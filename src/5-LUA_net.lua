local t = TAKIS_NET

rawset(_G,"CV_TAKIS",{})
CV_TAKIS.nerfarma = CV_RegisterVar({
	name = "takis_nerfarma",
	defaultvalue = "false",
	flags = CV_NETVAR,
	PossibleValue = CV_TrueFalse
})
CV_TAKIS.tauntkills = CV_RegisterVar({
	name = "takis_tauntkills",
	defaultvalue = "true",
	flags = CV_NETVAR,
	PossibleValue = CV_TrueFalse
})
CV_TAKIS.achs = CV_RegisterVar({
	name = "takis_achs",
	defaultvalue = "true",
	flags = CV_NETVAR,
	PossibleValue = CV_TrueFalse
})
CV_TAKIS.collaterals = CV_RegisterVar({
	name = "takis_collaterals",
	defaultvalue = "true",
	flags = CV_NETVAR,
	PossibleValue = CV_TrueFalse
})
CV_TAKIS.heartcards = CV_RegisterVar({
	name = "takis_heartcards",
	defaultvalue = "true",
	flags = CV_NETVAR,
	PossibleValue = CV_TrueFalse
})
CV_TAKIS.hammerquake = CV_RegisterVar({
	name = "takis_hammerquakes",
	defaultvalue = "true",
	flags = CV_NETVAR,
	PossibleValue = CV_TrueFalse
})

local boolean = {
	["false"] = false,
	["true"] = true,
}
local function CVtoNET()
	t.nerfarma = boolean[string.lower(CV_TAKIS.nerfarma.string)]
	t.tauntkillsenabled = boolean[string.lower(CV_TAKIS.tauntkills.string)]
	t.noachs = not boolean[string.lower(CV_TAKIS.achs.string)]
	t.collaterals = boolean[string.lower(CV_TAKIS.collaterals.string)]
	t.cards = boolean[string.lower(CV_TAKIS.heartcards.string)]
	t.hammerquakes = boolean[string.lower(CV_TAKIS.hammerquake.string)]
end

local function livesCount()
	if (gametyperules & GTR_TAG)
		return
	elseif (G_GametypeHasTeams())
		return
	else
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
				
				t.livescount = lives
			end
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
	
	t.ideyadrones = {}
	HH_Reset()
end)
--should these 2 HH_Resets be here?
addHook("MapLoad", function(mapid)
	HH_Reset()
	
	t.inbossmap = false
	
	t.numdestroyables = 0
	
	t.inspecialstage = G_IsSpecialStage(mapid)
	t.isretro = (maptol & TOL_MARIO)
	
	t.livescount = 0
	
	for mt in mapthings.iterate
		if mt.mobj and mt.mobj.valid
			local mobj = mt.mobj
			
			if mobj.type == MT_CYBRAKDEMON
				t.inbrakmap = true
			end
			
			if mobj.type == MT_EGGMAN_BOX
				continue
			end
			
			if (mobj.flags & (MF_ENEMY|MF_MONITOR))
			or (SPIKE_LIST[mobj.type] == true)
			or (mobj.takis_flingsme ~= false)
				mobj.partofdestoys = true
				t.numdestroyables = $+1
			end
		else
			continue
		end
		
	end
	
	t.partdestroy = t.numdestroyables/(t.playercount+2) or 1
	
end)

addHook("ThinkFrame", do
	
	CVtoNET()
	
	if gamestate == GS_TITLESCREEN
		TAKIS_TITLETIME = $+1
		
		--you probably wont get this without stalling
		if TAKIS_TITLETIME == (120*FU)
			S_ChangeMusic("D",false)
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
	
	livesCount()
	
	local playerCount = 0
	local exitingCount = 0
	local takisCount = 0
	for player in players.iterate
		if player.valid
			if player.exiting
			or player.spectator 
			or player.pizzaface
			or player.playerstate == PST_DEAD
				exitingCount = $+1
			end
			if (skins[player.skin] == TAKIS_SKIN)
				takisCount = $+1
			end
		end
		playerCount = $+1
	end

	t.exitingcount = exitingCount
	t.playercount = playerCount
	t.takiscount = takisCount
	
	--PLEASE... I WANT MY EARS
	if not (leveltime % 3*TR)
	and ((multiplayer) and not splitscreen)
	and not (t.noachs)
		if t.takiscount >= 6
			for p in players.iterate
				if (p ~= consoleplayer) then continue end
				if skins[p.skin].name == TAKIS_SKIN
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
	
end)


filesdone = $+1
