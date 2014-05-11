require 'thor'
require 'readline'

module KBL
  class CLI < Thor
    desc "import [FILENAME]", "Import KKBOX Songs from a list of IDs through [FILENAME] or STDIN."
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
      if filename
        begin
          input = File.open(filename)
        rescue Errno::ENOENT => e
          puts "Cannot Open File: #{filename}"
          exit 1
        end
      else
        input = STDIN
      end

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
  end
end
