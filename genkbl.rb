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
require 'erb'

class KKBOXEntry < Struct.new(:artist, :title, :album_name, :album_id, :song_id)
end

class Renderer
  def initialize(entries, now)
    @entries = entries
    @now = now

    @erb = ERB.new(File.read("kbl_template.erb"))
  end

  def render
    @erb.result(binding)
  end
end

input = STDIN.readlines
input.each(&:chomp!).delete("")

kkbox_entries = input.map {|line|
  KKBOXEntry.new(*line.split("\t"))
}

renderer = Renderer.new(kkbox_entries, Time.now)

puts renderer.render
