set playlist_name to "El Psy Congroo"

tell application "KKBOX" to activate

tell application "System Events"
	tell application process "KKBOX"
		tell window "KKBOX"
			set sidebar_list to outline 1 of scroll area 1 of splitter group 1 of splitter group 1
			
			set target_playlist to first row of sidebar_list where value of text field 1 is playlist_name
			
			set sidebar_list to outline 1 of scroll area 1 of splitter group 1 of splitter group 1
			
			tell sidebar_list to select target_playlist
		end tell
		
		delay 1
		
		tell menu "File" of menu bar item "File" of menu bar 1
			click menu item "Export Playlist"
		end tell
		
		tell window "Export Playlist"
			keystroke "g" using {shift down, command down}
			
			tell first sheet
				set value of first text field to directory
				click button "Go"
			end tell
			
			tell value of first text field to playlist_name
			
			click button "Export"
		end tell
	end tell
end tell
