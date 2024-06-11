--mariokart????????????
/*
	-[done]teleporters dont tp the kart, snaps the player back
	-[done]springs unsuable
	-[done]solids passable
	-[done]joystick support
	-clean up code and make it easier to port (seperate taksi stuff)
	-[done]make drift more accurate
	-wind sectors affect karts
	-dont use so many effects when drifting
	-waterslide affect karts
	
*/

local CMD_DEADZONE = 14
local STATS = {9,4} --speed,weight
local spaceaccel = true

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

local CS_VERT = (1<<0)
local CS_ACCEL = (1<<1)
local CS_ACCELNOABS = (1<<2)

local function GetCarSpeed(car,flags)
	flags = $ or 0
	local speed = FixedDiv(FixedHypot(car.momx,car.momy),car.scale)
	
	if (flags & CS_VERT)
		speed = FixedDiv(FixedHypot(FixedHypot(car.momx,car.momy),car.momz),car.scale)
	end
	if (flags & CS_ACCEL)
		if flags & CS_ACCELNOABS
			speed = car.accel*8
		else
			speed = abs(car.accel*8)
		end
	end
	
	return speed
end

local function lookatpeople(p,car)
	local me = p.mo
	local takis = p.takistable
	
	local maxdist = 1280*car.scale
	local blindspot = 10*FU
	local glancedir = 0
	local lastvalidglance
	
	for player in players.iterate
		local back,diff,distance
		local dir = -1
		
		if player ~= nil
			local victim = player.mo
			
			--why are you glancing at yourself
			if player == p
				continue
			end
			
			if player.spectator
				continue
			end
			
			distance = R_PointToDist2(car.x, car.y, victim.x, victim.y)
			distance = R_PointToDist2(0, car.z, distance, victim.z)
			if distance > maxdist
				continue
			end
			
			--this sucks!!!
			back = FixedAngle(AngleFixed(car.angle)+180*FU)
			diff = FixedAngle(AngleFixed(R_PointToAngle2(car.x, car.y, victim.x, victim.y))-AngleFixed(back))
			if AngleFixed(diff) > 180*FU
				diff = InvAngle(diff)
				dir = -$
			end
			
			--not behind
			if AngleFixed(diff) > 90*FU
				continue
			end
			
			if AngleFixed(diff) < blindspot
				continue
			end
			
			if not P_CheckSight(car,victim)
				continue
			end
			
			glancedir = $+dir
			lastvalidglance = dir
			
			--horn
			
		end
	end
	
	if glancedir > 0
		return 1
	elseif glancedir < 0
		return -1
	end
	return lastvalidglance
	
end

local function animhandle(p,car)
	local me = p.mo
	if me.state ~= S_PLAY_TAKIS_KART
		me.state = S_PLAY_TAKIS_KART
	end
	if me.sprite2 ~= SPR2_KART
		me.sprite2 = SPR2_KART
	end
	local speed = GetCarSpeed(car)
	local rumble = leveltime % 2 == 0
	local frame = A
	local dontrumble = false
	local takis = p.takistable
	
	if car.turning
		local turn = p.cmd.sidemove
		if abs(p.cmd.sidemove) < CMD_DEADZONE
			turn = 0
		end
		
		--left
		if turn > 0
			frame = G
		--right
		elseif turn < 0
			frame = D
		end
	end
	
	if takis.c3
	or (car.moving < -5 or car.reversing)
		frame = R
	end
	
	if abs(p.cmd.sidemove) < CMD_DEADZONE
	and car.drift == 0
	and P_IsObjectOnGround(car)
		local destglance = lookatpeople(p,car)
		if destglance == 1
			frame = O
		elseif destglance == -1
			frame = R
		end
	end
	
	if car.drift
		local frametic = car.drifttime % 2 == 1
		local driftdir = ((car.drift > 0) and 1 or -1)
		
		if driftdir > 0
			frame = K
		else
			frame = M
		end
		
		if not frametic
		and P_IsObjectOnGround(car)
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
		if speed < FU
			frame = (rumble) and $+1 or $
		elseif speed > FU
			if speed < 20*FU
				me.spriteyoffset = ((rumble) and FU or 0)
			end
			--spinning wheels
			frame = $+(rumble and 2 or 0)
		end
	end
	
	if GetCarSpeed(car)/FU ~= 0
	and car.offroad
		me.spriteyoffset = $+((rumble) and FU or 0)
	end
	
	me.frame = ($ &~FF_FRAMEMASK)|frame
	
	
end

local function soundhandle(p,car)
	
	local numsounds = 13
	
	local closedist = 160*FU
	local fardist = 1536*FU
	
	local dampenval = 48
	
	local class,s,w = 0,0,0
	
	local volume = 255
	local voldamp = FU
	
	local targetsnd = 0
	
	local kartspeed = STATS[1]
	local kartweight = STATS[2]
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
	
	local cmdmove = (6*car.moving)/25	
	local speedthing = GetCarSpeed(car)/FU/20
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
	kart.fuel = car.fuel or 100*FU
	touch.player.inkart = 2
end,MT_TAKIS_KART)

-- countersteer is how strong the controls are telling us we are turning
-- turndir is the direction the controls are telling us to turn, -1 if turning right and 1 if turning left
local function driftval(p,car, countersteer)
	local basedrift
	local driftangle
	local driftweight = STATS[2]*14;

	-- If they aren't drifting or on the ground this doesn't apply
	if (car.drift == 0 or not P_IsObjectOnGround(car))
		return 0
	end
	
	/*
	if (player.kartstuff[k_driftend] != 0)
		return -266*car.drift; // Drift has ended and we are tweaking their angle back a bit
	end
	*/
	
	local style = 2 --1 for kart, 2 for drrr
	
	if style == 1
		--basedrift = 90*player.kartstuff[k_drift]; // 450
		--basedrift = 93*player.kartstuff[k_drift] - driftweight*3*player.kartstuff[k_drift]/10; // 447 - 303
		basedrift = 83*car.drift - (driftweight - 14)*car.drift/5; // 415 - 303
		driftangle = abs((252 - driftweight)*car.drift/5);
		return basedrift + FixedMul(driftangle, countersteer);
	elseif style == 2
		basedrift = (83 * car.drift) - (((driftweight - 14) * car.drift) / 5)
		local driftadjust = abs((252 - driftweight) * car.drift / 5)
		return basedrift + FixedMul(driftadjust, countersteer)
	end
	
end

local function brakegfx(p,car)
	local me = p.mo
	local takis = p.takistable
	
	local momang = TakisMomAngle(car)+ANGLE_180
	local x,y = ReturnTrigAngles(momang)
	
	local spawner = P_SpawnMobjFromMobj(car,30*x,30*y,0,MT_THOK)
	spawner.tics,spawner.fuse = 1,1
	P_SetOrigin(spawner,
		spawner.x+FixedMul(15*car.scale,cos(momang+ANGLE_90)),
		spawner.y+FixedMul(15*car.scale,sin(momang+ANGLE_90)),
		spawner.z
	)
	spawner.scale = car.scale
	
	local spawner2 = P_SpawnMobjFromMobj(car,30*x,30*y,0,MT_THOK)
	spawner2.tics,spawner2.fuse = 1,1
	P_SetOrigin(spawner2,
		spawner2.x-FixedMul(15*car.scale,cos(momang+ANGLE_90)),
		spawner2.y-FixedMul(15*car.scale,sin(momang+ANGLE_90)),
		spawner2.z
	)
	spawner2.scale = car.scale
	
	for i = 0,1
		
		local spawn = spawner
		if i == 1 then spawn = spawner2 end
		
		local angle = momang+FixedAngle(P_RandomRange(-20,20)*FU+P_RandomFixed())
		TakisKart_SpawnSpark(car,angle,SKINCOLOR_ORANGE,true)					
		
	end
end

local function driftstuff(p,car)
	local cmd = p.cmd
	local me = p.mo
	local takis = p.takistable
	local grounded = P_IsObjectOnGround(car)

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
			
			/*
			if not (car.moving > 0)
			or car.reversing
				car.driftbrake = $+1
				if not S_SoundPlaying(car,sfx_skid)
					S_StartSound(car,sfx_skid)
				end
			else
				car.driftbrake = 0
				S_StopSoundByID(car,sfx_skid)
			end
			*/
			
			if GetCarSpeed(car) < FU
			or GetCarSpeed(car,CS_ACCELNOABS) <= -2*FU
				car.driftbrake = TR
			elseif GetCarSpeed(car) < 10*FU
				car.driftspark = $*9/10
			end
			
			if car.driftbrake >= TR/2
				car.driftedout = true
				car.drift = 0
				car.driftspark = 0
				stop = true
			end
			
			--effects and whatnot
			if not stop
				
				takis.tiltdo = true
				local sidemove = car.momt*24
				local movespeed = min(FixedDiv(takis.accspeed,22*FU),FU)
				takis.tiltvalue = $+FixedMul(sidemove,movespeed)
				
				car.drifttime = $+1
				if not (car.offroad)
				and (GetCarSpeed(car) >= 10*FU)
					car.driftspark = $+24
				end
				
				local turndir = -(cmd.sidemove >= 0 and 1 or -1)
				local driftdir = ((car.drift > 0) and 1 or -1)
		
				--gain back some lost speed, but not when youre
				--countersteering
				if car.maxspeed < car.basemaxspeed
				and (turndir == driftdir)
					if GetCarSpeed(car) >= car.maxspeed+5*FU
						car.maxspeed = GetCarSpeed(car)
					elseif GetCarSpeed(car) >= car.maxspeed
						car.maxspeed = $+(FU/255)
					end
					
				end
				
				local diff = car.oldangle-car.angle
				local sign = 1
				if car.drift < 0
					sign = -1
				end
				local drift = car.drift*sign
				
				if abs(car.drift) >= 3
					p.drawangle = car.angle-diff-(car.momt*24)
				else
					p.drawangle = car.angle-diff
				end
				local momang = TakisMomAngle(car)
				local x,y = ReturnTrigAngles(momang)
				
				local spawner = P_SpawnMobjFromMobj(car,-30*x,-30*y,0,MT_THOK)
				spawner.tics,spawner.fuse = 1,1
				P_SetOrigin(spawner,
					spawner.x+FixedMul(15*car.scale,cos(momang+ANGLE_90)),
					spawner.y+FixedMul(15*car.scale,sin(momang+ANGLE_90)),
					spawner.z
				)
				
				local spawner2 = P_SpawnMobjFromMobj(car,-30*x,-30*y,0,MT_THOK)
				spawner2.tics,spawner2.fuse = 1,1
				P_SetOrigin(spawner2,
					spawner2.x-FixedMul(15*car.scale,cos(momang+ANGLE_90)),
					spawner2.y-FixedMul(15*car.scale,sin(momang+ANGLE_90)),
					spawner2.z
				)
				
				for i = 0,1
					if TAKIS_NET.noeffects
					and i
					and false
						break
					end
					
					local spawn = spawner
					if i == 1 then spawn = spawner2 end
					
					/*
					local dust = TakisSpawnDust(spawn,
						momang+FixedAngle(P_RandomRange(-20,20)*FU+P_RandomFixed()),
						0,
						P_RandomRange(-1,2)*car.scale,
						{
							xspread = 0,
							yspread = 0,
							zspread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
							
							thrust = -P_RandomRange(1,6)*car.scale,
							thrustspread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
							
							momz = P_RandomRange(0,5)*me.scale*(TakisKart_DriftLevel(STATS,car.driftspark)),
							momzspread = P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1),
							
							scale = me.scale,
							scalespread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
							
							fuse = 23+P_RandomRange(-2,3),
						}
					)
					dust.color = TakisKart_DriftColor(TakisKart_DriftLevel(STATS,car.driftspark))
					dust.colorized = true
					dust.tracer = me
					*/
					
					if TakisKart_DriftLevel(STATS,car.driftspark) == 4
						local angle = momang+FixedAngle(P_RandomRange(-20,20)*FU+P_RandomFixed())
						local color = TakisKart_DriftColor(level)
						TakisKart_SpawnSpark(car,angle,color)					
					end
					
					if TakisKart_DriftLevel(STATS,car.driftspark) ~= car.olddlevel
					or P_RandomChance(FU/10)
						local level = TakisKart_DriftLevel(STATS,car.driftspark)
						
						for i = 10,P_RandomRange(15,20)
							local angle = momang+FixedAngle(P_RandomRange(-20,20)*FU+P_RandomFixed())
							local color = TakisKart_DriftColor(level)
							TakisKart_SpawnSpark(car,angle,color)					
						end
					end
					
					if car.driftbrake
						local angle = momang+FixedAngle(P_RandomRange(-20,20)*FU+P_RandomFixed())
						TakisKart_SpawnSpark(spawn,angle,SKINCOLOR_ORANGE,true)
					end
					
				end
				
				if TakisKart_DriftLevel(STATS,car.driftspark) ~= car.olddlevel
					local level = TakisKart_DriftLevel(STATS,car.driftspark)
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
						local angle = momang+FixedAngle(P_RandomRange(-20,20)*FU+P_RandomFixed())
						local color = TakisKart_DriftColor(TakisKart_DriftLevel(STATS,car.driftspark))
						TakisKart_SpawnSpark(car,angle,color)					
					end
				end
					
				--slow = FU*8/10
			end
			
		end
		if P_IsObjectOnGround(car)
			car.momt = $+(car.drift*2*FU)
		end
	else
		--keep our drift if we let go midair
		
		--if we let go grounded, then miniturbo
		--if grounded
		if car.driftspark >= TakisKart_DriftSparkValue(STATS)
		and not car.driftbrake
			local driftboost = 0
			local drifttime = 0
			if car.driftspark >= TakisKart_DriftSparkValue(STATS)*4
				driftboost = 15*car.scale
				drifttime = 6*TR
			elseif car.driftspark >= TakisKart_DriftSparkValue(STATS)*2
				driftboost = 10*car.scale
				drifttime = 3*TR
			elseif car.driftspark >= TakisKart_DriftSparkValue(STATS)
				driftboost = 3*car.scale
				drifttime = TR*4/5
			end
			
			car.driftdiff = car.angle
			car.angle = $-(driftval(p,car,car.momt/FU)+((ANGLE_45/9)*car.drift))*14/10
			car.driftdiff = FixedAngle(AngleFixed(car.angle) - AngleFixed($))
			if AngleFixed(car.driftdiff) > 180*FU
				car.driftdiff = InvAngle($)
			end
			
			P_Thrust(car,
				car.angle,
				driftboost
			)
			if not grounded
				P_SetObjectMomZ(car,-GetCarSpeed(car)/2,true)
			end
			
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
		--end
	end
	
	if car.drift ~= 0
	and not S_SoundPlaying(car,sfx_kartdr)
		S_StartSound(car,sfx_kartdr)
	elseif car.drift == 0
		S_StopSoundByID(car,sfx_kartdr)
	end

end

local extrastuff = true
addHook("ThinkFrame",do
	if not circuitmap
		extrastuff = mapheaderinfo[gamemap].forcekartextra ~= nil
	else
		extrastuff = true
	end
end)

local function InSectorSpecial(mo, grounded, section, special)
	local fofsector = P_ThingOnSpecial3DFloor(mo)
	-- You can be inside a FoF without being grounded
	if fofsector then
		--print("fofsector "..(fofsector and "yes" or "no"))
		if GetSecSpecial(fofsector.special,section) == special then
			--print("has special "..section.." "..special)
			return fofsector
		end
	end
	if GetSecSpecial(mo.subsector.sector.special, section) == special then
		if not grounded then
			return mo.subsector.sector
		elseif grounded and P_IsObjectOnGround(mo) then
			local flipped = P_MobjFlip(mo) == -1
			local slope = flipped and mo.subsector.sector.c_slope or mo.subsector.sector.f_slope -- no FoF
			local savedz = mo.z
			mo.z = mo.z -- update flooz/ceilingz, since they won't match properly for this tic yet
			local savedplanez = flipped and mo.ceilingz or mo.floorz -- current position floorz/ceilingz
			mo.flags = $|MF_NOCLIPHEIGHT -- we need to noclip it to make sure a bordering sector/fof doesnt mess with the floorz/ceilingz checking
			mo.z = slope and P_GetZAt(slope, mo.x, mo.y) or flipped and mo.subsector.sector.ceilingheight or mo.subsector.sector.floorheight -- sets floorz and ceilingz using hardcode functions we can't access from here
			local notonfof = savedplanez == (flipped and mo.ceilingz or mo.floorz) -- if our actual z is the same as the calculated floorz/ceilingz for this sector's slope, we aren't on a FoF
			mo.flags = $ & ~MF_NOCLIPHEIGHT
			mo.z = savedz
			return notonfof and mo.subsector.sector or nil
		end
	end
	return nil
/*
	if leveltime
		return P_MobjTouchingSectorSpecial(mo,section,special)
	end
	
	if sector then
		print("sector "..(sector and "yes" or "no"))
		print("has special "..section.." "..special)
		if P_IsObjectOnGround(mo) then
			print("grounded pass")
			return sector
		end
	end
	
	return nil
*/
end

local function offroadcollide(p,car)
	local me = p.mo
	local takis = p.takistable
	
	if not (me and me.valid)
		return 0
	end
	local kartstuff = false
	if (extrastuff)
		kartstuff = true
	end
	if not kartstuff
		return (P_InQuicksand(car) or P_InQuicksand(me)) and 5 or 0
	elseif kartstuff
		local val = 0
		--check weak offroad
		if InSectorSpecial(me,true,1,2)
			val = 3
		--reg offroad
		elseif InSectorSpecial(me,true,1,3)
			val = 4
		--strong offroad
		elseif InSectorSpecial(me,true,1,4)
			val = 5
		end
		return val
	end
end

local function updateoffroad(p,car)
	local me = p.mo
	local takis = p.takistable
	
	local offroad = 0
	local strength = offroadcollide(p,car)
	
	if car.nooffroad
		strength = 0
	end
	
	if strength
		if car.offroad == 0
			car.offroad = TR/2
		end
		if car.offroad > 0
			offroad = (strength << FRACBITS) / (TR/2)
			car.offroad = $+offroad
		end
		if car.offroad > (strength<<FRACBITS)
			car.offroad = (strength<<FRACBITS)
		end
	else
		car.offroad = 0
	end
	
end

addHook("MobjMoveCollide",function(car,mo)
	if (mo.type == MT_PLAYER)-- and mo == car.target)
	or (mo.flags & MF_SPRING)
	--rs lo,loloskdoisjro3iwhjriekujfhlkdxzucfhlais8durhb7asdv807
	or (mo.flags & MF_MISSILE)
		return false
	elseif (mo.type == MT_DUSTDEVIL)
		L_ZLaunch(car,20*FU)
	elseif (mo.type == MT_BIGGRABCHAIN)
	or (mo.type == MT_SMALLGRABCHAIN)
		L_ZLaunch(car,40*FU)
	end
end,MT_TAKIS_KART_HELPER)

--bonk
--bumpcode
addHook("MobjMoveBlocked",function(car,thing,line)
	if ((thing) and (thing.valid)) or ((line) and (line.valid))
		if (car.sprung) and car.momz*P_MobjFlip(car) > 0 then return end
		
		local oldangle = car.angle
		if thing and thing.valid
			if thing.flags & (MF_MONITOR|MF_PUSHABLE)
				return
			end
			
			car.angle = FixedAngle(AngleFixed(R_PointToAngle2(car.x,car.y,thing.x,thing.y))+(180*FU))
			P_InstaThrust(car,car.angle,20*car.scale)
			car.angle = oldangle
			car.accel = $/5
			
			if thing.iskart
				oldangle = thing.angle
				thing.angle = FixedAngle(AngleFixed(R_PointToAngle2(thing.x,thing.y,car.x,car.y))+(180*FU))
				P_InstaThrust(thing,thing.angle,20*thing.scale)
				thing.angle = oldangle
				if thing.accel ~= nil
					thing.accel = $/5
				end
			end
		elseif line and line.valid
			if GetCarSpeed(car) < 7*FU then return end
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
		if (car.target and car.target.player)
		and not car.target.player.powers[pw_flashing]
		and car.takiscar
			car.fuel = $-(5*FU)
			car.damagetic = TR
		end
		S_StartSound(car,sfx_s3k49)
		P_MoveOrigin(car.target,car.x,car.y,car.z)
		
		return true
	end
end,MT_TAKIS_KART_HELPER)

local basenormalspeed = 45
local function carinit(car)
	--toggles takis specific stuff (like fuel)
	car.iskart = true
	car.takiscar = true
	car.fuel = 100*FU
	car.init = true
	car.inpain = false
	car.painangle = 0
	car.painspin = 0
	car.facingangle = 0
	car.damagetic = 0
	car.oldangle = 0
	car.maxspeed = basenormalspeed*FU
	car.offroad = 0
	car.drift = 0
	car.drifttime = 0
	car.driftspark = 0
	car.driftbrake = 0
	car.driftboost = 0
	car.driftangle = 0
	car.driftedout = false
	car.driftdiff = 0
	car.momt = 0
	car.turning = false
	car.accel = 0
	car.enginesound = 0
	car.sprung = false
	car.jumped = false
	car.boostpanel = 0
	car.moving = 0
	car.nooffroad = false
	car.ringboost = 0
	car.reversing = 0
	car.stats = STATS
	car.rmomt = 0
end

addHook("MobjThinker",function(car)
	if not (car and car.valid) then return end
	if not (car.target and car.target.valid)
		P_RemoveMobj(car)
		return
	end
	
	local p = car.target.player
	if not (p and p.valid) then return end
	local me = p.mo
	if not (me and me.valid) then return end
	local takis = p.takistable
	if not (me.health)
	or not P_IsValidSprite2(me,SPR2_KART)
	or (me.skin ~= TAKIS_SKIN and car.takiscar)
		if me.health
			TakisFancyExplode(me,
				car.x, car.y, car.z,
				P_RandomRange(60,64)*car.scale,
				32,
				MT_TAKIS_EXPLODE,
				15,20
			)
			P_KillMobj(car)
		else
			P_RemoveMobj(car)
		end
		P_MovePlayer(p)
		if p.powers[pw_carry] == CR_TAKISKART
			p.powers[pw_carry] = 0
		end
		me.tracer = nil
		return
	end
	
	if (me.flags & MF_NOTHINK)
		return true
	end
	
	if not car.init
		carinit(car)
	end
	
	me.tracer = car
	P_ResetPlayer(p)
	--p.skidtime = 1
	p.pflags = $|PF_JUMPSTASIS
	p.inkart = 2
	p.powers[pw_carry] = CR_TAKISKART
	p.powers[pw_ignorelatch] = 32768 
	p.kartingtime = $+1 or 0
	car.scale = me.scale
	takis.transfo = 0|(takis.transfo & TRANSFO_SHOTGUN)
	
	/*
	--idk this seems fine to me now
	print("sac",
		L_FixedDecimal(car.scale,3),
		L_FixedDecimal(me.scale,3),
		L_FixedDecimal(P_GetMobjGravity(me),3),
		L_FixedDecimal(P_GetMobjGravity(car),3),
		L_FixedDecimal(FixedHypot(car.momx,car.momy),3),
		L_FixedDecimal(GetCarSpeed(car),3)
	)
	
	--we can do this later
	print("l",
		me.flags2 & MF2_OBJECTFLIP == MF2_OBJECTFLIP,
		me.eflags & MFE_VERTICALFLIP == MFE_VERTICALFLIP,
		car.flags2 & MF2_OBJECTFLIP == MF2_OBJECTFLIP,
		car.eflags & MFE_VERTICALFLIP == MFE_VERTICALFLIP,
		P_MobjFlip(me),
		P_MobjFlip(car),
		L_FixedDecimal(P_GetMobjGravity(car)*P_MobjFlip(car),3),
		L_FixedDecimal(car.momz,3)
	)
	*/
	
	if P_MobjFlip(me) == -1
		car.flags2 = $|MF2_OBJECTFLIP
	else
		car.flags2 = $ &~MF2_OBJECTFLIP
	end
	
	if p.pflags & PF_SLIDING
		P_MoveOrigin(car,me.x,me.y,me.z)
		car.momx,car.momy,car.momz = me.momx,me.momy,me.momz
		p.pflags = $ &~PF_JUMPSTASIS
		car.angle = me.angle
		me.sprite2 = SPR2_KART
		me.frame = J
		return
	end
	
	local dist = 130
	local x,y = me.x + me.momx, me.y + me.momy
	
	--takis.lastpos is {x=me.x,y=me.y,z=me.z} in a PostThink, where "me" is p.realmo
	if x+(dist*me.scale) < takis.lastpos.x + me.momx
	or x-(dist*me.scale) > takis.lastpos.x + me.momx
	or y+(dist*me.scale) < takis.lastpos.y + me.momy
	or y-(dist*me.scale) > takis.lastpos.y + me.momy
		P_MoveOrigin(car,x,y,GetActorZ(me,car,1))
	else
		P_MoveOrigin(me,car.x,car.y,GetActorZ(car,me,1))
	end
	
	if car.damagetic then car.damagetic = $-1 end
	car.flags2 = $|MF2_DONTDRAW
	local cmd = p.cmd
	local grounded = P_IsObjectOnGround(car)
	
	car.radius,car.height = me.radius,me.height
	me.momx,me.momy,me.momz = car.momx,car.momy,car.momz
	
	car.basemaxspeed = basenormalspeed*FU
	local basemaxspeed = car.basemaxspeed
	local maxspeed = car.maxspeed
	local accel = p.accelstart + (GetCarSpeed(car)>>FRACBITS)*p.acceleration
	local slow = FU
	accel = ($*10)*3/2
	
	if car.accel ~= 0
	and car.accel < -accel*2
	--and FixedHypot(car.momx,car.momy) <= 5*car.scale
		maxspeed = car.maxspeed/2
	end
	
	if car.takiscar
		car.fuel = $-(FixedDiv(100*FU,90*TR*FU))
		if car.fuel <= 25*FU
			if not (leveltime % TR)
				S_StartSoundAtVolume(car,sfx_kartlf,255/2,p)
			end
		end
	end
	
	car.moving = cmd.forwardmove
	car.reversing = min(cmd.forwardmove,0)
	if extrastuff
	and spaceaccel
	and not p.bot
	and not car.inpain
		car.moving = min(cmd.buttons & BT_JUMP,25)
		car.reversing = ((cmd.buttons & BT_JUMP) and (cmd.forwardmove <= -CMD_DEADZONE)) and 25 or 0
	end
	local moving = car.moving
	local reversing = car.reversing
	if car.inpain
		moving,reversing = 0,0
	end	
	
	--turning
	--angle diff between old and new angs should be 2-3
	if car.inpain
		car.drift = 0
		car.driftedout = true
		car.driftspark = 0
		car.driftboost = 0
		cmd.sidemove,cmd.forwardmove = 0,0
		local speed = GetCarSpeed(car,CS_VERT)
		car.painspin = $+speed
	end
	
	if cmd.sidemove
		local turndir = -(cmd.sidemove > 0 and 1 or -1)
		local driftdir = ((car.drift > 0) and 1 or -1)
		
		--start a drift
		if (cmd.buttons & BT_SPIN)
		and not (car.driftedout)
		and (max(GetCarSpeed(car,CS_ACCEL),GetCarSpeed(car)) >= 10*FU)
		and car.drift == 0
		and grounded
		and abs(p.cmd.sidemove) >= CMD_DEADZONE
		and moving >= CMD_DEADZONE
		and not car.reversing
			car.drift = $+turndir
			car.driftangle = car.angle
		end
		
		if (max(GetCarSpeed(car,CS_ACCEL),GetCarSpeed(car)) >= FU/2)
			local sidemove = 0
			if abs(cmd.sidemove) >= CMD_DEADZONE
				sidemove = FixedDiv(abs(cmd.sidemove),32)
			end
			sidemove = min($,FU)
			
			if car.drift ~= 0
			and grounded
				local driftadd = 0
				local mul = FU
				if GetCarSpeed(car) > car.basemaxspeed*3/2
					mul = FixedDiv(GetCarSpeed(car),car.basemaxspeed*3/2)
				end
				
				--if we're drifting, then countersteer a bit
				if turndir ~= driftdir
					car.momt = FixedMul(FixedMul(-4*FU,sidemove),mul)*driftdir
					if not (car.offroad)
						driftadd = $ - FixedMul(7,sidemove)
					end
				else
					if turndir == driftdir	
					and car.maxspeed > 15*FU
						local sidemove = min(sidemove,FU)
						car.maxspeed = $*198/201 --,FixedMul(FixedDiv(FU*198,FU*201)
					end
					car.momt = FixedMul(FixedMul(40*FU,sidemove),mul)*turndir
					if not (car.offroad)
						driftadd = $ + FixedMul(5,sidemove)
					end
				end
				if (GetCarSpeed(car) >= 10*FU)
					car.driftspark = $+driftadd
				end
			else
				car.momt = FixedMul(46*FU,sidemove)*turndir
				if sidemove >= FU/2
					car.accel = $*190/201
				end
			end
		end
		car.turning = true
	else
		car.turning = false
	end
	
	driftstuff(p,car)
	car.momt = $*3/5
	car.rmomt = ease.outquad(FU/3,$,car.momt)
	car.angle = $+FixedAngle(car.rmomt/9)
	--
	
	--move
	if (takis.fire == 1
	or (not (takis.fire % 3) and takis.fire))
	and p.rings > 0
		P_GivePlayerRings(p,-1)
		local me = p.realmo
		local ring = P_SpawnMobjFromMobj(me,me.momx,me.momy,me.momz,MT_RING)
		local sfx = P_SpawnGhostMobj(ring)
		sfx.flags2 = $|MF2_DONTDRAW
		sfx.type = MT_THOK
		sfx.tics,sfx.fuse = TR,TR
		S_StartSound(sfx,sfx_itemup)
		P_KillMobj(ring,me,me)
	end
	
	car.nooffroad = false
	if car.driftboost 
		car.basemaxspeed = $*3/2
		--accel = $*2
		TakisDoWindLines(me)
		car.driftboost = $-1
	end
	if car.ringboost
		if car.ringboost > 3*TR
			car.ringboost = 3*TR
		end
		car.basemaxspeed = $*13/10
		TakisDoWindLines(me,nil,SKINCOLOR_SUPERRUST4)
		car.ringboost = $-1
	end
	
	if p.powers[pw_sneakers]
		car.basemaxspeed = $*3/2
		car.nooffroad = true
		--accel = $*3/2
	end
	if (car.boostpanel)
		car.basemaxspeed = $*3/2
		TakisDoWindLines(me)
		car.boostpanel = $-1
		car.nooffroad = true
	end
	updateoffroad(p,car)
	
	if extrastuff
		if InSectorSpecial(me,true,4,6)
		and car.boostpanel < TR-2
			car.boostpanel = TR
			S_StartSound(car,sfx_cdfm01)
		end
		
		if InSectorSpecial(me,true,4,7)
		and not car.inpain
			P_DamageMobj(me)
		end
	end
	
	if car.drift == 0
		if car.maxspeed < car.basemaxspeed
			if car.maxspeed < 0
				car.maxspeed = FU
			end
			car.maxspeed = $*202/198
		elseif maxspeed > car.basemaxspeed
			car.maxspeed = car.basemaxspeed --$*198/200
		end
	end
	
	if moving ~= 0
		local acceldir = 1 --(moving > 0) and 1 or -1
		if reversing and acceldir ~= -1 then acceldir = -1 end
		local move = acceldir == 1 and moving or reversing
		local forwardmove = 0
		if abs(moving) >= CMD_DEADZONE
			forwardmove = min(FixedDiv(abs(move),25),FU)
		end
		
		local cmaxspeed = FixedMul(car.maxspeed,forwardmove)
		if acceldir == 1
			if car.accel < 0
				local ab = (car.accel > 0) and 1 or -1
				car.accel = (abs($)*4/5)*ab
			end
			if car.accel+accel < cmaxspeed/8
				car.accel = $+accel
			end
		--back it up terry
		else
			--braking
			if car.accel > 0
			or (GetCarSpeed(car,CS_ACCELNOABS) >= 13*FU)
				if grounded
					brakegfx(p,car)
					if not S_SoundPlaying(car,sfx_skid)
						S_StartSound(car,sfx_skid)
					end
				end
				car.accel = $*185/200
			else
				S_StopSoundByID(car,sfx_skid)
			end
			
			if car.accel-accel > -cmaxspeed/16
				car.accel = $-accel
			end
		end
	else
		if grounded
			local ab = (car.accel > 0) and 1 or -1
			car.accel = (FixedMul(abs($),29*FU/32))*ab
			
			if GetCarSpeed(car,CS_ACCEL) <= FU
				car.accel = 0
			end
		end
	end
	if car.accel > (car.maxspeed/8)--+(accel*2)
		car.accel = car.maxspeed/8
	end
	if car.accel < (-car.maxspeed/32)---(accel*2)
		car.accel = -car.maxspeed/32
	end
	
	car.oldspeed = R_PointToDist2(car.momx - p.cmomx,car.momy - p.cmomy,0,0)
	local thrustangle = car.angle
	if car.drift ~= 0
	and grounded
		thrustangle = car.angle-(FixedAngle((AngleFixed(ANGLE_45)/9)*car.drift))
	end
	if (car.boostpanel)
		car.accel = max($,car.maxspeed/8)
		if car.boostpanel == TR
			P_Thrust(car,thrustangle,4*car.scale)
		end
		if GetCarSpeed(car) < car.basemaxspeed
			P_Thrust(car,thrustangle,FixedMul(car.basemaxspeed-GetCarSpeed(car),car.scale))
		end
	end
	
	local movethrust = FixedMul(FixedMul(car.friction,car.movefactor), car.accel) --FixedMul(car.friction, car.accel)
	/*
	if car.friction > 29*FU/32
		if FixedHypot(car.momx,car.momy) > car.maxspeed
			movethrust = 0
		end
	end
	*/
	if not grounded
		movethrust = $/10
		if moving >= 0
			if GetCarSpeed(car) > car.maxspeed
				movethrust = 0
			end
		elseif reversing
			movethrust = $*3
		end
	else
		if car.offroad > 0
			if GetCarSpeed(car)/FU ~= 0
				if not (leveltime % 6)
					S_StartSound(car,sfx_cdfm70)
				end
				if not (leveltime % 2)
					local dust = TakisSpawnDust(me,
						car.angle+FixedAngle(P_RandomRange(-50,50)*FU+P_RandomFixed()),
						0,
						P_RandomRange(-1,2)*car.scale,
						{
							xspread = 0,
							yspread = 0,
							zspread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
							
							thrust = -P_RandomRange(3,7)*car.scale,
							thrustspread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
							
							momz = P_RandomRange(1,3)*me.scale,
							momzspread = P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1),
							
							scale = me.scale/2,
							scalespread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
							
							fuse = 15+P_RandomRange(-2,3),
						}
					)
				end
			end
			movethrust = FixedDiv($,car.offroad+FU)
		end
		
		if GetCarSpeed(car) > car.basemaxspeed+(FU*2)
			local mul = FU
			mul = FixedDiv(GetCarSpeed(car),car.basemaxspeed*4/5)
			movethrust = FixedDiv($,mul)
		end
		
	end
	movethrust = FixedMul($,car.scale)
	P_Thrust(car, thrustangle, movethrust)
	
	if not P_TryMove(me,
		me.x+P_ReturnThrustX(nil,thrustangle,movethrust),
		me.y+P_ReturnThrustY(nil,thrustangle,movethrust),
		true
	)
		car.accel = min($,15*FU/8)
	end
	
	P_ButteredSlope(car)
	P_ButteredSlope(car)
	P_ButteredSlope(me)
	P_ButteredSlope(me)
	
	--tire tracks
	if grounded
	and (GetCarSpeed(car) >= 60*FU
	or car.drift ~= 0)
	and not TAKIS_NET.noeffects
		for i = 0,1
			local momx,momy = 0,0
			if i == 1
				momx,momy = car.momx/2,car.momy/2
			end
			
			local track = P_SpawnMobjFromMobj(car,momx,momy,0,MT_THOK)
			track.scale = car.scale
			track.lifetime = 10*TR
			track.sprite = SPR_WDRG
			track.frame = F
			track.tics,track.fuse = track.lifetime,track.lifetime
			track.renderflags = RF_OBJECTSLOPESPLAT|RF_NOSPLATBILLBOARD|RF_FLOORSPRITE
			track.angle = thrustangle
			track.flags = $ &~(MF_NOSECTOR|MF_NOBLOCKMAP)
		end
	end
	--
	
	--jump
	local jumped = false
	if (cmd.buttons & BT_JUMP)
	and not (p.lastbuttons & BT_JUMP)
	and (grounded or takis.coyote)
	and car.drift == 0
	and not car.inpain
	and not car.jumped
	and not extrastuff
		L_ZLaunch(car,15*FU)
		S_StartSound(car,sfx_ngjump)
		car.jumped = true
		jumped = true
	end
	if not (cmd.buttons & BT_JUMP)
	and car.jumped
	and car.momz*P_MobjFlip(car) > 0
		car.momz = $/2
		car.jumped = false
	end
	--
	
	TakisBreakAndBust(p,car)
	local flashingtics = flashingtics/2
	if not grounded
		if not (car.sprung)
			car.momz = $+(P_GetMobjGravity(car)*3/5*P_MobjFlip(me))
		end
		if car.inpain
			car.accel = $*9/10
			me.flags2 = $ &~MF2_DONTDRAW
			car.jumped = false
			car.momz = $+(P_GetMobjGravity(car)*2/5*P_MobjFlip(me))
			if takis.fakeflashing < flashingtics-2
				takis.fakeflashing = flashingtics
			end
		end
	else
		if not jumped
			car.jumped = false
		end
		car.sprung = false
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
					takis.fakeflashing = flashingtics
				end
			end
		end
	end
	
	animhandle(p,car)
	soundhandle(p,car)
	
	--funny???
	if (gametype == GT_RACE
	or HAPPY_HOUR.othergt)
	or (TAKIS_NET.forcekart)
	or (extrastuff)
		car.fuel = 100*FU
	end
	
	--set the stuff for the player
	if p.ai
	or p.bot
		car.angle = me.angle
	end
	me.angle = car.angle
	--look behind
	if p.cmd.buttons & BT_CUSTOM3
		if car.viewaway == nil
			car.viewaway = P_SpawnMobjFromMobj(me,
				car.momx+(FixedMul(100*car.scale,cos(me.angle))),
				car.momy+(FixedMul(100*car.scale,sin(me.angle))),
				car.z+(96*car.scale*P_MobjFlip(me)),
				MT_THOK
			)
			car.viewaway.tics,car.viewaway.fuse = -1,-1
			car.viewaway.flags2 = $|MF2_DONTDRAW
		else
			P_MoveOrigin(car.viewaway,
				car.x+car.momx+(FixedMul(100*car.scale,cos(me.angle))),
				car.y+car.momy+(FixedMul(100*car.scale,sin(me.angle))),
				car.z+car.momz+(50*car.scale*P_MobjFlip(me))
			)
			car.viewaway.angle = R_PointToAngle2(car.viewaway.x,car.viewaway.y,car.x,car.y)
			car.viewaway.scale = me.scale
			p.awayviewmobj = car.viewaway
			p.awayviewtics = 2
		end
	else
		if car.viewaway and car.viewaway.valid
			P_RemoveMobj(car.viewaway)
			car.viewaway = nil
		end
	end
	if (TAKIS_NET.forcekart == false)
		--KILL the car
		if (p.cmd.buttons & BT_CUSTOM2 and not car.inpain)
		or (car.fuel <= 0 and car.takiscar)
			p.inkart = 0
			local newkart = P_SpawnMobjFromMobj(me,
				P_ReturnThrustX(nil,me.angle+ANGLE_90,64*me.scale),
				P_ReturnThrustY(nil,me.angle+ANGLE_90,64*me.scale),
				0,
				MT_TAKIS_KART
			)
			newkart.color = me.color
			newkart.fuel = car.fuel
			newkart.angle = car.angle
			me.state = S_PLAY_STND
			P_MovePlayer(p)
			P_RemoveMobj(car)
			/*
			TakisFancyExplode(me,
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
			P_MovePlayer(p)
			p.powers[pw_nocontrol] = 5
			*/
			if p.powers[pw_carry] == CR_TAKISKART
				p.powers[pw_carry] = 0
			end
			takis.HUD.lives.tweentic = 5*TR
			me.tracer = nil
			return
		end
	end
	
	car.driftdiff = FixedAngle(AngleFixed($)*4/5)
	if not car.inpain
		if (car.drift ~= 0)
			p.drawangle = car.angle
		else
			/*
			local sign = 1
			if car.drift < 0
				sign = -1
			end
			local drift = car.drift*sign
			*/
			
			if abs(car.drift) >= 3
				p.drawangle = car.angle-(car.momt*24)
			else
				p.drawangle = FixedAngle(AngleFixed(car.angle)+AngleFixed(car.driftdiff))
			end
		end
	else
		p.drawangle = car.painangle+FixedAngle(car.painspin)
	end
	car.oldangle = car.angle
	car.olddlevel = TakisKart_DriftLevel(STATS,car.driftspark)
	car.oldmomz = car.momz
	if car.standingslope
		--me.z = P_GetZAt(car.standingslope,me.x,me.y)
	end
	if takis.firenormal == 1
		takis.HUD.lives.nokarthud = not $
	end
	p.pflags = $|PF_JUMPED|PF_DRILLING
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

--misc stuff
addHook("ShouldDamage",function(me,_,_,_,dmgt)
	if not (me and me.valid) then return end
	if not extrastuff then return end
	if not (me.player.inkart) then return end
	
	if InSectorSpecial(me,true,1,2)
	or InSectorSpecial(me,true,1,3)
	or InSectorSpecial(me,true,1,4)
		return false
	end
end,MT_PLAYER)

addHook("MobjThinker",function(mo)
	if not extrastuff then return end
	if not (mo and mo.valid) then return end
	P_SpawnMobjFromMobj(mo,0,0,24*mo.scale,MT_RING)
	P_RemoveMobj(mo)
	return true
end,MT_SMASHINGSPIKEBALL)

addHook("LinedefExecute",function(line,mo,sec)
	if not mo.valid
	or not mo.health
	or not mo.player
	or not mo.player.valid
		return
	end
	
	local p = mo.player
	
	if p.inkart
		if (mo.tracer and mo.tracer.valid and mo.tracer.type == MT_TAKIS_KART_HELPER)
			mo.tracer.fuel = 100*FU
		end
		return
	end
	if mo.skin ~= TAKIS_SKIN then return end
	
	local kart = P_SpawnMobjFromMobj(mo,0,0,0,MT_TAKIS_KART_HELPER)
	kart.angle = mo.angle	
	kart.target = mo
	S_StartSound(kart,sfx_kartst)
	kart.fuel = 100*FU
	p.inkart = 2

end,"TAK_KART")

filesdone = $+1