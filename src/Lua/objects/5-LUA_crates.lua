local function delete3d(door)
	if not door.made3d
		door.flags2 = $ &~MF2_DONTDRAW
		return
	end
	
	if door.topblock
		for k,v in pairs(door.topblock)
			if v and v.valid
				P_RemoveMobj(v)
			end
		end
	end
	
	if door.sideblock1
		for k,v in pairs(door.sideblock1)
			if v and v.valid
				P_RemoveMobj(v)
			end
		end
	end
	
	if door.sideblock2
		for k,v in pairs(door.sideblock2)
			if v and v.valid
				P_RemoveMobj(v)
			end
		end
	end
	
	if door.nosign
		for k,v in pairs(door.nosign)
			if v and v.valid
				P_RemoveMobj(v)
			end
		end
	end 
	
	if door.alarm
		for k,v in pairs(door.alarm)
			if v and v.valid
				P_RemoveMobj(v)
			end
		end
	end

	if door.sides
		for k,v in pairs(door.sides)
			if v and v.valid
				P_RemoveMobj(v)
			end
		end
	end
	
	door.made3d = false
	door.flags2 = $ &~MF2_DONTDRAW
end

addHook("MobjThinker",function(door)
	if not (door and door.valid) then return end
	
	door.takis_flingme = false
	door.takis_monitorgibs = true
	door.takis_gibsprite = SPR_HTCD
	door.takis_gibframes = {P,Q,R,S}
	door.takis_gibframeflags = FF_PAPERSPRITE
	
	local dist = 0
	local cullout = true
	local doculling = true
	if doculling
		local cam = TakisGetCameraMobj()
		
		dist = R_PointToDist2(cam.x,cam.y, door.x,door.y)
		
		local thok = P_SpawnMobj(cam.x, cam.y, cam.z, MT_NULL)
		thok.angle = cam.angle
		thok.flags2 = $|MF2_DONTDRAW
		if dist <= 5000*FU
		and P_CheckSight(thok,door)
			cullout = false
		end
		
		if not cullout
			local back = FixedAngle(AngleFixed(thok.angle)+180*FU)
			local diff = FixedAngle(AngleFixed(R_PointToAngle2(thok.x, thok.y, door.x, door.y))-AngleFixed(back))
			if AngleFixed(diff) > 180*FU
				diff = InvAngle(diff)
			end
			
			--in the cameras view
			if AngleFixed(diff) > 90*FU
				cullout = false
			else
				cullout = true
			end
		end
		
		if not door.health
			cullout = true
		end
		P_RemoveMobj(thok)
	end
	
	if cullout
		delete3d(door)
		return
	end
	
	if not cullout

		if not door.made3d
			local list
			local flip = P_MobjFlip(door)
			door.flags2 = $|MF2_DONTDRAW
			
			door.sides = {}
			list = door.sides
			
			for i = 1,4
				local angle = door.angle+(FixedAngle(90*FU*(i-1)))
				local x,y = ReturnTrigAngles(angle)
				list[0+i] = P_SpawnMobjFromMobj(door,32*x,32*y,0,MT_THOK)
				list[0+i].frame = C
				list[0+i].sprite = SPR_HTCD
				list[0+i].tics,list[0+i].fuse = -1,-1
				list[0+i].flags = MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_NOCLIP
				list[0+i].renderflags = $|RF_PAPERSPRITE|RF_NOSPLATBILLBOARD
				list[0+i].angle = angle+ANGLE_90
				list[0+i].height = 64*FU
				list[0+i].radius = 0
				P_SetOrigin(list[0+i],
					list[0+i].x,
					list[0+i].y,
					GetActorZ(door,list[0+i],1)
				)
			end
			list[5] = P_SpawnMobjFromMobj(door,0,0,0,MT_THOK)
			list[5].frame = D
			list[5].sprite = SPR_HTCD
			list[5].tics,list[5].fuse = -1,-1
			list[5].flags = MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_NOCLIP
			list[5].renderflags = $|RF_FLOORSPRITE|RF_NOSPLATBILLBOARD
			list[5].angle = door.angle
			list[5].height = 0
			P_SetOrigin(list[5],list[5].x,list[5].y,GetActorZ(door,list[5],2))
			
			list[6] = P_SpawnMobjFromMobj(door,0,0,0,MT_THOK)
			list[6].frame = E
			list[6].sprite = SPR_HTCD
			list[6].tics,list[5].fuse = -1,-1
			list[6].flags = MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_NOCLIP
			list[6].renderflags = $|RF_FLOORSPRITE|RF_NOSPLATBILLBOARD
			list[6].angle = door.angle
			list[6].height = 0
			P_SetOrigin(list[6],list[6].x,list[6].y,GetActorZ(door,list[6],1))
			
			door.made3d = true
		
		--update positions
		else
			local list = door.sides
			
			for i = 1,4
				local angle = door.angle+(FixedAngle(90*FU*(i-1)))
				local x,y = ReturnTrigAngles(angle)
				list[0+i].angle = angle+ANGLE_90
				list[0+i].height = 64*FU
				list[0+i].radius = 0
				list[0+i].scale = door.scale
				P_MoveOrigin(list[0+i],
					door.x+P_ReturnThrustX(nil,angle,32*door.scale),
					door.y+P_ReturnThrustY(nil,angle,32*door.scale),
					GetActorZ(door,list[0+i],1)
				)
			end
			list[5].angle = door.angle
			list[5].height = 0
			list[5].scale = door.scale
			list[5].shadowscale = door.scale*14/10
			P_MoveOrigin(list[5],
				door.x,
				door.y,
				GetActorZ(door,list[5],2)
			)

			P_SetOrigin(list[6],door.x,door.y,door.z)
			list[6].angle = door.angle
			list[6].height = 0
			list[6].scale = door.scale
			P_MoveOrigin(list[6],
				door.x,
				door.y,
				GetActorZ(door,list[6],1)
			)
			
		end
	end
end,MT_TAKIS_HEARTCRATE)

addHook("MobjDeath",function(crate,inf,sor)
	if not (sor and sor.valid) then return end
	if not (sor.player and sor.player.valid) then return end
	
	local p = sor.player
	local takis = p.takistable
	local sound = P_SpawnGhostMobj(crate)
	sound.flags2 = $|MF2_DONTDRAW
	sound.fuse = TR
	DoQuake(p,15*FU,14)
	
	delete3d(crate)
	
	if sor.skin == TAKIS_SKIN
		--TakisGiveCombo(p,takis,true)
		if takis.heartcards ~= TAKIS_MAX_HEARTCARDS
			TakisHealPlayer(p,sor,takis,1)
			S_StartSound(sound,sfx_takhel,p)
		end
		takis.dived,takis.thokked = false,false
	--Bruh
	else
		--S_StartSound(sound,sfx_itemup,p)
		--P_GivePlayerRings(p,10)
	end
	
end,MT_TAKIS_HEARTCRATE)

addHook("MobjThinker",function(door)
	if not (door and door.valid) then return end
	
	door.takis_flingme = false
	door.takis_monitorgibs = true
	door.takis_gibsprite = SPR_HTCD
	door.takis_gibframes = {L,M,N,O}
	door.takis_gibframeflags = FF_PAPERSPRITE
	
	local dist = 0
	local cullout = true
	local doculling = true
	if doculling
		local cam = TakisGetCameraMobj()
		
		dist = R_PointToDist2(cam.x,cam.y, door.x,door.y)
		
		local thok = P_SpawnMobj(cam.x, cam.y, cam.z, MT_NULL)
		thok.angle = cam.angle
		thok.flags2 = $|MF2_DONTDRAW
		if dist <= 5000*FU
		and P_CheckSight(thok,door)
			cullout = false
		end
		
		if not cullout
			local back = FixedAngle(AngleFixed(thok.angle)+180*FU)
			local diff = FixedAngle(AngleFixed(R_PointToAngle2(thok.x, thok.y, door.x, door.y))-AngleFixed(back))
			if AngleFixed(diff) > 180*FU
				diff = InvAngle(diff)
			end
			
			--in the cameras view
			if AngleFixed(diff) > 90*FU
				cullout = false
			else
				cullout = true
			end
		end
		
		if not door.health
			cullout = true
		end
		P_RemoveMobj(thok)
	end
	
	if cullout
		delete3d(door)
		return
	end
	
	if not cullout
		if not door.made3d
			local list
			local flip = P_MobjFlip(door)
			door.flags2 = $|MF2_DONTDRAW
			
			door.sides = {}
			list = door.sides
			
			for i = 1,4
				local angle = door.angle+(FixedAngle(90*FU*(i-1)))
				local x,y = ReturnTrigAngles(angle)
				list[0+i] = P_SpawnMobjFromMobj(door,16*x,16*y,0,MT_THOK)
				list[0+i].frame = I
				list[0+i].sprite = SPR_HTCD
				list[0+i].tics,list[0+i].fuse = -1,-1
				list[0+i].flags = MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_NOCLIP
				list[0+i].renderflags = $|RF_PAPERSPRITE|RF_NOSPLATBILLBOARD
				list[0+i].angle = angle+ANGLE_90
				list[0+i].height = 64*FU
				list[0+i].radius = 0
				P_SetOrigin(list[0+i],
					list[0+i].x,
					list[0+i].y,
					GetActorZ(door,list[0+i],1)
				)
			end
			list[5] = P_SpawnMobjFromMobj(door,0,0,0,MT_THOK)
			list[5].frame = J
			list[5].sprite = SPR_HTCD
			list[5].tics,list[5].fuse = -1,-1
			list[5].flags = MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_NOCLIP
			list[5].renderflags = $|RF_FLOORSPRITE|RF_NOSPLATBILLBOARD
			list[5].angle = door.angle
			list[5].height = 0
			P_SetOrigin(list[5],list[5].x,list[5].y,GetActorZ(door,list[5],2))
			
			list[6] = P_SpawnMobjFromMobj(door,0,0,0,MT_THOK)
			list[6].frame = K
			list[6].sprite = SPR_HTCD
			list[6].tics,list[5].fuse = -1,-1
			list[6].flags = MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_NOCLIP
			list[6].renderflags = $|RF_FLOORSPRITE|RF_NOSPLATBILLBOARD
			list[6].angle = door.angle
			list[6].height = 0
			P_SetOrigin(list[6],list[6].x,list[6].y,GetActorZ(door,list[6],1))
			
			door.made3d = true
		
		--update positions
		else
			local list = door.sides
			
			for i = 1,4
				local angle = door.angle+(FixedAngle(90*FU*(i-1)))
				local x,y = ReturnTrigAngles(angle)
				list[0+i].angle = angle+ANGLE_90
				list[0+i].height = 64*FU
				list[0+i].radius = 0
				list[0+i].scale = door.scale
				P_MoveOrigin(list[0+i],
					door.x+P_ReturnThrustX(nil,angle,16*door.scale),
					door.y+P_ReturnThrustY(nil,angle,16*door.scale),
					GetActorZ(door,list[0+i],1)
				)
			end
			list[5].angle = door.angle
			list[5].height = 0
			list[5].scale = door.scale
			list[5].shadowscale = (door.scale/2)*14/10
			P_MoveOrigin(list[5],
				door.x,
				door.y,
				GetActorZ(door,list[5],2)
			)
			
			P_SetOrigin(list[6],door.x,door.y,door.z)
			list[6].angle = door.angle
			list[6].height = 0
			list[6].scale = door.scale
			P_MoveOrigin(list[6],
				door.x,
				door.y,
				GetActorZ(door,list[6],1)
			)
			
		end
	end
end,MT_TAKIS_CRATE)

local regcratedeath = function(crate,inf,sor)
	if not (sor and sor.valid) then return end
	if not (sor.player and sor.player.valid) then return end
	
	local p = sor.player
	local takis = p.takistable
	local sound = P_SpawnGhostMobj(crate)
	sound.flags2 = $|MF2_DONTDRAW
	sound.fuse = TR
	DoQuake(p,15*FU,14)
	delete3d(crate)
	
	if sor.skin == TAKIS_SKIN
		--TakisGiveCombo(p,takis,true)
		takis.dived,takis.thokked = false,false
	--Bruh
	else
		--S_StartSound(sound,sfx_itemup,p)
		--P_GivePlayerRings(p,10)
	end
end

addHook("MobjDeath",regcratedeath,MT_TAKIS_CRATE)
addHook("MobjDeath",regcratedeath,MT_TAKIS_BIGCRATE)

addHook("MobjThinker",function(door)
	if not (door and door.valid) then return end
	
	door.takis_flingme = false
	door.takis_monitorgibs = true
	door.takis_gibsprite = SPR_HTCD
	door.takis_gibframes = {L,M,N,O}
	door.takis_gibframeflags = FF_PAPERSPRITE
	
	local dist = 0
	local cullout = true
	local doculling = true
	if doculling
		local cam = TakisGetCameraMobj()
		
		dist = R_PointToDist2(cam.x,cam.y, door.x,door.y)
		
		local thok = P_SpawnMobj(cam.x, cam.y, cam.z, MT_NULL)
		thok.angle = cam.angle
		thok.flags2 = $|MF2_DONTDRAW
		if dist <= 5000*FU
		and P_CheckSight(thok,door)
			cullout = false
		end
		
		if not cullout
			local back = FixedAngle(AngleFixed(thok.angle)+180*FU)
			local diff = FixedAngle(AngleFixed(R_PointToAngle2(thok.x, thok.y, door.x, door.y))-AngleFixed(back))
			if AngleFixed(diff) > 180*FU
				diff = InvAngle(diff)
			end
			
			--in the cameras view
			if AngleFixed(diff) > 90*FU
				cullout = false
			else
				cullout = true
			end
		end
		
		if not door.health
			cullout = true
		end
		P_RemoveMobj(thok)
	end
	
	if cullout
		delete3d(door)
		return
	end
	
	if not cullout
		if not door.made3d
			local list
			local flip = P_MobjFlip(door)
			door.flags2 = $|MF2_DONTDRAW
			
			door.sides = {}
			list = door.sides
			
			for i = 1,4
				local angle = door.angle+(FixedAngle(90*FU*(i-1)))
				local x,y = ReturnTrigAngles(angle)
				list[0+i] = P_SpawnMobjFromMobj(door,32*x,32*y,0,MT_THOK)
				list[0+i].frame = F
				list[0+i].sprite = SPR_HTCD
				list[0+i].tics,list[0+i].fuse = -1,-1
				list[0+i].flags = MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_NOCLIP
				list[0+i].renderflags = $|RF_PAPERSPRITE|RF_NOSPLATBILLBOARD
				list[0+i].angle = angle+ANGLE_90
				list[0+i].height = 64*FU
				list[0+i].radius = 0
				P_SetOrigin(list[0+i],
					list[0+i].x,
					list[0+i].y,
					GetActorZ(door,list[0+i],1)
				)
			end
			list[5] = P_SpawnMobjFromMobj(door,0,0,0,MT_THOK)
			list[5].frame = G
			list[5].sprite = SPR_HTCD
			list[5].tics,list[5].fuse = -1,-1
			list[5].flags = MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_NOCLIP
			list[5].renderflags = $|RF_FLOORSPRITE|RF_NOSPLATBILLBOARD
			list[5].angle = door.angle
			list[5].height = 0
			P_SetOrigin(list[5],list[5].x,list[5].y,GetActorZ(door,list[5],2))
			
			list[6] = P_SpawnMobjFromMobj(door,0,0,0,MT_THOK)
			list[6].frame = H
			list[6].sprite = SPR_HTCD
			list[6].tics,list[5].fuse = -1,-1
			list[6].flags = MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_NOCLIP
			list[6].renderflags = $|RF_FLOORSPRITE|RF_NOSPLATBILLBOARD
			list[6].angle = door.angle
			list[6].height = 0
			P_SetOrigin(list[6],list[6].x,list[6].y,GetActorZ(door,list[6],1))
			
			door.made3d = true
		
		--update positions
		else
			local list = door.sides
			
			for i = 1,4
				local angle = door.angle+(FixedAngle(90*FU*(i-1)))
				local x,y = ReturnTrigAngles(angle)
				list[0+i].angle = angle+ANGLE_90
				list[0+i].height = 64*FU
				list[0+i].radius = 0
				list[0+i].scale = door.scale
				P_MoveOrigin(list[0+i],
					door.x+P_ReturnThrustX(nil,angle,32*door.scale),
					door.y+P_ReturnThrustY(nil,angle,32*door.scale),
					GetActorZ(door,list[0+i],1)
				)
			end
			list[5].angle = door.angle
			list[5].height = 0
			list[5].scale = door.scale
			list[5].shadowscale = door.scale*14/10
			P_MoveOrigin(list[5],
				door.x,
				door.y,
				GetActorZ(door,list[5],2)
			)
			
			P_SetOrigin(list[6],door.x,door.y,door.z)
			list[6].angle = door.angle
			list[6].height = 0
			list[6].scale = door.scale
			P_MoveOrigin(list[6],
				door.x,
				door.y,
				GetActorZ(door,list[6],1)
			)
			
		end
	end
end,MT_TAKIS_BIGCRATE)

local function removed(crate)
	delete3d(crate)
end

addHook("MobjRemoved",removed,MT_TAKIS_HEARTCRATE)
addHook("MobjRemoved",removed,MT_TAKIS_CRATE)
addHook("MobjRemoved",removed,MT_TAKIS_BIGCRATE)

filesdone = $+1