require("keygrabber")

awful.menu.menu_keys = {
	up = {"k", "K", "Up"},
	down = {"j", "Down"},
	back = {"h", "Left"},
	exec = {"l", "Return", "Right", "Space"},
	close = {"Escape"}
}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
	awful.button({ }, 3, function () mymainmenu:toggle() end),
	awful.button({ }, 4, awful.tag.viewnext),
	awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
	-- PreentScreen with scrot
	awful.key({            }, "Print",  function () awful.util.spawn("scrot   ") end ),
	awful.key({ modkeyctrl }, "Print",  function () awful.util.spawn("scrot -s") end ),

	-- menu 4 clients {{{
	-- TODO: navigation with 1-9 at least
	awful.key({ modkey }, "Tab",
		function ()
			local cmenu = awful.menu.clients({ width = 256 },
											 { keygrabber = true, coords = {x = 0, y = 10} })
		end ),
	
	-- menu 4 minimized clients only
	awful.key({ modkey, "Shift" }, "Tab",
		function()
			local clients = {}
			for i, c in pairs(client.get()) do
				if c.minimized == true then
					clients[i] = {
						c.name,
				   		function ()
							client.focus = c 
							c:readraw()
							c:raise()
							client.focus = c 
						end,
						c.icon
					}
				end
			end
			local menu = awful.menu({items = clients})
			menu:show({keygrabber=true, coords = { x = 0, y = 10 } })
			return menu
		end),
	--- }}}

	awful.key({ modkey,         }, "Left",   awful.tag.viewprev       ),
	awful.key({ modkey, "Shift" }, "p",      awful.tag.viewprev       ),
	awful.key({ modkey,         }, "Right",  awful.tag.viewnext       ),
	awful.key({ modkey, "Shift" }, "n",      awful.tag.viewnext       ),
	awful.key({ modkey,         }, "Escape", awful.tag.history.restore),

	awful.key({ modkey, "Shift" }, "Left",   shifty.shift_prev ),
	awful.key({ modkey, "Shift" }, "Right",  shifty.shift_next ),

	-- add temporary "tmp" tag	
	awful.key({ modkey            }, "a",  function() shifty.add({ rel_index = 1, name = "tmp"}) end ),
	awful.key({ modkey, "Shift"   }, "a",  function() shifty.add({ rel_index = 1, nopopup = true, name = "tmp" }) end ),
	awful.key({ modkey            }, "d",  shifty.del ),

	-- renaming FIXME
	-- awful.key({ modkey }, "z", function() shifty.rename(awful.tag.selected(1)) end ),

	awful.key({ modkey,           }, "j",
		function ()
			awful.client.focus.byidx( 1)
			if client.focus then client.focus:raise() end
		end),
	awful.key({ modkey,           }, "k",
		function ()
			awful.client.focus.byidx(-1)
			if client.focus then client.focus:raise() end
		end),
	awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true, coords = {x = 0, y = 10}}) end),

	-- Layout manipulation
	awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
	awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
	awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
	awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
	awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),

	-- Standard program
	awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
	awful.key({ modkey, "Control" }, "r", awesome.restart),
	awful.key({ modkey, "Shift"   }, "q", awesome.quit),

	awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
	awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
	awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
	awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
	awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
	awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
	awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
	awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

	-- Prompt
	awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

	awful.key({ modkey }, "x",
	function ()
		awful.prompt.run({ prompt = "Run Lua code: " },
		mypromptbox[mouse.screen].widget,
		awful.util.eval, nil,
		awful.util.getdir("cache") .. "/history_eval")
	end)
)

clientkeys = awful.util.table.join(
	awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
	awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
	awful.key({ modkey,           }, "q",      function (c) c:kill()                         end),
	awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
	awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
	awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
	awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
	awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
	awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
	awful.key({ modkey, "Control" }, "n", awful.client.restore),
	awful.key({ modkey,           }, "m",
		function (c)
			c.maximized_horizontal = not c.maximized_horizontal
			c.maximized_vertical   = not c.maximized_vertical
		end),

	-- resize floating window
	awful.key({ modkey, "Shift" }, "z", function(c)
		keygrabber.run(
			function(mod, key, event)
				if event == "release" then return true end

				if     key == 'j' then awful.client.moveresize(0, 0,  0,  20, c)
				elseif key == 'k' then awful.client.moveresize(0, 0,  0, -20, c)
				elseif key == 'l' then awful.client.moveresize(0, 0,  20,  0, c)
				elseif key == 'h' then awful.client.moveresize(0, 0, -20,  0, c)
				else keygrabber.stop()
				end

				return true
			end
		)
		end
	),

	-- move floating window
	awful.key({ modkey, "Control" }, "z", function(c)
		keygrabber.run(
			function(mod, key, event)
				if event == "release" then return true end

				if     key == 'j' then awful.client.moveresize(0,   20, 0, 0, c)
				elseif key == 'k' then awful.client.moveresize(0,  -20, 0, 0, c)
				elseif key == 'h' then awful.client.moveresize(-20,  0, 0, 0, c)
				elseif key == 'l' then awful.client.moveresize(20,   0, 0, 0, c)
				else keygrabber.stop()
				end

				return true
			end
		)
		end
	)

)


clientbuttons = awful.util.table.join(
	awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
	awful.button({ modkey }, 1, awful.mouse.client.move),
	awful.button({ modkey }, 3, awful.mouse.client.resize))

-- WORKSPACES
-- shifty:
for i = 0, 9 do
	globalkeys = awful.util.table.join(globalkeys, awful.key({ modkey }, i,
		function ()
			local t = awful.tag.viewonly(shifty.getpos(i))
		end))
	globalkeys = awful.util.table.join(globalkeys, awful.key({ modkey, "Control" }, i,
		function ()
			local t = shifty.getpos(i)
			t.selected = not t.selected
		end))
	globalkeys = awful.util.table.join(globalkeys, awful.key({ modkey, "Control", "Shift" }, i,
		function ()
			if client.focus then
				awful.client.toggletag(shifty.getpos(i))
			end
		end))
	globalkeys = awful.util.table.join(globalkeys, awful.key({ modkey, "Shift" }, i,
		function ()
			if client.focus then
				local t = shifty.getpos(i)
				awful.client.movetotag(t)
			end
	end))
end

-- Set keys
root.keys(globalkeys)
shifty.config.globalkeys = globalkeys
shifty.config.clientkeys = clientkeys
-- }}}
