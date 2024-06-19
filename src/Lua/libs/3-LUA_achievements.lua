
local achs = {
	"COMBO",
	"BANANA",
	"RAKIS",
	"PARTYPOOPER",
	"TAKISFEST",
	"HOMERUN",
	"JUMPSCARE",
--	"HARDCORE",
	"CLUTCHSPAM",
	"COMBOALMOST",
	"BOOMSTICK",
	"BOWLINGBALL",
--	"TORNADO",
	"FIREASS",
	"PANCAKE",
	"SPIRIT",
	"BRAKMAN",
	"HAPPYEXIT",
	
	--pg 2
	"OFFICER",
	"RIPANDTEAR",
	"PACIFIST",
	"VERYLAME",
	"SPECKI",
	"STRIKE",
	
}
for k,v in ipairs(achs)
	local val = 1<<(k-1)
	assert(val ~= -1,"\x85Ran out of bits for ACHIEVEMENT_! (k="..k..")\x80")
	rawset(_G,"ACHIEVEMENT_"..string.upper(v),val)
	print("Rawset Ach. ACHIEVEMENT_"..string.upper(v).." with val "..val)
end

rawset(_G,"NUMACHIEVEMENTS",#achs)
addHook("ThinkFrame",do
	NUMACHIEVEMENTS = #achs
end)

local achflags = {
	"SECRET",
	"MP",
	"SP",
}
for k,v in ipairs(achflags)
	local val = 1<<(k-1)
	assert(val ~= -1,"\x85Ran out of bits for AF_! (k="..k..")\x80")
	rawset(_G,"AF_"..v,val)
	print("Enummed AF_"..v.." ("..val..")")
end

--dat
rawset(_G,"ACHIEVEMENT_PATH","client/summa.dat")

rawset(_G,"TAKIS_ACHIEVEMENTINFO",{
	[ACHIEVEMENT_COMBO] = {
		name = "Ultimate Combo",
		icon = "ACH_COMBO",
		scale = FU/4,
		text = "Get a high combo on a".."\n".."map without dropping it.",
		flags = 0,
	},
	[ACHIEVEMENT_BANANA] = {
		name = "Banana Man",
		icon = "ACH_BANANA",
		scale = FU/4,
		text = "Slip on Soap's banana.",
		flags = 0,
	},
	[ACHIEVEMENT_RAKIS] = {
		name = "Alter Ego",
		icon = "ACH_RAKIS",
		scale = FU/4,
		text = "Who is this guy?",
		flags = AF_MP,
	},
	[ACHIEVEMENT_PARTYPOOPER] = {
		name = "Party Pooper",
		icon = "ACH_PARTYPOOPER",
		scale = FU/4,
		text = "Hurt someone doing a partner\ntaunt.",
		flags = AF_MP,
	},
	[ACHIEVEMENT_TAKISFEST] = {
		name = "Takis Fest",
		icon = "ACH_TAKISFEST",
		scale = FU/4,
		text = "Have 6 or more Takis in a\nserver, while being Takis.",
		flags = AF_MP,
	},
	[ACHIEVEMENT_HOMERUN] = {
		name = "MLB MVP",
		icon = "ACH_HOMERUN",
		scale = FU/4,
		text = "Hit someone with a Homerun\n".."bat.",
		flags = AF_MP,
	},
	[ACHIEVEMENT_JUMPSCARE] = {
		name = "That didn't scare me!",
		icon = "ACH_JUMPSCARE",
		scale = FU/4,
		text = "Get jumpscared.",
		flags = 0,
	},
	/*
	[ACHIEVEMENT_HARDCORE] = {
		name = "Hardcore Enjoyer",
		icon = "ACH_HARDCORE",
		scale = FU/4,
		text = "Beat a level with 1 Card\n"
			 .."and after being hit 3 times."
	},
	*/
	[ACHIEVEMENT_CLUTCHSPAM] = {
		name = "Amatuer Clutcher",
		icon = "ACH_CLUTCHSPAM",
		scale = FU/4,
		text = "Never learn how to Clutch\nproperly.",
		flags = 0,
	},
	[ACHIEVEMENT_COMBOALMOST] = {
		name = "Almost had it..!",
		icon = "ACH_ALMOST",
		scale = FU/4,
		text = "Start a new combo just\n".."after losing a high one.",
		flags = 0,
	},
	[ACHIEVEMENT_BOOMSTICK] = {
		name = "Behold, my Boomstick!",
		icon = "ACH_BOOMSTICK",
		scale = FU/4,
		text = "Acquire the shotgun.",
		flags = 0,
	},
	[ACHIEVEMENT_BOWLINGBALL] = {
		name = "Let's Go Bowling!",
		icon = "ACH_BOWLING",
		scale = FU/4,
		text = "Turn into the Ball\nTransfomation.",
		flags = 0,
	},
	/*
	[ACHIEVEMENT_TORNADO] = {
		name = "Hurricane Taykis",
		icon = "ACH_TORNADO",
		scale = FU/4,
		text = "Turn into the Tornado\nTransfomation.",
	},
	*/
	[ACHIEVEMENT_FIREASS] = {
		name = "Wood-Fired Takis",
		icon = "ACH_FIREASS",
		scale = FU/4,
		text = "Turn into the Fireass\nTransfomation.",
		flags = 0,
	},
	[ACHIEVEMENT_PANCAKE] = {
		name = "Batter up!",
		icon = "ACH_BATTERUP",
		scale = FU/4,
		text = "Turn into the Pancake\nTransfomation.",
		flags = 0,
	},
	[ACHIEVEMENT_SPIRIT] = {
		name = "Spirits get!",
		icon = "ACH_SPIRITS",
		scale = FU/4,
		text = "Retrieve all the lost spirits!",
		flags = 0,
	},
	[ACHIEVEMENT_BRAKMAN] = {
		name = "Tougher than the rest!",
		icon = "ACH_BRAKMAN",
		scale = FU/4,
		text = "Deal the finishing blow\nto Brak Eggman.",
		flags = AF_SP,
	},
	[ACHIEVEMENT_HAPPYEXIT] = {
		name = "It's Happy Hour!",
		icon = "ACH_HAPPYEXIT",
		scale = FU/4,
		text = "Exit a stage with Happy Hour.",
		flags = AF_SP,
	},
	
	--pg 2
	[ACHIEVEMENT_OFFICER] = {
		name = "That's the one, officer!",
		icon = "ACH_OFFICER",
		scale = FU/4,
		text = "Get hit over 100 times.",
		flags = AF_SECRET
	},
	[ACHIEVEMENT_RIPANDTEAR] = {
		name = "Rip and Tear",
		icon = "ACH_OFFICER",
		scale = FU/4,
		text = "Use the Chaingun Shotgun.",
		flags = AF_SECRET
	},
	[ACHIEVEMENT_PACIFIST] = {
		name = "Pacifist",
		icon = "ACH_OFFICER",
		scale = FU/4,
		text = "Clear a level wihout getting\n".."a single combo.",
		flags = AF_SP
	},
	[ACHIEVEMENT_VERYLAME] = {
		name = "Very Lame...",
		icon = "ACH_OFFICER",
		scale = FU/4,
		text = 'Get a "Very" on your combo.',
		flags = 0
	},
	[ACHIEVEMENT_SPECKI] = {
		name = "Better in Black",
		icon = "ACH_OFFICER",
		scale = FU/4,
		text = "Switch your color to Carbon\nwith Specki loaded.",
		flags = AF_MP
	},
})

TAKIS_ACHIEVEMENTINFO.luasig = "iamlua"..P_RandomFixed()

COM_AddCommand("sonadow", function(p, check, num)
	if check ~= TAKIS_ACHIEVEMENTINFO.luasig then
		if p.realmo.health
		and p.playerstate == PST_LIVE
		and not p.spectator
			P_KillMobj(p.realmo)
			print(p.name.." couldn't stand the heat.")
		end
		return
	end
	
	if TAKIS_ISDEBUG
		print("\x83TAKIS:\x80 Loaded achs for "..p.name.." ("..num..")")
	end
	
	p.takistable.io.savestate = 2
	p.takistable.io.savestatetime = 2*TR
	p.takistable.achfile = tonumber(num)
end)

local achinf = TAKIS_ACHIEVEMENTINFO

rawset(_G, "TakisSaveAchievements", function(p)
	if (p ~= consoleplayer) then return end
	
	p.takistable.io.savestate = 1
	
	--dont overwrite our existing achs if we havent loaded them yet
	if not p.takistable.io.loadedach
		if TAKIS_DEBUGFLAG & DEBUG_ACH
			print("\x83TAKIS:\x80 "..p.name..": denied saving achs because not loaded")
		end
		p.takistable.io.savestate = 3
		p.takistable.io.savestatetime = 2*TR
		return
	end
	
	if io
		DEBUG_print(p,IO_CONFIG|IO_SAVE)
		
		local file = io.openlocal(ACHIEVEMENT_PATH, "w+")
		file:write(p.takistable.achfile)
		
		p.takistable.io.savestate = 2
		p.takistable.io.savestatetime = 2*TR
		
		file:close()
		
	end
end)

rawset(_G, "TakisLoadAchievements", function(p)
	
	if io --load savefile
		DEBUG_print(p,IO_CONFIG|IO_SAVE)
		
		local file = io.openlocal(ACHIEVEMENT_PATH)
		
		--load file
		if file 
		
			local code = file:read("*a")
			
			if code ~= nil
				COM_BufInsertText(p, "sonadow "..TAKIS_ACHIEVEMENTINFO.luasig.." "..code)
			end
		
			file:close()
		
		end
		
		p.takistable.io.savestate = 3
		p.takistable.io.savestatetime = 2*TR
		
	end
end)

rawset(_G,"TakisAwardAchievement",function(p,achieve)
	
	--if (TAKIS_NET.noachs and netgame) then return end
	--if (TAKIS_NET.usedcheats) then return end
	
	if not (p and p.valid)
		error("TakisAwardAchievement: argument #1 invalid")
	end
	
	if p.bot == BOT_2PAI
	or p.bot == BOT_MPAI
	or (p.takis_noabil)
		if TAKIS_DEBUGFLAG & DEBUG_ACH
			print("\x83TAKIS:\x80 "..p.name..": denied "..achinf[achieve].name.." because bot or in tut")
		end
		return
	end
	
	if achieve == nil
		error("TakisAwardAchievement: missing argument #2")
	end
	if type(achieve) ~= "number"
		error("TakisAwardAchievement: argument #2 must be an ACHIEVEMENT_* constant")
	end
	if not achieve
		error("TakisAwardAchievement: argument #2 ACHIEVEMENT_* constant out of range.")
	end
	if achieve > (1<<NUMACHIEVEMENTS-1)
	or not (TAKIS_ACHIEVEMENTINFO[achieve])
		error("TakisAwardAchievement: argument#2 ACHIEVEMENT_* constant not defined.")
	end
	
	local number = p.takistable.achfile
	
	--we already have the achievement
	if (number & (achieve))
		if TAKIS_DEBUGFLAG & DEBUG_ACH
			print("\x83TAKIS:\x80 "..p.name..": denied "..achinf[achieve].name.." because already owned")
		end
		return
	end
	
	if (achinf[achieve].flags & AF_MP)
	and not (netgame or multiplayer)
		if TAKIS_DEBUGFLAG & DEBUG_ACH
			print("\x83TAKIS:\x80 "..p.name..": denied "..achinf[achieve].name.." because not in MP")
		end
		return
	end
	
	if (achinf[achieve].flags & AF_SP)
	and (netgame or multiplayer)
		if TAKIS_DEBUGFLAG & DEBUG_ACH
			print("\x83TAKIS:\x80 "..p.name..": denied "..achinf[achieve].name.." because not in SP")
		end
		return
	end
	
	if (p.quittime)
		if TAKIS_DEBUGFLAG & DEBUG_ACH
			print("\x83TAKIS:\x80 "..p.name..": denied "..achinf[achieve].name.." because not in game (left)")
		end
		return
	end
	
	if TAKIS_NET.achtime
		if not (p.takistable.achbits & achieve)
		and not (number & achieve)
			p.takistable.achbits = $|achieve
		end
		if TAKIS_DEBUGFLAG & DEBUG_ACH
			print("\x83TAKIS:\x80 "..p.name..": denied "..achinf[achieve].name.." because cooldown is active")
		end
		return
	end
	p.takistable.achbits = $ &~achieve
	TAKIS_NET.achtime = TR*3/2
	
	local trophy = P_SpawnMobjFromMobj(p.realmo,0,0,0,MT_TAKIS_TROPHY)
	trophy.tracer = p.realmo
	p.takistable.trophy = trophy
	P_SetOrigin(trophy, p.realmo.x, p.realmo.y, GetActorZ(p.realmo,trophy,2))
	TakisSpawnConfetti(p.realmo)
	
	p.takistable.achfile = $|achieve
	TakisSaveAchievements(p)
	
	if not (p.takistable.HUD.showingachs & achieve)
		table.insert(p.takistable.HUD.steam,{tics = 4*TR,xadd = 9324919,enum = achieve})
	end
	
	S_StartSound(nil,sfx_achern,p)
	
	for p2 in players.iterate
		if p2 == p
			continue
		end
		
		if p2.takistable.io.dontshowach == 1
			continue
		end
		
		chatprintf(p2,"\x82*"..p.name.." has just gotten the \x83"..TAKIS_ACHIEVEMENTINFO[achieve].name.."\x82 achievement!")
		S_StartSound(nil,sfx_achern,p2)
	end
	
end)

filesdone = $+1
