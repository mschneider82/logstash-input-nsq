require 'logstash/namespace'
require 'logstash/inputs/base'
require 'nsq'

class LogStash::Inputs::Nsq < LogStash::Inputs::Base
  config_name 'nsq'

  default :codec, 'json'

  config :nsqlookupd, :validate => :array, :default => 'localhost:4161'
  config :channel, :validate => :string, :default => 'logstash'
  config :topic, :validate => :string, :default => 'testtopic'
  config :max_in_flight, :validate => :number, :default => 100
  config :tls_v1, :validate => :boolean, :default => false
  config :tls_key, :validate => :string
  config :tls_cert, :validate => :string

  public
  def register
    @logger.info('Registering nsq', :channel => @channel, :topic => @topic, :nsqlookupd => @nsqlookupd)
    if @tls_key and @tls_cert
      @consumer = Nsq::Consumer.new(
       :nsqlookupd => @nsqlookupd,
       :topic => @topic,
       :channel => @channel,
       :max_in_flight => @max_in_flight,
       :tls_v1 => @tls_v1,
       :tls_context => {
        key: @tls_key,
        certificate: @tls_cert
       }
      )
    else
      @consumer = Nsq::Consumer.new(
       :nsqlookupd => @nsqlookupd,
       :topic => @topic,
       :channel => @channel,
       :tls_v1 => @tls_v1,
       :max_in_flight => @max_in_flight
      )
    end
  end # def register

  public
  def run(logstash_queue)
    @logger.info('Running nsq', :channel => @channel, :topic => @topic, :nsqlookupd => @nsqlookupd)
    begin
       while !stop?
          #@logger.info('consuming...')
          event = @consumer.pop
          #@logger.info('processing:', :event => event)
          queue_event(event.body, logstash_queue)
	      event.finish
       end
       @logger.warn('Done running nsq input')
    end
  end # def run

  private
  def queue_event(body, output_queue)
    begin
        #@logger.info('processing:', :body => body)
	    event = LogStash::Event.new("message" => body)  
	    decorate(event)
    	output_queue << event
        rescue => e # parse or event creation error
           @logger.error('Failed to create event', :message => "#{body}", :exception => e,
                    :backtrace => e.backtrace)
    end # begin
  end # def queue_event

  public
  def stop
    @logger.warn('nsq got stop signal. terminate')
    @consumer.terminate
  end #stop

end #class LogStash::Inputs::Nsq
