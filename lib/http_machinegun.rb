require "thor"
#require "pry"
#require 'benchmark'
require 'parallel'
require "http_machinegun/data"
require "http_machinegun/client"
require "http_machinegun/version"

# 引数　url port threadcount data
module HttpMachinegun

  class Machinegun < Thor
    desc "fire", "send data A number of specified thread "
    method_option :url , :type => :string, :required => true, :aliases => "-u"
    method_option :port, :type => :numeric, :aliases => "-p"
    method_option :data_or_file_path, :type => :string, :default => "", :aliases => "-d"
    method_option :method, :type => :string, :default => "get", :aliases => "-m"
    method_option :thread_number , :type => :numeric, :default => 1, :aliases => "-t"

    ##
    #
    def fire
      data = Data.new(options[:data_or_file_path])
      client = Client.new(options[:url], options[:port], data)
      client.http_method(options[:method])
      client.set_body

      clients = Array.new( options[:thread_number] , client)
      results = Parallel.each(clients, :in_threads => Parallel.processor_count) {|url|
        res = client.execute
        if res.code =~ /^[^2]..$/
         say("http_status_code:" + res.code, :red)
        else
         say("http_status_code:" + res.code, :green)
        end

        res
      }

      results

    end
  end
end
