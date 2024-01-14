local prn = CONS_Printf
local function choose(...)
	local args = {...}
	local choice = P_RandomRange(1,#args)
	return args[choice]
end

COM_AddCommand("takis_nostrafe", function(p)
	if gamestate ~= GS_LEVEL
		prn(p,"You can't use this right now.")
		return
	end
	
	if not (p.takistable)
		prn(p,"You can't use this right now.")
		return	
	end
	
	if p.takistable.io.nostrafe
		p.takistable.io.nostrafe = 0
		prn(p,skins[TAKIS_SKIN].realname.." will now force strafing.")
	else
		p.takistable.io.nostrafe = 1
		prn(p,skins[TAKIS_SKIN].realname.." will no longer force strafing.")
	end
	
	TakisSaveStuff(p)
end)
COM_AddCommand("takis_nohappyhour", function(p)
	if gamestate ~= GS_LEVEL
		prn(p,"You can't use this right now.")
		return
	end
	
	if not (p.takistable)
		prn(p,"You can't use this right now.")
		return	
	end
	
	if p.takistable.io.nohappyhour == 0
		p.takistable.io.nohappyhour = 1
		prn(p,skins[TAKIS_SKIN].realname.." will no longer show Happy Hour things in Pizza Time Spice Runners.")
		COM_BufInsertText(p,"tunes -default")
	else
		p.takistable.io.nohappyhour = 0
		prn(p,skins[TAKIS_SKIN].realname.." will now show Happy Hour things in Pizza Time Spice Runners.")
		COM_BufInsertText(p,"tunes -default")
	end
	
	TakisSaveStuff(p)
end)

COM_AddCommand("takis_morehappyhour", function(p)
	if gamestate ~= GS_LEVEL
		prn(p,"You can't use this right now.")
		return
	end
	
	if not (p.takistable)
		prn(p,"You can't use this right now.")
		return	
	end
	
	if p.takistable.io.morehappyhour == 1
		p.takistable.io.morehappyhour = 0
		prn(p,"Only "..skins[TAKIS_SKIN].realname.." will have Happy Hour in Jisk's Pizza Time.")
	else
		p.takistable.io.morehappyhour = 1
		prn(p,"Other characters will have Happy Hour in Jisk's Pizza Time.")
	end
	
	TakisSaveStuff(p)
end)

COM_AddCommand("takis_debuginfo", takis_printdebuginfo)

COM_AddCommand("takis_saveconfig", TakisSaveStuff)
COM_AddCommand("takis_loadconfig", function(p)
	p.takistable.io.loaded = false
	TakisLoadStuff(p)
end)

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

COM_AddCommand("takis_dojumpscare", function(p,node,wega)
	if gamestate ~= GS_LEVEL
		prn(p,"You can't use this right now.")
		return
	end
	
	if not (p.takistable)
		prn(p,"You can't use this right now.")
		return	
	end

	if not node
		prn(p,"Forces Takis' jumpscare on someone. Type @random to choose a random person in the server")
		return
	end
	
	--@ because you cant start names with it
	if node == "@random"
		local plist = {}
		for play in players.iterate
			if play.bot
			or play.quittime
				continue
			end
			table.insert(plist,#play)
		end
		if #plist == 1
			prn(p,"There's no one else to choose but you!")
		end
		
		node = choose(unpack(plist))
	end
	
	local p2 = GetPlayer(p,node)
	if p2
		TakisJumpscare(p2,wega ~= nil)
		prn(p,"Jumpscared "..p2.name)
	end
	
end,COM_ADMIN)

COM_AddCommand("takis_tauntmenucursor", function(p)
	if gamestate ~= GS_LEVEL
		prn(p,"You can't use this right now.")
		return
	end
	
	if not (p.takistable)
		prn(p,"You can't use this right now.")
		return	
	end
	
	if p.takistable.io.tmcursorstyle == 1
		p.takistable.io.tmcursorstyle = 2
		prn(p,"You can now use Weapon Next/Prev to scroll the Taunt Menu")
	else
		p.takistable.io.tmcursorstyle = 1
		prn(p,"You can now use numbers 1-7 to scroll the Taunt Menu")
	end
	
	TakisSaveStuff(p)
end)

COM_AddCommand("takis_quakes", function(p)
	if gamestate ~= GS_LEVEL
		prn(p,"You can't use this right now.")
		return
	end
	
	if not (p.takistable)
		prn(p,"You can't use this right now.")
		return	
	end
	
	if p.takistable.io.quakes == 1
		p.takistable.io.quakes = 0
		prn(p,skins[TAKIS_SKIN].realname.." will no longer cause screen quakes")
	else
		p.takistable.io.quakes = 1
		prn(p,skins[TAKIS_SKIN].realname.." will now cause screen quakes.")
	end
	
	TakisSaveStuff(p)
end)

COM_AddCommand("takis_flashes", function(p)
	if gamestate ~= GS_LEVEL
		prn(p,"You can't use this right now.")
		return
	end
	
	if not (p.takistable)
		prn(p,"You can't use this right now.")
		return	
	end
	
	if p.takistable.io.flashes == 1
		p.takistable.io.flashes = 0
		prn(p,skins[TAKIS_SKIN].realname.." will no longer cause screen flashes")
	else
		p.takistable.io.flashes = 1
		prn(p,skins[TAKIS_SKIN].realname.." will now cause screen flashes.")
	end
	
	TakisSaveStuff(p)
end)

COM_AddCommand("takis_instructions", function(p)
	CONS_Printf(p, "Check out the enclosed instruction book!")
	CONS_Printf(p, "	https://tinyurl.com/mr45rtzz")
	CONS_Printf(p, "Open your latest-log.txt and copy the link into your browser! (Google Docs link)")
end)

COM_AddCommand("takis_showmenuhints", function(p)
	local takis = p.takistable
	
	if not takis
		return
	end
	
	if not takis.cosmenu.menuinaction
		return
	end
	
	if takis.cosmenu.hintfade
		return
	end
	
	takis.cosmenu.hintfade = 3*TR+18
end)

COM_AddCommand("takis_importantletter", function(p)
	local takis = p.takistable
	
	if not takis
		return
	end
	
	if not takis.cosmenu.menuinaction
		return
	end
	
	if takis.HUD.showingletter
		return
	end
	
	if not takis.isTakis
		return
	end
	
	takis.HUD.showingletter = true
	P_PlayJingleMusic(p,"letter",0,true,JT_OTHER)
end)

COM_AddCommand("takis_openmenu", function(p)
	local takis = p.takistable
	
	if not takis
		return
	end
	TakisMenuOpenClose(p)
	
end)
COM_AddCommand("takis_additiveafterimages", function(p)
	if gamestate ~= GS_LEVEL
		prn(p,"You can't use this right now.")
		return
	end
	
	if not (p.takistable)
		prn(p,"You can't use this right now.")
		return	
	end
	
	if p.takistable.io.additiveai
		p.takistable.io.additiveai = 0
		prn(p,skins[TAKIS_SKIN].realname.." will no longer have additive afterimages.")
	else
		p.takistable.io.additiveai = 1
		prn(p,skins[TAKIS_SKIN].realname.." will now have additive afterimages.")
	end
	
	TakisSaveStuff(p)
end)
COM_AddCommand("takis_deleteachievements", function(p)
	if gamestate ~= GS_LEVEL
		prn(p,"You can't use this right now.")
		return
	end
	
	if not (p.takistable)
		prn(p,"You can't use this right now.")
		return	
	end
	
	p.takistable.achfile = 0
	TakisSaveAchievements(p)
	
	prn(p,"Deleted "..skins[TAKIS_SKIN].realname.."'s achievements.")
	
end)

COM_AddCommand("takis_clutchstyle", function(p)
	if gamestate ~= GS_LEVEL
		prn(p,"You can't use this right now.")
		return
	end
	
	if not (p.takistable)
		prn(p,"You can't use this right now.")
		return	
	end
	
	if p.takistable.io.clutchstyle
		p.takistable.io.clutchstyle = 0
		prn(p,"The Clutch Bar will now be near the lives area.")
	else
		p.takistable.io.clutchstyle = 1
		prn(p,"The Clutch Bar will now be near Takis.")
	end
	
	TakisSaveStuff(p)
end)
COM_AddCommand("takis_dontshowach", function(p)
	if gamestate ~= GS_LEVEL
		prn(p,"You can't use this right now.")
		return
	end
	
	if not (p.takistable)
		prn(p,"You can't use this right now.")
		return	
	end
	
	if p.takistable.io.dontshowach
		p.takistable.io.dontshowach = 0
		prn(p,"You will now be able to see when other Takis players get achievements.")
	else
		p.takistable.io.dontshowach = 1
		prn(p,"You will no longer be able to see when other Takis players get achievements.")
	end
	
	TakisSaveStuff(p)
end)
COM_AddCommand("takis_sharecombos", function(p)
	if gamestate ~= GS_LEVEL
		prn(p,"You can't use this right now.")
		return
	end
	
	if not (p.takistable)
		prn(p,"You can't use this right now.")
		return	
	end
	
	if p.takistable.io.sharecombos
		p.takistable.io.sharecombos = 0
		prn(p,"You will will no longer share Combos with other Takis players.")
	else
		p.takistable.io.sharecombos = 1
		prn(p,"You will now be able to share Combos with other Takis players.")
	end
	
	TakisSaveStuff(p)
end)


filesdone = $+1
