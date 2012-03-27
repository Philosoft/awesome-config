-- {{{ Variable definitions
home = os.getenv("HOME")
configdir = home .. "/.config/awesome/"
iconsdir = configdir .. "/icons/"

theme = configdir .. "/zenburn/theme.lua"
terminal = "urxvt"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
browser = "firefox"

-- Default modkey.
modkey = "Mod4"
modkeyalt = "Mod1"
modkeyctrl = "Mod2"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
	awful.layout.suit.floating,
	awful.layout.suit.tile,
	awful.layout.suit.tile.left,
	awful.layout.suit.tile.bottom,
	awful.layout.suit.tile.top,
	awful.layout.suit.max,
	awful.layout.suit.fair,
	awful.layout.suit.floating,
	awful.layout.suit.fair.horizontal,
	awful.layout.suit.spiral,
	awful.layout.suit.spiral.dwindle,
	awful.layout.suit.max,
	awful.layout.suit.max.fullscreen,
	awful.layout.suit.magnifier
}
-- }}}
