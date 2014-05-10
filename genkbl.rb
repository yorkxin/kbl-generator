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
#      angela\tKINGS\t465209\tZERO\t1962331\t20706554
#      angela\t境界線Set me free\t465209\tZERO\t1962331\t20706569
#      angela\tいつかのゼロから\t465209\tZERO\t1962331\t20706581
#
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

class KKBOXEntry < Struct.new(:artist, :title, :album_name, :album_id, :song_id)
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

        song.name     = entry.title
        song.pathname = entry.song_id
        song.artist   = entry.artist
        song.album    = entry.album_name
        song.album_id = entry.album_id
      end
    end
  end
end

puts kbl.to_kbl
