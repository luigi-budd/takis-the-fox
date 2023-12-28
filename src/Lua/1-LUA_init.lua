--Funny init

--welcome to sonic robo blast 2.
--after 40 years in development, hopefully it will be worth the wait.
--thanks, and have fun.

/*
	SPECIAL THANKS/CONTRIBUTORS
	remember to put this in the MB page luigi
	
	-dashdahog - takis' sprites inspiration. I LOVE TAILEELS!!!
	-jisk - jelped jith jome jode
	-unmatched bracket - waterslide pain -> sliding code
	
*/

local pnk = "\x8E"
local wht = "\x80"

rawset(_G, "TR", TICRATE)

rawset(_G, "TAKIS_ISDEBUG", true)
rawset(_G, "TAKIS_DEBUGFLAG", 0)
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
	"TRANSFO",
	"HURTMSG",
}
for k,v in ipairs(dbgflags)
	rawset(_G,"DEBUG_"..v,1<<(k-1))
	print("Enummed DEBUG_"..v.." ("..1<<(k-1)..")")
end

local ioflags = {
	"ACH",
	"CONFIG",
	
	"SAVE",
	"LOAD",
	
	"MENU",
}
for k,v in ipairs(ioflags)
	rawset(_G,"IO_"..v,1<<(k-1))
	print("Enummed IO_"..v.." ("..1<<(k-1)..")")
end

//only for IO debug, despite the name implying its for all
rawset(_G, "DEBUG_print",function(p,enum)
	--log this
	/*
	table.insert(TAKIS_NET.iousage,{
		player = p,
		type = tonumber(enum) or 0,
		tics = TR,
	})
	*/
end)

rawset(_G, "TAKIS_SKIN", "takisthefox")

local setname = false
addHook("ThinkFrame",do
	if OLDC and not setname
		OLDC.SetSkinFullName(TAKIS_SKIN,"Takis the Fox")
		setname = true
	end
end)

rawset(_G, "TAKIS_MAX_HEARTCARDS", 6)
rawset(_G, "TAKIS_MAX_HEARTCARD_FUSE", 30*TR)
rawset(_G, "TAKIS_HEARTCARDS_SHAKETIME", 17)
rawset(_G, "TAKIS_MAX_COMBOTIME", 7*TR)
rawset(_G, "TAKIS_PART_COMBOTIME", 4*TR/5)
--just soap lol!
rawset(_G, "TAKIS_COMBO_RANKS", {
	"Lame...",
	"\x83Soapy",
	"\x88".."Alright...",
	"\x8B".."Going Places!",
	"\x82Nice!",
	"\x84".."Gamer!",
	"\x8D".."Destructive!",
	"\x87".."Demo Expert!",
	"\x85Menacing!",
	"\x86WICKED!!",
	"\x85".."Adobe Flash!",
	"\x88".."Aseprite!!",
	"\x86Robo!",
	"\x88".."BLAST!!",
	"F"..pnk.."u"..wht.."n"..pnk.."n"..wht.."y"..pnk.."!",
	"\x86Unfunny.",
	"\x8B".."EAT EAT EAT!",
	"\x82Holy Moly!",
	"\x86Please, no more!",
	"\x84".."BALLER!",
	"\x82Super Cool!",
	"\x87".."Combo Fodder",
	"\x85".."DEATH MACHINE!",
	"\x8DNow THAT'S Hardcore!!",
	"\x86".."Boring...",
	"\x82".."De".."\x8D".."lu".."\x85".."sio".."\x8D".."na".."\x82".."l!",
	"\x85Property DAMAGE!!",
	pnk.."Lovely!",
	"\x83Lookin' Good!",
	pnk.."Fun-\x81ky!",
})
rawset(_G, "TAKIS_COMBO_UP", 5)
rawset(_G, "TAKIS_HAPPYHOURFONT", "TAHRF")
rawset(_G, "TAKIS_TITLETIME", 0)
rawset(_G, "TAKIS_TITLEFUNNY", 0)
rawset(_G, "TAKIS_TITLEFUNNYY", 0)

--hurtmsg stuff
local hurtmsgenum = {
	"CLUTCH",
	"SLIDE",
	"HAMMERBOX",
	"HAMMERQUAKE",
	"ARMA",
	"BALL",
	"NADO",
}
for k,v in ipairs(hurtmsgenum)
	rawset(_G,"HURTMSG_"..v,k-1)
	print("Enummed HURTMSG_"..v.." ("..(k-1)..")")
end

local noabflags = {
	"CLUTCH",
	"HAMMER",
	"DIVE",
	"SLIDE",
	"WAVEDASH",
	"SHOTGUN",		--generally for anything shotgunned
	"SHIELD",
	"THOK",
}
for k,v in ipairs(noabflags)
	rawset(_G,"NOABIL_"..v,1<<(k-1))
	print("Enummed NOABIL_"..v.." ("..1<<(k-1)..")")
end
--anything that uses spin
rawset(_G,"NOABIL_SPIN",NOABIL_CLUTCH|NOABIL_HAMMER|NOABIL_SHOTGUN|NOABIL_WAVEDASH)
--i dont *think* i should put thok in here, but that might change
rawset(_G,"NOABIL_ALL",NOABIL_SPIN|NOABIL_SLIDE|NOABIL_SHIELD|NOABIL_DIVE)

local transfoenum = {
	"SHOTGUN",
	"PANCAKE",
	"BALL",
	"ELEC",
	"TORNADO",
}
for k,v in ipairs(transfoenum)
	rawset(_G,"TRANSFO_"..v,1<<(k-1))
	print("Enummed TRANSFO_"..v.." ("..1<<(k-1)..")")
end

--spike stuff according tro source
-- https://github.com/STJr/SRB2/blob/a4a3b5b0944720a536a94c9d471b64c822cdac61/src/p_map.c#L838
rawset(_G, "SPIKE_LIST", {
	[MT_SPIKE] = true,
	[MT_WALLSPIKE] = true,
	[MT_SPIKEBALL] = true,
	[MT_BOMBSPHERE] = true,
})

rawset(_G, "TAKIS_NET", {
	inspecialstage = false,
	inbossmap = false,
	inbrakmap = false,
	isretro = 0,
	
	livescount = 0,
	
	nerfarma = false,
	tauntkillsenabled = true,
	noachs = false, --dont let players get achs in netgames
	collaterals = true, --let ragdolls kill other ragdolls
	cards = true, --only spawn heartcards if this is true
	hammerquakes = true,
	
	numdestroyables = 0,
	partdestroy = 0,
	
	exitingcount = 0,
	playercount = 0,
	takiscount = 0,
	
	ideyadrones = {},
	
	--DONT change to happy hour if the song is any one of these
	specsongs = {
		["_1up"] = true,
		["_shoes"] = true,
		["_minv"] = true,
		["_inv"] = true,
		["_drown"] = true,
		["_inter"] = true,
		["_clear"] = true,
		["_abclr"] = true,
		["hpyhre"] = true,
		["hapyhr"] = true,
		["letter"] = true,
		["creds"] = true,
		["_conga"] = true,
		["_gover"] = true,
		--spice runers
		["ovrtme"] = true,
		["rnk_a"] = true,
		["rnk_cb"] = true,
		["rnk_d"] = true,
		["rnk_p"] = true,
		["rnk_s"] = true,
		["p_int"] = true,
	},
	
})

rawset(_G, "TAKIS_HAMMERDISP", FixedMul(52*FU,9*FU/10))

freeslot("MT_TAKIS_TAUNT_HITBOX")
freeslot("S_TAKIS_TAUNT_HITBOX")
mobjinfo[MT_TAKIS_TAUNT_HITBOX] = {
	doomednum = -1,
	spawnstate = S_TAKIS_TAUNT_HITBOX,
	height = 60*FRACUNIT,
	radius = 35*FRACUNIT,
	flags = MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOGRAVITY|MF_SOLID
}
states[S_TAKIS_TAUNT_HITBOX] = {
	sprite = SPR_RING,
	frame = A
}

rawset(_G, "TakisInitTable", function(p)
	--why print?
	CONS_Printf(p,"\x86"+"Initializing Takis' table...")

	p.takistable = {
		--buttons
		jump = 0,
		use = 0,
		tossflag = 0,
		c1 = 0,
		c2 = 0,
		c3 = 0,
		fire = 0,
		firenormal = 0,
		weaponmask = 0,
		weaponmasktime = 0,
		weaponnext = 0,
		weaponprev = 0,
		
		transfo = 0,
		
		--vars
		accspeed = 0,
		prevspeed = 0,
		clutchcombo = 0,
		clutchcombotime = 0,
		clutchtime = 0,
		clutchingtime = 0,
		clutchspamcount = 0,
		clutchspamtime = 0,
		afterimaging = 0,
		beingcrushed = false,
		slidetime = 0,
		YDcount = 0,
		jumptime = 0,
		wavedashcapable = false,
		dived = false,
		steppedthisframe = false,
		prevmomz = 0,
		dontlanddust = false,
		dontfootdust = false,
		ticsforpain = 0,
		ticsinpain = 0,
		timesdeathpitted = 0,
		saveddmgt = 0,
		yeahwait = 0, 
		yeahed = false,
		altdisfx = 0,
		setmusic = false,
		crushtime = 0,
		timescrushed = 0,
		goingfast = false,
		wentfast = 0,
		sweat = 0,
		body = 0,
		stoprolling = false,
		--the only "InX" variable thats all lowercase 
		--(and not with the bools)
		inwaterslide = false,
		glowyeffects = 0,
		sethappyend = false,
		otherskin = false,
		otherskintime = 0,
		rmomz = 0,
		lastrank = 1,
		lastmomz = 0,
		recovwait = 0,
		dropdashstale = 0,
		dropdashstaletime = 0,
		lastmap = 1,
		lastgt = 0,
		lastskincolor = 0,
		lastdestroyed = 0,
		achfile = 0,
		drilleffect = 0,
		issuperman = false,
		attracttarg = nil,
		afterimagecolor = 1,
		dustspawnwait = 0,
		timetouchingground = 0,
		resettingtoslide = false,
		--NIGHT SEX PLODE!?!?!?
		nightsexplode = false,
		bashtime = 0,
		bashtics = 0,
		pizzastate = 0,
		deathfloored = false,
		pancaketime = 0,
		electime = 0,
		hhexiting = false,
		crushscale = FU/3,
		prevz = 0,
		ballretain = 0,
		nadocount = 0,
		nadotic = 0,
		nadouse = 0,
		nadoang = 0,
		nadocrash = 0,
		nadotime = 0,
		nadotuttic = 0,
		
		taunttime = 0,
		tauntid = 0,
		tauntspecial = false,
		--join mobj
		tauntjoin = 0,
		tauntjoinable = false,
		--quick taunts activated by
		--tossflag+c2/c3
		--uses taunt idss
		--these are actually io but they arent in the io table :trol:
		tauntquick1 = 0,
		tauntquick2 = 0,
		tauntcanparry = false,
		--holds the player doing a partner taunt with us
		tauntpartner = 0,
		--dont put the other player in tauntpartner if this is false
		tauntacceptspartners = false,
		
		hammerblastdown = 0,
		hammerblastwentdown = false,
		hammerblasthitbox = nil,
		hammerblastjumped = 0,
		hammerblastgroundtime = 0,
		hammerblastangle = 0,
		
		gravflip = 1,
		
		heartcards = TAKIS_MAX_HEARTCARDS,
		
		combo = {
			count = 0,
			lastcount = 0,
			time = 0,
			rank = 1,
			verylevel = 0,
			score = 0,
			cashable = false,
			dropped = false,
			awardable = false,
			failcount = 0,
			
			--anim stuff
			introtics = 0,
			outrotics = 0,
			outrotointro = 0,
			frozen = false,
		},
		io = {
			hasfile = false,
			loaded = false,
			loadwait = 25,
			
			nostrafe = 0,
			nohappyhour = 0,
			morehappyhour = 0,
			tmcursorstyle = 1, --taunt menu cursor style, 1 for nums, 2 for cursor
			quakes = 1,
			flashes = 1,
			windowstyle = 'win10', --for cosmenu, all lowercase
			additiveai = 0,
			clutchstyle = 1, --0 for bar, 1 for meter
			sharecombos = 1,
			dontshowach = 0, --1 to not show ach messages
		},
		--tf2 taunt menu lol
		--up to 7 taunts, detected with BT_WEAPONMASK
		tauntmenu = {
			open = false,
			closingtime = 0,
			yadd = 500*FU,
			tictime = 0,
			list = {
				[1] = "Ouchy \nOuch!",
				[2] = "Smugness",
				[3] = "Conga",
				[4] = "Home-run\n     Bat",
			},
			--1-7 x pos
			cursor = 1,
			gfx = {
				--the associated taunt icon for each taunt
				--MUST BE HUD PATCHES!!
				pix = {
					[1] = "TAHY_FACE0",	
				},
				--fixed point scales
				scales = {
					[1] = FU/5,
				},
			},
			--text x offsets
			xoffsets = {
				[1] = 11,
				[4] = 12,
			},
		},
		cosmenu = {
			menuinaction = false,
			
			--cursor pos
			y = 0,
			page = 0,
			scroll = 0,
			
			--btn
			up = 0,
			down = 0,
			left = 0,
			right = 0,
			jump = 0,
			
			achscroll = 0,
			
			hintfade = 3*TR+18,
		},
		hurtmsg = {
			[HURTMSG_CLUTCH] = {text = "Clutch Boost",tics = 0},
			[HURTMSG_SLIDE] = {text = "Slide",tics = 0},
			[HURTMSG_HAMMERBOX] = {text = "Hammer",tics = 0},
			[HURTMSG_HAMMERQUAKE] = {text = "Earthquake",tics = 0},
			[HURTMSG_ARMA] = {text = "Armageddon Shield",tics = 0},
			[HURTMSG_BALL] = {text = "tumble",tics = 0},
			[HURTMSG_NADO] = {text = "Tornado Spin",tics = 0},
		},
		bonuses = {
			["shotgun"] = {
				tics = 0, 
				score = 0,
				text = "Shotgun"
			},
			["ultimatecombo"] = {
				tics = 0, 
				score = 0,
				text = "\x82Ultimate Combo"
			},
			["happyhour"] = {
				tics = 0, 
				score = 0,
				text = "\x85Happy Hour trigger"
			},
			cards = {},
			/*
			["heartcard"] = {
				tics = 0, 
				score = 0,
				text = pnk.."Heart Card"
			}
			*/
		},
		
		shotgunned = false,
		--the shotgun mobj
		shotgun = 0,
		shotguncooldown = 0,
		shotguntime = 0,
		timesincelastshot = 0,
		shotguntuttic = 0,
		
		--bools
		onGround = false,
		inPain = false,
		isTakis = false,
		isSinglePlayer = false,
		inWater = false,
		inGoop = false,
		inFakePain = false,
		notCarried = false,
		isMusicOn = false,
		onPosZ = false,
		isElevated = false,
		inNIGHTSMode = false,
		justHitFloor = false,
		inSRBZ = false,
		inChaos = false,
		
		--fake powers
		fakeflashing = 0,
		stasistic = 0,
		thokked = false,
		fakesprung = false,
		fakeexiting = 0,
		nocontrol = 0,
		noability = 0,
		
		--quakes
		quakeint = 0, 
		quake = {
			/*
			intensity = FU,
			tics = TR,
			min = FU/TR
			*/
		},
		
		--hud
		--useful if this gets in yalls modmakers' ways
		HUD = {
			timeshake = 0,
			showingletter = false,
			hudname = '',
			cfgnotifstuff = 0,
			menutext = {
				tics = 0,
			},
			steam = {
				/*
				tics = 0,
				xadd = 0,
				enum = 0,
				*/
			},
			showingachs = 0,
			statusface = {
				priority = 0,
				state = "IDLE",
				frame = 0,
				evilgrintic = 0,
				happyfacetic = 0,
				painfacetic = 0,
			},
			heartcards = {
				shake = 0,
				add = 0,
			},
			rings = {
				FIXED = {19*FU, 56*FU},
				int = {117, 43}
			},
			--timer has 2 different sets for spectator and when finished
			timer = {
				text = 14,
				int = {117, 60},		
				spectator = {90-(13*6)+75+15 +15,(62-6)+20+24},
				finished = {90-(13*6)+75+15 +15,(62-6)+20},
			},
			combo = {
				basey = 70*FU,
				y = 70*FU,
				momy = 0,
				scale = FU,
				shake = 0,
				patchx = 0,
				tokengrow = 0,
				fillnum = TAKIS_MAX_COMBOTIME*FU,
			},
			flyingscore = {
				num = 0,
				tics = 0,
				x = 0,
				y = 0,
				lastscore = 0,
				scorenum = 0,
				xshake = 0,
				yshake = 0,
				
				scorex = 0,
				scorey = 0,
				scorea = 0,
				scores = 0,
			},
			funny = {
				y = 500*FU,
				alsofunny = false,
				tics = 0,
			},
			ptsr = {
				xoffset = 30,
				yoffset = 100,
			},
			happyhour = {
				falldown = false,
				doingit = false,
				its = {
					scale = FU/20,
					expectedtime = TR,
					x = 60*FU,
					yadd = -200*FU, 
					patch = "TAHY_ITS",
					frame = 0,
				},
				happy = {
					scale = FU/20,
					expectedtime = 3*TR/2,
					x = 155*FU,
					yadd = 100*FU, 
					patch = "TAHY_HAPY",
					frame = 0,
				},
				hour = {
					scale = FU/20,
					expectedtime = 2*TR,
					x = 260*FU,
					yadd = 100*FU, 
					patch = "TAHY_HOUR",
					frame = 0,
				},
				face = {
					x = 155*FU,
					expectedtime = TR,
					yadd = -200*FU,
					frame = 0,
					
				}
			},
			rank = {
				grow = 0,
				percent = 0, --we use this for the fills
				score = 0, --same here
			},
				/*
			scoretext = {
				cmap = V_GREENMAP,
				trans = V_HUDTRANSHALF,
				text = "+5",
				ymin = -FU,
				tics = TR,
			}
				*/
			
		},
		
	}

	--now we can tell if this actually worked or not
	CONS_Printf(p, "\n"+"\x82"+"Initialized Takis' stuff!")
	CONS_Printf(p, "Check out the enclosed instruction book!")
	CONS_Printf(p, "	https://tinyurl.com/mr45rtzz")

	CONS_Printf(p, "\n \x83Made by luigi budd")
	takis_printwarning(p)
	
	if P_RandomChance(FU/2)
		CONS_Printf(p, "\n"+"\x82"+"Look for the Gummy Bear album in stores on November 13th. ")
	end
	return true
end)

--from chrispy chars!!! by Lach!!!!
local function SafeFreeslot(...)
	for _, item in ipairs({...})
		if rawget(_G, item) == nil
			freeslot(item)
		end
	end
end

freeslot("sfx_clutch")
sfxinfo[sfx_clutch].caption = "Clutch Boost"
freeslot("sfx_cltch2")
sfxinfo[sfx_cltch2].caption = "Clutch Boost"

freeslot("sfx_taksld")
sfxinfo[sfx_taksld].caption = "Slide"

freeslot("sfx_eeugh")
sfxinfo[sfx_eeugh].caption = '\x86"Ehh!"\x80'
freeslot("sfx_antow1")
sfxinfo[sfx_antow1].caption = '\x86"Aah!!"\x80'
freeslot("sfx_antow2")
sfxinfo[sfx_antow2].caption = '\x86"Eargh!"\x80'
freeslot("sfx_antow3")
sfxinfo[sfx_antow3].caption = '\x86"Grr!"\x80'
freeslot("sfx_antow4")
sfxinfo[sfx_antow4].caption = '\x86"Hey, hey!"\x80'
freeslot("sfx_antow5")
sfxinfo[sfx_antow5].caption = '\x86"Oh boy!"\x80'
freeslot("sfx_antow6")
sfxinfo[sfx_antow6].caption = '\x86"WOW! Eheh!"\x80'
freeslot("sfx_antow7")
sfxinfo[sfx_antow7].caption = '\x86"W-w-w-w I\'m good!"\x80'

freeslot("sfx_tayeah")
sfxinfo[sfx_tayeah].caption = '\x86"Yyyeahh!"\x80'
freeslot("sfx_hapyhr")
sfxinfo[sfx_hapyhr].caption = '\x86'.."IT'S HAPPY HOUR!!"..'\x80'

freeslot("sfx_takdiv")
sfxinfo[sfx_takdiv].caption = 'Dive'
freeslot("sfx_airham")
sfxinfo[sfx_airham].caption = 'Swing'
freeslot("sfx_tawhip")
sfxinfo[sfx_tawhip].caption = '\x82Johnny Test!\x80'
freeslot("sfx_takhel")
sfxinfo[sfx_takhel].caption = '\x8EHealed!\x80'
freeslot("sfx_smack")
sfxinfo[sfx_smack].caption = "\x8DSmacked!\x80"
freeslot("sfx_takoww")
sfxinfo[sfx_takoww] = {
	flags = SF_X4AWAYSOUND,
	caption = "\x85".."EUROOOOWWWW!!!\x80"
}
freeslot("sfx_takdjm")
sfxinfo[sfx_takdjm].caption = "Double jump"
freeslot("sfx_takst1")
sfxinfo[sfx_takst1].caption = "Step"
freeslot("sfx_takst2")
sfxinfo[sfx_takst2].caption = "Step"
freeslot("sfx_takst3")
sfxinfo[sfx_takst3].caption = "Step"
freeslot("sfx_takst4")
sfxinfo[sfx_takst4].caption = "Land"
freeslot("sfx_takst0")
sfxinfo[sfx_takst0].caption = "Step"

freeslot("sfx_tkapow")
sfxinfo[sfx_tkapow] = {
	flags = SF_X2AWAYSOUND|SF_NOMULTIPLESOUND|SF_TOTALLYSINGLE,
	caption = "\x82KaPOW!!!\x80"
}
freeslot("sfx_tacrit")
sfxinfo[sfx_tacrit] = {
	flags = SF_X2AWAYSOUND,
	caption = "\x82".."Crit!".."\x80"
}
SafeFreeslot("sfx_slam")
sfxinfo[sfx_slam].caption = "\x8DSlam!!\x80"
SafeFreeslot("sfx_jumpsc")
sfxinfo[sfx_jumpsc].caption = "\x85".."AAAAAHHHHH!!!!\x80"
SafeFreeslot("sfx_mclang")
sfxinfo[sfx_mclang] = {
	caption = "\x8DMysterious clanging\x80",
	flags = SF_X2AWAYSOUND|SF_NOMULTIPLESOUND|SF_TOTALLYSINGLE,
}
SafeFreeslot("sfx_sparry")
sfxinfo[sfx_sparry] = {
	flags = SF_X2AWAYSOUND,
	caption = "\x82POW!\x80"
}
SafeFreeslot("sfx_rakupc")
sfxinfo[sfx_rakupc].caption = "/"
SafeFreeslot("sfx_rakupb")
sfxinfo[sfx_rakupb].caption = "/"
SafeFreeslot("sfx_rakupa")
sfxinfo[sfx_rakupa].caption = "/"
SafeFreeslot("sfx_rakups")
sfxinfo[sfx_rakups].caption = "/"
SafeFreeslot("sfx_rakupp")
sfxinfo[sfx_rakupp].caption = "/"

SafeFreeslot("sfx_rakdns")
sfxinfo[sfx_rakdns].caption = "/"
SafeFreeslot("sfx_rakdna")
sfxinfo[sfx_rakdna].caption = "/"
SafeFreeslot("sfx_rakdnb")
sfxinfo[sfx_rakdnb].caption = "/"
SafeFreeslot("sfx_rakdnc")
sfxinfo[sfx_rakdnc].caption = "/"
SafeFreeslot("sfx_rakdnd")
sfxinfo[sfx_rakdnd].caption = "/"
SafeFreeslot("sfx_tactic")
sfxinfo[sfx_tactic].caption = "\x86...Tick\x80"
SafeFreeslot("sfx_tactoc")
sfxinfo[sfx_tactoc].caption = "\x86Tock...\x80"
SafeFreeslot("sfx_homrun")
sfxinfo[sfx_homrun] = {
	caption = "\x82HOMERUN!!!\x80",
	flags = SF_X4AWAYSOUND
}

SafeFreeslot("sfx_shgnl")
sfxinfo[sfx_shgnl].caption = "\x86Time to kick ass!\x80"
SafeFreeslot("sfx_shgns")
sfxinfo[sfx_shgns].caption = "\x85".."BLAMMO!!\x80"
--shotgun kill/detransfo
SafeFreeslot("sfx_shgnk")
sfxinfo[sfx_shgnk].caption = "/"
SafeFreeslot("sfx_tsplat")
sfxinfo[sfx_tsplat].caption = "\x82Splat!\x80"
SafeFreeslot("sfx_achern")
sfxinfo[sfx_achern] = {
	flags = SF_NOMULTIPLESOUND|SF_TOTALLYSINGLE,
	caption = "/"
}
SafeFreeslot("sfx_ptchkp")
sfxinfo[sfx_ptchkp] = {
	flags = SF_X2AWAYSOUND,
	caption = "\x82".."Combo Restored!\x80"
}
SafeFreeslot("sfx_sprcom")
sfxinfo[sfx_sprcom] = {
	flags = SF_X2AWAYSOUND,
	caption = "\x83".."Combo Regenerated\x80"
}
SafeFreeslot("sfx_sprcar")
sfxinfo[sfx_sprcar] = {
	flags = SF_X2AWAYSOUND,
	caption = "\x83".."Cards Regenerated\x80"
}
SafeFreeslot("sfx_didbad")
sfxinfo[sfx_didbad].caption = "/"
SafeFreeslot("sfx_fastfl")
sfxinfo[sfx_fastfl].caption = "/"
for i = 0, 9
	SafeFreeslot("sfx_tcmup"..i)
	sfxinfo[sfx_tcmup0 + i].caption = "\x83".."Combo up!\x80"
end
SafeFreeslot("sfx_tcmupa")
SafeFreeslot("sfx_tcmupb")
SafeFreeslot("sfx_tcmupc")
sfxinfo[sfx_tcmupa].caption = "\x83".."Combo up!\x80"
sfxinfo[sfx_tcmupb].caption = "\x83".."Combo up!\x80"
sfxinfo[sfx_tcmupc].caption = "\x83".."Combo up!\x80"

SafeFreeslot("sfx_shgnbs")
sfxinfo[sfx_shgnbs].caption = "Shoulder Bash"
SafeFreeslot("sfx_hrtcdt")
sfxinfo[sfx_hrtcdt] = {
	caption = "Tink",
	flags = SF_NOMULTIPLESOUND|SF_TOTALLYSINGLE,
}

--tb = textbox
--open
SafeFreeslot("sfx_tb_opn")
sfxinfo[sfx_tb_opn].caption = "/"
--close
SafeFreeslot("sfx_tb_cls")
sfxinfo[sfx_tb_cls].caption = "/"
--tween in
SafeFreeslot("sfx_tb_tin")
sfxinfo[sfx_tb_tin].caption = "/"
--tween out
SafeFreeslot("sfx_tb_tot")
sfxinfo[sfx_tb_tot].caption = "/"
SafeFreeslot("sfx_s_tak1")
sfxinfo[sfx_s_tak1].caption = "/"
SafeFreeslot("sfx_s_tak2")
sfxinfo[sfx_s_tak2].caption = "/"
SafeFreeslot("sfx_s_tak3")
sfxinfo[sfx_s_tak3].caption = "/"

SafeFreeslot("sfx_trnsfo")
sfxinfo[sfx_trnsfo].caption = "/"
SafeFreeslot("sfx_tknado")
sfxinfo[sfx_tknado].caption = "Tornado spin"
SafeFreeslot("sfx_tkfndo")
sfxinfo[sfx_tkfndo].caption = "Tornado spin!"

--spr_ freeslot

SafeFreeslot("spr_wdrg")
SafeFreeslot("SPR_SWET")
SafeFreeslot("SPR_STB1")
SafeFreeslot("SPR_STB2")
SafeFreeslot("SPR_STB3")
SafeFreeslot("SPR_STB4")
SafeFreeslot("SPR_STB5")
SafeFreeslot("SPR_TPTN")
--these are my own sprites so i am allowed to use them
SafeFreeslot("SPR_SHGN")
SafeFreeslot("SPR_CDST")
--i guess i can use this for the  hud now
SafeFreeslot("SPR_HTCD")
SafeFreeslot("SPR_CMBB")
SafeFreeslot("SPR_TNDE")
SafeFreeslot("SPR_RGDA") --ragdoll A
SafeFreeslot("SPR_THND")
SafeFreeslot("SPR_TVSG")
SafeFreeslot("SPR_TGIB")

--

--spr2 freeslot

SafeFreeslot("SPR2_TAKI")
SafeFreeslot("SPR2_TAK2")
SafeFreeslot("SPR2_TDED")
SafeFreeslot("SPR2_THUP")
spr2defaults[SPR2_THUP] = SPR2_STND
SafeFreeslot("SPR2_TDD2")
spr2defaults[SPR2_TDD2] = SPR2_TDED
SafeFreeslot("SPR2_SLID")
--happy hour face
SafeFreeslot("SPR2_HHF_")
SafeFreeslot("SPR2_SGBS")
SafeFreeslot("SPR2_SGST")
SafeFreeslot("SPR2_CLKB")
--PLACEHOLH
SafeFreeslot("SPR2_PLHD")
--fireass
SafeFreeslot("SPR2_FASS")
SafeFreeslot("SPR2_NADO")

--

--state freeslot

freeslot("S_PLAY_TAKIS_TORNADO")
states[S_PLAY_TAKIS_TORNADO] = {
    sprite = SPR_PLAY,
    frame = SPR2_NADO,
    tics = -1,
}

freeslot("S_PLAY_TAKIS_SHOULDERBASH")
states[S_PLAY_TAKIS_SHOULDERBASH] = {
    sprite = SPR_PLAY,
    frame = SPR2_PLHD, --SPR2_SGBS,
    tics = TR,
    nextstate = S_PLAY_STND
}
freeslot("S_PLAY_TAKIS_SHOULDERBASH_JUMP")
states[S_PLAY_TAKIS_SHOULDERBASH_JUMP] = {
    sprite = SPR_PLAY,
    frame = SPR2_PLHD, --SPR2_SGBS,
    tics = 4,
    nextstate = S_PLAY_TAKIS_SHOULDERBASH
}

freeslot("S_PLAY_TAKIS_SHOTGUNSTOMP")
states[S_PLAY_TAKIS_SHOTGUNSTOMP] = {
    sprite = SPR_PLAY,
    frame = A|FF_ANIMATE|SPR2_SGST,
    tics = -1,
    nextstate = S_PLAY_STND
}
freeslot("S_PLAY_TAKIS_KILLBASH")
states[S_PLAY_TAKIS_KILLBASH] = {
    sprite = SPR_PLAY,
    frame = SPR2_PLHD, --SPR2_CLKB,
    tics = 12,
    nextstate = S_PLAY_FALL
}


freeslot("S_PLAY_TAKIS_SMUGASSGRIN")
states[S_PLAY_TAKIS_SMUGASSGRIN] = {
    sprite = SPR_PLAY,
    frame = SPR2_TAKI,
    tics = -1,
    nextstate = S_PLAY_STND
}
freeslot("S_PLAY_TAKIS_SMUGASSGRIN2")
states[S_PLAY_TAKIS_SMUGASSGRIN2] = {
    sprite = SPR_PLAY,
    frame = SPR2_TAK2,
    tics = -1,
    nextstate = S_PLAY_STND
}

freeslot("S_TAKIS_SWEAT1")
freeslot("S_TAKIS_SWEAT2")
freeslot("S_TAKIS_SWEAT3")
freeslot("S_TAKIS_SWEAT4")
states[S_TAKIS_SWEAT1] = {
    --sprite = SPR_RING,
	sprite = SPR_SWET,
    frame = A|FF_ANIMATE,
	var1 = 6,
	var2 = 2,
	tics = 6*2,
    nextstate = S_TAKIS_SWEAT2
}
states[S_TAKIS_SWEAT2] = {
	sprite = SPR_SWET,
    frame = G|FF_ANIMATE,
	var1 = 2,
	var2 = 2,
	tics = 2*2,
    nextstate = S_TAKIS_SWEAT3
}
states[S_TAKIS_SWEAT3] = {
	sprite = SPR_SWET,
    frame = I|FF_ANIMATE,
	var1 = 6,
 	var2 = 2,
	tics = 6*2,
    nextstate = S_TAKIS_SWEAT4
}
states[S_TAKIS_SWEAT4] = {
	sprite = SPR_SWET,
    frame = O|FF_ANIMATE,
	var1 = 2,
	var2 = 2,
	tics = 2*2,
    nextstate = S_TAKIS_SWEAT1
}

--jeez
SafeFreeslot("S_SOAP_SUPERTAUNT_FLYINGBOLT1")
SafeFreeslot("S_SOAP_SUPERTAUNT_FLYINGBOLT2")
SafeFreeslot("S_SOAP_SUPERTAUNT_FLYINGBOLT3")
SafeFreeslot("S_SOAP_SUPERTAUNT_FLYINGBOLT4")
SafeFreeslot("S_SOAP_SUPERTAUNT_FLYINGBOLT5")

states[S_SOAP_SUPERTAUNT_FLYINGBOLT1] = {
	sprite = SPR_STB1,
	frame = FF_PAPERSPRITE|FF_ANIMATE,
	var1 = 4,
	var2 = 2,
	tics = 4*2
}
states[S_SOAP_SUPERTAUNT_FLYINGBOLT2] = {
	sprite = SPR_STB2,
	frame = FF_PAPERSPRITE|FF_ANIMATE,
	tics = 4*2,
	var1 = 4,
	var2 = 2
}
states[S_SOAP_SUPERTAUNT_FLYINGBOLT3] = {
	sprite = SPR_STB3,
	frame = FF_PAPERSPRITE|FF_ANIMATE,
	var1 = 4,
	var2 = 2,
	tics = 4*2
}
states[S_SOAP_SUPERTAUNT_FLYINGBOLT4] = {
	sprite = SPR_STB4,
	frame = FF_PAPERSPRITE|FF_ANIMATE,
	tics = 4*2,
	var1 = 4,
	var2 = 2
}
states[S_SOAP_SUPERTAUNT_FLYINGBOLT5] = {
	sprite = SPR_STB5,
	frame = FF_PAPERSPRITE|FF_ANIMATE,
	tics = 4*2,
	var1 = 4,
	var2 = 2
}

freeslot("S_PLAY_TAKIS_SLIDE")
states[S_PLAY_TAKIS_SLIDE] = {
    sprite = SPR_PLAY,
    frame = SPR2_SLID,
    --var1 = 2,
	--var2 = 2,
	tics = -1,
    nextstate = S_PLAY_STND
}

freeslot("S_TAKIS_TAUNT_JOIN")
states[S_TAKIS_TAUNT_JOIN] = {
	sprite = SPR_TPTN,
	frame = A|FF_FULLBRIGHT,
	tics = 6,
	nextstate = S_NULL
}

freeslot("S_PLAY_TAKIS_CONGA")
states[S_PLAY_TAKIS_CONGA] = {
    sprite = SPR_PLAY,
    frame = SPR2_WALK|A|FF_ANIMATE,
    var1 = 8,
	var2 = 1,
	tics = -1,
    nextstate = S_PLAY_TAKIS_CONGA
}

freeslot("S_TAKIS_SHOTGUN")
states[S_TAKIS_SHOTGUN] = {
	sprite = SPR_SHGN,
	frame = A,
	tics = -1,
}

/*
freeslot("S_TAKIS_SHOTGUN_HITBOX")
states[S_TAKIS_SHOTGUN_HITBOX] = {
	sprite = SPR_RING,
	frame = A,
	tics = -1,
}
*/

freeslot("S_TAKIS_CLUTCHDUST")
states[S_TAKIS_CLUTCHDUST] = {
	sprite = SPR_CDST,
	frame = A|FF_PAPERSPRITE|FF_ANIMATE,
	var1 = 6,
	var2 = 2,
	tics = 6*2,
}

freeslot("S_TAKIS_DRILLEFFECT")
states[S_TAKIS_DRILLEFFECT] = {
    sprite = SPR_TNDE,
    frame = FF_PAPERSPRITE|FF_ANIMATE,
	var1 = 5,
	var2 = 2,
	tics = 5*2,
    nextstate = S_TAKIS_DRILLEFFECT
}

freeslot("S_TAKIS_BADNIK_RAGDOLL_A")
states[S_TAKIS_BADNIK_RAGDOLL_A] = {
    sprite = SPR_RGDA,
    frame = A|FF_ANIMATE,
	var1 = 1,
	var2 = 2,
	tics = (1*2)*20,
}

freeslot("S_TAKIS_HEARTCARD_SPIN")
states[S_TAKIS_HEARTCARD_SPIN] = {
    sprite = SPR_HTCD,
    frame = A|FF_PAPERSPRITE,
	tics = TAKIS_MAX_HEARTCARD_FUSE,
}

--

--mobj freeslot

--i would like to make these last forever like banjo, but
--server sustainability comes first!
freeslot("MT_TAKIS_HEARTCARD")
mobjinfo[MT_TAKIS_HEARTCARD] = {
	--$Name Heartcard
	--$Sprite HTCDALAR
	--$Category Takis Stuff
	--$Flags8Text No Gravity
	doomednum = 3003,
	spawnstate = S_TAKIS_HEARTCARD_SPIN,
	spawnhealth = 1000,
	height = 50*FRACUNIT,
	radius = 25*FRACUNIT,
	flags = MF_SLIDEME|MF_SPECIAL
}

freeslot("MT_TAKIS_DRILLEFFECT")
mobjinfo[MT_TAKIS_DRILLEFFECT] = {
	doomednum = -1,
	spawnstate = S_TAKIS_DRILLEFFECT,
	height = 60*FRACUNIT,
	radius = 35*FRACUNIT,
	flags = MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOGRAVITY|MF_SOLID
}

freeslot("MT_TAKIS_AFTERIMAGE")

mobjinfo[MT_TAKIS_AFTERIMAGE] = {
	doomednum = -1,
	spawnstate = S_PLAY_WAIT,
	radius = 12*FRACUNIT,
	height = 10*FRACUNIT,
	flags = MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOGRAVITY|MF_NOBLOCKMAP	
}

freeslot("MT_WINDRINGLOL")
freeslot("S_SOAPYWINDRINGLOL")

--Wallbounce ring effect object
mobjinfo[MT_WINDRINGLOL] = {
	doomednum = -1,
	spawnstate = S_SOAPYWINDRINGLOL,
	flags = MF_NOCLIP|MF_NOCLIPHEIGHT|MF_SCENERY|MF_NOGRAVITY
}
states[S_SOAPYWINDRINGLOL] = {
	sprite = SPR_WDRG,
	tics = -1,
	frame = TR_TRANS10|FF_PAPERSPRITE|A
}

freeslot("MT_TAKIS_HAMMERHITBOX")
freeslot("S_TAKIS_HAMMERHITBOX")
mobjinfo[MT_TAKIS_HAMMERHITBOX] = {
	doomednum = -1,
	spawnstate = S_TAKIS_HAMMERHITBOX,
	height = 60*FRACUNIT,
	radius = 20*FRACUNIT,
	flags = MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOGRAVITY|MF_SOLID
}
states[S_TAKIS_HAMMERHITBOX] = {
	sprite = SPR_RING,
	frame = A
}

freeslot("MT_TAKIS_BADNIK_RAGDOLL")
mobjinfo[MT_TAKIS_BADNIK_RAGDOLL] = {
	doomednum = -1,
	spawnstate = S_PLAY_WAIT,
	deathstate = S_XPLD1,
	height = 25*FRACUNIT,
	radius = 25*FRACUNIT,
}

freeslot("MT_TAKIS_SWEAT")
mobjinfo[MT_TAKIS_SWEAT] = {
	doomednum = -1,
	spawnstate = S_TAKIS_SWEAT1,
	height = 5*FRACUNIT,
	radius = 5*FRACUNIT,
	flags = MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOGRAVITY

}

freeslot("MT_TAKIS_TAUNT_JOIN")
mobjinfo[MT_TAKIS_TAUNT_JOIN] = {
	doomednum = -1,
	spawnstate = S_TAKIS_TAUNT_JOIN,
	height = 5*FRACUNIT,
	radius = 5*FRACUNIT,
	flags = MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOGRAVITY

}

SafeFreeslot("MT_SOAP_SUPERTAUNT_FLYINGBOLT")
mobjinfo[MT_SOAP_SUPERTAUNT_FLYINGBOLT] = {
	doomednum = -1,
	spawnstate = S_SOAP_SUPERTAUNT_FLYINGBOLT1,
	flags = MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOGRAVITY
}

freeslot("MT_TAKIS_DEADBODY")
mobjinfo[MT_TAKIS_DEADBODY] = {
	doomednum = -1,
	spawnstate = S_NULL,
	--mt_playuer
	flags = MF_NOCLIP|MF_SLIDEME|MF_NOCLIPTHING|MF_NOGRAVITY,
	height = 16*FRACUNIT,
	radius = 26*FRACUNIT,
}

freeslot("MT_TAKIS_SHOTGUN")
mobjinfo[MT_TAKIS_SHOTGUN] = {
	doomednum = -1,
	spawnstate = S_TAKIS_SHOTGUN,
	--mt_playuer
	flags = MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOCLIPTHING|MF_NOGRAVITY,
	height = 5*FRACUNIT,
	radius = 5*FRACUNIT,
}

freeslot("MT_TAKIS_CLUTCHDUST")
mobjinfo[MT_TAKIS_CLUTCHDUST] = {
	doomednum = -1,
	spawnstate = S_TAKIS_CLUTCHDUST,
	flags = MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOCLIPTHING|MF_NOGRAVITY,
	height = 5*FRACUNIT,
	radius = 5*FRACUNIT,
}

freeslot("MT_TAKIS_BADNIK_RAGDOLL_A")
mobjinfo[MT_TAKIS_BADNIK_RAGDOLL_A] = {
	doomednum = -1,
	spawnstate = S_TAKIS_BADNIK_RAGDOLL_A,
	flags = MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOCLIPTHING|MF_NOGRAVITY,
	height = 5*FRACUNIT,
	radius = 5*FRACUNIT,
}

function A_ShotgunBox(mo)
	local gun = P_SpawnMobjFromMobj(mo,0,0,0,MT_TAKIS_SHOTGUN)
	gun.dropped = true
	local oldscale = gun.scale
	gun.scale = $/20
	P_SetObjectMomZ(gun,4*FU)
	gun.destscale = oldscale
	
	if mo.info.seesound
		local g = P_SpawnGhostMobj(mo)
		g.tics = -1
		g.flags2 = $|MF2_DONTDRAW
		g.fuse = TR
		S_StartSound(g,mo.info.seesound)
	end
	
end

freeslot("S_SHOTGUN_BOX")
states[S_SHOTGUN_BOX] = {
	sprite = SPR_TVSG,
	frame = A,
	tics = 2,
	nextstate = S_BOX_FLICKER
}
freeslot("S_SHOTGUN_ICON1")
freeslot("S_SHOTGUN_ICON2")
states[S_SHOTGUN_ICON1] = {
	sprite = SPR_TVSG,
	frame = FF_ANIMATE|C,
	tics = 18,
	var1 = 3,
	var2 = 4,
	nextstate = S_SHOTGUN_ICON2
}
states[S_SHOTGUN_ICON2] = {
	sprite = SPR_TVSG,
	frame = C,
	tics = 18,
	action = A_ShotgunBox,
	nextstate = S_NULL
}

freeslot("MT_SHOTGUN_BOX")
freeslot("MT_SHOTGUN_ICON")
mobjinfo[MT_SHOTGUN_BOX] = {
	--$Name Shotgun Box
	--$Sprite TVSGA0
	--$Category Takis Stuff
	doomednum = 3002,
	spawnstate = S_SHOTGUN_BOX,
	painstate = S_SHOTGUN_BOX,
	deathstate = S_BOX_POP1,
	deathsound = sfx_pop,
	reactiontime = 8,
	speed = 1,
	damage = MT_SHOTGUN_ICON,
	mass = 100,
	flags = MF_SOLID|MF_SHOOTABLE|MF_MONITOR,
	height = 40*FRACUNIT,
	radius = 18*FRACUNIT,
}
mobjinfo[MT_SHOTGUN_ICON] = {
	doomednum = -1,
	spawnstate = S_SHOTGUN_ICON1,
	seesound = sfx_ncitem,
	reactiontime = 10,
	speed = 2*FRACUNIT,
	damage = 62*FRACUNIT,
	mass = 100,
	flags = MF_NOBLOCKMAP|MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY|MF_BOXICON,
	height = 14*FRACUNIT,
	radius = 8*FRACUNIT,
}

/*
freeslot("MT_TAKIS_SHOTGUN_HITBOX")
mobjinfo[MT_TAKIS_SHOTGUN_HITBOX] = {
	doomednum = -1,
	spawnstate = S_TAKIS_SHOTGUN_HITBOX,
	--mt_playuer
	flags = MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOGRAVITY|MF_SOLID,
	height = 60*FU,
	radius = 60*FU,
}
*/
freeslot("S_TAKIS_FLINGSOLID")
freeslot("MT_TAKIS_FLINGSOLID")
states[S_TAKIS_FLINGSOLID] = {
	sprite = SPR_TVSG,
	frame = A,
	tics = 5*TR,
}
mobjinfo[MT_TAKIS_FLINGSOLID] = {
	doomednum = -1,
	spawnstate = S_TAKIS_FLINGSOLID,
	flags = MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOCLIPTHING,
	height = 14*FRACUNIT,
	radius = 8*FRACUNIT,
}

freeslot("S_TAKIS_GIB")
freeslot("MT_TAKIS_GIB")
states[S_TAKIS_GIB] = {
	sprite = SPR_TGIB,
	frame = A,
	tics = 3*TR,
}
mobjinfo[MT_TAKIS_GIB] = {
	doomednum = -1,
	spawnstate = S_TAKIS_GIB,
	flags = MF_SLIDEME|MF_NOCLIPTHING,
	height = 4*FRACUNIT,
	radius = 4*FRACUNIT,
}

addHook("NetVars",function(n)
	TAKIS_NET = n($)
	/*
	for k,v in ipairs(netsynchlist)
		TAKIS_NET[k] = n($)
	end
	*/
	
	TAKIS_MAX_HEARTCARDS = n($)
	--TAKIS_DEBUGFLAG = n($)
	SPIKE_LIST = n($)
	local hhsync = {
		"happyhour",
		"timelimit",
		"timeleft",
		"time",
		"othergt",
		"overtime",
		"trigger",
		"exit",
		"gameover",
		"gameovertics",
		"song",
		"songend",
		"nosong",
		"noendsong",
	}
	for _,v in ipairs(hhsync)
		HAPPY_HOUR[v] = n($)
	end
end)

filesdone = $+1
