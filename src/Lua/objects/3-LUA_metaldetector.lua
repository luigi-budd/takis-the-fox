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
	door.made3d = false
	door.flags2 = $ &~MF2_DONTDRAW
end

addHook("MobjThinker",function(door)
	if not (door and door.valid) then return end
	
	local dist = 0
	local cullout = true
	if (displayplayer and displayplayer.valid)
		local cam = displayplayer.realmo
		if not (cam and cam.valid)
			cam = camera
		end
		
		dist = R_PointToDist2(cam.x,cam.y, door.x,door.y)
		
		local thok = P_SpawnMobj(cam.x, cam.y, cam.z, MT_NULL)
		thok.flags2 = $|MF2_DONTDRAW
		if dist <= 5000*FU
		and P_CheckSight(thok,door)
			cullout = false
		end
		P_RemoveMobj(thok)
	end
	
	if cullout
		delete3d(door)
		return
	end
	
	if not door.made3d
	and not cullout
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

filesdone = $+1