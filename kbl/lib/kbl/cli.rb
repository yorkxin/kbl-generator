require 'thor'
require 'readline'
require 'sqlite3'
require 'csv'

module KBL
  class CLI < Thor
    class MetaData < Struct.new(:song_id, :song_name, :artist_id, :artist_name, :album_id, :album_name)
      def to_a
        [
          self.song_id,
          self.song_name,
          self.artist_id,
          self.artist_name,
          self.album_id,
          self.album_name
        ]
      end

      def to_tsv
        to_a.join "\t"
      end
    end

    desc "import [INPUT_FILE or STDIN]", "Import KKBOX Songs from a list of IDs through [FILENAME] or STDIN."
    long_desc <<-EOS
      Given a list of KKBOX Song IDs (pathname), import them to your KKBOX client's
      Temporary Playlist, by brute-forcely `open`ing a bunch of
      `kkbox://play_song_xxxx` URLs.

      This will affect your current Temporary Playlist and make "now playing"
      song to the last song in the list.
    EOS

    option :yes, :type => :boolean, :default => false, :aliases => :y,
                 :desc => "Skip warning for overriding KKBOX now playing."

    def import(filename=nil)
      input = open_file(filename) || STDIN

      ids = input.readlines
      ids.each(&:chomp!).keep_if {|id| id.match(/\d+/) }#.delete("")

      if ids.empty?
        puts "No songs to import. Exit."
        exit 2
      end

      if !options[:yes]
        puts "\e[1;31mThis will import #{ids.size} songs into KKBOX and play the last song.\e[m"

        while answer = Readline.readline("Continue? [Y/n] ", false)
          case answer.downcase
          when 'n', 'no'
            puts "Cancelled."
            exit 3
          when 'y', 'yes', ''
            break # stop asking and continue importing
          else
            puts "Please answer 'y' or 'n', or hit enter for 'y'."
          end
        end
      end

      puts "Importing..."

      system "open #{ids.map { |id| "kkbox://play_song_#{id}" }.join(' ')}"
    end

    desc "dump [INPUT_FILE or STDIN] [-o=OUTPUT_FILE or STDOUT] [-f=tsv]",
         "Dump meta data of KKBOX songs from your local KKBOX client database."
    long_desc <<-EOS
      Given a list of KKBOX Song IDs (pathname), find their meta data from your
      KKBOX client's local database, and if found, export them to the file
      set in --output option, or the STDOUT stream if not given.

      If you have multiple accounts logged in to KKBOX client,
      it will look into all of them.

      The output contains the following fields:

      name: Song Title

      pathname: Song ID

      artist: Artist Name

      artist_id: Artist ID

      album: Album Name

      album_id: Album ID

      For tabular format like TSV and CSV, these columns will be printed
      in the above order.
    EOS

    option :format, :type => :string, :default => "tsv", :aliases => :f,
            :desc => "Format of output data.",
            :banner => "tsv"

    option :output, :type => :string, :default => nil, :aliases => :o,
            :desc => "The output file to write. Uses STDOUT if absent.",
            :banner => "OUTPUT_FILE"

    def dump(input_filename=nil)
      input = open_file(input_filename) || STDIN

      if output_filename = options[:output]
        output = open_file(output_filename, 'w')
        if output.nil?
          puts "Cannot open file #{output_filename} for output."
          exit 1
        end
      else
        output = STDOUT
      end

      ids = input.readlines
      ids.each(&:chomp!).keep_if {|id| id.match(/\d+/) }#.delete("")

      if ids.empty?
        puts "No songs to export. Exit."
        exit 2
      end

      meta_data = {}

      db_files = Dir.glob(File.expand_path("~/Library/Application Support/KKBOX/*/Playlists2.db"))

      db_files.each do |db_file|
        db = SQLite3::Database.new db_file

        sql = <<-SQL
          SELECT song_id, song_name, artist_id, artist_name, album_id, album_name
          FROM song_tracks
          WHERE song_id IN (#{ids.map {|id|"'#{id}'"}.join(',')});
        SQL

        db.execute(sql) do |row|
          data = MetaData.new(*row)

          meta_data[data.song_id] = data
        end
      end

      ids.each do |id|
        if data = meta_data[id]
          output.puts data.send(:"to_#{options[:format]}")
        else
          STDERR.puts "ID Not Found: #{id}"
        end
      end
    end

    private
    def open_file(filename, mode='r')
      if filename
        begin
          input = File.open(filename, mode)
        rescue Errno::ENOENT => e
          puts "Cannot Open File #{filename} in #{mode} mode"
          exit 1
        end
      else
        nil
      end
    end
  end
end
