local function L_ZCollide(mo1,mo2)
	if mo1.z > mo2.height+mo2.z then return false end
	if mo2.z > mo1.height+mo1.z then return false end
	return true
end

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
	
	if (TAKIS_NET.cards == false and card.spawnedfrommt ~= true) then P_RemoveMobj(card); return end
	
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

filesdone = $+1