--mariokart????????????
/*
	-teleporters dont tp the kart, snaps the player back
	-springs unsuable
	-solids passable
	-joystick support
	
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
		if turn > 0
			frame = E
		elseif turn < 0
			frame = C
		end
	end
	
	if car.drift
	and P_IsObjectOnGround(car)
		local frametic = car.drifttime % 2 == 1
		local driftdir = ((car.drift > 0) and 1 or -1)
		
		if driftdir > 0
			frame = G --((rumble) and frametic) and G or I
		else
			frame = I
		end
		
		if not frametic
			frame = $+1
		end
		
		dontrumble = true
	end
	
	if P_PlayerInPain(p)
	or car.inpain
		frame = K
		dontrumble = true
	end
	
	if not dontrumble
		if speed < car.scale
			frame = (rumble) and $+1 or $
		elseif speed > car.scale
		and speed < 20*car.scale
			me.spriteyoffset = ((rumble) and FU or 0)
		end
	end
	
	me.frame = ($ &~FF_FRAMEMASK)|frame
	
	
end

addHook("PlayerSpawn",function(p)
	if p.spectator then return end
	if skins[p.skin].name ~= TAKIS_SKIN then return end
	local x,y = ReturnTrigAngles(p.mo.angle)
	local car = P_SpawnMobjFromMobj(p.mo,-100*x,-100*y,0,MT_TAKIS_KART)
	car.angle = p.mo.angle
end)

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
	local speed = R_PointToDist2(car.momx - p.cmomx,car.momy - p.cmomy,0,0)
	if speed > maxspeed
		local tmomx,tmomy
		if oldspeed > maxspeed
			if (speed > oldspeed)
				tmomx = FixedMul(FixedDiv(car.momx - p.cmomx, speed), oldspeed)
				tmomy = FixedMul(FixedDiv(car.momy - p.cmomy, speed), oldspeed)
				car.momx = tmomx
				car.momy = tmomy
			end
		else
			tmomx = FixedMul(FixedDiv(car.momx - p.cmomx, speed), maxspeed)
			tmomy = FixedMul(FixedDiv(car.momy - p.cmomy, speed), maxspeed)
			car.momx = tmomx
			car.momy = tmomy
		end
	end
	
end

/*
addHook("MobjCollide",function(car,tm)
	if not (car and car.valid) then return end
	if not (tm and tm.valid) then return end
	
	if (tm.player and tm.player.valid)
	and (tm == car.target)
		print("ASD")
		return false
	end
	
end,MT_TAKIS_KART_HELPER)
*/

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

addHook("MobjThinker",function(car)
	if not (car and car.valid) then return end
	
	local p = car.target.player
	if not (p and p.valid) then return end
	local me = p.mo
	if not (me and me.valid) then return end
	local takis = p.takistable
	if not (me.health)
	or not P_IsValidSprite2(me,SPR2_KART)
	or (me.skin ~= TAKIS_SKIN)
		P_KillMobj(car)
		P_MovePlayer(p)
		if p.powers[pw_carry] == CR_TAKISKART
			p.powers[pw_carry] = 0
		end
		me.tracer = nil
		return
	end
	
	me.tracer = car
	P_ResetPlayer(p)
	p.skidtime = 1
	p.pflags = $|PF_JUMPSTASIS
	p.inkart = 2
	p.powers[pw_carry] = CR_TAKISKART
	p.kartingtime = $+1 or 0
	
	local dist = 50
	local x,y = me.x,me.y
	/*
	print("pos:",
		"	x:",
		"\x83"..L_FixedDecimal(takis.lastpos.x,3),
		L_FixedDecimal(x+dist*me.scale,3),
		L_FixedDecimal(x,3),
		L_FixedDecimal(x-dist*me.scale,3),
		(x+dist*me.scale < takis.lastpos.x),
		(me.x-dist*me.scale > takis.lastpos.x)
		
	)
	*/
	
	if x+dist*me.scale < takis.lastpos.x
	or x-dist*me.scale > takis.lastpos.x
	or y+dist*me.scale < takis.lastpos.y
	or y-dist*me.scale > takis.lastpos.y
	--or z+dist*me.scale < takis.lastpos.z
	--or z-dist*me.scale > takis.lastpos.z
		P_MoveOrigin(car,x,y,me.z)
	end
	
	car.inpain = $ or false
	car.painangle = $ or 0
	car.painspin = $ or 0
	car.facingangle = $ or 0
	car.fuel = $-(FixedDiv(100*FU,90*TR*FU))
	car.damagetic = $ or 0
	if car.damagetic then car.damagetic = $-1 end
	car.oldangle = $ or 0
	car.flags2 = $|MF2_DONTDRAW
	local cmd = p.cmd
	local grounded = P_IsObjectOnGround(car)
	
	car.radius,car.height = me.radius,me.height
	me.momx,me.momy,me.momz = car.momx,car.momy,car.momz
	
	car.maxspeed = $ or 45*car.scale
	local maxspeed = car.maxspeed
	local accel = p.accelstart + (FixedDiv(FixedHypot(car.momx,car.momy),car.scale)>>FRACBITS)*p.acceleration
	local slow = FU
	accel = $*10
	if car.accel
	and car.accel < -accel*2
	and FixedHypot(car.momx,car.momy) <= 5*car.scale
		maxspeed = car.maxspeed/2
	end
	if car.fuel <= 25*FU
		if not (leveltime % TR)
			S_StartSoundAtVolume(car,sfx_kartlf,255/2,p)
		end
	end
	
	--turning
	--angle diff between old and new angs should be 2-3
	car.drift = $ or 0
	car.drifttime = $ or 0
	car.driftspark = $ or 0
	car.driftbrake = $ or 0
	car.driftboost = $ or 0
	car.driftangle = $ or 0
	car.driftedout = $ or false
	car.momt = $ or 0
	car.turning = $ or false
	
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
			--if we're drifting, then countersteer a bit
			if car.drift ~= 0
			and grounded
				if turndir ~= driftdir
					car.momt = -4*FU*driftdir
					car.driftspark = $-(FU/2)
				else
					car.momt = 40*FU*turndir
					car.driftspark = $+(FU/2)
				end
			else
				car.momt = 40*FU*turndir
			end
		end
		car.turning = true
	else
		car.turning = false
	end
	
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
				if car.driftbrake then car.driftbrake = $-1 end
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
			
			if not stop
				car.drifttime = $+1
				car.driftspark = $+FU
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
					
				--slow = FU*8/10
			end
		end
		car.momt = $+(car.drift*2*FU)
	else
		--keep our drift if we let go midair
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
				car.driftboost = drifttime+1
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
	
	if car.drift ~= 0
	and grounded
		car.angle = $+driftval(p,car,car.momt/FU)
	end
	car.momt = $*3/5
	car.angle = $+FixedAngle(car.momt/9)
	--
	
	--move
	car.accel = $ or 0
	if car.drift
		if car.maxspeed > 30*car.scale
			car.maxspeed = 30*car.scale
		end
		if car.maxspeed > 45*car.scale/3
			car.maxspeed = $*199/200
		end
		maxspeed = car.maxspeed
	else
		if car.maxspeed < 45*car.scale
			car.maxspeed = $*21/20
		end
	end
	if p.powers[pw_sneakers]
		maxspeed = $*3/2
		accel = $*3/2
	end
	if car.driftboost 
		maxspeed = $*3/2
		accel = $*2
		TakisDoWindLines(me)
		car.driftboost = $-1
	end
		
	if cmd.forwardmove
	and grounded		
		local acceldir = (cmd.forwardmove > 0) and 1 or -1
		if acceldir == 1
			if car.accel < 0
				local ab = (car.accel > 0) and 1 or -1
				car.accel = (abs($)*4/5)*ab
			end
			if car.accel+accel < maxspeed
				car.accel = $+accel
			end
		else
			if car.accel > 0
				car.accel = $*4/5
			end
			if car.accel-accel > -maxspeed
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
		thrustangle = $+((ANGLE_45/9)*car.drift)
	end
	car.momx = $+P_ReturnThrustX(nil,thrustangle,car.accel)
	car.momy = $+P_ReturnThrustY(nil,thrustangle,car.accel)
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
		car.momz = $+(P_GetMobjGravity(car)*3/5*P_MobjFlip(car))
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
	
	--set the stuff for the player
	local diff = car.oldangle-car.angle
	me.angle = car.angle
	--look behind
	if p.cmd.buttons & BT_CUSTOM3
		me.angle = $-ANGLE_180
	end
	--KILL the car
	if (p.cmd.buttons & BT_CUSTOM2 and not car.inpain)
	or (car.fuel <= 0)
		p.inkart = 0
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
		p.drawangle = car.angle-diff
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