# Logstash Plugin

This is a plugin for [Logstash](https://www.elastic.co/products/logstash).

It is fully free and fully open source. The license is Apache 2.0, meaning you are pretty much free to use it however you want in whatever way.

At my work for [retarus GmbH](https://www.retarus.com) I really missed the NSQ support in logstash thats why i created this project in the after hours.
There is also a [logstash output nsq plugin](https://github.com/mschneider82/logstash-output-nsq) available.

logstash-input-nsq
====================

NSQ input for Logstash. This input will consume messages from a nsq topic using [nsq-ruby](https://github.com/wistia/nsq-ruby/). 

For more information about NSQ, refer to this [documentation](http://nsq.io) 

Installation
====================

    /opt/logstash/bin/logstash-plugin install logstash-input-nsq

Recommendation
====================

This consumer plugin uses `#pop` which is blocking. In case of a graceful shutdown it may can get unresponsive if there are no messages on the queue.
To mitigate this add `KILL_ON_STOP_TIMEOUT=1` to your `/etc/default/logstash` file.

Logstash Configuration
====================

    input {
       nsq {
            nsqlookupd => ["127.0.0.1:4161","192.0.2.1:4161"]
            topic => "topicname"
            channel => "channelname"
            max_in_flight  => 200
       }
    }


Logstash Configuration with TLS
====================

    input {
       nsq {
            nsqlookupd => ["127.0.0.1:4161","192.0.2.1:4161"]
            topic => "topicname"
            channel => "channelname"
            max_in_flight  => 200
            tls_v1 => true
       }
    }


Logstash Configuration with TLS Auth
====================

    input {
       nsq {
            nsqlookupd => ["127.0.0.1:4161","192.0.2.1:4161"]
            topic => "topicname"
            channel => "channelname"
            max_in_flight  => 200
            tls_v1 => true
            tls_key => "/path/to/private.key"
            tls_cert => "/path/to/public.pem"
       }
    }

Dependencies
====================

Dependencies are auto installed by logstash-plugin

* [nsq-ruby](https://github.com/wistia/nsq-ruby/)

