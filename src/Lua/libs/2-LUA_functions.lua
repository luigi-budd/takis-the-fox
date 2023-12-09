local function btntic(p,tic,enum)
	local btn = p.cmd.buttons
	if btn & enum
		tic = $+1
	else
		tic = 0
	end
	return tic
end

local cusbut = {
	[1] = BT_CUSTOM1,
	[2] = BT_CUSTOM2,
	[3] = BT_CUSTOM3
}
rawset(_G, "TakisButtonStuff", function(p,takis)
	
	local btn = p.cmd.buttons
	
	takis.jump = btntic(p,$,BT_JUMP)
	
	takis.nadouse = takis.use
	takis.use = btntic(p,$,BT_USE)
	
	takis.tossflag = btntic(p,$,BT_TOSSFLAG)
	
	for i = 1,3
		takis["c"..i] = btntic(p,$,cusbut[i])
	end
	
	takis.fire = btntic(p,$,BT_ATTACK)

	takis.firenormal = btntic(p,$,BT_FIRENORMAL)
	
	if btn & BT_WEAPONMASK
		takis.weaponmasktime = $+1
		takis.weaponmask = (btn & BT_WEAPONMASK)
	else
		takis.weaponmasktime = 0
		takis.weaponmask = 0
	end
	
	takis.weaponnext = btntic(p,$,BT_WEAPONNEXT)
	takis.weaponprev = btntic(p,$,BT_WEAPONPREV)
	
	if (takis.nocontrol)
	or (p.pflags & PF_STASIS)
	or (p.powers[pw_nocontrol])
		if takis.nocontrol
			takis.nocontrol = $-1
		end
		takis.jump = 0
		takis.use = 0
		takis.tossflag = 0
		takis.c1 = 0
		takis.c2 = 0
		takis.c3 = 0
		takis.fire = 0
		takis.firenormal = 0
		takis.weaponmasktime = 0
		takis.weaponmask = 0
		takis.weaponnext = 0
		takis.weaponprev = 0
		if takis.nocontrol
			p.powers[pw_nocontrol] = takis.nocontrol
		end
	end
	
end)

rawset(_G, "TakisBooleans", function(p,me,takis,SKIN)
	local posz = me.floorz
	local z = me.z
	if (P_MobjFlip(me) == -1)
		posz = me.ceilingz
		z = me.z+me.height
	end
	
	takis.onPosZ = (z == posz)
	
	if (me.eflags & MFE_JUSTHITFLOOR)
		takis.timetouchingground = $+1
	else
		takis.timetouchingground = 0
	end
	
	takis.justHitFloor = takis.timetouchingground == 1
	takis.onGround = (P_IsObjectOnGround(me)) or (takis.onPosZ) and (not (P_CheckDeathPitCollide(me)))
	takis.inPain = P_PlayerInPain(p)
	takis.isTakis = (me.skin == SKIN) or (skins[p.skin].name == SKIN)
	
	if (not netgame)
	and (not splitscreen)
		takis.isSinglePlayer = true
	else
		takis.isSinglePlayer = false
	end
	
	takis.inWater = (me.eflags&MFE_UNDERWATER) and not (me.eflags & MFE_TOUCHLAVA)
	takis.inGoop = P_IsObjectInGoop(me)
	takis.notCarried = ((p.powers[pw_carry] == CR_NONE) and not (takis.inwaterslide))
	if not (isdedicatedserver)
		takis.isMusicOn = ((CV_FindVar("digimusic").value) or (CV_FindVar("midimusic").value))
	end
	takis.isElevated = IsPlayerAdmin(p) or (p == server)
	takis.inNIGHTSMode = (p.powers[pw_carry] == CR_NIGHTSMODE) or (maptol & TOL_NIGHTS)
	takis.inSRBZ = gametype == GT_SRBZ
	takis.inChaos = (CBW_Chaos_Library and CBW_Chaos_Library.Gametypes[gametype])
end)

local function dorandom()
	local random = P_RandomRange(0,1)
	if random == 0
		random = -1
	end
	return random
end
local function getdec(random)
	return P_RandomByte() * 256 * random
end

rawset(_G, "TakisAnimateHappyHour", function(p)
	local takis = p.takistable
	local hud = takis.HUD
	local me = p.mo

	local dontdo = false
	if (HAPPY_HOUR.othergt)
		dontdo = takis.io.nohappyhour == 1
	end
	
	if HAPPY_HOUR.time and HAPPY_HOUR.time <= 5*TR	
	and not (dontdo)
		
		local tics = HAPPY_HOUR.time
		if tics == 1
			hud.happyhour.its.yadd = -200*FU
			hud.happyhour.happy.yadd = -100*FU
			hud.happyhour.hour.yadd = -100*FU
			hud.happyhour.face.yadd = -200*FU
		end
		
		hud.happyhour.its.frame = ((leveltime/3)%2)
		hud.happyhour.happy.frame = ((leveltime/3)%2)
		hud.happyhour.hour.frame = ((leveltime/3)%2)
		hud.happyhour.face.frame = ((leveltime/3)%2)
		
		if hud.happyhour.doingit
			if not hud.happyhour.falldown
				if hud.happyhour.its.yadd ~= 0
					hud.happyhour.its.yadd = 2*$/5
					
				elseif hud.happyhour.happy.yadd ~= 0
					hud.happyhour.happy.yadd = 2*$/5
				
				elseif hud.happyhour.hour.yadd ~= 0
					hud.happyhour.hour.yadd = 2*$/5
				end
				
				--elseif hud.happyhour.face.yadd ~= 0
				hud.happyhour.face.yadd = 4*$/5
			else
			
				hud.happyhour.its.yadd = $*8/5
				hud.happyhour.happy.yadd = $*7/5
				hud.happyhour.hour.yadd = $*6/5
				hud.happyhour.face.yadd = $*8/7
			
			end
		end

		hud.happyhour.doingit = true
		
		local h = hud.happyhour
		local y = 40*FU
		local back = 4*FU/5
		
		hud.happyhour.its.scale = ease.inoutback(( FU / h.its.expectedtime )*tics, FU/100, 3*FU/5,back)
		hud.happyhour.happy.scale = ease.inoutback(( FU / h.happy.expectedtime )*tics, FU/100, 3*FU/5,back)
		hud.happyhour.hour.scale = ease.inoutback(( FU / h.hour.expectedtime )*tics, FU/100, 3*FU/5,back)
				
		if tics >= 2*TR
			hud.happyhour.falldown = true
			if tics == 2*TR
				hud.happyhour.its.yadd = FU
				hud.happyhour.happy.yadd = FU
				hud.happyhour.hour.yadd = FU
				hud.happyhour.face.yadd = FU
			end
		end
	
	else
		hud.happyhour.doingit = false
		hud.happyhour.scale = FU/20
		hud.happyhour.falldown = false
		hud.happyhour.its.yadd = 0
		hud.happyhour.happy.yadd = 0
		hud.happyhour.hour.yadd = 0
	
	end
	

end)

local blerp0 = {
	["ULTIMATE"] = 0,
	["SHOTGUN"] = 0,
	["HAPPYHOUR"] = 0,
	["HEART"] = 0,
}
local blerp1 = {
	["ULTIMATE"] = 0,
	["SHOTGUN"] = 0,
	["HAPPYHOUR"] = 0,
	["HEART"] = 0,
}

rawset(_G, "TakisHUDStuff", function(p)
	local takis = p.takistable
	local hud = takis.HUD
	local me = p.realmo
	
	if hud.menutext.tics
		hud.menutext.tics = $-1
	end
	
	if hud.cfgnotifstuff
		if takis.c3 then hud.cfgnotifstuff = 1 end
		hud.cfgnotifstuff = $-1
	end
	
	local bonus = takis.bonuses
	if bonus["shotgun"].tics
		bonus["shotgun"].tics = $-1
	end
	
	if bonus["ultimatecombo"].tics
		bonus["ultimatecombo"].tics = $-1
	end
	
	if bonus["happyhour"].tics
		bonus["happyhour"].tics = $-1
	end
	
	for k,val in ipairs(bonus.cards)
		if val.tics
			val.tics = $-1
		else
			table.remove(bonus.cards,k)
		end
	end
	
	
	if hud.heartcards.add > 0
		hud.heartcards.add = $*20/22
	end

	if hud.heartcards.shake > 0
		hud.heartcards.shake = $-1
	end
	
	if hud.statusface.evilgrintic > 0
		hud.statusface.evilgrintic = $-1
	end
	
	if hud.statusface.happyfacetic > 0
		hud.statusface.happyfacetic = $-1
	end

	if hud.statusface.painfacetic > 0
		hud.statusface.painfacetic = $-1
	end
	
	if (me.health)
	and not (takis.fakeexiting)
		if takis.heartcards <= (TAKIS_MAX_HEARTCARDS/TAKIS_MAX_HEARTCARDS)
			if not (leveltime%TR)
				hud.heartcards.shake = $+TAKIS_HEARTCARDS_SHAKETIME/2
			end
		
		elseif takis.heartcards <= (TAKIS_MAX_HEARTCARDS/2)
			if not (leveltime%(TR*2))
				hud.heartcards.shake = $+TAKIS_HEARTCARDS_SHAKETIME/3
			end
		
		elseif takis.heartcards == 0

			if not (leveltime%(3*TR/5))
				hud.heartcards.shake = $+TAKIS_HEARTCARDS_SHAKETIME/4
			end
		
		end
	end
	

	local dontdo = false
	if (HAPPY_HOUR.othergt)
		dontdo = takis.io.nohappyhour == 1
	end
	
	--happy hour hud and stuff
	if HAPPY_HOUR.time
	and not (dontdo)
		local tics = HAPPY_HOUR.time
		
		if (tics == 1)
			hud.ptsr.yoffset = 200*FU
		end
		
		if tics <= 2*TR
			if hud.ptsr.yoffset ~= 0
				local et = 2*TR
				hud.ptsr.yoffset = ease.outquad(( FU / et )*tics,200*FU,0)
			end
		else
			if hud.ptsr.yoffset ~= 0
				hud.ptsr.yoffset = 0
			end
		end
		
	end
	
	if (PTSR)
	and (HAPPY_HOUR.othergt)
		if (PTSR.gameover)
			
			local tics = PTSR.intermission_tics
			
			if tics <= 2*TR
				local et = 2*TR
				hud.ptsr.yoffset = ease.inquad(( FU / et )*tics,0,200*FU)
			else
				if hud.ptsr.yoffset ~= 200*FU
					hud.ptsr.yoffset = 200*FU
				end
			end
			
		end
	end
	
	if HAPPY_HOUR.timelimit
	
		if HAPPY_HOUR.timeleft
			local tics = HAPPY_HOUR.timeleft
			local time = hud.timeshake
			
			local dontdo = false
			if (HAPPY_HOUR.othergt)
				dontdo = takis.io.nohappyhour == 1
			end
	
			if tics <= (56*TR)
			and not (dontdo)
				hud.timeshake = $+1
				if not takis.sethappyend
					ChangeTakisMusic("hpyhre",false,p,0,0,3*MUSICRATE)
					takis.sethappyend = true
				end
				DoQuake(p,(time*FU)/50,1)
			end
			
		else
			takis.sethappyend = false
			hud.timeshake = 0
		end
		
	else
		hud.timeshake = 0
		takis.sethappyend = false
	end

	if hud.flyingscore.tics > 0
		local expectedtime = 2*TR
		local tics = ((2*TR)+1)-hud.flyingscore.tics
		
		local backx = 15*FU
		local backy = 70*FU
		
		hud.flyingscore.x = ease.inexpo(( FU / expectedtime )*tics,
		backx+5*FU+hud.combo.patchx, 
		285*FU
		)
		hud.flyingscore.y = ease.inexpo(( FU / expectedtime )*tics,
		backy+7*FU, 
		15*FU
		)
		
		hud.flyingscore.tics = $-1
	else
		if hud.flyingscore.num
			hud.flyingscore.scorenum = $+hud.flyingscore.num
			hud.flyingscore.num = 0
		end
		hud.flyingscore.lastscore = 0
	end

	if hud.rank.grow > 0
		hud.rank.grow = $/2
	end

	TakisAnimateHappyHour(p)
	
	local random = dorandom()

	local score = p.score
	if hud.flyingscore.tics
		score = p.score-hud.flyingscore.lastscore
	end
	random = dorandom()
	
	if not paused
		if score > hud.flyingscore.scorenum
			if (score-hud.flyingscore.scorenum >= 5)
				hud.flyingscore.scorenum = $+5
				
				random = dorandom()
				hud.flyingscore.xshake = getdec(random) --v.RandomFixed()*random
				random = dorandom()
				hud.flyingscore.yshake = getdec(random) --v.RandomFixed()*random
				
				for i = 1,1000
					if (score-hud.flyingscore.scorenum >= 5*(i+1))
						
						hud.flyingscore.scorenum = $+5
						
						random = dorandom(v)
						hud.flyingscore.xshake = $+getdec(random) --FixedDiv(v.RandomFixed(),2*FU)*random
						random = dorandom(v)
						hud.flyingscore.yshake = $+getdec(random) --FixedDiv(v.RandomFixed(),2*FU)*random
					
					end
				end
			else
				hud.flyingscore.scorenum = $+score-hud.flyingscore.scorenum
			end
		elseif score < hud.flyingscore.scorenum
			if (hud.flyingscore.scorenum-score >= 5)
				hud.flyingscore.scorenum = $-5
				
				random = dorandom()
				hud.flyingscore.xshake = -getdec(random)
				random = dorandom()
				hud.flyingscore.yshake = -getdec(random)
				
				for i = 1,1700
					if (hud.flyingscore.scorenum-score >= 5*(i+1))
						
						hud.flyingscore.scorenum = $-5
						
						random = dorandom()
						hud.flyingscore.xshake = $-getdec(random) --FixedDiv(v.RandomFixed(),2*FU)*random
						random = dorandom()
						hud.flyingscore.yshake = $-getdec(random) --FixedDiv(v.RandomFixed(),2*FU)*random
					
					end
				end
			else
				hud.flyingscore.scorenum = $-(hud.flyingscore.scorenum-score)
			end
		end
	end
		
	hud.flyingscore.xshake = $/3
	hud.flyingscore.yshake = $/3
	
	if hud.combo.scale ~= 0
		hud.combo.scale = $*8/10
	end
	
	if hud.combo.fillnum ~= takis.combo.time*FU
	and takis.combo.time
		hud.combo.fillnum = ease.outquad(FU/5,$,takis.combo.time*FU)
	end
	
	if hud.combo.fillnum <= TAKIS_MAX_COMBOTIME*FU/4
		hud.combo.shake = (P_RandomFixed())*3/2
	elseif hud.combo.fillnum <= TAKIS_MAX_COMBOTIME*FU/2
		hud.combo.shake = P_RandomFixed()*2/3
	else
		if hud.combo.shake ~= 0
			if hud.combo.shake > 0
				hud.combo.shake = $-1
			else
				hud.combo.shake = $+1
			end
		else
			hud.combo.shake = 0
		end
	end

	hud.showingachs = 0
	for k,va in ipairs(hud.steam)
		if va == nil
			continue
		end
		
		local enum = va.enum
		
		if hud.showingachs & enum
			table.remove(hud.steam,k)
			return
		end
		
		hud.showingachs = $|enum
		
		local t = TAKIS_ACHIEVEMENTINFO
		local x = va.xadd
		if va.xadd ~= 0
			va.xadd = $*2/3 --ease.outquad(( FU / et )*(takis.HUD.steam.tics-(3*TR)), 9324919, 0)
		end
		va.tics = $-1
				
		if hud.steam[k].tics == 0
			table.remove(hud.steam,k)
		end
		
	end
	
	if hud.funny.tics
		hud.funny.y = $*4/5
		hud.funny.tics = $-1
	end

--hud stuff end
--hudstuff end

end)

--the treaqel
local function collide3(mo1,mo2,range)
	--we're over
	if mo1.z-(range*P_MobjFlip(mo1)) > mo2.height+mo2.z then return false end
	--they're over
	if mo2.z > mo1.height+mo1.z+(range*P_MobjFlip(mo1)) then return false end
	return true
end
local function otherwind(me)
	local r = me.radius/FU
	local wind = P_SpawnMobj(
		me.x + (P_RandomRange(r, -r) * FRACUNIT),
		me.y + (P_RandomRange(r, -r) * FRACUNIT),
		me.z + (P_RandomKey(me.height / FRACUNIT) * FRACUNIT) - me.height/2,
		MT_THOK)
	wind.scale = me.scale
	wind.fuse = wind.tics
	wind.sprite = SPR_RAIN
	wind.renderflags = $|RF_PAPERSPRITE
	wind.angle = me.angle
	wind.spritexscale,wind.spriteyscale = me.scale,me.scale
	wind.rollangle = ANGLE_90
	wind.source = me
	wind.blendmode = AST_ADD
end
-- thinkers for each transfo
rawset(_G, "TakisTransfoHandle", function(p,me,takis)
	if (takis.transfo & TRANSFO_BALL)
		if me.state ~= S_PLAY_ROLL
			--BUT, if we're trying to continue slide, keep the ball
			if (takis.justHitFloor and takis.c2)
				me.state = S_PLAY_ROLL
				p.pflags = $|PF_SPINNING
				takis.ballretain = 2
				takis.noability = $|NOABIL_SLIDE
			else
				if takis.ballretain == 0
					S_StopSoundByID(me,sfx_trnsfo)
					S_StartSound(me,sfx_shgnk)
					takis.transfo = $ &~TRANSFO_BALL
					p.thrustfactor = skins[TAKIS_SKIN].thrustfactor
				end
			end
		else
			takis.afterimaging = false
			takis.clutchingtime = 0
			takis.noability = $|NOABIL_SLIDE
			P_ButteredSlope(me)
			P_ButteredSlope(me)
			if (takis.onGround)
				p.thrustfactor = skins[TAKIS_SKIN].thrustfactor*10
				
				takis.dustspawnwait = $+FixedDiv(takis.accspeed,60*FU)
				while takis.dustspawnwait > FU
					takis.dustspawnwait = $-FU
					--xmom code
					if (takis.onGround)
					and not (leveltime % 6)
					and (takis.accspeed >= 25*FU)
						local d1 = P_SpawnMobjFromMobj(me, -20*cos(p.drawangle + ANGLE_45), -20*sin(p.drawangle + ANGLE_45), 0, MT_TAKIS_CLUTCHDUST)
						local d2 = P_SpawnMobjFromMobj(me, -20*cos(p.drawangle - ANGLE_45), -20*sin(p.drawangle - ANGLE_45), 0, MT_TAKIS_CLUTCHDUST)
						--d1.scale = $*2/3
						d1.destscale = FU/10
						d1.angle = R_PointToAngle2(me.x+me.momx, me.y+me.momy, d1.x, d1.y) --- ANG5

						--d2.scale = $*2/3
						d2.destscale = FU/10
						d2.angle = R_PointToAngle2(me.x+me.momx, me.y+me.momy, d2.x, d2.y) --+ ANG5
					end
				end
			else
				p.thrustfactor = skins[TAKIS_SKIN].thrustfactor
			end
			
		end
		if takis.ballretain then takis.ballretain = $-1 end
	end
	if (takis.transfo & TRANSFO_PANCAKE)
		if takis.pancaketime
			if (me.momz*takis.gravflip <= 0)
			and (takis.jump)
			and not takis.hammerblastdown
				me.momz = $*21/23
			end
			takis.pancaketime = $-1
		else
			S_StopSoundByID(me,sfx_trnsfo)
			S_StartSound(me,sfx_shgnk)
			takis.transfo = $ &~TRANSFO_PANCAKE
		end
	end
	if (takis.transfo & TRANSFO_ELEC)
		if takis.electime
			if (leveltime % 3) == 0
				me.color = SKINCOLOR_SUPERGOLD1
			else
				me.color = SKINCOLOR_JET
			end
			
			local rad = me.radius/FRACUNIT
			local hei = me.height/FRACUNIT
			local x = P_RandomRange(-rad,rad)*FRACUNIT
			local y = P_RandomRange(-rad,rad)*FRACUNIT
			local z = P_RandomRange(0,hei)*FRACUNIT
			local spark = P_SpawnMobjFromMobj(me,x,y,z,MT_SOAP_SUPERTAUNT_FLYINGBOLT)
			spark.tracer = me
			spark.state = P_RandomRange(S_SOAP_SUPERTAUNT_FLYINGBOLT1,S_SOAP_SUPERTAUNT_FLYINGBOLT5)			
			spark.blendmode = AST_ADD
			spark.color = P_RandomRange(SKINCOLOR_SUPERGOLD1,SKINCOLOR_SUPERGOLD5)
			spark.angle = p.drawangle+(FixedAngle( P_RandomRange(-337,337)*FRACUNIT ))

			me.colorized = true
			
			if (me.state ~= S_PLAY_DEAD)
				me.state = S_PLAY_DEAD
				me.frame = A
				me.sprite2 = SPR2_FASS
			end
			
			--so the instathrust doesnt move us by an inch
			p.cmd.forwardmove = max($,10)
			
			if (takis.justHitFloor)
				local range = 235
				P_SetObjectMomZ(me,4*FU)
				p.drawangle = $+(FixedAngle(
					P_RandomRange(-range,range)*FU+P_RandomFixed()
					)
				)
				P_InstaThrust(me,p.drawangle,14*me.scale)
			end
			
			if not takis.onGround
				me.momz = $-(me.scale/2*takis.gravflip)
			end
			
			p.powers[pw_nocontrol] = 2
			p.pflags = $|PF_FULLSTASIS
			takis.electime = $-1
		else
			me.color = p.skincolor
			me.colorized = false
			P_MovePlayer(p)
			takis.transfo = $ &~TRANSFO_ELEC
		end
	end
	if (takis.transfo & TRANSFO_TORNADO)
		local sfx_nado = sfx_tknado
		local sfx_nado2 = sfx_tkfndo
		
		if (takis.nadocount > 0)
			takis.noability = $|NOABIL_ALL
			takis.thokked = true
			takis.nadotime = $+2
			
			takis.nadoang = $+FixedAngle(20*FU)
			local nadodist = 30
			local lastspin = takis.nadouse
			
			local speed = 30*me.scale
			
			nadodist = $*2
			local waveforce = FU*5
			local ay = FixedMul(waveforce,sin(takis.nadotime*2*ANG2))
			local thok = P_SpawnMobjFromMobj(me,
				me.momx+nadodist*cos(me.angle+takis.nadoang),
				me.momy+nadodist*sin(me.angle+takis.nadoang),
				2*me.scale+FixedMul(ay,me.scale),
				MT_THOK
			)
			thok.angle = me.angle+takis.nadoang+ANGLE_90
			thok.renderflags = $|RF_PAPERSPRITE
			thok.height,thok.radius = me.height,me.radius
			thok.tics = 3
			thok.flags2 = $|MF2_DONTDRAW
			nadodist = $/2
			
			otherwind(thok)
			otherwind(thok)
			
			
			if (takis.use)
			or (not takis.onGround and takis.accspeed >= 45*FU)
				takis.nadoang = $+FixedAngle(10*FU)
				takis.nadotime = $+3
				otherwind(thok)
				otherwind(thok)
				
				speed = 50*me.scale
				if (takis.use == 1)
					S_StopSoundByID(me,sfx_nado)
				end
				--pull stuff in!
				local px = me.x+(me.momx)
				local py = me.y+(me.momy)
				local br = 350*me.scale
				local rbr = br
				local h = 5
				
				if (TAKIS_DEBUGFLAG & DEBUG_BLOCKMAP)
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
				searchBlockmap("objects", function(me, found)
					if found and found.valid
					and (found.health)
						local zrange = 100
						if (found.type ~= MT_EGGMAN_BOX)
						and (collide3(me,found,zrange*me.scale))
						--the real range
						and (FixedHypot(found.x-me.x,found.y-me.y) <= rbr)
							if ((found.flags & (MF_ENEMY|MF_BOSS))
							or (found.takis_flingme))
							or (found.type == MT_PLAYER)
								local source = found
								local enemy = thok
								local zdist = enemy.z - source.z
								local enx = enemy.x+(nadodist*cos(me.angle+takis.nadoang))
								local eny = enemy.y+(nadodist*sin(me.angle+takis.nadoang))
								if P_MobjFlip(source) == -1
									zdist = (enemy.z+enemy.height)-(source.z+source.height)
								end
								local dist = FixedHypot(FixedHypot(enx - source.x,eny - source.y),zdist)
								local speed = FixedMul(FixedDiv(dist,rbr),rbr)/15
								
								local cando = true
								if (source.player)
									local p2 = source.player
									if (P_PlayerInPain(p2))
									or (p2.powers[pw_flashing])
									or not (CanPlayerHurtPlayer(p,p2))
										cando = false
									end
								end
								if cando
									source.momx = $+FixedMul(FixedDiv(enx - source.x,dist),FixedMul(speed,source.scale))
									source.momy = $+FixedMul(FixedDiv(eny - source.y,dist),FixedMul(speed,source.scale))
									source.momz = $+FixedMul(FixedDiv(zdist,dist),FixedMul(speed,source.scale))
									
									if (source.player)
										source.state = S_PLAY_PAIN
										if (dist <= nadodist*FU*3)
											--?? please??
											TakisAddHurtMsg(source.player,HURTMSG_NADO)
											TakisAddHurtMsg(source.player,HURTMSG_NADO)
											P_DamageMobj(source,enemy,enemy)
											P_Thrust(source,R_PointToAngle2(
												source.x,source.y, enx,eny
												),
												-26*source.scale
											)
										end
									end
								end
							end
						end
					end
				end, me, px-br, px+br, py-br, py+br)	
				
			end
			
			if lastspin
			and takis.use == 0
				S_StopSoundByID(me,sfx_nado2)
			end
			
			if not (takis.onGround)
				p.thrustfactor = skins[TAKIS_SKIN].thrustfactor/4
			else
				p.thrustfactor = skins[TAKIS_SKIN].thrustfactor
			end
			
			p.normalspeed = FixedDiv(speed,me.scale)
			P_MovePlayer(p)
			
			if not (takis.use)
				if not S_SoundPlaying(me,sfx_nado)
					S_StartSound(me,sfx_nado)
				end
			else
				if not S_SoundPlaying(me,sfx_nado2)
					S_StartSound(me,sfx_nado2)
				end
			end
			
			local state = S_PLAY_TAKIS_TORNADO
			if (p.playerstate == PST_LIVE)
				if (me.state ~= state)
					me.state = state
				else
					p.powers[pw_strong] = $|STR_SPIKE|STR_WALL
				end
			end
			
			takis.clutchingtime = 0
			takis.dustspawnwait = $+FixedDiv(takis.accspeed,50*FU)
			while takis.dustspawnwait > FU
				takis.dustspawnwait = $-FU
				--xmom code
				if (takis.onGround)
				and not (leveltime % 10)
				and (takis.accspeed >= 45*FU)
					local d1 = P_SpawnMobjFromMobj(me, -20*cos(p.drawangle + ANGLE_45), -20*sin(p.drawangle + ANGLE_45), 0, MT_TAKIS_CLUTCHDUST)
					local d2 = P_SpawnMobjFromMobj(me, -20*cos(p.drawangle - ANGLE_45), -20*sin(p.drawangle - ANGLE_45), 0, MT_TAKIS_CLUTCHDUST)
					--d1.scale = $*2/3
					d1.destscale = FU/10
					d1.angle = R_PointToAngle2(me.x+me.momx, me.y+me.momy, d1.x, d1.y) --- ANG5

					--d2.scale = $*2/3
					d2.destscale = FU/10
					d2.angle = R_PointToAngle2(me.x+me.momx, me.y+me.momy, d2.x, d2.y) --+ ANG5
				end
			end
			
			local notransfo = TRANSFO_BALL
			if (takis.transfo & notransfo)
				takis.transfo = $ &~notransfo
			end
			
			if takis.nadotic > 0 then takis.nadotic = $-1 end
		else
			S_StopSoundByID(me,sfx_nado)
			S_StopSoundByID(me,sfx_nado2)
			takis.nadoang = 0
			takis.nadotime = 0
			
			p.thrustfactor = skins[TAKIS_SKIN].thrustfactor
			p.normalspeed = skins[TAKIS_SKIN].normalspeed
			
			if (takis.nadocrash)
				takis.stasistic = 2
				takis.noability = NOABIL_ALL
				local state = S_PLAY_DEAD
				if (me.state ~= state)
					me.state = state
				end
				
				if takis.nadocrash == 1
					S_StartAntonOw(me)
				end
				takis.nadocrash = $-1
			else
				P_DoJump(p,true)
				me.momz = $/10
				S_StartSound(me,sfx_shgnk)
				takis.transfo = $ &~TRANSFO_TORNADO		
			end
		end
		
	end
	
end)

rawset(_G, "TakisTransfo", function(p,me,takis)
	
	if (me.standingslope)
		if me.prevz == nil then return end
		
		if ((me.prevz - me.z)*takis.gravflip >= 7*me.scale)
		and (me.state == S_PLAY_TAKIS_SLIDE)
		and (p.pflags & PF_SPINNING)
		and not (takis.transfo & TRANSFO_BALL)
		and (takis.c2)
		and (takis.accspeed >= 30*FU)
			S_StartSound(me,sfx_trnsfo)
			me.state = S_PLAY_ROLL
			takis.transfo = $|TRANSFO_BALL
		end
	end
	
	if (takis.c3 == 1)
	--and not multiplayer
		takis.transfo = $|TRANSFO_TORNADO
		takis.nadocount = 3
	end
	
	TakisTransfoHandle(p,me,takis)
end)

rawset(_G, "TakisDoShorts", function(p,me,takis)
	
	TakisHUDStuff(p)
	
	if (takis.noability)
		takis.noability = 0
	end
	
	--fake pw_flashing
	if takis.fakeflashing > 0
		p.powers[pw_flashing] = takis.fakeflashing
		takis.fakeflashing = $-1
	end
	
	if takis.ticsforpain > 0
		if me.state ~= S_PLAY_PAIN
			me.state = S_PLAY_PAIN
		end
		takis.ticsforpain = $-1
	end
	
	--no more spinning while jumping
	if p.pflags & PF_JUMPED
		p.pflags = $ &~PF_SPINNING
	end

	--clutch stuff
	if takis.clutchtime > 0
		takis.clutchtime = $-1
	elseif takis.clutchingtime == 0
		takis.clutchcombo = 0
	end
	
	if me.eflags & MFE_SPRUNG
		takis.dived = false
		takis.thokked = false
		takis.inFakePain = false
	end
	
	if not (p.pflags & PF_SPINNING)
	or not (takis.transfo & TRANSFO_TORNADO)
		if (p.thrustfactor ~= skins[TAKIS_SKIN].thrustfactor)
			p.thrustfactor = skins[TAKIS_SKIN].thrustfactor
		end
	end
	
	TakisTransfo(p,me,takis)
	
	takis.attracttarg = nil
	local t = P_LookForEnemies(p,true,false)
	if (p.powers[pw_shield]&SH_NOSTACK) == SH_ATTRACT
	and t and t.valid
	and not (me.state >= 59 and me.state <= 64)
	and not (takis.noability & NOABIL_SHIELD)
		takis.attracttarg = t
		P_SpawnLockOn(p, t, S_LOCKON2)
	else
		takis.attracttarg = nil
	end
	
	if ((takis.hammerblasthitbox) and (takis.hammerblasthitbox.valid))
		takis.hammerblasthitbox.scale = me.scale
	end
	
	if takis.accspeed <= FU*8
		takis.clutchtime = 0
		takis.clutchcombo = 0
		takis.clutchingtime = 0
	end
	
	if (p.pflags & PF_SPINNING)
		if takis.slidetime
			takis.slidetime = $+1
		end
	else
		takis.slidetime = 0
	end
	
	--cancel slide when slow
	if (p.pflags & PF_SPINNING)
	and takis.accspeed <= 24*FU
	and takis.slidetime >= TR
	--try to sustain our slide if we're holding c2
	and not (takis.c2)
		p.pflags = $ &~PF_SPINNING
		if takis.accspeed >= p.runspeed
			me.state = S_PLAY_RUN
		else
			me.state = S_PLAY_WALK
		end
	end

	if takis.stasistic
		p.pflags = $|PF_FULLSTASIS
		takis.stasistic = $-1
	end
	
	if takis.clutchcombotime > 0
		if takis.clutchcombotime == 1
			takis.clutchcombo = 0
		end
		takis.clutchcombotime = $-1
	end
	
	if takis.clutchingtime < 0
		takis.clutchingtime = 0
	end
	
	if takis.combo.outrotics
		takis.combo.outrotics = $-1
		if takis.combo.gravity == 0
			takis.combo.gravity = $-(FU)
		else
			takis.combo.gravity = $*6/5
		end
	else
		if (takis.combo.gravity ~= 0)
			takis.combo.gravity = 0
		end
	end
	
	if takis.combo.outrotointro
		takis.combo.outrotointro = $*4/5
	end
	
	if (p.powers[pw_sneakers] > 0)
		/*
		if takis.shotgunned
			if not takis.critcharged
				S_StartSound(me,sfx_tacrtc)
			end
				
			takis.critcharged = true
			
			if p.powers[pw_sneakers] == 1
				S_StartSound(me,sfx_tacrtd)
			end
			
		end
		*/
		
		local rad = me.radius/FRACUNIT
		local hei = me.height/FRACUNIT
		local x = P_RandomRange(-rad,rad)*FRACUNIT
		local y = P_RandomRange(-rad,rad)*FRACUNIT
		local z = P_RandomRange(0,hei)*FRACUNIT
		local spark = P_SpawnMobjFromMobj(me,x,y,z,MT_SOAP_SUPERTAUNT_FLYINGBOLT)
		spark.tracer = me
		spark.state = P_RandomRange(S_SOAP_SUPERTAUNT_FLYINGBOLT1,S_SOAP_SUPERTAUNT_FLYINGBOLT5)			
		spark.blendmode = AST_ADD
		spark.color = me.color
		spark.angle = p.drawangle+(FixedAngle( P_RandomRange(-337,337)*FRACUNIT ))
	end
	
	if p.playerstate == PST_REBORN
		if me.rollangle then me.rollangle = 0 end
	end
	
	local lastspeed = takis.accspeed
	
	local spd = 6*skins[me.skin].runspeed/5
	if (p.powers[pw_carry] == CR_NIGHTSMODE)
		spd = 23*FU
		takis.accspeed = abs(FixedHypot(FixedHypot(me.momx,me.momy),me.momz))
	end
	
	--wind effect
	for i = 1,10
		if takis.accspeed > (spd*2)*i
			TakisDoWindLines(me)
			for j = 1,i
				TakisDoWindLines(me)
			end
		end
	end
	
	if takis.accspeed >= 8*spd/5
		TakisDoWindLines(me)
	elseif takis.accspeed >= 7*spd/5
		if not (leveltime % 2)
			TakisDoWindLines(me)
		end
	elseif takis.accspeed >= 6*spd/5
		if not (leveltime % 5)
			TakisDoWindLines(me)
		end
	elseif takis.accspeed >= spd
		if not (leveltime % 7)
			TakisDoWindLines(me)
		end
	end
	
	--nights stuff
	if ((p.drilltimer
	and p.drillmeter
	and not p.drilldelay)
	and (takis.jump)
	and (me.state == S_PLAY_NIGHTS_DRILL)
	and (takis.accspeed >= 23*FU)
	and (p.powers[pw_carry] == CR_NIGHTSMODE))
		if not (takis.drilleffect and takis.drilleffect.valid)
			local x,y = cos(p.drawangle),sin(p.drawangle)
			takis.drilleffect = P_SpawnMobjFromMobj(me,17*x,17*y,0,MT_TAKIS_DRILLEFFECT)
			local d = takis.drilleffect
			d.tracer = me
			d.angle = p.drawangle
			d.dispoffset = 2
			p.powers[pw_strong] = $|STR_PUNCH|STR_STOMP|STR_UPPER
		end
		if not (leveltime%2)
			TakisCreateAfterimage(p,me)
		end
	else
		if (takis.drilleffect and takis.drilleffect.valid)
			P_RemoveMobj(takis.drilleffect)
		end
		p.powers[pw_strong] = $ &~(STR_PUNCH|STR_STOMP|STR_UPPER)
		if (p.powers[pw_carry] == CR_NIGHTSMODE)
			takis.afterimaging = false
			takis.clutchingtime = 0
		end
	end
	
	if p.powers[pw_carry] ~= CR_NIGHTSMODE
		takis.accspeed = lastspeed
	end
	
	if takis.yeahed
	and me.health
		if me.sprite2 ~= SPR2_THUP
			me.frame = A
			me.sprite2 = SPR2_THUP
		end
		
		takis.tauntid = 0
		takis.taunttime = 0
		
		takis.HUD.statusface.happyfacetic = 2
		
		if P_RandomChance(FRACUNIT-((p.exiting*655)+36))
			me.frame = B
		else
			me.frame = A
		end
	end

	if me.sprite2 == SPR2_THUP
		takis.tauntid = 0
		takis.taunttime = 0
		
		takis.HUD.statusface.happyfacetic = 2
	
	end
	
	if takis.yeahwait
		takis.yeahwait = $-1
		if (p.pflags & PF_FINISHED)
			-- shouldve just kept this at 99 :/
			-- thanks for the help SMS Alfredo!
			p.exiting = 99
		end
	end
	
	takis.quakeint = 0
	for k,v in ipairs(takis.quake)
		if v == nil
			continue
		end
		
		local q = takis.quake
		
		if v.tics
			v.intensity = $-v.minus
			takis.quakeint = $+v.intensity
			v.tics = $-1
		else
			table.remove(q,k)
		end
	end
	if takis.quakeint
	and displayplayer == p
	and takis.io.quakes
		P_StartQuake(takis.quakeint,1)
	end
	
	if takis.crushtime ~= 0
		if not (takis.transfo & TRANSFO_PANCAKE)
			takis.crushtime = $-1
		end
	else
		takis.timescrushed = 0
	end
	
	if takis.accspeed >= 60*FU
		if (me.state == S_PLAY_WALK or me.state == S_PLAY_RUN)
		and (p.playerstate == PST_LIVE)
			takis.goingfast = true
			takis.wentfast = 10*TR
		end
	elseif (takis.heartcards <= (TAKIS_MAX_HEARTCARDS/6 or 1))
	and not (takis.fakeexiting)
	and (p.playerstate == PST_LIVE)
		takis.goingfast = true
		takis.wentfast = 3
	else
		takis.goingfast = false
	end
	
	--spawn sweat mobj
	if takis.wentfast ~= 0
		if not ((takis.sweat) and (takis.sweat.valid))
			takis.sweat = P_SpawnMobjFromMobj(me,0,0,0,MT_TAKIS_SWEAT)
			takis.sweat.tracer = me
		end
		takis.wentfast = $-1
	else
		if ((takis.sweat) and (takis.sweat.valid))
		--dont remove the sweat if its still animating
		and ((takis.sweat.state == S_TAKIS_SWEAT2) or (takis.sweat.state == S_TAKIS_SWEAT4))
			P_RemoveMobj(takis.sweat)
		end
	end
	
	
	if takis.inWater
		if ((takis.sweat) and (takis.sweat.valid))
			P_RemoveMobj(takis.sweat)
			takis.wentfast = 0
		end
	end
	
	--elfilin cheers refill combo
	if (p.elfride)
	and (p.elfride.cheerdur/5 > 0)
		TakisGiveCombo(p,takis,false,true)
	end
	
	if P_CheckDeathPitCollide(me)
	and not me.health
		me.flags = $|MF_NOCLIPHEIGHT
	end

	--ffoxd's smoothspintrilas
	if not me.prevz
	or not me.prevleveltime 
	or (me.prevleveltime ~= leveltime - 1) then
	   me.prevz = me.z
	end

	local rmomz = me.z - me.prevz
	me.prevz = me.z
	me.prevleveltime = leveltime
	
	takis.rmomz = rmomz
	
	--animate slide
	if me.state == S_PLAY_TAKIS_SLIDE
	and me.health
	and (me.sprite2 == SPR2_SLID)
		
		/*
		local speed = FixedDiv(FixedMul(takis.accspeed,me.scale),FixedMul(me.scale,me.movefactor))
		if speed > 16<<FRACBITS
			me.tics = 1
		else
			me.tics = 2
		end
		*/
		me.frame = ((takis.accspeed/FU) % 2)
	end
	
	if takis.fakesprung
		me.eflags = $ &~MFE_SPRUNG
		takis.fakesprung = false
	end
		
	--happy hour hud and stuff
	local dontdo = false
	if (HAPPY_HOUR.othergt)
		dontdo = takis.io.nohappyhour == 1
	end
	
	if HAPPY_HOUR.time
	and not (dontdo)
		local tics = HAPPY_HOUR.time
		
		if (tics == 1)
			S_StartSound(nil,sfx_mclang)
			TakisGiveCombo(p,takis,false,true)
		end
		
		if (me.health)
		--how convienient that 8 tics just so happens to be
		--exactly 22 centiseconds!
		and (tics == 8)
			if (p.happyhourscream
			and p.happyhourscream.skin == me.skin)
				S_StartSound(nil,p.happyhourscream.sfx,p)
			end
		end
		
		DoQuake(p,2*FU,1,0)
		
		if (tics <= TR)
			DoQuake(p,(72-(2*tics))*FU,1,0)
		end
		
		/*
		if not (takis.isMusicOn)
		and not (leveltime)
			local t = tics % TR
			local tl = JISK_TIMELEFT or PTJE.timeleft
			
			local istimelimit = false
			if ( ((CV_PTJE) and (CV_PTJE.timelimit.value))
			or ((JISK_TIMELIMIT) and (JISK_TIMELIMIT.value)) )
				istimelimit = true
			else
				istimelimit = false
			end
			
			if ((tl <= 56*TR)
			and (istimelimit))
				if t == 0
					S_StartSound(nil,sfx_tactic,p)
				elseif t == (TR/4)
					S_StartSound(nil,sfx_tactoc,p)
				elseif t == (TR/2)
					S_StartSound(nil,sfx_tactic,p)
				elseif t == (TR*3/4)
					S_StartSound(nil,sfx_tactoc,p)
				end				
			else
				if t == 0
					S_StartSound(nil,sfx_tactic,p)
				elseif t == 16
					S_StartSound(nil,sfx_tactoc,p)
				end
			end
		end
		*/
	end
	
	if takis.glowyeffects
		
		takis.afterimaging = true
		
		--ffoxd's smooth spintrails
		
		local freq = FRACUNIT*30
		local mospeed = R_PointToDist2(0, 0, R_PointToDist2(0, 0, me.momx, me.momy), me.momz)
		local dist = (mospeed/freq)
		
		if dist >= 25
			dist = 25
		end

		-- The loop, repeats until it spawns all the thok objects.			
		for i = dist, 1, -1 do

		--	local ghost = P_SpawnMobjFromMobj(me, (me.momx/dist)*i, (me.momy/dist)*i, (me.momz/dist)*i, MT_THOK)
			local ghost = P_SpawnGhostMobj(me)
			ghost.scale = 7*me.scale/5
			ghost.fuse = 8
			
		/*
			ghost.skin = me.skin
			ghost.sprite = me.sprite
			ghost.sprite2 = me.sprite2
			ghost.state = me.state
			ghost.frame = me.frame|TR_TRANS50
			ghost.angle = p.drawangle
		*/	
			ghost.color = me.color
			ghost.colorized = true
			ghost.destscale = me.scale/3
			ghost.blendmode = AST_ADD
			P_SetOrigin(ghost, 
			ghost.x-(me.momx/dist)*i, 
			ghost.y-(me.momy/dist)*i, 
			ghost.z-(me.momz/dist)*i
			)
			
		end
		
		takis.glowyeffects = $-1
	end
	
	--spin steer
	if not (takis.transfo & TRANSFO_BALL)
		if ((p.pflags & PF_SPINNING)
		and not (p.pflags & PF_STARTDASH)
		and (takis.onGround))
			p.thrustfactor = skins[TAKIS_SKIN].thrustfactor*3
		else
			p.thrustfactor = skins[TAKIS_SKIN].thrustfactor
		end
	end
	
	for p2 in players.iterate
		if p2 == p
			continue
		end
		
		local m2 = p2.realmo
		
		if ((m2) and (m2.valid))
		and (p2.takistable)
		and m2.skin == TAKIS_SKIN
			local dx = me.x-m2.x
			local dy = me.y-m2.y
			
			--in range!
			if FixedHypot(dx,dy) <= TAKIS_TAUNT_DIST
			and (not takis.taunttime)				
				if p2.takistable.tauntjoinable
					--this is stupid,,,, :/
					local tics = 6
					if ((takis.tauntjoin) and (takis.tauntjoin.valid))
					and not (takis.accspeed or me.momz)
					and me.health
						takis.tauntjoin.tics = tics
					else
						takis.tauntjoin = P_SpawnMobjFromMobj(me, 0, 0, me.height*2, MT_TAKIS_TAUNT_JOIN)
						takis.tauntjoin.target = me
					end
				end
			end
		end
	end
	
	if (takis.shotgunned)
		takis.afterimaging = false
		takis.shotguntime = $+1
		if not (takis.transfo & TRANSFO_SHOTGUN)
			TakisDeShotgunify(p)
		end
	else		
		takis.shotguntime = 0
	end
	
	if (takis.shotguncooldown)
		takis.shotguncooldown = $-1
	end
	
	if (takis.timesincelastshot)
		takis.timesincelastshot = $-1
	end
	
	if (takis.dropdashstaletime)
		takis.dropdashstaletime = $-1
	elseif takis.dropdashstale 
		takis.dropdashstale = 0
	end
	
	if p.soaptable
		if p.soaptable.bananapeeled == 1
			TakisAwardAchievement(p,ACHIEVEMENT_BANANA)
		end
	end
	
	if p.skincolor == SKINCOLOR_SALMON
	and takis.lastskincolor ~= SKINCOLOR_SALMON
		TakisAwardAchievement(p,ACHIEVEMENT_RAKIS)
	end
	
	if TAKIS_NET.numdestroyables
		if takis.thingsdestroyed >= TAKIS_NET.numdestroyables
		and (takis.lastdestroyed < TAKIS_NET.numdestroyables)
		and (p.powers[pw_carry] ~= CR_NIGHTSMODE)
			TakisAwardAchievement(p,ACHIEVEMENT_FULLCOMBO)
		end
	end

	if takis.clutchspamtime
		takis.clutchspamtime = $-1
	elseif takis.clutchspamcount
		takis.clutchspamcount = 0
	end

	if takis.combo.dropped
	and takis.combo.awardable
		takis.combo.awardable =  false
	end
	
	if takis.afterimaging
	or (p.powers[pw_invulnerability]
	or p.powers[pw_super] or takis.hammerblasstdown)
		p.powers[pw_strong] = $|STR_SPIKE
	else
		p.powers[pw_strong] = $ &~STR_SPIKE
	end

	if p.name
		if (p.ctfteam == 1)
			p.ctfnamecolor = "\x85"+p.name+"\x80"
		elseif (p.ctfteam == 2)
			p.ctfnamecolor = "\x84"+p.name+"\x80"
		else
			p.ctfnamecolor = p.name
		end
	end
	
	--no continue state
	if (me.sprite2 == SPR2_CNT1)
	or (me.sprite2 == SPR2_CNT2)
	or (me.sprite2 == SPR2_CNT3)
	or (takis.heartcards == 0 and me.health and not p.exiting)
		P_KillMobj(me)
	end
	
	if (takis.heartcards > TAKIS_MAX_HEARTCARDS)
		takis.heartcards = TAKIS_MAX_HEARTCARDS
	end
	
	if takis.inSRBZ
		takis.noability = NOABIL_SPIN|NOABIL_DIVE
	end
	
	if (takis.afterimaging
	and takis.shotgunned)
		takis.afterimaging = false
	end
	
	if (takis.wavedashcapable)
	or (p.gotflag)
		takis.noability = $|NOABIL_HAMMER
	end
	
	if (takis.shotguntuttic)
		takis.shotguntuttic = $-1
	end
	
	TakisNoShield(p)
	
	if (p.powers[pw_shield]&SH_NOSTACK == SH_FIREFLOWER)
		if (me.color ~= SKINCOLOR_BONE)
			me.color = SKINCOLOR_BONE
		end
		if not (leveltime % 3)
			A_BossScream(me, 1, MT_FIREBALLTRAIL)
		end
	end
	
	if (HAPPY_HOUR.othergt)
	and (HAPPY_HOUR.overtime)
	and (HAPPY_HOUR.happyhour)
		if (takis.heartcards > 1)
			takis.heartcards = 1
		end
		p.powers[pw_sneakers] = 3
	end
	
	if (me.sprite2 == SPR2_FASS)
		me.frame = (leveltime/3%2)
	end
	
	takis.hhexiting = false
	if (PTSR)
	and (HAPPY_HOUR.othergt)
		if (p.lap_hold)
		and (PTSR.laphold)
			if (p.lap_hold == PTSR.laphold-1)
				TakisGiveCombo(p,takis,false,true)
			end
		end
		if (PTSR.gameover)
			takis.hhexiting = true
			takis.noability = NOABIL_ALL
			
			if (p.playerstate == PST_LIVE and not p.spectator)
				if not (p.pflags & PF_FINISHED)
					p.pflags = $|PF_FINISHED
				end
				p.exiting = 100
			end
			
		end
	end
	
	if (me.pizza_in)
	and me.state ~= S_PLAY_DEAD
		if not (takis.pizzastate)
			takis.pizzastate = me.state
		end
		me.state = S_PLAY_DEAD
		me.frame = A
		me.sprite2 = SPR2_FASS
	end
	
	if (me.pizza_out)
	and (me.state ~= takis.pizzastate)
	and (takis.pizzastate)
	and (me.pizza_out == 1)
		P_MovePlayer(p)
		takis.pizzastate = 0
		TakisGiveCombo(p,takis,false,true)
	end
	
	if (p.spectator)
		takis.noability = $|NOABIL_ALL
	end
	
	p.alreadyhascombometer = 2
	
--shorts end
--shortsend
end)

--from clairebun
--https:--wiki.srb2.org/wiki/User:Clairebun/Sandbox/Common_Lua_Functions#L_Choose
local function choosething(...)
	local args = {...}
	local choice = P_RandomRange(1,#args)
	return args[choice]
end

--soaps createafterimage modified to include multiple colors
rawset(_G, "TakisCreateAfterimage", function(p,me)
	if not me
	or not me.valid
		return
	end
	
	local ghost = P_SpawnMobjFromMobj(me,0,0,0,MT_TAKIS_AFTERIMAGE)
	ghost.target = me
	--ghost.fuse = SoapFetchConstant("afterimages_fuse")
	
	ghost.skin = me.skin
	ghost.scale = me.scale
	
	ghost.sprite = me.sprite
	
	ghost.state = me.state
	ghost.sprite2 = me.sprite2
	ghost.takis_frame = me.frame
	ghost.tics = -1
	ghost.colorized = true
	
	ghost.angle = p.drawangle
	
	/*
	local color = P_RandomRange(1,#skincolors-1)
	--keep rolling until we get an accessable color!
	if skincolors[color].accessible == false
		color = P_RandomRange(1,#skincolors-1)
	end
	print("@@",color,#skincolors-1,#skincolors)
	*/
	
	local color = SKINCOLOR_GREEN
	
	--not everyone is salmon
	local salnum = #skincolors[ColorOpposite(p.skincolor)]
	p.takistable.afterimagecolor = $+1
	if (p.takistable.afterimagecolor > #skincolors-1-salnum)
		p.takistable.afterimagecolor = 1
	end
	color = salnum+p.takistable.afterimagecolor
	
	if G_GametypeHasTeams()
		color = p.skincolor-1
	end
	
	ghost.color = color
	ghost.takis_spritexscale,ghost.takis_spriteyscale = me.spritexscale, me.spriteyscale
	ghost.takis_spritexoffset,ghost.takis_spriteyoffset = me.spritexoffset, me.spriteyoffset
	ghost.takis_rollangle = me.rollangle
	return ghost
end)

rawset(_G, "CreateWindRing", function(p,me)
	--trig NOO!OOOO
	local x = cos(me.angle)
	local y = sin(me.angle)
	
	--thanks rebound dash!	
	local circle = P_SpawnMobjFromMobj(me, 0, 0, me.scale * 24, MT_WINDRINGLOL)
	circle.angle = p.drawangle + ANGLE_90
	circle.fuse = 14
	circle.scale = FixedMul(FU/3,me.scale)
	circle.destscale = FixedMul(10*FU,me.scale)
	circle.scalespeed = FU/10
	circle.colorized = true
	circle.color = SKINCOLOR_WHITE
	circle.momx = -me.momx/2
	circle.momy = -me.momy/2
	circle.startingtrans = FF_TRANS10
end)

rawset(_G, "DoTakisSquashAndStretch", function(p, me, takis)
	local dontdo = false
	if (p.powers[pw_carry] == CR_NIGHTSMODE)
	or (p.powers[pw_carry] == CR_PLAYER)
	or (p.powers[pw_carry] == CR_ZOOMTUBE)
	or (p.powers[pw_carry] == CR_PTERABYTE)
	or (p.powers[pw_carry] == CR_MINECART)
	or (p.powers[pw_carry] == CR_ROPEHANG)
	or (me.pizza_out or me.pizza_in)
		dontdo = true
	end
	
	if p.jt == nil then
		--jt is the only thing responsible for the stretching!?!?
		p.jt = 0
		p.jp = 0
		p.sp = 0
		p.tk = 0
		p.tr = 0
	end
	if p.jt > 0 then
		p.jt = p.jt - 1
	end
	if p.jt < 0 then
		p.jt = p.jt + 1
	end
	if not dontdo
		if me.momz*takis.gravflip < 1 then
			p.jp = 0
		end
		if me.state != S_PLAY_CLIMB
		and not (me.eflags & MFE_GOOWATER) then
			if me.momz*takis.gravflip > 0
			and p.jp == 0
			and me.state != S_PLAY_FLY
			and me.state != S_PLAY_SWIM
			and me.state != S_PLAY_FLY_TIRED
			and me.state != S_PLAY_WALK
			and me.state != S_PLAY_RUN
			and me.state != S_PLAY_WALK
			and me.state != S_PLAY_BOUNCE_LANDING then
				p.jp = 1
				p.jt = 5
			end
			if me.momz*takis.gravflip > 0
			and p.jt < 0
			and me.state != S_PLAY_FLY
			and me.state != S_PLAY_SWIM
			and me.state != S_PLAY_FLY_TIRED
			and me.state != S_PLAY_WALK
			and me.state != S_PLAY_RUN
			and me.state != S_PLAY_WALK
			and me.state != S_PLAY_BOUNCE_LANDING then
				p.jp = 1
				p.jt = 5
			end
		elseif (me.eflags & MFE_GOOWATER)
			p.jp = 1
		end
		if not ((p.pflags & PF_THOKKED)
		or takis.thokked) then
			p.tk = 0
		end
		if (p.pflags & PF_THOKKED or takis.thokked) and p.tk == 0 then
			p.tk = 1
			p.jt = 5
		end
	end
	p.maths = p.jt*FU
	p.maths = p.maths / 10
	me.spriteyscale = p.maths + FU
	
	p.maths = p.jt*p.spinheight
	if me.state != S_PLAY_ROLL then
		p.maths = p.jt*p.height
	end
	p.maths = p.maths / 20
	me.spriteyoffset = -1*p.maths
	
	p.maths = p.jt*FU
	p.maths = p.maths / 10
	p.maths = p.maths*-1
	me.spritexscale = p.maths + FU
end)

--thank you Tatsuru for this thing on the srb2 discord!
local function CheckAndCrumble(me, sec)
	for fof in sec.ffloors()
		if not (fof.flags & FF_EXISTS) continue end -- Does it exist?
		if not (fof.flags & FF_BUSTUP) continue end -- Is it bustable?
		
		if me.z + me.height < fof.bottomheight continue end -- Are we too low?
		if me.z > fof.topheight continue end -- Are we too high?
		
		if (me.type == MT_PLAYER)
			TakisGiveCombo(me.player,me.player.takistable,true)
		elseif (me.type == MT_TAKIS_HAMMERHITBOX)
			TakisGiveCombo(me.parent.player,me.parent.player.takistable,true)		
		elseif (me.type == MT_THROWNSCATTER)
			TakisGiveCombo(me.tracer.player,me.tracer.player.takistable,true)		
		end
		EV_CrumbleChain(fof) -- Crumble
	end
end

rawset(_G, "TakisBreakAndBust", function(p, me)
	CheckAndCrumble(me, me.subsector.sector)
end)

rawset(_G, "DoQuake", function(p, int, tic, minus)
	local m = int/tic
	if minus == 0
		m = 0
	end
	table.insert(p.takistable.quake,{intensity = int,tics = tic,minus = m})
end)

rawset(_G, "DoFlash", function(p, pal, tic)
	if p.takistable.io.flashes
		P_FlashPal(p,pal,tic)
	end
end)

rawset(_G, "S_StartAntonOw", function(source)
	if source == nil
		return
	end
	S_StartSound(source, P_RandomRange(sfx_antow1,sfx_antow7))
end)

local function collide2(me,mob)
	if me.z > (mob.height*2)+mob.z then return false end
	if mob.z > me.height+me.z then return false end
	return true
end

rawset(_G, "CanPlayerHurtPlayer", function(p1,p2,nobs)

	local ff = CV_FindVar("friendlyfire").value
	
	if not (nobs)
		--no griefing!
		if TAKIS_NET.inspecialstage
			return false
		end
		
		if not p1.mo
			return false
		end
		if not p2.mo
			return false
		end
		
		if not p1.mo.health
			return false
		end
		if not p2.mo.health
			return false
		end
		
		if (p1.powers[pw_flashing] > 2*TR)
			return false
		end
		if ((p2.powers[pw_flashing]) or (p2.powers[pw_invulnerability]) or (p2.powers[pw_super]))
			return false
		end
	end
	
	if (gametyperules & GTR_FRIENDLY)
		if ff
			return true
		end
	else
		if (gametyperules & GTR_TEAMS)
			if p1.ctfteam ~= p2.ctfteam
				return true
			elseif p1.ctfteam == p2.ctfteam
			and ff
				return true
			end
		elseif (gametyperules & (GTR_FRIENDLYFIRE|GTR_RINGSLINGER))
		or ((ff) and (p1.ctfteam == p2.ctfteam))
			return true
		end
		
	end
	return false

end)

rawset(_G, "TakisTeamNewShields", function(player)
	local s = player.powers[pw_shield]
	local f = s&SH_NOSTACK
	local takis = player.takistable
	local p = player
	local me = p.mo
	
	if not (player.mo.health)
	or (takis.noability & NOABIL_SHIELD)
		return
	end
	
	--if player.pflags & PF_JUMPED
	if (f or player.powers[pw_super])
	and not (player.mo.state >= 59 and player.mo.state <= 64)
		local t = takis.attracttarg
			
			takis.hammerblastdown = 0
			
			if s & SH_FORCE
				local me = player.mo
				p.pflags = $|PF_THOKKED|PF_SHIELDABILITY
				S_StartSound(me,sfx_ngskid)
				me.momx = 0
				me.momy = 0
				me.momz = 0
			end
			if f == SH_WHIRLWIND
			or f == SH_THUNDERCOIN
				P_DoJumpShield(player)
			end
			if f == SH_ARMAGEDDON
				player.pflags = $|PF_THOKKED|PF_SHIELDABILITY
				TakisPowerfulArma(player)
				player.mo.state = S_PLAY_ROLL
			end
			if f == SH_ATTRACT
				player.pflags = $|PF_THOKKED|PF_SHIELDABILITY
				player.homing = 2
				if t and t.valid
					P_HomingAttack(player.mo,t)
					player.mo.angle = R_PointToAngle2(player.mo.x,player.mo.y,t.x,t.y)
					player.mo.state = S_PLAY_ROLL
					S_StartSound(player.mo, sfx_s3k40)
					player.homing = 3*TR
					player.pflags = $|PF_JUMPED &~(PF_THOKKED|PF_NOJUMPDAMAGE)
					takis.thokked = false
				else
					S_StartSound(player.mo, sfx_s3ka6)
					player.pflags = $ &~PF_THOKKED
					takis.thokked = false
				end
			end
			if f == SH_BUBBLEWRAP
			or f == SH_ELEMENTAL
				local elem = ((player.powers[pw_shield]&SH_NOSTACK) == SH_ELEMENTAL)
				player.pflags = $|PF_THOKKED|PF_SHIELDABILITY
				takis.thokked,takis.dived = true,true
				if elem
					player.mo.momx = 0
					player.mo.momy = 0
					S_StartSound(player.mo, sfx_s3k43)
				else
					--player.mo.momx = $-(player.mo.momx/3)
					--player.mo.momy = $-(player.mo.momy/3)
					P_Thrust(me,p.drawangle,2*me.scale)
					player.pflags = $|PF_SHIELDABILITY &~(PF_NOJUMPDAMAGE)
					player.mo.state = S_PLAY_ROLL
					S_StartSound(player.mo,sfx_s3k44)
				end
				P_SetObjectMomZ(player.mo, -24*FRACUNIT, false)
			end
			if f == SH_FLAMEAURA
			and not (takis.thokked or takis.dived or p.pflags & (PF_THOKKED|PF_SHIELDABILITY))
				player.pflags = $|PF_THOKKED|PF_SHIELDABILITY
				takis.thokked = true
				takis.dived = true
				P_InstaThrust(player.mo, player.mo.angle,
					FixedMul(takis.accspeed,me.scale)+30*me.scale
				)
				player.drawangle = player.mo.angle
				player.pflags = $&~PF_NOJUMPDAMAGE
				player.mo.state = S_PLAY_ROLL
				S_StartSound(player.mo,sfx_s3k43)
			end
		
	end
end)

rawset(_G, "TakisNoShield", function(player)
	local s = player.powers[pw_shield]
	local f = s&SH_NOSTACK
	local takis = player.takistable
	local p = player
	local me = p.realmo
	
	if not (me.health)
		takis.noability = $|NOABIL_SHIELD
	end
	
	if not (not takis.onGround
	--and (p.pflags & PF_JUMPED)
	and p.powers[pw_shield] ~= SH_NONE
	and not (takis.hammerblastdown))
		takis.noability = $|NOABIL_SHIELD
	end
	
	if (takis.shotgunned)
		takis.noability = $|NOABIL_SHIELD
	end
	
	if (f or player.powers[pw_super])
	and not (player.mo.state >= 59 and player.mo.state <= 64)
		local t = takis.attracttarg
		if (f == SH_PITY)
		or (f == SH_PINK)
			takis.noability = $|NOABIL_SHIELD
		end
		
		if f == SH_WHIRLWIND
		or f == SH_THUNDERCOIN
			if (p.pflags & (PF_THOKKED|PF_SHIELDABILITY))
				takis.noability = $|NOABIL_SHIELD
			end
		end
		if f == SH_ATTRACT
			if not ((p.powers[pw_shield]&SH_NOSTACK) == SH_ATTRACT
			and not (me.state >= 59 and me.state <= 64))
				takis.noability = $|NOABIL_SHIELD
			end
		end
		if f == SH_FLAMEAURA
		and (takis.thokked or takis.dived or p.pflags & (PF_THOKKED|PF_SHIELDABILITY))
			takis.noability = $|NOABIL_SHIELD
		end
		
	end
end)

rawset(_G, "TakisHealPlayer", function(p,me,takis,healtype,healamt)
	if healamt == nil
		healamt = 1
	end
	
	--hurt
	if healtype == 3
		if takis.heartcards ~= 0
			takis.heartcards = $-(abs(healamt))
		end
		if takis.heartcards < 0
			takis.heartcards = 0
		end
		takis.HUD.heartcards.shake = TAKIS_HEARTCARDS_SHAKETIME
		return
	--full heal
	elseif healtype == 2
		if takis.heartcards == TAKIS_MAX_HEARTCARDS
			return
		end
		takis.heartcards = TAKIS_MAX_HEARTCARDS
		takis.HUD.heartcards.add = 5*FU
		takis.HUD.statusface.happyfacetic = 2*TR
		p.timeshit = 0
	elseif healtype == 1
		if takis.heartcards == TAKIS_MAX_HEARTCARDS
			return
		end
		takis.heartcards = $+healamt
		takis.HUD.heartcards.add = (healamt*FU)*3/2
		takis.HUD.statusface.happyfacetic = 2*TR
		if p.timeshit
			p.timeshit = $-1
		end
	else
		error("\x85".."TakisHealPlayer has an invalid healtype.\x80("..healtype..")",2)
		return
	end
	
	--S_StartSound(me,sfx_takhel,p)
	local maxturn = P_RandomRange(12,18)
	for i = 0,maxturn
		local radius = 35
		local turn = FixedDiv(360*FU,maxturn*FU)
		local fa = FixedAngle(i*turn)
		fa = $+FixedAngle(P_RandomRange(-4,4)*FU)
		local x,y = ReturnTrigAngles(fa)
		local heart = P_SpawnMobjFromMobj(me,
			radius*x,
			radius*y,
			me.height/2*P_MobjFlip(me),
			MT_THOK
		)
		heart.state = S_LHRT
		heart.frame = A|TR_TRANS10
		heart.blendmode = AST_ADD
		heart.tics = -1
		heart.angle = R_PointToAngle2(me.x,me.y,heart.x,heart.y)
		heart.fuse = TR*3
		heart.flags = $ &~MF_NOGRAVITY
		local ran = P_RandomRange(2,5)*FU+P_RandomFixed()		
		P_SetObjectMomZ(heart,FixedMul(ran,me.scale*2))
		
		ran = P_RandomRange(2,5)*FU+P_RandomFixed()		
		P_Thrust(heart,heart.angle,FixedMul(ran,me.scale))
		
		heart.scalespeed = FU/heart.fuse
		heart.destscale = $/5+FixedMul(P_RandomRange(FU/10,FU-2),me.scale)
	end
		
end)

local function lookforenemy(me,prevangle)
	local px = me.x
	local py = me.y
	local br = 75*me.scale
	
	local z = me.z+(7*me.scale)
	local z2 = me.z-(7*me.scale)
	
	local ang = prevangle

	searchBlockmap("objects", function(me, found)
		if found and found.valid
		and found.health
		and P_CheckSight(me,found)
		and ((found.z >= z2) and (found.z <= z))
		
			if ( (found.type == MT_PLAYER)
			and (CanPlayerHurtPlayer(me.parent2.player,found.player)) )
			or (found.flags & (MF_MONITOR|MF_ENEMY))

				ang = R_PointToAngle2(found.x,found.y, me.x,me.y)
				return true, ang
				
			end
		end
	end, me, px-br, px+br, py-br, py+br)
	
	return ang
end

local monitorctfteam = {
	[MT_RING_REDBOX] = 1,
	[MT_RING_BLUEBOX] = 2	
}
rawset(_G, "SpawnRagThing",function(tm,t,source)
	if source == nil
		source = t
	end
	
	local speed = FixedHypot(t.momx,t.momy)
	if t.player
		local p = t.player
		local takis = p.takistable
		
		speed = takis.accspeed
		DoQuake(p,t.scale*10+(speed/4),10)
		
		if (takis.inChaos)
			P_DamageMobj(tm,t,t,1)
			return
		end
	end
	
	if not (tm.flags & MF_BOSS)
		if (tm.flags & MF_ENEMY)
		or (tm.takis_flingme)
			--spawn ragdoll thing here
			local ragdoll = P_SpawnMobjFromMobj(tm,0,0,0,MT_TAKIS_BADNIK_RAGDOLL)
			tm.tics = -1
			ragdoll.sprite = tm.sprite
			ragdoll.color = tm.color
			ragdoll.angle = t.angle
			ragdoll.frame = tm.frame
			ragdoll.height = tm.height
			ragdoll.radius = tm.radius
			ragdoll.scale = tm.scale
			ragdoll.timealive = 1
			ragdoll.parent2 = source
			ragdoll.target = tm
			ragdoll.flags = MF_SOLID|MF_NOCLIPTHING
			ragdoll.ragdoll = true
			
			P_SetObjectMomZ(ragdoll,7*t.scale)
			
			local thrust = 63
			P_Thrust(ragdoll,ragdoll.angle,
				thrust*t.scale+FixedMul(speed,t.scale)
			)
			
			if P_RandomChance(FRACUNIT/13)
				S_StartSound(ragdoll,sfx_takoww)
			end
		elseif (tm.flags & MF_MONITOR)
			
			
			--but are we allowed to break it?
			if ((tm.type == MT_RING_REDBOX) or
			(tm.type == MT_RING_BLUEBOX))
				if monitorctfteam[tm.type] ~= t.player.ctfteam
					return
				end
			end
			
			--spawn ragdoll thing here
			local ragdoll = P_SpawnMobjFromMobj(tm,0,0,0,MT_TAKIS_BADNIK_RAGDOLL)
			tm.tics = -1
			ragdoll.sprite = tm.sprite
			ragdoll.color = tm.color
			ragdoll.angle = R_PointToAngle2(tm.x,tm.y, t.x,t.y)
			ragdoll.frame = tm.frame
			ragdoll.height = tm.height
			ragdoll.radius = tm.radius
			ragdoll.scale = tm.scale
			ragdoll.timealive = 1
			
			P_SetObjectMomZ(ragdoll,7*t.scale)
			P_Thrust(ragdoll,ragdoll.angle,-63*t.scale-FixedMul(speed,t.scale))
			for i = 0, 34
				A_BossScream(ragdoll,1,MT_SONIC3KBOSSEXPLODE)
			end
			local f = P_SpawnGhostMobj(ragdoll)
			f.flags2 = $|MF2_DONTDRAW
			f.fuse = 2*TR
			S_StartSound(f,sfx_tkapow)
			P_RemoveMobj(ragdoll)
		end
		
		P_KillMobj(tm,t,source)
		--S_StopSound(tm)
		if ((tm) and (tm.valid))
		and (tm.flags & MF_ENEMY
		or tm.takis_flingme)
			--hide deathstate
			tm.flags2 = $|MF2_DONTDRAW
			if tm.tics == -1
				tm.tics = 1
			end
		end
	else
		
		if (tm.flags2 & MF2_FRET)
			return
		end
		
		S_StartSound(t,sfx_tacrit)
		local ghost = P_SpawnGhostMobj(tm)
		ghost.color = tm.color
		ghost.colorized = true
		ghost.scale = tm.scale*7/5
		ghost.destscale = ghost.scale*3/2
		ghost.frame = $|TR_TRANS80
		ghost.blendmode = AST_ADD
		
		if speed < 60*t.scale
			P_DamageMobj(tm,t,source,2)
		else
			P_KillMobj(tm,t,source)
		end
	end
end)

local getcomnum = {
	[0] = sfx_tcmup0,
	[1] = sfx_tcmup1,
	[2] = sfx_tcmup2,
	[3] = sfx_tcmup3,
	[4] = sfx_tcmup4,
	[5] = sfx_tcmup5,
	[6] = sfx_tcmup6,
	[7] = sfx_tcmup7,
	[8] = sfx_tcmup8,
	[9] = sfx_tcmup9,
	[10] = sfx_tcmupa,
	[11] = sfx_tcmupb,
	[12] = sfx_tcmupc
}
rawset(_G, "TakisGiveCombo",function(p,takis,add,max,remove,shared)
	if (p.powers[pw_carry] == CR_NIGHTSMODE)
	or not (gametyperules & GTR_FRIENDLY)
	or (maptol & TOL_NIGHTS)
	or (TAKIS_NET.inspecialstage)
	or (takis.inChaos)
		return
	end
	if add == nil
		add = false
	end
	if max == nil
		max = false
	end
	if remove == nil
		remove = false
	end
	if shared == nil
		shared = false
	end
	
	if add == true
		takis.combo.count = $+1
		
		if takis.combo.count == 1
			S_StartSound(nil,sfx_kc3c,p)
			takis.HUD.combo.scale = $+(FU/5)
			if takis.combo.outrotics
				takis.combo.outrotointro = takis.combo.gravity
				if takis.combo.failcount >= 50 --TAKIS_NET.partdestoy
					TakisAwardAchievement(p,ACHIEVEMENT_COMBOALMOST)
				end
			end
		elseif takis.combo.count >= 50
			if (takis.combo.time <= TAKIS_MAX_COMBOTIME/4)
				TakisAwardAchievement(p,ACHIEVEMENT_COMBOCLOSE)
			end
		end
		
		if not (takis.combo.count % TAKIS_COMBO_UP)
			takis.HUD.combo.scale = $+(FU/10)
			S_StartSound(nil,getcomnum[
					((takis.combo.count/TAKIS_COMBO_UP)-1)%13
				],
				p
			)
			takis.combo.rank = $+1
		end
		
		takis.combo.time = TAKIS_MAX_COMBOTIME
		
		if (takis.io.sharecombos == 1)
		and not shared
			for p2 in players.iterate
				if not (p2 and p2.valid) then continue end
				if p2 == p then continue end
				if p2.quittime then continue end
				if p2.spectator then continue end
				if not (p2.mo and p2.mo.valid) then continue end
				if (not p2.mo.health) or (p2.playerstate ~= PST_LIVE) then continue end
				if (p2.mo.skin ~= TAKIS_SKIN) then continue end
				if (p2.takistable.io.sharecombos == 0) then continue end
				
				--forgot radius
				if not P_CheckSight(p.mo,p2.mo) then continue end
				local dx = p2.mo.x-p.mo.x
				local dy = p2.mo.y-p.mo.y
				local dz = p2.mo.z-p.mo.z
				local dist = TAKIS_TAUNT_DIST*5
				
				if FixedHypot(FixedHypot(dx,dy),dz) > dist
					continue
				end
				
				TakisGiveCombo(p2,p2.takistable,true,nil,nil,true)
				
			end
		end
	else
		if not takis.combo.count
			return
		end
		
		if (remove)
			if takis.combo.time >= TAKIS_PART_COMBOTIME
				takis.combo.time = $-TAKIS_PART_COMBOTIME
			else
				takis.combo.time = 0
			end
		else
			if max == true
				takis.combo.time = TAKIS_MAX_COMBOTIME
			else
				takis.combo.time = $+TAKIS_PART_COMBOTIME
			end
		end
	end
end)

--delf!!
rawset(_G, "TakisDoWindLines", function(me)
	if not me.health then return end
	
	local p = me.player
	
    local r = me.radius / FRACUNIT
	local ang = me.angle
	if p then ang = p.drawangle end
	local wind = P_SpawnMobj(
        (me.x+(50*cos(ang))) + (P_RandomRange(r, -r) * FRACUNIT),
        (me.y+(50*sin(ang))) + (P_RandomRange(r, -r) * FRACUNIT),
        me.z + (P_RandomKey(me.height / FRACUNIT) * FRACUNIT) - me.height/2,
        MT_THOK)
    wind.scale = me.scale
	wind.fuse = wind.tics
	wind.sprite = SPR_RAIN
    wind.renderflags = $|RF_PAPERSPRITE
    wind.angle = R_PointToAngle2(0, 0, me.momx, me.momy)
	wind.spritexscale,wind.spriteyscale = me.scale,me.scale
	
	--remove the "-" beforfe the "me.momz" or else the wind will point down
	--when you go up
	--and vice versa
	local momz = me.momz
	if p then momz = p.takistable.rmomz end
    wind.rollangle = R_PointToAngle2(0, 0, R_PointToDist2(0, 0, me.momx, me.momy), momz) + ANGLE_90
	
	wind.source = me
    wind.blendmode = AST_ADD
	
	--P_Thrust(wind,wind.angle,-(FixedMul(p.takistable.accspeed,me.scale)))
end)

rawset(_G, "TakisSpawnDeadBody", function(p, me, soap)
	if ((p.deadtimer >= 3*TR) and (me.flags2 & MF2_DONTDRAW))
	and not (soap.body and soap.body.valid)
		soap.body = P_SpawnMobjFromMobj(me, 0, 0, 0, MT_TAKIS_DEADBODY)
		soap.body.tics = -1
		soap.body.skin = me.skin
		soap.body.scale = me.scale
		soap.body.state = me.state
		soap.body.sprite2 = me.sprite2
		soap.body.angle = p.drawangle
		soap.body.rollangle = me.rollangle
		soap.body.color = me.color
		soap.body.frame = me.frame
		soap.body.spritexscale = me.spritexscale
		soap.body.spriteyscale = me.spriteyscale
		
		soap.body.flags = me.flags
		soap.body.eflags = me.eflags
		soap.body.momx = me.momx
		soap.body.momy = me.momy
		soap.body.momz = me.momz
		soap.body.target = me
		
		soap.body.colorized = me.colorized
		
		soap.body.shadowscale = me.shadowscale
	end
end)

rawset(_G, "TakisDeathThinker",function(p,me,takis)
	local capdead = false
	
	--explosion anim
	if me.sprite2 == SPR2_TDED
		if p.deadtimer < 21
			A_BossScream(me,0,MT_SONIC3KBOSSEXPLODE)
		end
		if not takis.stoprolling
			me.rollangle = $-(ANG2*2)
		end
	end
	
	if p.deadtimer == 1
		DoFlash(p,PAL_NUKE,7)
	end
	
	if me.state == S_PLAY_PAIN
		me.state = S_PLAY_DEAD
	end
	
	if takis.saveddmgt
		takis.altdisfx = 0
		if takis.saveddmgt == DMG_CRUSHED
			if p.deadtimer == 1
			and takis.onGround
				S_StartSound(me,sfx_slam)
			end
			
			me.flags = $ &~MF_NOCLIPHEIGHT
			me.height = 0
			
			local div = (TR/8)
			me.spriteyscale = FU/div
			me.spritexscale = FU*div
					
			TakisSpawnDeadBody(p,me,takis)
			return
		elseif takis.saveddmgt == DMG_ELECTRIC
			
			if p.deadtimer <= TICRATE
				if (leveltime % 3) == 0
					me.color = SKINCOLOR_SUPERGOLD1
				else
					me.color = SKINCOLOR_JET
				end
				
				if p.deadtimer == 1
					S_StartSound(me, sfx_buzz2)
				end
	
				local rad = me.radius/FRACUNIT
				local hei = me.height/FRACUNIT
				local x = P_RandomRange(-rad,rad)*FRACUNIT
				local y = P_RandomRange(-rad,rad)*FRACUNIT
				local z = P_RandomRange(0,hei)*FRACUNIT
				local spark = P_SpawnMobjFromMobj(me,x,y,z,MT_SOAP_SUPERTAUNT_FLYINGBOLT)
				spark.tracer = me
				spark.state = P_RandomRange(S_SOAP_SUPERTAUNT_FLYINGBOLT1,S_SOAP_SUPERTAUNT_FLYINGBOLT5)			
				spark.blendmode = AST_ADD
				spark.color = P_RandomRange(SKINCOLOR_SUPERGOLD1,SKINCOLOR_SUPERGOLD5)
				spark.angle = p.drawangle+(FixedAngle( P_RandomRange(-337,337)*FRACUNIT ))

				me.colorized = true
			elseif p.deadtimer == TICRATE+1
				me.color = p.skincolor
				me.colorized = false
			end
		
		elseif takis.saveddmgt == DMG_SPACEDROWN
			
			me.rollangle = $ - ANG1
			me.momz = me.scale*takis.gravflip
			
			TakisSpawnDeadBody(p, me, takis)
			return
		
		elseif takis.saveddmgt == DMG_DROWNED
			
			if (takis.inWater)
				me.momz = me.scale
			end
			me.rollangle = $-FixedAngle(FU/2)
			TakisSpawnDeadBody(p,me,takis)
			return
			
		elseif takis.saveddmgt == DMG_FIRE
			if (p.deadtimer == 1)
				S_StartSound(me,sfx_takoww)
			end
			
			if me.color ~= SKINCOLOR_JET
				me.color = SKINCOLOR_JET
				me.colorized = true
			end

			if p.deadtimer < 10
				S_StartSound(me,sfx_fire)
			end
			
			if (me.sprite2 ~= SPR2_FASS)
			and not takis.deathfloored
				me.sprite2 = SPR2_FASS
			end
			
			if (leveltime & 3) == 0
			and p.deadtimer <= 2*TICRATE
				A_BossScream(me, 0, MT_FIREBALLTRAIL)
			end
			
		elseif takis.saveddmgt == DMG_DEATHPIT
			return
		end
	end
	
	me.flags = $ &~MF_NOCLIPHEIGHT
	TakisSpawnDeadBody(p,me,takis)
	
	/*
	if (me.rollangle ~= 0)
	or not (takis.onGround)
	and (capdead)
		p.deadtimer = min(5,$)
	end
	*/
	
	if (takis.justHitFloor
	or takis.onGround)
	and p.deadtimer > 3
	and (not takis.deathfloored)
		me.tics = -1
		if (me.rollangle == 0)
			me.state = S_PLAY_DEAD
			me.frame = A
			me.sprite2 = SPR2_TDD2
			p.jp = 2
			p.jt = -5
			takis.deathfloored = true
		else
			P_SetObjectMomZ(me,10*FU)
			me.rollangle = 0
			takis.stoprolling = true
			takis.deathfloored = false
		end
		
		DoFlash(p,PAL_NUKE,5)
		S_StartSound(me,sfx_slam)
		DoQuake(p,10*FU,5)
	end
	
end)

local function FixedLerp(val1,val2,amt)
	local p = FixedMul(FRACUNIT-amt,val1) + FixedMul(amt,val2)
	return p
end

rawset(_G,"TakisDrawBonuses", function(v, p, x, y, flags, salign, dist, angle)

	local lerp = 0
	if (p == displayplayer)
		lerp = blerp0
	else
		lerp = blerp1
	end
	
	local takis = p.takistable
	local bonus = takis.bonuses
	
	local lerpx, lerpy = 0, 0
	
	local function DoShift(val, ang)
		lerpx = $+P_ReturnThrustX(nil, ang, val)
		lerpy = $+P_ReturnThrustY(nil, ang, val)
	end
	local function DoLerp(kind, retract, val)
		if (p == displayplayer) then
			if (retract)
				blerp0[kind] = FixedLerp(blerp0[kind], 0, FU*45/100)
			else
				blerp0[kind] = FixedLerp(blerp0[kind], val, FU*45/100)
			end
		else
			if (retract)
				blerp1[kind] = FixedLerp(blerp1[kind], 0, FU*45/100)
			else
				blerp1[kind] = FixedLerp(blerp1[kind], val, FU*45/100)
			end
		end
	end
	
	if bonus["shotgun"].tics
		local trans = 0
		if bonus["shotgun"].tics > 3*TR+9
			trans = (bonus["shotgun"].tics-(3*TR+9))<<V_ALPHASHIFT
		elseif bonus["shotgun"].tics < 10
			trans = (10-bonus["shotgun"].tics)<<V_ALPHASHIFT
		end
		
		v.drawString(x+lerpx, y+lerpy, 
			"+"..bonus["shotgun"].score.." - "..bonus["shotgun"].text, 
			flags|trans, salign
		)
		
		DoShift(lerp["SHOTGUN"], angle)
		DoLerp("SHOTGUN", false, dist)
	else
		DoShift(lerp["SHOTGUN"], angle)
		DoLerp("SHOTGUN", true, dist)
	end
	
	if bonus["ultimatecombo"].tics
		local trans = 0
		if bonus["ultimatecombo"].tics > 3*TR+9
			trans = (bonus["ultimatecombo"].tics-(3*TR+9))<<V_ALPHASHIFT
		elseif bonus["ultimatecombo"].tics < 10
			trans = (10-bonus["ultimatecombo"].tics)<<V_ALPHASHIFT
		end
		
		v.drawString(x+lerpx, y+lerpy, 
			"+"..bonus["ultimatecombo"].score.." - "..bonus["ultimatecombo"].text, 
			flags|trans, salign
		)
		
		DoShift(lerp["ULTIMATE"], angle)
		DoLerp("ULTIMATE", false, dist)
	else
		DoShift(lerp["ULTIMATE"], angle)
		DoLerp("ULTIMATE", true, dist)
	end
	
	if bonus["happyhour"].tics
		local trans = 0
		if bonus["happyhour"].tics > 3*TR+9
			trans = (bonus["happyhour"].tics-(3*TR+9))<<V_ALPHASHIFT
		elseif bonus["happyhour"].tics < 10
			trans = (10-bonus["happyhour"].tics)<<V_ALPHASHIFT
		end
		
		v.drawString(x+lerpx, y+lerpy, 
			"+"..bonus["happyhour"].score.." - "..bonus["happyhour"].text, 
			flags|trans, salign
		)
		
		DoShift(lerp["HAPPYHOUR"], angle)
		DoLerp("HAPPYHOUR", false, dist)
	else
		DoShift(lerp["HAPPYHOUR"], angle)
		DoLerp("HAPPYHOUR", true, dist)
	end
	
	for k,val in ipairs(bonus.cards)
		if val.tics
			local trans = 0
			if val.tics > TR+9
				trans = (val.tics-(TR+9))<<V_ALPHASHIFT
			elseif val.tics < 10
				trans = (10-val.tics)<<V_ALPHASHIFT
			end
			
			v.drawString(x+lerpx, y+lerpy, 
				"+"..val.score.." - "..val.text, 
				flags|trans, salign
			)
			
			DoShift(lerp["HEART"], angle)
			DoLerp("HEART", false, dist)
		else
			DoShift(lerp["HEART"], angle)
			DoLerp("HEART", true, dist)
			table.remove(bonus.cards,k)
		end
		
	end
	
end)

--i hope you dont mind if i copy this jisk
rawset(_G, "GetInternalFontWidth", function(str, font)

	-- No string
	if not (str) then return 0 end

	local width = 0

	for i=1,#str do
		-- (Using patch width by the way)
		if (font == "STCFN") then -- default font
			width = $1+8
		elseif (font == "TNYFN") then
			width = $1+7
		elseif (font == "LTFNT") then
			width = $1+20
		elseif (font == "TTL") then
			width = $1+29
		elseif (font == "CRFNT" or font == "NTFNT") then -- TODO: Credit font centers wrongly
			width = $1+16
		elseif (font == "NTFNO") then
			width = $1+20
		else
			width = $1+27
		end
	end
	return width
end)

rawset(_G, "TakisDrawPatchedText", function(v, x, y, str, parms)

	-- Scaling
	local scale = (parms and parms.scale) or 1*FRACUNIT
	local hscale = (parms and parms.hscale) or 0
	local vscale = (parms and parms.vscale) or 0
	local yscale = (8*(FRACUNIT-scale))
	-- Spacing
	local xspacing = (parms and parms.xspace) or 0 -- Default: 8
	local yspacing = (parms and parms.yspace) or 4
	-- Text Font
	local font = (parms and parms.font) or "STCFN"
	local uppercs = (parms and parms.uppercase) or false
	local align = (parms and parms.align) or nil
	local flags = (parms and parms.flags) or 0
	local fixed = (parms and parms.fixed) or false

	-- Split our string into new lines from line-breaks
	local lines = {}

	for ls in str:gmatch("[^\r\n]+") do
		table.insert(lines, ls)
	end

	-- For each line, set some stuff up
	for seg=1,#lines do
		
		local line = lines[seg]
		-- Fixed Position
		local fx = x << FRACBITS
		local fy = y << FRACBITS
		if fixed
			fx = x
			fy = y
		end
		-- Offset position
		local off_x = 0
		local off_y = 0
		-- Current character & font patch (we assign later later instead of local each char)
		local char
		local charpatch

		-- Alignment options
		if (align) then
			-- TODO: not working correctly for CRFNT
			if (align == "center") then
				if not fixed
					fx = $1-FixedMul( (GetInternalFontWidth(line, font)/2), scale) << FRACBITS -- accs for scale
				else
					fx = $1-FixedMul( (GetInternalFontWidth(line, font)/2), scale)
				end
				-- 	fx = $1-FixedMul( (v.stringWidth(line, 0, "normal")/2), scale) << FRACBITS
			elseif (align == "right") then
				if not fixed
					fx = $1-FixedMul( (GetInternalFontWidth(line, font)), scale) << FRACBITS
				else
					fx = $1-FixedMul( (GetInternalFontWidth(line, font)), scale)
				end
				-- fx = $1-FixedMul( (v.stringWidth(line, 0, "normal")), scale) << FRACBITS
			end
		end

		-- Go over each character in the line
		for strpos=1,#line do
			local drawable = true
			-- get our character step by step
			char = line:sub(strpos, strpos)

			-- TODO: custom skincolors will make a mess of this since the charlimit is 255
			-- Set text color, inputs, and more through special characters
			-- Referencing skincolors https:--wiki.srb2.org/wiki/List_of_skin_colors

			-- TODO: effects?
			-- if (char:byte() == 161) then
			-- 	continue
			-- end
			-- print(strpos<<27)
			-- off_x = (cos(v.RandomRange(ANG1, ANG10)*leveltime))
			-- off_y = (sin(v.RandomRange(ANG1, ANG10)*leveltime))
			-- local step = strpos%3+1
			-- print(step)
			-- off_x = cos(ANG10*leveltime)*step
			-- off_y = sin(ANG10*leveltime)*step

			-- Skip and replace non-existent space graphics
			if not char:byte() or char:byte() == 32 then
				fx = $1+2*scale
				drawable = false
			end

			-- Unavoidable non V_ALLOWLOWERCASE flag toggle (exclude specials above 210)
			if (uppercs or (font == "CRFNT" or font == "NTFNT" or font == 'PTFNT'))
			and not (char:byte() >= 210) then
				char = tostring(char):upper()
			end

			-- transform the char to byte to a font patch
			charpatch = v.cachePatch( string.format("%s%03d", font, string.byte(char)) )

			-- Draw char patch
			if drawable
				v.drawStretched(
					fx+off_x, fy+off_y+yscale,
					scale+hscale, scale+vscale, charpatch, flags)
				-- Sets the space between each character using font width
			end
			fx = $1+(xspacing+charpatch.width)*scale
			--fy = $1+yspacing*scale
		end

		-- Break new lines by spacing and patch width for semi-accurate spacing
		y = $1+(yspacing+charpatch.height)*scale >> FRACBITS 
	end	

end)

rawset(_G,"TakisPowerfulArma",function(p)
	local me = p.mo
	local takis = p.takistable
	local rad = 2000*FU
	
	if not (TAKIS_NET.nerfarma)
		S_StartSound(me, sfx_bkpoof)
		DoFlash(p,PAL_NUKE,20)
		DoQuake(p,75*FU,20)
		
		for p2 in players.iterate
			if p2 == p
				continue
			end
			
			local m2 = p2.realmo
			
			if not m2 or not m2.valid
				continue
			end
			
			if (FixedHypot(m2.x-me.x,m2.y-me.y) <= rad)
				if (CanPlayerHurtPlayer(p,p2))
					TakisAddHurtMsg(p2,HURTMSG_ARMA)
					P_DamageMobj(m2,me,me)
				end
				DoFlash(p2,PAL_NUKE,20)
				DoQuake(p2,
					FixedMul(
						75*FU, FixedDiv( rad-FixedHypot(m2.x-me.x,m2.y-me.y),rad )
					),
					20
				)
			end
		end
		
		--kill!
		local px = me.x
		local py = me.y
		local br = rad
		
		searchBlockmap("objects", function(me, found)
			if found and found.valid
			and (found.health)
				if (found.type ~= MT_EGGMAN_BOX)
				or (found.takis_flingme == nil or found.takis_flingme ~= false)
					if SPIKE_LIST[found.type] == true
						P_KillMobj(found,me,me)
					elseif found.flags & (MF_ENEMY|MF_BOSS)
					or found.takis_flingme
						P_KillMobj(found,me,me)
					end
					
				end
			end
		end, me, px-br, px+br, py-br, py+br)			
		
		me = p.mo
		
		--sparks
		for i = 1, 40 do
			local fa = (i*FixedAngle(9*FU))
			local x = FixedMul(cos(fa), 22*(me.scale/FU))*FU
			local y = FixedMul(sin(fa), 22*(me.scale/FU))*FU
			local height = me.height
			local spark = P_SpawnMobjFromMobj(me,x,y,(height/2)*takis.gravflip,MT_SOAP_SUPERTAUNT_FLYINGBOLT)
			spark.tracer = me
			spark.state = P_RandomRange(S_SOAP_SUPERTAUNT_FLYINGBOLT1,S_SOAP_SUPERTAUNT_FLYINGBOLT5)
			spark.color = p.skincolor
			spark.momx, spark.momy = x,y
			spark.blendmode = AST_ADD
			spark.angle = fa	
		end
		for i = 0, 16
			local fa = (i*ANGLE_22h)
			local spark = P_SpawnMobjFromMobj(me,0,0,0,MT_SUPERSPARK)
			spark.momx = FixedMul(sin(fa),rad)
			spark.momy = FixedMul(cos(fa),rad)
			local spark2 = P_SpawnMobjFromMobj(me,0,0,0,MT_SUPERSPARK)
			spark2.color = me.color
			spark2.momx = FixedMul(sin(fa),rad/20)
			spark2.momy = FixedMul(cos(fa),rad/20)
		end
		p.powers[pw_shield] = SH_NONE
	else
		P_BlackOw(p)
	end
	
	--get an extra combo from the shield
	TakisGiveCombo(p,takis,true)
end)

rawset(_G,"TakisResetTauntStuff",function(takis,killclapper)
	takis.taunttime = 0
	takis.tauntid = 0
	takis.tauntspecial = 0
	if (killclapper)
		if ((takis.tauntjoin) and (takis.tauntjoin.valid))
			P_KillMobj(takis.tauntjoin)
		end
		takis.tauntjoin = 0
	end
	takis.tauntjoinable = false
	takis.tauntpartner = 0
	takis.tauntacceptspartners = false
end)

rawset(_G,"ReturnTrigAngles",function(angle)
	return cos(angle),sin(angle)
end)

rawset(_G,"TakisDoShotgunShot",function(p,down)
	if down == nil
		down = false
	end

	local takis = p.takistable
	local me = p.mo
	
	local lastaimingbeforedown = p.aiming
	if down
		if (takis.gravflip == 1)
			p.aiming = FixedAngle(FU*270)
		else
			p.aiming = FixedAngle(FU*89)
		end
	end
	
	local ssmul = 10
	
	--rs neo
	
	--horiz
	local spread = 2
	for i = -2, 2
		local r = P_RandomFixed
		local ran = P_RandomRange(0,1)
		if ran == 0 then ran = -1 end
		
		local shotspread = FixedAngle( FixedMul( FixedMul( r(), r() ), r() ) * ran) * ssmul
		
		--the first shot is always accurate
		if takis.timesincelastshot == 0
			shotspread = 0
		end
		
		local shot = P_SPMAngle(me, MT_THROWNSCATTER, p.drawangle + i * ANG1*spread+shotspread, 1, 0)
		if ((shot) and (shot.valid))
			shot.tracer = me
			
			shot.momx = $*2
			shot.momy = $*2
			shot.momz = $*2
			shot.shotbytakis = true
			P_Thrust(shot,shot.angle,takis.accspeed)
			
		end
		
	end
	--vert
	for i = -2, 2
		if i == 0
			continue
		end
		
		local r = P_RandomFixed
		local ran = P_RandomRange(0,1)
		if ran == 0 then ran = -1 end
		
		local shotspread = FixedAngle( FixedMul( FixedMul( r(), r() ), r() ) * ran) * ssmul

		--the first shot is always accurate
		if takis.timesincelastshot == 0
			shotspread = 0
		end
		
		local prevaim = p.aiming
		p.aiming = $ + i * ANG1*spread
		local shot = P_SPMAngle(me, MT_THROWNSCATTER, p.drawangle+shotspread, 1, 0)
		
		--extra horiz
		if ((i == -1) or (i == 1))
			for j = -1, 1
				shotspread = FixedAngle( FixedMul( FixedMul( r(), r() ), r() ) * ran) * ssmul
				
				local shot = P_SPMAngle(me, MT_THROWNSCATTER, p.drawangle + (j * ANG1*spread)+shotspread, 1, 0)
				if ((shot) and (shot.valid))
					shot.tracer = me
					
					shot.momx = $*2
					shot.momy = $*2
					shot.momz = $*2
					shot.shotbytakis = true
					P_Thrust(shot,shot.angle,takis.accspeed)
					
				end
				
			end
		end
		p.aiming = prevaim
		
		if shot and shot.valid
			shot.tracer = me
			shot.flags2 = $|MF2_RAILRING
			
			shot.momx = $*2
			shot.momy = $*2
			shot.momz = $*2
			shot.shotbytakis = true
			
		end
	end
	
	p.aiming = lastaimingbeforedown
	takis.timesincelastshot = TR
	
end)

rawset(_G,"TakisMenuThinker",function(p)
	local me = p.mo
	local takis = p.takistable
	local menu = takis.cosmenu
	
	if not takis.cosmenu.menuinaction
		return
	end
	
	if p.spectator
	or not (me and me.valid)
		TakisMenuOpenClose(p)
		return
	end
	
 	takis.nocontrol = 3
	p.pflags = $ |PF_FULLSTASIS|PF_FORCESTRAFE
	
	if (p.cmd.buttons & BT_CUSTOM1)
		TakisMenuOpenClose(p)
		return
	end
	
	local menu = takis.cosmenu
	if (p.cmd.forwardmove > 19)
		menu.up = $+1
		menu.down = 0
	else
		menu.up = 0
	end
	if (p.cmd.forwardmove < -19)
		menu.down = $+1
		menu.up = 0
	else
		menu.down = 0
	end
	if (p.cmd.sidemove > 19) and not (menu.up or menu.down)
		menu.right = $+1
		menu.left = 0
		menu.scroll = 0
	else
		menu.right = 0
	end
	if (p.cmd.sidemove < -19) and not (menu.up or menu.down)
		menu.left = $+1
		menu.right = 0
		menu.scroll = 0
	else
		menu.left = 0
	end
	if (p.cmd.buttons & BT_JUMP) and not (p.cmd.buttons & BT_SPIN)
		menu.jump = $+1
	else
		menu.jump = 0
	end
	
	
	if menu.left == 1
		if menu.page > 0
			menu.y = 0
			menu.page = $-1
			S_StartSound(nil,sfx_menu1,p)
		end		
	end
	if menu.right == 1
		if menu.page ~= #TAKIS_MENU.entries
			menu.y = 0
			menu.page = $+1
			S_StartSound(nil,sfx_menu1,p)
		end
	end
	
	if menu.page == 1
		if menu.up == 1
		or menu.up >= TR/2
			if menu.achscroll ~= 0
				menu.achscroll = $-1
				S_StartSound(nil,sfx_menu1,p)
			end
		end
		if menu.down == 1
		or menu.down >= TR/2
			if menu.achscroll ~= NUMACHIEVEMENTS-5
				menu.achscroll = $+1
				S_StartSound(nil,sfx_menu1,p)
			end
		end
		return
	end
	
	if menu.up == 1
	or menu.up >= TR/2
		if menu.y ~= 0
			menu.y = $-1
			S_StartSound(nil,sfx_menu1,p)
		end
	end
	if menu.down == 1
	or menu.down >= TR/2
		if menu.y ~= #TAKIS_MENU.entries[menu.page].text-1
			menu.y = $+1
			S_StartSound(nil,sfx_menu1,p)
		end
	end
	if menu.jump == 1
		if TAKIS_MENU.entries[menu.page].commands
		and TAKIS_MENU.entries[menu.page].commands[menu.y+1] ~= nil
			local pre = "takis_"
			if (TAKIS_MENU.entries[menu.page].noprefix) then pre = '' end
			
			COM_BufInsertText(p,pre..TAKIS_MENU.entries[menu.page].commands[menu.y+1])
			S_StartSound(nil,sfx_menu1,p)
		elseif TAKIS_MENU.entries[menu.page].cvars
		and TAKIS_MENU.entries[menu.page].cvars[menu.y+1] ~= nil
			local cv = TAKIS_MENU.entries[menu.page].cvars[menu.y+1]
			local setting = 0
			setting = 1-cv.value
			COM_BufInsertText(p,cv.name.." "..setting)
			S_StartSound(nil,sfx_menu1,p)
			
		end
	end
		
end)

rawset(_G, "prtable", function(text, t, doprint, prefix, cycles)
    prefix = $ or ""
    cycles = $ or {}
	if doprint == nil
		doprint = true
	end
	
	local stringtext = {}

	if doprint
		print(prefix..text.." = {")
	end
	table.insert(stringtext,prefix..text.." = {")
	
    for k, v in pairs(t)
		local colorcode = ''
        if type(v) == "table"
            if cycles[v]
				if doprint
					print(prefix.."    "..tostring(k).." = "..tostring(v))
				end
				table.insert(stringtext,prefix.."    "..tostring(k).." = "..tostring(v))
            else
                cycles[v] = true
                prtable(k, v, doprint, prefix.."    ", cycles)
            end
        elseif type(v) == "string"
			colorcode = "\x8D"
			if doprint
				print(prefix.."    "..tostring(k)..' = '..colorcode..'"'..v..'"')
			end
			table.insert(stringtext,prefix.."    "..tostring(k)..' = '..colorcode..'"'..v..'"')
        else
			if type(v) == "userdata" and v.valid
				colorcode = "\x86"
				if (v.name)
					v = v.name
				end
			end
			if (type(v) == "boolean")
			or (type(v) == "function")
				colorcode = "\x84"
			end
			
			if doprint
				print(prefix.."    "..tostring(k).." = "..colorcode..tostring(v))
			end
			table.insert(stringtext,prefix.."    "..tostring(k).." = "..colorcode..tostring(v))
        end
    end
	
	if doprint
		print(prefix.."}")
	end
	table.insert(stringtext,prefix.."}")
	return stringtext
end)

/*
rawset(_G,"Takis_GiveScore",function(p,num)
	num = tonumber($)
	
	if num ~= 0
		local sym = "+"
		local cmap = V_GREENMAP
		if num < 0
			sym = "-"
			cmap = V_REDMAP
		end
		
		table.insert(p.takistable.HUD.scoretext,{
			cmap = cmap,
			trans = V_HUDTRAN,
			text = sym..num,
			ymin = 0,
			tics = TR,
		})
	
		P_AddPlayerScore(p,num)
	
	end
end)
*/

local musdefaults = {
	["hapyhr"] = "mp_mrz",
	["hpyhre"] = "spec7",
	["letter"] = "_chsel",
	["_conga"] = "_chsel",
	["war"] = "vsbrak"
}
--returns the music name for a takis song, returns '' if the
--player doesnt have takismusic.pk3
rawset(_G, "ReturnTakisMusic",function(mus,p)
	mus = string.lower(tostring(mus))
	
	--if we CAN play it
	if (S_MusicExists(mus,false,true))
		if string.lower(CV_FindVar("takis_loadedmus").string) == "false"
			CV_StealthSet(CV_FindVar("takis_loadedmus"),"true")
		end
		
		return mus
	end
	
	if not p.takistable.io.ihavemusicwad
		mus = musdefaults[mus] or ''
	end
	
	if mus == ''
	or mus == nil
		return nil
	end
	
	return mus
	
end)

rawset(_G, "ChangeTakisMusic",function(mus,looping,p,f,g,fade)
	local playert = consoleplayer
	if p and p.valid
	and userdataType(p) == "player_t"
		playert = p
	end
	
	mus = ReturnTakisMusic(mus,playert)
	
	if mus == ''
	or mus == nil
		return false
	end
	
	S_ChangeMusic(mus,looping,p,f,g,fade)
	return true
end)

rawset(_G, "TakisAddHurtMsg",function(p,enum)

	if enum == nil
		return
	end
	p.takistable.hurtmsg[enum].tics = 2
	
end)

rawset(_G, 'L_FixedDecimal', function(str,maxdecimal)
	if str == nil or tostring(str) == nil
		return '<invalid FixedDecimal>'
	end
	local number = tonumber(str)
	maxdecimal = ($ != nil) and $ or 3
	if tonumber(str) == 0 return '0' end
	local polarity = abs(number)/number
	local str_polarity = (polarity < 0) and '-' or ''
	local str_whole = tostring(abs(number/FRACUNIT))
	if maxdecimal == 0
		return str_polarity..str_whole
	end
	local decimal = number%FRACUNIT
	decimal = FRACUNIT + $
	decimal = FixedMul($,FRACUNIT*10^maxdecimal)
	decimal = $>>FRACBITS
	local str_decimal = string.sub(decimal,2)
	return str_polarity..str_whole..'.'..str_decimal
end)

--reset hammerblast
rawset(_G, "TakisResetHammerTime", function(p)
	local takis = p.takistable
	takis.hammerblastdown = 0
	takis.hammerblastwentdown = false
	if (takis.hammerblasthitbox and takis.hammerblasthitbox.valid)
		P_RemoveMobj(takis.hammerblasthitbox)
	end
	takis.hammerblasthitbox = nil
	takis.hammerblastjumped = 0
	takis.hammerblastgroundtime = 0
end)

rawset(_G, "TakisShotgunify", function(p)
	local takis = p.takistable
	local me = p.mo
	
	if me.skin ~= TAKIS_SKIN
		return
	end
	
	if (takis.transfo ~= 0)
		S_StartSound(me,sfx_shgnk)
		takis.transfo = 0
		P_MovePlayer(p)
	end
	
	takis.transfo = $|TRANSFO_SHOTGUN
	takis.shotgunned = true
	ChangeTakisMusic("war",true,p)
	S_StartSound(nil,sfx_shgnl,p)
	
	if not (TakisReadAchievements(p) & ACHIEVEMENT_BOOMSTICK)
		takis.shotguntuttic = 4*TR+(TR/2)
	end
	
	TakisAwardAchievement(p,ACHIEVEMENT_BOOMSTICK)
	
	if not ((takis.shotgun) and (takis.shotgun.valid))
		local x = cos(p.drawangle-ANGLE_90)
		local y = sin(p.drawangle-ANGLE_90)
		
		takis.shotgun = P_SpawnMobjFromMobj(me,16*x,16*y,me.height/2,MT_TAKIS_SHOTGUN)
		takis.shotgun.target = me
		takis.shotgun.angle = p.drawangle
	end
	TakisResetHammerTime(p)
end)

rawset(_G, "TakisDeShotgunify", function(p)
	local takis = p.takistable
	local me = p.mo
	
	if ((takis.shotgun) and (takis.shotgun.valid))
		P_KillMobj(takis.shotgun,me)
	end
	takis.shotgun = 0
	takis.shotgunned = false
	takis.transfo = $ &~TRANSFO_SHOTGUN
	if string.lower(S_MusicName()) == ReturnTakisMusic("war",p)
		P_RestoreMusic(p)
	end
	TakisResetHammerTime(p)
end)

rawset(_G,"SpawnBam",function(mo)
	local bam = P_SpawnMobjFromMobj(mo,0,0,0,MT_TNTDUST)
	bam.state = mobjinfo[MT_MINECART].deathstate 
	return bam
end)

rawset(_G,"TakisChangeHeartCards",function(amt)
	if amt == nil then return end
	if not tonumber(amt) then return end
	amt = abs($)
	
	local oldcards = TAKIS_MAX_HEARTCARDS
	TAKIS_MAX_HEARTCARDS = amt
	for p in players.iterate
		if skins[p.skin].name ~= TAKIS_SKIN then continue end
		if not p.takistable then return end
		local takis = p.takistable
		
		if takis.heartcards ~= oldcards then continue end
		
		takis.heartcards = TAKIS_MAX_HEARTCARDS
	end
end)

rawset(_G,"TakisMenuOpenClose",function(p)
	local takis = p.takistable
	if not takis then return end
	if takis.cosmenu.menuinaction
		takis.cosmenu.menuinaction = false
		takis.HUD.showingletter = false
		P_RestoreMusic(p)
		p.pflags = $ &~PF_FORCESTRAFE		
		return
	end
	
	takis.cosmenu.menuinaction = true
end)

--because im LAZY.
rawset(_G,"GetActorZ",function(actor,targ,type)
	if type == nil then type = 1 end
	if not (actor and actor.valid) then return 0 end
	if not (targ and targ.valid) then return 0 end
	
	local flip = P_MobjFlip(actor)
	
	--get z
	if type == 1
		if flip == 1
			return actor.z
		else
			return actor.z+actor.height-targ.height
		end
	--get top z
	elseif type == 2
		if flip == 1
			return actor.z+actor.height
		else
			return actor.z-targ.height
		end
	end
	return 0
end)

rawset(_G,"GetControlAngle",function(p)
	return (p.cmd.angleturn << 16) + R_PointToAngle2(0, 0, p.cmd.forwardmove << 16, -p.cmd.sidemove << 16)
end)

-- https://github.com/STJr/SRB2/blob/SRB2_release_2.2.13/src/p_inter.c#L1998
rawset(_G,"VanillaHurtMsg",function(p,inf,sor,dmgt,died)
	local deathonly = false
	local deadsource = false
	local deadtarget = false
	local deathtxt = "by idiocy"
	
	if not (gametyperules & GTR_RINGSLINGER|GTR_HURTMESSAGES)
		return
	end
	
	if not p then return end
	if not p.mo then return end
	if p.spectator then return end
	if not netgame then return end
	
	deadtarget = p.mo.health <= 0
	if died then deadtarget = true end
	
	if not (CV_FindVar("hazardlog").value) then return end
	
	if sor
		if sor.player
			if sor.player.playerstate == PST_DEAD
			and sor.player ~= p
			and (inf.flags2 & MF2_BEYONDTHEGRAVE)
				deadsource = true
			end
			
			if (inf.flags & MF_PUSHABLE)
				deathtxt = "playtime with heavy objects"
			--switch case for type
			else
				local ty = inf.type
				
				if ty == MT_PLAYER
					if (dmgt == DMG_NUKE)
						deathtxt = "armageddon blast"
					elseif inf.player.powers[pw_shield] & SH_NOSTACK == SH_ELEMENTAL
					and inf.player.pflags & PF_SHIELDABILITY
						deathtxt = "elemental stomp"
					elseif inf.player.powers[pw_invulnerability]
						deathtxt = "invincibility aura"
					elseif inf.player.powers[pw_super]
						deathtxt = "super aura"
					else
						deathtxt = "tagging hand"
					end
				elseif ty == MT_SPINFIRE
					deathtxt = "elemental fire trail"
				--weapon rings
				elseif ty == MT_THROWNBOUNCE
					deathtxt = "bounce ring"
				elseif ty == MT_THROWNINFINITY
					deathtxt = "infinity ring"
				elseif ty == MT_THROWNAUTOMATIC
					deathtxt = "automatic ring"
				elseif ty == MT_THROWNSCATTER
					deathtxt = "scatter ring"
				elseif ty == MT_THROWNEXPLOSION
					deathtxt = "explosion ring"
				elseif ty == MT_THROWNGRENADE
					deathtxt = "grenade ring"
				elseif ty == MT_REDRING
					if (inf.flags2 & MF2_RAILRING)
						deathtxt = "rail ring"
					else
						deathtxt = "thrown ring"
					end
				else
					deathtxt = 'idiocy'
				end
				
				local sortxt = (deadsource) and "The late" or ''
				local livetext = p.mo.health and "hurt" or "killed"
				
				print(sortxt..sor.player.ctfnamecolor.."'s "..deathtxt.." "..livetext.." "..p.ctfnamecolor)
			end
		
		--type switch case
		else
			deathtxt = "by their idiocy"
			local ty = sor.type
			
			if ty == MT_EGGMAN_ICON
				deathtxt = "by Eggman's nefarious TV magic"
			elseif SPIKE_LIST[ty] == true
				deathtxt = "by spikes"
			else
				deathtxt = "by an environmental hazard"
			end
		end
	--no source
	else
		--dmgt switch case
		if dmgt == DMG_WATER
			deathtxt = "by dangerous water"
		elseif dmgt == DMG_FIRE
			deathtxt = "by molten lava"
		elseif dmgt == DMG_ELECTRIC
			deathtxt = "by electricity"
		elseif dmgt == DMG_SPIKE
			deathtxt = "by spikes"
		--death
		elseif dmgt == DMG_DROWNED
			deathonly = true
			deathtxt = "drowned"
		elseif dmgt == DMG_CRUSHED
			deathonly = true
			deathtxt = "was crushed"
		elseif dmgt == DMG_DEATHPIT
			if deadtarget
				deathonly = true
				deathtxt = "fell into a bottomless pit"
			end
		elseif dmgt == DMG_SPACEDROWN
			if deadtarget
				deathonly = true
				deathtxt = "asphyxiated in space"
			end
		else
			if deadtarget
				deathonly = true
				deathtxt = "died"
			end
		end
	end
	
	if not deathtxt then return end
	
	if deathonly
		if not deadtarget then return end
		print(p.ctfnamecolor.." "..deathtxt)
	else
		local livetext = p.mo.health and "hurt" or "killed"
		print(p.ctfnamecolor.." was "..livetext.." "..deathtxt)	
	end
end)

rawset(_G,"TakisHurtMsg",function(p,inf,sor,dmgt)
	if (gametype == GT_COOP)
	or (not (p.mo and p.mo.valid))
		return
	end
	if p.spectator
		return
	end
	if not inf
	or not inf.valid
		VanillaHurtMsg(p,inf,sor,dmgt,p.playerstate ~= PST_LIVE)
		print("1")
		return
	end
	if not sor
	or not sor.valid
		VanillaHurtMsg(p,inf,sor,dmgt,p.playerstate ~= PST_LIVE)
		print("2")
		return
	end
	if not (netgame)
		return
	end
	
	if not (inf.skin == TAKIS_SKIN
	or sor.skin == TAKIS_SKIN)
		VanillaHurtMsg(p,inf,sor,dmgt)
		print("3")
		return
	end
	
	local takis = p.takistable
	local me = p.mo
	
	local livetext = me.health and "hurt" or "killed"
	local sortext = sor.health and '' or "The late "
	
	for i = 0, #takis.hurtmsg
		print("i "..i)
		print(takis.hurtmsg[i].tics)
		if takis.hurtmsg[i].tics
			print(sortext..sor.player.ctfnamecolor.."'s "..takis.hurtmsg[i].text.." "..livetext.." "..p.ctfnamecolor)
			return true
		end
	end
	VanillaHurtMsg(p,inf,sor,dmgt)
end)
filesdone = $+1
