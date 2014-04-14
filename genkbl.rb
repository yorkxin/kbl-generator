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
# ## License (MIT)
#
# Copyright (c) 2014 Yu-Cheng Chuang
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
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
