# KKBOX Playlist Library (KBL) Generator

A simple gem to generate KKBOX Playlist Library (KBL) files.

:warning: **[WARNING]** This program is made by reverse-engineering the KBL files. It does not guarantee that the generated KBL files is fully-compatible with KKBOX client. Use it AT YOUR OWN RISK!.

## Installation

Add this line to your application's Gemfile:

    gem 'kbl'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kbl

## Usage

**Important**: Read **Required Song Meta Data** section before you start generating a KBL file.

```rb
kbl = KBL::Package.new do |package|
  package.add_playlist do |playlist|
    playlist.name = "Playlist A"
    playlist.description = "A Sample Playlist"

    playlist.add_song do |song|
      song.name     = ""
      song.pathname = entry.song_id
      song.artist   = entry.artist
      song.album    = entry.album_name
      song.album_id = entry.album_id
    end
  end
end

puts kbl.to_kbl #=> the KBL source code (in XML)
```

## Required Song Meta Data

To generate a working KBL file, the following data for every song must be provided.

* **pathname** - The Song ID
* **album_id** - The Album ID
* **artist_id** - The Artist ID

If there is only `pathname`, the User Interface will work in strange behavior, if these songs has never been played in your KKBOX client, or was removed from your KKBOX client library before.

Additionally, add these data to avoid blank name, album and artist names, when importing unknown songs to the KKBOX client:

* **name** - The name of that song.
* **album** - The album name.
* **artist** - The artist name.

## Glossary

### Package

A package of KBL.

Can contain multiple playlists, which will be imported as individual playlists when the KBL file is imported to KKBOX client.

### Playlist

A playlist entry containing one or more songs.

It is recommended to assign name for it so that when importing, it will be showed up in the playlists sidebar.

### Song

A song entry.

Can exist multiple times across multiple playlists.

## Contributing

1. Fork it ( http://github.com/<my-github-username>/kbl/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## TODO

* Make a CLI tool for generating KBL files.
* Scraping meta data from KKBOX client database from given Song IDs.
* A workflow for how to build a KBL file from Song IDs.

## License

The MIT License (MIT)

Copyright (c) 2014 Yu-Cheng Chuang

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
