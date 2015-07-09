logstash-input-nsq
====================

NSQ input for Logstash. This input will consume messages from a nsq topic using nsq-ruby. 

For more information about NSQ, refer to this [documentation](http://nsq.io) 

Logstash Configuration
====================

    input {
       nsq {
            nsqlookupd => "127.0.0.1:4161"
            topic => "testtopic"
            channel => "testchannel"
       }
    }

Dependencies
====================

* nsq-ruby
