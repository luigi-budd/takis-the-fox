--mariokart????????????
/*
	-[done]teleporters dont tp the kart, snaps the player back
	-[done]springs unsuable
	-[done]solids passable
	-joystick support
	-clean up code and make it easier to port (seperate taksi stuff)
	-make drift more accurate
	
*/

SafeFreeslot("MT_TAKIS_KART_HELPER")
SafeFreeslot("S_TAKIS_KART_HELPER")
states[S_TAKIS_KART_HELPER] = {
	sprite = SPR_RING,
	frame = A,
	tics = -1,
}
mobjinfo[MT_TAKIS_KART_HELPER] = {
	doomednum = -1,
	spawnstate = S_TAKIS_KART_HELPER,
	flags = MF_SOLID|MF_SLIDEME,
	height = 48*FRACUNIT,
	radius = 16*FRACUNIT,
}

SafeFreeslot("MT_TAKIS_KART")
SafeFreeslot("S_TAKIS_KART")
states[S_TAKIS_KART] = {
	sprite = SPR_KART,
	frame = A,
	tics = -1,
}
mobjinfo[MT_TAKIS_KART] = {
	doomednum = -1,
	spawnstate = S_TAKIS_KART,
	flags = MF_SPECIAL|MF_SLIDEME,
	height = 20*FRACUNIT,
	radius = 16*FRACUNIT,
}

/* TAKIS STUFF
local function TakisKart_SpawnSpark(car,angle,color,realspark)
	local x,y = cos(angle),sin(angle)
	local spark = P_SpawnMobjFromMobj(car,
		-16*x+car.momx*2,
		-16*y+car.momy*2,
		(P_RandomRange(-1,2)*car.scale)+(P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
		MT_THOK
	)
	spark.scale = FixedMul(car.scale,2*FU+(P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)))
	local sscale = FixedDiv(FU/10,spark.scale)
	local lifetime = -1
	spark.angle = angle
	spark.spritexscale,spark.spriteyscale = sscale,sscale
	spark.blendmode = AST_ADD
	spark.tics,spark.fuse = lifetime,lifetime
	P_SetObjectMomZ(spark,(P_RandomRange(4,6)*car.scale)+(P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)))
	spark.flags = $ &~(MF_NOCLIPHEIGHT|MF_NOGRAVITY)
	P_Thrust(spark,
		spark.angle,
		P_RandomRange(-4,-6)*car.scale
	)
	spark.isakartspark = true
	spark.color = color
	if realspark 
		spark.isrealspark = true
		spark.blendmode = 0
	end
	return spark
end

local function TakisKart_DriftSparkValue()
	return 70*FU
end

local function TakisKart_DriftLevel(driftspark)
	local level = 0
	if driftspark >= TakisKart_DriftSparkValue()*4
		level = 4
	elseif driftspark >= TakisKart_DriftSparkValue()*2
		level = 3
	elseif driftspark >= TakisKart_DriftSparkValue()
		level = 2
	elseif driftspark < TakisKart_DriftSparkValue()
		level = 1
	end
	return level
end

local driftclr = {
	[4] = SKINCOLOR_NEON,
	[3] = SKINCOLOR_SALMON,
	[2] = SKINCOLOR_SAPPHIRE,
	[1] = SKINCOLOR_WHITE,
	[0] = SKINCOLOR_WHITE
}

local function TakisKart_DriftColor(driftlevel)
	return driftclr[driftlevel] or SKINCOLOR_WHITE
end

local CR_TAKISKART = 20
*/

/*
addHook("PlayerSpawn",function(p)
	if p.spectator then return end
	if skins[p.skin].name ~= TAKIS_SKIN then return end
	local x,y = ReturnTrigAngles(p.mo.angle)
	local car = P_SpawnMobjFromMobj(p.mo,-100*x,-100*y,0,MT_TAKIS_KART)
	car.angle = p.mo.angle
end)
*/

local function animhandle(p,car)
	local me = p.mo
	if me.state ~= S_PLAY_TAKIS_KART
		me.state = S_PLAY_TAKIS_KART
	end
	local speed = FixedHypot(car.momx,car.momy)
	local rumble = leveltime % 2 == 0
	local frame = A
	local dontrumble = false
	
	if car.turning
		local turn = p.cmd.sidemove
		--left
		if turn > 0
			frame = G
		--right
		elseif turn < 0
			frame = D
		end
	end
	
	if car.drift
	and P_IsObjectOnGround(car)
		local frametic = car.drifttime % 2 == 1
		local driftdir = ((car.drift > 0) and 1 or -1)
		
		if driftdir > 0
			frame = K
		else
			frame = M
		end
		
		if not frametic
			frame = $+1
		end
		
		dontrumble = true
	end
	
	if P_PlayerInPain(p)
	or car.inpain
		frame = J
		dontrumble = true
	end
	
	if not dontrumble
		if speed < car.scale
			frame = (rumble) and $+1 or $
		elseif speed > car.scale
			if speed < 20*car.scale
				me.spriteyoffset = ((rumble) and FU or 0)
			end
			frame = $+(rumble and 2 or 0)
		end
	end
	
	me.frame = ($ &~FF_FRAMEMASK)|frame
	
	
end

local oldstuff = true

local function soundhandle(p,car)
	
	local numsounds = 13
	
	local closedist = 160*FU
	local fardist = 1536*FU
	
	local dampenval = 48
	
	local class,s,w = 0,0,0
	
	local volume = 255
	local voldamp = FU
	
	local targetsnd = 0
	
	local kartspeed = 9
	local kartweight = 4
	s = (kartspeed-1)/3
	w = (kartweight-1)/3
	
	class = s+(3*w)
	
	if leveltime < 8 or p.spectator -- or p.exiting
		car.enginesound = 0
		return
	end
	
	if (leveltime % 8)
		return
	end
	
	local cmdmove = (6*p.cmd.forwardmove)/25	
	local speedthing = FixedMul(car.momx,car.momy)--/50
	targetsnd = (cmdmove+speedthing)/2
	--clamp
	targetsnd = max(0,min(12,targetsnd))
	
	if car.enginesound < targetsnd then car.enginesound = $+1 end
	if car.enginesound > targetsnd then car.enginesound = $-1 end
	car.enginesound = max(0,min(12,car.enginesound))
	
	-- This code calculates how many players (and thus, how many engine sounds) are within ear shot,
	-- and rebalances the volume of your engine sound based on how far away they are.

	-- This results in multiple things:
	-- * When on your own, you will hear your own engine sound extremely clearly.
	-- * When you were alone but someone is gaining on you, yours will go quiet, and you can hear theirs more clearly.
	-- * When around tons of people, engine sounds will try to rebalance to not be as obnoxious.
	
	for player in players.iterate
		local thisvol = 0
		local dist = 0
		
		if not (player.mo and player.mo.valid)
			continue
		end
		
		if (player.spectator)
			continue
		end
		
		if (p == player)
		and (player == displayplayer)
			continue
		end
		
		dist = FixedHypot(
					FixedHypot(
						p.mo.x - player.mo.x,
						p.mo.y - player.mo.y
					),
					p.mo.z - player.mo.z
				)/2
		
		if dist > fardist
			continue
		elseif dist < closedist
			thisvol = 255
		else
			thisvol = (15*((closedist-dist)/FU))/((fardist-closedist) >> (FRACBITS+4))
		end
		
		voldamp = $+(thisvol*dampenval)
	end
	
	if voldamp > FU
		volume = FixedDiv(volume*FU,voldamp)/FU
	end
	
	if volume <= 0
		return
	end
	
	S_StartSoundAtVolume(car,sfx_krte00+car.enginesound,volume)
	
end

addHook("TouchSpecial",function(car,touch)
	if not (touch.player and touch.player.valid) then return true end
	if not (touch.health) then return true end
	if not (P_IsValidSprite2(touch,SPR2_KART)) then return true end
	if (touch.skin ~= TAKIS_SKIN) then return true end
	if (touch.player.inkart) then return true end
	
	local kart = P_SpawnMobjFromMobj(car,0,0,0,MT_TAKIS_KART_HELPER)
	kart.angle = car.angle	
	kart.target = touch
	S_StartSound(kart,sfx_kartst)
	kart.fuel = 100*FU
	touch.player.inkart = 2
end,MT_TAKIS_KART)

// countersteer is how strong the controls are telling us we are turning
// turndir is the direction the controls are telling us to turn, -1 if turning right and 1 if turning left
local function driftval(p,car, countersteer)
	local basedrift
	local driftangle
	local driftweight = 4*14;

	// If they aren't drifting or on the ground this doesn't apply
	if (car.drift == 0 or not P_IsObjectOnGround(car))
		return 0
	end
	
	/*
	if (player->kartstuff[k_driftend] != 0)
		return -266*car.drift; // Drift has ended and we are tweaking their angle back a bit
	end
	*/
	
	//basedrift = 90*player->kartstuff[k_drift]; // 450
	//basedrift = 93*player->kartstuff[k_drift] - driftweight*3*player->kartstuff[k_drift]/10; // 447 - 303
	basedrift = 83*car.drift - (driftweight - 14)*car.drift/5; // 415 - 303
	driftangle = abs((252 - driftweight)*car.drift/5);

	return basedrift + FixedMul(driftangle, countersteer);
end

local function movementstuff(p,car,maxspeed,oldspeed)
	
	local speed = R_PointToDist2(car.momx,car.momy,0,0)
	if speed > maxspeed
		local tmomx,tmomy
		if oldspeed > maxspeed
			if (speed > oldspeed)
				tmomx = FixedMul(FixedDiv(car.momx, speed), oldspeed)
				tmomy = FixedMul(FixedDiv(car.momy, speed), oldspeed)
				car.momx = tmomx
				car.momy = tmomy
			end
		else
			tmomx = FixedMul(FixedDiv(car.momx, speed), maxspeed)
			tmomy = FixedMul(FixedDiv(car.momy, speed), maxspeed)
			car.momx = tmomx
			car.momy = tmomy
		end
	end
	
end

local function driftstuff(p,car)
	local cmd = p.cmd
	local me = p.mo
	local grounded = P_IsObjectOnGround(car)

	if oldstuff
		if cmd.buttons & BT_SPIN
			if abs(car.drift) < 5
				if car.drift < 0
					car.drift = $-1
				elseif car.drift > 0
					car.drift = $+1
				end
			end
			
			if car.drift ~= 0
			and grounded
				local stop = false
				
				if not (cmd.forwardmove > 0)
					car.driftbrake = $+1
					if not S_SoundPlaying(car,sfx_skid)
						S_StartSound(car,sfx_skid)
					end
				else
					car.driftbrake = 0
					S_StopSoundByID(car,sfx_skid)
				end
				
				if FixedHypot(car.momx,car.momy) < 6*car.scale
					car.driftbrake = TR
				end
				
				if car.driftbrake >= TR/2
					car.driftedout = true
					car.drift = 0
					car.driftspark = 0
					stop = true
				end
				
				--effects and whatnot
				if not stop
					car.drifttime = $+1
					car.driftspark = $+FU
					
					local x,y = ReturnTrigAngles(p.drawangle)
					
					local spawner = P_SpawnMobjFromMobj(car,-30*x,-30*y,0,MT_THOK)
					spawner.tics,spawner.fuse = 1,1
					P_SetOrigin(spawner,
						spawner.x+(15*cos(p.drawangle+ANGLE_90)),
						spawner.y+(15*sin(p.drawangle+ANGLE_90)),
						spawner.z
					)
					
					local spawner2 = P_SpawnMobjFromMobj(car,-30*x,-30*y,0,MT_THOK)
					spawner2.tics,spawner2.fuse = 1,1
					P_SetOrigin(spawner2,
						spawner2.x-(15*cos(p.drawangle+ANGLE_90)),
						spawner2.y-(15*sin(p.drawangle+ANGLE_90)),
						spawner2.z
					)
					
					for i = 0,1
						local spawn = spawner
						if i == 1 then spawn = spawner2 end
						
						local dust = TakisSpawnDust(spawn,
							car.angle+FixedAngle(P_RandomRange(-20,20)*FU+P_RandomFixed()),
							0,
							P_RandomRange(-1,2)*car.scale,
							{
								xspread = 0,
								yspread = 0,
								zspread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
								
								thrust = -P_RandomRange(1,6)*car.scale,
								thrustspread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
								
								momz = P_RandomRange(0,5)*me.scale*(TakisKart_DriftLevel(car.driftspark)/2),
								momzspread = P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1),
								
								scale = me.scale,
								scalespread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
								
								fuse = 23+P_RandomRange(-2,3),
							}
						)
						dust.color = TakisKart_DriftColor(TakisKart_DriftLevel(car.driftspark))
						dust.colorized = true
						
						if TakisKart_DriftLevel(car.driftspark) == 4
							local angle = car.angle+FixedAngle(P_RandomRange(-20,20)*FU+P_RandomFixed())
							local color = TakisKart_DriftColor(TakisKart_DriftLevel(car.driftspark))
							TakisKart_SpawnSpark(car,angle,color)					
						end
						
						if TakisKart_DriftLevel(car.driftspark) ~= car.olddlevel
							local level = TakisKart_DriftLevel(car.driftspark)
							
							for i = 10,P_RandomRange(15,20)
								local angle = car.angle+FixedAngle(P_RandomRange(-20,20)*FU+P_RandomFixed())
								local color = TakisKart_DriftColor(TakisKart_DriftLevel(car.driftspark))
								TakisKart_SpawnSpark(car,angle,color)					
							end
						end
						
						if car.driftbrake
							local angle = car.angle+FixedAngle(P_RandomRange(-20,20)*FU+P_RandomFixed())
							TakisKart_SpawnSpark(spawn,angle,SKINCOLOR_ORANGE,true)
						end
						
					end
					
					if TakisKart_DriftLevel(car.driftspark) ~= car.olddlevel
						local level = TakisKart_DriftLevel(car.driftspark)
						if level ~= 4
							if level == 3
								S_StartSound(car,sfx_cdfm40)
							elseif level == 2
								S_StartSound(car,sfx_s3ka2)
							end
						else
							S_StartSound(car,sfx_kc4d)
						end
						
						for i = 10,P_RandomRange(15,20)
							local angle = car.angle+FixedAngle(P_RandomRange(-20,20)*FU+P_RandomFixed())
							local color = TakisKart_DriftColor(TakisKart_DriftLevel(car.driftspark))
							TakisKart_SpawnSpark(car,angle,color)					
						end
					end
						
					--slow = FU*8/10
				end
				
			end
			car.momt = $+(car.drift*2*FU)
		else
			--keep our drift if we let go midair
			
			--if we let go grounded, then miniturbo
			if grounded
				if car.driftspark >= TakisKart_DriftSparkValue()
				and not car.driftbrake
					local driftboost = 0
					local drifttime = 0
					if car.driftspark >= TakisKart_DriftSparkValue()*4
						driftboost = 15*car.scale
						drifttime = 6*TR
					elseif car.driftspark >= TakisKart_DriftSparkValue()*2
						driftboost = 10*car.scale
						drifttime = 3*TR
					elseif car.driftspark >= TakisKart_DriftSparkValue()
						driftboost = 3*car.scale
						drifttime = TR*4/5
					end
					
					car.angle = $+driftval(p,car,car.momt/FU)+((ANGLE_45/9)*car.drift)
					P_Thrust(car,
						car.angle,
						driftboost
					)
					S_StartSound(car,sfx_zoom)
					if car.driftboost < drifttime+1
						car.driftboost = drifttime+1
					end 
					car.maxspeed = car.basemaxspeed*3/2
				end
				car.driftedout = false
				car.drifttime = 0
				car.drift = 0
				car.driftspark = 0
				car.driftbrake = 0
			end
		end
		
		if car.drift ~= 0
		and not S_SoundPlaying(car,sfx_kartdr)
		and grounded
			S_StartSound(car,sfx_kartdr)
		elseif car.drift == 0
		or not grounded
			S_StopSoundByID(car,sfx_kartdr)
		end
		
		return
	end
	
	local minspeed = 10*car.scale
	local dsone = TakisKart_DriftSparkValue()
	local dstwo = dsone*2
	local dsthree = dstwo*2
	local k_jump = cmd.buttons & BT_SPIN
	
	if car.drift ~= -5 and car.drift ~= 5
	and car.driftspark < dsone
	and grounded
		car.driftspark = 0
	elseif car.drift ~= -5 and car.drift ~= 5
	and car.driftspark >= dsone and car.driftspark < dstwo
	and grounded
		if drifttime < 20
			drifttime = 20
		end
		S_StartSound(car,sfx_s23c)
		car.driftspark = 0
	elseif car.drift ~= -5 and car.drift ~= 5
	and car.driftspark < dsthree
	and grounded
		if drifttime < 50
			drifttime = 50
		end
		S_StartSound(car,sfx_s23c)
		car.driftspark = 0
	elseif car.drift ~= -5 and car.drift ~= 5
	and car.driftspark >= dsthree
	and grounded
		if drifttime < 125
			drifttime = 125
		end
		S_StartSound(car,sfx_s23c)
		car.driftspark = 0
	end
	
	-- Drifting: left or right?
	if cmd.sidemove > 0
	and FixedHypot(car.momx,car.momy) > minspeed
	and k_jump
	and car.drift == 0
	and not (car.driftedout)
		--left
		car.drift = 1
		car.driftedout = false
	elseif cmd.sidemove < 0
	and FixedHypot(car.momx,car.momy) > minspeed
	and k_jump
	and car.drift == 0
	and not (car.driftedout)
		--right
		car.drift = -1
		car.driftedout = false
	elseif not k_jump
		if car.drift > 0
			car.drift = $-1
			car.driftedout = true
		elseif car.drift < 0
			car.drift = $+1
			car.driftedout = true
		else
			car.driftedout = false
		end
	end
	
	-- Incease/decrease the drift value to continue drifting in that direction
	if grounded
	and car.drift ~= 0
		local driftadd = 24
		
		if car.drift >= 1 --to left
			car.drift = $+1
			if car.drift > 5 then car.drift = 5 end
			
			--inward
			if cmd.sidemove > 0
				driftadd = $+abs(cmd.sidemove*16)/100
			end
			--outward
			if cmd.sidemove < 0
				driftadd = $-abs(cmd.sidemove*16)/75
			end
		elseif car.drift <= -1 --to right
			car.drift = $-1
			if car.drift < -5 then car.drift = -5 end
			
			--inward
			if cmd.sidemove < 0
				driftadd = $+abs(cmd.sidemove*16)/100
			end
			--outward
			if cmd.sidemove > 0
				driftadd = $-abs(cmd.sidemove*16)/75
			end
		end
		
		local dust = TakisSpawnDust(me,
			car.angle+FixedAngle(P_RandomRange(-20,20)*FU+P_RandomFixed()),
			0,
			P_RandomRange(-1,2)*car.scale,
			{
				xspread = 0,
				yspread = 0,
				zspread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
				
				thrust = -P_RandomRange(1,6)*car.scale,
				thrustspread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
				
				momz = P_RandomRange(0,5)*me.scale,
				momzspread = P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1),
				
				scale = me.scale,
				scalespread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
				
				fuse = 23+P_RandomRange(-2,3),
			}
		)
		dust.color = TakisKart_DriftColor(TakisKart_DriftLevel(car.driftspark))
		dust.colorized = true
		
		car.driftspark = $+driftadd
		car.driftedout = false
	end
	
	--stop drifting
	if car.inpain or FixedMul(car.momx,car.momy) < minspeed
		car.drift = 0
		car.driftspark = 0
		car.driftedout = true
	end
	
	if car.drift ~= 0
	and grounded
		if not (cmd.forwardmove > 0)
			car.driftbrake = $+1
			if not S_SoundPlaying(car,sfx_skid)
				S_StartSound(car,sfx_skid)
			end
		else
			if car.driftbrake then car.driftbrake = $-1 end
			S_StopSoundByID(car,sfx_skid)
		end
	end
	if car.driftbrake >= TR/2
		car.driftedout = true
		car.drift = 0
		car.driftspark = 0
	end
	
	if TakisKart_DriftLevel(car.driftspark) == 4
		local angle = car.angle+FixedAngle(P_RandomRange(-20,20)*FU+P_RandomFixed())
		local color = TakisKart_DriftColor(TakisKart_DriftLevel(car.driftspark))
		TakisKart_SpawnSpark(car,angle,color)					
	end
	
	if TakisKart_DriftLevel(car.driftspark) ~= car.olddlevel
		local level = TakisKart_DriftLevel(car.driftspark)
		if level ~= 4
			if level == 3
				S_StartSound(car,sfx_cdfm40)
			elseif level == 2
				S_StartSound(car,sfx_s3ka2)
			end
		else
			S_StartSound(car,sfx_kc4d)
		end
		
		for i = 10,P_RandomRange(15,20)
			local angle = car.angle+FixedAngle(P_RandomRange(-20,20)*FU+P_RandomFixed())
			local color = TakisKart_DriftColor(TakisKart_DriftLevel(car.driftspark))
			TakisKart_SpawnSpark(car,angle,color)					
		end
	end
	if car.driftbrake
		local angle = car.angle+FixedAngle(P_RandomRange(-20,20)*FU+P_RandomFixed())
		TakisKart_SpawnSpark(car,angle,SKINCOLOR_ORANGE,true)
	end
	
 	if car.drift ~= 0
	and grounded
		car.angle = $+driftval(p,car,car.momt/FU)
	end
end

addHook("MobjMoveCollide",function(car,mo)
	if mo.type == MT_PLAYER
	or (mo.flags & MF_SPRING)
		return false
	end
end,MT_TAKIS_KART_HELPER)

--bonk
addHook("MobjMoveBlocked",function(car,thing,line)
	if ((thing) and (thing.valid)) or ((line) and (line.valid))
		if FixedHypot(car.momx,car.momy) < 7*car.scale then return end
		
		local oldangle = car.angle
		if thing and thing.valid
			if thing.flags & MF_MONITOR
				return
			end
			
			car.angle = FixedAngle(AngleFixed($)+(180*FU))
			P_InstaThrust(car,car.angle,20*car.scale)
			car.angle = oldangle
			car.accel = $/5
		elseif line and line.valid
			--THANKS MARILYN FOR LETTIN ME STEAL THIS!!
			if abs(line.dx) > 0
                local myang = R_PointToAngle2(0, 0, car.momx, car.momy)
                local vertang = R_PointToAngle2(0, 0, 0, car.momz)
                local lineang = R_PointToAngle2(line.v1.x, line.v1.y, line.v2.x, line.v2.y)
                P_InstaThrust(car, myang + 2*(lineang - myang), FixedHypot(car.momx, car.momy)- car.friction)
            else
                car.momx = $*-1
            end			
			car.accel = $/5
		end
		
		SpawnBam(car)
		if not car.target.player.powers[pw_flashing]
			car.fuel = $-(5*FU)
			car.damagetic = TR
			car.driftspark = 0
		end
		S_StartSound(car,sfx_slam)
		P_MoveOrigin(car.target,car.x,car.y,car.z)
		
		return true
	end
end,MT_TAKIS_KART_HELPER)

local function carinit(car)
	--toggles takis specific stuff (like fuel)
	car.init = true
	car.takiscar = true
	car.inpain = false
	car.painangle = 0
	car.painspin = 0
	car.facingangle = 0
	car.fuel = $-(FixedDiv(100*FU,90*TR*FU))
	car.damagetic = 0
	car.oldangle = 0
	car.maxspeed = 45*car.scale
	car.drift = 0
	car.drifttime = 0
	car.driftspark = 0
	car.driftbrake = 0
	car.driftboost = 0
	car.driftangle = 0
	car.driftedout = false
	car.momt = 0
	car.turning = false
	car.accel = 0
	car.enginesound = 0
end

addHook("MobjThinker",function(car)
	if not (car and car.valid) then return end
	
	local p = car.target.player
	if not (p and p.valid) then return end
	local me = p.mo
	if not (me and me.valid) then return end
	local takis = p.takistable
	if not (me.health)
	or not P_IsValidSprite2(me,SPR2_KART)
	or (me.skin ~= TAKIS_SKIN and car.takiscar)
		TakisFancyExplode(
			car.x, car.y, car.z,
			P_RandomRange(60,64)*car.scale,
			32,
			MT_TAKIS_EXPLODE,
			15,20
		)
		P_KillMobj(car)
		P_MovePlayer(p)
		if p.powers[pw_carry] == CR_TAKISKART
			p.powers[pw_carry] = 0
		end
		me.tracer = nil
		return
	end
	
	if not car.init
		carinit(car)
	end
	
	me.tracer = car
	P_ResetPlayer(p)
	p.skidtime = 1
	p.pflags = $|PF_JUMPSTASIS
	p.inkart = 2
	p.powers[pw_carry] = CR_TAKISKART
	p.kartingtime = $+1 or 0
	
	local dist = 60
	local x,y = me.x,me.y
	
	--takis.lastpos is {x=me.x,y=me.y,z=me.z} in a PostThink, where "me" is p.realmo
	if x+dist*me.scale < takis.lastpos.x
	or x-dist*me.scale > takis.lastpos.x
	or y+dist*me.scale < takis.lastpos.y
	or y-dist*me.scale > takis.lastpos.y
		P_MoveOrigin(car,x,y,me.z)
	end
	
	if car.damagetic then car.damagetic = $-1 end
	car.flags2 = $|MF2_DONTDRAW
	local cmd = p.cmd
	local grounded = P_IsObjectOnGround(car)
	
	car.radius,car.height = me.radius,me.height
	me.momx,me.momy,me.momz = car.momx,car.momy,car.momz
	
	car.basemaxspeed = 45*me.scale
	local basemaxspeed = car.basemaxspeed
	local maxspeed = car.maxspeed
	local accel = p.accelstart + (FixedDiv(FixedHypot(car.momx,car.momy),car.scale)>>FRACBITS)*p.acceleration
	local slow = FU
	accel = $*10
	
	if car.accel ~= 0
	and car.accel < -accel*2
	--and FixedHypot(car.momx,car.momy) <= 5*car.scale
		maxspeed = car.maxspeed/2
	end
	
	if car.fuel <= 25*FU
	and car.takiscar
		if not (leveltime % TR)
			S_StartSoundAtVolume(car,sfx_kartlf,255/2,p)
		end
	end
	
	--turning
	--angle diff between old and new angs should be 2-3
	if car.inpain
		car.drift = 0
		car.driftedout = true
		car.driftspark = 0
		car.driftboost = 0
		cmd.sidemove,cmd.forwardmove = 0,0
		local speed = FixedDiv(FixedHypot(FixedHypot(car.momx,car.momy),car.momz),car.scale)
		car.painspin = $+speed
	end
	
	if cmd.sidemove
		local turndir = -(cmd.sidemove > 0 and 1 or -1)
		local driftdir = ((car.drift > 0) and 1 or -1)
		
		--start a drift
		if (cmd.buttons & BT_SPIN)
		and not (car.driftedout)
		and (FixedHypot(car.momx,car.momy) >= 10*car.scale)
		and car.drift == 0
		and grounded
			car.drift = $+turndir
			car.driftangle = car.angle
		end
		
		if (FixedHypot(car.momx,car.momy) >= car.scale/2)
			if car.drift ~= 0
			and grounded
				--if we're drifting, then countersteer a bit
				if turndir ~= driftdir
					car.momt = -4*FU*driftdir
					car.driftspark = $-(FU/2)
				else
					if turndir == driftdir
					and car.maxspeed > 15*car.scale
						car.maxspeed = $*198/201
					end
					car.momt = 40*FU*turndir
					car.driftspark = $+(FU/2)
				end
			else
				car.momt = 40*FU*turndir
			end
		end
		car.turning = true
	else
		if car.drift ~= 0
			if car.maxspeed < basemaxspeed
				car.maxspeed = $*203/198
			elseif car.maxspeed > basemaxspeed
				car.maxspeed = basemaxspeed
			end
		end
		car.turning = false
	end
	
	driftstuff(p,car)
	car.momt = $*3/5
	car.angle = $+FixedAngle(car.momt/9)
	--
	
	--move
	if p.powers[pw_sneakers]
		car.basemaxspeed = $*3/2
		--accel = $*3/2
	end
	if car.driftboost 
		car.basemaxspeed = $*3/2
		--accel = $*2
		TakisDoWindLines(me)
		car.driftboost = $-1
	end
	
	if car.drift == 0
		if car.maxspeed < car.basemaxspeed
			car.maxspeed = $*202/198
		elseif maxspeed > car.basemaxspeed
			car.maxspeed = car.basemaxspeed --$*198/200
		end
	end
	
	if cmd.forwardmove
	and grounded		
		local acceldir = (cmd.forwardmove > 0) and 1 or -1
		if acceldir == 1
			if car.accel < 0
				local ab = (car.accel > 0) and 1 or -1
				car.accel = (abs($)*4/5)*ab
			end
			if car.accel+accel < maxspeed/8
				car.accel = $+accel
			end
		else
			if car.accel > 0
				car.accel = $*4/5
			end
			if car.accel-accel > -maxspeed/8
				car.accel = $-accel
			end
		end
	else
		local ab = (car.accel > 0) and 1 or -1
		car.accel = (abs($)*4/5)*ab
	end
	
	car.oldspeed = R_PointToDist2(car.momx - p.cmomx,car.momy - p.cmomy,0,0)
	local thrustangle = car.angle
	if car.drift ~= 0
	and grounded
		thrustangle = car.angle-((ANGLE_45/9)*car.drift)
	end
	
	local movethrust = FixedMul(FixedMul(car.friction,car.movefactor), car.accel)
	P_Thrust(car, thrustangle, movethrust)
	
	if grounded
	and (FixedHypot(car.momx,car.momy) >= 50*car.scale
	or car.drift ~= 0)
		for i = 0,1
			local momx,momy = 0,0
			if i == 1
				momx,momy = car.momx/2,car.momy/2
			end
			
			local track = P_SpawnMobjFromMobj(car,momx,momy,0,MT_THOK)
			track.lifetime = 5*TR
			track.sprite = SPR_WDRG
			track.frame = F
			track.tics,track.fuse = track.lifetime,track.lifetime
			track.renderflags = RF_OBJECTSLOPESPLAT|RF_NOSPLATBILLBOARD|RF_FLOORSPRITE
			track.angle = thrustangle
		end
	end
	
	/*
		car.momx = $+P_ReturnThrustX(nil,thrustangle,car.accel)
		car.momy = $+P_ReturnThrustY(nil,thrustangle,car.accel)
	*/
	car.momx,car.momy = FixedMul($1,slow),FixedMul($2,slow)
	
	movementstuff(p,car,maxspeed,car.oldspeed)
	
	P_ButteredSlope(car)
	P_ButteredSlope(car)
	--
	
	--jump
	if (cmd.buttons & BT_JUMP)
	and not (p.lastbuttons & BT_JUMP)
	and grounded
	and car.drift == 0
	and not car.inpain
		P_SetObjectMomZ(car,10*car.scale)
		S_StartSound(car,sfx_ngjump)
	end
	--
	
	local flashingtics = flashingtics/2
	if not grounded
		if car.takiscar
			car.momz = $+(P_GetMobjGravity(car)*3/5*P_MobjFlip(car))
		end
		if car.inpain
			car.momz = $+(P_GetMobjGravity(car)*2/5*P_MobjFlip(car))
			if takis.fakeflashing < flashingtics-2
				takis.fakeflashing = flashingtics
			end
		end
	else
		if car.inpain
			if car.oldmomz ~= nil
			and car.oldmomz <= -5*car.scale
				P_SetObjectMomZ(car,-FixedDiv(car.oldmomz,car.scale)/2)
				SpawnBam(car)
				S_StartSound(car,sfx_slam)
			else
				car.painspin = $*4/5
				if p.powers[pw_flashing] == 1
					car.inpain = false
				end
			end
		end
	end
	
	local heightdisp = car.z-me.z
	animhandle(p,car)
	soundhandle(p,car)
	
	--set the stuff for the player
	local diff = car.oldangle-car.angle
	me.angle = car.angle
	--look behind
	if p.cmd.buttons & BT_CUSTOM3
		me.angle = $-ANGLE_180
	end
	--KILL the car
	if (p.cmd.buttons & BT_CUSTOM2 and not car.inpain)
	or (car.fuel <= 0 and car.takiscar)
		p.inkart = 0
		TakisFancyExplode(
			car.x, car.y, car.z,
			P_RandomRange(60,64)*car.scale,
			32,
			MT_TAKIS_EXPLODE,
			15,20
		)
		P_MovePlayer(p)
		P_DoPlayerPain(p,car,car)
		P_SetObjectMomZ(me,15*me.scale)
		P_Thrust(me,car.angle,20*car.scale)
		P_KillMobj(car)
		P_MovePlayer(p)
		if p.powers[pw_carry] == CR_TAKISKART
			p.powers[pw_carry] = 0
		end
		p.powers[pw_nocontrol] = 5
		takis.HUD.lives.tweentic = 5*TR
		me.tracer = nil
		return
	end
	P_MoveOrigin(me,
		car.x+car.momx,
		car.y+car.momy,
		car.z+car.momz
	)
	if not car.inpain
		if (car.drift ~= 0)
			p.drawangle = car.angle-diff
		else
			local sign = 1
			if car.drift < 0
				sign = -1
			end
			local drift = car.drift*sign
			
			if drift >= 3
				p.drawangle = car.angle-diff-(car.momt*20)
			else
				p.drawangle = car.angle-diff
			end
		end
	else
		p.drawangle = car.painangle+FixedAngle(car.painspin)
	end
	/*
	if car.drift ~= 0
		local diff = car.angle-car.driftangle
		p.drawangle = car.angle+diff
	end
	*/
	car.oldangle = car.angle
	car.olddlevel = TakisKart_DriftLevel(car.driftspark)
	car.oldmomz = car.momz
	if car.standingslope
		me.z = P_GetZAt(car.standingslope,me.x,me.y)
	end
	--
	
end,MT_TAKIS_KART_HELPER)

addHook("MobjDeath",function(car)
	local sfx = P_SpawnMobjFromMobj(car,0,0,0,MT_THOK)
	sfx.flags2 = $|MF2_DONTDRAW
	sfx.fuse,sfx.tics = TR,TR
	S_StartSound(sfx,sfx_tkapow)
	for i = 0,16
		A_BossScream(sfx,1,MT_SONIC3KBOSSEXPLODE)
	end
end,MT_TAKIS_KART_HELPER)

filesdone = $+1