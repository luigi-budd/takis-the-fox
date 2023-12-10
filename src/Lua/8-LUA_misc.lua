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
	
	if not (camera.chase)
		--only dontdraw afterimages that are too close to the player
		local dist = TAKIS_TAUNT_DIST*3
		
		local dx = me.x-ai.x
		local dy = me.y-ai.y
		local dz = me.z-ai.z
		if FixedHypot(FixedHypot(dx,dy),dz) < dist
			ai.flags2 = $|MF2_DONTDRAW
		else
			ai.flags2 = $ &~MF2_DONTDRAW
		end
	else
		ai.flags2 = $ &~MF2_DONTDRAW
	end
	
	if p.takistable.io.additiveai
		ai.blendmode = AST_ADD
	else
		ai.blendmode = AST_TRANSLUCENT
	end
	
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
	if (TAKIS_NET.collaterals)
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
				if (found.takis_flingme ~= false)
					if (found.flags & (MF_ENEMY|MF_BOSS))
					or (found.takis_flingme)
						SpawnBam(found)
						SpawnRagThing(found,rag,rag.parent2)
						local sfx = P_SpawnGhostMobj(found)
						sfx.flags2 = $|MF2_DONTDRAW
						sfx.tics = TR
						S_StartSound(sfx,sfx_smack)
					elseif (SPIKE_LIST[found.type] == true)
						P_KillMobj(found,rag,rag.parent2)
					end
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
		for i = 0, 34
			A_BossScream(rag,1,MT_SONIC3KBOSSEXPLODE)
		end
		
		--collaterals
		if (TAKIS_NET.collaterals)
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
					if (found.takis_flingme ~= false)
						if (found.flags & (MF_ENEMY|MF_BOSS))
						or (found.takis_flingme)
							SpawnRagThing(found,helper,helper.parent2)
						elseif (SPIKE_LIST[found.type] == true)
							P_KillMobj(found,helper,helper.parent2)
						end
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
	
	if not post.activators
		post.activators = {
			cards = {},
			combo = {}
		}
	end
	if not post.activators.cards
		post.activators.cards = {}
	end
	if not post.activators.combo
		post.activators.combo = {}
	end
	
	--thanks amperbee
	if not post.activators.cards[touch]
		
		if ((post.activators.cards[touch] == false) or (post.activators.cards[touch] == nil))
			docards(post,touch)
		end
	end
	if not post.activators.combo[touch]
		if ((post.activators.combo[touch] == false) or (post.activators.combo[touch] == nil))
			docombo(post,touch)
		end
	end
	if not touch.player.takistable.HUD.menutext.tics
		touch.player.takistable.HUD.menutext.tics = 3*TR+9
	end
end, MT_STARPOST)

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
	
	if not sweat.tracer
	or not sweat.tracer.valid
		P_RemoveMobj(sweat)
		return
	end
	
	if not (camera.chase)
		sweat.flags2 = $|MF2_DONTDRAW
	else
		sweat.flags2 = $ &~MF2_DONTDRAW
	end
	
	if sweat.tracer.skin ~= TAKIS_SKIN
		sweat.flags2 = $|MF2_DONTDRAW
	end
	
	if sweat.tracer.eflags & MFE_VERTICALFLIP
		sweat.eflags = $|MFE_VERTICALFLIP
	else
		sweat.eflags = $ &~MFE_VERTICALFLIP
	end	
	P_MoveOrigin(sweat, sweat.tracer.x, sweat.tracer.y, GetActorZ(sweat.tracer,sweat,1))
	sweat.scale = sweat.tracer.scale
	sweat.spritexscale,sweat.spriteyscale = sweat.tracer.spritexscale,sweat.tracer.spriteyscale
end,MT_TAKIS_SWEAT)

addHook("MobjThinker", function(bolt)
	if not bolt
	or not bolt.valid
		return
	end
	
	if not bolt.tracer
	or not bolt.tracer.valid
		P_RemoveMobj(bolt)
		return
	end
	
	if not (camera.chase)
		bolt.flags2 = $|MF2_DONTDRAW
	else
		bolt.flags2 = $ &~MF2_DONTDRAW
	end
	
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

addHook("MobjDeath",function(mo,i,s)
	local gst = P_SpawnGhostMobj(mo)
	gst.flags2 = $|MF2_DONTDRAW
	gst.fuse = 3*TR
	
	S_StartSound(gst,mobjinfo[MT_SPIKE].deathsound)

	for i = 0,16
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
		P_SetObjectMomZ(debris,10*mo.scale)
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
	
	local dohhmus = true
	if (consoleplayer.takistable.io.nohappyhour == 1)
		dohhmus = false
	end
	
	if (skins[consoleplayer.skin].name ~= TAKIS_SKIN)
	and (consoleplayer.takistable.io.morehappyhour == 0)
		dohhmus = false
	end
	
	if (HAPPY_HOUR.happyhour)
	and dohhmus
	
		local hh = HAPPY_HOUR
		local nomus = hh.nosong
		local noendmus = hh.noendsong
		
		local song = hh.song
		local songend = hh.songend
		
		newname = string.lower(newname)
		
		local isspecsong
		isspecsong = string.sub(newname,1,1) == "_"
		if not isspecsong
			isspecsong = TAKIS_NET.specsongs[newname]
		end
		
		oldname = string.lower($)
		
		--stop any lap music
		if (not isspecsong)
		
			local changetohappy = true
			
			if HAPPY_HOUR.timelimit
				
				if HAPPY_HOUR.timeleft
					local tics = HAPPY_HOUR.timeleft
					
					if tics <= (56*TR)
					and (hh.noendsong == false)
						changetohappy = false
					end
				end
			end
			
			if changetohappy
				if nomus then return end
				
				if oldname ~= song
					return ReturnTakisMusic(song,consoleplayer),mflags,looping,pos,prefade,fade
				end
			
			else
				if noendmus then return end
				
				if oldname ~= songend
					return ReturnTakisMusic(songend,consoleplayer),mflags,looping,pos,prefade,fade
				end
			end
			
			return true
		end
		
	else

		if not consoleplayer.takistable.shotgunned
			return
		end
		
		local newname = string.lower(newname)
		
		if (TAKIS_NET.specsongs[newname] ~= true)
			return ReturnTakisMusic("war",consoleplayer),mflags,looping,pos,prefade,fade
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
		if not mo.set
			mo.flags = MF_SPECIAL
			mo.set = true
		end
		
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
	
	if (mo.flags & MF_MONITOR)
		SpawnRagThing(mo,shot,shot.tracer)
	end
	
	if (SPIKE_LIST[mo.type] == true)
		P_KillMobj(mo,shot,shot.tracer)
	end
	
	if (mo.flags & (MF_ENEMY|MF_BOSS))
		SpawnRagThing(mo,shot,shot.tracer)
		return true
	end
	
	--spice runners' pf ai
	/*
	if (_G["MT_PIZZA_ENEMY"])
	and (mo.type == MT_PIZZA_ENEMY)
		local ang = R_PointToAngle2(mo.x,mo.y, shot.x,shot.y)
		local tics = TR
		local xy,z = 15*FU,15*FU
		if (CV_PTSR)
			tics = CV_PTSR.parrystuntime.value
			xy = CV_PTSR.parryknockback_xy.value
			z = CV_PTSR.parryknockback_z.value
		end
		
		mo.pfstunmomentum = true
		mo.pfstuntime = tics
		P_SetObjectMomZ(mo, z)
		P_InstaThrust(mo, ang - ANGLE_180, xy)
		
	end
	*/
	
end,MT_THROWNSCATTER)

local function gunragdoll(gun,i)
	local rag = P_SpawnMobjFromMobj(gun,0,0,0,MT_TAKIS_SHOTGUN)
	rag.ragdoll = true
	rag.timealive = 0
	rag.flags = $ &~MF_NOGRAVITY
	rag.fuse = 4*TR
	rag.frame = B
	rag.rollangle = ANGLE_90-(ANG10*3)
	
	P_SetObjectMomZ(rag,10*FU)
	P_Thrust(rag, R_PointToAngle2(rag.x,rag.y, i.x,i.y), -5*rag.scale)
	
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
				TakisShotgunify(s.player)
				TakisGiveCombo(s.player,s.player.takistable,false,true)
			else
				gunragdoll(gun,s)
			end
		end
	end
end,MT_TAKIS_SHOTGUN)

addHook("MobjThinker",function(shot)
	if not shot.shotbytakis
		return
	end
	
	TakisBreakAndBust(nil,shot)
	
end,MT_THROWNSCATTER)

addHook("MobjDeath",function(shot,i,s)
	if ((i == shot.tracer) or (s == shot.tracer))
	or ((shot.timealive < 10) and (i.valid or s.valid))
	and (shot.shotbytakis)
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
addHook("PreThinkFrame",function()
	for p in players.iterate
		if not p
		or not p.valid
			continue
		end
		
		--p.HAPPY_HOURscream = {}
		
		if not p.takistable
			continue
		end
		
		local takis = p.takistable
		
		if (takis.cosmenu.menuinaction)
			TakisMenuThinker(p)
		end
		
		if (takis.transfo & TRANSFO_TORNADO)
		and not (takis.nadocrash)
			local force = 50
			--brake a bit
			if P_GetPlayerControlDirection(p) == 2
				force = $-((25-p.cmd.forwardmove)/2)
				force = min(50,$)
			end
			p.cmd.forwardmove = force
			p.cmd.sidemove = $/2
		end
		
	end
end)

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
				spark.tracer = s
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

addHook("MobjThinker",function(me)
	if not me
	or not me.valid
		return
	end
	
	if me.activators == nil
		me.activators = {
			cards = {},
			combo = {},
			cardsrespawn = {},
			comborespawn = {},
		}
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
	
	local br = 145*me.scale
	
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
				
				local x,y = ReturnTrigAngles(R_PointToAngle2(me.x,me.y, found.x,found.y))
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
					card.angle = (R_PointToAngle2(me.x,me.y, found.x,found.y))-ANGLE_90
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
					combo.angle = (R_PointToAngle2(me.x,me.y, found.x,found.y))-ANGLE_90
				end
				--
			end
		end
	end
	
end,MT_STARPOST)

addHook("BossThinker", function(mo)
	if (not TAKIS_NET.inbossmap)
	and (mapheaderinfo[gamemap].muspostbossname)
		TAKIS_NET.inbossmap = true
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
		HH_Trigger(drone,coolp.nightstime)
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

--i couldve sworn i had a postthink in here
--that may just be thinking this is soap lol
--anyway, thanks to Unmatched Bracket for this code!!!
--:iwantsummadat:
addHook("PostThinkFrame", function ()
    for p in players.iterate() do
        if not (p and p.valid) then continue end
		if not (p.mo and p.mo.valid) then continue end
		if not (p.mo.skin == TAKIS_SKIN) then continue end
		
		local me = p.realmo
		local takis = p.takistable
		
		if (takis.transfo & TRANSFO_TORNADO)
			p.drawangle = me.angle+takis.nadoang
		end
		
        if takis.inwaterslide
		and not (takis.inPain or takis.inFakePain) then
            takis.resettingtoslide = true
			p.mo.sprite2 = SPR2_SLID
            p.mo.frame = ($ & ~FF_FRAMEMASK) | (leveltime % 4) / 2
            p.drawangle = p.mo.angle
			continue
        end
		
		takis.resettingtoslide = false
    end
end)

addHook("MobjThinker",function(ring)
	if not ring
	or not ring.valid
		return
	end
	
	--idk why regular fuse cant do this
	local start = ring.startingtrans
	local startn = transtonum[ring.startingtrans]
	if ring.fuse < 10-startn
		ring.frame = A|numtotrans[10-ring.fuse]
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
	
end

local flinglist = {
	MT_EGGROBO1,
	MT_ROSY,	--DIE
}

for k,type in pairs(flinglist)
	addHook("MobjSpawn",makefling,type)
end

--heartcards mt
local function cardspawn(card,spawnedfrommt,hasambush)
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
	
	card.spritexscale,card.spriteyscale = cardscale,cardscale
	card.spawnedfrommt = spawnedfrommt
end

addHook("MapThingSpawn",function(mo,mt)
	if not (mo and mo.valid) then return end
	cardspawn(mo,true,mt.options & MTF_AMBUSH)
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
	
	--end of life blinking
	if (card.timealive >= 50*TR)
	and (card.spawnedfrommt ~= true)
		if card.timealive < 57*TR
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
	
	if grounded
		if (card.eflags & MFE_JUSTHITFLOOR)
			if (-card.lastmomz > 2*FU)
				P_SetObjectMomZ(card,-card.lastmomz/2)
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
			and (splitscreen or multiplayer))
				local new = P_SpawnMobjFromMobj(card,0,0,0,MT_THOK)
				new.camefromcard = true
				new.respawntime = CV_FindVar("respawnitemtime").value * TICRATE
				new.cardflags = card.spawnflags or mobjinfo[card.type].flags
				new.cardhadambush = card.cardhadambush
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

--thok respawns cards for us
addHook("MobjThinker",function(th)
	if not (th and th.valid) then return end
	if not (th.camefromcard) then return end
	
	th.flags2 = $|MF2_DONTDRAW
	--tic respawn timer
	if (th.respawntime)
		if th.respawntime > CV_FindVar("respawnitemtime").value * TICRATE
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
		P_RemoveMobj(th)
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
	MT_STEAM	--thz steam
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


filesdone = $+1
