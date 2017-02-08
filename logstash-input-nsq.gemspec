Gem::Specification.new do |s|

  s.name            = 'logstash-input-nsq'
  s.version         = '2.0.2'
  s.licenses        = ['Apache License (2.0)']
  s.summary         = 'This input will read events from a nsq topic.'
  s.description     = "This gem is a logstash plugin required to be installed on top of the Logstash core pipeline using $LS_HOME/bin/plugin install gemname. This gem is not a stand-alone program"
  s.authors         = ['Matthias Schneider']
  s.email           = 'ms@wck.biz'
  s.homepage        = "https://github.com/mschneider82/logstash-input-nsq"
  s.require_paths = ["lib"]

  # Files
  s.files = `git ls-files`.split($\)
  # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { 'logstash_plugin' => 'true', 'group' => 'input'}

  # Gem dependencies
  s.add_runtime_dependency "logstash-core", ">= 2.0.0", "< 7.0.0"
  s.add_runtime_dependency 'logstash-codec-json'
  s.add_runtime_dependency 'logstash-codec-plain'

  s.add_runtime_dependency 'nsq-ruby', ">= 2.0.0"

  s.add_development_dependency 'logstash-devutils'
end

