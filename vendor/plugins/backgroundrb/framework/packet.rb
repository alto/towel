require "socket"
require "yaml"
require "forwardable"
require "bin_parser"

require "ostruct"
require "packet_guid"
require "class_helpers"
require "double_keyed_hash"
require File.dirname(__FILE__) + '/event'

require "periodic_event"
require "disconnect_error"
require "callback"

require "nbio"
require "pimp"
require "meta_pimp"
require "core"

require "packet_master"
require "connection"
require "worker"

# This file is just a runner of things and hence does basic initialization of thingies required for running
# the application.


PACKET_APP = File.expand_path'../' unless defined?(PACKET_APP)

module Packet
  VERSION='0.1.0'
end
