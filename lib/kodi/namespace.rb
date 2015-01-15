module Kodi
  class Namespace
    attr_reader :client, :name

    def initialize(client, name, *methods)
      @client = client
      @name = name
      @methods = methods
    end

    def method_missing(method_name, *arguments, &block)
      if method = find_method(method_name)
        RPC.new(client.uri).dispatch(name + '.' + method)
      else
        super
      end
    end

    private

    def find_method(name)
      @methods.find { |m| m == name.to_s.camelize }
    end
  end
end
