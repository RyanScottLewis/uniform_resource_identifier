class UniformResourceIdentifier
  module Parser
    STRICT = /^(?:([^:\/?#]+):)?(?:\/\/((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?))?((((?:[^?#\/]*\/)*)([^?#]*))(?:\?([^#]*))?(?:#(.*))?)/
    LOOSE  = /^(?:(?![^:@]+:[^:@\/]*@)([^:\/?#.]+):)?(?:\/\/)?((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?)(((\/(?:[^?#](?![^?#\/]*\.[^?#\/.]+(?:[?#]|$)))*\/?)?([^?#\/]*))(?:\?([^#]*))?(?:#(.*))?)/
    
    # Simply returns a Hash containing the captures
    # mode can either be :strict or :loose
    def self.parse(uri, mode=:loose)
      raise(ArgumentError, "mode must either be :loose or :strict") unless [:loose, :strict].include?(mode)
      
      regexp = mode == :loose ? LOOSE : STRICT
      match  = uri.match(regexp)
      keys   = [:protocol, :authority, :user_info, :username, :password, :host,
                :port, :relative, :path, :directory, :file, :query, :anchor]
      
      keys.each.with_index.inject({}) do |memo, (key, index)|
        memo[key] = match.captures[index]
        memo
      end
    end
  end
end