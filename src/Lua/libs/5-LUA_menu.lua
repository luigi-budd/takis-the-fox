rawset(_G, "TAKIS_MENU",{})
local tm = TAKIS_MENU

tm.entries = {
	[0] = {
		title = "Takis Help",
		color = SKINCOLOR_SILVER,
		text = {
			"Menu Help",
			"Takis Manual",
			"Important Letter",
		},
		commands = {
			"showmenuhints",
			"instructions",
			"importantletter",
		},
		hints = {
			"Show the controls.",
			"Print the manual URL in console.",
			"..."
		}
	},
	--hardcoded so you cant mess with it
	[1] = {
		title = "Achievements",
		color = SKINCOLOR_CARBON,
		text = {},
	},
	[2] = {
		title = "Takis Options",
		color = SKINCOLOR_FOREST,
		text = {
			"No Strafe",
			"No PT Happy Hour",
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
			"morehappyhour",
			"tauntmenucursor",
			"quakes",
			"flashes",
			"additiveafterimages",
			"ihavethemusicwad",
			"clutchstyle",
			"sharecombos",
			"dontshowach"
		},
		hints = {
			"Toggles forced strafing.",
			"Toggles Happy Hour in Pizza Time Spice Runners.",
			"Toggles other characters getting Happpy Hour in PTSR.",
			"Toggles the cursor in the Taunt Menu. (TF+C1)",
			"Toggles screen quakes.",
			"Toggles screen flashes.",
			"Toggles additive blending for the afterimages.",
			"Do you have the music wad?",
			"Clutch Bar or Clutch Meter.",
			"Share combos with other Takis.",
			"Don't show other Takis' achievements."
		}
	},
	[3] = {
		title = "I/O Stuff",
		color = SKINCOLOR_GREY,
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
			"No Achs.",
			"Ragdoll collaterals"
		},
		values = {
			"dontspeedboost",
			"nerfarma",
			"tauntkillsenabled",
			"noachs",
			"collaterals",
		},
		commands = {
			"speedboosts",
			"nerfarma",
			"tauntkills",
			"noachs",
			"collaterals",
		},
		hints = {
			"Toggles Takis giving players speed boosts in Co-op.",
			"Toggles Powerful Arma & normal Arma for Takis.",
			"Toggles tauntkills for Takis.",
			"Toggles Takis being able to get achievements.",
			"Toggles ragdolls being able to kill other things."
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
