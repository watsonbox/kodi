module Kodi
  class Client
    attr_reader :uri, :namespaces

    def initialize(uri)
      @uri = URI.parse(uri)
      @namespaces = build_namespaces
    end

    def method_missing(method_name, *arguments, &block)
      find_namespace(method_name) || super
    end

    private

    def find_namespace(name)
      namespaces[name.to_s.camelize]
    end

    def build_namespaces
      {
        'Input' => Namespace.new(self, 'Input', 'Up')
      }
    end
  end
end
