logstash-input-nsq Plugin
====================

This is a NSQ input plugin for Logstash. This plugin will consume messages from a nsq topic using [nsq-ruby](https://github.com/wistia/nsq-ruby/). 

At my work for [retarus GmbH](https://www.retarus.com) I really missed the NSQ support in logstash thats why i created this project in the after hours.
There is also a [logstash output nsq plugin](https://github.com/mschneider82/logstash-output-nsq) available.

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

Features
====================

* Discovery via nsqlookupd
* Automatic reconnection to nsqd
* Channels and Topics with `#ephemeral` suffix to prevent writing to disk
* TLS
* TLS Auth (not really tested)
* Multi Events: multi_events => true (default: false, this will split input messages by a `\n` into multiple events)
