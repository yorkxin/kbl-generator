require 'nokogiri'

module KBL::Serializable
  module Song
    def to_kbl_node
      doc = Nokogiri::XML.parse(<<-XML, nil, nil, Nokogiri::XML::ParseOptions::NOBLANKS)
        <song_data>
          <song_name>#{ self.name }</song_name>
          <song_artist>#{ self.artist }</song_artist>
          <song_album>#{ self.album }</song_album>
          <song_genre>#{ self.genre }</song_genre>
          <song_preference>#{ self.preference }</song_preference>
          <song_playcnt>#{ self.play_count }</song_playcnt>
          <song_pathname>#{ self.pathname }</song_pathname>
          <song_type>#{ self.type }</song_type>
          <song_lyricsexist>#{ self.has_lyrics }</song_lyricsexist>
          <song_artist_id>#{ self.artist_id }</song_artist_id>
          <song_album_id>#{ self.album_id }</song_album_id>
          <song_song_idx>#{ self.song_index }</song_song_idx>
        </song_data>
      XML

      doc.root
    end
  end
end
