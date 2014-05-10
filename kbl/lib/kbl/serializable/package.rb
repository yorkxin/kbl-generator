module KBL::Serializable
  module Package
    def to_kbl
      to_kbl_node.to_xml({
        :encoding => 'UTF-8',
        :indent => 2,
        :indent_text => " "
      }).gsub(/<(.+)\/>/, '<\1></\1>')
    end

    def to_kbl_node
      doc = Nokogiri::XML.parse(<<-XML, nil, nil, Nokogiri::XML::ParseOptions::NOBLANKS)
        <utf-8_data><kkbox_package></kkbox_package></utf-8_data>
      XML

      package_node = doc.css("kkbox_package").first

      package_node << "<kkbox_ver>#{self.kkbox_version}</kkbox_ver>"

      @playlists.each do |playlist|
        package_node << playlist.to_kbl_node
      end

      package_node << Nokogiri::XML.parse(<<-XML, nil, nil, Nokogiri::XML::ParseOptions::NOBLANKS).root
        <package>
          <ver>1.0</ver>
          <descr>包裝說明</descr>
          <packdate>#{ self.date.strftime("%Y%m%d%H%M%S") }</packdate>
          <playlistcnt>#{ self.playlists.size }</playlistcnt>
          <songcnt>#{ self.total_songs }</songcnt>
        </package>
      XML

      doc.root
    end
  end
end
