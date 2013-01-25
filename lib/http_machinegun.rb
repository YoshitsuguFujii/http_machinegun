require "http_machinegun/version"
require "thor"

# 引数　url port threadcount data
module HttpMachinegun
  class Machinegun < Thor
    desc "fire", "send data A number of specified thread "
    method_option :url , :type => :string, :required => true, :aliases => "-u"
    method_option :port, :type => :numeric, :default => 80
    method_option :data_or_file_path, :type => :string, :default => "", :aliases => "-d"
    def fire # コマンドはメソッドとして定義する
      say(options, :red)
    end
  end
end
