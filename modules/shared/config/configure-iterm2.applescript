#!/usr/bin/env osascript

-- iTerm2 Declarative Configuration Script
-- This script configures iTerm2 programmatically using AppleScript

-- Check if iTerm2 is running, if not, we'll configure it when it starts
tell application "System Events"
	if not (exists process "iTerm2") then
		-- iTerm2 is not running, start it briefly to configure
		tell application "iTerm2"
			activate
			delay 1 -- Give iTerm2 time to start
		end tell
	end if
end tell

tell application "iTerm2"
	-- Create a new profile or modify default
	try
		set myProfile to (first profile whose name is "NixOS Profile")
	on error
		-- Create new profile if it doesn't exist
		set myProfile to (create profile with default settings)
		set name of myProfile to "NixOS Profile"
	end try
	
	-- Configure font settings
	tell myProfile
		set font family to "FiraCode Nerd Font"
		set font size to 14
		set use bold font to true
		set use italic font to true
		set horizontal spacing to 1.0
		set vertical spacing to 1.0
		
		-- Configure colors (dark theme)
		set background color to {0.1176, 0.1176, 0.1176, 1.0} -- Dark gray
		set foreground color to {0.8314, 0.8314, 0.8314, 1.0} -- Light gray
		set transparency to 0.05
		
		-- Configure cursor
		set cursor type to "Box"
		set blinking cursor to false
		
		-- Configure window
		set working directory to "/Users/junr03"
		
		-- Make this the default profile
		set default profile to "NixOS Profile"
	end tell
	
	-- Set iTerm2 to use the new profile as default
	set default profile to "NixOS Profile"
end tell

-- Only show notification if running interactively (not during system rebuild)
try
	display notification "iTerm2 configuration applied successfully!" with title "Nix iTerm2 Setup"
end try
