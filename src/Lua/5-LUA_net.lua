local t = TAKIS_NET
local m = TAKIS_MISC

local boolean = {
	["false"] = false,
	["true"] = true,
}

local function debugf(name,cv,tv)
	if not TAKIS_ISDEBUG then return end
	if not (TAKIS_DEBUGFLAG & DEBUG_NET) then return end
	
	print("\x83TAKIS:\x80 "..name.." = cv: "..cv.." tv: "..tv)
end

rawset(_G,"CV_TAKIS",{})
CV_TAKIS.nerfarma = CV_RegisterVar({
	name = "takis_nerfarma",
	defaultvalue = "false",
	flags = CV_NETVAR|CV_SHOWMODIF|CV_CALL,
	PossibleValue = CV_TrueFalse,
	func = function(cv)
		t.nerfarma = boolean[string.lower(cv.string)]
		debugf("nerfarma",string.lower(cv.string),tostring(t.nerfarma))
	end
})
CV_TAKIS.tauntkills = CV_RegisterVar({
	name = "takis_tauntkills",
	defaultvalue = "true",
	flags = CV_NETVAR|CV_SHOWMODIF|CV_CALL,
	PossibleValue = CV_TrueFalse,
	func = function(cv)
		t.tauntkillsenabled = boolean[string.lower(cv.string)]
		debugf("tauntkills",string.lower(cv.string),tostring(t.tauntkillsenabled))
	end
})
CV_TAKIS.achs = CV_RegisterVar({
	name = "takis_achs",
	defaultvalue = "true",
	flags = CV_NETVAR|CV_SHOWMODIF|CV_CALL,
	PossibleValue = CV_TrueFalse,
	func = function(cv)
		t.noachs = not boolean[string.lower(cv.string)]
		debugf("achs",string.lower(cv.string),tostring(not t.achs))
	end
})
CV_TAKIS.collaterals = CV_RegisterVar({
	name = "takis_collaterals",
	defaultvalue = "true",
	flags = CV_NETVAR|CV_SHOWMODIF|CV_CALL,
	PossibleValue = CV_TrueFalse,
	func = function(cv)
		t.collaterals = boolean[string.lower(cv.string)]
		debugf("collaterals",string.lower(cv.string),tostring(t.collaterals))
	end
})
CV_TAKIS.heartcards = CV_RegisterVar({
	name = "takis_heartcards",
	defaultvalue = "true",
	flags = CV_NETVAR|CV_SHOWMODIF|CV_CALL,
	PossibleValue = CV_TrueFalse,
	func = function(cv)
		t.cards = boolean[string.lower(cv.string)]
		debugf("cards",string.lower(cv.string),tostring(t.cards))
	end
})
CV_TAKIS.hammerquake = CV_RegisterVar({
	name = "takis_hammerquakes",
	defaultvalue = "true",
	flags = CV_NETVAR|CV_SHOWMODIF|CV_CALL,
	PossibleValue = CV_TrueFalse,
	func = function(cv)
		t.hammerquakes = cv.value == 1 --boolean[string.lower(cv.string)]
		debugf("hammerquakes",string.lower(cv.string),tostring(t.hammerquakes))
	end
})
CV_TAKIS.chaingun = CV_RegisterVar({
	name = "takis_chaingun",
	defaultvalue = "false",
	flags = CV_NETVAR|CV_SHOWMODIF|CV_CALL,
	PossibleValue = CV_TrueFalse,
	func = function(cv)
		t.chaingun = boolean[string.lower(cv.string)]
		debugf("chaingun",string.lower(cv.string),tostring(t.chaingun))
	end
})

local function livesCount()
	if (gametyperules & GTR_TAG)
		return
	end
	if (G_GametypeHasTeams())
		return
	end
	
	if (G_GametypeUsesLives())
		if ((netgame or multiplayer) and G_GametypeUsesCoopLives() and (CV_FindVar("cooplives").value == 3))
			local lives = 0
			
			for p in players.iterate
				if p.lives < 1
					continue
				end
				
				if (p.lives == INFLIVES)
					lives = INFLIVES
					break
				elseif lives < 99
					lives = $+p.lives
				end
				
			end
			
			m.livescount = lives
		end
	end
end

addHook("MapChange", function(mapid)
	TakisChangeHeartCards(6)
	if (mapheaderinfo[mapid].takis_maxheartcards)
		if (tonumber(mapheaderinfo[mapid].takis_maxheartcards) > 0)
			TakisChangeHeartCards(tonumber(mapheaderinfo[mapid].takis_maxheartcards))
		end
	end
	if ultimatemode
		TakisChangeHeartCards(1)
	end
	
	mapmusname = mapheaderinfo[mapid].musname
	
	for p in players.iterate
		p.takistable.HUD.bosscards = {
			maxcards = 0,
			dontdrawcards = false,
			cards = 0,
			cardshake = 0,
			mo = 0,
			name = '',
			statusface = {
				priority = 0,
				state = "IDLE",
				frame = 0,
			},
		}
		p.takistable.HUD.bosstitle.tic = 0
	end
	
	m.ideyadrones = {}
	m.inbossmap = false
end)

--will this synch though?
addHook("MapLoad", function(mapid)
	
	m.numdestroyables = 0
	
	for mt in mapthings.iterate
		
		if mt.mobj and mt.mobj.valid
			local mobj = mt.mobj
				
			
			if mobj.type == MT_CYBRAKDEMON
				m.inbrakmap = true
			end
			
			if (CanFlingThing(mobj))
			or (SPIKE_LIST[mobj.type] == true)
				m.numdestroyables = $+1
			end
		else
			continue
		end
		
	end
	
	m.partdestroy = m.numdestroyables/(m.playercount+2) or 1
	
end)

local bumpinterval = {
	["vsboss"] = 18,
	["vsalt"] = 13,
	["vsmetl"] = 11,
	["vsbrak"] = 10,
	["vsfang"] = 15
}

addHook("ThinkFrame", do
	
	--CVtoNET()
	
	if usedCheats
	and not t.usedcheats
		t.usedcheats = true
		print("\x83NOTICE:\x80 Achievements cannot be earned in cheated games.")
	end
	
	if gamestate == GS_TITLESCREEN
		TAKIS_TITLETIME = $+1
		
		--you probably wont get this without stalling
		if TAKIS_TITLETIME == (120*TR)
			S_StopMusic()
			S_StartSound(nil,sfx_jumpsc)
			TAKIS_TITLEFUNNY = (TR)+1
			TAKIS_TITLEFUNNYY = 500*FU
		end
		if TAKIS_TITLEFUNNY > 0
			if TAKIS_TITLEFUNNY == 1
				COM_BufInsertText(consoleplayer,"quit")
			end
			TAKIS_TITLEFUNNY = $-1
		end
	else
		TAKIS_TITLETIME = 0
	end
	
	if gamestate ~= GS_LEVEL
		return
	end
	
	m.inspecialstage = G_IsSpecialStage(gamemap)
	m.isretro = (maptol & TOL_MARIO)
	
	m.inttic = 0
	m.inbossmap = $ or (mapheaderinfo[gamemap].bonustype == 1)
	
	livesCount()
	
	local playerCount = 0
	local exitingCount = 0
	local takisCount = 0
	for player in players.iterate
		if player.valid
			if player.exiting
			or player.spectator 
			or player.pizzaface
			or player.ptsr_outofgame
			or player.playerstate == PST_DEAD
				exitingCount = $+1
			end
			if (skins[player.skin].name == TAKIS_SKIN)
				takisCount = $+1
			end
		end
		playerCount = $+1
	end

	m.exitingcount = exitingCount
	m.playercount = playerCount
	m.takiscount = takisCount
	
	if not (leveltime % 3*TR)
	and ((multiplayer) and not splitscreen)
	and not (t.noachs)
		if m.takiscount >= 6
			for p in players.iterate
				if skins[p.skin].name == TAKIS_SKIN
				and not (p.takistable.achfile & ACHIEVEMENT_TAKISFEST)
					TakisAwardAchievement(p,ACHIEVEMENT_TAKISFEST)
				end
			end
			
		end
	end
	
	if (ultimatemode)
		if TAKIS_MAX_HEARTCARDS ~= 1
			TakisChangeHeartCards(1)
		end
	else
		if TAKIS_MAX_HEARTCARDS < 1
			TakisChangeHeartCards(6)
		end
	end
	
	if m.inbossmap
		local bump = bumpinterval[string.lower(mapheaderinfo[gamemap].musname or '')] or TR
		if (leveltime % bump) == 0
			m.cardbump = 10*FU
		end
	end
	
	if m.cardbump ~= 0 then m.cardbump = $*5/6 end
end)

--didnt know stagefailed was passed onto IntermissionThinker
--until i looked at the source code. this should be documented
--on the wiki now, thanks to yours truely :))))
addHook("IntermissionThinker",function(stagefailed)
	m.inttic = $+1
	m.stagefailed = stagefailed
	
	for p in players.iterate
		local takis = p.takistable
		
		if takis
		and (skins[p.skin].name == TAKIS_SKIN)
		and takis.lastss
			if m.inttic == TR
				if not stagefailed
				and string.lower(G_BuildMapTitle(takis.lastmap)) ~= "black hole zone"
					S_StartSound(nil,sfx_sptclt,p)
				else
					S_StartSound(nil,sfx_altdi1,p)
				end
			elseif m.inttic == TR+(TR*4/5)
				if All7Emeralds(emeralds)
					S_StartSound(nil,sfx_tayeah,p)
				elseif not stagefailed
					if string.lower(G_BuildMapTitle(takis.lastmap)) == "black hole zone"
						S_StartSound(nil,sfx_takoww,p)
					else
						S_StartAntonLaugh(nil,p)
					end
				else
					S_StartSound(nil,sfx_antow3,p)
				end
			end
		end
	end
end)

--this only works if you dont have a menu open...
addHook("KeyDown", function(key)
	if gamestate == GS_TITLESCREEN
		TAKIS_TITLETIME = $-10
		if TAKIS_TITLETIME < 0 then TAKIS_TITLETIME = 0 end
	end
end)

filesdone = $+1
