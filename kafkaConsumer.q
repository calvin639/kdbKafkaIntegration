//Load in OG kafka instructions
//TODO Replace pub and log functions with your own pub and log functions

\l kfk.q

// Define schemas
sensorData:([]time:`timestamp$();updateTS:`timestamp$();sensor:`symbol$();reading:`float$();lLimit:`float$();uLimit:`float$());
masterData:([sensor:`symbol$()]lLimit:`float$();uLimit:`float$());

//Open connection to client
client:.kfk.Consumer[`metadata.broker.list`group.id!`seoul4:9092`0];
if[0=client;client:.kfk.Consumer[`metadata.broker.list`group.id!`seoul4:9092`0]];
if[0>=client;.log.warn[.z.h;"No connection opened to client";()]];

.kc.sd:{[msg]
    .log.out[.z.h;"New sensor data arrived";()];
    .dbg.sd:msg;
    data:.j.k "c"$msg[`data];
    data[`time]:msg`msgtime;
    data[`updateTS]:.z.P;
    data: update sensor:`$sensor from enlist data; //If sending multiple values need to ungroup
    data:sensorData upsert data lj masterData; 
    .dm.pub[`sensorData;data];
    .kc.pubMetrics[count data];
    .log.debug[.z.h;"Published sensorData";()];
    };

.kc.md:{[msg]
     if[(`$"_PARTITION_EOF")=msg`mtype;:()];
    .log.out[.z.h;"New master data arrived";()];
    .dbg.md:msg;
    data:"SFF"$":"vs "c"$.dbg.md`data;
    data:masterData upsert `sensor`lLimit`uLimit!data;
    `masterData upsert data;
    .dm.pub[`masterData;0!data]; //Using DC publishing r- replace with your pub func
    .log.out[.z.h;"Master data published";()];
    };

//Seet default master data
`masterData upsert flip `sensor`lLimit`uLimit!flip `voltage`temp`pressure`spice,'(1.1 1.4;31 39f;.05 .66;1 2.5);



// Sub to sensor topic
// Topics to subscribe to
topic1:`sensorData;
topic2:`masterData;

.log.out[.z.h;"Subscribing to sensor data";()];
.kfk.Subscribe[client;topic1;enlist .kfk.PARTITION_UA;.kc.sd];
.log.out[.z.h;"Subscribing to master data";()];
.kfk.Subscribe[client;topic2;enlist .kfk.PARTITION_UA;.kc.md];

//For performance tests
metrics:([]time:`s#`timestamp$();cnt:`long$())
metrics upsert enlist(.z.P;5)
.kc.pubMetrics:{[c]
   `metrics upsert enlist(.z.P;c)
    }

getMetrics:{
    c:select count i from metrics where time>.z.P-0D00:00:10;
    .log.out[`METRICS;("Current readings/second");value first c%10];
    }