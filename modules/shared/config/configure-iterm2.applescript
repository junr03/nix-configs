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
        set myProfile to (first profile whose name is "Nix Profile")
	on error
		-- Create new profile if it doesn't exist
		set myProfile to (create profile with default settings)
        set name of myProfile to "Nix Profile"
	end try
	
	-- Configure font settings
	tell myProfile
		set font family to "FiraCode Nerd Font"
		set font size to 14
		set use bold font to true
		set use italic font to true
		set horizontal spacing to 1.0
		set vertical spacing to 1.0
		
		-- Configure colors (Gruvbox Dark theme)
		set background color to {0.157, 0.157, 0.157, 1.0} -- #282828 (bg0)
		set foreground color to {0.922, 0.859, 0.698, 1.0} -- #ebdbb2 (fg1)
		set transparency to 0.0
		
		-- Gruvbox ANSI colors
		set ansi 0 color to {0.157, 0.157, 0.157, 1.0}  -- #282828 (bg0)
		set ansi 1 color to {0.8, 0.141, 0.114, 1.0}    -- #cc241d (red)
		set ansi 2 color to {0.596, 0.592, 0.102, 1.0}  -- #98971a (green)
		set ansi 3 color to {0.843, 0.6, 0.129, 1.0}    -- #d79921 (yellow)
		set ansi 4 color to {0.271, 0.522, 0.533, 1.0}  -- #458588 (blue)
		set ansi 5 color to {0.694, 0.384, 0.525, 1.0}  -- #b16286 (purple)
		set ansi 6 color to {0.408, 0.616, 0.416, 1.0}  -- #689d6a (aqua)
		set ansi 7 color to {0.658, 0.6, 0.478, 1.0}    -- #a89984 (fg4)
		set ansi 8 color to {0.572, 0.514, 0.365, 1.0}  -- #928374 (gray)
		set ansi 9 color to {0.984, 0.286, 0.204, 1.0}  -- #fb4934 (bright red)
		set ansi 10 color to {0.721, 0.733, 0.149, 1.0} -- #b8bb26 (bright green)
		set ansi 11 color to {0.98, 0.741, 0.184, 1.0}  -- #fabd2f (bright yellow)
		set ansi 12 color to {0.514, 0.647, 0.596, 1.0} -- #83a598 (bright blue)
		set ansi 13 color to {0.827, 0.525, 0.608, 1.0} -- #d3869b (bright purple)
		set ansi 14 color to {0.553, 0.752, 0.486, 1.0} -- #8ec07c (bright aqua)
		set ansi 15 color to {0.922, 0.859, 0.698, 1.0} -- #ebdbb2 (fg1)
		
		-- Configure cursor
		set cursor type to "Box"
		set blinking cursor to false
		
		-- Configure window
		set working directory to "/Users/junr03"
		
		-- Make this the default profile
                set default profile to "Nix Profile"
	end tell
	
	-- Set iTerm2 to use the new profile as default
        set default profile to "Nix Profile"
end tell

-- Only show notification if running interactively (not during system rebuild)
try
	display notification "iTerm2 configuration applied successfully!" with title "Nix iTerm2 Setup"
end try
