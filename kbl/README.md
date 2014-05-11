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
      song.name      = "君の知らない物語"
      song.pathname  = "3665602"
      song.artist    = "Supercell"
      song.artist_id = "197227"
      song.album     = "Today Is A Beautiful Day"
      song.album_id  = "314546"
    end
  end
end

puts kbl.to_kbl #=> the KBL source code (in XML)
```

### CLI Tool

This gem provides a CLI tool `kbl` that simplifies playlist importing / dumping via Song IDs (pathname).

Usage:

```txt
# Import KKBOX Songs from a list of IDs through [FILENAME] or STDIN.
kbl import [INPUT_FILE or STDIN]

# Dump meta data of KKBOX songs from your local KKBOX client database.
kbl dump [INPUT_FILE or STDIN] [-o=OUTPUT_FILE or STDOUT] [-f=tsv]
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

1. Fork it ( http://github.com/chitsaou/kbl-generator/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## TODO

* Make a CLI tool for generating KBL files.
* Scraping meta data from KKBOX client database from given Song IDs.
* A workflow for how to build a KBL file from Song IDs.

## License

The MIT License (MIT). See LICENSE.txt.
