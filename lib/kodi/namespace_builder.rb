module Kodi
  class NamespaceBuilder < Struct.new(:uri)
    # Generates a hash of Namespaces by name for a particular URI
    #
    # Params
    # +method_groups+ (optional)::  A Hash where the key is the name of the created namespace and the value is an Array
    #                               of the desired methods. A valid hash could be:
    #                               {
    #                                 'AudioLibrary' => ['GetArtists'],
    #                                 'Input' => ['Up', 'Down', 'Left', 'Right', 'Select', 'Back'],
    #                                 'Player' => ['GetActivePlayers', 'PlayPause']
    #                               }
    #                               If left empty, the complete API will be requested from the server. This will cost an
    #                               extra second or two, but ensures that you have all methods available.
    def build_namespaces(method_groups = nil)
      namespaces = (method_groups || api_method_groups).map do |name, methods|
        Namespace.new(uri, name, *methods)
      end

      namespaces.index_by(&:name)
    end

    private

    def api_method_groups
      api_methods.group_by(&:namespace)
    end

    def api_methods
      api_introspect['methods'].keys.map do |path|
        Struct.new(:namespace, :name).new(*path.split('.', 2))
      end
    end

    def api_introspect
      @api_introspect ||= RPC.new(uri).dispatch('JSONRPC.Introspect')
    end
  end
end
