//Load in OG kafka instructions
//TODO Replace pub and log functions with your own pub and log functions


\l kfk.q

\d .kp

// specify kafka brokers to connect to and statistics settings.
kfk_cfg:`metadata.broker.list`statistics.interval.ms!`seoul4:9092`10000
// create producer with the config above
producer:.kfk.Producer[kfk_cfg]
// setup producer topic
topic:.kfk.Topic[producer;`kxData;()!()]
// publish function
pubData:{[data]
    .dbg.data:data;
    .kfk.Pub[.kp.topic;.kfk.PARTITION_UA;.j.j data;"data"];
    .log.out[.z.h;"Published data back to Kafka";count data];
    }