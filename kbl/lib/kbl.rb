require "kbl/version"

module KBL
  autoload :Package,  "kbl/package"
  autoload :Playlist, "kbl/playlist"
  autoload :Song,     "kbl/song"

  module Serializable
    autoload :Package,  "kbl/serializable/package"
    autoload :Playlist, "kbl/serializable/playlist"
    autoload :Song,     "kbl/serializable/song"
  end
end
