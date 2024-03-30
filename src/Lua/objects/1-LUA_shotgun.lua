local function L_ZCollide(mo1,mo2)
	if mo1.z > mo2.height+mo2.z then return false end
	if mo2.z > mo1.height+mo1.z then return false end
	return true
end

--SHOTGUN
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
				TakisShotgunify(s.player,gun.forceon ~= nil)
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
--

--SHOTGUN SHOT

--specki is strangely invulnerable to this
addHook("MobjMoveCollide",function(shot,mo)
	if not shot
	or not shot.valid
		return
	end
	
	if not L_ZCollide(shot,mo)
		return
	end
	
	if not mo.health
		return
	end
	
	if not (shot.parent and shot.parent.valid)
		return
	end
	
	if (SPIKE_LIST[mo.type] == true)
		P_KillMobj(mo,shot,shot.parent)
		return
	end
	
	if (CanFlingThing(mo)
	or (
		mo.type == MT_PLAYER
		and CanPlayerHurtPlayer(shot.parent.player,mo.player)
		--dont kill ourselves though
		and (mo ~= shot.parent)
	))
	and (mo.health)
		S_StartSound(mo,sfx_sdmkil)
		SpawnEnemyGibs(shot,mo)
		SpawnBam(mo)
		if (mo.type ~= MT_PLAYER)
			SpawnRagThing(mo,shot,shot.parent)
			if (mo.flags & MF_BOSS)
				local boom = P_SpawnMobjFromMobj(mo,0,0,0,MT_THOK)
				boom.flags2 = $|MF2_DONTDRAW
				boom.radius,boom.height = mo.radius,mo.height
				
				S_StartSound(mo,sfx_tkapow)
				for i = 0,P_RandomRange(10,20)
					A_BossScream(boom,1,MT_SONIC3KBOSSEXPLODE)
				end
				DoFlash(shot.parent.player,PAL_WHITE,3)
			end
		else
			--dont hurt other shotgunners with chainguns
			if (mo.player.takistable.transfo & TRANSFO_SHOTGUN)
			and (TAKIS_NET.chaingun)
				return false
			end
			
			P_KillMobj(mo,shot,shot.parent)
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
	
end,MT_TAKIS_GUNSHOT)

local colorlist = {
	SKINCOLOR_FLAME,
	SKINCOLOR_GARNET,
	SKINCOLOR_KETCHUP
}

addHook("MobjThinker",function(shot)
	TakisBreakAndBust(nil,shot)
	shot.timealive = $+1
	shot.color = colorlist[P_RandomRange(1,#colorlist)]
	
	if shot.timealive < 3 then return end
	
	local ghost = P_SpawnGhostMobj(shot)
	ghost.colorized = true
	ghost.blendmode = AST_ADD
	ghost.destscale = 1
	ghost.angle = shot.angle+(P_RandomRange(-20,20)*FU+((P_RandomChance(FU/2) and 1 or -1)*P_RandomFixed()))
	P_Thrust(ghost,ghost.angle,-P_RandomRange(10,20)*shot.scale)
	ghost.angle = shot.angle
	P_SetObjectMomZ(ghost,P_RandomRange(-3,3)*ghost.scale)
end,MT_TAKIS_GUNSHOT)

addHook("MobjDeath",function(shot,i,s)
	if (shot.timealive)
		shot.health = 1
		return true
	end
	if ((i == shot.parent) or (s == shot.parent))
	or ((i and i.valid or s and s.valid))
		shot.health = 1
		return true
	end
end,MT_TAKIS_GUNSHOT)
--

--SHOTGUN BOXES
addHook("MapThingSpawn",function(mo,mt)
	if mt.options & MTF_AMBUSH
		mo.type = MT_SHOTGUN_GOLDBOX
	end
	if mt.options & MTF_OBJECTSPECIAL
		mo.forcebox = true
	end
end,MT_SHOTGUN_BOX)
--

filesdone = $+1