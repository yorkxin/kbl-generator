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

## CLI Tool

This gem provides a CLI tool `kbl` that simplifies playlist importing / dumping via Song IDs (pathname).

### Import

Import KKBOX Songs from a list of IDs in a file or STDIN.

**Important**: this will add songs to your Temporary Playlist and after running, your Now Playing will become the last song in the list.

```shell-session
$ kbl import [INPUT_FILE or STDIN]
```

Sample Input:

    17645049
    22021717
    38369455
    30772971
    30772977

Which maps to these songs:

| Song ID | Artist | Song Name | Album |
|---------|--------|-----------|-------|
| 17645049 | 日笠陽子 | 美しき残酷な世界 | 美しき残酷な世界 |
| 22021717 | 水樹奈々×T.M.Revolution | 革命デュアリズム | 革命デュアリズム |
| 38369455 | 喜多村英梨 | Birth | 証×明 -SHOMEI- |
| 30772971 | 藍井エイル | サンビカ | AUBE |
| 30772977 | 藍井エイル | シリウス | AUBE |

Result:

* The above songs will be added to the bottom of Temporary Playlist.
* Your Now Playing song will become シリウス by 藍井エイル from AUBE album.

### Dump

Dump meta data of KKBOX songs from your local KKBOX client database.

```shell-session
$ kbl dump [INPUT_FILE or STDIN] [-o=OUTPUT_FILE or STDOUT] [-f=tsv]
```

The default output format is TSV (Tab-Separated Values, the Tab version of CSV.)

For tabular output like TSV and CSV, the order of columns will be:

* Song ID (pathname)
* Song Name
* Artist ID
* Artist Name
* Album ID
* Album Name

Sample Input:

    17645049
    22021717
    38369455
    30772971
    30772977

Sample Output (TSV):

    17645049	美麗殘酷的世界 (「進擊的巨人」片尾曲)	945776	日笠陽子(Hikasa Yoko)	1685970	美麗殘酷的世界
    22021717	革命 Dualism	1176631	水樹奈奈 × T.M.Revolution	2084207	革命 Dualism (特別盤)
    38369455	Birth	830288	喜多村英梨 (Eri Kitamura)	3847501	証×明-SHOMEI-
    30772971	聖歌（動畫『雙斬少女KILL la KILL』插曲）	475589	藍井艾露 (Eir Aoi)	2828979	Aube初回限定盤
    30772977	天狼星（動畫『雙斬少女KILL la KILL』片頭曲）	475589	藍井艾露 (Eir Aoi)	2828979	Aube初回限定盤

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
