FROM docker.elastic.co/logstash/logstash-oss:6.0.0
RUN /usr/share/logstash/bin/logstash-plugin install logstash-input-nsq
COPY logstash.conf /usr/share/logstash/pipeline/logstash.conf
