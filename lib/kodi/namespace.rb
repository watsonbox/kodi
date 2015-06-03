module Kodi
  class Namespace
    attr_reader :uri, :name

    def initialize(uri, name, *methods)
      @uri = uri
      @name = name
      @methods = methods
    end

    def method_missing(method_name, *arguments, &block)
      if method = find_method(method_name)
        RPC.new(uri).dispatch(name + '.' + method, *arguments)
      else
        super
      end
    end

    def self.generate_namespaces(uri)
      namespaces = Hash.new
      api = RPC.new(uri).dispatch('JSONRPC.Introspect')
      api['methods'].keys.each do |method|
        parts = method.split('.')
        if namespaces.has_key?(parts[0])
          namespaces[parts[0]].append(parts[1])
        else
          namespaces[parts[0]] = [parts[1]]
        end
      end
      namespaces.each { |name, methods| namespaces[name] = self.new(uri, name, *methods) }
    end

    private

    def find_method(name)
      @methods.find { |m| m == name.to_s.camelize }
    end
  end
end
