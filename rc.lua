require("awful.autofocus")
require("awful.rules")
require("beautiful")
require("naughty")
require("vicious")
require("shifty")

require("rc.vars")

beautiful.init(theme)

-- shifty: predefined tags {
shifty.config.tags = {
	["dev" ]   = { position = 1, layout = awful.layout.suit.tile.bottom, mwfact = 0.8, spawn = "gvim" },
	["im"   ]   = { position = 2, layout = awful.layout.suit.tile.left, mwfact = 0.2		           },
	["web"  ]   = { position = 3, layout = awful.layout.suit.max,                                      },
	["term" ]   = { position = 4, layout = awful.layout.suit.tile.bottom                               },
	["mail" ]   = { position = 5, layout = awful.layout.suit.max                                       },
	["music"]   = { position = 6, layout = awful.layout.suit.tile.bottom, max_clientst = 2             },
	["torrent"] = { position = 7, layout = awful.layout.suit.max                                       },
}
-- }

-- shifty: tags matching and client rules
shifty.config.apps = {
	{ match = { "luakit",
				"Firefox",
   				"Iceweasel" }, tag = "web", float = false, nopopup = true                                 },
	-- Floating windows for browsers
	{ match = {"Dialog"}, float = true },

	{ match = { "GVim"      }, tag = "dev", master = true                                                },
	{ match = { "Glade"     }, float = true                                                               },

	-- IM {
	{ match = { "Gajim"     }, tag = "im", nopopup = true },
	{ match = { "Pidgin"    }, tag = "im", nopopup = true, run = function (c)
		local target_tag = awful.tag.selected(1) -- howoto get current active screen? FIXME
		if awful.tag.getnmaster(target_tag) == 1 then
			awful.tag.setnmaster(2, target_tag)
		end
	end },
	{ match = { "buddy_list"			}, slave = true,   				                        					  },
	-- }

	{ match = { "Thunderbird", "Icedove"}, tag = "mail", nopopup = true                         					  },
	{ match = { "Gimp"					}, tag = "gimp",											                  },
	{ match = { "gimp%-image%-window"	}, geometry = {231,20,905,750}, border_width = 0                              },
	{ match = { "^gimp%-toolbox$"		}, geometry = {0,20,230,750}, slave = true, border_width = 1, ontop = true	  },
	{ match = { "^gimp%-dock$"			}, geometry = {1136,20,230,760}, slave = true, border_width = 1, ontop = true },
	{ match = { "^MPlayer"				}, geometry = {0,15,nil,nil}, float = true, sticky=false, ontop=true          },
	{ match = { "SMPlayer"				}, float = true, ontop = true, sticky = true								  },
	{ match = { "Cmus"                  }, tag = "music",                                                             },
	{ match = { "Deluge", "Transmission"}, tag = "torrent", nopopup = true                                            },

	-- client manipulation
	{ 
		match = { "" },
		honorsizehints = true,
		buttons = awful.util.table.join (
			awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
			awful.button({ modkey }, 1, awful.mouse.client.move),
			awful.button({ modkey }, 3, awful.mouse.client.resize)
		)
	},
}

-- shifty: defaults
shifty.config.defaults = {
	layout = awful.layout.suit.max,
}
shifty.config.layouts = layouts
shifty.init()

-- {{{ Menu
shutdown_dlg = "/home/philosoft/bin/shutdown_dialog.sh"
myshutdownmenu = {
    { "Hibernate", "sudo pm-hibernate" },
    { "Sleep",     "sudo pm-suspend"   },
    { "Reboot",    "sudo reboot"       },
    { "Shutdown",  "sudo poweroff"     },
    { "Dialog",     shutdown_dlg       }
}

mymainmenu = awful.menu({ items = { { "shutdown", myshutdownmenu },
                                    { "umount"  , "/home/philosoft/bin/umount_dlg.sh" }
							      }
						})
mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon), menu = mymainmenu })
-- }}}

require("rc.widgets")

require("rc.bindings")

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
	-- Add a titlebar
	-- awful.titlebar.add(c, { modkey = modkey })

	-- Enable sloppy focus
	c:add_signal("mouse::enter", function(c)
		if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
			and awful.client.focus.filter(c) then
			client.focus = c
		end
	end)

	if not startup then
		-- Set the windows at the slave,
		-- i.e. put it at the end of others instead of setting it master.
		awful.client.setslave(c)

		-- Put windows in a smart way, only if they does not set an initial position.
		if not c.size_hints.user_position and not c.size_hints.program_position then
			awful.placement.no_overlap(c)
			awful.placement.no_offscreen(c)
		end
	end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- disable startup-notification globally
local oldspawn = awful.util.spawn
awful.util.spawn = function (s)
	oldspawn(s, false)
end

-- {{{  Applications autorun
function run_once(prg)
	if not prg then
		do return nil end
	end
	awful.util.spawn_with_shell("pgrep -u $USER -x " .. prg .. " || (" .. prg .. ")")
end
-- }}}

-- vim:foldmethod=manual
