# Changelog

## 0.2.0

* Improved CLI tool usage documents and caveats.
* KBL files are rendered by HAML templates. Deprecated Nokogiri. Reason:
  * Nokogiri as a XML parser, escapes HTML entities.
  * However KBL files does not escape HTML entities.
  * When a song is imported to your KKBOX client and that song has no cache in your local KKBOX database, the KKBOX client will take song name, artist name and album name from KBL files, making it strange to people.
  * HAML renderer does not escape HTML entities, therefore we use it instead of a powerful and general XML processor.
* `#to_kbl` is deprecated. Use `#to_xml` now.
* All templates are located at `lib/templates/*.haml`.

## 0.1.0

* Introduces `kbl` command line tool.
* `kbl import` to blute-forcely import KKBOX Songs via Command Line `open` command.
* `kbl dump` to dump KKBOX Song Meta Data from your KKBOX local database.
* Switch to Nokogiri in order to unify serialization endpoints across Package, Playlist and Song classes.

## 0.0.1 :birthday:

* Basic KBL DSL in Ruby.
