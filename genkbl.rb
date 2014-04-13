# Simple KKBOX Playlist Generator
#
# ## Usage:
#
# 1. prepare `ids.txt` and put all the ids in that file.
# 2. run:
#
#      cat ids.txt | ruby genkbl.rb > playlist.kbl
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

class Renderer
  def initialize(ids, now)
    @ids = ids
    @now = now

    @erb = ERB.new(File.read("kbl_template.erb"))
  end

  def render
    @erb.result(binding)
  end
end

kkbox_ids = STDIN.readlines
kkbox_ids.each(&:chomp!).delete("")

renderer = Renderer.new(kkbox_ids, Time.now)

puts renderer.render
