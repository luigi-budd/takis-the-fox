--buggiethebug wants this in so here it is!!!
-- https://mb.srb2.org/addons/nights-free-roam.5657/

rawset(_G,"NiGHTSFreeroam",function(player)
	local mo = player.mo
	player.nightsfreeroam = true
	P_SpawnGhostMobj(mo)
	
	player.powers[pw_carry] = 0
	mo.target = nil
	mo.flags = $&~MF_NOGRAVITY
	mo.color = player.skincolor
	mo.state = S_PLAY_STND
	player.nightsuntransform = 0
	P_FlashPal(player,1,3)
	for i = 0,16
		local fa = player.drawangle + (360/16)*i*ANG1
		local spark = P_SpawnMobjFromMobj(mo,0,0,mo.height/2,MT_SUPERSPARK)
		P_InstaThrust(spark,fa,16*mo.scale)
	end
	player.transformcooldown = TICRATE
	S_StartSound(mo,sfx_s1a8)
end)

/*
addHook("ShouldDamage", function(mo,mobj,src,dmg,dmgtype)
	if mo.skin ~= TAKIS_SKIN
		return
	end
	
	if mo.player and mo.player.valid
		local player = mo.player
		if (mobj == mo
		or src == mo)
			return
		end
		
		if player.nightsfreeroam
		and player.powers[pw_carry] != CR_NIGHTSMODE
		and not player.powers[pw_flashing]
			S_StartSound(mo,sfx_nghurt)
			if player.nightstime > TICRATE*5
				player.nightstime = $-TICRATE*5
			else
				player.nightstime = 0
			end
			return true
		end
	end
end,MT_PLAYER)
*/

addHook("TouchSpecial", function(mo,mobj)
	if mobj and mobj.valid
		if mobj.player and mobj.player.valid
			if mobj.player.transformcooldown
				mobj.player.transformcooldown = TICRATE
				return true
			end
			if mobj.player.freeroamtime
			and mobj.player.nightsfreeroam
				TakisResetHammerTime(mobj.player)
				mobj.player.setnighttime = true
				mobj.player.nightsfreeroam = false
			end
		end
	end
end,MT_NIGHTSDRONE)

addHook("PlayerSpawn", function(player)
	if player.valid and not player.spectator
	and player.mo and player.mo.valid
		player.nightsfreeroam = false
		player.setnighttime = false
		player.freeroamtime = 0
		player.transformcooldown = 0
	end
end)

addHook("PlayerThink", function(player)
	if player.valid and not player.spectator
	and player.mo and player.mo.valid
		local mo = player.mo
		player.nightsuntransform = $ or 0
		player.transformcooldown = $ or 0
		if player.transformcooldown then player.transformcooldown = $-1 end
		
		if player.nightstime != player.freeroamtime
		and player.setnighttime
			player.nightstime = player.freeroamtime
			player.setnighttime = false
		end
		
		if player.nightsfreeroam
			player.nightstime = $-1
			player.freeroamtime = player.nightstime
			if player.powers[pw_carry] == CR_NIGHTSMODE
				player.nightsfreeroam = false
			end
			if mo.subsector and mo.subsector.valid
			and mo.subsector.sector and mo.subsector.sector.valid
				if GetSecSpecial(mo.subsector.sector.special,4) == 2
					player.powers[pw_carry] = CR_NIGHTSFALL
				end
			end
			if R_PointToDist2(0,FixedHypot(mo.momx,mo.momy),0,mo.momz)
				local rmom = R_PointToAngle2(0,0,mo.momx,mo.momy)
				if (leveltime&1)
					local fmobj
					local smobj
					local spawndist = FixedMul(16*FRACUNIT,mo.scale)
					fmobj = P_SpawnMobjFromMobj(mo,
						P_ReturnThrustX(mo,rmom+ANGLE_90,spawndist),
						P_ReturnThrustY(mo,rmom+ANGLE_90,spawndist),
						mo.height/2,MT_NIGHTSPARKLE)
					smobj = P_SpawnMobjFromMobj(mo,
						P_ReturnThrustX(mo,rmom-ANGLE_90,spawndist),
						P_ReturnThrustY(mo,rmom-ANGLE_90,spawndist),
						mo.height/2,MT_NIGHTSPARKLE)
					
					fmobj.target = mo
					smobj.target = mo
					
					if player.powers[pw_nights_superloop]
						fmobj.state = mobjinfo[MT_NIGHTSPARKLE].seestate
						smobj.state = mobjinfo[MT_NIGHTSPARKLE].seestate
					end
				end
				
				local helpermobj = P_SpawnMobj(mo.x,mo.y,mo.z+mo.height/2,MT_NIGHTSLOOPHELPER)
				helpermobj.fuse = leveltime
				mo.fuse = leveltime
				helpermobj.target = mo
				helpermobj.scale = mo.scale
			end
			if player.nightstime <= 0
			and not player.exiting
				player.nightsfreeroam = false
				player.setnighttime = false
				player.freeroamtime = 0
				player.powers[pw_carry] = CR_NIGHTSFALL
				if G_IsSpecialStage(gamemap)
					for p in players.iterate
						p.nightstime = 1
						player.exiting = 3*TICRATE
						player.marescore = 0
						player.spheres = 0
						player.rings = 0
					end
				end
				for mobj in mobjs.iterate()
					if mobj.type != MT_NIGHTSDRONE then continue end
					if (mobj.flags2 & MF2_AMBUSH)
						player.marescore = 0
						player.spheres = 0
						player.rings = 0
						P_DamageMobj(mo,nil,nil,1,DMG_INSTAKILL)
						return
					end
				end
				S_StartSound(nil,sfx_timeup)
			end
		end
	end
end)

filesdone = $+1
