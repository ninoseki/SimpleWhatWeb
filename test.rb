require "http"
require 'digest/md5'

require_relative "./plugin"
require_relative "./plugins/zte-iad"


module Test
  refine HTTP::Response do
    def md5sum
      Digest::MD5.hexdigest(body)
    end
  end
end

using Test

p Plugin.registered_plugins