set playlist_name to "El Psy Congroo"

on cliclick(x, y)
	do shell script "/usr/local/bin/cliclick " & "c:" & x & "," & y
end cliclick

on cliclick_right(x, y)
	do shell script "/usr/local/bin/cliclick " & "c:" & x & "," & y & " kd:ctrl"
end cliclick_right

tell application "KKBOX" to activate

tell application "System Events"
	tell application process "KKBOX"
		tell window "KKBOX"
			set pause_button to first button where title is "Play"
			
			# First, clear the temporary playlist
			set sidebar_list to outline 1 of scroll area 1 of splitter group 1 of splitter group 1
			
			set temporary_pl to row 2 of sidebar_list
			
			tell sidebar_list to select temporary_pl
			
			set playlist_table to table 1 of scroll area 1 of splitter group 2 of splitter group 1
			
			set existing_rows to rows of playlist_table
			
		end tell
		
		
		tell menu of menu bar item "File" of menu bar 1
			set export_playlist_menu_item to first menu item where title is "Export Playlist"
		end tell
		
		if length of existing_rows > 0 then
			set focused of playlist_table to true
			
			tell menu 1 of menu bar item "Edit" of menu bar 1
				click menu item "Select All"
				click menu item "Delete"
			end tell
			
			delay 1
			
			keystroke return
			# click button "Delete" of window
		end if
		
		delay 1
		
		# Then add songs to it
		do shell script "open kkbox://play_song_20706554 kkbox://play_song_20706569 kkbox://play_song_20706581"
		
		# wait for a moment			
		delay 1
		
		# pause playing
		if description of pause_button is "Pause" then
			click pause_button
		end if
		
		# Now select the first entry
		tell playlist_table
			set focused to true
			set r to select row 1
			
			set more_button to last text field of r
			
			set base_pos to position of more_button
			set button_size to size of more_button
			
			set pos to {x:(item 1 of base_pos) + (item 1 of button_size) / 2 as integer, y:(item 2 of base_pos) + (item 2 of button_size) / 2 as integer}
			
			delay 1
			my cliclick(x of pos, y of pos)
			
		end tell
		
		# I couldn't find the menu so here is the simulation:
		# press key "a" to find "Add to Playlist" item, and 
		# press return to trigger it.
		delay 1
		
		keystroke "a"
		keystroke return
		
		tell window "Add to Playlist"
			click button "Select All" of group 1
			tell text field 1 of group 2
				set focused to true
				set value to playlist_name
			end tell
			
			tell (checkbox 1 where title is "Download as Offline Songs")
				if value is 1 then
					click
				end if
			end tell
			
			click button "OK"
		end tell
		
	end tell
end tell

