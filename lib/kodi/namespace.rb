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

    # Generates an Array of Namespaces for a particular URI
    #
    # Params
    # +uri+::                       The URI of the Kodi JSON-RPC API server
    # +method_groups+ (optional)::  A Hash where the key is the name of the created namespace and the value is an Array
    #                               of the desired methods. A valid hash could be:
    #                               {
    #                                 'AudioLibrary' => ['GetArtists'],
    #                                 'Input' => ['Up', 'Down', 'Left', 'Right', 'Select', 'Back'],
    #                                 'Player' => ['GetActivePlayers', 'PlayPause']
    #                               }
    #                               If left empty, the complete API will be requested from the server. This will cost an
    #                               extra second or two, but ensures that you have all methods available.
    def self.generate_namespaces(uri, method_groups = nil)
      namespaces = method_groups || request_methods(uri)
      namespaces.each { |name, methods| namespaces[name] = self.new(uri, name, *methods) }
    end

    private

    def find_method(name)
      @methods.find { |m| m == name.to_s.camelize }
    end

    # Calls the JSONRPC.Introspect method and uses the result to create a hash
    # containing all methods that are available in the Kodi JSON-RPC API
    #
    # Params
    # +uri+:: The URI of the Kodi JSON-RPC API server
    def self.request_methods(uri)
      method_groups = Hash.new
      api = RPC.new(uri).dispatch('JSONRPC.Introspect')
      api['methods'].keys.each do |method|
        parts = method.split('.')
        if method_groups.has_key?(parts[0])
          method_groups[parts[0]].append(parts[1])
        else
          method_groups[parts[0]] = [parts[1]]
        end
      end
      method_groups
    end

  end
end
