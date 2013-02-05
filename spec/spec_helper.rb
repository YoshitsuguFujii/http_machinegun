# encoding: utf-8
require 'rubygems'
require 'http_machinegun'
require 'webmock/rspec'
require 'stringio'

# Set shell to basic
$0 = "thor"
$thor_runner = true
ARGV.clear
Thor::Base.shell = Thor::Shell::Basic

RSpec.configure do |config|
  # Captures the output for analysis later
  #
  # @example Capture `$stderr`
  #
  #     output = capture(:stderr) { $stderr.puts "this is captured" }
  #
  # @param [Symbol] stream `:stdout` or `:stderr`
  # @yield The block to capture stdout/stderr for.
  # @return [String] The contents of $stdout or $stderr
  def capture(stream)
    begin
      stream = stream.to_s
      eval "$#{stream} = StringIO.new"
      yield
      result = eval("$#{stream}").string
    ensure
      eval("$#{stream} = #{stream.upcase}")
    end

    result
  end

  alias :silence :capture
end
