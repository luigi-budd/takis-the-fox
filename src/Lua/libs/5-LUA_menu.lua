rawset(_G, "TAKIS_MENU",{})
local tm = TAKIS_MENU

tm.entries = {
	[0] = {
		title = "Takis Help",
		color = "p.skincolor",
		text = {
			"Menu Help",
			"Takis Manual",
			"Takis Tutorial",
			'Important Letter',
		},
		commands = {
			"showmenuhints",
			"instructions",
			"takistutorial",
			"importantletter",
		},
		hints = {
			"Show the controls.",
			"Print the manual URL in console.",
			"Warp to the Tutorial level. Singleplayer only.",
			"..."
		}
	},
	--hardcoded so you cant mess with it
	[1] = {
		title = "Achievements",
		color = SKINCOLOR_CARBON,
		text = {''},
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
			"Toggles screen flashes and flashing objects.",
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
			"Nerf Armas",
			"Tauntkills",
			"No achievements",
			"Ragdoll collaterals",
			"Heartcards",
			"Hammer quakes",
		},
		values = {
			"nerfarma",
			"tauntkillsenabled",
			"noachs",
			"collaterals",
			"cards",
			"hammerquakes",
		},
		--must be consvar_t, must be on/off, yes/no, true/false
		cvars = {
			CV_TAKIS.nerfarma,
			CV_TAKIS.tauntkills,
			CV_TAKIS.achs,
			CV_TAKIS.collaterals,
			CV_TAKIS.heartcards,
			CV_TAKIS.hammerquake,
		},
		hints = {
			"Toggles Powerful Arma & normal Arma for Takis.",
			"Toggles tauntkills for Takis.",
			"Toggles Takis being able to get achievements.",
			"Toggles ragdolls being able to kill other things.",
			"Toggles things dropping Heart Cards on death.",
			"Toggles Takis' Hammer Blast causing quakes when landing."
		}
	},
}

if (TAKIS_ISDEBUG)
	tm.entries[5] = {
		title = "Debug",
		color = SKINCOLOR_SEAFOAM,
		noprefix = true,
		text = {
			"Instant exit",
			"Panic!",
			"Shotgunify",
			"\x82".."Debug Flags:",
		},
		table = "_G",
		values = {
			nil,
			nil,
			nil,
			nil
		},
		commands = {
			"leave",
			"panic 3 2",
			"shotgun",
			nil,
		},
		hints = {
			"Leave the level instantly.",
			"Triggers Happy Hour with 3 minutes.",
			"Instant shotgunify.",
			"Clientside debug flags.",
		}
	}
	local dbgflags = {
		"BUTTONS",
		"PAIN",
		"ACH",
		"QUAKE",
		"HAPPYHOUR",
		"ALIGNER",
		"PFLAGS",
		"BLOCKMAP",
		"DEATH",
		"SPEEDOMETER",
		"HURTMSG",
	}
	for k,v in ipairs(dbgflags)
		tm.entries[5].text[4+k] = v
	end
	for k,v in ipairs(dbgflags)
		tm.entries[5].commands[4+k] = "setdebug "..v
	end
	addHook("ThinkFrame",do
		for i = 1,#dbgflags
			local bit = 1<<(i-1)
			tm.entries[5].values[4+i] = (TAKIS_DEBUGFLAG&bit)==bit
		end
	end)
	
end

filesdone = $+1
