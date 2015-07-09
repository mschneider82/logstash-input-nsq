require 'logstash/namespace'
require 'logstash/inputs/base'
require 'nsq'

class LogStash::Inputs::Nsq < LogStash::Inputs::Base
  config_name 'nsq'

  default :codec, 'json'

  config :nsqlookupd, :validate => :string, :default => 'localhost:4161'
  config :channel, :validate => :string, :default => 'logstash'
  config :topic, :validate => :string, :default => 'testtopic'


  public
  def register
   @logger.info('Registering nsq', :channel => @channel, :topic => @topic, :nsqlookupd => @nsqlookupd)
  end # def register

  public
  def run(logstash_queue)
    @logger.info('Running nsq', :channel => @channel, :topic => @topic, :nsqlookupd => @nsqlookupd)
    begin
      begin
        consumer = Nsq::Consumer.new(
           :nsqlookupd => @nsqlookupd,
           :topic => @topic,
           :channel => @channel
        )
        while true
          #@logger.info('consuming...')
          event = consumer.pop
          #@logger.info('processing:', :event => event)
          queue_event(event.body, logstash_queue)
	  event.finish
        end
      rescue LogStash::ShutdownSignal
        @logger.info('nsq got shutdown signal')
      end
      @logger.info('Done running nsq input')
    rescue => e
      @logger.warn('client threw exception, restarting',
                   :exception => e)
      retry
    end
    finished
  end # def run

  private
  def queue_event(body, output_queue)
    begin
        #@logger.info('processing:', :body => body)
	event = LogStash::Event.new("message" => body, "host" => @host)  
	decorate(event)
	output_queue << event
    rescue => e # parse or event creation error
      @logger.error('Failed to create event', :message => "#{body}", :exception => e,
                    :backtrace => e.backtrace)
    end # begin
  end # def queue_event

end #class LogStash::Inputs::Nsq
