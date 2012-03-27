-- advanced widgets {{{
require("blingbling")

-- Volume widget {{{
	volicon = widget({type = "imagebox"})
	volicon.image = image("/home/philosoft/.config/awesome/icons/vol.png")
	my_volume=blingbling.volume.new()
	my_volume:set_height(18)
	my_volume:set_width(30)
	--bind the volume widget on the master channel
	my_volume:update_master()
	my_volume:set_master_control()
	my_volume:set_bar(true)
-- }}}

--network
mynet = blingbling.net.new()
mynet:set_height(18) -- FIXME set height to fit height of bar
mynet:set_interface("wlan0")
mynet:set_show_text(true)
mynet:set_background_text_color(theme.bg_normal)
mynet:set_text_color(theme.fg_normal)

--cal
mycal = blingbling.calendar.new({type = "textbox", text = "calendar"})
mycal:set_cell_padding(4)
mycal:set_columns_lines_titles_text_color(beautiful.text_font_color_2)
mycal:set_title_text_color(beautiful.fg_focus)
--mem
memwidget=blingbling.progress_bar.new()
memwidget:set_height(18)
memwidget:set_width(15)
-- {{{ Memory usage
	memicon = widget({ type = "imagebox" })
	memicon.image = image(iconsdir .. "mem.png")
	memwidget:set_background_text_color(theme.bg_normal) 
	memwidget:set_text_color(theme.fg_normal)            
	vicious.register(memwidget, vicious.widgets.mem, '$1', 2)
-- }}}

-- {{{ CPU usage and temperature
	cpuicon = widget({ type = "imagebox" })
	cpuicon.image = image(iconsdir .. "cpu.png")
	mycairograph=blingbling.classical_graph.new()
	mycairograph:set_height(18)
	mycairograph:set_width(80)
	mycairograph:set_tiles_color("#00000022")
	mycairograph:set_show_text(true)
	mycairograph:set_label("$percent %")
	mycairograph:set_background_text_color(theme.bg_normal)   
	mycairograph:set_text_color(theme.fg_normal)              
	vicious.register(mycairograph, vicious.widgets.cpu,'$1',2)
-- }}}

-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })
timeicon = widget({type = "imagebox"})
timeicon.image = image(iconsdir .. "time.png")


-- Create a systray
mysystray = widget({ type = "systray" })

-- batwidget {{{
	-- battery state
	baticon = widget({type = "imagebox"})
	baticon.image = image(iconsdir .. "bat.png")
	-- Init widget
	batwidget = widget({type = "textbox"})
	-- reg widget
	vicious.register(batwidget, vicious.widgets.bat, "$1$2%", 61, "BAT0")
-- }}}



-- Keyboard layout widget {{{
	kbdwidget = widget({type = "textbox", name = "kbdwidget"})
	kbdwidget.border_width = 1
	kbdwidget.border_color = beautiful.fg_normal
	kbdwidget.text = " en "

	dbus.request_name("session", "ru.gentoo.kbdd")
	dbus.add_match("session", "interface='ru.gentoo.kbdd',member='layoutChanged'")
	dbus.add_signal("ru.gentoo.kbdd", function(...)
		local data = {...}
		local layout = data[2]
		lts = {[0] = "en", [1] = "ru"}
		kbdwidget.text = " "..lts[layout].." "
		end
	)
-- }}}

-- {{{ Reusable separator
	separator = widget({ type = "imagebox" })
	separator.image = image(iconsdir .. "separator.png")
-- }}}

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
											awful.button({ }, 1, awful.tag.viewonly),	
											awful.button({ modkey }, 1, awful.client.movetotag),
											awful.button({ }, 3, awful.tag.viewtoggle),
											awful.button({ modkey }, 3, awful.client.toggletag),
											awful.button({ }, 4, awful.tag.viewnext),
											awful.button({ }, 5, awful.tag.viewprev)
										)

shifty.taglist = mytaglist

mytasklist = {}
mytasklist.buttons = awful.util.table.join(
	awful.button({ }, 1, function (c)
		if not c:isvisible() then
			awful.tag.viewonly(c:tags()[1])
		end
		client.focus = c
		c:raise()
	end),
	awful.button({ }, 3, function ()
		if instance then
			instance:hide()
			instance = nil
		else
			instance = awful.menu.clients({ width=250 })
		end
	end),
	awful.button({ }, 4, function ()
		awful.client.focus.byidx(1)
		if client.focus then client.focus:raise() end
	end),
	awful.button({ }, 5, function ()
		awful.client.focus.byidx(-1)
		if client.focus then client.focus:raise() end
end))

for s = 1, screen.count() do
	-- Create a promptbox for each screen
	mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
	-- Create an imagebox widget which will contains an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	mylayoutbox[s] = awful.widget.layoutbox(s)
	mylayoutbox[s]:buttons(awful.util.table.join(
	awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
	awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
	awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
	awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
	-- Create a taglist widget
	mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

	-- Create a tasklist widget
	mytasklist[s] = awful.widget.tasklist(function(c)
		return awful.widget.tasklist.label.currenttags(c, s)
	end, mytasklist.buttons)

	-- Create the wibox
	mywibox[s] = awful.wibox({ position = "top", screen = s })

	-- Add widgets to the wibox - order matters
	mywibox[s].widgets = {
		{
			mylayoutbox[s],
			mytaglist[s],
			mypromptbox[s],
			layout = awful.widget.layout.horizontal.leftright
		},
	mytextclock, timeicon,
	mysystray,
	kbdwidget,
	separator, batwidget, baticon,
	--mycal.widget,
	my_volume.widget, volicon,
	separator, memwidget.widget, memicon,
	separator, mycairograph.widget, cpuicon,
	separator, mynet.widget,
	mytasklist[s],
	layout = awful.widget.layout.horizontal.rightleft
}
end
-- }}}
