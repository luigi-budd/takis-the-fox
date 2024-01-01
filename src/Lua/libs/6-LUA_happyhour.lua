--happy hour stuff
local function L_ZCollide(mo1,mo2)
	if mo1.z > mo2.height+mo2.z then return false end
	if mo2.z > mo1.height+mo1.z then return false end
	return true
end
local function choosething(...)
	local args = {...}
	local choice = P_RandomRange(1,#args)
	return args[choice]
end

rawset(_G,"HAPPY_HOUR",{
	happyhour = false,
	
	timelimit = 0,
	timeleft = 0,
	time = 0,
	
	othergt = false,
	overtime = false,
	
	trigger = 0,
	exit = 0,
		
	gameover = false,
	gameovertics = 0,
	
	song = "hapyhr",
	songend = "hpyhre",
	nosong = false,
	noendsong = false,
})

local hh = HAPPY_HOUR

rawset(_G,"HH_Trigger",function(actor,player,timelimit)
	if not hh.happyhour
	
		if timelimit == nil
			timelimit = 3*60*TR
		end
		--add 2 more seconds for the timer tween
		if timelimit ~= 0
			hh.timelimit = timelimit+2*TR
			hh.timeleft = hh.timelimit
		else
			hh.timelimit = 0
		end
		
		hh.happyhour = true
		hh.time = 1
		hh.gameover = false
		hh.gameovertics = 0
		
		for p in players.iterate
			if (hh.nosong == false)
				S_ChangeMusic(hh.song,p)
				mapmusname = hh.song
			end
			if multiplayer
				p.realmo.momx,p.realmo.momy,p.realmo.momz = 0,0,0
				p.powers[pw_nocontrol] = 5
				P_SetOrigin(p.realmo,
					actor.x,
					actor.y,
					GetActorZ(actor,actor,2)
				)
			end
		end
		
		if not (actor and actor.valid) then return end
		
		local tag = nil
		local activator = actor
		if player and player.valid
			activator = player.realmo
		end
		if (mapheaderinfo[gamemap].takis_hh_tag ~= nil
		and (tonumber(mapheaderinfo[gamemap].takis_hh_tag)))
			tag = tonumber(mapheaderinfo[gamemap].takis_hh_tag)
			P_LinedefExecute(tag,activator,nil)
		end
		
		if (hh.exit and hh.exit.valid)
			if hh.exit.type == MT_HHEXIT
				if (hh.exit.type == MT_HHEXIT)
					hh.exit.state = S_HHEXIT_OPEN
				end
			end
		else
			for mobj in mobjs.iterate()
				if mobj.type == MT_HHEXIT
					mobj.state = S_HHEXIT_OPEN
					hh.exit = mobj
				end
			end
		end
		
		hh.trigger = actor
	end
end)

rawset(_G,"HH_Reset",function()
	hh.happyhour = false
	hh.timelimit = 0
	hh.timeleft = 0
	hh.time = 0
	hh.trigger = 0
	hh.exit = 0
	hh.gameover = false
	hh.gameovertics = 0
	
	if (gamestate == GS_LEVEL)
		if (mapheaderinfo[gamemap].takis_hh_nointer)
			G_SetCustomExitVars(mapheaderinfo[gamemap].nextlevel,1)
		end
	end
end)

addHook("ThinkFrame",do

	local nomus = string.lower(mapheaderinfo[gamemap].takis_hh_nomusic or '') == "true"
	local noendmus = string.lower(mapheaderinfo[gamemap].takis_hh_noendmusic or '') == "true"
	
	local song = mapheaderinfo[gamemap].takis_hh_music or "hapyhr"
	local songend = mapheaderinfo[gamemap].takis_hh_endmusic or "hpyhre"
	
	song,songend = string.lower($1),string.lower($2)
	
	hh.song = song
	hh.songend = songend
	hh.nosong = nomus
	hh.noendsong = noendmus
	
	hh.othergt = (gametype == GT_PTSPICER)
	if hh.othergt
		hh.happyhour = PTSR.pizzatime --and (PTSR.gameover == false)
		hh.timelimit = CV_PTSR.timelimit.value*TICRATE*60 or 0
		hh.timeleft = PTSR.timeleft
		hh.time = PTSR.pizzatime_tics
		hh.overtime = hh.timeleft <= 0 and hh.happyhour
		hh.gameover = PTSR.gameover
	else
	
		if hh.happyhour
			
			if not hh.gameover
				hh.time = $+1
				if (hh.timeleft)
					hh.timeleft = $-1
				end
			else
				hh.gameovertics = $+1
			end
			
			if (G_EnoughPlayersFinished())
			and not hh.gameover
				for p in players.iterate()
					if skins[p.skin].name == TAKIS_SKIN then continue end
					S_StopMusic(p)
				end
				hh.gameover = true
			end
			
			for p in players.iterate
				if not (p and p.valid) then continue end
				if not (p.mo and p.mo.valid) then continue end
				if (not p.mo.health) or (p.playerstate ~= PST_LIVE) then continue end
				
				local me = p.mo
				local takis = p.takistable
				
				--finish thinker
				if (p.exiting or p.pflags & PF_FINISHED)
				and (hh.exit and hh.exit.valid)
					P_DoPlayerExit(p)
					me.flags2 = $|MF2_DONTDRAW
					
					me.momx,me.momy,me.momz = 0,0,0
					P_SetOrigin(me,hh.exit.x,hh.exit.y,hh.exit.z)
					
					p.pflags = $|PF_FINISHED
					if hh.gameovertics < (2*TR)+(TR/2)+5
						p.exiting = max(99,$)
					end
					
					p.powers[pw_flashing] = 3
					p.powers[pw_shield] = 0
					
					if (takis.isTakis)
						takis.goingfast = false
						takis.wentfast = 0
						takis.noability = $|NOABIL_ALL
					end
					
					continue
				end
				
				if (p.happydeath)
					--DONT let them respawn....
					if (multiplayer)
						p.deadtimer = min(3,$)
					end
					if (p.playerstate ~= PST_DEAD)
						p.happydeath = false
					end
					continue
				end
				
				if not hh.gameover
					if not (hh.time % TR)
					and (hh.time)
						if not (maptol & TOL_NIGHTS)
							if (p.score > 5)
								p.score = $-5
							else
								p.score = 0
							end
						else	
							P_AddPlayerScore(p,-5)
						end
					end
				end
				
			end
			
			if (hh.timelimit ~= nil or hh.timelimit ~= 0)
				if hh.timelimit < 0
					hh.timelimit = 3*60*TR
				end
				
				--hh.timeleft = hh.timelimit-hh.time
				
				if hh.timeleft == 0
					if hh.othergt then return end
					if not hh.gameover then hh.gameover = true end
					
					for p in players.iterate
						if not (p and p.valid) then continue end
						if not (p.mo and p.mo.valid) then continue end
						if (p.exiting or p.pflags & PF_FINISHED) then continue end
						
						if not (p.happydeath)
							P_KillMobj(p.mo)
							p.happydeath = true
							--too bad! sucks to suck!
							if (p.score < 10000)
								p.score = 0
							else
								p.score = $-10000
							end
							p.exiting = 99
							--no time bonus
							p.rings = 0
							p.realtime = leveltime*99
						end
					end
					
				end
			end
			
		end
	end
end)

----	trigger stuff
freeslot("SPR_HHT_")
freeslot("S_HHTRIGGER_IDLE")
freeslot("S_HHTRIGGER_PRESSED")
freeslot("S_HHTRIGGER_ACTIVE")
freeslot("MT_HHTRIGGER")
freeslot("sfx_hhtsnd")
sfxinfo[sfx_hhtsnd] = {
	flags = SF_X2AWAYSOUND,
	caption = "/",
}

states[S_HHTRIGGER_IDLE] = {
	sprite = SPR_HHT_,
	frame = O,
	tics = -1
}
states[S_HHTRIGGER_PRESSED] = {
	sprite = SPR_HHT_,
	frame = A,
	tics = 5,
	nextstate = S_HHTRIGGER_ACTIVE
}
states[S_HHTRIGGER_ACTIVE] = {
	sprite = SPR_HHT_,
	frame = A,
	tics = -1,
}

mobjinfo[MT_HHTRIGGER] = {
	--$Name Happy Hour Trigger
	--$Sprite HHT_O0
	--$Category Takis Stuff
	doomednum = 3000,
	spawnstate = S_HHTRIGGER_IDLE,
	spawnhealth = 1,
	deathstate = S_HHTRIGGER_PRESSED,
	deathsound = sfx_mclang,
	height = 60*FRACUNIT,
	radius = 35*FRACUNIT, --FixedDiv(35*FU,2*FU),
	flags = MF_SOLID,
}

addHook("MobjSpawn",function(mo)
--	mo.height,mo.radius = $1*2,$2*2
	mo.shadowscale = mo.scale*9/10
	mo.spritexoffset = 19*FU
	mo.spriteyoffset = 26*FU
	mo.takis_flingme = false
end,MT_HHTRIGGER)

addHook("MobjThinker",function(trig)
	if not trig
	or not trig.valid
		return
	end
	
	trig.spritexscaleadd = $ or 0
	trig.spriteyscaleadd = $ or 0
	
	if trig.state == S_HHTRIGGER_ACTIVE
		if not (hh.gameover)
			trig.frame = ((5*(HAPPY_HOUR.time)/6)%14)
			if not S_SoundPlaying(trig,sfx_hhtsnd)
				S_StartSound(trig,sfx_hhtsnd)
			end
		else
			trig.frame = A
			S_StopSound(trig)
		end
	end
	
	trig.spritexscale = 2*FU+trig.spritexscaleadd
	trig.spriteyscale = 2*FU+trig.spriteyscaleadd
	if trig.spritexscaleadd ~= 0
		trig.spritexscaleadd = 4*$/5
	end
	if trig.spriteyscaleadd ~= 0
		trig.spriteyscaleadd = 4*$/5
	end
	--trig.height = FixedMul(60*trig.scale,FixedDiv(trig.spriteyscale,2*FU))
end,MT_HHTRIGGER)

addHook("MobjCollide",function(trig,mo)
	if (HAPPY_HOUR.othergt) then return end
	
	if not mo
	or not mo.valid
		return
	end
	
	if (mo.type ~= MT_PLAYER) then return end
	
	if HAPPY_HOUR.happyhour
		if L_ZCollide(trig,mo)
			return --true
		end
		return
	end
	
	if not trig.health
		if L_ZCollide(trig,mo)
			return --true
		end
		return
	end
	
	--TODO: flipped grav
	if P_MobjFlip(trig) == 1
		local myz = trig.z+trig.height
		if not (mo.z <= myz+trig.scale and mo.z >= myz-trig.scale)
			if L_ZCollide(trig,mo)
				return --true
			end
		return
		end
		if (mo.momz)
			return --true
		end
		
		local tl = tonumber(mapheaderinfo[gamemap].takis_hh_timelimit or 3*60)*TR
		if mapheaderinfo[gamemap].takis_hh_timelimit ~= nil
		and string.lower(tostring(mapheaderinfo[gamemap].takis_hh_timelimit)) == "none"
			tl = 0
		end
		HH_Trigger(trig,mo.player,tl)
		
		S_StartSound(trig,trig.info.deathsound)
		trig.state = trig.info.deathstate
		
		trig.spritexscaleadd = 2*FU
		trig.spriteyscaleadd = -FU*3/2
		
		P_AddPlayerScore(mo.player,5000)
		
		local takis = mo.player.takistable
		takis.bonuses["happyhour"].tics = 3*TR+18
		takis.bonuses["happyhour"].score = 5000
		takis.HUD.flyingscore.scorenum = $+5000
		return --true
		
	end
	
end,MT_HHTRIGGER)
----

----	exit stuff
freeslot("SPR_HHE_")
freeslot("SPR_HHF_")
freeslot("S_HHEXIT")
states[S_HHEXIT] = {
	sprite = SPR_HHE_,
	frame = A,
	tics = -1
} 
freeslot("S_HHEXIT_OPEN")
states[S_HHEXIT_OPEN] = {
	sprite = SPR_HHE_,
	frame = B,
	tics = -1
} 
freeslot("S_HHEXIT_CLOSE1")
freeslot("S_HHEXIT_CLOSE2")
freeslot("S_HHEXIT_CLOSE3")
freeslot("S_HHEXIT_CLOSE4")
states[S_HHEXIT_CLOSE1] = {
	sprite = SPR_HHE_,
	frame = P|FF_ANIMATE,
	var1 = 3,
	var2 = 2,
	tics = 3*2,
	nextstate = S_HHEXIT_CLOSE2
} 
states[S_HHEXIT_CLOSE2] = {
	sprite = SPR_HHE_,
	frame = S,
	tics = 15,
	nextstate = S_HHEXIT_CLOSE3,
} 
states[S_HHEXIT_CLOSE3] = {
	sprite = SPR_HHF_,
	frame = B|FF_ANIMATE,
	var1 = 13,
	var2 = 1,
	tics = 13*6,
	nextstate = S_HHEXIT_CLOSE4
} 
states[S_HHEXIT_CLOSE4] = {
	sprite = SPR_HHF_,
	frame = A,
	tics = -1
}
freeslot("sfx_elebel")
sfxinfo[sfx_elebel] = {
	flags = SF_X2AWAYSOUND,
	caption = "Elevator bell"
}

freeslot("MT_HHEXIT")
mobjinfo[MT_HHEXIT] = {
	--$Name Happy Hour Exit
	--$Sprite HHE_A0
	--$Category Takis Stuff
	doomednum = 3001,
	spawnstate = S_HHEXIT,
	seestate = S_HHEXIT_OPEN,
	spawnhealth = 1,
	height = 115*FRACUNIT,
	radius = 25*FRACUNIT,
	flags = MF_SPECIAL,
}

--might need a mapthingspawn for this?
addHook("MobjSpawn",function(mo)
	--mo.shadowscale = mo.scale*9/10
	local scale = FU*2
	mo.spritexscale,mo.spriteyscale = scale,scale
	mo.boltrate = 10
	hh.exit = mo
	mo.init = true
end,MT_HHEXIT)

addHook("TouchSpecial",function(door,mo)
	if not (mo and mo.valid) then return true end
	if not (door and door.valid) then return true end
	if not (hh.happyhour) then return true end
	if (hh.othergt) then return true end
	
	local p = mo.player
	
	if (p.exiting or p.pflags & PF_FINISHED) then return true end
	
	chatprint("\x82*\x83"..p.name.."\x82 reached the exit.")
	P_DoPlayerExit(p)
	mo.momx,mo.momy,mo.momz = 0,0,0
	P_SetOrigin(mo,door.x,door.y,door.z)
	mo.flags2 = $|MF2_DONTDRAW
	
	if (G_EnoughPlayersFinished())
		door.state = S_HHEXIT_CLOSE1
	end
	
	return true
end,MT_HHEXIT)
addHook("MobjThinker",function(door)
	if not (door and door.valid) then return end
	
	if not (hh.happyhour)
	and (door.spritexscale ~= 2*FU and door.spriteyscale ~= 2*FU)
		local scale = FU*2
		door.spritexscale,door.spriteyscale = scale,scale
	end
	
	if door.state == S_HHEXIT_OPEN
		door.frame = 1+((hh.time)%14)
	elseif door.state == S_HHEXIT_CLOSE3
		if not (door.exittic)
			door.exittic = 1
		else
			if not (leveltime % 2)
				door.exittic = $+1
			end
		end
		local ay = FU+(door.exittic*FU/40)
		if P_RandomChance(FU/2)
			ay = FU/2+door.exittic*FU/20
		end
		
		door.spritexscale = FixedMul(2*FU,ay)
		door.spriteyscale = FixedDiv(2*FU,ay)
		
		if not (leveltime % 3)
			local rad = door.radius/FRACUNIT
			local hei = door.height/FRACUNIT
			local x = P_RandomRange(-rad,rad)*FRACUNIT
			local y = P_RandomRange(-rad,rad)*FRACUNIT
			local z = P_RandomRange(0,hei)*FRACUNIT
			local spark = P_SpawnMobjFromMobj(door,x,y,z,MT_SOAP_SUPERTAUNT_FLYINGBOLT)
			spark.tracer = door
			spark.state = P_RandomRange(S_SOAP_SUPERTAUNT_FLYINGBOLT1,S_SOAP_SUPERTAUNT_FLYINGBOLT5)			
			spark.blendmode = AST_ADD
			spark.color = P_RandomRange(SKINCOLOR_WHITE,SKINCOLOR_GREY)
			spark.angle = door.angle+(FixedAngle( (P_RandomRange(-337,337)*FU)+P_RandomFixed() ))
			spark.momz = P_RandomRange(0,4)*door.scale*P_MobjFlip(door)
			P_Thrust(spark,spark.angle,P_RandomRange(1,5)*door.scale)
			spark.scale = P_RandomRange(1,3)*FU+P_RandomFixed()
		end
	elseif door.state == S_HHEXIT_CLOSE4
		if (door.exittic ~= nil)
			S_StartSound(door,sfx_elebel)
			door.exittic = nil
		end
		door.spritexscale = 2*FU
		door.spriteyscale = 2*FU
	end
	
	if (hh.gameover)
		if (P_RandomChance(FU/(max(2,50-(hh.gameovertics/2)))))
			local fa = FixedAngle(P_RandomRange(0,360)*FU)
			local x,y = ReturnTrigAngles(fa)
			local range = 300
			local xvar = 50*P_RandomRange(1,2)
			local yvar = 50*P_RandomRange(1,2)
			local thok = P_SpawnMobjFromMobj(door,
				range*x+P_RandomRange(-yvar,yvar)*door.scale,
				range*y+P_RandomRange(-yvar,yvar)*door.scale,
				P_RandomRange(-yvar,yvar)*door.scale,
				MT_THOK
			)
			thok.scale = P_RandomRange(1,5)*FU+P_RandomFixed()
			thok.flags2 = $|MF2_DONTDRAW
			A_BossScream(thok,1,choosething(MT_BOSSEXPLODE,MT_SONIC3KBOSSEXPLODE))
			
			local sfx = P_SpawnGhostMobj(thok)
			sfx.flags2 = $|MF2_DONTDRAW
			sfx.tics = TR*3/4
			sfx.fuse = TR*3/4
			S_StartSound(sfx,sfx_tkapow)
		end
	end

end,MT_HHEXIT)

----

--all happy hour
addHook("MapLoad", function(mapid)
	if (gametype ~= GT_COOP) then return end
	if (G_IsSpecialStage(mapid)) then return end
	if (maptol & TOL_NIGHTS) then return end
	if (netgame) then return end
	--probably boss map?
	if (mapheaderinfo[gamemap].bonustype == 1) then return end
	local hastakis = false
	for p in players.iterate
		if skins[p.skin].name == TAKIS_SKIN
			hastakis = true
		end
	end
	if (gamemap == titlemap) then return end
	if (TAKIS_NET.inescapable[string.lower(G_BuildMapTitle(gamemap))] == true) then return end
	
	if not hastakis then return end
	
	local hasexit = false
	local hassign = false
	local hasdoor = false
	
	--spawn our hh things
	--this seems REALLY bad, iterating all of this x3 on load
	for mt in mapthings.iterate
		--exit
		if mt.type == MT_HHEXIT
			hasdoor = true
		end
	end	
	
	for mt in mapthings.iterate
		--exit
		if mt.type == 1
		and not hasdoor
			--print("ASDSD")
			--print(mt.angle,mt.angle*FU)
			local x,y = ReturnTrigAngles(FixedAngle(mt.angle*FU))
			local px,py,pz  = mt.x*FU,mt.y*FU,mt.z*FU
			local door = P_SpawnMobj(px-(100*x),py-(100*y),pz*FU,MT_HHEXIT)
			hasdoor = true
		end
	end
	
	for mt in mapthings.iterate
		--trigger
		if mt.type == 501
		and hasdoor
			local x,y = ReturnTrigAngles(FixedAngle(mt.angle*FU))
			local trig = P_SpawnMobj(
				mt.x*FU+(-10*x), 
				mt.y*FU+(-10*y), 
				mt.z*FU,
				MT_HHTRIGGER
			)
			if mt.options & MTF_OBJECTFLIP then
				trig.flags2 = $ | MF2_OBJECTFLIP
			end
			if (mt.mobj and mt.mobj.valid) then P_RemoveMobj(mt.mobj) end
			hassign = true
		end

	end
	
	--remove exitsectors
	local SSF_REALEXIT = 1<<7
	if (hasdoor and hassign)
		for sec in sectors.iterate
			if (sec.specialflags & SSF_REALEXIT)
			or (GetSecSpecial(sec.special, 4) == 2)
				sec.specialflags = $ &~SSF_REALEXIT
				hasexit = true
			end
		end
	end
	
end)
--

filesdone = $+1
