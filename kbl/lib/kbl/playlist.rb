module KBL
  class Playlist
    include KBL::Serializable

    attr_reader :songs
    attr_accessor :name, :description, :id

    def initialize(&block)
      @songs = []

      block.call(self) if block_given?
    end

    def add_song(&block)
      song = Song.new
      block.call(song)

      @songs << song
    end
  end
end
