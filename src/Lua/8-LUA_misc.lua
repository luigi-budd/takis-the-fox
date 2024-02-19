/*
	the misc file, for object thinkers, netvars, and stuff not
	directly related to takis
	
*/

local function L_ZCollide(mo1,mo2)
	if mo1.z > mo2.height+mo2.z then return false end
	if mo2.z > mo1.height+mo1.z then return false end
	return true
end
local transtonum = {
	[FF_TRANS90] = 9,
	[FF_TRANS80] = 8,
	[FF_TRANS70] = 7,
	[FF_TRANS60] = 6,
	[FF_TRANS50] = 5,
	[FF_TRANS40] = 4,
	[FF_TRANS30] = 3,
	[FF_TRANS20] = 2,
	[FF_TRANS10] = 1,
}
local numtotrans = {
	[9] = FF_TRANS90,
	[8] = FF_TRANS80,
	[7] = FF_TRANS70,
	[6] = FF_TRANS60,
	[5] = FF_TRANS50,
	[4] = FF_TRANS40,
	[3] = FF_TRANS30,
	[2] = FF_TRANS20,
	[1] = FF_TRANS10,
	[0] = 0,
}

--after image
addHook("MobjThinker", function(ai)
	if not ai
	or not ai.valid
		return
	end
	
	--we need a thing to follow
	if not ai.target
	or not ai.target.valid
		P_RemoveMobj(ai)
		return
	end
	
	local p = ai.target.player or server
	local me = p.mo
	
	--bruh
	if not me
	or not me.valid
		P_RemoveMobj(ai)
		return	
	end
	
	ai.spritexoffset = ai.takis_spritexoffset or 0
	ai.spriteyoffset = ai.takis_spriteyoffset or 0
	ai.spritexscale = ai.takis_spritexscale or FU
	ai.spriteyscale = ai.takis_spriteyscale or FU
	ai.rollangle = ai.takis_rollangle or 0
	
	ai.frame = ai.takis_frame|FF_TRANS30
	
	ai.colorized = true
	if not ai.timealive
		ai.timealive = 1	
	else
		ai.timealive = $+1
	end
	
	/*
	if p.takistable.io.additiveai
		local transnum = numtotrans[((ai.timealive*2/3)+1) %9]
		ai.frame = $|transnum
	else
		if ai.timealive % 6 <= 2
			ai.frame = $|FF_TRANS10
		else
			if P_RandomChance(FU/2)
				ai.frame = $|FF_TRANS70
			else
				ai.frame = $|FF_TRANS50
			end
		end
	end
	*/
	
	if (displayplayer and displayplayer.valid)
		if not (camera.chase)
			--only dontdraw afterimages that are too close to the player
			local dist = TAKIS_TAUNT_DIST*3
			
			local dx = (displayplayer.realmo.x)-ai.x
			local dy = (displayplayer.realmo.y)-ai.y
			local dz = (displayplayer.realmo.z)-ai.z
			if FixedHypot(FixedHypot(dx,dy),dz) < dist
				ai.flags2 = $|MF2_DONTDRAW
			else
				ai.flags2 = $ &~MF2_DONTDRAW
			end
		else
			ai.flags2 = $ &~MF2_DONTDRAW
		end
	end
	
	ai.blendmode = AST_ADD
	
	local fuselimit = 5

	--because fuse doesnt wanna work
	if ai.timealive > fuselimit
		P_RemoveMobj(ai)
		return
	end
	
end, MT_TAKIS_AFTERIMAGE)

addHook("MobjSpawn",function(AA)
	AA.spritexscale,AA.spriteyscale = 2*FU,2*FU
	AA.timealive = 1
	AA.scale = FU*2
end,MT_TAKIS_BADNIK_RAGDOLL_A)
addHook("MobjThinker",function(AA)
	if not AA
	or not AA.valid
		return
	end
	local flip = P_MobjFlip(AA)
	if AA.timealive <= 10
		AA.z = $ - ((10-AA.timealive)*FU)*flip
	else
		AA.z = $ + ((AA.timealive-10)*FU)*flip
		AA.destscale = 0
	end
	AA.timealive = $+1
end,MT_TAKIS_BADNIK_RAGDOLL_A)

addHook("MobjThinker", function(rag)
	if not rag
	or not rag.valid
		return
	end
	
	local intwod = (rag.flags2 & MF2_TWOD or twodlevel)
	
	rag.speed = abs(FixedHypot(rag.momx,rag.momy))
	rag.timealive = $+1
	if not (rag.timealive % 2)
		local aa = P_SpawnMobjFromMobj(rag,0,0,rag.height/2,MT_TAKIS_BADNIK_RAGDOLL_A)
		aa.color = SKINCOLOR_KETCHUP
	end
	if rag.timealive % 5 == 0
		local poof = P_SpawnMobjFromMobj(rag,0,0,rag.height/2,MT_SPINDUST)
		poof.scale = FixedMul(2*FRACUNIT,rag.scale)
		poof.colorized = true
		poof.destscale = rag.scale/4
		poof.scalespeed = FRACUNIT/4
		poof.fuse = 10				
	end
	--do hitboxes
	if (TAKIS_NET.collaterals and not intwod)
		--make hitting stuff more generous
		local oldbox = {rag.radius,rag.height}
		rag.radius,rag.height = $1*2, $2*2
		
		local oldpos = {rag.x,rag.y,rag.z}
		P_SetOrigin(rag,oldpos[1],oldpos[2],
			oldpos[3]-(rag.height/2*P_MobjFlip(rag))
		)
		local px = rag.x
		local py = rag.y
		local br = FixedDiv(rag.radius*5/2,2*FU)
		searchBlockmap("objects", function(rag, found)
			if found and found.valid
			and (found.health)
			and (L_ZCollide(rag,found))
				if CanFlingThing(found,MF_ENEMY|MF_BOSS)
					SpawnEnemyGibs(rag,found)
					SpawnBam(found)
					local sfx = P_SpawnGhostMobj(found)
					sfx.flags2 = $|MF2_DONTDRAW
					S_StartSound(sfx,sfx_smack)
					SpawnRagThing(found,rag,rag.parent2)
				elseif (SPIKE_LIST[found.type] == true)
					P_KillMobj(found,rag,rag.parent2)
				end
			end
		end, rag, px-br, px+br, py-br, py+br)
		rag.radius,rag.height = unpack(oldbox)
		P_SetOrigin(rag,oldpos[1],oldpos[2],oldpos[3])
	end
	--
	
	rag.angle = $-ANG10
	if rag.speed == 0
	or ((P_IsObjectOnGround(rag)) and (rag.timealive > 4))
		SpawnEnemyGibs(nil,rag)
		
		if P_IsObjectOnGround(rag)
		and P_RandomChance(FU/2)
			P_SetObjectMomZ(rag,10*FU)
			return
		end
		
		for i = 0, 34
			A_BossScream(rag,1,MT_SONIC3KBOSSEXPLODE)
		end
		
		local rad = 1200*rag.scale
		for p in players.iterate
			
			local m2 = p.realmo
			
			if not m2 or not m2.valid
				continue
			end
			
			if (FixedHypot(m2.x-rag.x,m2.y-rag.y) <= rad)
				DoQuake(p,
					FixedMul(
						100*FU, FixedDiv( rad-FixedHypot(m2.x-rag.x,m2.y-rag.y),rad )
					),
					17
				)
			end
		end
		
		--collaterals
		if (TAKIS_NET.collaterals and not intwod)
			local px = rag.x
			local py = rag.y
			local br = 420*rag.scale
			local h = 20
			
			if (TAKIS_DEBUGFLAG & DEBUG_BLOCKMAP)
				local me = rag
				for i = 0,10
					local f1 = P_SpawnMobj(px-br,py-br,me.z+((h*FU)*i),MT_THOK)
					f1.tics = -1
					f1.fuse = TR
					f1.sprite = SPR_RING
				end
				for i = 0,10
					local f2 = P_SpawnMobj(px-br,py+br,me.z+((h*FU)*i),MT_THOK)
					f2.tics = -1
					f2.fuse = TR
					f2.sprite = SPR_RING
				end
				for i = 0,10
					local f3 = P_SpawnMobj(px+br,py-br,me.z+((h*FU)*i),MT_THOK)
					f3.tics = -1
					f3.fuse = TR
					f3.sprite = SPR_RING
				end
				for i = 0,10
					local f4 = P_SpawnMobj(px+br,py+br,me.z+((h*FU)*i),MT_THOK)
					f4.tics = -1
					f4.fuse = TR
					f4.sprite = SPR_RING
				end
			end
			
			local helper = P_SpawnGhostMobj(rag)
			helper.flags2 = $|MF2_DONTDRAW
			helper.fuse = 5
			helper.parent2 = rag.parent2
			searchBlockmap("objects", function(helper, found)
				if found and found.valid
				and (found.health)
					if CanFlingThing(found,MF_ENEMY|MF_BOSS)
						SpawnRagThing(found,helper,helper.parent2)
					elseif (SPIKE_LIST[found.type] == true)
						P_KillMobj(found,helper,helper.parent2)
					end
				end
			end, helper, px-br, px+br, py-br, py+br)		
		end
		
		/*
		for i = 0,4
			local ring = P_SpawnMobjFromMobj(rag,
				0,0,0,MT_WINDRINGLOL
			)
			if (ring and ring.valid)
				ring.renderflags = RF_FLOORSPRITE
				ring.frame = $|FF_TRANS50
				ring.startingtrans = FF_TRANS50
				ring.scale = FixedMul(rag.scale,5*FU-(i*3*FU/2))
				ring.fuse = 10
				ring.destscale = FixedMul(ring.scale,2*FU)
				ring.scalespeed = 3*FU/2-(i*FU/2)
				ring.colorized = true
				ring.color = SKINCOLOR_WHITE
			end
		end
		*/

		local f = P_SpawnGhostMobj(rag)
		f.flags2 = $|MF2_DONTDRAW
		f.fuse = 2*TR
		S_StartSound(f,sfx_tkapow)
		--wtfsonic
		if (f.sprite == SPR_PLAY)
			local dead = P_SpawnMobjFromMobj(f,0,0,0,MT_THOK)
			
			dead.fuse = -1
			dead.tics = 3*TR
			dead.flags = MF_NOCLIP|MF_NOCLIPHEIGHT
			
			dead.sprite = SPR_PLAY
			dead.skin = f.skin
			dead.color = f.color
			dead.frame = A
			dead.sprite2 = SPR2_DEAD
			dead.isFUCKINGdead = true
			P_SetObjectMomZ(dead,14*FU)

		end
		P_RemoveMobj(rag)
		
	end
end, MT_TAKIS_BADNIK_RAGDOLL)

--starposts refill combo bar
addHook("MobjSpawn", function(post)
	post.activators = {
		cards = {},
		combo = {},
		cardsrespawn = {},
		comborespawn = {},
		first = {},
	}
end, MT_STARPOST)

local function docards(post,touch)
	if touch.skin ~= TAKIS_SKIN
		return
	end
	
	if touch.player.takistable.heartcards == TAKIS_MAX_HEARTCARDS
		return
	end
	
	post.activators.cards[touch] = true
	
	if CV_FindVar("respawnitem").value
	and (splitscreen or multiplayer)
		local time = CV_FindVar("respawnitemtime").value * TICRATE
		post.activators.cardsrespawn[touch] = time
	else
		post.activators.cardsrespawn[touch] = -1
	end	
	
	TakisHealPlayer(touch.player,touch,touch.player.takistable,2)
	S_StartSound(post,sfx_takhel,touch.player)
	touch.player.takistable.HUD.statusface.happyfacetic = 3*TR/2
	
end
local function docombo(post,touch)
	if touch.skin ~= TAKIS_SKIN
		return
	end
	
	
	if not touch.player.takistable.combo.time
		return
	end
	
	post.activators.combo[touch] = true
	
	if CV_FindVar("respawnitem").value
	and (splitscreen or multiplayer)
		local time = CV_FindVar("respawnitemtime").value * TICRATE
		post.activators.comborespawn[touch] = time
	else
		post.activators.comborespawn[touch] = -1
	end	
	
	TakisGiveCombo(touch.player,touch.player.takistable,false,true)
	S_StartSound(post,sfx_ptchkp,touch.player)
	

end

addHook("TouchSpecial", function(post,touch)
	if not L_ZCollide(post,touch)
		return
	end
	
	--thanks amperbee
	if not post.activators.cards[touch]
		
		if ((post.activators.cards[touch] == false) 
		or (post.activators.cards[touch] == nil))
			docards(post,touch)
		end
	end
	if not post.activators.combo[touch]
		if ((post.activators.combo[touch] == false) 
		or (post.activators.combo[touch] == nil))
			docombo(post,touch)
		end
	end
	if not post.activators.first[touch]
		if ((post.activators.first[touch] == false) 
		or (post.activators.first[touch] == nil))
			touch.player.takistable.HUD.menutext.tics = 3*TR+9
			
			TakisSpawnPongler(post,
				R_PointToAngle2(touch.x,touch.y,
					post.x,post.y
				)
			)
			post.activators.first[touch] = true
			S_StartSound(post,sfx_ponglr)
		end
	end
	
end, MT_STARPOST)

addHook("MobjThinker",function(me)
	if not me
	or not me.valid
		return
	end
	
	if me.activators == nil
	or (HAPPY_HOUR.time == 1)
		if HAPPY_HOUR.time == 1
			me.activators.cards = {}
			me.activators.combo = {}
			me.activators.cardsrespawn = {}
			me.activators.comborespawn = {}
			--dont set first field
		else
			me.activators = {
				cards = {},
				combo = {},
				cardsrespawn = {},
				comborespawn = {},
				first = {},
			}
		end
		return
	end
	
	for k,v in pairs(me.activators.cardsrespawn)
		if v == nil
			continue
		end
		
		if v > 0
			if v > CV_FindVar("respawnitemtime").value*TICRATE
				v = CV_FindVar("respawnitemtime").value*TICRATE
			end
			
			me.activators.cardsrespawn[k] = $-1
			
			if (HAPPY_HOUR.time == 1)
				me.activators.cardsrespawn[k] = 0
			end
		elseif v == 0
		and (me.activators.cards[k] ~= false)
			me.activators.cards[k] = false
			table.remove(me.activators.cardsrespawn,me.activators.cardsrespawn[k])
			S_StartSound(me,sfx_sprcar)
			
			local g = P_SpawnMobjFromMobj(me,0,0,me.height/4,MT_THOK)
			g.sprite = SPR_HTCD
			g.frame = A
			g.tics = TR
			g.blendmode = AST_ADD
			g.scale = FixedMul(me.scale,2*FU)
			g.destscale = FixedDiv(me.scale,4*FU)
		end
	end

	for k,v in pairs(me.activators.comborespawn)
		if v == nil
			continue
		end
		
		if v > 0
			if v > CV_FindVar("respawnitemtime").value*TICRATE
				v = CV_FindVar("respawnitemtime").value*TICRATE
			end
			
			me.activators.comborespawn[k] = $-1
			
			if (HAPPY_HOUR.time == 1)
				me.activators.comborespawn[k] = 0
			end
		elseif v == 0
		and (me.activators.combo[k] ~= false)
			me.activators.combo[k] = false
			table.remove(me.activators.comborespawn,me.activators.comborespawn[k])
			S_StartSound(me,sfx_sprcom)

			local g = P_SpawnMobjFromMobj(me,0,0,me.height/4,MT_THOK)
			g.sprite = SPR_CMBB
			g.frame = A
			g.tics = TR
			local scale =  FU/2
			g.spritexscale = scale
			g.spriteyscale = scale
			g.blendmode = AST_ADD
			g.scale = FixedMul(me.scale,2*FU)
			g.destscale = FixedDiv(me.scale,4*FU)
		end
	end
	
	local br = 215*me.scale
	
	for p in players.iterate
		if p and p.valid
		and p.realmo.health
		and P_CheckSight(me,p.realmo)
				
			if p.realmo.skin ~= TAKIS_SKIN
				continue
			end
			
			local dx = me.x-p.realmo.x
			local dy = me.y-p.realmo.y
			
			if FixedHypot(dx,dy) > br
				continue
			end
			
			--thanks Monster Iestyn for this!
			if (p and p == displayplayer)
				local found = p.realmo
				
				local x,y = ReturnTrigAngles(R_PointToAngle2(me.x,me.y, camera.x,camera.y))
				if not camera.chase
					x,y = ReturnTrigAngles(R_PointToAngle2(me.x,me.y, found.x,found.y))
				end
				if found.flags2 & MF2_TWOD
				or twodlevel
					x,y = ReturnTrigAngles(InvAngle(R_PointToAngle(found.x,found.y)))
				end
				
				--card
				local card = P_SpawnMobjFromMobj(me,64*x,64*y,me.height/4+(FU*10),MT_UNKNOWN)
				card.sprite = SPR_HTCD
				card.tics = 2		
				if me.activators.cards[found] == true
					card.frame = B|FF_TRANS50
				else
					card.frame = A
				end
				
				card.frame = $|FF_PAPERSPRITE
				if found.flags2 & MF2_TWOD
				or twodlevel
					card.angle = (R_PointToAngle(me.x,me.y))-ANGLE_90
				else
					if camera.chase
						card.angle = (R_PointToAngle2(me.x,me.y, camera.x,camera.y))-ANGLE_90
					else
						card.angle = (R_PointToAngle2(me.x,me.y, found.x,found.y))-ANGLE_90					
					end
				end
				--

				--combo
				local combo = P_SpawnMobjFromMobj(me,64*x,64*y,me.height/4-(FU*10),MT_UNKNOWN)
				combo.sprite = SPR_CMBB
				combo.tics = 2		
				if me.activators.combo[found] == true
					combo.frame = B|FF_TRANS50
				else
					combo.frame = A
				end
				local scale =  FU/2
				combo.spritexscale = scale
				combo.spriteyscale = scale
				
				combo.frame = $|FF_PAPERSPRITE
				if found.flags2 & MF2_TWOD
				or twodlevel
					combo.angle = (R_PointToAngle(me.x,me.y))-ANGLE_90
				else
					if camera.chase
						combo.angle = (R_PointToAngle2(me.x,me.y, camera.x,camera.y))-ANGLE_90
					else
						combo.angle = (R_PointToAngle2(me.x,me.y, found.x,found.y))-ANGLE_90
					end
				end
				--
			end
		end
	end
	
end,MT_STARPOST)

addHook("MobjDeath",function(t,i,s)
	if s
	and s.skin == TAKIS_SKIN
	and s.player
	
		if s.player.takistable.combo.time
			TakisGiveCombo(s.player,s.player.takistable,false,true)
		end
		
		if s.player.powers[pw_shield] & SH_FIREFLOWER
			TakisHealPlayer(s.player,s,s.player.takistable,1,1)
			S_StartSound(s,sfx_takhel,s.player)
		end
	end
end,MT_FIREFLOWER)

addHook("MobjDeath", function(target,inflict,source)
	if source
	and source.skin == TAKIS_SKIN
	and source.player
		for p in players.iterate
			p.takistable.HUD.statusface.happyfacetic = 3*TR/2
		end
	end
end, MT_TOKEN)

addHook("MobjThinker", function(sweat)
	if not sweat
	or not sweat.valid
		return
	end
	
	TakisFollowThingThink(sweat,sweat.tracer,1,true)
end,MT_TAKIS_SWEAT)

addHook("MobjThinker", function(bolt)
	if not bolt
	or not bolt.valid
		return
	end
	
	TakisFollowThingThink(bolt,bolt.tracer,false)
	
end,MT_SOAP_SUPERTAUNT_FLYINGBOLT)

--eject from carts
addHook("MobjThinker",function(cart)
	if not cart
	or not cart.valid
	or not cart.target
		return
	end
	
	if ((cart.target) and (cart.target.valid))
	and cart.target.skin == TAKIS_SKIN
		
		local p = cart.target.player
		local takis = p.takistable
		
		if (p.cmd.buttons & BT_CUSTOM1)
		and (p.powers[pw_carry] == CR_MINECART)
			p.powers[pw_carry] = CR_NONE
			
			p.mo.momx,p.mo.momy = cart.momx,cart.momy
			
			p.pflags = $|PF_JUMPED &~PF_THOKKED
			takis.thokked = false
			takis.dived = false

			p.mo.momz = (8*p.mo.scale)*P_MobjFlip(p.mo)
			P_DoJump(p,true)
			p.mo.state = S_PLAY_ROLL
			
			TakisGiveCombo(p,takis,true)
			cart.target = nil
			return
			
		end
		
	end
	
	
end,MT_MINECART)

--give spikeballs a deathstate
addHook("MobjDeath",function(mo,i,s)
	local gst = P_SpawnGhostMobj(mo)
	gst.flags2 = $|MF2_DONTDRAW
	gst.fuse = 3*TR
	
	S_StartSound(gst,mobjinfo[MT_SPIKE].deathsound)

	for i = 0,5
		local debris = P_SpawnMobjFromMobj(mo,
			(P_RandomRange(-10,10)*mo.scale),
			(P_RandomRange(-10,10)*mo.scale),
			(P_RandomRange(-10,10)*mo.scale),
			MT_THOK
		)
		debris.sprite = SPR_USPK
		debris.frame = P_RandomRange(E,F)
		debris.tics = -1
		debris.fuse = 3*TR
		debris.angle = R_PointToAngle2(debris.x,debris.y, mo.x,mo.y)
		debris.flags = $ &~MF_NOGRAVITY
		L_ZLaunch(debris,10*mo.scale)
		P_Thrust(debris,InvAngle(debris.angle),2*mo.scale)
	end
	
end,MT_SPIKEBALL)

local function happyhourmus(oldname, newname, mflags,looping,pos,prefade,fade)
	if splitscreen
		return
	end
	
	if not (consoleplayer and consoleplayer.valid)
		return
	end
	
	if not (consoleplayer.takistable)
		return
	end
	
	local p = consoleplayer
	local takis = p.takistable
	
	if (gamestate == GS_INTERMISSION)
	and takis.lastss
		newname = string.lower(newname)
		
		if newname == "_clear"
			--mapmusname = song
			return "blstcl",mflags,true,pos,prefade,fade	
		end
	end
	
	local dohhmus = true
	if (consoleplayer.takistable.io.nohappyhour == 1)
		dohhmus = false
	end
	
	if (skins[consoleplayer.skin].name ~= TAKIS_SKIN)
	and (consoleplayer.takistable.io.morehappyhour == 0)
		dohhmus = false
	end
	
	--print(" s "..tostring(HAPPY_HOUR.happyhour))
	if (HAPPY_HOUR.happyhour and not HAPPY_HOUR.gameover)
	and dohhmus
	
		local hh = HAPPY_HOUR
		
		local nomus,noendmus,song,songend = GetHappyHourMusic()
		
		newname = string.lower(newname)
		
		local isspecsong
		isspecsong = string.sub(newname,1,1) == "_"
		if not isspecsong
			isspecsong = TAKIS_NET.specsongs[newname]
		end
		
		oldname = string.lower($)
		
		if TAKIS_DEBUGFLAG & DEBUG_HAPPYHOUR
			CONS_Printf(consoleplayer,"New music change:",
				"HH Music: "..song,
				"HH End Music: "..songend,
				''
			)
			CONS_Printf(consoleplayer,"Nomus",
				nomus,
				noendmus,
				''
			)
			CONS_Printf(consoleplayer,"Changing from "..oldname,"to "..newname,"")
			CONS_Printf(consoleplayer,"Spec "..tostring(not isspecsong),'')
		end
		
		--stop any lap music
		if (not isspecsong)
			local changetohappy = true
			
			if HAPPY_HOUR.timelimit
				
				if HAPPY_HOUR.timeleft
					local tics = HAPPY_HOUR.timeleft
					
					if tics <= (56*TR)
					and (noendmus == false)
						changetohappy = false
					end
				end
			end
			
			if TAKIS_DEBUGFLAG & DEBUG_HAPPYHOUR
				CONS_Printf(consoleplayer,"Change to happy:",
					tostring(changetohappy)
				)
			end
			
			if changetohappy
				if nomus then return end
				
				if oldname ~= song
					--mapmusname = song
					return song,mflags,looping,pos,prefade,fade
				end
			
			else
				if noendmus then return end
				
				if oldname ~= songend
					--mapmusname = songend
					return songend,mflags,looping,pos,prefade,fade
				end
			end
			
			return true
		end
		
	else

		if not consoleplayer.takistable.shotgunned
			return
		end
		
		if not ultimatemode then return end
		
		local newname = string.lower(newname)
		
		if (TAKIS_NET.specsongs[newname] ~= true)
			return "war",mflags,looping,pos,prefade,fade
		end
	end
end
addHook("MusicChange", happyhourmus)

addHook("MobjThinker",function(mo)
	if not mo
	or not mo.valid
		return
	end
	
	if not mo.target
	or not mo.target.valid
		P_KillMobj(mo)
		return
	end
	
	if mo.target.eflags & MFE_VERTICALFLIP
		mo.eflags = $|MFE_VERTICALFLIP
		P_MoveOrigin(mo, mo.target.x, mo.target.y, (mo.target.z + mo.target.height - mo.height)-(mo.target.height*2))
	else
		P_MoveOrigin(mo, mo.target.x, mo.target.y, mo.target.z+(mo.target.height*2) )
	end	
	
end,MT_TAKIS_TAUNT_JOIN)

addHook("MobjThinker",function(mo)
	if not mo
	or not mo.valid
		return
	end
	
	if (mo.dropped)
		mo.flags = MF_SPECIAL|MF_NOGRAVITY
		mo.momz = $*70/71
		
		local grounded = P_IsObjectOnGround(mo)
		if mo.groundtime == nil
			mo.groundtime = 0
		end
		if mo.timealive == nil
			mo.timealive = 1
		else
			mo.timealive = $+1
		end
		
		--end of life blinking
		if (mo.timealive >= 50*TR)
			if (mo.timealive%2)
				mo.flags2 = $ &~MF2_DONTDRAW
			else
				mo.flags2 = $|MF2_DONTDRAW
			end
			if (mo.timealive >= 60*TR)
				P_RemoveMobj(mo)
				return
			end
		end
		
		if grounded			
			mo.groundtime = $+1
			local waveforce = FU
			local ay = FixedMul(waveforce,sin(mo.groundtime*3*ANG2))
			mo.spriteyoffset = 6*FU+ay
		else
			if mo.groundtime
				mo.groundtime = $-1
			end
		end
		
		mo.angle = $+FixedAngle(5*FU)
		return
	end
	
	if not mo.ragdoll
		if not mo.target
		or not mo.target.valid
			P_KillMobj(mo)
			return
		end
		
		local p = mo.target.player
		
		local trans = 0
		
		if (p.takistable.noability & NOABIL_SHOTGUN)
			trans = FF_TRANS50
		end
		
		local x = cos(p.drawangle-ANGLE_90)
		local y = sin(p.drawangle-ANGLE_90)
		
		mo.angle = p.drawangle
		
		if mo.target.eflags & MFE_VERTICALFLIP
			mo.eflags = $|MFE_VERTICALFLIP
		else
			mo.eflags = $ &~MFE_VERTICALFLIP
		end
		P_MoveOrigin(mo, mo.target.x+(16*x), mo.target.y+(16*y), GetActorZ(mo.target,mo,1)+(mo.target.height/2*P_MobjFlip(mo.target)) )
		
		if not (camera.chase)
			mo.flags2 = $|MF2_DONTDRAW
		else
			mo.flags2 = $ &~MF2_DONTDRAW
		end
		
		mo.frame = A|trans
	else
		local rag = mo
		
		rag.timealive = $+1
		if rag.timealive % 5 == 0
			local poof = P_SpawnMobjFromMobj(rag,0,0,rag.height/2,MT_SPINDUST)
			poof.scale = FixedMul(FRACUNIT*4/5,rag.scale)
			poof.colorized = true
			poof.destscale = rag.scale/4
			poof.scalespeed = FRACUNIT/10
			poof.fuse = 10				
		end
		
	end
	
end,MT_TAKIS_SHOTGUN)

--specki is strangely invulnerable to this
addHook("MobjMoveCollide",function(shot,mo)
	if not shot
	or not shot.valid
		return
	end
	
	if not shot.shotbytakis
		return
	end
	
	if not L_ZCollide(shot,mo)
		return
	end
	
	if not mo.health
		return
	end
	
	if not (shot.tracer and shot.tracer.valid)
		return
	end
	
	if (SPIKE_LIST[mo.type] == true)
		P_KillMobj(mo,shot,shot.tracer)
		return
	end
	
	if (CanFlingThing(mo)
	or (
		mo.type == MT_PLAYER
		and CanPlayerHurtPlayer(shot.tracer.player,mo.player)
		--dont kill ourselves though
		and (mo ~= shot.tracer)
	))
	and (mo.health)
		S_StartSound(mo,sfx_sdmkil)
		SpawnEnemyGibs(shot,mo)
		SpawnBam(mo)
		if (mo.type ~= MT_PLAYER)
			SpawnRagThing(mo,shot,shot.tracer)
			if (mo.flags & MF_BOSS)
				local boom = P_SpawnMobjFromMobj(mo,0,0,0,MT_THOK)
				boom.flags2 = $|MF2_DONTDRAW
				boom.radius,boom.height = mo.radius,mo.height
				
				S_StartSound(mo,sfx_tkapow)
				for i = 0,P_RandomRange(10,20)
					A_BossScream(boom,1,MT_SONIC3KBOSSEXPLODE)
				end
				DoFlash(shot.tracer.player,PAL_WHITE,3)
			end
		else
			--dont hurt other shotgunners with chainguns
			if (mo.player.takistable.transfo & TRANSFO_SHOTGUN)
			and (CV_TAKIS.chaingun.value)
				return true
			end
			
			P_KillMobj(mo,shot,shot.tracer)
			P_InstaThrust(mo,R_PointToAngle2(shot.x,shot.y, mo.x,mo.y),50*shot.scale)
			local boom = P_SpawnMobjFromMobj(mo,0,0,0,MT_THOK)
			boom.flags2 = $|MF2_DONTDRAW
			boom.radius,boom.height = mo.radius,mo.height
			
			S_StartSound(mo,sfx_tkapow)
			for i = 0,P_RandomRange(10,20)
				A_BossScream(boom,1,MT_SONIC3KBOSSEXPLODE)
			end
			DoFlash(mo.player,PAL_NUKE,3)
		end
		return true
	end
	
end,MT_THROWNSCATTER)

local function gunragdoll(gun,i)
	local rag = P_SpawnMobjFromMobj(gun,0,0,0,MT_TAKIS_SHOTGUN)
	rag.ragdoll = true
	rag.timealive = 0
	rag.flags = $ &~MF_NOGRAVITY
	rag.fuse = 4*TR
	rag.frame = B
	rag.rollangle = ANGLE_90-(ANG10*3)
	
	L_ZLaunch(rag,10*FU)
	if i and i.valid
		P_Thrust(rag, R_PointToAngle2(rag.x,rag.y, i.x,i.y), -5*rag.scale)
	end
	S_StartSound(i,sfx_shgnk)
end

addHook("MobjDeath",function(gun,i,s)
	if not gun.dropped
		if not gun.ragdoll
			gunragdoll(gun,i)
		end
	else
		if (s and s.valid)
		and s.health
		and (s.player and s.player.valid)
			if (s.skin == TAKIS_SKIN)
				if (s.player.takistable.transfo & TRANSFO_SHOTGUN)
					gun.flags = MF_SPECIAL|MF_NOGRAVITY
					gun.dropped = true
					gun.health = 1
					return true
				end
				TakisShotgunify(s.player,gun.flags2 & MF2_AMBUSH == MF2_AMBUSH)
				TakisGiveCombo(s.player,s.player.takistable,false,true)
			else
				gun.flags = MF_SPECIAL|MF_NOGRAVITY
				gun.dropped = true
				gun.health = 1
				return true
				--gunragdoll(gun,s)
			end
		end
	end
end,MT_TAKIS_SHOTGUN)

addHook("MobjThinker",function(shot)
	if not shot.shotbytakis
		return
	end
	
	S_StopSound(shot)
	TakisBreakAndBust(nil,shot)
	
end,MT_THROWNSCATTER)

addHook("MobjDeath",function(shot,i,s)
	if (shot.shotbytakis and not shot.timealive)
		shot.health = 1
		return true
	end
	if ((i == shot.tracer) or (s == shot.tracer))
	or ((shot.timealive < 10) and (i and i.valid or s and s.valid))
	and (shot.shotbytakis)
		shot.health = 1
		return true
	end
end,MT_THROWNSCATTER)

--specials

-- combo
local types = {
	MT_RING,
	MT_COIN,
	MT_BLUESPHERE,
	MT_TOKEN,
	MT_EMBLEM,
	MT_BOUNCERING,
	MT_RAILRING,
	MT_INFINITYRING,
	MT_AUTOMATICRING,
	MT_EXPLOSIONRING,
	MT_SCATTERRING,
	MT_GRENADERING,
	MT_REDTEAMRING,
	MT_BLUETEAMRING
}

local function makespecial(mo)
	mo.takis_givecombotime = true
end

for k,type in pairs(types)
	addHook("MobjSpawn",makespecial,type)
end
--

--cards
local types2 = {
	MT_RING,
	MT_COIN,
	MT_REDTEAMRING,
	MT_BLUETEAMRING
}


local function givepieces(mo)
	mo.takis_givecardpieces = true
end

for k,type in pairs(types2)
	addHook("MobjSpawn",givepieces,type)
end
--

--
local function choose(...)
	local args = {...}
	local choice = P_RandomRange(1,#args)
	return args[choice]
end

addHook("MobjThinker",function(s)
	if not s
	or not s.valid
		return
	end
	
	if s.target.skin == TAKIS_SKIN
		local p = s.target.player
		local takis = p.takistable
		
		if not (TAKIS_NET.nerfarma)
			/*
			choose(AST_ADD,AST_TRANSLUCENT,AST_MODULATE
				AST_ADD,AST_ADD,AST_TRANSLUCENT,AST_TRANSLUCENT,AST_MODULATE)
			*/
			
			if not (leveltime % 3)
				local rad = s.radius/FRACUNIT
				local hei = s.height/FRACUNIT
				local x = P_RandomRange(-rad,rad)*FRACUNIT
				local y = P_RandomRange(-rad,rad)*FRACUNIT
				local z = P_RandomRange(0,hei)*FRACUNIT
				local spark = P_SpawnMobjFromMobj(s,x,y,z,MT_SOAP_SUPERTAUNT_FLYINGBOLT)
				spark.tracer = s.target
				spark.state = P_RandomRange(S_SOAP_SUPERTAUNT_FLYINGBOLT1,S_SOAP_SUPERTAUNT_FLYINGBOLT5)			
				spark.blendmode = AST_ADD
				spark.color = P_RandomRange(SKINCOLOR_SALMON,SKINCOLOR_KETCHUP)
				spark.angle = p.drawangle+(FixedAngle( P_RandomRange(-337,337)*FRACUNIT ))
				spark.momz = P_RandomRange(0,4)*s.scale*takis.gravflip
				P_Thrust(spark,spark.angle,P_RandomRange(1,5)*s.scale)
			end
			
			--die
	/*
			local trans = 0
			local lt = (leveltime % 10)
			if lt == 1
				trans = FF_TRANS10
			elseif lt == 2
				trans = FF_TRANS20
			elseif lt == 3
				trans = FF_TRANS30
			elseif lt == 4
				trans = FF_TRANS40
			elseif lt == 5
				trans = FF_TRANS50
			elseif lt == 6
				trans = FF_TRANS60
			elseif lt == 7
				trans = FF_TRANS70
			elseif lt == 8
				trans = FF_TRANS80
			elseif lt == 9
				trans = FF_TRANS90
			end
	*/

			local trans = 0
			trans = choose(FF_TRANS10,FF_TRANS20,FF_TRANS30,FF_TRANS40,
				FF_TRANS50,FF_TRANS60,FF_TRANS70,FF_TRANS80,FF_TRANS90)
			
			s.frame = $|trans
			s.tracer.frame = $|trans
		end
	end
end,MT_ARMAGEDDON_ORB)

addHook("BossThinker", function(mo)
	if TAKIS_NET.bossprefix[mo.type] == nil then return end
	
	if (mo.target and mo.target.valid)
	and (mo.target.player and mo.target.player.valid)
		mo.p_target = mo.target
	end
	
end)

addHook("MobjThinker",function(effect)
	if not effect
	or not effect.valid
		return
	end
	
	if not effect.tracer
	or not effect.tracer.valid
		return
	end
	
	local me = effect.tracer
	local p = effect.tracer.player
	local x,y = cos(p.drawangle),sin(p.drawangle)
	
	P_MoveOrigin(effect,me.x+17*x,me.y+17*y,me.z)
	effect.angle = p.drawangle
	effect.rollangle = R_PointToAngle2(0, 0, R_PointToDist2(0, 0, me.momx, me.momy), me.momz)
	effect.scale = me.scale
	
	if (effect.tics % 2)
		effect.flags2 = $|MF2_DONTDRAW
	else
		effect.flags2 = $ &~MF2_DONTDRAW
	end
	
end,MT_TAKIS_DRILLEFFECT)

addHook("HurtMsg", function(p, inf, sor, dmgt)
	return TakisHurtMsg(p,inf,sor,dmgt)
end)

--fix this stupid zfighting issue in opengl
addHook("MobjSpawn",function(drone)
	if (maptol & TOL_NIGHTS)
		drone.dispoffset = -1
		table.insert(TAKIS_NET.ideyadrones,drone)
	end
end,MT_EGGCAPSULE)

addHook("MobjThinker",function(drone)
	if not drone
	or not drone.valid
		return
	end
	
	if not (maptol & TOL_NIGHTS)
		return
	end
	
	if not (drone.flags & MF_NOGRAVITY)
	and drone.hadnograv
	and not multiplayer
		local coolp = server
		local i = 0
		for p in players.iterate
			if i == 0
				coolp = p
			end
			
			if (skins[p.skin].name ~= TAKIS_SKIN)
				return
			end
			i = $+1
		end
		--only on the final mare
		if coolp.mare ~= #TAKIS_NET.ideyadrones-1
			return
		end
		HH_Trigger(drone,coolp,coolp.nightstime)
		S_StartSound(drone,sfx_mclang)
		coolp.mo.angle = coolp.drawangle
		NiGHTSFreeroam(coolp)
	end
	
	drone.hadnograv = drone.flags & MF_NOGRAVITY
end,MT_EGGCAPSULE)


local nightsthings = {
	[MT_RING] = true,
	[MT_FLINGRING] = true,
	[MT_BLUESPHERE] = true,
	[MT_FLINGBLUESPHERE] = true,
	[MT_NIGHTSCHIP] = true,
	[MT_FLINGNIGHTSCHIP] = true,
	[MT_NIGHTSSTAR] = true,
	[MT_FLINGNIGHTSSTAR] = true,
}

addHook("MobjMoveCollide",function(effect,t)
	if not effect
	or not effect.valid
		return
	end
	
	if not t
	or not t.valid
		return
	end
	
	if not L_ZCollide(t,effect)
		return
	end
	
	if (t.flags & MF_ENEMY)
	or (nightsthings[t.type] == true)
		P_KillMobj(t,effect.tracer ,effect.tracer)
	end
	
end,MT_TAKIS_DRILLEFFECT)

addHook("MobjThinker",function(ring)
	if not ring
	or not ring.valid
		return
	end
	
	--idk why regular fuse cant do this
	local start = ring.startingtrans
	local startn = transtonum[ring.startingtrans]
	if ring.fuse < 10-startn
		ring.frame = (ring.frame & FF_FRAMEMASK)|numtotrans[10-ring.fuse]
	end
end,MT_WINDRINGLOL)

addHook("MobjDeath",function(brak,_,sor)
	if not (sor and sor.valid)
		return
	end
	
	if not (sor.player and sor.player.valid)
		return
	end
	
	if not (TAKIS_NET.inbrakmap)
		return
	end
	
	if (sor.skin ~= TAKIS_SKIN)
		return
	end
	
	TakisAwardAchievement(sor.player,ACHIEVEMENT_BRAKMAN)
end,MT_CYBRAKDEMON)

local function makefling(mo)
	if not mo
	or not mo.valid
		return
	end
	
	mo.takis_flingme = true
	
	if mo.type == MT_ROSY
		mo.flags = $|MF_ENEMY
	end
end

local flinglist = {
	MT_EGGROBO1,
	MT_ROSY,	--DIE
}

for k,type in pairs(flinglist)
	addHook("MobjSpawn",makefling,type)
end

--heartcards mt
local function cardspawn(card,spawnedfrommt,hasambush,hasspecial,rtime)
	local cardscale = 2*FU
	
	if not card
	or not card.valid
		return
	end
	
	if (card.flags2 & MF2_AMBUSH)
	or (hasambush)
	or (card.cardhadambush)
		card.flags = $|MF_NOGRAVITY
		card.cardhadambush = true
	end
	
	if (hasspecial)
	or (card.cardhadspecial)
		card.cardhadspecial = true
	end
	
	--TODO: udmf
	if rtime ~= nil
		card.cardtime = rtime*TR
	end
	card.spritexscale,card.spriteyscale = cardscale,cardscale
	card.spawnedfrommt = spawnedfrommt
end

addHook("MapThingSpawn",function(mo,mt)
	if not (mo and mo.valid) then return end
	cardspawn(mo,
		true,
		mt.options & MTF_AMBUSH,
		mt.options & MTF_OBJECTSPECIAL,
		mt.extrainfo
	)
end,MT_TAKIS_HEARTCARD)
addHook("MobjSpawn",cardspawn,MT_TAKIS_HEARTCARD)

addHook("MobjThinker",function(card)
	if not card
	or not card.valid
		return
	end
	
	if (TAKIS_NET.cards == false and card.spawnedfrommt ~= true) then P_RemoveMobj(card) return end
	
	local grounded = P_IsObjectOnGround(card)
	card.angle = $+FixedAngle(5*FU)
	card.spawnflags = mobjinfo[card.type].flags
	if (card.flags2 & MF2_AMBUSH)
	or (card.cardhadambush)
		card.spawnflags = $|MF_NOGRAVITY
	end
	if card.groundtime == nil
		card.groundtime = 0
	end
	if card.timealive == nil
		card.timealive = 1
	else
		card.timealive = $+1
	end
	
	if card.spawnedfrommt
		if card.tics > 0
			card.tics = -1
		end
	end
	
	card.flags2 = $ &~MF2_DONTDRAW
	
	--end of life blinking
	if (card.timealive >= TAKIS_MAX_HEARTCARD_FUSE-(10*TR))
	and (card.spawnedfrommt ~= true)
		if card.timealive < TAKIS_MAX_HEARTCARD_FUSE-(3*TR)
			if (card.timealive/2%2)
				card.flags2 = $ &~MF2_DONTDRAW
			else
				card.flags2 = $|MF2_DONTDRAW
			end
		else
			if (card.timealive%2)
				card.flags2 = $ &~MF2_DONTDRAW
			else
				card.flags2 = $|MF2_DONTDRAW
			end		
		end
	end
	
	if (displayplayer and displayplayer.valid)
	and (skins[displayplayer.skin].name ~= TAKIS_SKIN)
		card.flags2 = $|MF2_DONTDRAW
	end
	
	if grounded
		if (card.eflags & MFE_JUSTHITFLOOR)
			if (-card.lastmomz > 2*FU)
				L_ZLaunch(card,-FixedDiv(card.lastmomz,card.scale)/2)
				S_StartSound(card,sfx_hrtcdt)
			end
		end
		
		card.groundtime = $+1
		local waveforce = FU
		local ay = FixedMul(waveforce,sin(card.groundtime*3*ANG2))
		card.spriteyoffset = 3*FU+ay
	else
		if card.groundtime
			card.groundtime = $-1
		end
	end
	card.lastmomz = card.momz
end,MT_TAKIS_HEARTCARD)

addHook("MobjDeath",function(card,_,sor)
	if not card
	or not card.valid
		return
	end
	
	local ttime = card.timealive or 0
	
	if sor
	and sor.skin == TAKIS_SKIN
	and sor.player
	and sor.player.valid
		local doreturn = false
		if (sor.player.takistable.heartcards ~= TAKIS_MAX_HEARTCARDS)
		and (ttime > 4)
			TakisHealPlayer(sor.player,sor,sor.player.takistable,1,1)
			local sound = P_SpawnGhostMobj(card)
			sound.flags2 = $|MF2_DONTDRAW
			sound.fuse = TR
			S_StartSound(sound,sfx_takhel,sor.player)
			doreturn = true
		end
		if (sor.player.takistable.combo.time)
		and (ttime > 4)
			for i = 0, 1
				TakisGiveCombo(sor.player,sor.player.takistable,false)
			end
			S_StartSound(sor,sfx_ncitem,sor.player)
			local spark = P_SpawnMobjFromMobj(card,0,0,0,MT_THOK)
			spark.fuse = -1
			spark.state = mobjinfo[MT_RING].deathstate
			spark.scale = $*2
			doreturn = true
		end
		if (doreturn)
			--make a thok do our bidding (respawn the card)
			if (card.spawnedfrommt)
			and (CV_FindVar("respawnitem").value
			and (splitscreen or multiplayer or card.cardhadspecial))
				local new = P_SpawnMobjFromMobj(card,0,0,0,MT_THOK)
				new.camefromcard = true
				new.respawntime = (card.cardhadspecial and card.cardtime) or CV_FindVar("respawnitemtime").value * TICRATE
				new.cardflags = card.spawnflags or mobjinfo[card.type].flags
				new.cardhadambush = card.cardhadambush
				new.cardhadspecial = card.cardhadspecial
				if card.cardtime ~= nil
					new.cardtime = card.cardtime
				end
			end
			return
		end
		card.health = 1000
		card.flags = card.spawnflags or mobjinfo[card.type].flags
		return true
	else
		card.health = 1000
		card.flags = card.spawnflags or mobjinfo[card.type].flags
		return true
	end
	
	
end,MT_TAKIS_HEARTCARD)

--thok respawns stuff for us
addHook("MobjThinker",function(th)
	if not (th and th.valid) then return end
	
	if (th.camefromcard)
		
		th.flags2 = $|MF2_DONTDRAW
		--tic respawn timer
		if (th.respawntime)
			if th.respawntime > CV_FindVar("respawnitemtime").value * TICRATE
			and not th.cardhadspecial
				th.respawntime = CV_FindVar("respawnitemtime").value * TICRATE
			end
			th.tics,th.fuse = -1,-1
			th.respawntime = $-1
		else
			local card = P_SpawnMobjFromMobj(th,0,0,0,MT_TAKIS_HEARTCARD)
			card.spawnflags = th.cardflags
			card.spawnedfrommt = true
			if th.cardhadambush
				card.cardhadambush = th.cardhadambush
				card.flags = $|MF_NOGRAVITY
			end
			if th.cardhadspecial
				card.cardhadspecial = th.cardhadspecial
			end
			if th.cardtime ~= nil
				card.cardtime = th.cardtime
			end
			P_RemoveMobj(th)
		end
	elseif (th.camefromsolid)
		th.flags2 = $|MF2_DONTDRAW
		--tic respawn timer
		if (th.respawntime)
			if th.respawntime > CV_FindVar("respawnitemtime").value * TICRATE
				th.respawntime = CV_FindVar("respawnitemtime").value * TICRATE
			end
			if (th.respawntime <= TR)
				if not (th.respawntime % 2)
					th.state = th.solid.state
					th.flags2 = $ &~MF2_DONTDRAW
				else
					th.state = S_THOK
				end
			end
			
			th.angle = th.solid.angle
			th.tics,th.fuse = -1,-1
			th.respawntime = $-1
		else
			local s = th.solid
			local new = P_SpawnMobj(s.pos[1],s.pos[2],s.pos[3],s.type)
			new.flags = s.flags
			new.flags2 = s.flags2
			new.angle = s.angle
			new.scale = s.scale
			new.color = s.color
			
			P_RemoveMobj(th)
		end	
	elseif th.isFUCKINGdead
		local grav = P_GetMobjGravity(th)
		grav = $
		th.momz = $+(grav*P_MobjFlip(th))
	else
		return
	end
	
end,MT_THOK)

local function dontfling(mo)
	if not mo
	or not mo.valid
		return
	end
	
	mo.takis_flingme = false

end

local dontflinglist = {
	MT_EGGMAN_GOLDBOX,
	MT_EGGMAN_BOX,
	MT_BIGMINE,
	MT_SHELL,
	MT_STEAM,	--thz steam
	--strange divide by 0 with one of these 2
	MT_ROLLOUTSPAWN,
	MT_ROLLOUTROCK,
	MT_DUSTDEVIL,
	MT_DUSTLAYER,
}

for k,type in ipairs(dontflinglist)
	addHook("MobjSpawn",dontfling,type)
end

--shields will squish with us
local shieldlist = {
	MT_ELEMENTAL_ORB,
	MT_ATTRACT_ORB,
	MT_FORCE_ORB,
	MT_ARMAGEDDON_ORB,
	MT_WHIRLWIND_ORB,
	MT_PITY_ORB,
	MT_FLAMEAURA_ORB,
	MT_BUBBLEWRAP_ORB,
	MT_THUNDERCOIN_ORB,
}
local shieldsquash = function(shield)
	if not shield
	or not shield.valid
		return
	end
	
	if not shield.target
	or not shield.target.valid
		return
	end
	
	local p = shield.target.player
	local me = shield.target
	local takis = p.takistable
	
	if takis
		if (me.skin == TAKIS_SKIN)
			shield.stretched = true
			shield.spritexscale,shield.spriteyscale = me.spritexscale,me.spriteyscale
			shield.spriteyoffset = me.spriteyoffset
		else
			if (shield.stretched)
				shield.spritexscale,shield.spriteyscale = FU,FU
				shield.spriteyoffset = 0
				shield.stretched = false
			end
		end
	end
	
	--multi layered
	if (shield.tracer and shield.tracer.valid)
		local overlay = shield.tracer
		overlay.spritexscale,overlay.spriteyscale = shield.spritexscale,shield.spriteyscale
		overlay.spriteyoffset = shield.spriteyoffset
	end
	
end

for k,type in ipairs(shieldlist)
	addHook("MobjThinker",shieldsquash,type)
end

addHook("MobjThinker",function(fling)
	if not (fling and fling.valid) then return end
	fling.momz = $+(P_GetMobjGravity(fling)*P_MobjFlip(fling))
	if not (leveltime % 5)
		local dust = P_SpawnMobjFromMobj(fling,0,0,fling.height/2,MT_SPINDUST)
		dust.scale = FixedMul(2*FU,fling.scale)
		dust.destscale = fling.scale/4
		dust.scalespeed = FU/4
		dust.fuse = 10
	end
	if (fling.momz*P_MobjFlip(fling) < -10*fling.scale)
		fling.rollangle = $+FixedAngle(fling.momz*P_MobjFlip(fling))
	else
		fling.rollangle = $-FixedAngle(10*fling.scale)
	end
	
end,MT_TAKIS_FLINGSOLID)

addHook("MobjThinker",function(gib)
	if not (gib and gib.valid) then return end
	local grav = P_GetMobjGravity(gib)
	grav = $*3/5
	gib.momz = $+(grav*P_MobjFlip(gib))
	gib.rollangle = $+gib.angleroll
	gib.speed = FixedHypot(gib.momx,gib.momy)
	if (P_IsObjectOnGround(gib)
	and not gib.bounced)
		if not gib.iwillbouncetwice
			gib.flags = $|MF_NOCLIPHEIGHT|MF_NOCLIP
			gib.bounced = true
			gib.tics = 3*TR
			L_ZLaunch(gib,
				(gib.lessbounce and P_RandomRange(2,4) or P_RandomRange(4,9))
				*FU+P_RandomFixed()
			)
		else
			gib.iwillbouncetwice = nil
			gib.lessbounce = true
			L_ZLaunch(gib,P_RandomRange(6,9)*FU+P_RandomFixed())
		end
	end
end,MT_TAKIS_GIB)

addHook("MobjMoveBlocked",function(gib)
	if gib.flags & MF_NOCLIP then return end
	if gib.bounced then return end
	P_BounceMove(gib)
	gib.angle = FixedAngle(AngleFixed($)+180*FU)
end,MT_TAKIS_GIB)

--boss health stuff
--this is so sa hud!!
-- https://mb.srb2.org/threads/sonic-adventure-style-hud.27294/

local bossnames = TAKIS_NET.bossnames
local addonbosses = TAKIS_NET.addonbosses
local nobosscards = TAKIS_NET.nobosscards
local noaddonbosscards = TAKIS_NET.noaddonbosscards
local bossprefix = TAKIS_NET.bossprefix
local addonbossprefix = TAKIS_NET.addonbossprefix

local function setBossMeter(p, boss)
	local bosscards = p.takistable.HUD.bosscards
	
	if (bosscards != nil)
	and (bosscards.mo == boss)
		-- It's the same guy!
		return;
	end
	
	bosscards.mo = boss;
	
	local takis = p.takistable
	local title = takis.HUD.bosstitle
	title.takis[1],title.takis[2] = unpack(title.basetakis)
	title.egg[1],title.egg[2] = unpack(title.baseegg)
	title.vs[1],title.vs[2] = unpack(title.basevs)
	title.mom = 1980
	title.tic = 3*TR
end

local function bossThink(mo)
	if (mo.health <= 0)
		-- Don't add a boss that's dead!
		return;
	end
	
	-- I suppose we can iterate everyone...
	for p in players.iterate do
		if not (p.mo and p.mo.valid)
			continue;
		end
		local bosscards = p.takistable.HUD.bosscards
		
		if (bosscards != nil
		and ((bosscards.mo and bosscards.mo.valid)
		and bosscards.mo == mo))
			-- It's already us! We can move on...
			continue;
		end
		
		if (P_CheckSight(mo, p.mo))
			local updateboss = false;

			if ((bosscards == nil)
			or not (bosscards.mo and bosscards.mo.valid and bosscards.mo.health > 0))
				-- Another boss doesn't exist, so we can add it!
				updateboss = true;
			else
				-- Another boss exists already, so only assume that they're not fighting the boss when
				updateboss = (not P_CheckSight(bosscards.mo, p.mo));
			end

			if (updateboss == true)
				setBossMeter(p, mo);
			end
		end
	end
end

local function bossHurt(mo, inf, src)
	if not (mo.flags & MF_BOSS)
		-- Only bosses!
		return;
	end

	if (src and src.valid) and (src.player and src.player.valid)
		setBossMeter(src.player, mo);
		for p in players.iterate
			if p.takistable.HUD.bosscards.mo == mo
				p.takistable.HUD.bosscards.cardshake = TAKIS_HEARTCARDS_SHAKETIME
			end
		end
	end
end

local function bossMeterThink(p)
	if (p.takistable == nil) then return end
	
	if (p.takistable.HUD.bosscards == nil)
		return;
	end
	
	local takis = p.takistable
	local bosscards = takis.HUD.bosscards
	
	--prtable("boss",bosscards)
	if (bosscards.cards > 0)
	and not (bosscards.mo and bosscards.mo.valid and bosscards.mo.health > 0)
		bosscards.cards = 0
	else
		if bosscards.mo and bosscards.mo.valid
			
			local maxhealth = bosscards.mo.info.spawnhealth;
			bosscards.maxcards = maxhealth
			
			local bosshp = bosscards.mo.health;
			bosscards.cards = bosshp
			
			if bosscards.cardshake then bosscards.cardshake = $-1 end
			
			if bosscards.cards
				if bosscards.cards <= (2)
					if not (leveltime%TR)
						bosscards.cardshake = $+TAKIS_HEARTCARDS_SHAKETIME/2
					end
				
				elseif bosscards.cards <= (bosscards.maxcards/2)
					if not (leveltime%(TR*2))
						bosscards.cardshake = $+TAKIS_HEARTCARDS_SHAKETIME/3
					end
				end
			end
			
			bosscards.name = nil
			if bossnames[bosscards.mo.type] ~= nil
			or bosscards.mo.info.name ~= nil
				bosscards.name = bossnames[bosscards.mo.type] or bosscards.mo.info.name
			end
			
			bosscards.nocards = false
			if nobosscards[bosscards.mo.type] ~= nil
				bosscards.nocards = nobosscards[bosscards.mo.type]
			end
		else
			local title = takis.HUD.bosstitle
			title.takis[1],title.takis[2] = unpack(title.basetakis)
			title.egg[1],title.egg[2] = unpack(title.baseegg)
			title.vs[1],title.vs[2] = unpack(title.basevs)
			title.mom = 1980
		end
	end

end

local function isMobjTypeValid(mt)
	if (pcall(do return _G[mt] end))
		return _G[mt];
	else
		return nil;
	end
end

local function mapSet()
	-- Check for new addon bosses
	for k,v in pairs(addonbosses) do
		local mt = isMobjTypeValid(k);

		if not (mt)
			continue;
		end

		bossnames[mt] = v;
	end
	for k,v in pairs(noaddonbosscards) do
		local mt = isMobjTypeValid(k);

		if not (mt)
			continue;
		end

		nobosscards[mt] = v;
	end
	for k,v in pairs(addonbossprefix) do
		local mt = isMobjTypeValid(k);

		if not (mt)
			continue;
		end

		bossprefix[mt] = v;
	end

end

addHook("ThinkFrame", mapSet);
addHook("BossThinker", bossThink);
addHook("MobjDamage", bossHurt);
addHook("MobjDeath", bossHurt);
addHook("PlayerThink",bossMeterThink)

--chaos emeralds are replaced with spirits
local emeraldslist = {
	[0] = SKINCOLOR_GREEN,
	[1] = SKINCOLOR_SIBERITE,
	[2] = SKINCOLOR_SAPPHIRE,
	[3] = SKINCOLOR_SKY,
	[4] = SKINCOLOR_TOPAZ,
	[5] = SKINCOLOR_FLAME,
	[6] = SKINCOLOR_SLATE,
}

addHook("MobjThinker",function(gem)
	if not (gem and gem.valid) then return end
	if emeraldslist[gem.emeralddex] == nil then P_RemoveMobj(gem) return end
	
	local me = gem.tracer
	
	if not (me and me.valid) then P_RemoveMobj(gem) return end
	
	if not gem.camefromemerald
		local die = false
		if HAPPY_HOUR.gameover
		or not me.health
			die = true
		end
		
		if not die
			--assume we've just spawned
			if not gem.emeraldcolor
				gem.emeraldcolor = emeraldslist[gem.emeralddex]
				--never let spirits overlap
				if gem.emeralddex ~= 0
				and (me.player.takistable.spiritlist and
				me.player.takistable.spiritlist[gem.emeralddex-1])
					gem.timealive = me.player.takistable.spiritlist[gem.emeralddex-1].timealive--+((360/7)*gem.emeralddex)
				end
			end
			gem.color = gem.emeraldcolor
			if gem.timealive == nil
				gem.timealive = 0
			else
				gem.timealive = $+1
			end
			local extraang = 0
			if me.player.powers[pw_carry] == CR_NIGHTSMODE
				extraang = R_PointToAngle(gem.x,gem.y)
			end
			gem.circle = extraang+FixedAngle( ((2*FU)*3/2)*gem.timealive )
			gem.circle = $+(FixedAngle(FixedDiv(333*FU,7*FU)*gem.emeralddex+1))
			
			local x,y = ReturnTrigAngles(gem.circle)
			local z = sin(gem.circle)*12
			P_MoveOrigin(gem,
				me.x + 30*x,
				me.y + 30*y,
				GetActorZ(me,gem,1) + z + (7*gem.scale)
			)
			
			gem.angle = gem.circle+ANGLE_90
			if not camera.chase
				gem.flags2 = $|MF2_DONTDRAW
			else
				gem.flags2 = $ &~MF2_DONTDRAW
			end
			
		else
			if gem.flags & MF_NOGRAVITY
				gem.circle = $ or gem.angle-ANGLE_90
				S_StartSound(gem,sfx_shldls)
				P_SetObjectMomZ(gem,6*FU)
				P_Thrust(gem,gem.circle+ANGLE_90,2*gem.scale)
				gem.flags = $ &~MF_NOGRAVITY
			end
		end
	else
		if not gem.emeraldcolor
			gem.emeraldcolor = emeraldslist[gem.emeralddex]
		end
		gem.color = gem.emeraldcolor
		if gem.timealive == nil
			gem.timealive = 0
		else
			gem.timealive = $+1
		end
		
		gem.circle = FixedAngle( ((2*FU)*3/2)*gem.timealive )
		
		local z = sin(gem.circle)*12
		gem.spriteyoffset = 3*FU+z
		
		if (displayplayer
		and displayplayer.valid)
			if skins[displayplayer.skin].name == TAKIS_SKIN
				gem.flags2 = $ &~MF2_DONTDRAW
				gem.angle = R_PointToAngle2(gem.x,gem.y,
					displayplayer.realmo.x,
					displayplayer.realmo.y
				)
			else
				gem.flags2 = $|MF2_DONTDRAW
			end
		end
	end
end,MT_TAKIS_SPIRIT)

--gotemeralds to spirits
addHook("MobjThinker",function(gem)
	if not (gem and gem.valid) then return end
	if emeraldslist[gem.frame & FF_FRAMEMASK] == nil then return end
	
	if not gem.emeraldcolor
		gem.emeraldcolor = emeraldslist[gem.frame & FF_FRAMEMASK]
	end
	local soda = P_SpawnMobjFromMobj(gem,0,0,0,MT_TAKIS_SPIRIT)
	soda.tracer = gem.target
	soda.emeralddex = gem.frame & FF_FRAMEMASK
	gem.target.player.takistable.spiritlist[soda.emeralddex] = soda
	P_RemoveMobj(gem)
	
	return
end,MT_GOTEMERALD)

--collectable emeralds change into spirits and back
local function emeraldcollectspirit(gem)
	if not (gem and gem.valid) then return end
	if emeraldslist[gem.frame & FF_FRAMEMASK] == nil then return end
	
	if not gem.emeraldcolor
		gem.emeraldcolor = emeraldslist[gem.frame & FF_FRAMEMASK]
	end
	if not (gem.soda and gem.soda.valid)
	and (gem.health)
		gem.soda = P_SpawnMobjFromMobj(gem,0,0,5*gem.scale*P_MobjFlip(gem),MT_TAKIS_SPIRIT)
		local soda = gem.soda
		soda.tracer = gem
		soda.emeralddex = gem.frame & FF_FRAMEMASK
		soda.camefromemerald = true
	elseif (gem.soda and gem.soda.valid)
		if (displayplayer
		and displayplayer.valid
		and skins[displayplayer.skin].name == TAKIS_SKIN)
			gem.flags2 = $|MF2_DONTDRAW
		else
			gem.flags2 = $ &~MF2_DONTDRAW
		end
		
		if not gem.health
			gem.soda.tracer = nil
		end
	end
end

local emeraldtypes = {
	MT_EMERALD1,
	MT_EMERALD2,
	MT_EMERALD3,
	MT_EMERALD4,
	MT_EMERALD5,
	MT_EMERALD6,
	MT_EMERALD7
}
for _,type in ipairs(emeraldtypes)
	addHook("MobjThinker",emeraldcollectspirit,type)
end

local laughingtypes = {
	MT_EMERALD1,
	MT_EMERALD2,
	MT_EMERALD3,
	MT_EMERALD4,
	MT_EMERALD5,
	MT_EMERALD6,
	MT_EMERALD7,
	MT_TOKEN,
	
	MT_BLUEFLAG,
	MT_REDFLAG,
	
	MT_EMBLEM,
	
	MT_1UP_BOX,
	MT_SCORE10K_BOX,
	
}
local function laughondeath(gem,_,tak)
	if not (gem and gem.valid) then return end
	if not (tak and tak.valid) then return end
	if (tak.skin == TAKIS_SKIN)
		S_StartAntonLaugh(tak)
	end
end

for _,type in ipairs(laughingtypes)
	addHook("MobjDeath",laughondeath,type)
end

/*
addHook("MobjThinker",function(rock)
	if not (rock and rock.valid) then return end
	
	local speed = FixedHypot(rock.momx,rock.momy)
	local topspeed = FixedMul(rock.info.speed,rock.scale)
	
end,MT_ROLLOUTROCK)
*/
--this is way better
mobjinfo[MT_ROLLOUTROCK].speed = 60*FU
states[S_ROLLOUTROCK].var1 = FU

addHook("MobjThinker",function(trophy)
	if not (trophy and trophy.valid) then return end
	if not (trophy.tracer and trophy.tracer.valid) then P_RemoveMobj(trophy); return end
	local me = trophy.tracer
	
	if trophy.state == S_TAKIS_TROPHY
		P_MoveOrigin(trophy, me.x, me.y, GetActorZ(me,trophy,2))
		if P_MobjFlip(me) == 1
			trophy.eflags = $ &~MFE_VERTICALFLIP
		else
			trophy.eflags = $|MFE_VERTICALFLIP
		
		end
	elseif trophy.state == S_TAKIS_TROPHY2
		if (trophy.flags & MF_NOGRAVITY)
			trophy.flags = $ &~MF_NOGRAVITY
			L_ZLaunch(trophy,10*trophy.scale)
		end
		local grav = P_GetMobjGravity(trophy)
		grav = $*3/5
		trophy.momz = $+(grav*P_MobjFlip(trophy))
	end
	
end,MT_TAKIS_TROPHY)

addHook("MobjThinker",function(fet)
	if not (fet and fet.valid) then return end
	if (P_IsObjectOnGround(fet)) then P_RemoveMobj(fet); return end
	
	--this is awesome CHRISPYCHARS CODE!!!
	local flip = P_MobjFlip(fet)
	
	fet.momx = FixedMul($, fet.info.mass)
	fet.momy = FixedMul($, fet.info.mass)
	if not (fet.flags & MF_NOGRAVITY)
		fet.momz = FixedMul($, fet.info.mass)
		local maxfall = -FixedMul(fet.info.speed, fet.scale)
		if flip*fet.momz < maxfall
			fet.momz = flip*FixedMul(flip*$, fet.info.mass)
			if flip*fet.momz > maxfall
				fet.momz = flip*maxfall
				fet.flags = $ | MF_NOGRAVITY
			end
		end
	end
	fet.angle = $+(ANG15*fet.rngspin)
	fet.rollangle = $+(ANG15*fet.rngspin)
end,MT_TAKIS_FETTI)

addHook("MapThingSpawn",function(mo,mt)
	if mt.options & MTF_AMBUSH
		mo.type = MT_SHOTGUN_GOLDBOX
	end
end,MT_SHOTGUN_BOX)

addHook("TouchSpecial",function(door,mo)
	if not (mo and mo.valid) then return true end
	if not (door and door.valid) then return true end
	
	local p = mo.player
	local takis = p.takistable
	
	if not takis then return true end
	
	local hasit = (takis.transfo & TRANSFO_SHOTGUN) or (p.charflags & SF_MACHINE)
	
	if (mo.touchingdetector and not (takis.transfo & TRANSFO_SHOTGUN)) then mo.touchingdetector = 3; return true end
	
	if hasit
		S_StartSound(door,door.info.activesound)
		TakisDeShotgunify(p)
		mo.touchingdetector = 3
		door.flashing = 10
	end
	return true
end,MT_TAKIS_METALDETECTOR)

addHook("MobjThinker",function(door)
	if not (door and door.valid) then return end
	
	if not door.made3d
		local list
		local flip = P_MobjFlip(door)
		door.flags2 = $|MF2_DONTDRAW
		
		door.topblock = {}
		list = door.topblock
		
		--flipgrav is really PISSING me off
		local height = ((flip == 1) and door.height or 0)
		local base = 0
		if (flip == -1) then base = door.height end
		
		--spawn the splats
		list[1] = P_SpawnMobjFromMobj(door,0,0,0,MT_THOK)
		list[1].frame = A
		list[1].sprite = SPR_MTLD
		list[1].tics,list[1].fuse = -1,-1
		list[1].flags = MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_NOCLIP
		list[1].renderflags = $|RF_FLOORSPRITE|RF_NOSPLATBILLBOARD
		list[1].angle = door.angle
		list[1].height = 0
		P_SetOrigin(list[1],list[1].x,list[1].y,GetActorZ(door,list[1],2))

		list[2] = P_SpawnMobjFromMobj(door,0,0,0,MT_THOK)
		list[2].frame = A
		list[2].sprite = SPR_MTLD
		list[2].frame = B
		list[2].tics,list[1].fuse = -1,-1
		list[2].flags = MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_NOCLIP
		list[2].renderflags = $|RF_FLOORSPRITE|RF_NOSPLATBILLBOARD
		list[2].angle = door.angle
		list[2].height = 0
		P_SetOrigin(list[2],
			list[2].x,
			list[2].y,
			GetActorZ(door,list[2],2)-(flip*30*door.scale)
		)
		--
		
		--spawn the papersprites
		for i = 1,4
			local angle = door.angle+(FixedAngle(90*FU*(i-1)))
			local x,y = ReturnTrigAngles(angle)
			list[2+i] = P_SpawnMobjFromMobj(door,32*x,32*y,0,MT_THOK)
			list[2+i].frame = C
			list[2+i].sprite = SPR_MTLD
			list[2+i].tics,list[1].fuse = -1,-1
			list[2+i].flags = MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_NOCLIP
			list[2+i].renderflags = $|RF_PAPERSPRITE|RF_NOSPLATBILLBOARD
			list[2+i].angle = angle+ANGLE_90
			list[2+i].height = 30*FU
			list[2+i].radius = 0
			P_SetOrigin(list[2+i],
				list[2+i].x,
				list[2+i].y,
				GetActorZ(door,list[2+i],2)-(flip*30*door.scale)
			)
		end
		
		door.sideblock1 = {}
		list = door.sideblock1
		
		for i = 1,2
			local angle = door.angle+FixedAngle(90*FU)
			local x,y = ReturnTrigAngles(angle)
			local dist = (i == 1) and 30 or 24
			list[0+i] = P_SpawnMobjFromMobj(door,dist*x,dist*y,0,MT_THOK)
			list[0+i].frame = D
			list[0+i].sprite = SPR_MTLD
			list[0+i].tics,list[1].fuse = -1,-1
			list[0+i].flags = MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_NOCLIP
			list[0+i].renderflags = $|RF_PAPERSPRITE|RF_NOSPLATBILLBOARD
			list[0+i].angle = angle+ANGLE_90
			list[0+i].height = 110*FU
			list[0+i].radius = 0
			P_SetOrigin(list[0+i],
				list[0+i].x,
				list[0+i].y,
				GetActorZ(door,list[0+i],1)
			)
		end
		for i = 1,2
			local angle = door.angle+FixedAngle(90*FU)
			angle = $+((i == 1) and FixedAngle(90*FU) or FixedAngle(270*FU))
			
			local x,y = ReturnTrigAngles(angle)
			list[2+i] = P_SpawnMobjFromMobj(list[i],
				32*x,
				32*y,
				0,
				MT_THOK
			)
			list[2+i].frame = E
			list[2+i].sprite = SPR_MTLD
			list[2+i].tics,list[1].fuse = -1,-1
			list[2+i].flags = MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_NOCLIP
			list[2+i].renderflags = $|RF_PAPERSPRITE|RF_NOSPLATBILLBOARD
			list[2+i].angle = angle+ANGLE_90
			list[2+i].height = 110*FU
			list[2+i].radius = 0
			P_SetOrigin(list[2+i],
				list[2+i].x,
				list[2+i].y,
				GetActorZ(door,list[2+i],1)
			)
		end
		local x,y = ReturnTrigAngles(door.angle+FixedAngle(90*FU))
		list[5] = P_SpawnMobjFromMobj(door,27*x,27*y,0,MT_THOK)
		list[5].frame = F
		list[5].sprite = SPR_MTLD
		list[5].tics,list[1].fuse = -1,-1
		list[5].flags = MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_NOCLIP
		list[5].renderflags = $|RF_FLOORSPRITE|RF_NOSPLATBILLBOARD
		list[5].angle = door.angle+FixedAngle(90*FU)
		list[5].height = 0
		list[5].radius = 0
		P_SetOrigin(list[5],
			list[5].x,
			list[5].y,
			GetActorZ(door,list[5],1)
		)
		
		door.sideblock2 = {}
		list = door.sideblock2
		
		for i = 1,2
			local angle = door.angle-FixedAngle(90*FU)
			local x,y = ReturnTrigAngles(angle)
			local dist = (i == 1) and 30 or 24
			list[0+i] = P_SpawnMobjFromMobj(door,dist*x,dist*y,0,MT_THOK)
			list[0+i].frame = D
			list[0+i].sprite = SPR_MTLD
			list[0+i].tics,list[1].fuse = -1,-1
			list[0+i].flags = MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_NOCLIP
			list[0+i].renderflags = $|RF_PAPERSPRITE|RF_NOSPLATBILLBOARD
			list[0+i].angle = angle+ANGLE_90
			list[0+i].height = 110*FU
			list[0+i].radius = 0
			P_SetOrigin(list[0+i],
				list[0+i].x,
				list[0+i].y,
				GetActorZ(door,list[0+i],1)
			)
		end
		for i = 1,2
			local angle = door.angle-FixedAngle(90*FU)
			angle = $+((i == 1) and FixedAngle(90*FU) or FixedAngle(270*FU))
			
			local x,y = ReturnTrigAngles(angle)
			list[2+i] = P_SpawnMobjFromMobj(list[i],
				32*x,
				32*y,
				0,
				MT_THOK
			)
			list[2+i].frame = E
			list[2+i].sprite = SPR_MTLD
			list[2+i].tics,list[1].fuse = -1,-1
			list[2+i].flags = MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_NOCLIP
			list[2+i].renderflags = $|RF_PAPERSPRITE|RF_NOSPLATBILLBOARD
			list[2+i].angle = angle+ANGLE_90
			list[2+i].height = 110*FU
			list[2+i].radius = 0
			P_SetOrigin(list[2+i],
				list[2+i].x,
				list[2+i].y,
				GetActorZ(door,list[2+i],1)
			)
		end
		local x,y = ReturnTrigAngles(door.angle-FixedAngle(90*FU))
		list[5] = P_SpawnMobjFromMobj(door,27*x,27*y,0,MT_THOK)
		list[5].frame = F
		list[5].sprite = SPR_MTLD
		list[5].tics,list[1].fuse = -1,-1
		list[5].flags = MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_NOCLIP
		list[5].renderflags = $|RF_FLOORSPRITE|RF_NOSPLATBILLBOARD
		list[5].angle = door.angle-FixedAngle(90*FU)
		list[5].height = 0
		list[5].radius = 0
		P_SetOrigin(list[5],
			list[5].x,
			list[5].y,
			GetActorZ(door,list[5],1)
		)
		
		door.nosign = {}
		list = door.nosign
		list[1] = P_SpawnMobjFromMobj(door,0,0,0,MT_THOK)
		list[1].frame = G
		list[1].sprite = SPR_MTLD
		list[1].tics,list[1].fuse = -1,-1
		list[1].flags = MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_NOCLIP
		list[1].renderflags = $|RF_PAPERSPRITE|RF_NOSPLATBILLBOARD
		list[1].angle = door.angle+FixedAngle(90*FU)
		list[1].height = 140*FU
		list[1].radius = 0
		P_SetOrigin(list[1],
			list[1].x,
			list[1].y,
			GetActorZ(door,list[1],1)
		)
		
		door.alarm = {}
		list = door.alarm
		list[1] = P_SpawnMobjFromMobj(door,0,0,height,MT_THOK)
		list[1].frame = H
		list[1].sprite = SPR_MTLD
		list[1].tics,list[1].fuse = -1,-1
		list[1].flags = MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_NOCLIP
		list[1].angle = door.angle
		list[1].height = 16*FU
		list[1].radius = 16*FU
		P_SetOrigin(list[1],
			list[1].x,
			list[1].y,
			GetActorZ(door,list[1],2)
		)
		
		door.made3d = true
	else
		if (door.flashing)
			door.alarm[1].frame = I
			door.flashing = $-1
		else
			door.alarm[1].frame = H
		end
	end
end,MT_TAKIS_METALDETECTOR)

local gibbinglist = {
	MT_FANG,
}
local function regulargib(mo)
	if not (mo and mo.valid) then return end
	mo.takis_metalgibs = false
	print("metalgib: "..tostring(mo.takis_metalgibs))
end

for _,type in ipairs(gibbinglist)
	addHook("MobjSpawn",regulargib,type)
end

addHook("MobjThinker",function(mo)
	if not mo
	or not mo.valid
		return
	end
	
	mo.startfuse = $ or 20
	mo.timealive = $+1
	if (mo.startfuse - mo.timealive) <= 10
		if mo.scalespeed == 0
			mo.scalespeed = FU/20
		end
		mo.scalespeed = $*6/5
	else
		mo.scalespeed = 0
	end
	
	if not (camera.chase)
		mo.flags2 = $|MF2_DONTDRAW
	else
		mo.flags2 = $ &~MF2_DONTDRAW
	end
	
	if mo.tracer.skin ~= TAKIS_SKIN
		mo.flags2 = $|MF2_DONTDRAW
	end
	
	if mo.tracer.flags2 & MF2_DONTDRAW
		mo.eflags = $|MF2_DONTDRAW
	end
	
	local mul = FU*19/22
	
	/*
	if (mo.eflags & MFE_UNDERWATER|MFE_TOUCHWATER == MFE_UNDERWATER|MFE_TOUCHWATER)
	and not (mo.eflags & MFE_TOUCHLAVA)
		mo.tics = -1
		mo.frame = A
		mo.sprite = SPR_BUBL
		mo.frame = D
		mo.rollangle = 0
		mul = $/2
	else
		if mo.sprite == SPR_BUBL
			P_RemoveMobj(mo)
			return
		end
	end
	*/
	
	mo.momx,mo.momy,mo.momz = FixedMul($1,mul),FixedMul($2,mul),FixedMul($3,mul)
end,MT_TAKIS_STEAM)

addHook("MobjThinker",function(drone)
	if not (drone and drone.valid) then return end
	
	if not (drone.exitsign and drone.exitsign.valid)
		local d = P_SpawnMobjFromMobj(drone,0,0,100*drone.scale,MT_THOK)
		d.sprite = SPR_WDRG
		d.frame = A
		d.tics = -1
		d.fuse = -1
		drone.exitsign = d
	end
	if not (drone.exitrow1 and drone.exitrow1.valid)
		local d = P_SpawnMobjFromMobj(drone,0,0,15*drone.scale,MT_THOK)
		d.sprite = SPR_WDRG
		d.frame = C
		d.renderflags = $|RF_PAPERSPRITE
		d.tics = -1
		d.fuse = -1
		drone.exitrow1 = d
	end
	if not (drone.exitrow2 and drone.exitrow2.valid)
		local d = P_SpawnMobjFromMobj(drone,0,0,15*drone.scale,MT_THOK)
		d.sprite = SPR_WDRG
		d.frame = C
		d.renderflags = $|RF_PAPERSPRITE
		d.tics = -1
		d.fuse = -1
		drone.exitrow2 = d
	end
	
	local ticker = (leveltime/2 % 2)
	if (displayplayer and displayplayer.valid)
	and (skins[displayplayer.skin].name == TAKIS_SKIN)
		local takis = displayplayer.takistable
		
		if takis
		and takis.io.flashes == 0
			ticker = 0
		end
	end
	
	if drone.timealive == nil
		drone.timealive = 0
	else
		drone.timealive = $+1
	end
	drone.circle = FixedAngle( (5*FU)*drone.timealive )
	
	if (drone.exitsign and drone.exitsign.valid)
		drone.exitsign.frame = D+ticker
		if not HAPPY_HOUR.happyhour
			drone.exitsign.flags2 = $|MF2_DONTDRAW
		else
			drone.exitsign.flags2 = $ &~MF2_DONTDRAW
		end
	end
	if (drone.exitrow1 and drone.exitrow1.valid)
		drone.exitrow1.frame = B+ticker
		drone.exitrow1.angle = drone.circle
		drone.exitrow1.spriteyoffset = sin(drone.circle)*12
		if not HAPPY_HOUR.happyhour
			drone.exitrow1.flags2 = $|MF2_DONTDRAW
		else
			drone.exitrow1.flags2 = $ &~MF2_DONTDRAW
		end
	end
	if (drone.exitrow2 and drone.exitrow2.valid)
		drone.exitrow2.frame = B+ticker
		drone.exitrow2.angle = drone.circle+ANGLE_90
		drone.exitrow2.spriteyoffset = sin(drone.circle)*12
		if not HAPPY_HOUR.happyhour
			drone.exitrow2.flags2 = $|MF2_DONTDRAW
		else
			drone.exitrow2.flags2 = $ &~MF2_DONTDRAW
		end
	end
	
end,MT_NIGHTSDRONE)

--SUMMIT!
addHook("GameQuit",function(quit)
	if not quit then return end
	
	S_StopMusic(consoleplayer)
	S_StartSound(nil,sfx_summit)
end)

addHook("MobjThinker",function(pong)
	if not (pong and pong.valid) then return end
	
	local timealive = (states[S_TAKIS_PONGLER].tics+1)-(pong.tics)
	
	local circle = FixedAngle( (5*FU)*timealive )
	pong.spritexoffset = sin(circle)*12
	
	if timealive <= 10
		if pong.scalespeed == 0
			pong.scalespeed = FU/20
		end
		pong.scalespeed = $*6/5
		if timealive <= 8
			pong.frame = (pong.frame & FF_FRAMEMASK)|numtotrans[9-timealive]
		else
			pong.frame = (pong.frame & FF_FRAMEMASK)
		end
		
	elseif timealive >= (states[S_TAKIS_PONGLER].tics+1)-9
		pong.destscale = 0
		if pong.scalespeed == 0
			pong.scalespeed = FU/20
		end
		pong.scalespeed = $*6/5
		
		if timealive >= (states[S_TAKIS_PONGLER].tics+1)-9
			local trans = timealive-((states[S_TAKIS_PONGLER].tics+1)-9)
			pong.frame = (pong.frame & FF_FRAMEMASK)|numtotrans[trans]
		end
	else
		pong.frame = (pong.frame & FF_FRAMEMASK)
		pong.destscale = 0
		pong.scalespeed = 0
	end
	
end,MT_TAKIS_PONGLER)

filesdone = $+1

