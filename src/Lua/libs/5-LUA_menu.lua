rawset(_G, "TAKIS_MENU",{})
local tm = TAKIS_MENU

tm.entries = {
	[0] = {
		title = "Takis Help",
		color = SKINCOLOR_CLOUDY,
		curcolor = SKINCOLOR_SUPERGOLD4,
		icon = "MISSING",
		text = {
			"Menu Help",
			"Takis Manual",
			"Important Letter",
		},
		commands = {
			"showmenuhints",
			"instructions",
			"importantletter",
		}
	},
	--hardcoded so you cant mess with it
	[1] = {
		title = "Achievements",
		color = SKINCOLOR_CARBON,
		nocursor = true,
		text = {},
	},
	[2] = {
		title = "Takis Options",
		color = SKINCOLOR_CLOUDY,
		curcolor = SKINCOLOR_SUPERGOLD4,
		text = {
			"No Strafe",
			"No PT Happy Hour",
			"Happy Hour Style",
			"More Happy Hour",
			"Taunt Menu Cursor",
			"Quakes",
			"Flashes",
			"Additive Afterimages",
			"I have the Music Wad!",
			"Clutch Meter Style",
			"Share Combos",
			"Don't Show Ach. Messages",
		},
		table = "takis.io",
		values = {
			"nostrafe",
			"nohappyhour",
			"happyhourstyle",
			"morehappyhour",
			"tmcursorstyle",
			"quakes",
			"flashes",
			"additiveai",
			"ihavemusicwad",
			"clutchstyle",
			"sharecombos",
			"dontshowach"
		},
		commands = {
			"nostrafe",
			"nohappyhour",
			"happyhourstyle",
			"morehappyhour",
			"tauntmenucursor",
			"quakes",
			"flashes",
			"additiveafterimages",
			"ihavethemusicwad",
			"clutchstyle",
			"sharecombos",
			"dontshowach"
		}
	},
	[3] = {
		title = "I/O Stuff",
		color = SKINCOLOR_CLOUDY,
		curcolor = SKINCOLOR_SUPERGOLD4,
		text = {
			"Save Config",
			"Load Config",
			"Delete Achievements",
			"$$$$$",
		},
		commands = {
			"saveconfig",
			"loadconfig",
			"deleteachievements",
		}
	},
	[4] = {
		title = "Net Stuff",
		color = SKINCOLOR_GOLD,
		text = {
			"Don't Speed Boost",
			"Nerf Armas",
			"Tauntkills",
			"No Achs."
		},
		values = {
			"dontspeedboost",
			"nerfarma",
			"tauntkillsenabled",
			"noachs",
		},
		commands = {
			"speedboosts",
			"nerfarma",
			"tauntkills",
			"noachs",
		}
	}
}

for i = 1,NUMACHIEVEMENTS
	if i > 7
		continue
	end
	table.insert(tm.entries[1].text,'')
end

filesdone = $+1
