--pretty buggy, maybe rewrite?

local achs = {
	"COMBO",
	"BANANA",
	"RAKIS",
	"PARTYPOOPER",
	"TAKISFEST",
	"HOMERUN",
	"FULLCOMBO",
	"JUMPSCARE",
	"HARDCORE",
	"CLUTCHSPAM",
	"COMBOCLOSE",
	"COMBOALMOST",
	"BOOMSTICK",
	"BRAKMAN",
	"TORNADO"
}
for k,v in ipairs(achs)
	rawset(_G,"ACHIEVEMENT_"..string.upper(v),1<<(k-1))
	print("Rawset Ach. ACHIEVEMENT_"..string.upper(v).." with val "..1<<(k-1))
end

rawset(_G,"NUMACHIEVEMENTS",#achs)

rawset(_G,"ACHIEVEMENT_PATH","client/coolswag.dat")

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
		text = "Slip on a banana."
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
	[ACHIEVEMENT_FULLCOMBO] = {
		name = "Full Combo",
		icon = "ACH_FULLCOMBO",
		scale = FU/4,
		text = "Destroy everything in a\nmap."
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
	[ACHIEVEMENT_COMBOCLOSE] = {
		name = "Close Call!",
		icon = "ACH_COMBOCLOSE",
		scale = FU/4,
		text = "Save a high combo from\n".."ending."
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
	[ACHIEVEMENT_BRAKMAN] = {
		name = "I'm Brakman.",
		icon = "ACH_PLACEHOLDER",
		scale = FU/4,
		text = "Deal the finishing blow\nto Brak Eggman.",
	},
	[ACHIEVEMENT_TORNADO] = {
		name = "Hurricane Taykis",
		icon = "ACH_PLACEHOLDER",
		scale = FU/4,
		text = "Turn into the Tornado\nTransfomation.",
	},
})

rawset(_G,"TakisReadAchievements",function(p)
	local number = 0
	
	if io
		DEBUG_print(p,IO_ACH)
		
		local file = io.openlocal(ACHIEVEMENT_PATH)
		
		if file
			
			number = tonumber(file:read("*a"))
			
			file:close()
		end
	end
	
	p.takistable.achfile = number
	return number
end)

local function writeach(p,ach,num)
	if consoleplayer ~= p
		return
	end
	
	if io
		
		DEBUG_print(p,IO_ACH|IO_SAVE)
		
		local file = io.openlocal(ACHIEVEMENT_PATH, "w+")
		local pro = num|ach
		file:write(tostring(pro))
			
		file:close()
		
	end

end

rawset(_G,"TakisAwardAchievement",function(p,achieve)
	if (TAKIS_NET.noachs and netgame) then return end
	
	if achieve == nil
		error("TakisAwardAchievement was not given an achievement!")
	end
	if type(achieve) ~= "number"
		error("Second argument to TakisAwardAchievement must be an ACHIEVEMENT_* constant.")
	end
	if not achieve
		error("ACHIEVEMENT_ constant out of range.")
	end
	
	local number = TakisReadAchievements(p)
	
	--we already have the achievement
	if (number & (achieve))
		return
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
	
	if not (p.takistable.HUD.showingachs & achieve)
		table.insert(p.takistable.HUD.steam,{tics = 4*TR,xadd = 9324919,enum = achieve})
	end
	
	writeach(p,achieve,number)
end)

filesdone = $+1
