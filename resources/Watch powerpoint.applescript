tell application "Microsoft PowerPoint"
	set lastSlideNum to -1
	log lastSlideNum
	repeat
		set slideNum to current show position of slide show view of slide show window of active presentation
		if (slideNum is not missing value) then
			if (slideNum is not lastSlideNum) then
				set markerName to "Slide_" & (slideNum as string)
				set lastSlideNum to slideNum
				
				tell application "Sound Studio trial"
					if (is recording is true) then
						tell front document
							set markerTime to sample count
							make new marker with properties {position:markerTime, name:markerName}
						end tell
					end if
				end tell
				
			end if
		end if
		
		delay 0.1
	end repeat
end tell