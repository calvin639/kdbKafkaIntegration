import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerRecord;

import java.util.Properties;


public class SampleProducer {
    public SampleProducer(){

        Properties properties = new Properties();
        properties.put("bootstrap.servers", "seoul4:9092");
        properties.put("key.serializer", "org.apache.kafka.common.serialization.StringSerializer");
        properties.put("value.serializer", "org.apache.kafka.common.serialization.StringSerializer");

        KafkaProducer kafkaProducer = new KafkaProducer(properties);
        ProducerRecord producerRecord1 = new ProducerRecord("sensors", "masterData", "temp:32:40");
        ProducerRecord producerRecord2 = new ProducerRecord("sensors", "masterData", "pressure:0.01:0.99");


        kafkaProducer.send(producerRecord1);
        kafkaProducer.send(producerRecord2);
        kafkaProducer.close();

    }
}
