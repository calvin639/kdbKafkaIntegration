from kafka import KafkaProducer
import json
import time

from data import create_sData


def json_serializer(data):
    return json.dumps(data).encode("utf-8")


producer = KafkaProducer(bootstrap_servers=['seoul4:9092'],
                         value_serializer=json_serializer)

if __name__ == '__main__':
    while 1 == 1:
        sData = create_sData()
        print(sData)
        producer.send("sensors", sData)
        time.sleep(5)
