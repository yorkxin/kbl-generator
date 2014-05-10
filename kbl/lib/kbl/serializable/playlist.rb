require 'nokogiri'

module KBL::Serializable
  module Playlist
    def to_kbl_node
      node = Nokogiri::XML.parse(<<-XML, nil, nil, Nokogiri::XML::ParseOptions::NOBLANKS)
        <playlist>
          <playlist_id>#{ self.id }</playlist_id>
          <playlist_name>#{ self.name }</playlist_name>
          <playlist_descr>#{ self.description }</playlist_descr>
          <playlist_data></playlist_data>
        </playlist>
      XML

      data_node = node.css("playlist_data").first

      @songs.each do |song|
        data_node << song.to_kbl_node
      end

      node.root
    end
  end
end
