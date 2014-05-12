module KBL
  class Package
    include KBL::Serializable

    attr_reader :kkbox_version, :version, :description, :date, :playlists

    def initialize(&block)
      @date = Time.now
      @playlists = []
      @kkbox_version = "04000016"

      block.call(self) if block_given?
    end

    def add_playlist(&block)
      playlist = Playlist.new
      playlist.id = @playlists.size + 1
      block.call(playlist)

      @playlists << playlist
    end

    def total_songs
      @playlists.map { |playlist| playlist.songs.size }.reduce(:+)
    end
  end
end
