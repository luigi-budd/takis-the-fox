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
	elseif th.isakartspark
		th.prevmomz = $ or th.momz
		if th.timealive == nil
			th.timealive = 0
		else
			th.timealive = $+1
		end
		
		if P_IsObjectOnGround(th)
			if P_RandomChance(FU/2)
			and (th.prevmomz*P_MobjFlip(th)) <= -5*th.scale
			and not th.bouncedup
				P_SetObjectMomZ(th,-
					FixedDiv(
						FixedDiv(th.prevmomz,th.scale),
						2*FU+(P_RandomFixed()*(P_RandomChance(FU/2) and 1 or -1))
					)
				)
				th.bouncedup = true
			else
				P_RemoveMobj(th)
				return
			end
		end
		th.frame = $|FF_FULLBRIGHT
		local maxiter = 2
		local momx = th.momx/(maxiter*2)
		local momy = th.momy/(maxiter*2)
		local momz = th.momz/(maxiter*2)
		for i = 0,maxiter-1
			local posx,posy,posz = 0,0,0
			posx = momx*i
			posy = momy*i
			posz = momz*i
			local angle = th.angle
			local spark = P_SpawnMobjFromMobj(th,
				posx,
				posy,
				posz,
				MT_THOK
			)
			local lifetime = 8
			spark.scale = th.scale
			spark.angle = angle
			spark.spritexscale,spark.spriteyscale = th.spritexscale,th.spriteyscale
			spark.blendmode = th.blendmode
			spark.tics,spark.fuse = lifetime,lifetime
			spark.color = th.color
			spark.destscale = 0
			spark.scalespeed = $*2
			spark.frame = $|FF_FULLBRIGHT
			if th.isrealspark
				spark.camefromspark = true
			end
		end
		th.prevmomz = th.momz
	elseif th.camefromspark
		if th.tics > 4
		and th.tics <= 6
			th.color = SKINCOLOR_APRICOT
		elseif th.tics > 2
		and th.tics <= 4
			th.color = SKINCOLOR_LEMON
		elseif th.tics <= 2
			th.color = SKINCOLOR_WHITE
		end
	else
		return
	end
	
end,MT_THOK)

filesdone = $+1