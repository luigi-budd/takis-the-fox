--Funny init

--welcome to sonic robo blast 2.
--after 40 years in development, hopefully it will be worth the wait.
--thanks, and have fun.

--specki is not takis, and takis is not specki!!

/*
	SPECIAL THANKS/CONTRIBUTORS
	
	-dashdahog - takis' sprites inspiration. I LOVE TAILEELS!!!
	-Jisk - jelped jith jome jode
	-Unmatched Bracket - waterslide pain -> sliding code, compiling code
	-katsy - bounce sector detection
	-Banddy - metal sonic boss portrait, tested hh things mapheader positions
	-Marilyn - final demo cutscene i used lol, kart bump code
	-nicholas rickys (saxashitter) - helped me with some code in sharecombos
	
	CODE I STOLE (from reusable mods)
	-SMSReborn - IO code
	-CustomHud Lib - customhud lib duhhh
	-Clone Fighter's Textbox Engine - slightly modified to be more
									  banjo kazooie (also linedef
									  triggers)
	-NiGHTS Freeroam - ok this isnt reusable but buggie asked me to put it in
	-ChrispyChars - some code used for confetti, safefreeslot code
	-MinHUD - some hud functions i used
	-ffoxD's Momentum mod - momentum used in takis
	
	SOME MORE STUFF I STOLE
	-Antonblast - sound effects, music, sprites
	-Pizza Tower - sound effects
	-Team Fortress 2 - sound effects, music
	-SRB2Kart - engine & drifting sound effects
	-Hill Climb Racing - low fuel beep
	
	some functions were also taken from here
	https://wiki.srb2.org/wiki/User:Clairebun/Sandbox/Common_Lua_Functions
	
	shhhhooould be all, if i missed any LET ME KNOW SO I CAN CREDIT THEM!!!
*/

local constlist = {}

local pnk = "\x8E"
local wht = "\x80"

rawset(_G, "TR", TICRATE)
table.insert(constlist,{"TR",TICRATE})

rawset(_G, "TAKIS_ISDEBUG", true)
table.insert(constlist,{"TAKIS_ISDEBUG",true})

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
	"HURTMSG",
	"BOSSCARD",
	"NET",
}
for k,v in ipairs(dbgflags)
	local val = 1<<(k-1)
	assert(val ~= -1,"\x85Ran out of bits for DEBUG_! (k="..k..")\x80")
	rawset(_G,"DEBUG_"..v,val)
	print("Enummed DEBUG_"..v.." ("..val..")")
	table.insert(constlist,{"DEBUG_"..v,val})
end

--these arent really used so theres no point in verifying these
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

rawset(_G, "TAKIS_MAX_HEARTCARDS", 6)

rawset(_G, "TAKIS_MAX_HEARTCARD_FUSE", 30*TR)
table.insert(constlist,{"TAKIS_MAX_HEARTCARD_FUSE",30*TR})

rawset(_G, "TAKIS_HEARTCARDS_SHAKETIME", 17)
table.insert(constlist,{"TAKIS_HEARTCARDS_SHAKETIME",17})

rawset(_G, "TAKIS_MAX_COMBOTIME", 7*TR)
table.insert(constlist,{"TAKIS_MAX_COMBOTIME",7*TR})

rawset(_G, "TAKIS_PART_COMBOTIME", 4*TR/5)
table.insert(constlist,{"TAKIS_PART_COMBOTIME",4*TR/5})

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
table.insert(constlist,{"TAKIS_COMBO_UP",5})

rawset(_G, "TAKIS_HAPPYHOURFONT", "TAHRF")
table.insert(constlist,{"TAKIS_HAPPYHOURFONT","TAHRF"})

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
	local val = k-1
	rawset(_G,"HURTMSG_"..v,val)
	print("Enummed HURTMSG_"..v.." ("..val..")")
	table.insert(constlist,{"HURTMSG_"..v,val})
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
	"AFTERIMAGE",	--i wouldnt really call afterimages an ability
}
for k,v in ipairs(noabflags)
	local val = 1<<(k-1)
	rawset(_G,"NOABIL_"..v,val)
	print("Enummed NOABIL_"..v.." ("..val..")")
	table.insert(constlist,{"NOABIL_"..v,val})
end
--anything that uses spin
rawset(_G,"NOABIL_SPIN",NOABIL_CLUTCH|NOABIL_HAMMER|NOABIL_SHOTGUN|NOABIL_WAVEDASH)
table.insert(constlist,{"NOABIL_SPIN",NOABIL_CLUTCH|NOABIL_HAMMER|NOABIL_SHOTGUN|NOABIL_WAVEDASH})

--i dont *think* i should put thok in here, but that might change
rawset(_G,"NOABIL_ALL",NOABIL_SPIN|NOABIL_SLIDE|NOABIL_SHIELD|NOABIL_DIVE)
table.insert(constlist,{"NOABIL_ALL",NOABIL_SPIN|NOABIL_SLIDE|NOABIL_SHIELD|NOABIL_DIVE})

local transfoenum = {
	"SHOTGUN",
	"PANCAKE",
	"BALL",
	"ELEC",
	"TORNADO",
	"FIREASS",
	"KART",
}
for k,v in ipairs(transfoenum)
	local val = 1<<(k-1)
	rawset(_G,"TRANSFO_"..v,val)
	print("Enummed TRANSFO_"..v.." ("..val..")")
	table.insert(constlist,{"TRANSFO_"..v,val})
end

rawset(_G,"CR_TAKISKART",20)
table.insert(constlist,{"CR_TAKISKART",20})

--spike stuff according tro source
-- https://github.com/STJr/SRB2/blob/a4a3b5b0944720a536a94c9d471b64c822cdac61/src/p_map.c#L838
rawset(_G, "SPIKE_LIST", {
	[MT_SPIKE] = true,
	[MT_WALLSPIKE] = true,
	[MT_SPIKEBALL] = true,
	[MT_BOMBSPHERE] = true,
})

--these arent really synched anymore but keeping the old name
--so stuff doesnt break
rawset(_G, "TAKIS_NET", {
	
	nerfarma = false,
	tauntkillsenabled = true,
	noachs = false, --dont let players get achs in netgames
	collaterals = true, --let ragdolls kill other ragdolls
	cards = true, --only spawn heartcards if this is true
	hammerquakes = true,
	chaingun = false,
	--happytime = false,
	
	usedcheats = false,
	
})

--everything else that was in TAKIS_NET is now in here
rawset(_G,"TAKIS_MISC",{
	inspecialstage = false,
	inbossmap = false,
	inbrakmap = false,
	isretro = 0,
	
	exitingcount = 0,
	playercount = 0,
	takiscount = 0,
	livescount = 0,
	maxpostcount = 0,
	
	numdestroyables = 0,
	partdestroy = 0,
	
	ideyadrones = {},
	
	inttic = 0,
	stagefailed = true,
	cardbump = 0,
	
	scoreboard = {},
	
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
		["blstcl"] = true,
		["brdwrd"] = true,
		--spice runers
		["ovrtme"] = true,
		["ovrtm2"] = true,
		["rnk_a"] = true,
		["rnk_cb"] = true,
		["rnk_d"] = true,
		["rnk_p"] = true,
		["rnk_s"] = true,
		["p_int"] = true,
		["ot_ph"] = true,
	},
	
	inescapable = {
		--vanilla
		["techno hill zone 1"] = true,
		["techno hill zone 2"] = true,
		["deep sea zone 1"] = true,
		["deep sea zone 2"] = true,
		["castle eggman zone 1"] = true,
		["red volcano zone 1"] = true,
		["egg rock zone 1"] = true,
		["black core zone 1"] = true,
		["pipe towers zone"] = true,
		["haunted heights zone"] = true,
		-- do you REALLY wanna back track these 2?
		["aerial garden zone"] = true,
		["azure temple zone"] = true,
		
		--oldc shit
		["hub"] = true,
		["hell coaster zone 1"] = true,
		--this stage kinda already has an escape sequence
		--of its own
		["festung oder so"] = true,
		["spiral hill pizza"] = true,
		["magma mountain 1"] = true,
		["hanging illusion"] = true,
		["hexacolor heaven"] = true,
		["null space"] = true,
		
		--tortured planet
		--stage locks you out of any backtracking routes
		["eruption conduit 2"] = true,
		["snowcap nimbus 1"] = true,
		["snowcap nimbus 2"] = true,
		
		--the past
		["srb2 museum zone"] = true,
	},
})

rawset(_G,"TAKIS_BOSSCARDS",{
	--titlecard stuff
	bossnames = {
		-- Vanilla SRB2
		[MT_EGGMOBILE] = "Egg Zapper",
		[MT_EGGMOBILE2] = "Egg Slimer",
		[MT_EGGMOBILE3] = "Sea Egg",
		--this is the longest a name can be on a green res
		[MT_EGGMOBILE4] = "E. Colosseum",
		[MT_FANG] = "Fang",
		[MT_METALSONIC_BATTLE] = "Metal Sonic",
		[MT_CYBRAKDEMON] = "Brak Eggman",
		[MT_BLACKEGGMAN] = "Brak Eggman",
	},
	addonbosses = {
		--mrce
		MT_FBOSS = "Egg Fighter",
		MT_FBOSS2 = "Egg Fighter",
		MT_XBOSS2 = "Egg Mobile",
		MT_EGGANIMUS = "Egg Animus",
		MT_EGGANIMUS_EX = "Egg Animus",
		MT_EGGBALLER = "Fireballer",
		MT_EGGFREEZER = "Egg Freezer",
		MT_EGGEBOMBER = "E-Bomber",
		
		--characters
		MT_SONIC = "Sonic",
		MT_TAILS = "Tails",
		MT_KNUCKLES = "Knuckles",
		MT_AMY = "Amy Rose",
		MT_SHADOW = "Shadow",
		MT_SILVER = "Silver",
		
		-- Misc levels
		/*
		MT_EGGMOBILE7 = "Egg Boiler",
		MT_BOSSRIDE = "Player", -- this one never gets used, included anyway to tell the game you have it loaded
		
		--true arena stuff
		MT_GREENHILLBOSS = "Ball & Chain",
		MT_EGGOFLAMER = "Egg Flambe",
		MT_EGGOFLAMERB = "Beta Flambe",
		MT_STRAYBOLTS_BOSS = "Stray-Bolts",
		MT_THOKBOSS = "Thok",
		MT_SANDSUB_326 = "Sand Sub",
		MT_OLDK = "Ugly Knux",
		MT_FROSTBURN = "Frostburn",
		MT_EGGZAP = "Egg Zap",
		MT_REKNUCKLES = "Knuckles",
		MT_SUPERHOOD = "Robo-Hood",
		MT_ANASTASIA = "Anastasia",
		MT_INFINITE_318 = "Infinite",
		*/
		
		--specki
		MT_AGGROMANEN = "Aggromobile",
		MT_AGGROPAINTER = "Aggropainter",
	},
	
	nobosscards = {},
	noaddonbosscards = {
		MT_FACCIOLO_BOSS = true,
		
		MT_GREENHILLBOSS = true,
		MT_EGGOFLAMER = true,
		MT_EGGOFLAMERB = true,
		MT_STRAYBOLTS_BOSS = true,
		MT_THOKBOSS = true,
		MT_SANDSUB_326 = true,
		MT_OLDK = true,
		MT_FROSTBURN = true,
		MT_EGGZAP = true,
		MT_REKNUCKLES = true,
		MT_ROBOHOOD_MINIBOSS = true,
		MT_SUPERHOOD = true,
		MT_ANASTASIA = true,
		MT_INFINITE_318 = true,
		
		MT_PIZZA_ENEMY = true,
		MT_ALIVEDUSTDEVIL = true,
		MT_PT_JUGGERNAUTCROWN = true,
	},
	
	bossprefix = {
		[MT_EGGMOBILE] = "EGG",
		[MT_EGGMOBILE2] = "EGG",
		[MT_EGGMOBILE3] = "EGG",
		[MT_EGGMOBILE4] = "EGG",
		[MT_FANG] = "FNG",
		[MT_METALSONIC_BATTLE] = "MSN",
		[MT_CYBRAKDEMON] = "BRK",
		[MT_BLACKEGGMAN] = "BRK",
	},
	addonbossprefix = {
		--mrce
		MT_FBOSS = "EGG",
		MT_FBOSS2 = "EGG",
		MT_XBOSS2 = "EGG",
		MT_EGGANIMUS = "EGG",
		MT_EGGANIMUS_EX = "EGG",
		MT_EGGBALLER = "EGG",
		MT_EGGFREEZER = "EGG",
		MT_EGGEBOMBER = "EGG",
		MT_SANDSUB_326 = "EGG",
		MT_GREENHILLBOSS = "EGG",
		MT_EGGMOBILE7 = "EGG",
		
		--true arena
		/*
		MT_GREENHILLBOSS = "EGG",
		MT_EGGOFLAMER = "EGG",
		MT_EGGOFLAMERB = "EGG",
		MT_SANDSUB_326 = "EGG",
		MT_FROSTBURN = "EGG",
		MT_EGGZAP = "EGG",
		*/
	},
})

rawset(_G, "TAKIS_HAMMERDISP", FixedMul(52*FU,9*FU/10))
table.insert(constlist,{"TAKIS_HAMMERDISP",FixedMul(52*FU,9*FU/10)})

SafeFreeslot("MT_TAKIS_TAUNT_HITBOX")
SafeFreeslot("S_TAKIS_TAUNT_HITBOX")
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
		prevz = 0,
		lastrank = 1,
		lastmomz = 0,
		lastlives = p.lives,
		oldlives = p.lives,
		recovwait = 0,
		dropdashstale = 0,
		dropdashstaletime = 0,
		lastmap = 1,
		lastgt = 0,
		lastskincolor = 0,
		lastdestroyed = 0,
		lastemeralds = 0,
		lastss = 0,
		lastpos = {x=p.realmo.x,y=p.realmo.y,z=p.realmo.z},
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
		bashcooldown = false,
		pizzastate = 0,
		deathfloored = false,
		pancaketime = 0,
		electime = 0,
		hhexiting = false,
		crushscale = FU/3,
		prevz = 0,
		ballretain = 0,
		timeshit = 0,
		totalshit = 0,
		spiritlist = {},
		fireasssmoke = 0,
		fireasstime = 0,
		fireballtime = 0,
		starman = false,
		coyote = 5,
		trophy = 0,
		gotemeralds = 0,
		emeraldcutscene = 0,
		firethokked = false, --fireass 3rd jump
		lastminhud = nil,
		placement = 0,
		lastplacement = 0,
		lastgroundedpos = {},
		lastgroundedangle = 0,
		ropeletgo = 0,
		pitanim = 0,
		pitfunny = false,
		lastcarry = 0,
		
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
		--uses taunt ids
		--these are actually io but they arent in the io table :trol:
		tauntquick1 = 0,
		tauntquick2 = 0,
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
			pacifist = true,
			
			failcount = 0,
			failtics = 0,
			failrank = 0,
			
			--anim stuff
			introtics = 0,
			outrotics = 0,
			outrotointro = 0,
			frozen = false,
			slidein = 0,
			slidetime = 0,
		},
		io = {
			hasfile = false,
			loaded = false,
			loadwait = 25,
			loadedach = false,
			
			nostrafe = 0,
			nohappyhour = 0,
			morehappyhour = 0,
			tmcursorstyle = 1, --taunt menu cursor style, 1 for nums, 2 for cursor
			quakes = 1,
			flashes = 1,
			additiveai = 1,
			clutchstyle = 1, --0 for bar, 1 for meter
			sharecombos = 1,
			dontshowach = 0, --1 to not show ach messages
			minhud = 0, --guess what this one does, you wont believe it
		},
		--tf2 taunt menu lol
		--up to 7 taunts, detected with BT_WEAPONMASK
		tauntmenu = {
			open = false,
			closingtime = 0,
			yadd = 500*FU,
			tictime = 0,
			list = {
				--this is stupid, maybe i can use tables
				--and draw each line seperately
				[1] = "Ouchy \nOuch!",
				[2] = "Smugness",
				[3] = "Conga",
				[4] = "Home-run\n     Bat",
				[5] = "Bird\nWord!",
				[6] = "Yeah!",
			},
			--1-7 x pos
			cursor = 1,
			gfx = {
				--the associated taunt icon for each taunt
				--MUST BE HUD PATCHES!!
				pix = {
					[1] = "TAUNTPIX_PAIN",	
					[2] = "TAUNTPIX_SMUG",	
					[3] = "TAUNTPIX_CONG",	
					[4] = "TAUNTPIX_HRBT",	
					[5] = "TAUNTPIX_BIRD",	
					[6] = "TAUNTPIX_YEAH",	
				},
				--fixed point scales
				scales = {
					[1] = FU/2,
					[2] = FU/2,
					[3] = FU/2,
					[4] = FU/2,
					[5] = FU/2,
					[6] = FU/2,
				},
			},
			--text x offsets
			xoffsets = {
				[1] = 11,
				[4] = 12,
				[5] = 9,
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
			
			achcur = 0,
			achpage = 0,
			
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
				text = "\x82Ultimate Combo\x80"
			},
			["happyhour"] = {
				tics = 0, 
				score = 0,
				text = "\x85Happy Hour trigger\x80"
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
		/*
		hitlag = {
			tics = 0,
			speed = 0,
			momz = 0,
			angle = 0,
			frame = 0,
			sprite2 = 0,
			pflags = 0,
		},
		*/
		
		shotgunned = false,
		--the shotgun mobj
		shotgun = 0,
		shotguncooldown = 0,
		shotguntime = 0,
		timesincelastshot = 0,
		shotguntuttic = 0,
		shotgunforceon = false,
		
		--bools
		--booleans
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
		isSuper = false,
		isAngry = false,
		inBattle = false,
		
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
			useplacements = false,
			lives = {
				tweenx = -55*FU,
				tweentic = 5*TR,
				tweenwait = TR*3/2,
				bump = 0,
			},
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
				
				--spinning anim
				spintics = 0,
				oldhp = 0,
				hpdiff = 0,
			},
			rings = {
				FIXED = {19*FU, 56*FU},
				int = {117, 43}
			},
			--timer has 2 different sets for spectator and when finished
			--you can tell this was way before i knew how to align
			--hud stuff....
			timer = {
				text = 14,
				int = {117, 60},		
				spectator = {90-(13*6)+75+15 +15,(62-6)+20+24},
				finished = {90-(13*6)+75+15 +15,(62-6)+20},
			},
			combo = {
				basex = 15*FU,
				x = 15*FU,
				basey = 70*FU,
				y = 70*FU,
				momx = 0,
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
				scorenum = p.score,
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
				wega = false,
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
			bosscards = {
				maxcards = 0,
				nocards = false,
				cards = 0,
				cardshake = 0,
				mo = 0,
				name = '',
				statusface = {
					priority = 0,
					state = "IDLE",
					frame = 0,
				},
			},
			bosstitle = {
				tic = 0,
				mom = 0,
				takis = {
					100,60
				},
				egg = {
					200,140
				},
				--x only
				vs = {
					160-19,
					160,
				},
				
				basetakis = {
					100,60
				},
				baseegg = {
					200,140
				},
				--x only
				basevs = {
					160-19,
					160,
				}
			},
			comboshare = {
				--indexing every player node
				/*
				[0] = serfver
				[4] = pnode 4
				and whatnot
				*/
				/*
					p = 0,
					comboadd = 0,
					tics = 0,
					x = 0,
					y = 0,
				*/
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
	takis_printdebuginfo(p)
	
	if P_RandomChance(FU/2)
		CONS_Printf(p, "\n"+"\x82"+"Look for the Gummy Bear album in stores on November 13th. ")
	end
	return true
end)

SafeFreeslot("sfx_clutch")
sfxinfo[sfx_clutch].caption = "Clutch Boost"
SafeFreeslot("sfx_cltch2")
sfxinfo[sfx_cltch2].caption = "Clutch Boost"

SafeFreeslot("sfx_taksld")
sfxinfo[sfx_taksld].caption = "Slide"

--takis vox
SafeFreeslot("sfx_eeugh")
sfxinfo[sfx_eeugh].caption = '\x8F"Ehh!"\x80'
SafeFreeslot("sfx_antow1")
sfxinfo[sfx_antow1].caption = '\x8F"Aah!!"\x80'
SafeFreeslot("sfx_antow2")
sfxinfo[sfx_antow2].caption = '\x8F"Eargh!"\x80'
SafeFreeslot("sfx_antow3")
sfxinfo[sfx_antow3].caption = '\x8F"Grr!"\x80'
SafeFreeslot("sfx_antow4")
sfxinfo[sfx_antow4].caption = '\x8F"Hey, hey!"\x80'
SafeFreeslot("sfx_antow5")
sfxinfo[sfx_antow5].caption = '\x8F"Oh boy!"\x80'
SafeFreeslot("sfx_antow6")
sfxinfo[sfx_antow6].caption = '\x8F"WOW! Eheh!"\x80'
SafeFreeslot("sfx_antow7")
sfxinfo[sfx_antow7].caption = '\x8F"W-w-w-w I\'m good!"\x80'
SafeFreeslot("sfx_antwi1")
sfxinfo[sfx_antwi1].caption = "Strange laughing"
SafeFreeslot("sfx_antwi2")
sfxinfo[sfx_antwi2].caption = '\x8F"Ha!"\x80'
SafeFreeslot("sfx_antwi3")
sfxinfo[sfx_antwi3].caption = '\x8F"Ha-ha ha ha!"\x80'
SafeFreeslot("sfx_tayeah")
sfxinfo[sfx_tayeah].caption = '\x8F"Yyyeahh!"\x80'
SafeFreeslot("sfx_hapyhr")
sfxinfo[sfx_hapyhr].caption = '\x8F'.."IT'S HAPPY HOUR!!"..'\x80'
--

SafeFreeslot("sfx_takdiv")
sfxinfo[sfx_takdiv].caption = 'Dive'
SafeFreeslot("sfx_airham")
sfxinfo[sfx_airham].caption = 'Swing'
SafeFreeslot("sfx_tawhip")
sfxinfo[sfx_tawhip].caption = '\x82Johnny Test!\x80'
SafeFreeslot("sfx_takhel")
sfxinfo[sfx_takhel].caption = '\x8EHealed!\x80'
SafeFreeslot("sfx_smack")
sfxinfo[sfx_smack].caption = "\x8DSmacked!\x80"
SafeFreeslot("sfx_takoww")
sfxinfo[sfx_takoww] = {
	flags = SF_X4AWAYSOUND,
	caption = "\x85".."EUROOOOWWWW!!!\x80"
}
SafeFreeslot("sfx_takdjm")
sfxinfo[sfx_takdjm].caption = "Double jump"
SafeFreeslot("sfx_takst1")
sfxinfo[sfx_takst1].caption = "Step"
SafeFreeslot("sfx_takst2")
sfxinfo[sfx_takst2].caption = "Step"
SafeFreeslot("sfx_takst3")
sfxinfo[sfx_takst3].caption = "Step"
SafeFreeslot("sfx_takst4")
sfxinfo[sfx_takst4].caption = "Land"
SafeFreeslot("sfx_takst0")
sfxinfo[sfx_takst0].caption = "Step"

SafeFreeslot("sfx_tkapow")
sfxinfo[sfx_tkapow] = {
	singular = true,
	flags = SF_X2AWAYSOUND,
	caption = "\x82KaPOW!!!\x80"
}
SafeFreeslot("sfx_tacrit")
sfxinfo[sfx_tacrit] = {
	flags = SF_X2AWAYSOUND,
	caption = "\x82".."Crit!".."\x80"
}
SafeFreeslot("sfx_slam")
sfxinfo[sfx_slam].caption = "\x8DSlam!!\x80"
SafeFreeslot("sfx_jumpsc")
sfxinfo[sfx_jumpsc].caption = "\x85".."AAAAAHHHHH!!!!\x80"
SafeFreeslot("sfx_wega")
sfxinfo[sfx_wega].caption = "\x85".."AAAAAHHHHH!!!!\x80"
SafeFreeslot("sfx_mclang")
sfxinfo[sfx_mclang] = {
	caption = "\x8DMysterious clanging\x80",
	flags = SF_X2AWAYSOUND|SF_NOMULTIPLESOUND|SF_TOTALLYSINGLE,
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
SafeFreeslot("sfx_homrun")
sfxinfo[sfx_homrun] = {
	caption = "\x82HOMERUN!!!\x80",
	flags = SF_X4AWAYSOUND|SF_TOTALLYSINGLE,
}

SafeFreeslot("sfx_shgnl")
sfxinfo[sfx_shgnl].caption = "\x86Time to kick ass!\x80"
SafeFreeslot("sfx_shgns")
sfxinfo[sfx_shgns].caption = "\x85".."BLAMMO!!\x80"
--shotgun kill/detransfo
SafeFreeslot("sfx_shgnk")
sfxinfo[sfx_shgnk].caption = "Detransfo"
SafeFreeslot("sfx_tsplat")
sfxinfo[sfx_tsplat].caption = "\x82Splat!\x80"
SafeFreeslot("sfx_achern")
sfxinfo[sfx_achern] = {
	singular = true,
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
SafeFreeslot("sfx_didgod")
sfxinfo[sfx_didgod].caption = "/"
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
sfxinfo[sfx_trnsfo].caption = "Transfo"
SafeFreeslot("sfx_tknado")
sfxinfo[sfx_tknado].caption = "Tornado spin"
SafeFreeslot("sfx_tkfndo")
sfxinfo[sfx_tkfndo].caption = "Tornado spin!"
SafeFreeslot("sfx_takhmb")
sfxinfo[sfx_takhmb].caption = "/"
SafeFreeslot("sfx_sptclt")
sfxinfo[sfx_sptclt].caption = "Collect Spirit"
SafeFreeslot("sfx_sdmkil")
sfxinfo[sfx_sdmkil].caption = "/"
SafeFreeslot("sfx_summit")
sfxinfo[sfx_summit].caption = "\x89SUMMIT!\x80"
SafeFreeslot("sfx_ponglr")
sfxinfo[sfx_ponglr].caption = "/"
SafeFreeslot("sfx_kartst")
sfxinfo[sfx_kartst].caption = "Startup"
SafeFreeslot("sfx_kartlf")
sfxinfo[sfx_kartlf].caption = "Fuel low!"
SafeFreeslot("sfx_kartdr")
sfxinfo[sfx_kartdr].caption = "/"
for i = 0,12
	local text = i
	if i < 10
		text = "0"..i
	end
	SafeFreeslot("sfx_krte"..text)
	--sfxinfo[sfx_krte00+i].caption = "/"
end

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
SafeFreeslot("SPR_TSPR")
SafeFreeslot("SPR_TKFT")
SafeFreeslot("SPR_MTLD")
SafeFreeslot("SPR_MDST")
SafeFreeslot("SPR_PGLR") --polar and other pongler sprites
SafeFreeslot("SPR_KART")

--

--spr2 freeslot

SafeFreeslot("SPR2_TAKI")
--SafeFreeslot("SPR2_TAK2") I LOVE WASTING FREESLOTS!!!!
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
SafeFreeslot("SPR2_TBRD")
SafeFreeslot("SPR2_KART")

--

--state freeslot

SafeFreeslot("S_PLAY_TAKIS_KART")
states[S_PLAY_TAKIS_KART] = {
    sprite = SPR_PLAY,
    frame = SPR2_KART,
    tics = -1,
}

SafeFreeslot("S_PLAY_TAKIS_TORNADO")
states[S_PLAY_TAKIS_TORNADO] = {
    sprite = SPR_PLAY,
    frame = SPR2_NADO,
    tics = -1,
}

SafeFreeslot("S_PLAY_TAKIS_RESETSTATE")
states[S_PLAY_TAKIS_RESETSTATE] = {
    sprite = SPR_PLAY,
    frame = SPR2_WALK,
	action = function(mo)
		local flip = P_MobjFlip(mo)
		if not P_IsObjectOnGround(mo)
			if mo.momz*flip < 0
				mo.state = S_PLAY_FALL
			else
				mo.state = S_PLAY_JUMP
			end
		else
			mo.state = S_PLAY_WALK
		end
		if mo.player.skidtime
			mo.state = S_PLAY_SKID
		end
		P_MovePlayer(mo.player)
	end,
    tics = 0,
}

SafeFreeslot("S_PLAY_TAKIS_SHOULDERBASH")
states[S_PLAY_TAKIS_SHOULDERBASH] = {
    sprite = SPR_PLAY,
    frame = SPR2_PLHD, --SPR2_SGBS,
    tics = TR,
    nextstate = S_PLAY_TAKIS_RESETSTATE
}
SafeFreeslot("S_PLAY_TAKIS_SHOULDERBASH_JUMP")
states[S_PLAY_TAKIS_SHOULDERBASH_JUMP] = {
    sprite = SPR_PLAY,
    frame = SPR2_PLHD, --SPR2_SGBS,
    tics = 4,
    nextstate = S_PLAY_TAKIS_SHOULDERBASH
}

SafeFreeslot("S_PLAY_TAKIS_SHOTGUNSTOMP")
states[S_PLAY_TAKIS_SHOTGUNSTOMP] = {
    sprite = SPR_PLAY,
    frame = A|FF_ANIMATE|SPR2_SGST,
    tics = -1,
    nextstate = S_PLAY_STND
}
SafeFreeslot("S_PLAY_TAKIS_KILLBASH")
states[S_PLAY_TAKIS_KILLBASH] = {
    sprite = SPR_PLAY,
    frame = SPR2_PLHD, --SPR2_CLKB,
    tics = 12,
    nextstate = S_PLAY_FALL
}


SafeFreeslot("S_PLAY_TAKIS_SMUGASSGRIN")
states[S_PLAY_TAKIS_SMUGASSGRIN] = {
    sprite = SPR_PLAY,
    frame = SPR2_TAKI,
    tics = -1,
    nextstate = S_PLAY_TAKIS_RESETSTATE
}

SafeFreeslot("S_TAKIS_SWEAT1")
SafeFreeslot("S_TAKIS_SWEAT2")
SafeFreeslot("S_TAKIS_SWEAT3")
SafeFreeslot("S_TAKIS_SWEAT4")
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

SafeFreeslot("S_PLAY_TAKIS_SLIDE")
states[S_PLAY_TAKIS_SLIDE] = {
    sprite = SPR_PLAY,
    frame = SPR2_SLID,
    --var1 = 2,
	--var2 = 2,
	tics = -1,
    nextstate = S_PLAY_STND
}

SafeFreeslot("S_TAKIS_TAUNT_JOIN")
states[S_TAKIS_TAUNT_JOIN] = {
	sprite = SPR_TPTN,
	frame = A|FF_FULLBRIGHT,
	tics = 6,
	nextstate = S_NULL
}

SafeFreeslot("S_TAKIS_TROPHY")
SafeFreeslot("S_TAKIS_TROPHY2")
states[S_TAKIS_TROPHY] = {
	sprite = SPR_TKFT,
	frame = E|FF_FULLBRIGHT,
	tics = 3*TR,
	nextstate = S_TAKIS_TROPHY2
}
states[S_TAKIS_TROPHY2] = {
	sprite = SPR_TKFT,
	frame = E|FF_FULLBRIGHT,
	tics = 3*TR,
	nextstate = S_NULL
}

SafeFreeslot("S_PLAY_TAKIS_CONGA")
states[S_PLAY_TAKIS_CONGA] = {
    sprite = SPR_PLAY,
    frame = SPR2_WALK|A|FF_ANIMATE,
    var1 = 8,
	var2 = 1,
	tics = -1,
    nextstate = S_PLAY_TAKIS_CONGA
}

SafeFreeslot("S_PLAY_TAKIS_BIRD")
states[S_PLAY_TAKIS_BIRD] = {
    sprite = SPR_PLAY,
    frame = SPR2_TBRD,
	tics = -1,
    nextstate = S_PLAY_TAKIS_BIRD
}

SafeFreeslot("S_TAKIS_SHOTGUN")
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

SafeFreeslot("S_TAKIS_CLUTCHDUST")
states[S_TAKIS_CLUTCHDUST] = {
	sprite = SPR_CDST,
	frame = A|FF_PAPERSPRITE|FF_ANIMATE,
	var1 = 6,
	var2 = 2,
	tics = 6*2,
}

SafeFreeslot("S_TAKIS_DRILLEFFECT")
states[S_TAKIS_DRILLEFFECT] = {
    sprite = SPR_TNDE,
    frame = FF_PAPERSPRITE|FF_ANIMATE,
	var1 = 5,
	var2 = 2,
	tics = 5*2,
    nextstate = S_TAKIS_DRILLEFFECT
}

SafeFreeslot("S_TAKIS_BADNIK_RAGDOLL_A")
states[S_TAKIS_BADNIK_RAGDOLL_A] = {
    sprite = SPR_RGDA,
    frame = A|FF_ANIMATE,
	var1 = 1,
	var2 = 2,
	tics = (1*2)*20,
}

SafeFreeslot("S_TAKIS_HEARTCARD_SPIN")
states[S_TAKIS_HEARTCARD_SPIN] = {
    sprite = SPR_HTCD,
    frame = A|FF_PAPERSPRITE,
	tics = TAKIS_MAX_HEARTCARD_FUSE,
}

--

--mobj freeslot

--i would like to make these last forever like banjo, but
--server sustainability comes first!
SafeFreeslot("MT_TAKIS_HEARTCARD")
mobjinfo[MT_TAKIS_HEARTCARD] = {
	--$Name Heartcard
	--$Sprite HTCDALAR
	--$Category Takis Stuff
	--$Flags4Text Respawn in SP
	--$Flags8Text No Gravity
	--$ParameterText Respawn
	doomednum = 3003,
	spawnstate = S_TAKIS_HEARTCARD_SPIN,
	spawnhealth = 1000,
	height = 50*FRACUNIT,
	radius = 25*FRACUNIT,
	flags = MF_SLIDEME|MF_SPECIAL
}

SafeFreeslot("MT_TAKIS_DRILLEFFECT")
mobjinfo[MT_TAKIS_DRILLEFFECT] = {
	doomednum = -1,
	spawnstate = S_TAKIS_DRILLEFFECT,
	height = 60*FRACUNIT,
	radius = 35*FRACUNIT,
	flags = MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOGRAVITY|MF_SOLID
}

SafeFreeslot("MT_TAKIS_AFTERIMAGE")

mobjinfo[MT_TAKIS_AFTERIMAGE] = {
	doomednum = -1,
	spawnstate = S_PLAY_WAIT,
	radius = 12*FRACUNIT,
	height = 10*FRACUNIT,
	flags = MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOGRAVITY|MF_NOBLOCKMAP	
}

SafeFreeslot("MT_WINDRINGLOL")
SafeFreeslot("S_SOAPYWINDRINGLOL")

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

SafeFreeslot("MT_TAKIS_HAMMERHITBOX")
SafeFreeslot("S_TAKIS_HAMMERHITBOX")
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

SafeFreeslot("MT_TAKIS_BADNIK_RAGDOLL")
mobjinfo[MT_TAKIS_BADNIK_RAGDOLL] = {
	doomednum = -1,
	spawnstate = S_PLAY_WAIT,
	deathstate = S_XPLD1,
	height = 25*FRACUNIT,
	radius = 25*FRACUNIT,
}

SafeFreeslot("MT_TAKIS_SWEAT")
mobjinfo[MT_TAKIS_SWEAT] = {
	doomednum = -1,
	spawnstate = S_TAKIS_SWEAT1,
	height = 5*FRACUNIT,
	radius = 5*FRACUNIT,
	flags = MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOGRAVITY

}

SafeFreeslot("MT_TAKIS_TAUNT_JOIN")
mobjinfo[MT_TAKIS_TAUNT_JOIN] = {
	doomednum = -1,
	spawnstate = S_TAKIS_TAUNT_JOIN,
	height = 5*FRACUNIT,
	radius = 5*FRACUNIT,
	flags = MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOGRAVITY

}

SafeFreeslot("MT_TAKIS_TROPHY")
mobjinfo[MT_TAKIS_TROPHY] = {
	doomednum = -1,
	spawnstate = S_TAKIS_TROPHY,
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

SafeFreeslot("MT_TAKIS_DEADBODY")
mobjinfo[MT_TAKIS_DEADBODY] = {
	doomednum = -1,
	spawnstate = S_NULL,
	--mt_playuer
	flags = MF_NOCLIPHEIGHT|MF_NOCLIP|MF_SLIDEME|MF_NOCLIPTHING|MF_NOGRAVITY,
	height = 16*FRACUNIT,
	radius = 26*FRACUNIT,
}

SafeFreeslot("MT_TAKIS_SHOTGUN")
mobjinfo[MT_TAKIS_SHOTGUN] = {
	doomednum = -1,
	spawnstate = S_TAKIS_SHOTGUN,
	--mt_playuer
	flags = MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOCLIPTHING|MF_NOGRAVITY,
	height = 5*FRACUNIT,
	radius = 5*FRACUNIT,
}

SafeFreeslot("MT_TAKIS_CLUTCHDUST")
mobjinfo[MT_TAKIS_CLUTCHDUST] = {
	doomednum = -1,
	spawnstate = S_TAKIS_CLUTCHDUST,
	flags = MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOCLIPTHING|MF_NOGRAVITY,
	height = 5*FRACUNIT,
	radius = 5*FRACUNIT,
}

SafeFreeslot("MT_TAKIS_BADNIK_RAGDOLL_A")
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
	L_ZLaunch(gun,4*FU)
	gun.destscale = oldscale
	if mo.forcebox
		gun.forceon = true
	end
	
	if mo.info.seesound
		local g = P_SpawnGhostMobj(mo)
		g.tics = -1
		g.flags2 = $|MF2_DONTDRAW
		g.fuse = TR
		S_StartSound(g,mo.info.seesound)
	end
	
end

SafeFreeslot("S_SHOTGUN_BOX")
states[S_SHOTGUN_BOX] = {
	sprite = SPR_TVSG,
	frame = A,
	tics = 2,
	nextstate = S_BOX_FLICKER
}
SafeFreeslot("S_SHOTGUN_ICON1")
SafeFreeslot("S_SHOTGUN_ICON2")
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

SafeFreeslot("MT_SHOTGUN_BOX")
SafeFreeslot("MT_SHOTGUN_ICON")
SafeFreeslot("MT_SHOTGUN_GOLDBOX")

function A_MonitorPop(mo)
	--override shotgun boxesx
	if mo.type == MT_SHOTGUN_BOX
	--these guys use a different action
	--or mo.type == MT_SHOTGUN_GOLDBOX
		
		local item = 0
		if mo.info.damage == MT_UNKNOWN
			super(mo)
			return
		else
			item = mo.info.damage
		end
		
		if item == 0
			super(mo)
			return
		end
		
		local itemmo = P_SpawnMobjFromMobj(mo,0,0,13*FU,item)
		itemmo.target = mo.target
		itemmo.forcebox = mo.forcebox
		
		S_StartSound(mo,mo.info.deathsound)
		P_SpawnMobjFromMobj(mo,0,0,mo.height/4,MT_EXPLODE)
		
		mo.health = 0
		mo.flags = $|MF_NOCLIP &~MF_SOLID
		
		return
	else
		super(mo)
	end
	
end

mobjinfo[MT_SHOTGUN_BOX] = {
	--$Name Shotgun Box
	--$Sprite TVSGA0
	--$Category Takis Stuff
	--$Flags4Text Force On
	--$Flags8Text Golden
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

SafeFreeslot("S_SHOTGUN_GOLDBOX")
states[S_SHOTGUN_GOLDBOX] = {
	sprite = SPR_TVSG,
	frame = B,
	tics = 2,
	nextstate = S_GOLDBOX_FLICKER,
	action = A_GoldMonitorSparkle,
}
mobjinfo[MT_SHOTGUN_GOLDBOX] = {
	doomednum = -1,
	spawnstate = S_SHOTGUN_GOLDBOX,
	painstate = S_SHOTGUN_GOLDBOX,
	deathstate = S_GOLDBOX_OFF1,
	attacksound = sfx_monton,
	deathsound = sfx_pop,
	reactiontime = 8,
	speed = 1,
	damage = MT_SHOTGUN_ICON,
	mass = 100,
	flags = MF_SOLID|MF_SHOOTABLE|MF_MONITOR|MF_GRENADEBOUNCE,
	height = 44*FRACUNIT,
	radius = 20*FRACUNIT,
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
SafeFreeslot("S_TAKIS_FLINGSOLID")
SafeFreeslot("MT_TAKIS_FLINGSOLID")
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

SafeFreeslot("S_TAKIS_GIB")
SafeFreeslot("MT_TAKIS_GIB")
states[S_TAKIS_GIB] = {
	sprite = SPR_TGIB,
	frame = A,
	tics = -1,
}
mobjinfo[MT_TAKIS_GIB] = {
	doomednum = -1,
	spawnstate = S_TAKIS_GIB,
	flags = MF_SLIDEME|MF_NOCLIPTHING,
	height = 4*FRACUNIT,
	radius = 4*FRACUNIT,
}

SafeFreeslot("S_TAKIS_FETTI")
SafeFreeslot("MT_TAKIS_FETTI")
states[S_TAKIS_FETTI] = {
	sprite = SPR_TKFT,
	frame = A|FF_PAPERSPRITE,
	tics = -1,
}
mobjinfo[MT_TAKIS_FETTI] = {
	doomednum = -1,
	spawnstate = S_TAKIS_FETTI,
	flags = MF_NOCLIP|MF_NOCLIPTHING,
	height = 4*FRACUNIT,
	radius = 4*FRACUNIT,
	speed = 2*FRACUNIT,
	mass = FU*60/63,
}

SafeFreeslot("S_TAKIS_SPIRIT","MT_TAKIS_SPIRIT")
states[S_TAKIS_SPIRIT] = {
	sprite = SPR_TSPR,
	frame = A,
	tics = -1,
}
mobjinfo[MT_TAKIS_SPIRIT] = {
	doomednum = -1,
	spawnstate = S_TAKIS_SPIRIT,
	flags = MF_SLIDEME|MF_NOCLIPTHING|MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOGRAVITY,
	height = 4*FRACUNIT,
	radius = 4*FRACUNIT,
}

SafeFreeslot("MT_TAKIS_METALDETECTOR")
SafeFreeslot("S_TAKIS_METALDETECTOR")
states[S_TAKIS_METALDETECTOR] = {
	sprite = SPR_SHGN,
	frame = C,
	tics = -1,
	nextstate = S_TAKIS_METALDETECTOR,
}

mobjinfo[MT_TAKIS_METALDETECTOR] = {
	--$Name Metal Detector
	--$Sprite SHGNC0
	--$Category Takis Stuff
	doomednum = 3004,
	spawnstate = S_TAKIS_METALDETECTOR,
	deathstate = S_TAKIS_METALDETECTOR,
	spawnhealth = 1000,
	activesound = sfx_gbeep,
	height = 140*FRACUNIT,
	radius = 32*FRACUNIT,
	flags = MF_SLIDEME|MF_SPECIAL|MF_NOGRAVITY
}

SafeFreeslot("MT_TAKIS_STEAM")
SafeFreeslot("S_TAKIS_STEAM")
SafeFreeslot("S_TAKIS_STEAM2")
states[S_TAKIS_STEAM] = {
	sprite = SPR_MDST,
	frame = A|FF_ANIMATE,
	var1 = 3,
	var2 = 1,
	tics = 3*1,
	nextstate = S_TAKIS_STEAM2,
}
states[S_TAKIS_STEAM2] = {
	sprite = SPR_MDST,
	frame = D|FF_ANIMATE,
	var1 = 7,
	var2 = 1,
	tics = 1*7,
	nextstate = S_TAKIS_STEAM2
}

mobjinfo[MT_TAKIS_STEAM] = {
	doomednum = -1,
	spawnstate = S_TAKIS_STEAM,
	spawnhealth = 1,
	height = 6*FRACUNIT,
	radius = 6*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_SCENERY|MF_NOCLIP|MF_NOGRAVITY|MF_NOCLIPHEIGHT
}

SafeFreeslot("MT_TAKIS_PONGLER")
SafeFreeslot("S_TAKIS_PONGLER")
states[S_TAKIS_PONGLER] = {
	sprite = SPR_PGLR,
	frame = A,
	var1 = A,
	tics = TR*3/2,
}
mobjinfo[MT_TAKIS_PONGLER] = {
	doomednum = -1,
	spawnstate = S_TAKIS_PONGLER,
	spawnhealth = 1,
	height = 6*FRACUNIT,
	radius = 6*FRACUNIT,
	flags = MF_NOCLIP|MF_NOGRAVITY|MF_NOCLIPHEIGHT
}

SafeFreeslot("MT_TAKIS_GUNSHOT")
SafeFreeslot("S_TAKIS_GUNSHOT")
states[S_TAKIS_GUNSHOT] = {
	sprite = SPR_SHGN,
	frame = D,
	action = A_ThrownRing,
	tics = 1,
	nextstate = S_TAKIS_GUNSHOT
}
mobjinfo[MT_TAKIS_GUNSHOT] = {
	doomednum = -1,
	spawnstate = S_TAKIS_GUNSHOT,
	spawnhealth = 1,
	height = 32*FRACUNIT,
	radius = 16*FRACUNIT,
	speed = 120*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_MISSILE|MF_NOGRAVITY
}

/*
SafeFreeslot("MT_TAKIS_SPAWNER")
SafeFreeslot("S_TAKIS_SPAWNER_IDLE")
SafeFreeslot("S_TAKIS_SPAWNER_FIRE")
states[S_TAKIS_SPAWNER_IDLE] = {
	sprite = SPR_RING,
	frame = A,
	tics = 4*TICRATE,
	nextstate = S_TAKIS_SPAWNER_IDLE,
}

mobjinfo[MT_TAKIS_SPAWNER] = {
	--$Name Enemy Spawner
	--$Sprite SHGNC0
	--$Category Takis Stuff
	doomednum = 3005,
	spawnstate = S_TAKIS_SPAWNER_IDLE,
	deathstate = S_TAKIS_SPAWNER_IDLE,
	spawnhealth = 1000,
	activesound = sfx_gbeep,
	height = 64*FRACUNIT,
	radius = 32*FRACUNIT,
	flags = MF_SOLID|MF_NOGRAVITY
}
*/

addHook("NetVars",function(n)
	--TAKIS_NET = n($)
	
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
	TAKIS_ACHIEVEMENTINFO = n($)
end)

addHook("ThinkFrame",do
	for k,v in ipairs(constlist)
		local enum = v[1]
		local val = v[2]
		
		if _G[enum] ~= val
			_G[enum] = val
		end
	end
end)

filesdone = $+1
