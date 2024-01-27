--pretty buggy, maybe rewrite?

local achs = {
	"COMBO",
	"BANANA",
	"RAKIS",
	"PARTYPOOPER",
	"TAKISFEST",
	"HOMERUN",
	"JUMPSCARE",
	"HARDCORE",
	"CLUTCHSPAM",
	"COMBOALMOST",
	"BOOMSTICK",
	"BOWLINGBALL",
--	"TORNADO",
	"FIREASS",
	"SPIRIT",
	"BRAKMAN",
	"OFFICER",
}
for k,v in ipairs(achs)
	rawset(_G,"ACHIEVEMENT_"..string.upper(v),1<<(k-1))
	print("Rawset Ach. ACHIEVEMENT_"..string.upper(v).." with val "..1<<(k-1))
end

rawset(_G,"NUMACHIEVEMENTS",#achs)

rawset(_G,"ACHIEVEMENT_PATH","client/summa.dat")

rawset(_G,"TAKIS_ACHIEVEMENTINFO",{
	[ACHIEVEMENT_COMBO] = {
		name = "Ultimate Combo",
		icon = "ACH_COMBO",
		scale = FU/4,
		text = "Get a high combo on a".."\n".."map without dropping it."
	},
	[ACHIEVEMENT_BANANA] = {
		name = "Banana Man",
		icon = "ACH_BANANA",
		scale = FU/4,
		text = "Slip on Soap's banana."
	},
	[ACHIEVEMENT_RAKIS] = {
		name = "Alter Ego",
		icon = "ACH_RAKIS",
		scale = FU/4,
		text = "Who is this guy?"
	},
	[ACHIEVEMENT_PARTYPOOPER] = {
		name = "Party Pooper",
		icon = "ACH_PARTYPOOPER",
		scale = FU/4,
		text = "Hurt someone doing a partner\ntaunt."
	},
	[ACHIEVEMENT_TAKISFEST] = {
		name = "Takis Fest",
		icon = "ACH_TAKISFEST",
		scale = FU/4,
		text = "Have 6 or more Takis in a\nserver."
	},
	[ACHIEVEMENT_HOMERUN] = {
		name = "MLB MVP",
		icon = "ACH_HOMERUN",
		scale = FU/4,
		text = "Hit someone with a Homerun\n".."bat."
	},
	[ACHIEVEMENT_JUMPSCARE] = {
		name = "That didn't scare me!",
		icon = "ACH_JUMPSCARE",
		scale = FU/4,
		text = "Get jumpscared."
	},
	[ACHIEVEMENT_HARDCORE] = {
		name = "Hardcore Enjoyer",
		icon = "ACH_HARDCORE",
		scale = FU/4,
		text = "Beat a level with 1 Card\n"
			 .."and after being hit 3 times."
	},
	[ACHIEVEMENT_CLUTCHSPAM] = {
		name = "Amatuer Clutcher",
		icon = "ACH_CLUTCHSPAM",
		scale = FU/4,
		text = "Never learn how to Clutch\nproperly."
	},
	[ACHIEVEMENT_COMBOALMOST] = {
		name = "Almost had it..!",
		icon = "ACH_PLACEHOLDER",
		scale = FU/4,
		text = "Start a new combo just\n".."after losing a high one."
	},
	[ACHIEVEMENT_BOOMSTICK] = {
		name = "Behold, my Boomstick!",
		icon = "ACH_BOOMSTICK",
		scale = FU/4,
		text = "Acquire the shotgun."
	},
	[ACHIEVEMENT_BOWLINGBALL] = {
		name = "Let's Go Bowling!",
		icon = "ACH_BOOMSTICK",
		scale = FU/4,
		text = "Turn into the Ball\nTransfomation."
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
		icon = "ACH_TORNADO",
		scale = FU/4,
		text = "Turn into the Fireass\nTransfomation.",
	},
	[ACHIEVEMENT_SPIRIT] = {
		name = "Spirits get!",
		icon = "ACH_SPIRITS",
		scale = FU/4,
		text = "Retrieve all the lost spirits!",
	},
	[ACHIEVEMENT_BRAKMAN] = {
		name = "Tougher than the rest!",
		icon = "ACH_BRAKMAN",
		scale = FU/4,
		text = "Deal the finishing blow\nto Brak Eggman.",
	},
	[ACHIEVEMENT_OFFICER] = {
		name = "That's the one, officer!",
		icon = "ACH_OFFICER",
		scale = FU/4,
		text = "Get hit over 100 times.",
		secret = true,
	},
})

TAKIS_ACHIEVEMENTINFO.luasig = "iamlua"..P_RandomFixed()

COM_AddCommand("_loadachs", function(p, check, num)
	if check ~= TAKIS_ACHIEVEMENTINFO.luasig then
		P_KillMobj(p.realmo)
		print(p.name.." couldn't stand the heat.")
		return
	end
	
	p.takistable.achfile = tonumber(num)
end)

rawset(_G, "TakisSaveAchievements", function(p)
	if (p ~= consoleplayer) then return end
	
	--dont overwrite our existing achs if we havent loaded them yet
	if not p.takistable.io.loadedach
		return
	end
	
	if io
		DEBUG_print(p,IO_CONFIG|IO_SAVE)
		
		local file = io.openlocal(ACHIEVEMENT_PATH, "w+")
		file:write(p.takistable.achfile)
		
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
				COM_BufInsertText(p, "_loadachs "..TAKIS_ACHIEVEMENTINFO.luasig.." "..code)
			end
		
			file:close()
		
		end
		
	end
end)

rawset(_G,"TakisAwardAchievement",function(p,achieve)
	if (TAKIS_NET.noachs and netgame) then return end
	if (TAKIS_NET.cheatedgame) then return end
	
	if p.bot == BOT_2PAI
	or p.bot == BOT_MPAI
	or (p.takis_noabil)
		return
	end
	
	if achieve == nil
		error("TakisAwardAchievement was not given an achievement!")
	end
	if type(achieve) ~= "number"
		error("Second argument to TakisAwardAchievement must be an ACHIEVEMENT_* constant.")
	end
	if not achieve
		error("ACHIEVEMENT_ constant out of range.")
	end
	if achieve > (1<<NUMACHIEVEMENTS-1)
	or not (TAKIS_ACHIEVEMENTINFO[achieve])
		error("ACHIEVEMENT_ constant not defined.")
	end
	
	local number = p.takistable.achfile
	
	--we already have the achievement
	if (number & (achieve))
		return
	end
	
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
