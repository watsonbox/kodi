require 'net/http'
require 'uri'
require 'json'

module Kodi
  class RPC
    def initialize(uri)
      @uri = uri
    end

    def dispatch(name, args = {})
      post_body = { 'method' => name, 'params' => args, 'jsonrpc' => '2.0', 'id' => '1' }.to_json
      resp = JSON.parse( http_post_request(post_body) )
      raise JSONRPCError, resp['error'] if resp['error']
      resp['result']
    end

    class JSONRPCError < RuntimeError; end

    private

    def http_post_request(post_body)
      http = Net::HTTP.new(@uri.host, @uri.port)
      request = Net::HTTP::Post.new(@uri.request_uri)
      request.basic_auth @uri.user, @uri.password
      request.content_type = 'application/json'
      request.body = post_body
      http.request(request).body
    end
  end
end
