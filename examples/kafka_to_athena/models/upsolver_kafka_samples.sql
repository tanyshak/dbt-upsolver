{{ config(
            materialized='connection',
            connection_type="KAFKA"
        )
}}

HOSTS = ('pkc-2396y.us-east-1.aws.confluent.cloud:9092')
CONSUMER_PROPERTIES = '
    bootstrap.servers=pkc-2396y.us-east-1.aws.confluent.cloud:9092
    security.protocol=SASL_SSL
    sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule   required username="6OIULZJH26XNMEOX"   password="1KLfnOtufgTzUBwHseN0q9RR3sf5jJfUYJ9ZaAH+K2mp4YFUk6jhYDfP9J378mvT";
    ssl.endpoint.identification.algorithm=https
    sasl.mechanism=PLAIN'
