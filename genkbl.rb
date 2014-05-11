# Simple KKBOX Playlist Generator
#
# ## Usage:
#
# 1. Prepare `input.tsv` which contains lines in this format:
#
#      Artist Name  Title   Album ID    Song ID
#
#    each column is separated by a single tab character (\t).
#
#    Example:
#
#      20706554\tKings (TV動畫「K」片頭曲)\t465209\tangela\t1962311\tZERO
#      20706569\t境界線Set me free (TV動畫「K」形象曲)\t465209\tangela\t1962311\tZERO
#      20706581\t曾幾何時從零開始 (TV動畫「K」形象曲)\t465209\tangela\t1962311\tZERO
#      20706584\t- Requiem of Red- (TV動畫「K」最終回插曲self cover)\t465209\tangela\t1962311\tZERO
#      20706587\tTo be with U! (TV動畫「K」最終回片尾主題曲)\t465209\tangela\t1962311\tZERO
#      20706572\tThe Lights Of Heroes (PSP遊戲軟體「英雄幻想曲」主題曲)\t465209\tangela\t1962311\tZERO
# 2. run:
#
#      ruby genkbl.rb < input.tsv > playlist.kbl
#
# 3. Open playlist.kbl
#
# ## License
# Licensed under the MIT License. See `LICENSE` file.
#
require 'kbl'

class KKBOXEntry < Struct.new(:song_id, :song_name, :artist_id, :artist_name, :album_id, :album_name)
end

input = STDIN.readlines
input.each(&:chomp!).delete("")

kbl = KBL::Package.new do |package|
  package.add_playlist do |playlist|
    # TODO: use command line args
    playlist.name = "Playlist 1"
    playlist.description = "A Sample Playlist"

    input.map do |line|
      playlist.add_song do |song|
        entry = KKBOXEntry.new(*line.split("\t"))

        song.name      = entry.song_name
        song.pathname  = entry.song_id
        song.artist    = entry.artist_name
        song.artist_id = entry.artist_id
        song.album     = entry.album_name
        song.album_id  = entry.album_id
      end
    end
  end
end

puts kbl.to_kbl
