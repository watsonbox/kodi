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

    private

    def find_method(name)
      @methods.find { |m| m == name.to_s.camelize }
    end
  end
end
