module KBL
  class Song
    include KBL::Serializable::Song

    attr_accessor :name, :artist, :album, :genre, :preference,
                :play_count, :pathname, :type, :has_lyrics,
                :artist_id, :album_id, :song_index
  end
end
