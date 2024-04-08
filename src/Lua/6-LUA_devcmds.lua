if not TAKIS_ISDEBUG
	filesdone = $+1
	return
end

local prn = CONS_Printf

local ranktonum = {
	["P"] = 6,
	["S"] = 5,
	["A"] = 4,
	["B"] = 3,
	["C"] = 2,
	["D"] = 1,
}

COM_AddCommand("setrank", function(p,rank)
	if gamestate ~= GS_LEVEL
		prn(p,"You can't use this right now.")
		return
	end
	
	if not (p.takistable)
		prn(p,"You can't use this right now.")
		return	
	end
	
	if rank == nil
		return
	end
	
	if (gametype ~= GT_PTSPICER)
		return
	end
	
	if not (ranktonum[rank])
		rank = "D"
	end
	
	if ranktonum[rank] > 6
		rank = "P"
	end
	
	if ranktonum[rank] < 1
		rank = "D"
	end
	
	
	local pec = (PTSR.maxrankpoints)/6
	if rank == "D"
		p.score = 0
	elseif rank == "C" then
		p.score = pec*2
		
	elseif rank == "B" then
		p.score = pec*4
	elseif rank == "A" then
		p.score = pec*8
	elseif rank == "S" then
		p.score = pec*13
	else
		/*
		if player.timeshit then
			player.ptsr_rank = "S"
		else
			player.ptsr_rank = "P"
		end
		*/
		
		player.ptsr_rank = "P"
	end
	

	
end,COM_ADMIN)

COM_AddCommand("sethp", function(p,type,amt)
	if gamestate ~= GS_LEVEL
		return
	end
	if not p.mo.health
		return
	end
	local takis = p.takistable
	if not (takis.isTakis)
		return
	end
	if type == nil
		return
	end
	if amt == nil
		return
	end
	
	type = tonumber($)
	if ((type > 3) or (type < 1))
		return
	end
	
	TakisHealPlayer(p,p.mo,takis,type,amt)
end,COM_ADMIN)

local function GetPlayerHelper(pname)
	-- Find a player using their node or part of their name.
	local N = tonumber(pname)
	if N ~= nil and N >= 0 and N < 32 then
		for player in players.iterate do
			if #player == N then
	return player
			end
		end
	end
	for player in players.iterate do
		if string.find(string.lower(player.name), string.lower(pname)) then
			return player
		end
	end
	return nil
end
local function GetPlayer(player, pname)
	local player2 = GetPlayerHelper(pname)
	if not player2 then
		CONS_Printf(player, "No one here has that name.")
	end
	return player2
end

COM_AddCommand("setscore", function(p,score)
	if gamestate ~= GS_LEVEL
		prn(p,"You can't use this right now.")
		return
	end

	if score == nil
		return
	end
	
	if string.lower(score) == "max"
		p.score = UINT32_MAX
		return
	end
	
	score = abs(tonumber(score))
	
	p.score = score
end,COM_ADMIN)

local shields = {
	["n"] = SH_NONE,
	["p"] = SH_PITY,
	["w"] = SH_WHIRLWIND,
	["a"] = SH_ARMAGEDDON,
	["pk"] = SH_PINK,
	["e"] = SH_ELEMENTAL,
	["m"] = SH_ATTRACT,
	["fa"] = SH_FLAMEAURA,
	["b"] = SH_BUBBLEWRAP,
	["t"] = SH_THUNDERCOIN,
	["f"] = SH_FORCE|1,
	["ff"] = SH_FIREFLOWER,
}

COM_AddCommand("shield", function(p,sh)
	if gamestate ~= GS_LEVEL
		prn(p,"You can't use this right now.")
		return
	end

	if sh == nil
		return
	end
	
	sh = string.lower($)
	
	if shields[sh]
		p.powers[pw_shield] = shields[sh]
		if shields[sh] ~= 0
			P_SpawnShieldOrb(p)
		else
			P_RemoveShield(p)
		end
		if sh == "ff"
			p.realmo.color = SKINCOLOR_WHITE
		end
	end
	
end,COM_ADMIN)

COM_AddCommand("leave", function(p)
	if gamestate ~= GS_LEVEL
		prn(p,"You can't use this right now.")
		return
	end
	
	P_DoPlayerExit(p)
	p.exiting = 4
end,COM_ADMIN)

COM_AddCommand("setdebug", function(p,...)
	local args = {...}
	/*
	if args == {}
		CONS_Printf(p,"Current flag is "..TAKIS_DEBUGFLAG)
		CONS_Printf(p,"Use: speedometer, happyhour, buttons")
		return
	end
	*/
	
	for _, enum in ipairs(args)
		local todo = string.upper(enum)
		local realnum = _G["DEBUG_"..todo] or 0
		if realnum ~= 0
			if TAKIS_DEBUGFLAG & realnum
				TAKIS_DEBUGFLAG = $ &~realnum
			else
				TAKIS_DEBUGFLAG = $|realnum
			end
		else
			prn(p,"Flag invalid ("..todo..")")
		end
	end
	
end,COM_LOCAL)

COM_AddCommand("panic", function(p,tics,flags)
	if gamestate ~= GS_LEVEL
		prn(p,"You can't use this right now.")
		return
	end
	
	if (HAPPY_HOUR.othergt)
		if not HAPPY_HOUR.happyhour
			COM_BufInsertText(p,"ptsr_pizzatimenow")
		else
			COM_BufInsertText(p,"ptsr_timeto1")
		end
		return
	end
	
	if tics == nil
		return
	end
	
	if flags == nil
		flags = 0
	end
	
	flags = abs(tonumber($)) or 0
	
	tics = abs(tonumber($)) or 0
	
	if (flags & 1 == 1)
		tics = $*TR
	elseif (flags & 2 == 2)
		tics = $*60*TR
	end
	
	--erm,, whatevre, set it to the playher
	HH_Trigger(p.realmo,p,tics)
	
end,COM_ADMIN)

COM_AddCommand("shotgun", function(p,force)
	if gamestate ~= GS_LEVEL
		prn(p,"You can't use this right now.")
		return
	end
	
	if not (p.takistable)
		prn(p,"You can't use this right now.")
		return	
	end
	
	if not (p.mo.health)
	or (p.mo.skin ~= TAKIS_SKIN)
		prn(p,"You can't use this right now.")
		return	
	end
	
	local takis = p.takistable
	
	if (takis.shotgunned)
		TakisDeShotgunify(p,force ~= nil)
	
	else
		TakisShotgunify(p)
	end
	
end,COM_ADMIN)

COM_AddCommand("kart", function(p)
	if gamestate ~= GS_LEVEL
		prn(p,"You can't use this right now.")
		return
	end
	
	if not (p.takistable)
		prn(p,"You can't use this right now.")
		return	
	end
	
	if not (p.mo.health)
		prn(p,"You can't use this right now.")
		return	
	end
	
	local x,y = ReturnTrigAngles(p.mo.angle+ANGLE_90)
	P_SpawnMobjFromMobj(p.mo,-75*x,-75*y,0,MT_TAKIS_KART)
	
end,COM_ADMIN)

local function GetPlayerHelper(pname)
	-- Find a player using their node or part of their name.
	local N = tonumber(pname)
	if N ~= nil and N >= 0 and N < 32 then
		for player in players.iterate do
			if #player == N then
	return player
			end
		end
	end
	for player in players.iterate do
		if string.find(string.lower(player.name), string.lower(pname)) then
			return player
		end
	end
	return nil
end
local function GetPlayer(player, pname)
	local player2 = GetPlayerHelper(pname)
	if not player2 then
		CONS_Printf(player, "No one here has that name.")
	end
	return player2
end

COM_AddCommand("shotgunfor", function(p,node,force)
	if gamestate ~= GS_LEVEL
		prn(p,"You can't use this right now.")
		return
	end
	
	if node == nil
		return
	end
	
	local p2 = GetPlayer(p,node)
	if p2
		if not (p2.takistable)
			prn(p,"You can't use this right now.")
			return	
		end
		
		local takis = p2.takistable
		if not (p2.mo.health)
		or (p2.mo.skin ~= TAKIS_SKIN)
			prn(p,"You can't use this right now.")
			return	
		end
		
		if (takis.shotgunned)
			TakisDeShotgunify(p2,force ~= nil)
		
		else
			TakisShotgunify(p2)
		end
		
		prn(p,"Shotgunified "..p2.name)
		prn(p2,p.name.." gifted you with the Shotgun")
	end
end,COM_ADMIN)

COM_AddCommand("setmaxhp",function(p,amt)
	if gamestate ~= GS_LEVEL
		CONS_Printf(p,"You can't use this right now.")
	end


	if (amt == nil)
		CONS_Printf(p,"Type number lel")
		return
	else
		amt = abs(tonumber(amt))
		if amt == 0
			CONS_Printf(p,"You do this you die")
			return
		end
		TakisChangeHeartCards(amt)
	end
end,COM_ADMIN)

COM_AddCommand("forcedialog",function(p,type)
	if gamestate ~= GS_LEVEL
		CONS_Printf(p,"You can't use this right now.")
	end
	
	if TAKIS_TEXTBOXES[type] ~= nil
		CFTextBoxes:DisplayBox(p,TAKIS_TEXTBOXES[type])
	end
end,COM_ADMIN)

COM_AddCommand("killme",function(p,type)
	if gamestate ~= GS_LEVEL
		CONS_Printf(p,"You can't use this right now.")
	end
	
	if type == nil then return end
	
	type = string.upper($)
	type = _G["DMG_"..type] or DMG_INSTAKILL
	P_KillMobj(p.realmo,nil,nil,type)
	p.takistable.saveddmgt = type
	p.deadtimer = 1
	
end,COM_ADMIN)

COM_AddCommand("invuln", function(p,tics,flags)
	if gamestate ~= GS_LEVEL
		prn(p,"You can't use this right now.")
		return
	end
	
	if tics == nil
		return
	end
	
	if flags == nil
		flags = 0
	end
	
	flags = abs(tonumber($)) or 0
	
	tics = abs(tonumber($)) or 0
	
	if (flags & 1 == 1)
		tics = $*TR
	elseif (flags & 2 == 2)
		tics = $*60*TR
	end
	
	p.powers[pw_invulnerability] = tics
end,COM_ADMIN)

COM_AddCommand("freeroam",NiGHTSFreeroam,COM_ADMIN)

COM_AddCommand("spheres", function(p, num)
	if gamestate ~= GS_LEVEL
		prn(p,"You can't use this right now.")
		return
	end
	
	if tonumber(num) == nil then return end
	
	num = tonumber($)
	
	p.spheres = num
end,COM_ADMIN)

COM_AddCommand("lives", function(p, num)
	if gamestate ~= GS_LEVEL
		prn(p,"You can't use this right now.")
		return
	end
	
	if tonumber(num) == nil then return end
	
	num = tonumber($)
	
	p.lives = num
end,COM_ADMIN)

COM_AddCommand("setach", function(p, num)
	if gamestate ~= GS_LEVEL
		prn(p,"You can't use this right now.")
		return
	end
	
	if tonumber(num) == nil 
		if num == "all"
			for i = 0,NUMACHIEVEMENTS-1
				TakisAwardAchievement(p,1<<i)
			end
		end
		return
	end
	
	local file = p.takistable.achfile
	local enum = 1<<tonumber(num)
	
	if file & enum
		file = $ &~enum
	else
		TakisAwardAchievement(p,enum)
	end
	
end,COM_ADMIN)

COM_AddCommand("sharecombo", function(p, num)
	if gamestate ~= GS_LEVEL
		prn(p,"You can't use this right now.")
		return
	end
	
	if tonumber(num) == nil 
		return
	end
	
	local sharedex = p.takistable.HUD.comboshare[#p]
	sharedex.comboadd = $+num
	sharedex.tics = TR*3/2
	local x,y = R_GetScreenCoords(nil,p,camera,players[#p].realmo)
	sharedex.x,sharedex.y = x,y
	sharedex.startx,sharedex.starty = x,y
	
end,COM_ADMIN)

COM_AddCommand("forcecheat", function(p, num)
	if gamestate ~= GS_LEVEL
		prn(p,"You can't use this right now.")
		return
	end
	
	G_SetUsedCheats(false)
	
end,COM_ADMIN)

COM_AddCommand("pong", function(p)
	if gamestate ~= GS_LEVEL
		prn(p,"You can't use this right now.")
		return
	end
	
	TakisSpawnPongler(p.realmo,p.drawangle)
	
end,COM_ADMIN)

COM_AddCommand("testmap", function(p)
	if gamestate ~= GS_LEVEL
		prn(p,"You can't use this right now.")
		return
	end
	
	if not (p.takistable)
		prn(p,"You can't use this right now.")
		return	
	end
	
	if G_BuildMapTitle(1003) ~= "Test Room"
		prn(p,"Test map has been replaced, cannot teleport.")
		return	
	end
	
	G_SetCustomExitVars(1003,2)
	G_ExitLevel()
	
end,COM_ADMIN)

COM_AddCommand('powerstone', function(p, arg)
	if arg == nil
		return
	else
		if arg == 'all' then arg = '1234567' end
		local previous = p.powers[pw_emeralds]
		p.powers[pw_emeralds] = 0
		local bit = 1
		for i=1,7 do
			if string.find(arg, tostring(i)) ~= nil then
				p.powers[pw_emeralds] = $ | bit
			end
			bit = $ * 2
		end
	end
end, COM_ADMIN)

COM_AddCommand("prhappyhour", function(p)
	local strings = prtable("Happy Hour",HAPPY_HOUR,false)
	for k,va in ipairs(strings)
		print(va)
	end
	
	local dh = {}
	dh.x = tonumber(mapheaderinfo[gamemap].takis_hh_exit_x)
	dh.y = tonumber(mapheaderinfo[gamemap].takis_hh_exit_y)
	dh.z = tonumber(mapheaderinfo[gamemap].takis_hh_exit_z)
	for k,v in pairs(dh)
		if v == nil
			dh.valid = false
			break
		else
			dh.valid = true
			continue
		end
	end
	local th = {}
	th.x = tonumber(mapheaderinfo[gamemap].takis_hh_trig_x)
	th.y = tonumber(mapheaderinfo[gamemap].takis_hh_trig_y)
	th.z = tonumber(mapheaderinfo[gamemap].takis_hh_trig_z)
	th.flip = mapheaderinfo[gamemap].takis_hh_trig_flip ~= nil
	for k,v in pairs(th)
		if type(v) == "boolean" then continue end
		if v == nil
			th.valid = false
			break
		else
			th.valid = true
			continue
		end
	end
	
	print("door: {x="..(dh.x or "nil")..",y="..(dh.y or "nil")..",z="..(dh.z or "nil").."}")
	print("trig: {x="..(th.x or "nil")..",y="..(th.y or "nil")..",z="..(th.z or "nil")..",f="..(tostring(th.flip) or "nil").."}")
	print("candoshit: "..tostring( HH_CanDoHappyStuff(p) ))
end,COM_ADMIN)

/*
COM_AddCommand("_gmodify", function(p,gdex,value,vty)
	local dex = _G[gdex]
	
	if dex == nil
		prn(p,"This global var is nil")
		return
	end
	
	local type = type(dex)
	
	if type == "no value"
		prn(p,"This global var has no value")
		return
	elseif type == "function"
		prn(p,"This global var is a function")
		return
	elseif type == "table"
		prtable(gdex,dex)
		return
	end
	
	if vty == "boolean"
		value = boolean[string.lower($)]
	elseif vty == "number"
		value = tonumber($)
	end
	
	print("Changing "..gdex.." from "..tostring(dex).." to "..tostring(value))
	dex = value
	print(dex)
	
end,COM_ADMIN)
*/

filesdone = $+1
