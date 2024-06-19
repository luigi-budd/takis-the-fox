if not (rawget(_G, "customhud")) return end
local modname = "takisthefox"
local battleoffset = 15

local function happyshakelol(v)
	local s = 5
	local shakex,shakey = v.RandomFixed()/2,v.RandomFixed()/2
	
	local d1 = v.RandomRange(-1,1)
	local d2 = v.RandomRange(-1,1)
	if d1 == 0
		d1 = v.RandomRange(-1,1)
	end
	if d2 == 0
		d2 = v.RandomRange(-1,1)
	end

	shakex = $*s*d1
	shakey = $*s*d2
	
	return shakex,shakey
end


--if TAKIS_ISDEBUG then return end

--HEALTH----------

local function drawheartcards(v,p)

	if (customhud.CheckType("takis_heartcards") != modname) return end
	
	if p.takis_noabil ~= nil
		if p.takistable.heartcards == TAKIS_MAX_HEARTCARDS
			return
		end
	end
	
	local amiinsrbz = false
	
	if (gametype == GT_ZE2)
		amiinsrbz = true
	end
	
	if p.takistable.inNIGHTSMode
	or (TAKIS_NET.inspecialstage)
	or amiinsrbz
	or p.takistable.hhexiting
		return
	end
	
	local xoff = 15*FU
	local takis = p.takistable
	local me = p.mo
	
	if p.takis_noabil ~= nil
	or (takis.io.minhud)
		xoff = -2*FU
	end
	
	--space allocated for all the cards
	local bump = 0
	if ((TAKIS_NET.inbossmap)
	and (takis.HUD.bosscards.mo and takis.HUD.bosscards.mo.valid)
	and (takis.HUD.bosscards.mo and takis.HUD.bosscards.mo.health))
	or (HAPPY_HOUR.happyhour)
		bump = TAKIS_MISC.cardbump
	end
	local maxspace = 90*FU+bump
	
	--position of the first card
	local maxx = maxspace
	
	--heart cards
	for i = 1, TAKIS_MAX_HEARTCARDS do
		
		local j = i
		
		local eflag = V_HUDTRANS
		if (TAKIS_NET.inbossmap)
		and (takis.HUD.bosscards and takis.HUD.bosscards.mo and takis.HUD.bosscards.mo.valid)
		and (takis.HUD.bosscards.mo and takis.HUD.bosscards.mo.health)
			eflag = $ &~V_HUDTRANS
			eflag = $|(v.userTransFlag())
		end
		
		--patch
		local patch = v.cachePatch("HEARTCARD1")
		if ultimatemode
			patch = v.cachePatch("HEARTCARD3")
		end
		
		local hp = (takis.HUD.heartcards.spintic) and takis.HUD.heartcards.oldhp or takis.heartcards
		
		if takis.HUD.heartcards.spintic
			local maxhp2 = takis.heartcards
			if (TAKIS_MAX_HEARTCARDS-i > takis.HUD.heartcards.oldhp - 1)
				patch = v.cachePatch("HEARTCSPIN"..4-(takis.HUD.heartcards.spintic/2))
			end
		end
		if TAKIS_MAX_HEARTCARDS-i > takis.heartcards - 1
		or p.spectator
			patch = v.cachePatch("HEARTCARD2")
			if p.spectator
				eflag = V_HUDTRANSHALF
			end
		end
		
		--
		
		--always make the first card (onscreen) go up
		local add = -3*FU
		local iseven = TAKIS_MAX_HEARTCARDS%2 == 0
		if (i%2 and iseven)
		or (not (i%2) and not iseven)
			add = 3*FU
		end
		
		if TAKIS_MAX_HEARTCARDS == 1
			add = 0
			j = 0
		end
		
		--shake
		local shakex,shakey = 0,0
		
		if takis.HUD.heartcards.shake
		and not (paused)
		and not (menuactive and takis.isSinglePlayer)
		and not p.spectator
			
			local s = takis.HUD.heartcards.shake
			shakex,shakey = v.RandomFixed()/2,v.RandomFixed()/2
			
			local d1 = v.RandomRange(-1,1)
			local d2 = v.RandomRange(-1,1)
			if d1 == 0
				d1 = v.RandomRange(-1,1)
			end
			if d2 == 0
				d2 = v.RandomRange(-1,1)
			end
		
			shakex = $*s*d1
			shakey = $*s*d2
		end
		--
		
		local incre = (FixedMul(
				FixedDiv(maxspace,TAKIS_MAX_HEARTCARDS*FU)*j,
				FU*4/5
			)
		)
		
		if (takis.inBattle) then add = $+battleoffset*FU end

		--draw from last to first
		local flags = V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|eflag
		v.drawScaled(maxx-(incre)+xoff+shakex,
			15*FU+add-takis.HUD.heartcards.add+shakey,
			4*FU/5, patch, flags
		)
	end
	
end

local function drawbosscards(v,p)

	if (customhud.CheckType("takis_bosscards") != modname) return end
	
	local xoff = -20*FU
	local takis = p.takistable
	local me = p.mo
	local bosscards = takis.HUD.bosscards
	
	if (bosscards == nil) then return end
	if not (bosscards.mo and bosscards.mo.valid) then return end
	if (bosscards.nocards or TAKIS_BOSSCARDS.nobosscards[bosscards.mo.type] ~= nil) then return end
	
	local amiinsrbz = false
	
	if (gametype == GT_ZE2)
		amiinsrbz = true
	end
	
	if p.takistable.inNIGHTSMode
	or (TAKIS_NET.inspecialstage)
	or amiinsrbz
	or p.takistable.hhexiting
	or p.takistable.inChaos
		return
	end
	
	
	--space allocated for all the cards
	local bump = 0
	if (bosscards.mo.health)
		bump = TAKIS_MISC.cardbump
	end
	local maxspace = 110*FU+bump
	
	--position of the first card
	local maxx = maxspace
	
	if TAKIS_BOSSCARDS.bossprefix[bosscards.mo.type] ~= nil then xoff = 4*FU end
	if takis.io.minhud then xoff = -20*FU end
	
	--tween in/out
	local et = TR/2
	local tween = 0
	if not (TAKIS_NET.inbossmap and bosscards.mo.health)
	and (bosscards.mo)
		local tics = min(bosscards.timealive or 0,et+1)
		tween = ease.outback((FU/et)*tics,-300*FU,0,FU*3/2)
	end
	xoff = $+tween
	
	--boss cards
	for i = 1, bosscards.maxcards do
		
		local j = i
		
		local eflag = V_HUDTRANS
		if (TAKIS_NET.inbossmap)
		and (bosscards.mo and bosscards.mo.health)
			eflag = $ &~V_HUDTRANS
			eflag = $|(v.userTransFlag())
		end
		
		--patch
		local patch = v.cachePatch("HEARTCARD3")
		
		if bosscards.maxcards-i > bosscards.cards-1
			patch = v.cachePatch("HEARTCARD2")
		end			
		--
		
		--always make the first card (onscreen) go up
		local add = -3*FU
		local iseven = bosscards.maxcards%2 == 0
		if (i%2 and iseven)
		or (not (i%2) and not iseven)
			add = 3*FU
		end
		
		if bosscards.maxcards == 1
			add = 0
		end
			
		local shakex,shakey = 0,0
		if bosscards.cardshake
		and not (paused)
		and not (menuactive and (not multiplayer or splitscreen))
			
			local s = bosscards.cardshake
			shakex,shakey = v.RandomFixed()/2,v.RandomFixed()/2
			
			local d1 = v.RandomRange(-1,1)
			local d2 = v.RandomRange(-1,1)
			if d1 == 0
				d1 = v.RandomRange(-1,1)
			end
			if d2 == 0
				d2 = v.RandomRange(-1,1)
			end
		
			shakex = $*s*d1
			shakey = $*s*d2
		end
		
		local incre = (FixedMul(
				FixedDiv(maxspace,bosscards.maxcards*FU)*j,
				FU*4/5
			)
		)
		
		--draw from last to first
		local flags = V_SNAPTORIGHT|V_SNAPTOTOP|eflag|V_FLIP
		v.drawScaled(300*FU-(maxx-(incre)+xoff)+shakex,
			15*FU+add+shakey,
			4*FU/5, patch, flags
		)
	end
	
end

--      ----------

--FACE  ----------

--referencing doom's status face code
-- https:--github.com/id-Software/DOOM/blob/77735c3ff0772609e9c8d29e3ce2ab42ff54d20b/linuxdoom-1.10/st_stuff.c#L752
local function calcstatusface(p,takis)
	local me = p.mo
	local noretrooverride = false
	
	--idle
	if not HAPPY_HOUR.happyhour
	and not ((p.pizzaface) or ultimatemode)
		takis.HUD.statusface.state = "IDLE"
		takis.HUD.statusface.frame = (leveltime/3)%2
		takis.HUD.statusface.priority = 0
	else
		takis.HUD.statusface.state = "PTIM"
		takis.HUD.statusface.frame = (2*leveltime/3)%2
		takis.HUD.statusface.priority = 0
	end
	if takis.isAngry
		takis.HUD.statusface.state = "AGRY"
		takis.HUD.statusface.frame = (leveltime/3)%4
		takis.HUD.statusface.priority = 0
	end
	if (takis.transfo & TRANSFO_SHOTGUN)
		takis.HUD.statusface.state = "SGUN"
		takis.HUD.statusface.frame = (leveltime/3)%2
		takis.HUD.statusface.priority = 0		
	end
	if (takis.transfo & TRANSFO_BALL)
	and (p.realmo.sprite2 == SPR2_ROLL)
		--im lazy and dont want to draw more ball frames
		takis.HUD.statusface.state = "SPR2"
		takis.HUD.statusface.frame = p.realmo.frame
		takis.HUD.statusface.priority = 0
		noretrooverride = true
	end
	if (takis.transfo & TRANSFO_PANCAKE)
		takis.HUD.statusface.state = "PCKE"
		takis.HUD.statusface.frame = (leveltime/4)%2
		takis.HUD.statusface.priority = 0		
	end
	
	if (takis.heartcards <= (TAKIS_MAX_HEARTCARDS/TAKIS_MAX_HEARTCARDS or 1))
	and not (takis.fakeexiting)
	and (takis.HUD.statusface.state == "IDLE")
		takis.HUD.statusface.state = "PTIM"
		takis.HUD.statusface.frame = (2*leveltime/3)%2
		takis.HUD.statusface.priority = 0	
	end
	
	if takis.HUD.statusface.priority < 10
		
		--dead
		if not (me)
		or (not me.health)
		or (p.playerstate ~= PST_LIVE)
		or (p.spectator)
			takis.HUD.statusface.state = "DEAD"
			takis.HUD.statusface.frame = 0
			takis.HUD.statusface.priority = 9
		end
	end
	
	if takis.HUD.statusface.priority < 9
		
		--pain
		if not takis.resettingtoslide
			if ((takis.inPain or takis.inFakePain)
			or (takis.ticsforpain)
			or (me.sprite2 == SPR2_PAIN)
			or (me.state == S_PLAY_PAIN)
			or (takis.HUD.statusface.painfacetic))
			or (me.pizza_out or me.pizza_in)
			or (takis.pitanim)
			and me.sprite2 ~= SPR2_SLID
				takis.HUD.statusface.state = "PAIN"
				takis.HUD.statusface.frame = (leveltime%4)/2
				takis.HUD.statusface.priority = 8
			end
		end
	end
	
	
	if takis.HUD.statusface.priority < 8
		
		--evil grin when killing someone
		--or a boss
		if takis.HUD.statusface.evilgrintic
		or (takis.transfo & TRANSFO_SHOTGUN
		and TAKIS_NET.chaingun
		and takis.use >= TR*2)
			takis.HUD.statusface.state = "EVL_"
			takis.HUD.statusface.frame = (leveltime/4)%2
			takis.HUD.statusface.priority = 7
		end
		
	end
	
	if takis.HUD.statusface.priority < 7
		
		--happy face
		if takis.HUD.statusface.happyfacetic
		or takis.tauntid == 2
			takis.HUD.statusface.state = "HAPY"
			takis.HUD.statusface.frame = (leveltime/2)%2
			takis.HUD.statusface.priority = 6		
		end
		
	end
	
	
	if takis.HUD.statusface.priority < 6
		
		--doom's godmode face
		if (p.pflags & PF_GODMODE)
			takis.HUD.statusface.state = "GOD_"
			takis.HUD.statusface.frame = (leveltime/3)%2
			takis.HUD.statusface.priority = 5
		end
		
	end
	
	if takis.HUD.statusface.priority < 2
	
		--space drown
		if ((P_InSpaceSector(me)) and (p.powers[pw_spacetime]))
		or ((p.powers[pw_underwater]) and (p.powers[pw_underwater] <= 11*TR))
			takis.HUD.statusface.state = "SDWN"
			takis.HUD.statusface.frame = (leveltime)%2
			takis.HUD.statusface.priority = 1
		end
		
	end
	
	--isnt this just so retro?
	--god, if only i lived in retroville
	if TAKIS_NET.isretro
	and not noretrooverride
		takis.HUD.statusface.frame = 0
	end
	
	return takis.HUD.statusface.state, takis.HUD.statusface.frame
end

local function drawface(v,p)

	if (customhud.CheckType("takis_statusface") != modname) return end
	
	if (p.takis_noabil ~= nil) then return end
	
	local amiinsrbz = false
	
	if (gametype == GT_ZE2)
		amiinsrbz = true
	end
	
	if p.takistable.inNIGHTSMode
	or (TAKIS_NET.inspecialstage)
	or amiinsrbz
	or p.takistable.hhexiting
		return
	end

	local takis = p.takistable
	local me = p.mo
	
	if (takis.io.minhud) then return end
	
	local eflags = V_HUDTRANS
	
	local headcolor
	if p.spectator
		headcolor = SKINCOLOR_CLOUDY
		eflags = V_HUDTRANSHALF
	else
		if ((me) and (me.valid))
			headcolor = me.color
		else
			headcolor = SKINCOLOR_CLOUDY
			eflags = V_HUDTRANSHALF
		end
	end
	
	local pre = "TAK"
	local scale = 2*FU/5
	local x,y2 = 0,0
	if TAKIS_NET.isretro
		pre = "RETR_"
		scale = $*3
		x = -17*FU
		y2 = -20*FU
	end
	
	local healthstate,healthframe = calcstatusface(p,takis)	
	local headpatch
	local flip = false
	if (healthstate ~= "SPR2")
		headpatch = v.cachePatch(pre..healthstate..tostring(healthframe))
	else
		flip = true
		headpatch = v.getSprite2Patch(TAKIS_SKIN,me.sprite2,p.powers[pw_super] > 0,healthframe,2,0)
		scale = (2*FU/5)*8/5
		y2 = 7*FU
	end
	
	local y = 0
	local expectedtime = TR
	
	if HAPPY_HOUR.time and HAPPY_HOUR.time < 3*TR
	and HH_CanDoHappyStuff(p)
		local tics = HAPPY_HOUR.time
		
		if (tics < 2*TR)
			y = ease.inquad(( FU / expectedtime )*tics, 0, -60*FU)
		else
			y = ease.outquad(( FU / expectedtime )*(tics-(2*TR)), -60*FU, 0)
		end
	end
	
	if (TAKIS_NET.inbossmap)
	and (takis.HUD.bosscards.mo and takis.HUD.bosscards.mo.valid)
	and (takis.HUD.bosscards.mo and takis.HUD.bosscards.mo.health)
		eflags = $ &~(V_HUDTRANS|V_HUDTRANSHALF)
		eflags = $|(v.userTransFlag())
	end
	
	if (takis.inBattle) then y2 = $+battleoffset*FU end
	
	if flip == true then eflags = $|V_FLIP end
	v.drawScaled(20*FU+x,27*FU+y+y2,
		scale,
		headpatch,
		V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|eflags,
		v.getColormap((me and me.valid and me.colorized or p.spectator) and TC_RAINBOW or nil,headcolor)
	)

end

local function calcbossface(bosscards,me)
	local status = bosscards.statusface
	
	--idle
	status.state = "IDLE"
	status.frame = (leveltime/3)%2
	status.priority = 0
		
	if (bosscards.maxcards > 0)
	and (bosscards.cards <= 2)
		status.state = "LWHP"
		status.frame = (2*leveltime/3)%2
		status.priority = 0	
	end
	
	if status.priority < 10
		
		--dead
		if (not me.health)
		or (bosscards.cards == 0)
			status.state = "DEAD"
			status.frame = 0
			status.priority = 9
		end
	end
	
	if status.priority < 9
		
		--pain
		if (me.flags2 & MF2_FRET)
		or (me.state == me.info.painstate)
			status.state = "PAIN"
			status.frame = (leveltime%4)/2
			status.priority = 8
		end
		
	end
	
	
	if status.priority < 8
		
		--evil grin when killing someone
		-- --or attacking		
		if (me.p_target and me.p_target.valid)
		and (me.p_target.health == 0 
		or me.p_target.state == S_PLAY_PAIN
		or me.p_target.sprite2 == SPR2_PAIN)
		/*
		or (me.state == me.info.meleestate
		or me.state == me.info.missilestate)
		*/
			status.state = "EVL_"
			status.frame = (leveltime/4)%2
			status.priority = 7
		end
		
	end
	
	return status.state, status.frame
end

local function drawbossface(v,p)

	if (customhud.CheckType("takis_statusface") != modname) return end
	

	local takis = p.takistable
	local me = p.mo
	local bosscards = takis.HUD.bosscards
	
	if not (bosscards.mo and bosscards.mo.valid) then return end
	if not (bosscards.name) then return end
	if (bosscards.nocards or TAKIS_BOSSCARDS.nobosscards[bosscards.mo.type] ~= nil) then return end
	if (takis.inChaos) then return end
	if (takis.io.minhud) then return end
	
	local eflags = v.userTransFlag()
	
	local pre = TAKIS_BOSSCARDS.bossprefix[bosscards.mo.type]
	local scale = 2*FU/5
	
	if pre == nil then return end
	
	local healthstate,healthframe = calcbossface(bosscards,bosscards.mo)	
	local headpatch
	local headstring = pre..healthstate..tostring(healthframe)
	if not v.patchExists(headstring)
		pre = "TAK"
		headstring = pre..healthstate..tostring(healthframe)
		eflags = $|V_FLIP
	end
	
	headpatch = v.cachePatch(headstring)
	
	--tween in/out
	local et = TR/2
	local tween = 0
	if not (TAKIS_NET.inbossmap and bosscards.mo.health)
	and (bosscards.mo)
		local tics = min(bosscards.timealive or 0,et+1)
		tween = ease.outback((FU/et)*tics,-300*FU,0,FU*3/2)
	end
	
	v.drawScaled((300-5)*FU-tween,
		27*FU,
		scale,
		headpatch,
		V_SNAPTORIGHT|V_SNAPTOTOP|eflags,
		v.getColormap((bosscards.mo.flags2 & MF2_FRET and (leveltime % 2)) and TC_BOSS or nil)
	)

end

--      ----------

--RINGS ----------

local function drawrings(v,p)

	if (customhud.CheckType("rings") != modname) return end

	if p.takistable.inNIGHTSMode
	or (TAKIS_NET.inspecialstage)
	or p.takistable.inSRBZ
	or p.takistable.hhexiting
	or (p.takis_noabil ~= nil and p.rings == 0)
		return
	end

	
	local takis = p.takistable
	
	local ringpatch = takis.HUD.rings.sprite
	local flash = false
	
	if p.rings == 0
	and takis.heartcards <= 0
	and not (p.exiting)
		flash = true
	end
	
	if (p.rings <= 0)
	and ((not (gametyperules & GTR_FRIENDLY))
	or G_RingSlingerGametype()
	and not p.spectator)
		flash = true
	end
	
	flash = (flash and ((leveltime%(2*TR)) < 30*TR) and (leveltime/5 & 1))

	local eflag = V_HUDTRANS
	if p.spectator then eflag = V_HUDTRANSHALF end
	
	if not (takis.io.minhud)
		local ringFx,ringFy = unpack(takis.HUD.rings.FIXED)
		local ringx,ringy = unpack(takis.HUD.rings.int)
		
		if (p.takis_noabil ~= nil)
			ringx = 102
			if (takis.heartcards == TAKIS_MAX_HEARTCARDS)
				ringFy = 28*FU
				ringy = 15
			end
		end
		
		local val = p.rings
		
		if (takis.inBattle)
			ringFy = $+battleoffset*FU	
			ringy = $+battleoffset	
		end
		
		local spinframe = 0
		if takis.HUD.rings.ringframe ~= 0
			spinframe = FixedInt(takis.HUD.rings.spin) % takis.HUD.rings.ringframe
		end
		
		local patch,flip = v.getSpritePatch(ringpatch, spinframe, 0)
		if patch == nil
			if takis.HUD.rings.ringframe ~= 0
				patch = v.getSpritePatch(ringpatch, spinframe-1, 0)
				--still???
				if patch == nil
					patch = v.getSpritePatch(ringpatch, 0, 0)
				end
			else
				patch = v.getSpritePatch(ringpatch, 0, 0)
			end
		end
		eflag = $|(flip and V_FLIP or 0)
		
		if takis.HUD.rings.shake
			local s = takis.HUD.rings.shake
			local shakex,shakey = v.RandomFixed()/6,v.RandomFixed()/6
			
			local d1 = v.RandomRange(-1,1)
			local d2 = v.RandomRange(-1,1)
			if d1 == 0
				d1 = v.RandomRange(-1,1)
			end
			if d2 == 0
				d2 = v.RandomRange(-1,1)
			end
		
			shakex = $*s*d1
			shakey = $*s*d2
			ringFx = $+shakex
			ringFy = $+shakey
		end
		
		local colormap
		local tcolormap
		
		if G_GametypeHasTeams()
		and ringpatch == "TRNG"
			if p.spectator
				ringpatch = "RING"
			else
				colormap = v.getColormap(nil,p.ctfteam == 1 and skincolor_redring or skincolor_bluering)
			end
		end
		
		if flash
			tcolormap = v.getColormap(TC_RAINBOW,SKINCOLOR_RED)
		end
		
		--classic x = 102
		v.drawScaled(
			ringFx,
			ringFy,
			FU/2,
			patch,
			V_SNAPTOLEFT|V_SNAPTOTOP|eflag|V_PERPLAYER,
			colormap
		)
		
		local rings = (takis.HUD.rings.drawrings > 0) and tostring(takis.HUD.rings.drawrings) or "*"
		if rings:len() < 4
			for i = 1,4-rings:len()
				rings = "*"..$
			end
		end
		for i = rings:len(),1,-1
			local n = string.sub(rings,i,i)
			local number = (n ~= "*") and n or "0"
			local oflag = (n == "*") and V_HUDTRANSHALF or V_HUDTRANS
			local patch = v.cachePatch("STTNUM"+number)
			ringx = $-v.cachePatch("STTNUM0").width
			v.drawScaled(ringx*FU,
				ringy*FU,
				FU,
				patch,
				V_SNAPTOLEFT|V_SNAPTOTOP|(eflag &~(V_FLIP|V_HUDTRANS))|V_PERPLAYER|oflag,
				tcolormap
			)
				
		end
		
	else
 		
		local off = (takis.inBattle) and battleoffset or 0
		
		v.drawScaled(20*FU,
			52*FU+(off*FU),
			FU/4,
			v.getSpritePatch(ringpatch, A, 0, 0),
			V_SNAPTOLEFT|V_SNAPTOTOP|eflag|V_PERPLAYER,
			nil
		)
		v.drawString(45,45+off,
			p.rings,
			V_SNAPTOLEFT|V_SNAPTOTOP|eflag|V_PERPLAYER,
			"thin-right"
		)
		
	end
	
end

--      ----------

--TIMER ----------

--this is so minhud
-- https:--mb.srb2.org/addons/minhud.2927/
local function howtotimer(player)
	local flash, tics = false
	
	local pt, lt = player.realtime, leveltime
	local puretlimit, purehlimit = CV_FindVar("timelimit").value, CV_FindVar("hidetime").value
	local tlimit = puretlimit * 60 * TR
	local hlimit = purehlimit * TR
	local extratext = ''
	local extrafunc = ''
	local timertype = "regular"
	
	-- Counting down the hidetime?
	if (gametyperules & GTR_STARTCOUNTDOWN)
	and (pt <= hlimit)
		tics = hlimit - pt
		--match race nums
		tics = $+(TR-1)
		
		flash = true
		extrafunc = "countinghide"
		timertype = "counting"
	else
		
		-- Time limit?
		if (gametyperules & GTR_TIMELIMIT) 
		and (puretlimit) then -- Gotta thank CobaltBW for spotting this oversight.
			if (tlimit > pt)
				tics = (tlimit+(TR-1)) - pt
				--match race nums
				--tics = $+(TR-1)
			else -- Overtime!
				tics = 0
			end
			if ((gametyperules & (GTR_STARTCOUNTDOWN|GTR_TAG)) == (GTR_STARTCOUNTDOWN|GTR_TAG))
				if (tlimit+hlimit > pt)
					tics = (tlimit+hlimit+(TR-1)) - pt
					--tics = $+(TR-1)
				else -- Overtime!
					tics = 0
				end
			end
			
			flash = true
			timertype = "counting"
		-- Post-hidetime normal.
        elseif (gametyperules & GTR_STARTCOUNTDOWN)
		and (gametyperules & GTR_TIMELIMIT) -- Thanking 'im again.
			tics = pt-hlimit
        elseif (gametyperules & GTR_STARTCOUNTDOWN)
            tics = pt
			tics = $+hlimit
			extrafunc = "hiding"
			timertype = "counting"
		--level timelimit
		elseif (mapheaderinfo[gamemap].countdown)
			local tlimit = (mapheaderinfo[gamemap].countdown*TR)
			if tlimti > rt
				tics = tlimit-rt
			else
				tics = 0
			end
			flash = true
		else
            tics = pt
        end
	end
	
	flash = (flash and (tics < 30*TR) and (lt/5 & 1)) -- Overtime?
	
	return flash, tics, extratext, extrafunc, timertype
end

local function drawtimer(v,p,altpos)

	if (customhud.CheckType("time") != modname) return end
	
	if altpos == nil then altpos = false end
	
	if p.takistable.inNIGHTSMode
	or (TAKIS_NET.inspecialstage)
	or p.takistable.inSRBZ
	or HAPPY_HOUR.othergt
		return
	end
	
	local takis = p.takistable
	local cd = takis.HUD.countdown
	
	--time
	--this is so minhud
	local flashflag = 0
	local flash,timetic,extratext,extrafunc,type = howtotimer(p)
	
	if (type == "regular"
	and (gametype == GT_COOP))
	and (not altpos)
	and not modeattacking
	and not (takis.io.minhud)
		if not p.exiting then return end
	end
	
	if (takis.io.minhud)
	and (p.takis_noabil ~= nil)
	and not p.exiting
		return
	end
	
	if flash
		flashflag = V_REDMAP
	end
	
	local hours = G_TicsToHours(timetic)
	local minutes = G_TicsToMinutes(timetic, false)
	local seconds = G_TicsToSeconds(timetic)
	local tictrn  = G_TicsToCentiseconds(timetic)
	local spad, tpad = '', ''
	local extra = ''
	local extrac = ''
	
	--paddgin!!
	if (seconds < 10) then spad = '0' end
	if (tictrn < 10) then tpad = '0' end
	
	local timex, timey = unpack(takis.HUD.timer.int)
	local timetx = takis.HUD.timer.text
			
	if hours > 0
		extrac = ":"
		if (minutes < 10)
			extrac = $.."0"
		end
	else
		hours = ''
	end
	
	if timetic >= (10*60*TR)
	and extrafunc == ''
		extra = " (SUCKS)"
	end
	
	/*
	if p.spectator
		timex, timey = unpack(takis.HUD.timer.spectator)
	elseif ( ((p.pflags & PF_FINISHED) and (netgame))
	or extrafunc == "hiding"
	or extrafunc == "countinghide")
	and not p.exiting
		timex, timey = unpack(takis.HUD.timer.finished)
	end
	*/
	
	local flag = V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER|flashflag
	if altpos
		flag = $ &~V_HUDTRANS
		if multiplayer
			flag = $ &~(V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER)
			timetx = 4
			timex = timetx+103
			timey = 184
		end
	end
	if (takis.inBattle)
		timey = 25
		timex = 160
		flag = $ &~V_SNAPTOLEFT
		if (gametype == GT_DIAMOND)
		or (gametype == GT_TEAMDIAMOND)
		or (gametype == GT_CP)
		or (gametype == GT_TEAMCP)
			timey = $+10
		end
	end
	
	if (takis.io.minhud)
	and not takis.inBattle
		timex = 100
		timey = 45
		
		v.drawScaled(50*FU,
			44*FU,
			FU,
			v.cachePatch("NGRTIMER"),
			flag
		)
			
	end
	
	v.drawString(timex, timey, hours..extrac..minutes..":"..spad..seconds.."."..tpad..tictrn,flag,((takis.inBattle) and "thin-center" or "thin-right"))
	if not takis.inBattle
	and (takis.io.minhud == 0)
		v.drawString(timetx, timey, "Time"..extra,flag,"thin")
	end
	if extrastring ~= ''
	and (takis.io.minhud == 0)
		v.drawString(timetx, timey+8, extratext,flag,"thin")			
	end
	
	--countdown
	if cd.tics
		if cd.tics == 1 then return end
		local trans = 0
		if cd.tics <= 9
			trans = (10-cd.tics)<<V_ALPHASHIFT
		end
		
		local scorenum = "CMBCF"
		local score = cd.number
		local prevw
		if not prevw then prevw = 0 end
		local scale = 2*FU+cd.scale+cd.scale2
		
		local textwidth = 0
		for i = 1,string.len(score)
			local n = string.sub(score,i,i)
			local patch = v.cachePatch(scorenum+n)
			textwidth = $+(patch.width*scale*4/10)		
		end
		
		for i = 1,string.len(score)
			local sc = FixedDiv(scale,2*FU)
			local n = string.sub(score,i,i)
			local patch = v.cachePatch(scorenum+n)
			--local textwidth = (patch.width*scale*4/10)
			v.drawScaled(160*FU+prevw-(textwidth/2),
				145*FU-(patch.height/2*sc)+6*FU-(FU/2),
				sc,
				patch,
				trans
			)
				
			prevw = $+(patch.width*scale*4/10)
		end
	
	end

end

--      ----------

--SCORE ----------

local function drawscore(v,p)

	if (customhud.CheckType("score") != modname) return end
	
	if p.takistable.inNIGHTSMode
	or (TAKIS_NET.inspecialstage)
	or p.takistable.inSRBZ
	or (p.takis_noabil ~= nil)
		return
	end
	
	if (PTSR)
		if PTSR.intermission_tics
		or (PTSR:inVoteScreen())
			return
		end
	end
	
	--some of
	if (gametype == GT_TEAMARENA)
	or (gametype == GT_SURVIVAL)
	or (gametype == GT_TEAMSURVIVAL)
	or (gametype == GT_DIAMOND)
	or (gametype == GT_TEAMDIAMOND)
	or (gametype == GT_CP)
	or (gametype == GT_TEAMCP)
	and (takis.inBattle)
		return
	end
	
	local takis = p.takistable
	
	local fs = takis.HUD.flyingscore
	local xshake = fs.xshake
	local yshake = fs.yshake
		
	/*
	if fs.tics
	and (takis.io.minhud == 0)
		score = p.score-fs.lastscore
	end
	*/
	--v.drawString((300-15)*FU+xshake, 15*FU+yshake, takis.HUD.flyingscore.scorenum,V_SNAPTORIGHT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER,"fixed-right")
	
	--buggie's tf2 engi code
	local scorenum = "SCREFT"
	local score = fs.scorenum
	local align = "right"
	
	if ((takis.HUD.lives.useplacements
	and takis.placement == 1)
	or (score >= 99999990))
		scorenum = "GSCREFT"
	end
	
	local prevw
	if not prevw then prevw = 0 end
	
	--alignment stuff
	--14 pixels away from edge like timer
	local x,y = 300-2+(v.cachePatch(scorenum.."1").width*4/10),15
	
	if takis.HUD.bosscards.mo and takis.HUD.bosscards.mo.valid
	and not (takis.HUD.bosscards.nocards
	or TAKIS_BOSSCARDS.nobosscards[takis.HUD.bosscards.mo.type] ~= nil)
		y = $+30
	end
	
	local snap = V_SNAPTORIGHT|V_SNAPTOTOP
	if takis.inChaos
		x = 303
		y = 55
	end
	
	if (gametype == GT_ARENA)
		x = 160
		y = 35
		align = "center"
		snap = V_SNAPTOTOP
	end
	
	local width = FixedMul(string.len(score)*FU,(v.cachePatch(scorenum.."1").width*FU*4/10))
	if align == "center"
		width = $/2
	elseif align ~= "right"
		width = 0
	end
	--
	
	--correct for width-1
	fs.scorex, fs.scorey = x,y
	fs.scorea = align
	fs.scores = snap
	
	for i = 1,string.len(score)
		local n = string.sub(score,i,i)
		v.drawScaled((x+prevw)*FU+xshake-width,
			y*FU+yshake,
			FU/2,
			v.cachePatch(scorenum+n),
			snap|V_HUDTRANS|V_PERPLAYER
		)
			
		prevw = $+v.cachePatch(scorenum+n).width*4/10
	end
	
	if fs.tics
	and (takis.io.minhud == 0)
		local expectedtime = 2*TR
		local tics = ((2*TR)+1)-fs.tics
		
		local total_width = (v.width() / v.dupx()) + 1
		local total_height = (v.height() / v.dupy()) + 1
		
		local cxpos = (160*FU-(total_width*FU/2))+takis.HUD.combo.basex
		local cypos = ((100*FU)-(total_height*FU/2))+takis.HUD.combo.basey

		local sxpos = (160*FU+(total_width*FU/2))-(300*FU-((x*FU)+((v.cachePatch(scorenum.."1").width*4/10)*FU)))
		local sypos = ((100*FU)-(total_height*FU/2))+(y*FU)
		
		local fx = ease.inexpo(
			( FU / expectedtime )*tics,
			cxpos+5*FU+takis.HUD.combo.patchx, 
			sxpos
		)
		local fy = ease.inexpo(
			( FU / expectedtime )*tics,
			cypos+7*FU, 
			sypos
		)
		
		v.drawString(fx, fy, 
			fs.num,
			V_HUDTRANS|V_PERPLAYER,
			"thin-fixed-center"
		)
		
	end
end

--      ----------

--LIVES ----------

local function getnamemap(name)
	local map = V_YELLOWMAP
	if name == "Rakis"
	or name == "Raykis"
	or name == "Sjakis"
		map = V_REDMAP
	elseif name == "Taykis"
	or name == "Takeys"
		map = V_GREENMAP
	elseif name == "Blukis"
		map = V_BLUEMAP
	elseif name == "Golkis"
		map = (leveltime/4 % 3 == 0) and V_YELLOWMAP or ((leveltime/4 % 3 == 1 or leveltime/4 % 3 == 3) and V_BROWNMAP or V_ORANGEMAP)
	elseif name == "Rakeys"
		map = V_MAGENTAMAP
	elseif name == "Poyo"
	or name == "Speckis"
		map = V_INVERTMAP
	elseif name == "Jsakis"
		map = V_AZUREMAP
	end
	return map
end

local function drawlivesbutton(v,p,x,y,flags)
	local me = p.mo
	local takis = p.takistable
	
	local disp = 0
	
	if takis.HUD.lives.tweentic
		local et = TR/2
		local tic = (5*TR)-takis.HUD.lives.tweentic
		local low = 0
		local high = 35*FU
		
		if tic <= TR/2
			disp = ease.outback((FU/et)*tic,low, high, FU*3/2)
		elseif tic >= 4*TR+TR/2
			disp = ease.inquad((FU/et)*((4*TR+TR/2)-tic), high, low)
		else
			disp = high
		end
		
		disp = -$
	end
	
	if (takis.clutchcombo)
	and (takis.io.clutchstyle == 0)
		disp = $-2*FU
	end
	
	if (modeattacking)
		if p.pflags & PF_AUTOBRAKE
			disp = $-10*FU
		else
			disp = $-5*FU
		end
	end
	
	if ((takis.firenormal)
	or (takis.HUD.rthh.sptic or takis.io.savestate ~= 0))
	and not takis.HUD.lives.tweentic
		disp = $-35*FU
	end
	
	if (p.inkart and not p.takistable.HUD.lives.nokarthud)
		disp = $-33*FU
	end
	
	if not p.inkart
		if (takis.transfo & TRANSFO_SHOTGUN)
		and (takis.shotgunforceon == false)
			local bflag = V_HUDTRANS
			if takis.hammerblastdown then bflag = V_HUDTRANSHALF end
			v.drawScaled(x, y+disp, (FU/2)+(FU/12), v.cachePatch("TB_C3"), flags|bflag)
			v.drawString(x+20*FU, y+disp+5*FU, "De-Shotgun",V_ALLOWLOWERCASE|flags|V_HUDTRANS, "thin-fixed")	
			disp = $-20*FU
		end
	
		if (p.powers[pw_shield] ~= SH_NONE)
			local shieldflag = V_HUDTRANSHALF
			shieldflag = (not(takis.noability&NOABIL_SHIELD)) and V_HUDTRANS or V_HUDTRANSHALF
			
			v.drawScaled(x, y+disp, (FU/2)+(FU/12), v.cachePatch("TB_C2"), flags|shieldflag)
			v.drawString(x+20*FU, y+disp+5*FU, "Shield Ability",V_ALLOWLOWERCASE|flags|V_HUDTRANS, "thin-fixed")
			disp = $-20*FU
		end
	else
		v.drawScaled(x, y+disp, (FU/2)+(FU/12), v.cachePatch("TB_C3"), flags|V_HUDTRANS)
		v.drawString(x+20*FU, y+disp+5*FU, "Look behind",V_ALLOWLOWERCASE|flags|V_HUDTRANS, "thin-fixed")	
		disp = $-20*FU
		
		if not TAKIS_NET.forcekart
			v.drawScaled(x, y+disp, (FU/2)+(FU/12), v.cachePatch("TB_C2"), flags|V_HUDTRANS)
			v.drawString(x+20*FU, y+disp+5*FU, "Dismount",V_ALLOWLOWERCASE|flags|V_HUDTRANS, "thin-fixed")
			disp = $-20*FU
		end
	end
	
	if (p.powers[pw_carry] == CR_MINECART)
		v.drawScaled(x, y+disp, (FU/2)+(FU/12), v.cachePatch("TB_C1"), flags|V_HUDTRANS)
		v.drawString(x+20*FU, y+disp+5*FU, "Break Minecart",V_ALLOWLOWERCASE|flags|V_HUDTRANS, "thin-fixed")
	end
	
	if (takis.nocontrol and takis.taunttime)
	and (takis.tauntid ~= 6)
		v.drawScaled(x,
			y+disp,
			(FU/2)+(FU/12),
			v.cachePatch("TB_C1"),
			flags|V_HUDTRANS
		)
		v.drawString(x+20*FU,
			y+disp+5*FU,
			"Cancel Taunt",
			V_ALLOWLOWERCASE|flags|V_HUDTRANS,
			"thin-fixed"
		)
	end

end

local function drawemeralds(v,emeraldpics,x,y,scale,f,pemeralds)
	--epic source :iwantsummadat:
	-- https://github.com/STJr/SRB2/blob/master/src/hu_stuff.c#L2754
	
	if (pemeralds & EMERALD1)
		v.drawScaled(x  , y-6*FU, scale, emeraldpics[0], f);
	end
	
	if (pemeralds & EMERALD2)
		v.drawScaled(x+4*FU, y-3*FU, scale, emeraldpics[1], f);
	end

	if (pemeralds & EMERALD3)
		v.drawScaled(x+4*FU, y+3*FU, scale, emeraldpics[2], f);
	end

	if (pemeralds & EMERALD4)
		v.drawScaled(x  , y+6*FU, scale, emeraldpics[3], f);
	end

	if (pemeralds & EMERALD5)
		v.drawScaled(x-4*FU, y+3*FU, scale, emeraldpics[4], f);
	end

	if (pemeralds & EMERALD6)
		v.drawScaled(x-4*FU, y-3*FU, scale, emeraldpics[5], f);
	end

	if (pemeralds & EMERALD7)
		v.drawScaled(x  , y  , scale, emeraldpics[6], f);	
	end
	
end

--ordinal numbers
local placetext = {
	[1] = ",",
	[2] = ":",
	[3] = "!",
	
	[21] = ",",
	[22] = ":",
	[23] = "!",
	
	[31] = ",",
	[32] = ":",
	[33] = "!",
}

local placetext2 = {
	[","] = "ST",
	[":"] = "ND",
	["!"] = "RD",
	["?"] = "TH",
}

local placestring = {
	[0] = '',
	[1] = "P",	--gold font
	[2] = "S",	--silver font
	[3] = "B",	--bronze font
}

local function isplayerlosing(p)
	local winningpos = 1
	local pcount = 0
	local takis = p.takistable
	
	if takis.placement == 1
		return false
	end
	
	for player in players.iterate
		if (player.spectator)
			continue
		end
		if not player.takistable
			continue
		end
		if player.takistable.placement > pcount
			pcount = player.takistable.placement
		end
	end
	
	if pcount <= 1
		return false
	end
	
	winningpos = pcount/2
	if (pcount % 2)
		winningpos = $+1
	end
	
	return (takis.placement > winningpos)
	
end

--i guess we could put placements here in match
local function drawlivesarea(v,p)

	if (customhud.CheckType("lives") != modname) return end
	
	if p.takistable.inNIGHTSMode
	or (TAKIS_NET.inspecialstage)
	or p.takistable.inSRBZ
	or (p.textBoxInAction)
	or (TAKIS_DEBUGFLAG & (DEBUG_SPEEDOMETER|DEBUG_BUTTONS))
	or p.takistable.hhexiting
	or (p.takis_noabil ~= nil)
		return
	end
	
	local me = p.mo
	local takis = p.takistable
	
	local x = takis.HUD.lives.tweenx
	local y = 190*FU
	local flags = V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER
	local contpatch = v.getSprite2Patch(TAKIS_SKIN,SPR2_XTRA,false,C,0,0)
	local nolivestext = false
	
	drawlivesbutton(v,p,15*FU,y-20*FU,flags)
	
	if (p.inkart and not p.takistable.HUD.lives.nokarthud) then return end
	
	if not (p.skincolor)
	or modeattacking
		return
	end
	
	local infinite = false
	
	if (G_GametypeUsesLives())
		if CV_FindVar("cooplives").value == 0
			infinite = true
		end
	elseif (G_PlatformGametype() and not (gametyperules & GTR_LIVES))
		infinite = true
	elseif G_RingSlingerGametype() and not (gametyperules & GTR_FRIENDLY)
		infinite = true
	else
		nolivestext = true
	end
	
	
	if takis.isSinglePlayer
		if p.lives ~= INFLIVES
			infinite = false
		else
			infinite = true
		end
	end
	
	if infinite then nolivestext = true end
	
	local colorized = false
	if (p.spectator)
	or (p.ctfteam == 1 or p.ctfteam == 2)
	and G_GametypeHasTeams()
		colorized = true
		nolivestext = true
	end
	
	local color = v.getColormap((colorized) and TC_RAINBOW or nil,(p.spectator) and SKINCOLOR_CLOUDY or p.skincolor)
	local textmap = getnamemap(takis.HUD.hudname)
	
	--this is juuust wide enough to peak out from the side
	if takis.HUD.lives.tweentic
		v.drawScaled(x,y,FU,v.cachePatch("TA_LIVESBACK"),
			(flags &~(V_HUDTRANS|V_HUDTRANSHALF)|V_HUDTRANSHALF)
		)
	end
	
	if p.spectator
		flags = $|V_HUDTRANSHALF
		textmap = V_GRAYMAP
	else
		flags = $|V_HUDTRANS
		if G_GametypeHasTeams()
			if p.ctfteam == 1
				textmap = V_REDMAP
			elseif p.ctfteam == 2
				textmap = V_BLUEMAP
			end
			
			v.drawString(x+52*FU,
				y-8*FU,
				(p.ctfteam == 1) and "red" or "blu",
				flags|((p.ctfteam == 1) and V_REDMAP or V_BLUEMAP),
				"fixed-right"
			)
	
		elseif (gametyperules & GTR_TAG)
			if (p.pflags & PF_TAGIT)
				v.drawString(x+52*FU,
					y-8*FU,
					"it!",
					flags,
					"fixed-right"
				)
				textmap = V_ORANGEMAP
			end
			nolivestext = true
		end
	end
	
	v.drawScaled(x+10*FU,y,FU,contpatch,flags,color)
	
	if not nolivestext
		local lives = takis.oldlives
		
		/*
		if CV_FindVar("cooplives").value == 3
		and (netgame or multiplayer)
			lives = TAKIS_MISC.livescount
		end
		*/
		
		local scorenum = "CMBCF"
		if lives >= 99
			scorenum = "CMBCFP"
		end
		local score = lives
		local scale = FU
		
		local prevw
		if not prevw then prevw = 0 end
		
		local textwidth = 0
		for i = 1,string.len(score)
			local n = string.sub(score,i,i)
			local patch = v.cachePatch(scorenum+n)
			textwidth = $+(patch.width*scale*4/10)		
		end
		
		for i = 1,string.len(score)
			local sc = FixedDiv(scale,2*FU)
			local n = string.sub(score,i,i)
			local patch = v.cachePatch(scorenum+n)
			--local textwidth = (patch.width*scale*4/10)
			v.drawScaled(x+prevw-textwidth+50*FU,
				y-(patch.height*sc)+6*FU-(FU/2)-takis.HUD.lives.bump,
				sc,
				patch,
				flags
			)
				
			prevw = $+(patch.width*scale*4/10)
		end
	else
		--match placements
		if takis.HUD.lives.useplacements
		and not (p.spectator or G_GametypeHasTeams())
			local top3 = takis.placement and takis.placement < 4
			local inlosingplace = isplayerlosing(p)
			local losing = inlosingplace and (leveltime/4 & 1)
			local scorenum = "CMBCF"
			local score = takis.placement
			score = $..(placetext[takis.placement] or "?")
			local scale = FU
			
			if (gametyperules & GTR_RACE)
			and circuitmap
				local maxlaps = CV_FindVar("numlaps").value
				if p.laps == maxlaps-1 
				or (p.pflags & PF_FINISHED)
				or (p.exiting)
					scorenum = (top3 and not inlosingplace) and "CMBCF"..placestring[takis.placement] or (losing and "CMBCFR" or "CMBCF")
				end
			else
				scorenum = (top3 and not inlosingplace) and "CMBCF"..placestring[takis.placement] or (losing and "CMBCFR" or "CMBCF")
			end
			
			local prevw
			if not prevw then prevw = 0 end
			
			local textwidth = 0
			for i = 1,string.len(score)
				local n = string.sub(score,i,i)
				local patch = v.cachePatch(scorenum+n)
				if placetext2[n] ~= nil
					patch = v.cachePatch(scorenum..placetext2[n])
				end
				textwidth = $+(patch.width*scale*4/10)		
			end
			
			for i = 1,string.len(score)
				local sc = FixedDiv(scale,2*FU)
				local n = string.sub(score,i,i)
				local patch = v.cachePatch(scorenum+n)
				if placetext2[n] ~= nil
					patch = v.cachePatch(scorenum..placetext2[n])
				end
				v.drawScaled(x+prevw-textwidth+50*FU,
					y-(patch.height*sc)+6*FU-(FU/2)-takis.HUD.lives.bump,
					sc,
					patch,
					flags
				)
					
				prevw = $+(patch.width*scale*4/10)
			end
		end
	end
	
	v.drawString(x+52*FU,
		y-18*FU,
		takis.HUD.hudname,
		flags|V_ALLOWLOWERCASE|textmap,
		"thin-fixed-right"
	)
	
	local disp = 0
	
	--powerstones
	if (gametyperules & GTR_POWERSTONES)
	and (CV_FindVar("powerstones").value)
		disp = 15*FU
		
		local emeraldpics = {
			[0] = v.cachePatch("TEMER1"),
			[1] = v.cachePatch("TEMER2"),
			[2] = v.cachePatch("TEMER3"),
			[3] = v.cachePatch("TEMER4"),
			[4] = v.cachePatch("TEMER5"),
			[5] = v.cachePatch("TEMER6"),
			[6] = v.cachePatch("TEMER7"),
		}
		
		local stop
		if (leveltime & 1)
		and p.powers[pw_invulnerability]
		and (p.powers[pw_sneakers] ==
		p.powers[pw_invulnerability])
			drawemeralds(v,
				emeraldpics,
				x+63*FU,
				y-10*FU,
				FU/2,
				(flags &~(V_HUDTRANS|V_HUDTRANSHALF)|V_HUDTRANS),
				127		--allemeralds
			)		
			stop = true
		end
		
		if not stop
			drawemeralds(v,
				emeraldpics,
				x+63*FU,
				y-10*FU,
				FU/2,
				(flags &~(V_HUDTRANS|V_HUDTRANSHALF)|V_HUDTRANS),
				p.powers[pw_emeralds]
			)
		end
	end
	
	if takis.HUD.rthh.sptic
		local tic = takis.HUD.rthh.sptic
		local tween = 0
		
		local et = TR/2
		if tic >= 2*TR+et
			local tics = (3*TR)-takis.HUD.rthh.sptic
			tween = ease.outback((FU/et)*tics,40*FU,0,FU*3/2)
		elseif tic <= et
			local tics = et-takis.HUD.rthh.sptic
			tween = ease.inexpo((FU/et)*tics,0,40*FU)
		end
		
		v.drawString(
			x+60*FU,
			y-20*FU+tween,
			"Checkpoint!",
			V_YELLOWMAP|(flags &~(V_HUDTRANS|V_HUDTRANSHALF)|V_HUDTRANS|V_ALLOWLOWERCASE),
			"thin-fixed"
		)
		local frame = (5*leveltime/6)%14
		local patch = v.cachePatch("TAHHS"..frame)
		v.drawScaled(x+60*FU+((v.stringWidth("Checkpoint!",0,"thin"))*FU/2)-(v.cachePatch("TAHHS0").width*FU/4),
			y-10*FU+tween,
			FU/2,
			patch,
			(flags &~(V_HUDTRANS|V_HUDTRANSHALF))|V_HUDTRANS
		)
		disp = $+55*FU
	end
	
	if (p.ptsr)
	and me.pfstuntime
	and p.ptsr.pizzaface
		v.drawScaled(
			x+60*FU+disp,
			y-24*FU,
			FU,
			v.cachePatch("TA_ICE2"),
			(flags &~(V_HUDTRANS|V_HUDTRANSHALF))|V_HUDTRANS
		)
		
		local stunmax = CV_PTSR.pizzatimestun.value*TR
		local stuntime = me.pfstuntime
		local tics = L_FixedDecimal(FixedDiv(stuntime*FU,TR*FU),1)
		
		local erm = FixedDiv(stuntime*FU,stunmax*FU)
		local height = v.cachePatch("TA_ICE").height*FU - FixedMul(erm,v.cachePatch("TA_ICE").height*FU)
		if height < 0 then
			height = 0
		end
		
		v.drawCropped(
			x+60*FU+disp,
			y-24*FU+height,
			FU,FU,
			v.cachePatch("TA_ICE"),
			(flags &~(V_HUDTRANS|V_HUDTRANSHALF))|V_HUDTRANS,
			nil,
			0,height,
			v.cachePatch("TA_ICE").width*FU,
			v.cachePatch("TA_ICE").height*FU
		)
		
		v.drawString(x+60*FU+disp+(v.cachePatch("TA_ICE").width*FU/2),
			y-27*FU+(v.cachePatch("TA_ICE").height*FU/2),
			tics,
			(flags &~(V_HUDTRANS|V_HUDTRANSHALF))|V_HUDTRANS|V_YELLOWMAP,
			"thin-fixed-center"
		)
		
		disp = $+30*FU
		
	end
	
	if takis.io.savestate ~= 0
		local state = "IDLE"
		if takis.io.savestate == 2
			state = "GOOD"
		elseif takis.io.savestate == 3
			state = "BAD"
		elseif takis.io.savestate == 4
			state = "WARN"
		end
		
		v.drawScaled(
			x+70*FU+disp,
			y-8*FU,
			FU,
			v.cachePatch("TA_SAVE_"..state),
			(flags &~(V_HUDTRANS|V_HUDTRANSHALF))|V_HUDTRANS
		)
		
		if not takis.io.loaded
		and takis.io.loadtries > 1
			local scorenum = (leveltime/4) % 2 and "CMBCF" or "CMBCFR"
			local score = takis.io.loadtries
			local scale = FU
			
			local prevw
			if not prevw then prevw = 0 end
			
			local textwidth = 0
			for i = 1,string.len(score)
				local n = string.sub(score,i,i)
				local patch = v.cachePatch(scorenum+n)
				textwidth = $+(patch.width*scale*4/10)		
			end
			
			for i = 1,string.len(score)
				local sc = FixedDiv(scale,2*FU)
				local n = string.sub(score,i,i)
				local patch = v.cachePatch(scorenum+n)
				--local textwidth = (patch.width*scale*4/10)
				v.drawScaled(x+prevw-textwidth+80*FU+disp,
					y-(patch.height*sc)+5*FU,
					sc,
					patch,
					(flags &~(V_HUDTRANS|V_HUDTRANSHALF))|V_HUDTRANS
				)
					
				prevw = $+(patch.width*scale*4/10)
			end
		end
		
		disp = $+25*FU
	end
	
	--lives fill
	if (takis.firenormal)
	--?
	--and not (takis.HUD.lives.tweentic)
		local openingmenu = false
		if (takis.c2 or takis.c3) then openingmenu = true end
		
		local fn = min(takis.firenormal,TR)
		local c2 = min(takis.c2,TR)
		local c3 = min(takis.c3,TR)
		
		local timetic = FixedDiv(fn*FU,TR*FU)
		
		if openingmenu
			timetic = FixedDiv(
				(fn*FU)+(c2*FU)+(c3*FU),
				3*TR*FU
			)
		end
		
		local percent = FixedMul(100*FU,timetic)
		
		local pre = "TA_LIVESFILL_"
		/*
		local erm = FixedDiv(percent,100*FU)
		local height = v.cachePatch(pre.."FILL").height*FU - FixedMul(erm,v.cachePatch(pre.."FILL").height*FU)
		if height < 0 then
			height = 0
		end
		*/
		local scale = FU
		
		--back
		v.drawScaled(x+80*FU+disp,y-10*FU,scale,
			v.cachePatch(pre.."BACK"),
			(flags &~(V_HUDTRANS|V_HUDTRANSHALF)|V_HUDTRANSHALF)
		)		
		
		local maxsegs = 50
		local fx,fy = x+80*FU+disp,y-10*FU
		for i = 0,maxsegs,1
			if timetic == 0 then break end
			
			local angmath = 
			FixedMul(
				FixedDiv(
					FixedMul(360*FU,timetic),
					maxsegs*FU
				),
				i*FU
			)-90*FU
			local angle = FixedAngle(angmath)
			v.drawScaled(
				fx+(9*cos(angle)),
				fy+(9*sin(angle)),
				FU/2,
				v.cachePatch(pre.."BALL"),
				(flags &~(V_HUDTRANS|V_HUDTRANSHALF)|V_HUDTRANS),
				v.getColormap(0,openingmenu and SKINCOLOR_GREEN or SKINCOLOR_WHITE)
			)
		end
		
		/*
		v.drawCropped(x+80*FU+disp,y-10*FU+FixedMul(height,SKINCOLOR_WHITEscale),scale,scale,
			v.cachePatch(pre.."FILL"),
			V_ADD|(flags &~(V_HUDTRANS|V_HUDTRANSHALF)|V_HUDTRANSHALF), 
			v.getColormap(0,openingmenu and SKINCOLOR_GREEN or SKINCOLOR_WHITE),
			0,height,
			v.cachePatch(pre.."FILL").width*FU,
			v.cachePatch(pre.."FILL").height*FU
		)
		*/
		
		local string = L_FixedDecimal(percent,1).."%"
		v.drawString(
			x+80*FU+disp,
			y-13*FU,
			string,
			(flags &~(V_HUDTRANS|V_HUDTRANSHALF)|V_HUDTRANS),
			"thin-fixed-center"
		)
		
		local showing = takis.HUD.lives.tweentic > 0
		if (5*TR)-takis.HUD.lives.tweentic > 4*TR+(TR/2)
			showing = false
		end
		
		if not (showing and not openingmenu)
			v.drawString(
				x+95*FU+disp,
				y-13*FU,
				openingmenu and (modeattacking and "Menu disabled" or "Open menu") or "Show lives",
				(flags &~(V_HUDTRANS|V_HUDTRANSHALF)|V_HUDTRANS|V_ALLOWLOWERCASE),
				"thin-fixed"
			)		
		end
	end
	
	
end

--      ----------

--CLUTCH----------

local function drawclutches(v,p,cam)

	if (customhud.CheckType("takis_clutchstuff") != modname) return end
	
	/*
	if p.takistable.inNIGHTSMode
	or (TAKIS_NET.inspecialstage)
		return
	end
	*/
	
	local takis = p.takistable
	local me = p.mo
	
	if (takis.io.clutchstyle == 0)
		local y = hudinfo[HUD_LIVES].y*FU
		
		if takis.HUD.lives.tweentic
			local et = TR/2
			local tic = (5*TR)-takis.HUD.lives.tweentic
			local low = hudinfo[HUD_LIVES].y*FU
			local high = hudinfo[HUD_LIVES].y*FU-35*FU
			
			if tic <= TR/2
				y = ease.outback((FU/et)*tic,low, high, FU*3/2)
			elseif tic >= 4*TR+TR/2
				y = ease.inquad((FU/et)*((4*TR+TR/2)-tic), high, low)
			else
				y = high
			end
			
		end
		if (modeattacking)
			if p.pflags & PF_AUTOBRAKE
				y = $-10*FU
			else
				y = $-5*FU
			end
		end
		if ((takis.firenormal)
		and not takis.HUD.lives.tweentic)
		or (takis.HUD.rthh.sptic)
			y = $-35*FU
		end
	
		if takis.clutchtime > 0
			local barx = hudinfo[HUD_LIVES].x*FU
			local bary = y+20*FU
			local color = SKINCOLOR_CRIMSON
			local pre = "CLTCHBAR_"
				
			if (takis.clutchtime <= 11)
			and (takis.clutchtime > 0)
				color = SKINCOLOR_GREEN
			end
			
			
			v.drawScaled(barx, bary, FU, v.cachePatch(pre.."BACK"),
				V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_HUDTRANS|V_PERPLAYER
			)
			
			local max = 23*FU
			local timer = (23-takis.clutchtime)*FU
			local erm = FixedDiv((timer),max)
			local width = FixedMul(erm,v.cachePatch(pre.."FILL").width*FU)
			if width < 0 then
				width = 0
			end
			local scale = FU
			
			v.drawCropped(barx,bary,scale,scale,
				v.cachePatch(pre.."FILL"),
				V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_HUDTRANS|V_PERPLAYER, 
				v.getColormap(nil,color),
				0,0,
				width,v.cachePatch(pre.."FILL").height*FU
			)
			
			v.drawScaled(barx, bary, FU, v.cachePatch(pre.."MARK"),
				V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_HUDTRANS|V_PERPLAYER
			)
		end
		--clutch combo
		if takis.clutchcombo
			
			v.drawString(hudinfo[HUD_LIVES].x*FU,
				y+10*FU,
				takis.clutchcombo.."x BOOSTS",
				V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_HUDTRANS|V_PERPLAYER|V_ALLOWLOWERCASE,
				"fixed"
			)
			
		end
	elseif (takis.io.clutchstyle == 1)
		--chrispy chars
		local player = p
		local mo = player.realmo
		local color = SKINCOLOR_CRIMSON
		local pre = "CLTCHMET_"
		
		if (takis.clutchtime <= 11)
		and (takis.clutchtime > 0)
			color = SKINCOLOR_GREEN
		end
		
		local flip = 1
		local bubble = v.cachePatch(pre.."BACK")
		local angdiff = ANGLE_90
		local x, y, scale, nodraw
		local cutoff = function(y) return false end
		
		if cam.chase and not (player.awayviewtics and not takis.in2D)
			x, y, scale, nodraw = R_GetScreenCoords(v, player, cam, mo)
			if nodraw then return end
			
			scale = $*2
			if mo.eflags & MFE_VERTICALFLIP
			and player.pflags & PF_FLIPCAM
				y = 200*FRACUNIT - $
			else
				flip = P_MobjFlip(mo)
			end
			scale = FixedMul($,mo.scale)
		else
			x, y, scale = 160*FRACUNIT, (100 + bubble.height >> 1)*FRACUNIT, FRACUNIT
		end
		
		if splitscreen
			if player == secondarydisplayplayer
				cutoff = function(y) return y < (bubble.height*scale >> 1) end
			else
				cutoff = function(y) return y > 200*FRACUNIT + (bubble.height*scale >> 1) end
			end
		end
		
		local angle = angdiff + ANGLE_90
		local x = x - P_ReturnThrustX(nil, angle, 40*scale)
		local y = y - flip*P_ReturnThrustY(nil, angle, 70*scale)
			
		if not cutoff(y)
			if takis.clutchcombo
				v.drawString(x,y,
					"x"..takis.clutchcombo,
					V_PERPLAYER|V_HUDTRANS|V_ALLOWLOWERCASE,
					"fixed"
				)
				v.drawString(x,y+(8*FU),
					"boosts",
					V_PERPLAYER|V_HUDTRANS,
					"thin-fixed"
				)
			end
			if (takis.clutchspamcount)
			and not (takis.clutchcombo)
				if (takis.clutchspamcount >= 3)
				and (takis.clutchspamcount < 7)
					v.drawString(x,y,
						"don't",
						V_PERPLAYER|V_HUDTRANS,
						"thin-fixed"
					)			
					v.drawString(x,y+8*FU,
						"spam",
						V_PERPLAYER|V_HUDTRANS,
						"thin-fixed"
					)
				elseif (takis.clutchspamcount >= 7)
					v.drawString(x,y,
						"clutch on",
						V_PERPLAYER|V_HUDTRANS,
						"thin-fixed"
					)			
					v.drawString(x,y+8*FU,
						"green",
						V_PERPLAYER|V_HUDTRANS,
						"thin-fixed"
					)				
				end
			end
			
			if takis.clutchtime > 0
				v.drawScaled(x, y, scale, bubble, V_PERPLAYER|V_HUDTRANS)
				
				local max = 23*FU
				local timer = (23-takis.clutchtime)*FU
				local erm = FixedDiv((timer),max)
				local width = v.cachePatch(pre.."FILL").height*FU-FixedMul(erm,v.cachePatch(pre.."FILL").height*FU)
				if width < 0 then
					width = 0
				end
				
				v.drawCropped(x,y+FixedMul(width,scale),scale,scale,
					v.cachePatch(pre.."FILL"),
					V_PERPLAYER|V_HUDTRANS, 
					v.getColormap(nil,color),
					0,width,
					v.cachePatch(pre.."FILL").width*FU,v.cachePatch(pre.."FILL").height*FU
				)
				
				v.drawScaled(x, y, scale, v.cachePatch(pre.."MARK"), V_PERPLAYER|V_HUDTRANS)
			end
		end
	end
	
end

--      ----------

local function drawnadocount(v,p,cam)

	if (customhud.CheckType("takis_nadocount") != modname) return end
	
	local takis = p.takistable
	local me = p.mo
	
	if not takis then return end 
	
	if not (takis.transfo & TRANSFO_TORNADO)
	or not takis.nadocount
		return
	end
	
	--chrispy chars
	local player = p
	local mo = player.realmo
	
	local flip = 1
	local bubble = v.cachePatch("CMBCF"..takis.nadocount)
	local angdiff = ANGLE_90
	local x, y, scale, nodraw
	local cutoff = function(y) return false end
	
	if cam.chase and not (player.awayviewtics and not takis.in2D)
		x, y, scale, nodraw = R_GetScreenCoords(v, player, cam, mo)
		if nodraw then return end
		
		scale = $*2
		if mo.eflags & MFE_VERTICALFLIP
		and player.pflags & PF_FLIPCAM
			y = 200*FRACUNIT - $
		else
			flip = P_MobjFlip(mo)
		end
	else
		scale = FU
		x = (160*FU)
		y = 100*FU
	end
	
	if splitscreen
		if player == secondarydisplayplayer
			cutoff = function(y) return y < (bubble.height*scale >> 1) end
		else
			cutoff = function(y) return y > 200*FRACUNIT + (bubble.height*scale >> 1) end
		end
	end
	
	local angle = angdiff + ANGLE_90
	local x = x - P_ReturnThrustX(nil, angle, -(bubble.width*scale)/2)
	y = $+flip*(-50*scale)
	if not cutoff(y)
		v.drawScaled(x, y, scale, bubble, V_PERPLAYER|V_HUDTRANS)
	end

end

--COMBO ----------

local function drawmincombo(v,p,maxtime)
	local takis = p.takistable
	local me = p.mo
	
	if takis.combo.count
	or takis.combo.outrotics
		local pre = "MINCBAR_"
		
		local backx = (takis.HUD.combo.x)-3*FU
		local backy = takis.HUD.combo.y-9*FU
		local combonum = takis.combo.count
		if (takis.combo.outrotics)
			combonum = takis.combo.failcount
		end
		local max = maxtime*FU or 1
		local erm = FixedDiv((takis.HUD.combo.fillnum),max)
		local width = FixedMul(erm,v.cachePatch(pre.."FILL").width*FU)
		if width < 0 then
			width = 0
		end
		local scale = FU/2
		
		v.drawScaled(backx,
			backy,
			scale*2,
			v.cachePatch(pre.."BAR2"),
			V_SNAPTOTOP|V_SNAPTOLEFT|V_HUDTRANSHALF|V_PERPLAYER
		)
		
		v.drawScaled(backx+3*FU, backy+9*FU, scale, v.cachePatch(pre.."BACK"),
			V_SNAPTOTOP|V_SNAPTOLEFT|V_HUDTRANS|V_PERPLAYER
		)
		
		
		local color
		if takis.HUD.combo.fillnum <= TAKIS_MAX_COMBOTIME*FU/4
			color = SKINCOLOR_RED
		elseif takis.HUD.combo.fillnum <= TAKIS_MAX_COMBOTIME*FU/2
			color = SKINCOLOR_ORANGE
		elseif takis.HUD.combo.fillnum <= TAKIS_MAX_COMBOTIME*FU*3/4
			color = SKINCOLOR_YELLOW
		end
		if (takis.combo.frozen)
			color = SKINCOLOR_ICY
		end
		
		v.drawCropped(backx+3*FU,backy+9*FU,scale,scale,
			v.cachePatch(pre.."FILL"),
			V_SNAPTOTOP|V_SNAPTOLEFT|V_HUDTRANS|V_PERPLAYER, 
			v.getColormap(nil,color),
			0,0,
			width,v.cachePatch(pre.."FILL").height*FU
		)
		
		local scorenum = "CMBCF"
		local combonum = takis.combo.count
		if (takis.combo.outrotics)
			combonum = takis.combo.failcount
		end
		local score = combonum
		
		local prevw = 0
		
		local textwidth = 0
		for i = 1,string.len(score)
			local n = string.sub(score,i,i)
			local patch = v.cachePatch(scorenum+n)
			textwidth = $+(patch.width*FU*4/10)		
		end
		
		for i = 1,string.len(score)
			local n = string.sub(score,i,i)
			local patch = v.cachePatch(scorenum+n)
			v.drawScaled(backx+prevw-textwidth+89*FU,
				backy,
				scale,
				patch,
				V_SNAPTOTOP|V_SNAPTOLEFT|V_HUDTRANS|V_PERPLAYER
			)
				
			prevw = $+(patch.width*FU*4/10)
		end
		/*
		v.drawString(backx-(v.cachePatch(pre.."FILL").width*scale)-FU*2,
			backy-3*FU,
			takis.combo.count.."x",
			V_SNAPTOTOP|V_SNAPTOLEFT|V_HUDTRANS|V_PERPLAYER|V_ALLOWLOWERCASE,
			"thin-fixed-right"
		)
		*/
		
		if not takis.combo.outrotics
			local length = #TAKIS_COMBO_RANKS
			v.drawString(backx+3*FU,
				backy+14*FU,
				TAKIS_COMBO_RANKS[ ((takis.combo.rank-1) % length)+1 ],
				V_SNAPTOTOP|V_SNAPTOLEFT|V_HUDTRANS|V_PERPLAYER|V_ALLOWLOWERCASE,
				"thin-fixed"
			)
			if takis.combo.score ~= "dontdraw"
				v.drawString(backx+3*FU,
					backy+FU,
					"+"..takis.combo.score,
					V_SNAPTOTOP|V_SNAPTOLEFT|V_HUDTRANS|V_PERPLAYER|V_ALLOWLOWERCASE,
					"thin-fixed"
				)
			end
		end

	end

	if takis.combo.awardable
	and not takis.combo.dropped
		--takis.combo.awardable = true
		
		local patch = v.cachePatch("FCTOKEN")
		
		local fs = takis.HUD.flyingscore
		local x = fs.scorex*FU-(patch.width*FU/3)
		local y = (fs.scorey+15)*FU
		
		if (p.ptsr and p.ptsr.rank)
		and HAPPY_HOUR.othergt
			x = $-20*FU
		end
		local grow = takis.HUD.combo.tokengrow
		
		v.drawScaled(x-(grow*25),y-(grow*20),FU/3+grow,
			patch,
			V_HUDTRANS|V_SNAPTORIGHT|V_SNAPTOTOP, 
			v.getColormap(nil, p.skincolor)
		)
	end
	
	--this is so um jammer lammy
	for k,va in pairs(takis.HUD.comboshare)
		if not va.tics then continue end
		
		local total_width = (v.width() / v.dupx()) + 1
		local total_height = (v.height() / v.dupy()) + 1
		
		
		local x,y = va.x,va.y
		
		if va.tics <= TR/2
			--THANKS NICK FOR HELPIN ME WITH THE COORDS!!
			local pre = "MINCBAR_"
			local et = TR/2
			local tics = et-va.tics
			
			local ypos = ((100*FU)-(total_height*FU/2))+takis.HUD.combo.basey
			local xpos = 160*FU-(total_width*FU/2)
			
			if takis.combo.time
				xpos = $+(v.cachePatch(pre.."FILL").width*FU/2)
			end
			
			y = ease.outback(
				(FU/et)*tics,
				va.starty,
				ypos,
				FU*4
			)
			x = ease.insine(
				(FU/et)*tics,
				va.startx,
				xpos,
				FU
			)
			
		end
		
		local waveforce = FU*3
		local ay = FixedMul(waveforce,sin(FixedAngle(leveltime*20*FU)))
		if va.tics <= TR/2
			ay = 0
		end
		
		local cpatch = v.cachePatch("TAKCOSHARE")
		local color = v.getColormap(nil,
			(leveltime/2 % 2) and SKINCOLOR_GREEN
			or SKINCOLOR_RED
		)
		local xoff = -7*FU
		v.drawScaled(x+8*FU-xoff,y+ay,FU,cpatch,0,color)
		v.drawString(x+8*FU-xoff,y+ay,"+"..va.comboadd,0,"fixed-right")
	end
	
end

local function drawcombostuff(v,p,cam)

	if (customhud.CheckType("takis_combometer") != modname) return end
	
	if (TAKIS_DEBUGFLAG & DEBUG_BOSSCARD) then return end
	
	if p.takistable.inNIGHTSMode
	or (TAKIS_NET.inspecialstage)
		return
	end
	
	local takis = p.takistable
	local me = p.mo
	
	local maxtime = TAKIS_MAX_COMBOTIME
	if (p.ptsr)
		maxtime = p.ptsr.combo_maxtime
		takis.combo.time = p.ptsr.combo_timeleft
	end

	if takis.io.minhud
		drawmincombo(v,p,maxtime)
		return
	end
	
	if (takis.combo.failtics)
		local meter = v.cachePatch("TAKCOBACK")
		local offy = 0
		if (takis.combo.count)
			offy = meter.height*FU+5*FU
		end
		
		v.drawString(15*FU+(meter.width*FU/2),
			takis.HUD.combo.basey+offy,
			"That combo was",
			V_HUDTRANS|V_ALLOWLOWERCASE|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER,
			"thin-fixed-center"
		)
		local length = #TAKIS_COMBO_RANKS
		local xs,ys = happyshakelol(v)
		xs,ys = $1/3,$2/3
		v.drawString(15*FU+(meter.width*FU/2)+xs,
			takis.HUD.combo.basey+15*FU+ys+offy,
			TAKIS_COMBO_RANKS[ ((takis.combo.failrank-1) % length)+1 ],
			V_HUDTRANS|V_ALLOWLOWERCASE|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER,
			"thin-fixed-center"
		)
		
		local score = takis.combo.failcount
		local prevw = 0
		local scorenum = "CMBCF"
		local fontwidth = 0
		
		for i = 1,string.len(score)
			local n = string.sub(score,i,i)
			fontwidth = $+v.cachePatch(scorenum+n).width*4/10
		end
		fontwidth = $*FU
		
		for i = 1,string.len(score)
			local n = string.sub(score,i,i)
			v.drawScaled(15*FU+(meter.width*FU/2)+(prevw*FU)-(fontwidth/2),
				(takis.HUD.combo.basey+25*FU+offy),--(v.cachePatch(scorenum+n).height*FixedDiv(scale-FU,4*FU)),
				FU/2,
				v.cachePatch(scorenum+n),
				V_HUDTRANS|	V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER
			)
				
			prevw = $+v.cachePatch(scorenum+n).width*4/10
		end
		
		local verys = takis.combo.failcount/(#TAKIS_COMBO_RANKS*TAKIS_COMBO_UP)
		if verys > 0
			local verypatch = v.cachePatch("TAKCOVERY")
			
			v.drawScaled(15*FU+((verypatch.width*FU/3)/2),
				takis.HUD.combo.basey+offy+12*FU,
				FU/3,
				verypatch,
				V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER
			)
			
			if verys > 1
				v.drawString(15*FU+((verypatch.width*FU/3)/2),
					takis.HUD.combo.basey+offy+15*FU,
					"x"..verys,
					V_ALLOWLOWERCASE|V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER,
					"thin-fixed-center"
				)
			end
			
		end
	end
	
	if takis.combo.count
	or takis.combo.outrotics
		local slide = 0
		if (takis.combo.slidetime)
			slide = takis.combo.slidein
		end
		local comboscale = takis.HUD.combo.scale+FU
		local shake = -FixedMul(takis.HUD.combo.shake,comboscale)
		local backx = (takis.HUD.combo.x)+slide
		local backy = takis.HUD.combo.y + shake
		if (takis.combo.outrotointro)
			backy = takis.HUD.combo.y+shake---takis.combo.outrotointro+shake
		end
		local combonum = takis.combo.count
		if (takis.combo.outrotics)
			combonum = takis.combo.failcount
		end
				
		/*
		if ((p.pflags & PF_FINISHED) and (netgame))
		and not p.exiting
			backy = $+(20*FU)
		end
		*/
		
		local max = maxtime*FU or 1
		local erm = FixedDiv((takis.HUD.combo.fillnum),max)
		local width = FixedMul(erm,v.cachePatch("TAKCOFILL").width*FU)
		local color
		if takis.HUD.combo.fillnum <= maxtime*FU/4
			color = SKINCOLOR_RED
		elseif takis.HUD.combo.fillnum <= maxtime*FU/2
			color = SKINCOLOR_ORANGE
		elseif takis.HUD.combo.fillnum <= maxtime*FU*3/4
			color = SKINCOLOR_YELLOW
		end
		if (takis.combo.frozen)
			color = SKINCOLOR_ICY
		end
		if width < 0 then
			width = 0
		end
		takis.HUD.combo.patchx = v.cachePatch("TAKCOFILL").width*FU/2
		local patchx = takis.HUD.combo.patchx
		
		v.drawCropped(backx,backy,comboscale,comboscale,
			v.cachePatch("TAKCOFILL"),
			V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER, 
			v.getColormap(nil,color),
			0,0,
			width,v.cachePatch("TAKCOFILL").height*FU
		)
		
		v.drawScaled(backx,backy,comboscale,
			v.cachePatch("TAKCOBACK"),
			V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER
		)
		
		
		if not (takis.combo.outrotics)
			if p.ptsr
				local prank_able = p.ptsr.combo_timesfailed == 0 and p.ptsr.combo_times_started == 1 
				if not prank_able
					v.drawString(backx+5*comboscale+(FixedMul(patchx,comboscale)),
						backy+6*comboscale+(v.cachePatch("TAKCOFILL").height*comboscale/2)-(7*comboscale/2),
						"no p-rank",
						V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER,
						"thin-fixed-center"
					)
				end
			end
			if takis.combo.score ~= "dontdraw"
				v.drawString(backx+5*comboscale+(FixedMul(patchx,comboscale)),
					backy+6*comboscale+(v.cachePatch("TAKCOFILL").height*comboscale/2)-(7*comboscale/2),
					takis.combo.score,
					V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER,
					"thin-fixed-center"
				)
			end
		end
		
		/*
		if not (takis.combo.outrotics)
			TakisDrawPatchedText(v,
				backx+5*comboscale+(FixedMul(patchx,comboscale))-(v.stringWidth(tostring(takis.combo.score),0,"thin")*comboscale/2),
				backy+(7*comboscale),
				tostring(takis.combo.score),
				{
					font = "TNYFN",
					flags = (V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER),
					align = 'left',
					scale = comboscale,
					fixed = true
				}
			)
		end
		*/
		
		if not takis.combo.outrotics
			--draw combo rank
			--this isnt patched text bnecause of issues with the
			--color codes
			local length = #TAKIS_COMBO_RANKS
			v.drawString(backx+7*comboscale,
				backy+20*comboscale,
				TAKIS_COMBO_RANKS[ ((takis.combo.rank-1) % length)+1 ],
				V_HUDTRANS|V_ALLOWLOWERCASE|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER,
				"thin-fixed"
			)
		end
		
		--font
		local scorenum = "CMBCF"
		local score = combonum
		
		local prevw
		if not prevw then prevw = 0 end
		
		for i = 1,string.len(score)
			local n = string.sub(score,i,i)
			v.drawScaled(backx+FixedMul(75*FU+(prevw*FU),comboscale),
				backy+5*FU,
				FixedDiv(comboscale,2*FU),
				v.cachePatch(scorenum+n),
				V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER
			)
				
			prevw = $+v.cachePatch(scorenum+n).width*4/10
		end
		
		if takis.combo.cashable
			v.drawString(backx+5*comboscale+(FixedMul(patchx,comboscale)),
				backy-2*comboscale,
				"C1+C2: Cash in!",
				V_ALLOWLOWERCASE|V_GREENMAP|V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER,
				"thin-fixed-center"
			)
		end
		
		--draw the verys
		local maxvery = 19	
		
		local waveforce = FU*2
		waveforce = $+(FU/50*((takis.combo.verylevel-1)))
		if takis.combo.verylevel > 0
			for i = 1, takis.combo.verylevel
				
				local verypatch = v.cachePatch("TAKCOVERY")
				--if not (i % 2)
				--	verypatch = v.cachePatch("TAKCOSUPR")
				--end
				
				local k = ((i-1)%maxvery) --x
				local j = ((i-1)/maxvery) --y
				
				local angle = FixedAngle(maxvery*FU)
				local ay = FixedMul(waveforce,sin((leveltime-k)*angle))
				
				v.drawScaled(backx+(7*FU)+(k*(5*FU)),
					backy+(37*FU)+(j*6*FU)+ay,
					FU/3,
					verypatch,
					V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER
				)
				
			end
			/*
			v.drawString(backx+(7*FU)+(maxvery*(5*FU)),
				backy+(37*FU),
				"x"..takis.combo.verylevel.."\x83 Verys!",
				V_ALLOWLOWERCASE|V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER,
				"thin-fixed"
			)
			*/
		end
		
	end

	if takis.combo.awardable
	and not takis.combo.dropped
		--takis.combo.awardable = true
		
		local patch = v.cachePatch("FCTOKEN")
		
		local fs = takis.HUD.flyingscore
		local x = fs.scorex*FU-(patch.width*FU/3)
		local y = (fs.scorey+20)*FU
		
		if (p.ptsr and p.ptsr.rank)
		and HAPPY_HOUR.othergt
			x = $-20*FU
		end
		local grow = takis.HUD.combo.tokengrow
		
		v.drawScaled(x-(grow*25),y-(grow*20),FU/3+grow,
			patch,
			V_HUDTRANS|V_SNAPTORIGHT|V_SNAPTOTOP, 
			v.getColormap(nil, p.skincolor)
		)
	end
	
	--this is so um jammer lammy
	for k,va in pairs(takis.HUD.comboshare)
		if not va.tics then continue end
		
		local total_width = (v.width() / v.dupx()) + 1
		local total_height = (v.height() / v.dupy()) + 1
		
		/*
		v.drawString(
			160*FU-(total_width*FU/2),
			((100*FU)-(total_height*FU/2))+takis.HUD.combo.basey,
			"Combo Share",
			V_ALLOWLOWERCASE,
			"fixed"
		)
		*/
		
		local x,y = va.x,va.y
		/*
		if va.tics >= (2*TR+(TR/2))-1
			x,y = R_GetScreenCoords(v, p, cam, players[va.node].realmo)
			va.x,va.y = x,y
			va.startx = x
			va.starty = y
		end
		*/
		
		if va.tics <= TR/2
			--THANKS NICK FOR HELPIN ME WITH THE COORDS!!
			local et = TR/2
			local tics = et-va.tics
			
			local ypos = ((100*FU)-(total_height*FU/2))+takis.HUD.combo.basey+9*FU
			local xpos = 160*FU-(total_width*FU/2)
			
			if takis.combo.time
				xpos = $+(v.cachePatch("TAKCOBACK").width*FU/2)
			end
			
			y = ease.outback(
				(FU/et)*tics,
				va.starty,
				ypos,
				FU*4
			)
			x = ease.insine(
				(FU/et)*tics,
				va.startx,
				xpos,
				FU
			)
			
		end
		
		local waveforce = FU*3
		local ay = FixedMul(waveforce,sin(FixedAngle(leveltime*20*FU)))
		if va.tics <= TR/2
			ay = 0
		end
		
		local cpatch = v.cachePatch("TAKCOSHARE")
		local color = v.getColormap(nil,
			(leveltime/2 % 2) and SKINCOLOR_GREEN
			or SKINCOLOR_RED
		)
		local xoff = -7*FU
		v.drawScaled(x+8*FU-xoff,y+ay,FU,cpatch,0,color)
		v.drawString(x+8*FU-xoff,y+ay,"+"..va.comboadd,0,"fixed-right")
	end
	
end

--      ----------

local function drawjumpscarelol(v,p)

	if (customhud.CheckType("takis_c3jumpscare") != modname) return end

	local takis = p.takistable
	local h = takis.HUD.funny
	
	if h.tics
		if not h.wega
			v.fadeScreen(35,10)
			
			local scale = FU*7/5
			local p = v.cachePatch("BALL_BUSTER")
			
			local x = v.RandomFixed()*3
			if ((leveltime%4) < 3)
				x = -$
			end
			
			if h.alsofunny
				p = v.cachePatch("BASTARD")
				scale = FU/2
			end
			
			v.drawScaled(((300/2)*FU)+x,h.y,scale,p,0)
		else
			if h.tics > TR
				local trans = 0
				if h.tics < TR+10
					trans = (10-(h.tics-TR))<<V_ALPHASHIFT
				end
				
				local patch = v.cachePatch("TA_WEGA")
				
				local width = patch.width
				local height = patch.height
				local total_width = (v.width() / v.dupx()) + 1
				local total_height = (v.height() / v.dupy()) + 1
				local hscale = FixedDiv(total_width * FU, width * FU)
				local vscale = FixedDiv(total_height * FU, height * FU)
				
				v.drawStretched(0, 0, hscale, vscale, patch, V_SNAPTOTOP|V_SNAPTOLEFT|trans)		
			end
		end
	end
	
end

local function drawhappyhour(v,p)

	if (customhud.CheckType("PTSR_itspizzatime") != modname) and (HAPPY_HOUR.othergt) then return end
	
	if not HH_CanDoHappyStuff(p)
		return
	end
	
	local takis = p.takistable
	
	if (HAPPY_HOUR.time) and (HAPPY_HOUR.time <= 5*TR)
	and (HAPPY_HOUR.gameover == false)
		local date = os.date("*t")
		
		local tics = HAPPY_HOUR.time

		takis.HUD.happyhour.doingit = true
		
		local cmap = 0xFF00
		
		if tics < 15
			v.fadeScreen(cmap,tics)
		elseif ((tics >= 15) and (tics < ((2*TR)+17) ))
			v.fadeScreen(cmap,16)
		elseif ((tics >= ((2*TR)+17)) and (tics < 103))
			v.fadeScreen(cmap,16-(tics-87)) 
		end
		if tics < 4*TR
		and not (p.texttimer < TICRATE/2)
			if p.texttimer
			and p.textvar == 1
				v.drawString(160,
					52,
					"GET TO THE GOAL!",
					V_PERPLAYER|V_GREENMAP,
					"center"
				)
			end
		end
		
		local h = takis.HUD.happyhour
		local y = 40*FU
		
		local me = p.realmo

		local back = 4*FU/5
		
		local pa = v.cachePatch
		
		if tics > 2
			local shakex,shakey = happyshakelol(v)
			v.drawScaled(h.its.x+shakex, y+h.its.yadd+shakey, h.its.scale,
				pa(h.its.patch..h.its.frame),
				V_SNAPTOTOP|v.userTransFlag()
			)
			
			local happy = h.happy.patch
			if date.hour == 6 or date.hour == 18
				happy = "TAHY_SAD"
			end
			
			shakex,shakey = happyshakelol(v)
			v.drawScaled(h.happy.x+shakex, y+h.happy.yadd+shakey, h.happy.scale,
				pa(happy..h.happy.frame),
				V_SNAPTOTOP|v.userTransFlag()
			)
			
			shakex,shakey = happyshakelol(v)
			v.drawScaled(h.hour.x+shakex, y+h.hour.yadd+shakey, h.hour.scale,
				pa(h.hour.patch..h.hour.frame),
				V_SNAPTOTOP|v.userTransFlag()
			)
			if tics > 4
				local pat = SPR2_TRNS
				local scale = 6*FU/5
				--if this looks weird, i dont care
				--ADD HHF_ SPRITE!!!!!
				local frame = G
				local num = {
					[0] = A,
					[1] = B
				}
				local skin = me.skin or p.skin
				local hires = skins[skin].highresscale or FU
				local yadd = 15*FU
				
				if P_IsValidSprite2(me,SPR2_HHF_)
					pat = SPR2_HHF_
					scale = 3*FU/5
					frame = num[h.face.frame]
					yadd = 0
				end
				
				shakex,shakey = happyshakelol(v)
				shakex,shakey = $1/2, $2/2
				local face = v.getSprite2Patch(p.skin,pat,false,frame,0,0)
				v.drawScaled(h.face.x+x+shakex,
					(130*FU)+h.face.yadd+yadd+shakey,
					FixedMul(scale,hires),
					face,
					v.userTransFlag(), v.getColormap(p.skin,p.skincolor)
				)
			end
		end
	end
	
end

local function getlaptext(p)
	local text = ''
	local exitingCount, playerCount = PTSR_COUNT()
	local lapsperplayertext = "\x82Your Laps:"
	local inflaps = "\x83Laps:"
	local num = ''
	
	--lots of these for backwards compatability
	local laps = (PTSR.laps)
	local maxlaps = PTSR.maxlaps
	
	if p.ptsr.pizzaface
		return '',"dontdraw"
	end
	
	if CV_PTSR.default_maxlaps.value
		text = lapsperplayertext
		num = p.ptsr.laps.." / "..PTSR.maxlaps
		p.takistable.HUD.lapanim.maxlaps = PTSR.maxlaps
		return text,num
	else
		text = inflaps
		num = p.ptsr.laps
		p.takistable.HUD.lapanim.maxlaps = -1
		return text,num
	end

end

local function drawtelebar(v,p)

	
	local takis = p.takistable
	local me = p.mo
	local h = takis.HUD.ptsr
	
	local color = SKINCOLOR_GREEN
	local pre = "CLTCHMET_"
	
	local charge = (p.pizzacharge or 0)
	local max = TR*FU
	
	if p.pizzachargecooldown
		max = CV_PTSR.pizzatpcooldown.value*FU
		charge = CV_PTSR.pizzatpcooldown.value - p.pizzachargecooldown
		color = SKINCOLOR_RED
	end
	
	local back = v.cachePatch(pre.."BACK")
	local x = 220*FU
	local y = 190*FU+h.yoffset
	local scale = FU/2
	
	v.drawScaled(
		x,
		y,
		scale,
		back,
		V_SNAPTOBOTTOM|V_HUDTRANS
	)

	local timer = charge*FU
	local erm = FixedDiv((timer),max)
	local width = v.cachePatch(pre.."FILL").height*FU-FixedMul(erm,v.cachePatch(pre.."FILL").height*FU)
	if width < 0 then
		width = 0
	end
	
	v.drawCropped(x,
		y+FixedMul(width,scale),
		scale,scale,
		v.cachePatch(pre.."FILL"),
		V_SNAPTOBOTTOM|V_HUDTRANS, 
		v.getColormap(nil,color),
		0,width,
		v.cachePatch(pre.."FILL").width*FU,v.cachePatch(pre.."FILL").height*FU
	)
end

local function drawpizzatips(v,p)

	if (customhud.CheckType("PTSR_tooltips") != modname) return end
	
	if not HH_CanDoHappyStuff(p)
		return
	end
	
	local takis = p.takistable
	local h = takis.HUD.ptsr
	local me = p.realmo
	
	if (takis.hhexiting) then return end
	
	if not (HAPPY_HOUR.othergt and HAPPY_HOUR.happyhour)
		return
	end
	
	local tics = HAPPY_HOUR.time
	
	if p.ptsr == nil then return end
	
	local text,num = getlaptext(p)
	local exitingCount, playerCount = PTSR_COUNT()

	if (not p.ptsr.pizzaface)
	and (p.ptsr.outofgame)
	and (p.playerstate ~= PST_DEAD) 
	and not (p.ptsr.laps >= PTSR.maxlaps and CV_PTSR.default_maxlaps.value)
	and not PTSR.gameover then
		if not p.hold_newlap then
			v.drawString(160, 130, "\x85Hold FIRE to try a new lap!", V_ALLOWLOWERCASE|V_SNAPTOBOTTOM, "thin-center")
		else
			local per = (FixedDiv(p.hold_newlap*FRACUNIT, PTSR.laphold*FRACUNIT)*100)/FRACUNIT
			v.drawString(160, 130, "\x85Lapping... "..per.."%", V_SNAPTOBOTTOM|V_ALLOWLOWERCASE, "thin-center")
		end
	end
	
	if tics > 3
		h.xoffset = 0
		if num ~= 'dontdraw'
			h.xoffset = 31
			
			v.drawScaled(65*FU+(h.xoffset*FU),170*FU+(h.yoffset),3*FU/5,v.cachePatch("TA_LAPFLAG"),V_HUDTRANS|V_SNAPTOBOTTOM)
			v.drawString((85+h.xoffset)*FU,(160)*FU+(h.yoffset),text,V_ALLOWLOWERCASE|V_HUDTRANS|V_SNAPTOBOTTOM|V_RETURN8,"thin-fixed-center")

			v.drawString((85+h.xoffset)*FU,(177)*FU+(h.yoffset),num,V_PURPLEMAP|V_ALLOWLOWERCASE|V_HUDTRANS|V_SNAPTOBOTTOM|V_RETURN8,"fixed-center")
		end
		
		if playerCount == 1
			v.drawString((85+h.xoffset)*FU,(160-16)*FU+(h.yoffset),"\x88".."Exercise",V_ALLOWLOWERCASE|V_HUDTRANS|V_SNAPTOBOTTOM|V_RETURN8,"thin-fixed-center")
			v.drawString((85+h.xoffset)*FU,(160-8)*FU+(h.yoffset),"\x88".."Mode",V_ALLOWLOWERCASE|V_HUDTRANS|V_SNAPTOBOTTOM|V_RETURN8,"thin-fixed-center")
		end
		
	end
		
	if p.ptsr.pizzaface
		/*
		if (p.pizzachargecooldown)
			v.drawString(153+(h.xoffset),162+(h.yoffset),"Cooling down...",V_SNAPTOBOTTOM|V_HUDTRANS|V_ALLOWLOWERCASE,"small-fixed")
		elseif (p.pizzacharge)
			v.drawString(153+(h.xoffset),162+(h.yoffset),"Charging!",V_SNAPTOBOTTOM|V_HUDTRANS|V_ALLOWLOWERCASE,"small-fixed")
		else
			v.drawString(153+(h.xoffset),162+(h.yoffset),"Hold FIRE to teleport!", V_SNAPTOBOTTOM|V_HUDTRANS|V_ALLOWLOWERCASE,"small-fixed")
		end
		*/
		drawtelebar(v,p)
	end
end

local function hhtimerbase(v,p)
	if not HAPPY_HOUR.happyhour
		return
	end
	
	if not HAPPY_HOUR.timelimit
		return
	end
	
	if HAPPY_HOUR.time < 2
		return
	end
	
	local tics = HAPPY_HOUR.timeleft
	
	local takis = p.takistable
	
	if tics == nil
		tics = 0
	end
	
	local min = tics/(60*TR) --G_TicsToMinutes(tics,true)
	local sec = G_TicsToSeconds(tics)
	local cen = G_TicsToCentiseconds(tics)
	local spad,cpad,extrastring = '','',''
	
	--paddgin!!
	if (sec < 10) then spad = '0' end
	if (cen < 10) then cpad = '0' end
	
	local timertime = min..":"..spad..sec
	extrastring = "."..cpad..cen 
	if not (TAKIS_DEBUGFLAG & DEBUG_HAPPYHOUR)
		extrastring = ''
	end
	
	local string = timertime..extrastring
	
	local h = takis.HUD.ptsr
		
	local frame = ((5*leveltime/6)%14)
	local patch
	local trig = HAPPY_HOUR.trigger
	/*
	if (trig and trig.valid)
	and (trig.type == MT_HHTRIGGER)
		patch = v.getSpritePatch(SPR_HHT_,trig.frame,0)
	else
	*/
	patch = v.cachePatch("TAHHS"..frame)
	
	
	if not (HAPPY_HOUR.othergt)
		h.xoffset = (-GetInternalFontWidth(tostring(string),TAKIS_HAPPYHOURFONT)-30)/10
	end
	
	if not (takis.inNIGHTSMode)
		v.drawScaled(110*FU+(h.xoffset*FU),168*FU+(h.yoffset),FU,patch,V_HUDTRANS|V_SNAPTOBOTTOM)
		
		if not (HAPPY_HOUR.overtime)
			TakisDrawPatchedText(v,
				(150+(h.xoffset))*FU,
				173*FU+(h.yoffset),
				tostring(string),
				{
					font = TAKIS_HAPPYHOURFONT,
					flags = (V_SNAPTOBOTTOM|V_HUDTRANS),
					align = 'left',
					scale = 4*FU/5,
					fixed = true
				}
			)
		else
			local x,y = happyshakelol(v)
			v.drawScaled(
				(150+h.xoffset)*FU+x,173*FU+h.yoffset+y,4*FU/5,
				v.cachePatch(TAKIS_HAPPYHOURFONT.."OT"),
				V_SNAPTOBOTTOM|V_HUDTRANS
			)
		end
	else
		if (p.exiting) then return end
		
		v.drawScaled(100*FU,10*FU-(h.yoffset),
			FU,v.cachePatch("TAHHS"..frame),
			V_HUDTRANS|V_SNAPTOTOP
		)
	
	end

end

local function drawpizzatimer(v,p)

	if (customhud.CheckType("PTSR_bar") != modname) return end
	
	if not HH_CanDoHappyStuff(p)
		return
	end
	
	hhtimerbase(v,p)
end

local function drawhappytime(v,p)
	if (customhud.CheckType("takis_happyhourtime") != modname) return end
	
	if HAPPY_HOUR.othergt
		return
	end
	
	hhtimerbase(v,p)
end

--before i learned about patch_t...
local rankwidths = {
	["S"] = 34*FU,
	["A"] = 36*FU,
	["B"] = 32*FU,
	["C"] = 36*FU,
	["D"] = 35*FU,
}
local rankheights = {
	["S"] = 43*FU,
	["A"] = 44*FU,
	["B"] = 43*FU,
	["C"] = 40*FU,
	["D"] = 39*FU,
}

local function drawpizzaranks(v,p)

	if (customhud.CheckType("PTSR_rank") != modname) return end
	
	if (skins[p.skin].name ~= TAKIS_SKIN)
		return
	end
	
	if gametype ~= GT_PTSPICER then return end
	if p.pizzaface then return end
	
	if (PTSR)
		if PTSR.intermission_tics
		or (PTSR:inVoteScreen())
			return
		end
	end
	
	local takis = p.takistable
	local h = takis.HUD.rank
	if p.ptsr == nil then return end
	
	local patch = v.cachePatch("HUDRANK"..p.ptsr.rank)
	
	local fs = takis.HUD.flyingscore
	local x = fs.scorex*FU-(patch.width*FU/3)
	local y = (fs.scorey+20)*FU
	if takis.io.minhud
		y = (fs.scorey+15)*FU
	end
		
	if (p.ptsr and p.ptsr.rank)
		v.drawScaled(x-(h.grow*25),y-(h.grow*20),FU/3+h.grow,
			patch,
			V_HUDTRANS|V_SNAPTORIGHT|V_SNAPTOTOP
		)
		if h.percent
		and (p.ptsr.rank ~= "P")
			--thanks jisk for the help lol
			
			if p.ptsr.rank == "S"
			and not (p.ptsr.combo_timesfailed == 0 
			and p.ptsr.combo_times_started == 1)
				return
			end
			
			local max = h.percent
			local erm = FixedDiv((h.score),max)
			
			local scale2 = rankheights[p.ptsr.rank]-(FixedMul(erm,rankheights[p.ptsr.rank]))
			
 			if scale2 < 0 then scale2 = FU end
			
			v.drawCropped(x,y+(scale2/3),FU/3,FU/3,
				v.cachePatch("RANKFILL"..p.ptsr.rank),
				V_HUDTRANS|V_SNAPTORIGHT|V_SNAPTOTOP, 
				v.getColormap(nil, nil),
				0,scale2,
				rankwidths[p.ptsr.rank],rankheights[p.ptsr.rank]
			)
			
		end
	end

end

local function drawtauntmenu(v,p)

	if (customhud.CheckType("takis_tauntmenu") != modname) return end
	
	if (skins[p.skin].name ~= TAKIS_SKIN)
		return
	end
	
	local takis = p.takistable
	local me = p.mo
	
	if not takis.tauntmenu.open
		return
	end
	
	if not takis.tauntmenu.closingtime
		if takis.tauntmenu.yadd ~= 0
			local et = TR/2
			takis.tauntmenu.yadd = ease.outquad(( FU / et )*takis.tauntmenu.tictime,200*FU,0)
		end
		if takis.tauntmenu.tictime < 16
			v.fadeScreen(0xFF00,takis.tauntmenu.tictime)
		else
			v.fadeScreen(0xFF00,16)
		end
	else
		if takis.tauntmenu.yadd ~= 200*FU
			local et = TR/2
			takis.tauntmenu.yadd = ease.inquad(( FU / et )*((TR/2)-takis.tauntmenu.closingtime),0,200*FU)
		end	
		local tic = takis.tauntmenu.closingtime
		if tic > 16
			tic = 16
		end
		v.fadeScreen(0xFF00,tic)
	end
	local yadd = takis.tauntmenu.yadd
	
	
	v.drawScaled(160*FU,108*FU+yadd,FU/2,v.cachePatch("TAUNTBACK"),V_30TRANS,v.getColormap(nil, SKINCOLOR_BLACK))
	v.drawString(15*FU,(75*FU)+yadd,"Taunt",V_ALLOWLOWERCASE,"fixed")
	v.drawString(305*FU,(75*FU)+yadd,"Hit C1 to Cancel",V_ALLOWLOWERCASE,"thin-fixed-right")
	v.drawString(15*FU,(90*FU)+yadd,"Hit C3 to join a Partner Taunt",V_ALLOWLOWERCASE,"thin-fixed")
	v.drawString(305*FU,(86*FU)+yadd,"Quick Taunt: TF+#+C2/C3",V_ALLOWLOWERCASE,"small-fixed-right")
	v.drawString(305*FU,(94*FU)+yadd,"Delete Quick Taunt: TF+Fire+C2/C3",V_ALLOWLOWERCASE,"small-fixed-right")
	v.drawScaled(160*FU,100*FU+yadd,FU/2,v.cachePatch("TAUNTSEPAR"),0,nil)
	
	local ydisp = 25*FU
	for i = 1, 7 --#takis.tauntmenu.list
		v.drawScaled((20+(35*i))*FU,103*FU+yadd+ydisp,FU/2,v.cachePatch("TAUNTCELL"),V_10TRANS,v.getColormap(nil, SKINCOLOR_BLACK))
		local name = takis.tauntmenu.list[i]
		local xoffset = takis.tauntmenu.xoffsets[i] or 0
		local showicon = true
		
		local trans = 0
		if ((name == "")
		or (name == nil))
			name = "\x86None"
			trans = V_50TRANS
			showicon = false
		--there IS an entry, but no functions to call for it
		elseif ((TAKIS_TAUNT_INIT[i] == nil) or (TAKIS_TAUNT_THINK[i] == nil))
			name = "\x86"..takis.tauntmenu.list[i]
			trans = V_50TRANS
		end
		
		if (i == takis.tauntmenu.cursor)
		and (takis.io.tmcursorstyle == 2)
			v.drawScaled((20+(35*i))*FU,103*FU+yadd+ydisp,(FU*6/10),v.cachePatch("TAUNTCUR"),0,v.getColormap(nil, SKINCOLOR_SUPERGOLD4))
		end
		
		if showicon
			
			local icon = (takis.tauntmenu.gfx.pix[i]) or "IRRELEVANT"
			local scale = (takis.tauntmenu.gfx.scales[i]) or FU
			
			local x,y = 0,0
			if icon == "IRRELEVANT"
				x,y = (-31*FU)/2,(-31*FU)/2
			end
			v.drawScaled( (20+(35*i))*FU+x, 103*FU+yadd+ydisp+y,
				scale, v.cachePatch(tostring(icon)),0,
				v.getColormap(TAKIS_SKIN, p.skincolor)
			)
		end
		
		v.drawString( (20+(35*i)+xoffset)*FU,(125*FU)+yadd+ydisp,
			name,trans|V_RETURN8|V_ALLOWLOWERCASE,
			"small-fixed-center"
		)
		if (takis.io.tmcursorstyle == 1)
			v.drawString( (20+(35*i))*FU,(135*FU)+yadd+ydisp,
				i,trans|V_ALLOWLOWERCASE,
				"small-fixed-center"
			)
		end
		if (i == takis.tauntquick1)
			v.drawString( (20+(35*i))*FU,(140*FU)+yadd+ydisp,
				"TF+C2",trans|V_ALLOWLOWERCASE,
				"small-fixed-center"
			)		
		end
		if (i == takis.tauntquick2)
			v.drawString( (20+(35*i))*FU,(140*FU)+yadd+ydisp,
				"TF+C3",trans|V_ALLOWLOWERCASE,
				"small-fixed-center"
			)		
		end

	end
	
	if (takis.io.tmcursorstyle == 2)
		v.drawString(160*FU,(135*FU)+yadd+ydisp,
			"Use Weapon Next/Prev to scroll. Press Fire Normal to select.",V_ALLOWLOWERCASE,
			"small-fixed-center"
		)	
	end
	
end

local function drawwareffect(v,p)
	if (customhud.CheckType("takis_tauntmenu") != modname) return end
	
	if (skins[p.skin].name ~= TAKIS_SKIN)
		return
	end
	
	local takis = p.takistable
	local me = p.mo
	
	if not (takis.shotgunned)
		return
	end
	
	local fade = 0
	local time = takis.shotguntime/10
	local maxfade = 3
	
	if (time%(maxfade*2))+1 > maxfade
		fade = maxfade-(time%maxfade)
	else
		fade = (time%maxfade)
	end
	fade = $+1
	
--	v.fadeScreen(35,fade)
	--drawfill my favorite :kindlygimmesummadat:
	v.drawScaled(0,0,FU*10,v.cachePatch("TAUNTBACK"),(9-fade)<<V_ALPHASHIFT,v.getColormap(nil,SKINCOLOR_RED))
end

local letter = {
	"Dear pesky blaster...",
	"The Badniks and I have taken over your",
	"spirit stash. The spirits are now",
	"permanent guests at each of my seven",
	"Special Stages. I dare you to find them...",
	"If you can!"
}
	

--		needa make a font for this
local function drawcosmenu(v,p)
	if (customhud.CheckType("takis_cosmenu") != modname) return end
	
	local takis = p.takistable
	local me = p.mo
	
	local menu = takis.cosmenu
	local page = TAKIS_MENU.entries[menu.page]
	
	local function happyshakelol(v,pos,evenless)
		pos = $ or 0
		local s = 5
		local shakex,shakey = v.RandomFixed()/2,v.RandomFixed()/2
		
		local d1 = v.RandomRange(-1,1)
		local d2 = v.RandomRange(-1,1)
		if d1 == 0
			d1 = v.RandomRange(-1,1)
		end
		if d2 == 0
			d2 = v.RandomRange(-1,1)
		end

		shakex = $*s*d1
		shakey = $*s*d2
		
		local oncur = 0
		if pos-1 == takis.cosmenu.y then oncur = FU end
		
		shakex,shakey = FixedDiv($1,2*FU),FixedDiv($2,2*FU)
		shakex,shakey = FixedMul($1,oncur),FixedMul($2,oncur)
		if (evenless)
			shakex,shakey = FixedDiv($1,2*FU),FixedDiv($2,2*FU)		
		end
		
		return shakex,shakey
	end
	
	local pos = {x = 15,y = 15}
	local shakex,shakey = happyshakelol(v)
	
	local pagecolor = SKINCOLOR_GREEN
	if (page.color == "mo.color")
		pagecolor = mo.color
	elseif (page.color == "p.skincolor")
		pagecolor = p.skincolor
	else
		pagecolor = page.color
	end
	
	
	--TODO: transparent box behind text, I CANT SEE IT!
	
	--drawfill my favorite :kindlygimmesummadat:
	v.drawFill(0,0,v.width(),v.height(),
		--even if there is tearing, you wont see the black void
		skincolors[pagecolor].ramp[15]|V_SNAPTOLEFT|V_SNAPTOTOP
	)
	
	local bgp = v.cachePatch("TA_MENUBG")
	local bgscale = FU
	local total_width = (v.width() / v.dupx()) + 1
	local total_height = (v.height() / v.dupy()) + 1
	local bgflags = V_SNAPTOTOP|V_SNAPTOLEFT|V_10TRANS
	local bgmaxi = FixedInt(FixedDiv(total_width*FU,bgp.width*bgscale))+1
	local bgmaxj = FixedInt(FixedDiv(total_height*FU,bgp.height*bgscale))+1
	local bgxoff = (-leveltime*5000)%(bgp.width*bgscale)
	local bgyoff = (leveltime*5000)%(bgp.height*bgscale)
	
	-- +1 for scrolling
	for i = 0,bgmaxi
		for j = 0,bgmaxj
			local x = (bgp.width*bgscale*i)
			local y = -bgp.height*bgscale+(bgp.height*bgscale*j)
			v.drawScaled(x+bgxoff,
				y+bgyoff,
				bgscale,bgp,bgflags,
				v.getColormap(nil,pagecolor)
			)
			/*
			v.drawString(x+bgxoff,
				y+bgyoff,
				"i"..i..", j"..j.."\n"
				.."max "..bgmaxi..", "..bgmaxj,
				bgflags|V_ALLOWLOWERCASE|V_RETURN8,
				"thin-fixed"
			)
			*/
		end
	end
	
	v.drawScaled((300-pos.x)*FU,pos.y*FU,(FU/2)+(FU/12),
		v.cachePatch("TB_C1"),
		V_SNAPTORIGHT|V_SNAPTOTOP
	)
	v.drawString(300-pos.x-5,pos.y,
		"Leave",
		V_SNAPTORIGHT|V_SNAPTOTOP|V_YELLOWMAP|V_ALLOWLOWERCASE,
		"right"
	)
	if takis.io.savestate ~= 0
		local state = "IDLE"
		if takis.io.savestate == 2
			state = "GOOD"
		elseif takis.io.savestate == 3
			state = "BAD"
		elseif takis.io.savestate == 4
			state = "WARN"
		end
		
		v.drawScaled(
			(300-pos.x)*FU,
			pos.y+35*FU+(v.cachePatch("TA_SAVE_IDLE").height*FU/2),
			FU,
			v.cachePatch("TA_SAVE_"..state),
			V_SNAPTORIGHT|V_SNAPTOTOP|V_YELLOWMAP
		)
		
	end
	
	--draw title
	v.drawString(pos.x,pos.y,
		page.title.."\x80 ("..tostring(menu.page+1).."/"..tostring(#TAKIS_MENU.entries+1)..")",
		V_SNAPTOLEFT|V_SNAPTOTOP|V_YELLOWMAP|V_ALLOWLOWERCASE,
		"left"
	)
	
	local longestwidth = 0
	local lowestheight = ((100*FU)+(total_height*FU/2))-(60*FU)
	local lowestiter = 0
	local alreadysetwrap = false
	
	--the TEXT.
	local lastx = pos.x
	for i = 1,#page.text
		shakex,shakey = happyshakelol(v,i)
		if (menu.page ~= 1)
			
			--handles text wrapping if it goes too close to the
			--bottom of the screen
			--ONLY WRAPS ONCE so try not to use so many entries :)
			local txtlength = 0
			local texty = pos.y*FU+10*FU*i
			--absolute coords on screen
			local absy = ((100*FU)-(total_height*FU/2))+texty
			--check bottom of string (+8)
			--idea is to generally keep the entries away from the hints & controls
			local toolow = (absy+8*FU >= lowestheight) and true or false
			if toolow
				if lowestiter == 0
					lowestiter = i
				end
				if not alreadysetwrap
					pos.x = $+(longestwidth/FU)+10
				end
				texty = pos.y*FU+10*FU*((i-lowestiter)+1)
				alreadysetwrap = true
			end
			
			if i-1 == takis.cosmenu.y
				v.drawScaled(pos.x*FU,texty,FU,
					v.cachePatch("TA_MENUTXTCUR"),
					V_SNAPTOLEFT|V_SNAPTOTOP,
					v.getColormap(nil,ColorOpposite(pagecolor))
				)
			end
			
			if (page.text[i] == "$$$$$")
				local txt = ''
				if io
				and (p == consoleplayer)
					DEBUG_print(p,IO_CONFIG|IO_MENU)
					local file = io.openlocal("client/takisthefox/config.dat")
					
					if file 
						local extra = ''
						local curcode = TakisConstructSaveCode(p)
						local code = file:read("*a")
						if code ~= curcode
							extra = "\x87 (Outdated)"
						end
						if code ~= nil and not (string.find(code, ";"))
							txt = "\x82".."Config: "..code..extra
						end
						file:close()
					else
						txt = "\x86No Config."
					end
					
				else
					txt = "\x85Other person's config."
				end
				v.drawString(pos.x*FU, texty,
					txt,
					V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
					"thin-fixed"
				)
				txtlength = v.stringWidth(txt,V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE,"thin")*FU
			elseif (page.text[i] == "$$$$$$")
				local txt = ''
				if io
				and (p == consoleplayer)
					DEBUG_print(p,IO_CONFIG|IO_MENU)
					local file = io.openlocal("client/takisthefox/backupconfig.dat")
					
					if file 
						local code = file:read("*a")
						if code ~= nil and not (string.find(code, ";"))
							txt = "\x82".."Backup Config: "..code
						end
						file:close()
					else
						txt = "No Backup."
					end
					
				else
					txt = "\x85Other person's config."
				end
				v.drawString(pos.x*FU, texty,
					txt,
					V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
					"thin-fixed"
				)
				txtlength = v.stringWidth(txt,V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE,"thin")*FU
			else
				v.drawString(pos.x*FU+shakex, texty+shakey,
					page.text[i],
					V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
					"thin-fixed"
				)
				txtlength = v.stringWidth(page.text[i],V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE,"thin")*FU
				if (page.values ~= nil)
				and (#page.values)
				and (page.values[i] ~= nil)
					local value = '\x85???'
					
					--get the table so we can get our value
					if (type(page.values[i]) == "string")
						local table = TAKIS_NET
						if page.table == "takis.io"
							table = takis.io
						elseif page.table == "takis"
							table = takis
						elseif page.table == "player"
							table = p
						elseif page.table == "_G"
							table = _G
						elseif page.table ~= nil
							table = p[page.table]
						end
						value = tostring(table[(page.values[i])])
					else
						value = tostring(page.values[i])
					end
					if value == nil or value == "nil" then value = '\x85???' end
					
					v.drawString(pos.x*FU+txtlength+shakex,
						texty+shakey,
						": \x82"..value,
						V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
						"thin-fixed"
					)
					txtlength = $+(v.stringWidth(": \x82"..value,V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE,"thin")*FU)
				end
			end
			if txtlength > longestwidth
				longestwidth = txtlength
			end
		--achs page
		else
			local maxach = 16
			local number = consoleplayer.takistable.achfile
			for i = 0,maxach-1
				--bits to shift up by
				local j = i+(menu.achpage*maxach)
				
				if j > NUMACHIEVEMENTS-1 then break end
				
				local has = V_60TRANS
				local t = TAKIS_ACHIEVEMENTINFO
				local ach = t[1<<j]
				
				if (number & (1<<j))
				and not (TAKIS_NET.usedcheats or TAKIS_NET.noachs)
					has = 0
				end
				
				local x = pos.x*FU+((140*FU)*(i%2))
				local y = pos.y*FU+10*FU+(17*FU*(i/2))
				
				if ach == nil
					local icon = v.cachePatch("ACH_INVALID")
					v.drawScaled(x,
						y,
						FU/4,
						icon,
						V_SNAPTOLEFT|V_SNAPTOTOP
					)
					v.drawString(x+FU+(icon.width*FU/4),
						y,
						"Invalid Achievement",
						V_REDMAP|V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE|V_RETURN8,
						"thin-fixed"
					)
					continue
				end
			
				v.drawScaled(x,
					y,
					ach.scale or FU,
					(number & (1<<j)) and v.cachePatch(ach.icon) or ((ach.flags & AF_SECRET and has) and v.cachePatch("ACH_SPLACEHOLDER") or v.cachePatch("ACH_PLACEHOLDER")),
					V_SNAPTOLEFT|V_SNAPTOTOP|has
				)
				v.drawString(x+FU+(v.cachePatch(ach.icon).width*(ach.scale or FU)),
					y,
					(ach.flags & AF_SECRET and has) and "Secret Achievement" or (ach.name or "Ach. Enum "..(1<<j)),
					(V_GRAYMAP and has or 0)|V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE|V_RETURN8,
					"thin-fixed"
				)
				v.drawString(x+FU+(v.cachePatch(ach.icon).width*(ach.scale or FU)),
					y+(8*FU),
					(ach.flags & AF_SECRET and has) and " " or (ach.text or "Flavor text goes here"),
					(V_GRAYMAP and has or 0)|V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE|V_RETURN8,
					"small-fixed"
				)
				
			end
			
			if not (TAKIS_NET.usedcheats)
				--draw a bigger version so you can see the icon
				local x = pos.x*FU
				local y = pos.y*FU+10*FU+(17*FU*((maxach+1)/2))
				
				local t = TAKIS_ACHIEVEMENTINFO
				local num,num2 = menu.achcur,menu.achcur
				num = $+(menu.achpage*maxach)
				local ach = t[1<<num]
				local has = V_60TRANS
				if (number & (1<<num))
					has = 0
				end
				
				local curx = pos.x*FU+((140*FU)*(num2%2))
				local cury = pos.y*FU+10*FU+(17*FU*(num2/2))
				v.drawScaled(curx,cury,FU,
					v.cachePatch("TA_MENUACHCUR"),
					V_SNAPTOLEFT|V_SNAPTOTOP,
					v.getColormap(nil,SKINCOLOR_SUPERGOLD4)
				)
				
				local x2 = pos.x*FU
				v.drawString(300*FU-x2,y+16*FU,
					"(Jump) Set "..(menu.achpage+1).."/"..((NUMACHIEVEMENTS > 16) and "2" or "1"),
					V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
					"thin-fixed-right"
				)
				
				if ach == nil
					local icon = v.cachePatch("ACH_INVALID")
					v.drawScaled(x,
						y,
						FU/2,
						icon,
						V_SNAPTOLEFT|V_SNAPTOTOP
					)
					v.drawString(x+FU+(icon.width*FU/2),
						y,
						"Invalid Achievement",
						V_REDMAP|V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE|V_RETURN8,
						"fixed"
					)
				else
					--ok draw the ach
					v.drawScaled(x,
						y,
						(ach.scale or FU)*2,
						(number & (1<<num)) and v.cachePatch(ach.icon) or ((ach.flags & AF_SECRET and has) and v.cachePatch("ACH_SPLACEHOLDER") or v.cachePatch("ACH_PLACEHOLDER")),
						V_SNAPTOLEFT|V_SNAPTOTOP|has
					)
					v.drawString(x+FU+(v.cachePatch(ach.icon).width*((ach.scale or FU)*2)),
						y,
						(ach.flags & AF_SECRET and has) and "Secret Achievement" or (ach.name or "Ach. Enum "..(1<<i)),
						V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE|V_RETURN8,
						"fixed"
					)
					v.drawString(x+FU+(v.cachePatch(ach.icon).width*((ach.scale or FU)*2)),
						y+(8*FU),
						(ach.flags & AF_SECRET and has) and " " or (ach.text or "Flavor text goes here"),
						V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE|V_RETURN8,
						"thin-fixed"
					)
					
					local disp = 0
					if has == 0
						v.drawString(300*FU-x,y,
							"You have this.",
							V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
							"thin-fixed-right"
						)
						disp = 8*FU
					end
					if (ach.flags & AF_MP)
						v.drawString(300*FU-x,y+disp,
							"MP only",
							V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
							"thin-fixed-right"
						)					
						
						local leg = v.stringWidth(" MP only",V_ALLOWLOWERCASE,"thin")*FU
						
						v.drawScaled(300*FU-x-leg,y+disp,
							FU,
							v.cachePatch("TA_NETGAME"),
							V_SNAPTOLEFT|V_SNAPTOTOP
						)					
					end
					if (ach.flags & AF_SP)
						v.drawString(300*FU-x,y+disp,
							"SP only",
							V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
							"thin-fixed-right"
						)					
						
						local leg = v.stringWidth(" SP only",V_ALLOWLOWERCASE,"thin")*FU
						
						v.drawScaled(300*FU-x-leg,y+disp,
							FU,
							v.cachePatch("TA_SINGLEP"),
							V_SNAPTOLEFT|V_SNAPTOTOP
						)					
					end
				end
			else
				local x = pos.x*FU
				local y = pos.y*FU+10*FU+(17*FU*((NUMACHIEVEMENTS+1)/2))				
				
				v.drawString(x,y,
					TAKIS_NET.noachs and "Achievements have been disabled by the server."
					or "Achievements cannot be earned in cheated games.",
					V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE|V_REDMAP,
					"thin-fixed"
				)
			end
			
		end
	end
	pos.x = lastx
	
	if (page.hints ~= nil)
	and (#page.hints)
		if (page.hints[menu.y+1] ~= nil)
			shakex,shakey = happyshakelol(v,menu.y+1,true)
			v.drawString(pos.x*FU+shakex, (200-pos.y)*FU-10*FU+shakey,
				page.hints[menu.y+1],
				V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE,
				"thin-fixed"
			)
		end
	end
	
	local hinttrans = 0
	if menu.hintfade > 0
		if menu.hintfade > (3*TR+9)
			hinttrans = (menu.hintfade-(3*TR+9))<<V_ALPHASHIFT
		end
		if menu.hintfade < 10
			hinttrans = (10-menu.hintfade)<<V_ALPHASHIFT
		end
		shakex,shakey = happyshakelol(v,menu.y+1,true)
		v.drawString(pos.x*FU+shakex, ((200-pos.y)*FU)-42*FU+shakey,
			"[C1] - Exit",
			V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_GRAYMAP|V_RETURN8|V_ALLOWLOWERCASE|hinttrans,
			"thin-fixed"
		)
		shakex,shakey = happyshakelol(v,menu.y+1,true)
		v.drawString(pos.x*FU+shakex, ((200-pos.y)*FU)-34*FU+shakey,
			"[Jump] - Select",
			V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_GRAYMAP|V_RETURN8|V_ALLOWLOWERCASE|hinttrans,
			"thin-fixed"
		)
		shakex,shakey = happyshakelol(v,menu.y+1,true)
		v.drawString(pos.x*FU+shakex, ((200-pos.y)*FU)-26*FU+shakey,
			"[Up/Down] - Move Cursor",
			V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_GRAYMAP|V_RETURN8|V_ALLOWLOWERCASE|hinttrans,
			"thin-fixed"
		)
		shakex,shakey = happyshakelol(v,menu.y+1,true)
		v.drawString(pos.x*FU+shakex, ((200-pos.y)*FU)-18*FU+shakey,
			"[Left/Right] - Flip page",
			V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_GRAYMAP|V_RETURN8|V_ALLOWLOWERCASE|hinttrans,
			"thin-fixed"
		)
		
	end
	
	if takis.HUD.showingletter
		v.fadeScreen(0xFF00,16)
		local color = v.getColormap(nil,p.skincolor)
		v.drawScaled(160*FU,100*FU,FU,v.cachePatch("IMP_LETTER"),V_HUDTRANS,color)
		/*
		v.drawString(82,11,"Dear pesky rodents...",V_ALLOWLOWERCASE|V_HUDTRANS|V_INVERTMAP,"thin")
		v.drawString(76,21,"The Badniks and I have taken over\nGreenflower City. The Chaos Emeralds are",V_RETURN8|V_ALLOWLOWERCASE|V_HUDTRANS|V_INVERTMAP,"thin")
		v.drawString(72,37,"now permanent guests at one of my seven",V_ALLOWLOWERCASE|V_HUDTRANS|V_INVERTMAP,"thin")
		v.drawString(69,45,"Special Stages. I dare you to find them, if\nyou can! ",V_ALLOWLOWERCASE|V_HUDTRANS|V_INVERTMAP,"thin")
		*/
		
		for k,val in ipairs(letter)
			v.drawString(82,11*k,val,V_ALLOWLOWERCASE|V_HUDTRANS|V_INVERTMAP,"thin")		
		end
		
		v.drawString(82,11*(#letter+1),"C2 - Exit",V_ALLOWLOWERCASE|V_HUDTRANS|V_GRAYMAP,"left")
		v.drawScaled(108*FU,131*FU,FU,v.cachePatch("IMP_SIG"),V_HUDTRANS)
	end
end

local function drawcfgnotifs(v,p)
	if (customhud.CheckType("takis_cfgnotifs") != modname) return end
	
	if (skins[p.skin].name ~= TAKIS_SKIN)
		return
	end
	
	local takis = p.takistable
	local HUD = takis.HUD
	local me = p.mo
	
	if not HUD.cfgnotifstuff
		return
	end
	
	local trans = 0
	
	if HUD.cfgnotifstuff >= 6*TR+9
		trans = (HUD.cfgnotifstuff-(6*TR+9))<<V_ALPHASHIFT
	elseif HUD.cfgnotifstuff < 10
		trans = (10-HUD.cfgnotifstuff)<<V_ALPHASHIFT
	end
	
	local waveforce = FU/10
	local ay = FixedMul(waveforce,sin(leveltime*ANG2))
	v.drawScaled(160*FU,65*FU,FU+ay,v.cachePatch("BUBBLEBOX"),trans)
	
	if not multiplayer
		v.drawString(160,50,"Would you like to play",trans|V_ALLOWLOWERCASE,"thin-center")
		v.drawString(160,60,"the Takis Tutorial?",trans|V_ALLOWLOWERCASE,"thin-center")
		v.drawString(160,70,"\x86".."C2 - Yes",trans|V_ALLOWLOWERCASE,"thin-center")
		v.drawString(160,80,"\x86".."C3 - Dismiss",trans|V_ALLOWLOWERCASE,"thin-center")
	else
		v.drawString(160,50,"You have no Config, check",trans|V_ALLOWLOWERCASE,"thin-center")
		v.drawString(160,60,"out the \x86takis_openmenu\x80.",trans|V_ALLOWLOWERCASE,"thin-center")
		v.drawString(160,70,"\x86(Hold FN+C3+C2)",trans|V_ALLOWLOWERCASE,"thin-center")
		v.drawString(160,80,"\x86".."C3 - Dismiss",trans|V_ALLOWLOWERCASE,"thin-center")
	end
end

local function drawbonuses(v,p)
	if (customhud.CheckType("takis_bonuses") != modname) return end
	
	if (skins[p.skin].name ~= TAKIS_SKIN)
		return
	end
	
	local takis = p.takistable
	local HUD = takis.HUD
	local me = p.mo
	local fs = HUD.flyingscore
	
	local snap = "-"..fs.scorea
	if fs.scorea ~= "center" and fs.scorea ~= "right" then snap = '' end
	
	TakisDrawBonuses(
		v, p, -- Self explanatory.
		fs.scorex*FU, (fs.scorey*FU)+15*FU, fs.scores|V_ALLOWLOWERCASE, -- Powerups X & Y. Flags.
		'thin-fixed'..snap, -- string alignment.
		8*FU, ANGLE_90-- Distance to shift and which angle to do so.
	)
end

local function drawcrosshair(v,p)
	if (customhud.CheckType("takis_crosshair") != modname) return end
	
	if (skins[p.skin].name ~= TAKIS_SKIN)
		return
	end
	
	local takis = p.takistable
	local me = p.mo
	
	if not (takis.shotgunned)
		return
	end
	
	if (camera.chase and not (p.awayviewtics and not takis.in2D))
		return
	end
	
	local trans = V_HUDTRANS
	local scale = FU/2
	if takis.shotguncooldown
		scale = $+FixedDiv(takis.shotguncooldown*FU,6*FU)
		trans = V_HUDTRANSHALF
	end
	if (takis.noability & NOABIL_SHOTGUN)
		trans = V_HUDTRANSHALF
	end
	
	v.drawScaled(160*FU,100*FU,scale,v.cachePatch("SHGNCRSH"),trans)
end

local function drawtutbuttons(v,p)
	if (customhud.CheckType("takis_tutbuttons") != modname) return end
	
	if (skins[p.skin].name ~= TAKIS_SKIN)
		return
	end
	
	if (p.takis_noabil == nil) then return end
	if (p.textBoxInAction) then return end
	
	local takis = p.takistable
	local me = p.mo
	
	local disp = 0
	
	if (takis.transfo & TRANSFO_SHOTGUN)
	and (takis.shotgunforceon == false)
		v.drawScaled(hudinfo[HUD_LIVES].x*FU,
			(hudinfo[HUD_LIVES].y+disp)*FU,
			(FU/2)+(FU/12),
			v.cachePatch("TB_C3"),
			V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER|V_HUDTRANS
		)
		v.drawString(hudinfo[HUD_LIVES].x+20,
			hudinfo[HUD_LIVES].y+(disp+5),
			"De-Shotgun",
			V_ALLOWLOWERCASE|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER|V_HUDTRANS,
			"thin"
		)	
		disp = $-20
	end
	
	if not (p.takis_noabil & NOABIL_DIVE)
		v.drawScaled(hudinfo[HUD_LIVES].x*FU,
			(hudinfo[HUD_LIVES].y+disp)*FU,
			(FU/2)+(FU/12),
			v.cachePatch("TB_C1"),
			V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER|V_HUDTRANS
		)
		v.drawString(hudinfo[HUD_LIVES].x+20,
			hudinfo[HUD_LIVES].y+(disp+5),
			takis.transfo & TRANSFO_SHOTGUN and "Shoulder Bash" or "Dive",
			V_ALLOWLOWERCASE|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER|V_HUDTRANS,
			"thin"
		)	
		disp = $-20
	end
	
	if not (p.takis_noabil & NOABIL_SLIDE)
		v.drawScaled(hudinfo[HUD_LIVES].x*FU,
			(hudinfo[HUD_LIVES].y+disp)*FU,
			(FU/2)+(FU/12),
			v.cachePatch("TB_C2"),
			V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER|V_HUDTRANS
		)
		v.drawString(hudinfo[HUD_LIVES].x+20,
			hudinfo[HUD_LIVES].y+(disp+5),
			"Spin (hold on slope)",
			V_ALLOWLOWERCASE|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER|V_HUDTRANS,
			"thin"
		)
		disp = $-20
		v.drawScaled(hudinfo[HUD_LIVES].x*FU,
			(hudinfo[HUD_LIVES].y+disp)*FU,
			(FU/2)+(FU/12),
			v.cachePatch("TB_C2"),
			V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER|V_HUDTRANS
		)
		v.drawString(hudinfo[HUD_LIVES].x+20,
			hudinfo[HUD_LIVES].y+(disp+5),
			"Slide",
			V_ALLOWLOWERCASE|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER|V_HUDTRANS,
			"thin"
		)	
		disp = $-20
	end
	
	if not (p.takis_noabil & NOABIL_HAMMER)
		v.drawScaled(hudinfo[HUD_LIVES].x*FU,
			(hudinfo[HUD_LIVES].y+disp)*FU,
			(FU/2)+(FU/12),
			v.cachePatch("TB_SPIN"),
			V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER|V_HUDTRANS
		)
		v.drawString(hudinfo[HUD_LIVES].x+20,
			hudinfo[HUD_LIVES].y+(disp+5),
			"Hammer Blast (hold)",
			V_ALLOWLOWERCASE|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER|V_HUDTRANS,
			"thin"
		)	
		disp = $-20
	end
	
	if not (p.takis_noabil & NOABIL_THOK)
		v.drawScaled(hudinfo[HUD_LIVES].x*FU,
			(hudinfo[HUD_LIVES].y+disp)*FU,
			(FU/2)+(FU/12),
			v.cachePatch("TB_JUMP"),
			V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER|V_HUDTRANS
		)
		v.drawString(hudinfo[HUD_LIVES].x+20,
			hudinfo[HUD_LIVES].y+(disp+5),
			"x2 Double Jump",
			V_ALLOWLOWERCASE|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER|V_HUDTRANS,
			"thin"
		)	
		disp = $-20
	end
	
	if not (p.takis_noabil & NOABIL_CLUTCH)
		v.drawScaled(hudinfo[HUD_LIVES].x*FU,
			(hudinfo[HUD_LIVES].y+disp)*FU,
			(FU/2)+(FU/12),
			v.cachePatch("TB_SPIN"),
			V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER|V_HUDTRANS
		)
		v.drawString(hudinfo[HUD_LIVES].x+20,
			hudinfo[HUD_LIVES].y+(disp+5),
			takis.transfo & TRANSFO_SHOTGUN and "Shoot" or "Clutch Boost",
			V_ALLOWLOWERCASE|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER|V_HUDTRANS,
			"thin"
		)	
		disp = $-20
	end	

end

local function drawbosstitles(v,p)
	
	if (skins[p.skin].name ~= TAKIS_SKIN)
		return
	end
	
	local takis = p.takistable
	local me = p.mo
	local bosscards = takis.HUD.bosscards
	local title = takis.HUD.bosstitle
	
	if not title.tic then return end
	
	if not (bosscards.mo and bosscards.mo.valid) then return end
	
	if (bosscards.name)
		
		local ticker = title.tic-TR
		
		if 2*TR-ticker < 16
			--we probably just loaded the level
			if (leveltime <= 2*TR)
			or (p.jointime <= 2*TR)
				v.fadeScreen(0xFF00,32-(2*TR-ticker))
			else
				v.fadeScreen(0xFF00,(2*TR-ticker))
			end
		else
			if (ticker > 0)
				if (ticker < 16)
					v.fadeScreen(0xFF00,ticker)
				else
					v.fadeScreen(0xFF00,16)
				end
			end
		end
		
		if (3*TR-title.tic > 3)
			local tx,ty = unpack(title.takis)
			local x,y = unpack(title.egg)
			local vx1,vx2 = unpack(title.vs)
			local bosswidth = v.levelTitleWidth(bosscards.name)
			local sx,sy
			
	
			local patch = v.cachePatch("BT_SPIKEY"..(title.tic/2%3))
			
			local width = patch.width
			local height = patch.height
			local total_width = (v.width() / v.dupx()) + 1
			local hscale = FixedDiv(total_width * FU, width * FU)
			local vscale = FU
			if (3*TR-title.tic) < 17
				vscale = FixedDiv(3*TR*FU-(title.tic*FU),16*FU)
			elseif title.tic < 17
				vscale = FixedDiv(title.tic*FU,16*FU)				
			end
			
			v.drawStretched(0, (ty+10)*FU, hscale, vscale, patch, V_SNAPTOLEFT)
			--6 41
			v.drawScaled((tx-94)*FU,(ty-19)*FU,FU,v.cachePatch("BTP_TAKIS"..(title.tic/3%2)),0,v.getColormap(nil,p.skincolor))
			sx,sy = v.RandomRange(-1,1),v.RandomRange(-1,1)
			v.drawLevelTitle(tx+sx,ty+sy,takis.HUD.hudname or "Takis",0)
			
			sx,sy = happyshakelol(v)
			v.drawScaledNameTag(vx1*FU+sx,
				100*FU+sy,"V",0,FU,
				SKINCOLOR_KETCHUP,SKINCOLOR_WHITE
			)
			sx,sy = happyshakelol(v)
			v.drawScaledNameTag(vx2*FU+sx,
				100*FU+sy,"S",0,FU,
				SKINCOLOR_KETCHUP,SKINCOLOR_WHITE
			)
			
			patch = v.cachePatch("BT_SPIKEY"..(title.tic/2%3))
			v.drawStretched(320*FU, (y+10)*FU, hscale, vscale, patch, V_SNAPTORIGHT|V_FLIP)
			--294 121
			local bosspatch --= v.cachePatch("BTP_BOSSBLANK")
			local pstring = "BTP_"..string.upper(bosscards.name)..(title.tic/3%2)
			if not v.patchExists(pstring)
				bosspatch = v.cachePatch("BTP_BOSSDEFAULT"..(title.tic/3%2))
			else
				bosspatch = v.cachePatch(pstring)
			end
			
			v.drawScaled((x+94)*FU,(y-19)*FU,FU,bosspatch,0)
			sx,sy = v.RandomRange(-1,1),v.RandomRange(-1,1)
			v.drawLevelTitle(x-bosswidth+sx,y+sy,bosscards.name,0)
		end
		
		local trans = 0
		if title.tic >= 3*TR-9
			trans = (title.tic-(3*TR-9))<<V_ALPHASHIFT
		elseif title.tic < 10
			trans = (10-title.tic)<<V_ALPHASHIFT
		end
		if G_BuildMapTitle(gamemap) ~= nil
			v.drawString(160,190,G_BuildMapTitle(gamemap),V_YELLOWMAP|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE|trans,"thin-center")
		end
	end
	
end

local function drawtransfotimer(v,p,cam)
	if (customhud.CheckType("takis_transfotimer") != modname) return end	
	
	if (skins[p.skin].name ~= TAKIS_SKIN)
		return
	end
	
	local takis = p.takistable
	local me = p.realmo	
	
	if not (takis.transfo & (TRANSFO_PANCAKE|TRANSFO_FIREASS))
		return
	end
	
	if takis.io.minhud
		v.drawString(15*FU,55*FU,
			"Transfo:",
			V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE|V_HUDTRANS,
			"thin-fixed"
		)
		
		local pre = "MINFOB_"
		local back = v.cachePatch(pre.."BACK")
		local fill = v.cachePatch(pre.."FILL")
		
		local color = v.getColormap(nil,me.color)
		local color2 = v.getColormap(nil,p.skincolor)
		
		local max = 10*TR*FU
		local time = 0
		local time2 = 0
		local type = 0
		local type2 = 0
		
		v.drawScaled(54*FU,56*FU,FU,
			back,
			V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS
		)
		
		if takis.transfo & TRANSFO_PANCAKE
			if takis.pancaketime > takis.fireasstime
				time = takis.pancaketime*FU
				type = 0
			else
				time2 = takis.pancaketime*FU
				type2 = 0
			end
		end
		if takis.transfo & TRANSFO_FIREASS
			if takis.fireasstime > takis.pancaketime
				time = takis.fireasstime*FU
				type = 1
			else
				time2 = takis.fireasstime*FU
				type2 = 1
			end
		end
		
		local erm = FixedDiv(time,max)
		local width = FixedMul(erm,fill.width*FU)
		if width < 0 then
			width = 0
		end
		
		local erm2 = FixedDiv(time2,max)
		local width2 = FixedMul(erm2,fill.width*FU)
		if width2 < 0 then
			width2 = 0
		end
		
		v.drawCropped(54*FU,56*FU,FU,FU,
			fill,
			V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS, 
			(type == 1) and color or color2,
			0,0,
			width,fill.height*FU
		)
		
		v.drawCropped(54*FU,56*FU,FU,FU,
			fill,
			V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS, 
			(type2 == 1) and color or color2,
			0,0,
			width2,fill.height*FU
		)
		
	else
	
		local pre = "TRANSFOM_"
		local flip = 1
		local bubble = v.cachePatch(pre.."BAR")
		local fill = v.cachePatch(pre.."FILL")
		local mark = v.cachePatch(pre.."TIC")
		local x, y, scale, nodraw
		local cutoff = function(y) return false end
		local bottom = false
		
		if cam.chase and not (p.awayviewtics and not takis.in2D)
			x, y, scale, nodraw = R_GetScreenCoords(v, p, cam, me)
			if nodraw then return end
			
			scale = $*2
			if me.eflags & MFE_VERTICALFLIP
			and p.pflags & PF_FLIPCAM
				y = 200*FRACUNIT - $
			else
				flip = P_MobjFlip(me)
			end
			scale = FixedMul($,me.scale)
		else
			x, y, scale, bottom = 160*FRACUNIT, (130 - bubble.height >> 1)*FRACUNIT, FRACUNIT*2, true
		end
		
		scale = FixedDiv($,2*FU)
		
		if splitscreen
			if p == secondarydisplayplayer
				cutoff = function(y) return y < (bubble.height*scale >> 1) end
			else
				cutoff = function(y) return y > 200*FRACUNIT + (bubble.height*scale >> 1) end
			end
		end
		
		if not cutoff(y)
			
			local color = v.getColormap(nil,me.color)
			local color2 = v.getColormap(nil,p.skincolor)
			local invc  = v.getColormap(nil,SKINCOLOR_SALMON)
			
			x = $-(bubble.width*scale/2)
			y = $+25*scale
			
			local max = 10*TR*FU
			local time = 0 --(10*TR - (leveltime % (TR*10)))*FU
			local time2 = 0
			local type = 0
			local type2 = 0
			
			if takis.transfo & TRANSFO_PANCAKE
				if takis.pancaketime >= takis.fireasstime
					time = takis.pancaketime*FU
					type = 0
				else
					time2 = takis.pancaketime*FU
					type2 = 0
				end
			end
			if takis.transfo & TRANSFO_FIREASS
				if takis.fireasstime >= takis.pancaketime
					time = takis.fireasstime*FU
					type = 1
				else
					time2 = takis.fireasstime*FU
					type2 = 1
				end
			end
			
			local erm = FixedDiv(time,max)
			local width = FixedMul(erm,fill.width*FU)
			if width < 0 then
				width = 0
			end
			
			local erm2 = FixedDiv(time2,max)
			local width2 = FixedMul(erm2,fill.width*FU)
			if width2 < 0 then
				width2 = 0
			end
			
			local snap = (bottom) and V_SNAPTOBOTTOM or 0
			v.drawCropped(x,y,scale,scale,
				fill,
				snap|V_HUDTRANS|V_PERPLAYER, 
				(type == 1) and color or color2,
				0,0,
				width,fill.height*FU
			)
			
			v.drawCropped(x,y,scale,scale,
				fill,
				snap|V_HUDTRANS|V_PERPLAYER, 
				(type2 == 1) and color or color2,
				0,0,
				width2,fill.height*FU
			)
			
			v.drawScaled(x, y, scale, bubble, snap|V_PERPLAYER|V_HUDTRANS)
			if time2
				local offset = FixedMul(FixedMul(fill.width*FU,erm2),scale)+scale
				v.drawScaled(x+4*scale+offset, y+3*scale, scale, mark, snap|V_PERPLAYER|V_HUDTRANS,invc)
			end
			
			local offset = FixedMul(FixedMul(fill.width*FU,erm),scale)+scale
			v.drawScaled(x+4*scale+offset, y+3*scale, scale, mark, snap|V_PERPLAYER|V_HUDTRANS,invc)
		
		end
		
	end
	
end

local function drawfallout(v,p,tabdraw)
	
	if (skins[p.skin].name ~= TAKIS_SKIN)
		return
	end
		
		
	local takis = p.takistable
	local me = p.realmo	
	
	local tic = takis.pitanim
		
	if not tic then return end
		
	local width = (v.width() / v.dupx()) + 1
	local height = (v.height() / v.dupy()) + 1
	
	if tic >= 2*TR
		local timer = 3*TR-tic
		if timer >= TR/2+2
			v.fadeScreen(0xFF00,(timer-TR/2-2)*2)
		end
	elseif tic >= TR
		v.fadeScreen(0xFF00,32)
	elseif tic < TR
		local left = (160*FU)-(width*FU/2)--FixedMul(340*FU,FixedDiv(width*FU, 340*FU))
		local right = (160*FU)+(width*FU/2)+10*FU
		
		local wipe = v.cachePatch("TA_WIPE")
		local zig = v.cachePatch("TA_WIPEZIG")
		local zag = v.cachePatch("TA_WIPEZAG")
		
		local hscale = FixedDiv(width * FU, wipe.width * FU)
		local vscale = FixedDiv(height * FU, wipe.height * FU)
		
		--local tween = ease.inback((FU/TR)*(TR-tic),left,right,FU*2)
		local tween = ease.inquint((FU/TR)*(TR-tic),left,right)
		
		v.drawStretched(tween, 0, 
			hscale, vscale,
			zig,
			V_SNAPTOTOP
		)
		v.drawStretched(tween, 0, 
			hscale, vscale,
			wipe,
			V_SNAPTOTOP
		)
		v.drawStretched(tween, 0, 
			hscale, vscale,
			zag,
			V_SNAPTOTOP
		)
	end
	

	local top = (100*FU)-(height*FU/2)-10*FU
	local bottom = (100*FU)+(height*FU/2)+10*FU
	
	local tweentic = min(3*TR-tic,TR/2)
	local et = TR/2
	local tween = ease.outback((FU/et)*tweentic,
		top,
		100*FU,
		FU*2
	)
	
	if tic <= TR
	and tic > TR/2
		--
	end
	
	if tic <= TR
	and tic > et
		tween = ease.inback((FU/et)*(TR-tic),
			100*FU,
			bottom,
			FU*2
		)
	end
	
	if tic > et
	and not tabdraw
		v.drawString(160*FU,tween,"Fall out!",0,"fixed-center")
	end
end

local function drawdriftmeter(v,p,cam)
	if (customhud.CheckType("takis_kart_driftmeter") != modname) return end	
	
	if (skins[p.skin].name ~= TAKIS_SKIN)
		return
	end
	
	local takis = p.takistable
	local me = p.realmo	
	
	if not p.inkart then return end
	if not (me.tracer and me.tracer.valid) then return end
	local car = me.tracer
	if (car.drift == 0) then return end
	
	local width = 72*FU
	local flip = 1
	local bubble = v.cachePatch("TA_KDRIFT_BAR")
	local fill = v.cachePatch("TA_KDRIFT_FILL")
	local x, y, scale, nodraw
	local cutoff = function(y) return false end
	local bottom = false
	
	if cam.chase and not (p.awayviewtics and not takis.in2D)
		x, y, scale, nodraw = R_GetScreenCoords(v, p, cam, me)
		if nodraw then return end
		
		scale = $*2
		if me.eflags & MFE_VERTICALFLIP
		and p.pflags & PF_FLIPCAM
			y = 200*FRACUNIT - $
		else
			flip = P_MobjFlip(me)
		end
		scale = FU
	else
		x, y, scale, bottom = 160*FRACUNIT, (110 - bubble.height >> 1)*FRACUNIT, FRACUNIT, true
	end
	
	
	if splitscreen
		if p == secondarydisplayplayer
			cutoff = function(y) return y < (bubble.height*scale >> 1) end
		else
			cutoff = function(y) return y > 200*FRACUNIT + (bubble.height*scale >> 1) end
		end
	end
	
	if not cutoff(y)
		
		y = $+25*scale
		local percent = 0
		local tmap = 0
		local snap = (bottom) and V_SNAPTOBOTTOM or 0
		local bounce = false
		
		if car.driftspark
			local driftstage = TakisKart_DriftLevel(car.driftspark)
			local erm = 0
			local value = TakisKart_DriftSparkValue()
			local max = 0
			local erm2 = 0
			
			if car.drift == 0 then return end
			
			if car.driftspark >= value*4
				erm = 400*FU
				tmap = skincolors[TakisKart_DriftColor(driftstage)].chatcolor
			elseif car.driftspark >= value*2
				erm2 = car.driftspark-(value*2)
				erm = 200*FU+FixedMul(200*FU,FixedDiv(erm2,value*2))
				tmap = V_REDMAP
				max = value*2
			elseif car.driftspark >= value
				erm2 = car.driftspark-value
				erm = 100*FU+FixedMul(100*FU,FixedDiv(erm2,value))
				tmap = V_SKYMAP
				max = value
			else
				erm2 = car.driftspark
				erm = FixedMul(100*FU,FixedDiv(erm2,value))
				max = value
			end
			if car.driftbrake
			and (car.driftbrake & 1)
				tmap = V_REDMAP
				bounce = true
			end
			percent = FixedInt(erm)
			
			if driftstage > 1
			and driftstage ~= 4
				v.drawScaled(x,
					y,
					scale,
					fill,
					snap|V_PERPLAYER|V_HUDTRANS,
					v.getColormap(nil,TakisKart_DriftColor(driftstage-1))
				)
			end
			
			local color = TakisKart_DriftColor(driftstage)
			if driftstage == 4
				v.drawScaled(x,
					y,
					scale,
					fill,
					snap|V_PERPLAYER|V_HUDTRANS,
					v.getColormap(nil,color)
				)
			else
				local um = FixedDiv(erm2,max)
				local width = FixedMul(um,fill.width*FU)
				if width < 0 then
					width = 0
				end
				
				v.drawCropped(x,y,scale,scale,
					fill,
					snap|V_PERPLAYER|V_HUDTRANS, 
					v.getColormap(nil,color),
					0,0,
					width,fill.height*FU
				)
			
			end
		end
		
		v.drawScaled(x, y, scale, bubble, snap|V_PERPLAYER|V_HUDTRANS)
		v.drawString(x+(bubble.width*scale/2)+3*scale,
			y-2*scale-((bounce) and scale or 0),
			percent.."%",
			tmap|snap|V_PERPLAYER|V_HUDTRANS,
			"thin-fixed-right"
		)
	end
		
end

local function kartspeedometer(v,p,takis,car,minus)
	if (TAKIS_DEBUGFLAG & DEBUG_SPEEDOMETER) then return end
	
	local scale = FU
	local x,y = (hudinfo[HUD_LIVES].x+15)*FU+minus,(hudinfo[HUD_LIVES].y)*FU
	local flags = V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_HUDTRANS
	
	local maxspeed = 70*FU
	local speed = FixedDiv(takis.accspeed,maxspeed)
	local sroll
	if (speed ~= 0)
		sroll = FixedAngle(90*FU-FixedMul(90*FU,speed))
	else
		sroll = FixedAngle(90*FU)
	end
	sroll = $+FixedAngle(33*FU)
	
	v.drawScaled(5*FU+minus,192*FU,scale/2,
		v.cachePatch("TA_KFUEL_BCRC"),
		flags
	)
		
	local maxsegs = 50
	local meterfill = FixedDiv(abs(car.accel),car.basemaxspeed/8)
	local fx,fy = x,y-FU
	for i = 0,maxsegs,1
		if meterfill == 0 then break end
		
		local angmath = 
		FixedMul(
			FixedDiv(
				FixedMul(120*FU,meterfill),
				maxsegs*FU
			),
			i*FU
		)
		angmath = $+FixedAngle(33*FU)
		
		local angle = FixedAngle(angmath)
		v.drawScaled(
			fx+(15*cos(angle)),
			fy+(15*sin(angle)),
			FU/3,
			v.cachePatch("TA_LIVESFILL_BALL"),
			flags,
			v.getColormap(0,SKINCOLOR_WHITE)
		)
	end
	
	v.drawScaled(x,
		y-(AngleFixed(sroll) == 0 and 4*FU or 0),
		scale/2,
		v.getSpritePatch(SPR_THND,F,0,sroll),
		flags
	)
	
	local scorenum = "CMBCF"
	local score = FixedInt(takis.accspeed)
	local prevw
	if not prevw then prevw = 0 end
	
	local textwidth = 0
	for i = 1,string.len(score)
		local n = string.sub(score,i,i)
		local patch = v.cachePatch(scorenum+n)
		textwidth = $+(patch.width*scale*4/10)		
	end
	
	for i = 1,string.len(score)
		local sc = FixedDiv(scale,2*FU)
		local n = string.sub(score,i,i)
		local patch = v.cachePatch(scorenum+n)
		--local textwidth = (patch.width*scale*4/10)
		v.drawScaled(x+prevw-(textwidth/2),
			y-(patch.height*sc)+6*FU-(FU/2),
			sc,
			patch,
			flags
		)
			
		prevw = $+(patch.width*scale*4/10)
	end
	
	if G_RingSlingerGametype() or takis.inSRBZ
		local percent = min( FixedDiv(max(p.rings,p.spheres)*FU,40*FU),FU)
		local x,y = 95*FU+minus,130*FU
		local color
		local segcolor = {73, 64, 52, 54, 55, 35, 34, 33, 202, 180, 181, 182, 164, 165, 166, 153, 152}
		
		local width = max(FixedMul(percent,29*FU)/FU, 0)
		local ring = min(max(p.rings,p.spheres),40)
		if ring > 0 and width == 0
			width = 1
		end
		
		local ind = (ring*(#segcolor))/(40+1)
		
		v.drawFill((x/FU)-27,((y/FU)),width,3,segcolor[max(ind-1,1)]|flags)
		v.drawFill((x/FU)-27,((y/FU))+1,width,1,segcolor[max(ind-2,1)]|flags)
		v.drawFill((x/FU)-27,((y/FU))+3,width,3,segcolor[max(ind,1)]|flags)
		
		local patch = "RINGA0"
		if p.spheres > p.rings
			patch = "SPHRA0"
		end
		
		v.drawScaled(x-35*FU,
			y+7*FU,
			FU/4,
			v.cachePatch(patch),
			flags
		)
		
		v.drawScaled(x-27*FU,
			y+FU,
			FU/2,
			v.cachePatch("TA_KRING_BAR"),
			flags
		)
	end
	
end

local function kartfuelometer(v,p,takis,car,minus)
	local x,y = (hudinfo[HUD_LIVES].x+60)*FU+minus,(hudinfo[HUD_LIVES].y)*FU
	local flags = V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_HUDTRANS
	if (TAKIS_DEBUGFLAG & DEBUG_SPEEDOMETER)
		x = $+25*FU
	end
	local jerry = v.cachePatch("TA_KFUEL_CAN")
	local needroll = 0
	local maxfuel = 100*FU
	local lev = 100*FU-car.fuel
	local fuel = FixedDiv(lev,maxfuel)
	local color = SKINCOLOR_SUPERSILVER1
	if (car.damagetic
	or car.fuel <= 25*FU)
	and (leveltime/2 % 2)
		color = SKINCOLOR_RED 
	end
	local colorm = v.getColormap(nil,color)
	needroll = (FixedAngle(180*FU-FixedMul(180*FU,fuel))-ANGLE_90)
	
	v.drawScaled(x,
		y-(jerry.height*FU/2)-(FU/2),
		FU/2,
		v.cachePatch("TA_KFUEL_CIRC"),
		flags,
		colorm
	)	
	v.drawScaled(x,
		y-(jerry.height*FU/2)-(FU/2),
		FU,
		v.cachePatch("TA_KFUEL_EF"),
		flags,
		colorm
	)	
	v.drawScaled(x,
		y-(jerry.height*FU/2)+FU-(AngleFixed(needroll) == 0 and 4*FU or 0),
		FU/2,
		v.getSpritePatch(SPR_THND,E,0,needroll),
		flags,
		colorm
	)
	v.drawScaled(x,
		y-(jerry.height*FU/2),
		FU/2,
		jerry,
		flags,
		colorm
	)	
end

local function drawkartmeters(v,p)
	if (customhud.CheckType("takis_kart_meters") != modname) return end	
	
	if (skins[p.skin].name ~= TAKIS_SKIN)
		return
	end
	
	local takis = p.takistable
	local me = p.realmo	
	
	if not p.inkart then return end
	if not (me.tracer and me.tracer.valid) then return end
	local car = me.tracer
	if car.type ~= MT_TAKIS_KART_HELPER then return end
	if takis.HUD.lives.nokarthud then return end
	
	local minx = -55*FU
	local maxx = 12*FU
	local x = maxx
	local y = 128*FU
	if p.kartingtime < TR/2
		local etin = TR/2
		local intic = p.kartingtime
		
		x = ease.outback((FU/etin)*intic,minx, maxx, FU*3/2)
		
	end
	if not (TAKIS_DEBUGFLAG & DEBUG_SPEEDOMETER)
		v.drawScaled(x,y,FU,
			v.cachePatch("TA_KFUEL_BACKING"),
			V_HUDTRANSHALF|V_SNAPTOLEFT|V_SNAPTOBOTTOM
		)
	end
	
	kartspeedometer(v,p,takis,car,x-3*FU)
	kartfuelometer(v,p,takis,car,x-3*FU)
		
end


local function drawlapanim(v,p)
	local takis = p.takistable
	local me = p.realmo	
	local lapanim = takis.HUD.lapanim
	local x = 160*FU
	local y = 60*FU
	local tween = 0
	local et = 20
	local maxlaps = lapanim.maxlaps
	
	if lapanim.tics == 0 then return end
	
	if lapanim.tics >= 80-(et/2)
		et = $/2
		tween = ease.outquad((FU/et)*(et-(lapanim.tics-(80-et))), 300*FU, 0)	
	elseif lapanim.tics <= et
		tween = ease.inback((FU/et)*(et-lapanim.tics),
			0,
			-300*FU,
			FU*2
		)
	end
	x = $+tween
	
	local lastlap = lapanim.lapnum == maxlaps
	
	v.drawScaled(x,
		y,
		FU,
		lastlap and v.cachePatch("TA_LAPANIM_TXT2") or v.cachePatch("TA_LAPANIM_TXT1"),
		V_SNAPTOTOP|V_HUDTRANS,
		v.getColormap(nil,p.skincolor)
	)
	
	local waveforce = FU*2
	local thumbsine = FixedMul(waveforce,sin(leveltime*ANG15))
	v.drawScaled(x,
		y+thumbsine,
		FU,
		(isplayerlosing(p) and v.cachePatch("TA_LAPANIM_BAD") or v.cachePatch("TA_LAPANIM_GOOD")),
		V_SNAPTOTOP|V_HUDTRANS,
		v.getColormap(nil,p.skincolor)
	)
	
	local time = lapanim.time
	local min = G_TicsToMinutes(time,true)
	local sec = G_TicsToSeconds(time)
	local cen = G_TicsToCentiseconds(time)
	local timestr = tostring(min)..":"..(sec < 10 and "0" or '')..tostring(sec).."."..(cen < 10 and "0" or '')..tostring(cen)
	
	v.drawString(x,y+15*FU,
		timestr,
		V_SNAPTOTOP|V_HUDTRANS|((lapanim.tics/2 % 2) and V_YELLOWMAP or V_ORANGEMAP),
		"fixed-center"
	)
	
	if not lastlap
		local scorenum = "CMBCF"
		local score = lapanim.lapnum
		if score < 10
			score = "0"..$
		end
		local scale = FU*2
		
		local prevw
		if not prevw then prevw = 0 end
		
		local textwidth = 0
		for i = 1,string.len(score)
			local n = string.sub(score,i,i)
			local patch = v.cachePatch(scorenum+n)
			textwidth = $+(patch.width*scale*4/10)		
		end
		
		for i = 1,string.len(score)
			local sc = FixedDiv(scale,2*FU)
			local n = string.sub(score,i,i)
			local patch = v.cachePatch(scorenum+n)
			--local textwidth = (patch.width*scale*4/10)
			v.drawScaled(x+prevw-textwidth+60*FU,
				y-(patch.height*sc)+16*FU,
				sc,
				patch,
				V_SNAPTOTOP|V_HUDTRANS
			)
				
			prevw = $+(patch.width*scale*4/10)
		end
	end
	
end

local function drawracelaps(v,p)
	if (customhud.CheckType("takis_racelaps") != modname) return end	
	
	if (skins[p.skin].name ~= TAKIS_SKIN)
		return
	end
	
	local takis = p.takistable
	local me = p.realmo	
	
	if not (gametyperules & GTR_RACE) then return end
	if not circuitmap then return end
	
	local lapflag = v.cachePatch("TA_LAPFLAG")
	local scale = 3*FU/5
	v.drawScaled(160*FU-(lapflag.width*3*FU/5/2),
		170*FU,
		scale,
		lapflag,
		V_HUDTRANS|V_SNAPTOBOTTOM
	)
	v.drawString(160*FU,
		160*FU,
		"Laps",
		V_YELLOWMAP|V_ALLOWLOWERCASE|V_HUDTRANS|V_SNAPTOBOTTOM|V_RETURN8,
		"thin-fixed-center"
	)
	
	local maxlaps = CV_FindVar("numlaps").value
	if p.laps ~= maxlaps
		local map = (p.laps == maxlaps-1 
			and leveltime/4 & 1 
			and p.starpostnum == TAKIS_MISC.maxpostcount
			and not isplayerlosing(p)
		) and V_YELLOWMAP or V_PURPLEMAP
		
		v.drawString(160*FU,
			177*FU,
			(p.laps+1).."/"..maxlaps,
			map|V_ALLOWLOWERCASE|V_HUDTRANS|V_SNAPTOBOTTOM|V_RETURN8,
			"fixed-center"
		)
	else
		v.drawString(160*FU,
			177*FU,
			"Finished!",
			V_YELLOWMAP|V_ALLOWLOWERCASE|V_HUDTRANS|V_SNAPTOBOTTOM|V_RETURN8,
			"fixed-center"
		)	
	end
	
end

--lmao lol
local numtotrans = {
	[9] = V_90TRANS,
	[8] = V_80TRANS,
	[7] = V_70TRANS,
	[6] = V_60TRANS,
	[5] = V_50TRANS,
	[4] = V_40TRANS,
	[3] = V_30TRANS,
	[2] = V_20TRANS,
	[1] = V_10TRANS,
	[0] = 0,
}

--rsneo
local function drawviewmodel(v,p,cam)
	if (customhud.CheckType("takis_viewmodel") != modname) return end	
	
	if (skins[p.skin].name ~= TAKIS_SKIN)
		return
	end
	
	local takis = p.takistable
	local me = p.realmo	
	
	if not (me and me.valid) then return end
	
	if cam.chase
		return
	end
	
	if (p.awayviewtics and not (takis.in2D))
		return
	end
	
	if p.spectator then return end
	
	/*
	if (p.inkart)
		local car = me.tracer
		local turningang = FixedAngle(car.rmomt/9)
		if AngleFixed(turningang) > 180*FU
			turningang = InvAngle($)
		end
		local patch = v.getSpritePatch(SPR_THND,A,0,
			FixedAngle((car.rmomt/9)+(90*FU))
		)
		local scale = FU*3/2
		local x, y
		x = 160*FU
		y = 100*FU --220*FU
		
		if not splitscreen
			v.drawScaled(x,
				y,
				scale,
				patch,
				V_SNAPTOBOTTOM|V_PERPLAYER
			)
		end
		return
	end
	*/
	
	local col = v.getColormap((me.colorized and TC_RAINBOW or TC_DEFAULT), me.color)
	local x, y
	if (takis.transfo & TRANSFO_SHOTGUN)
	
		local framenum = (takis.HUD.viewmodel.frameinc/4)+1
		local patch = v.cachePatch("TA_VIEW_"..framenum)
		local scale = FU
		
		
		x = 32*FU + takis.HUD.viewmodel.bobx
		y = 48*FU + takis.HUD.viewmodel.boby
		
		if not splitscreen
			v.drawScaled(x,
				y,
				scale,
				patch,
				V_SNAPTOBOTTOM|V_PERPLAYER,
				col
			)
			
			if takis.afterimaging
				local timealive = TR-takis.bashtics
				local transnum = numtotrans[((timealive*2/3)+1) %9]
				col = v.getColormap(TC_RAINBOW,takis.afterimagecolor)
				v.drawScaled(x,
					y,
					scale,
					patch,
					V_SNAPTOBOTTOM|V_PERPLAYER|V_ADD|transnum,
					col
				)
			end
		end
	
	else
		if not (G_RingSlingerGametype() or takis.inSRBZ) then return end
		--rsneo has its own
		if RingSlinger then return end
		
		local currentweapon = takis.currentweapon
		local mm = gametype == GT_MURDERMYSTERY
		local role = p.role or 0
		if (takis.weapondelaytics)
			currentweapon = "FIRE"
		end
		local patch = v.cachePatch("TA_VIEWR_"..currentweapon)
		local scale = FU
		
		x = 208*FU + takis.HUD.viewmodel.bobx
		y = 80*FU + takis.HUD.viewmodel.boby
		
		if not splitscreen
			v.drawScaled(x,
				y,
				scale,
				patch,
				V_SNAPTORIGHT|V_SNAPTOBOTTOM|V_PERPLAYER,
				col
			)
			
			if (takis.currentweapon == 0
			or takis.currentweapon == 1
			or takis.currentweapon == 4)
			and not takis.weapondelaytics
				col = nil
				if takis.currentweapon == 0
					col = v.getColormap(nil,G_GametypeHasTeams() and (p.ctfteam == 1 and skincolor_redring or skincolor_bluering) or SKINCOLOR_RED)
				end
				v.drawScaled(x,
					y,
					scale,
					v.cachePatch("TA_VIEWR_"..takis.currentweapon.."R"),
					V_SNAPTORIGHT|V_SNAPTOBOTTOM|V_PERPLAYER,
					col
				)
			
			end
			
		end
		
		
	end
	
end

/*
local function drawbubbles(v,p,cam)
	--chrispy chars
	local player = p
	local mo = player.mo
	
	local flip = 1
	local bubble = v.cachePatch("TA_BUBBLE")
	local angdiff = ANGLE_90
	local x, y, scale
	local cutoff = function(y) return false end
	
	if cam.chase and not (player.awayviewtics and not (me.flags2 & MF2_TWOD))
		x, y, scale = R_GetScreenCoords(v, player, cam, mo)
		x = $+(10*scale)
		if mo.eflags & MFE_VERTICALFLIP
		and player.pflags & PF_FLIPCAM
			y = 200*FRACUNIT - $
		else
			flip = P_MobjFlip(mo)
		end
	else
		x, y, scale = 160*FRACUNIT, (100 + bubble.height >> 1)*FRACUNIT, FRACUNIT/3
	end
	
	if splitscreen
		if player == secondarydisplayplayer
			cutoff = function(y) return y < (bubble.height*scale >> 1) end
		else
			cutoff = function(y) return y > 200*FRACUNIT + (bubble.height*scale >> 1) end
		end
	end
	
	local angle = angdiff - ANGLE_90
	local x = x - P_ReturnThrustX(nil, angle, 50*scale)
	local y = y - flip*P_ReturnThrustY(nil, angle, 64*scale)
		
	if not cutoff(y)
	and p.powers[pw_underwater]
		local j = -1
		for i = -3,2
			j = $+1
			local flag = V_HUDTRANSHALF
			if j-1 < p.powers[pw_underwater]/TR/5
				flag = V_HUDTRANS
			end
			v.drawScaled(x, y+(i*25*scale), scale, bubble, V_PERPLAYER|flag)
		end
	end
end
*/

local function DrawButton(v, player, x, y, flags, color, color2, butt, symb, strngtype)
-- Buttons! Shows input controls.
-- butt parameter is the button cmd in question.
-- symb represents the button via drawn string.
	local offs, col
	if (butt == 1) then
		offs = 0
		col = flags|color2
	elseif (butt > 1) then
		offs = 0
		col = flags|color
	else
		offs = 1
		col = flags|16
		v.drawFill(
			(x), (y+9),
			10, 1, flags|29
		)
	end
	v.drawFill(
		(x), (y)-offs,
		10, 10,	col
	)
	
	local stringx, stringy = 1, 1
	if (strngtype == 'thin') then
		stringx, stringy = 0, 2
	end
	
	v.drawString(
		(x+stringx), (y+stringy)-offs,
		symb, flags, strngtype
	)
end

local function DrawMiniButton(v, player, x, y, flags, color, butt, symb, strngtype)
-- This is identical to above. Only mini, when you need to have it small.
-- butt parameter is the button cmd in question.
-- symb represents the button via drawn string.
	local offs, col
	if (butt) and (player.cmd.buttons & butt) then
		offs = 0
		col = flags|color
	else
		offs = 1
		col = flags|16
		v.drawFill(
			(x), (y+9),
			5, 1, flags|29
		)
	end
	v.drawFill(
		(x), (y)-offs,
		5, 10,	col
	)
	
	local stringx, stringy = 1, 1
	if (strngtype == 'thin') then
		stringx, stringy = 0, 2
	end
	
	v.drawString(
		(x+stringx), (y+stringy)-offs,
		symb, flags, strngtype
	)
end

local musname
addHook("ThinkFrame",do
	musname = S_MusicName()
end)

local getpstate = {
	[0] = "PST_LIVE",
	[1] = "PST_DEAD",
	[2] = "PST_REBORN",
}
local getdmg = {
	[0] = "None",
	[1] = "DMG_WATER",
	[2] = "DMG_FIRE",
	[3] = "DMG_ELECTRIC",
	[4] = "DMG_SPIKE",
	[5] = "DMG_NUKE",
	[128] = "DMG_INSTAKILL",
	[129] = "DMG_DROWNED",
	[130] = "DMG_SPACEDROWN",
	[131] = "DMG_DEATHPIT",
	[132] = "DMG_CRUSHED",
	[133] = "DMG_SPECTATOR",
}

local getcarry = {
	[0] = "none",
	[1] = "generic",
	[2] = "player",
	[3] = "nightsmode",
	[4] = "nightsfall",
	[5] = "brakgoop",
	[6] = "zoomtube",
	[7] = "ropehang",
	[8] = "macespin",
	[9] = "minecart",
	[10] = "rollout",
	[11] = "pterabyte",
	[12] = "dustdevil",
	[13] = "fan",
	[20] = "kart",
}

local function drawflag(v,x,y,string,flags,onmap,offmap,align,flag)
	local map = offmap
	if flag
		map = onmap
	end
	
	v.drawString(x,y,string,flags|map,align)
end

local function drawdebug(v,p)
	local takis = p.takistable
	local me = p.mo
	
	if not TAKIS_ISDEBUG
		return
	end
	
	if (TAKIS_DEBUGFLAG & DEBUG_BUTTONS)
		local x, y = 15, hudinfo[HUD_LIVES].y
		local flags = V_HUDTRANS|V_PERPLAYER|V_SNAPTOBOTTOM|V_SNAPTOLEFT
		local color = (p.skincolor and skincolors[p.skincolor].ramp[4] or 0)
		local color2 = (ColorOpposite(p.skincolor) and skincolors[ColorOpposite(p.skincolor)].ramp[4] or 0)
		DrawButton(v, p, x, y, flags, color, color2, takis.jump, 'J', 'left')
		DrawButton(v, p, x+11, y, flags, color, color2, takis.use,  'S', 'left')
		DrawButton(v, p, x+22, y, flags, color, color2, takis.tossflag, 'TF', 'thin')
		DrawButton(v, p, x+33, y, flags, color, color2, takis.c1,  'C1', 'thin')
		DrawButton(v, p, x+44, y, flags, color, color2, takis.c2,  'C2', 'thin')
		DrawButton(v, p, x+55, y, flags, color, color2, takis.c3,  'C3', 'thin')
		DrawButton(v, p, x+66, y, flags, color, color2, takis.fire,'F', 'left')
		DrawButton(v, p, x+77, y, flags, color, color2, takis.firenormal,'FN', 'thin')
		DrawButton(v, p, x+88, y, flags, color, color2, takis.weaponmasktime,takis.weaponmask, 'left')
		
		--these arent really flags so it wouldnt make sense to draw them like they are
		v.drawString(x,y-128,"pw_carry",flags,"thin")
		if not p.inkart
			v.drawString(x,y-120,getcarry[p.powers[pw_carry]] or "Unknown",flags,"thin")
		else
			v.drawString(x,y-120,"TAKISKART",flags,"thin")
		end
		
		v.drawString(x,y-108,"pw_strong",flags,"thin")
		drawflag(v,x+00,y-100,"NN",flags,V_GREENMAP,V_REDMAP,"thin",(p.powers[pw_strong] & STR_NONE))
		drawflag(v,x+15,y-100,"AN",flags,V_GREENMAP,V_REDMAP,"thin",(p.powers[pw_strong] & STR_ANIM))
		drawflag(v,x+30,y-100,"PN",flags,V_GREENMAP,V_REDMAP,"thin",(p.powers[pw_strong] & STR_PUNCH))
		drawflag(v,x+45,y-100,"TL",flags,V_GREENMAP,V_REDMAP,"thin",(p.powers[pw_strong] & STR_TAIL))
		drawflag(v,x+60,y-100,"ST",flags,V_GREENMAP,V_REDMAP,"thin",(p.powers[pw_strong] & STR_STOMP))
		drawflag(v,x+75,y-100,"UP",flags,V_GREENMAP,V_REDMAP,"thin",(p.powers[pw_strong] & STR_UPPER))
		drawflag(v,x+90,y-100,"GD",flags,V_GREENMAP,V_REDMAP,"thin",(p.powers[pw_strong] & STR_GUARD))
		--line 2
		drawflag(v,x+00,y-90,"HV",flags,V_GREENMAP,V_REDMAP,"thin",(p.powers[pw_strong] & STR_HEAVY))
		drawflag(v,x+15,y-90,"DS",flags,V_GREENMAP,V_REDMAP,"thin",(p.powers[pw_strong] & STR_DASH))
		drawflag(v,x+30,y-90,"WL",flags,V_GREENMAP,V_REDMAP,"thin",(p.powers[pw_strong] & STR_WALL))
		drawflag(v,x+45,y-90,"FL",flags,V_GREENMAP,V_REDMAP,"thin",(p.powers[pw_strong] & STR_FLOOR))
		drawflag(v,x+60,y-90,"CL",flags,V_GREENMAP,V_REDMAP,"thin",(p.powers[pw_strong] & STR_CEILING))
		drawflag(v,x+75,y-90,"SP",flags,V_GREENMAP,V_REDMAP,"thin",(p.powers[pw_strong] & STR_SPRING))
		drawflag(v,x+90,y-90,"SK",flags,V_GREENMAP,V_REDMAP,"thin",(p.powers[pw_strong] & STR_SPIKE))
		
		v.drawString(x,y-78,"transfo",flags|V_GREENMAP,"thin")
		drawflag(v,x+00,y-70,"SG",flags,V_GREENMAP,V_REDMAP,"thin",(takis.transfo & TRANSFO_SHOTGUN))
		drawflag(v,x+15,y-70,"BL",flags,V_GREENMAP,V_REDMAP,"thin",(takis.transfo & TRANSFO_BALL))
		drawflag(v,x+30,y-70,"PC",flags,V_GREENMAP,V_REDMAP,"thin",(takis.transfo & TRANSFO_PANCAKE))
		drawflag(v,x+45,y-70,"EL",flags,V_GREENMAP,V_REDMAP,"thin",(takis.transfo & TRANSFO_ELEC))
		drawflag(v,x+60,y-70,"TR",flags,V_GREENMAP,V_REDMAP,"thin",(takis.transfo & TRANSFO_TORNADO))
		drawflag(v,x+75,y-78,
			FixedMul(FixedDiv(takis.fireasstime*FU,10*TR*FU),100*FU)/FU.."%",
		flags,V_GREENMAP,V_REDMAP,"thin",(takis.transfo & TRANSFO_FIREASS))
		drawflag(v,x+75,y-70,"FA",flags,V_GREENMAP,V_REDMAP,"thin",(takis.transfo & TRANSFO_FIREASS))
		
		v.drawString(x,y-58,"noability",flags|V_GREENMAP,"thin")
		drawflag(v,x+00,y-50,"CL",flags,V_GREENMAP,V_REDMAP,"thin",(takis.noability & NOABIL_CLUTCH))
		drawflag(v,x+15,y-50,"HM",flags,V_GREENMAP,V_REDMAP,"thin",(takis.noability & NOABIL_HAMMER))
		drawflag(v,x+30,y-50,"DI",flags,V_GREENMAP,V_REDMAP,"thin",(takis.noability & NOABIL_DIVE))
		drawflag(v,x+45,y-50,"SL",flags,V_GREENMAP,V_REDMAP,"thin",(takis.noability & NOABIL_SLIDE))
		drawflag(v,x+60,y-50,"WD",flags,V_GREENMAP,V_REDMAP,"thin",(takis.noability & NOABIL_WAVEDASH))
		drawflag(v,x+75,y-50,"SG",flags,V_GREENMAP,V_REDMAP,"thin",(takis.noability & NOABIL_SHOTGUN))
		drawflag(v,x+75,y-58,"FO",flags,V_GREENMAP,V_REDMAP,"thin",(takis.shotgunforceon))
		drawflag(v,x+90,y-50,"SH",flags,V_GREENMAP,V_REDMAP,"thin",(takis.noability & NOABIL_SHIELD))
		drawflag(v,x+105,y-50,"TH",flags,V_GREENMAP,V_REDMAP,"thin",(takis.noability & NOABIL_THOK))
		drawflag(v,x+120,y-50,"AI",flags,V_GREENMAP,V_REDMAP,"thin",(takis.noability & NOABIL_AFTERIMAGE))
		
		v.drawString(x,y-38,"FSTASIS",flags|V_GREENMAP,"thin")
		v.drawString(x,y-30,takis.stasistic,flags,"thin")
		
		v.drawString(x+60,y-38,"stasis",flags,"thin")
		drawflag(v,x+60,y-30,"FS",flags,V_GREENMAP,V_REDMAP,"thin",(p.pflags & PF_FULLSTASIS))
		drawflag(v,x+78,y-30,"JS",flags,V_GREENMAP,V_REDMAP,"thin",(p.pflags & PF_JUMPSTASIS))
		drawflag(v,x+96,y-30,"SS",flags,V_GREENMAP,V_REDMAP,"thin",(p.pflags & PF_STASIS))
		
		v.drawString(x,y-18,"nocontrol",flags|V_GREENMAP,"thin")
		v.drawString(x,y-10,takis.nocontrol,flags,"thin")
		
		v.drawString(x+60,y-18,"nocontrol",flags,"thin")
		v.drawString(x+60,y-10,p.powers[pw_nocontrol],flags,"thin")
		
	end
	if (TAKIS_DEBUGFLAG & DEBUG_STATE)
		local pstate = getpstate[p.playerstate]
		local dmg = getdmg[takis.saveddmgt]
		
		v.drawString(100,100,"State: "..me.state,V_ALLOWLOWERCASE,"thin")
		v.drawString(100,108,"Sprite2: "..spr2names[me.sprite2],V_ALLOWLOWERCASE,"thin")
		v.drawString(100,116,"PState: "..pstate,V_ALLOWLOWERCASE,"thin")
		v.drawString(100,124,"Deadtimer: "..p.deadtimer,V_ALLOWLOWERCASE,"thin")
		v.drawString(100,132,"DMG: "..dmg ,V_ALLOWLOWERCASE,"thin")
		drawflag(v,100,140,"TDeadtimer: "..takis.deadtimer,V_ALLOWLOWERCASE,V_GREENMAP,0,"thin",(takis.freezedeath))
		
		drawflag(v,200,100,"Pain",V_PERPLAYER|V_ALLOWLOWERCASE,V_GREENMAP,V_REDMAP,"thin",(takis.inPain))
		drawflag(v,200,108,"FakePain",V_PERPLAYER|V_ALLOWLOWERCASE,V_GREENMAP,V_REDMAP,"thin",(takis.inFakePain))
		drawflag(v,200,116,"WaterSlide",V_PERPLAYER|V_ALLOWLOWERCASE,V_GREENMAP,V_REDMAP,"thin",(takis.inwaterslide))
		drawflag(v,200,124,"WasWaterSlide",V_PERPLAYER|V_ALLOWLOWERCASE,V_GREENMAP,V_REDMAP,"thin",(takis.wasinwaterslide))
		drawflag(v,200,132,"TicsForPain: "..takis.ticsforpain,V_PERPLAYER|V_ALLOWLOWERCASE,V_GREENMAP,V_REDMAP,"thin",(takis.ticsforpain > 0))
		drawflag(v,200,140,"TicsInPain: "..takis.ticsinpain,V_PERPLAYER|V_ALLOWLOWERCASE,V_GREENMAP,V_REDMAP,"thin",(takis.ticsinpain > 0))
		v.drawString(200,148,"Pitanim: "..takis.pitanim,V_PERPLAYER|V_ALLOWLOWERCASE,"thin")
		v.drawString(200,156,"Pittime,Count: "..takis.pittime..","..takis.pitcount,V_PERPLAYER|V_ALLOWLOWERCASE,"thin")
	end
	if (TAKIS_DEBUGFLAG & DEBUG_ACH)
		for k,va in ipairs(takis.HUD.steam)
			if va == nil
				continue
			end
			
			local t = TAKIS_ACHIEVEMENTINFO
			v.drawString(165,k*8,t[va.enum].name,
				V_ALLOWLOWERCASE|V_HUDTRANS|V_SNAPTOTOP,
				"thin"
			)
		end
		local work = 0
		for p2 in players.iterate
			local extra = ''
			if p2.takistable.achbits
				extra = " ("..p2.takistable.achbits..")"
			end
			v.drawString(290,30+(work*8),
				"[#"..#p2.."] "..p2.name.." - "..p2.takistable.achfile..extra,
				V_HUDTRANS|V_SNAPTOTOP|V_SNAPTORIGHT|V_ALLOWLOWERCASE|
				((p2 == p) and V_YELLOWMAP or 0),
				"thin-right"
			)
			work = $+1
		end
		v.drawString(290,30+(work*8),
			"\x8EusedCheats\x80:\x84 "..tostring(usedCheats),
			V_HUDTRANS|V_SNAPTOTOP|V_SNAPTORIGHT|V_ALLOWLOWERCASE,
			"thin-right"
		)
		v.drawString(290,38+(work*8),
			"TAKIS_NET.usedcheats:\x84 "..tostring(TAKIS_NET.usedcheats),
			V_HUDTRANS|V_SNAPTOTOP|V_SNAPTORIGHT|V_ALLOWLOWERCASE,
			"thin-right"
		)
		v.drawString(290,46+(work*8),
			"TAKIS_NET.achtime:\x84 "..TAKIS_NET.achtime,
			V_HUDTRANS|V_SNAPTOTOP|V_SNAPTORIGHT|V_ALLOWLOWERCASE,
			"thin-right"
		)
	end
	if (TAKIS_DEBUGFLAG & DEBUG_QUAKE)
		local red = (not takis.io.quakes) and V_REDMAP or 0
		for k,va in ipairs(takis.quake)
			if va == nil
				continue
			end
			
			v.drawString(40,8*(k-1),
				va.tics.." | "..
				L_FixedDecimal(va.intensity,3)..
				((va.id ~= nil) and (" - "..va.id) or ''),
				red|V_HUDTRANS|V_ALLOWLOWERCASE,
				"left"
			)
		end
		v.drawString(40,-8,L_FixedDecimal(takis.quakeint,3),red|V_HUDTRANS,"left")
	end
	if (TAKIS_DEBUGFLAG & DEBUG_HAPPYHOUR)
		local strings = prtable("Happy Hour",HAPPY_HOUR,false)
		for k,va in ipairs(strings)
			v.drawString(100,30+(8*(k-1)),va,V_ALLOWLOWERCASE,"thin")
		end
		
		local dh = {}
		dh.x = tonumber(mapheaderinfo[gamemap].takis_hh_exit_x)
		dh.y = tonumber(mapheaderinfo[gamemap].takis_hh_exit_y)
		dh.z = tonumber(mapheaderinfo[gamemap].takis_hh_exit_z)
		for k,v in pairs(dh)
			if v == nil
				dh.valid = false
				break
			else
				dh.valid = true
				continue
			end
		end
		local th = {}
		th.x = tonumber(mapheaderinfo[gamemap].takis_hh_trig_x)
		th.y = tonumber(mapheaderinfo[gamemap].takis_hh_trig_y)
		th.z = tonumber(mapheaderinfo[gamemap].takis_hh_trig_z)
		th.flip = mapheaderinfo[gamemap].takis_hh_trig_flip ~= nil
		for k,v in pairs(th)
			if type(v) == "boolean" then continue end
			if v == nil
				th.valid = false
				break
			else
				th.valid = true
				continue
			end
		end
		
		v.drawString(100,
			30+(8*(#strings)),
			"door: {x="..(dh.x or "nil")..",y="..(dh.y or "nil")..",z="..(dh.z or "nil").."}",
			V_ALLOWLOWERCASE|((not dh.valid) and V_REDMAP or 0),"thin"
		)
		v.drawString(100,
			38+(8*(#strings)),
			"trig: {x="..(th.x or "nil")..",y="..(th.y or "nil")..",z="..(th.z or "nil")..",f="..(tostring(th.flip) or "nil").."}",
			V_ALLOWLOWERCASE|((not th.valid) and V_REDMAP or 0),"thin"
		)
		v.drawString(100,
			46+(8*(#strings)),
			"candoshit: "..tostring( HH_CanDoHappyStuff(p) ),
			V_ALLOWLOWERCASE,
			"thin"
		)
		
	end
	--not exactly aligned but whatever
	if (TAKIS_DEBUGFLAG & DEBUG_ALIGNER)
		v.drawScaled(160*FU-(FU/2),100*FU-(FU/2),FU,v.cachePatch("ALIGNER"),V_20TRANS)
	end
	if (TAKIS_DEBUGFLAG & DEBUG_PFLAGS)
		drawflag(v,100,60,"FC",
			V_HUDTRANS|V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_FLIPCAM)
		)
		drawflag(v,110,60,"AM",
			V_HUDTRANS|V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_ANALOGMODE)
		)
		drawflag(v,120,60,"DC",
			V_HUDTRANS|V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_DIRECTIONCHAR)
		)
		drawflag(v,130,60,"AB",
			V_HUDTRANS|V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_AUTOBRAKE)
		)
		drawflag(v,140,60,"GM",
			V_HUDTRANS|V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_GODMODE)
		)
		drawflag(v,150,60,"NC",
			V_HUDTRANS|V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_NOCLIP)
		)
		drawflag(v,160,60,"IV",
			V_HUDTRANS|V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_INVIS)
		)
		drawflag(v,170,60,"ad",
			V_HUDTRANS|V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_ATTACKDOWN)
		)
		drawflag(v,180,60,"sd",
			V_HUDTRANS|V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_SPINDOWN)
		)
		drawflag(v,190,60,"jd",
			V_HUDTRANS|V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_JUMPDOWN)
		)
		drawflag(v,200,60,"wd",
			V_HUDTRANS|V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_WPNDOWN)
		)
		drawflag(v,210,60,"Stasis not drawn",
			V_HUDTRANS|V_PERPLAYER,
			V_GREENMAP,0,
			"small"
		)
		
		drawflag(v,100,70,"AA",
			V_HUDTRANS|V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_APPLYAUTOBRAKE)
		)
		drawflag(v,110,70,"sj",
			V_HUDTRANS|V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_STARTJUMP)
		)
		drawflag(v,120,70,"ju",
			V_HUDTRANS|V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_JUMPED)
		)
		drawflag(v,130,70,"nj",
			V_HUDTRANS|V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_NOJUMPDAMAGE)
		)
		drawflag(v,140,70,"sp",
			V_HUDTRANS|V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_SPINNING)
		)
		drawflag(v,150,70,"ss",
			V_HUDTRANS|V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_STARTDASH)
		)
		drawflag(v,160,70,"th",
			V_HUDTRANS|V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_THOKKED)
		)
		--
		drawflag(v,160,74,"th",
			V_HUDTRANS|V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			takis.thokked
		)
		drawflag(v,160,78,"di",
			V_HUDTRANS|V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			takis.dived
		)
		--
		drawflag(v,170,70,"sa",
			V_HUDTRANS|V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_SHIELDABILITY)
		)
		drawflag(v,180,70,"gl",
			V_HUDTRANS|V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_GLIDING)
		)
		drawflag(v,190,70,"bc",
			V_HUDTRANS|V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_BOUNCING)
		)
		drawflag(v,200,70,"sl",
			V_HUDTRANS|V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			takis.inwaterslide
		)
		drawflag(v,210,70,"tc",
			V_HUDTRANS|V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_TRANSFERTOCLOSEST)
		)
		drawflag(v,220,70,"nd",
			V_HUDTRANS|V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_DRILLING)
		)
		drawflag(v,230,70,"go",
			V_HUDTRANS|V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_GAMETYPEOVER)
		)
		drawflag(v,240,70,"it",
			V_HUDTRANS|V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_TAGIT)
		)
		drawflag(v,250,70,"fs",
			V_HUDTRANS|V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_FORCESTRAFE)
		)
		drawflag(v,260,70,"cc",
			V_HUDTRANS|V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_CANCARRY)
		)
		drawflag(v,270,70,"fin",
			V_HUDTRANS|V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_FINISHED)
		)
		
	end
	if (TAKIS_DEBUGFLAG & DEBUG_SPEEDOMETER)
		
		local ypos = hudinfo[HUD_LIVES].y
		if modeattacking then ypos = hudinfo[HUD_LIVES].y+10 end
		local maxspeed = 200*FU
		local speed = FixedDiv(takis.accspeed,maxspeed)
		local runspeed = FixedDiv(p.runspeed,maxspeed)
		local normalspeed = FixedDiv(p.normalspeed,maxspeed)
		local roll
		local rsroll
		local nroll
		local scale = FU
		local offy2 = 0
		if (speed ~= 0)
			roll = FixedAngle(180*FU-FixedMul(180*FU,speed))
		else
			roll = FixedAngle(180*FU)
		end
		if (normalspeed ~= 0)
			nroll = FixedAngle(180*FU-FixedMul(180*FU,normalspeed))
		else
			nroll = FixedAngle(180*FU)
		end
		if (runspeed ~= 0)
			rsroll = FixedAngle(180*FU-FixedMul(180*FU,runspeed))
		else
			rsroll = FixedAngle(180*FU)
		end
		if AngleFixed(roll) == 0
			offy2 = -4
		end
		
		for i = 0,10
			local offy = 0
			local ra = FixedAngle(180*FU-(i*18)*FU)
			if i == 10
				offy = -4
			end
			v.drawScaled((hudinfo[HUD_LIVES].x+30)*FU,
				(ypos-8+offy)*FU,
				FU/2,
				v.getSpritePatch(SPR_THND,B,0,ra),
				V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER
			)
			if i == 5
				v.drawString((hudinfo[HUD_LIVES].x+30)*FU+(30*cos(ra)),
					(ypos-8+offy)*FU-(35*sin(ra))-(4*FU),
					"100",
					V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER,
					"thin-fixed-center"
				)	
			elseif i == 10
				v.drawString((hudinfo[HUD_LIVES].x+30)*FU+(35*cos(ra)),
					(ypos-8+offy)*FU-(35*sin(ra))-(7*FU),
					"200",
					V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER,
					"thin-fixed-center"
				)	
			end
		end
		
		v.drawScaled((hudinfo[HUD_LIVES].x+30)*FU,
			(ypos-8+offy2)*FU,
			FU/2,
			v.getSpritePatch(SPR_THND,D,0,rsroll),
			V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER
		)
		v.drawScaled((hudinfo[HUD_LIVES].x+30)*FU,
			(ypos-8+offy2)*FU,
			FU/2,
			v.getSpritePatch(SPR_THND,C,0,nroll),
			V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER
		)
		
		v.drawScaled((hudinfo[HUD_LIVES].x+30)*FU,
			(ypos-8+offy2)*FU,
			FU/2,
			v.getSpritePatch(SPR_THND,A,0,roll),
			V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER
		)
		
		local scorenum = "CMBCF"
		local score = L_FixedDecimal(takis.accspeed,3)
		
		local prevw
		if not prevw then prevw = 0 end
		
		for i = 1,string.len(score)
			local n = string.sub(score,i,i)
			--if n == "." then n = "DOT" end
			v.drawScaled(hudinfo[HUD_LIVES].x*FU+(prevw*scale),
				(ypos)*FU-(v.cachePatch(scorenum+n).height*FixedDiv(scale-FU,2*FU)),
				FixedDiv(scale,2*FU),
				v.cachePatch(scorenum+n),
				V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER
			)
				
			prevw = $+v.cachePatch(scorenum+n).width*4/10
		end
		
		v.drawString(hudinfo[HUD_LIVES].x*FU,
			(ypos-60)*FU,
			L_FixedDecimal(me.friction,3).." friction",
			V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER,
			"thin-fixed"
		)
		
		v.drawString(hudinfo[HUD_LIVES].x*FU,
			(ypos-68)*FU,
			p.thrustfactor.." thrust",
			V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER,
			"thin-fixed"
		)

		v.drawString(hudinfo[HUD_LIVES].x*FU,
			(ypos-76)*FU,
			p.accelstart..", "..p.acceleration.." accelstart, accel",
			V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER,
			"thin-fixed"
		)
		
		v.drawString(hudinfo[HUD_LIVES].x*FU,
			(ypos-84)*FU,
			L_FixedDecimal(me.movefactor,3).." movefactor",
			V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER,
			"thin-fixed"
		)
		
		v.drawString(hudinfo[HUD_LIVES].x*FU,
			(ypos-92)*FU,
			L_FixedDecimal(me.subsector.sector.friction,3).." sec fric",
			V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER,
			"thin-fixed"
		)
		
		/*
		//height debug
		local scale = FU/10
		local floorz = me.floorz
		local drawz = 175*FU-FixedMul(floorz,scale)
		v.drawFill(105,175-(FixedMul(floorz,scale)/FU),60,2,
			skincolors[ColorOpposite(p.skincolor)].ramp[4]|
			V_SNAPTOBOTTOM
		)
		local dist = (me.z-floorz)
		v.drawScaled(115*FU,
			drawz-FixedMul(dist,scale),
			FixedMul(scale,skins[me.skin].highresscale or FU),
			v.getSprite2Patch(me.skin,me.sprite2,
			p.powers[pw_super] > 0,
			me.frame,
				3,me.rollangle
			),
			V_SNAPTOBOTTOM,
			v.getColormap(nil,me.color)
		)
		for i = 0,2
			v.drawScaled(122*FU+(i*FU*7),
				drawz,
				FixedMul(scale,skins[i].highresscale or FU),
				v.getSprite2Patch(i,SPR2_STND,false,A,
					3,0
				),
				V_SNAPTOBOTTOM,
				v.getColormap(i,skins[i].prefcolor)
			)		
		end
		v.drawScaled(146*FU,
			drawz,
			scale,
			v.getSpritePatch(SPR_BRAK,A,3,0),
			V_SNAPTOBOTTOM
		)
		v.drawString(115*FU,
			drawz-4*FU-FixedMul(dist,FixedDiv(scale,2*FU)),
			L_FixedDecimal(dist,3),
			V_SNAPTOBOTTOM,
			"thin-fixed"
		)
		*/
	end
	if (TAKIS_DEBUGFLAG & DEBUG_HURTMSG)
		for i = 0,#takis.hurtmsg
			local strings = prtable("i "..i,takis.hurtmsg[i],false)
			for k,va in ipairs(strings)
				v.drawString(100,(4*(k-1))+(16*i),va,V_ALLOWLOWERCASE,"small")
			end
		end
	end
	if (TAKIS_DEBUGFLAG & DEBUG_BOSSCARD)
		local bosscards = takis.HUD.bosscards
		
		local x,y = 10,60
		local flags = V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE
		if not (bosscards.mo and bosscards.mo.valid)
			v.drawString(x,y,"No boss",flags|V_REDMAP,"thin")
		else
			/*
				maxcards = 0,
				dontdrawcards = false,
				cards = 0,
				cardshake = 0,
				mo = 0,
				name = '',
				statusface = {
					priority = 0,
					state = "IDLE",
					frame = 0,
				},
			*/
			
			local hascard
			v.drawString(x,y,
				"mo: \x86"..tostring(bosscards.mo),
				flags,"thin"
			)		
			v.drawString(x,y+8,"type#: "..tonumber(bosscards.mo.type),flags,"thin")		
			v.drawString(x,y+16,bosscards.name or "No name",flags,"thin")		
			v.drawString(x,y+24,"HP: "..
				bosscards.mo.health.."/"..
				bosscards.maxcards..
				((bosscards.nocards or TAKIS_BOSSCARDS.nobosscards[bosscards.mo.type] ~= nil) and " (Not drawn)" or ''),
				flags|((bosscards.nocards or TAKIS_BOSSCARDS.nobosscards[bosscards.mo.type] ~= nil) and V_REDMAP or 0),"thin"
			)		
			v.drawString(x,y+32,"face: "..
				(TAKIS_BOSSCARDS.bossprefix[bosscards.mo.type] or "No face prefix"),
				flags,"thin"
			)		
			local strings = prtable("statusface",bosscards.statusface,false)
			for k,va in ipairs(strings)
				v.drawString(x,y+32+(k*8),va,flags,"thin")		
			end
		end
		flags = $|V_SNAPTORIGHT &~V_SNAPTOLEFT
		local strings = prtable("TAKIS_BOSSCARDS.nobosscards",TAKIS_BOSSCARDS.nobosscards,false)
		for k,va in ipairs(strings)
			v.drawString(300-x,y-8+(k*8),va,flags,"thin-right")		
		end
		
	end
	if (TAKIS_DEBUGFLAG & DEBUG_NET)
		local dex = 9
		local cv = {
			[1] = CV_TAKIS.nerfarma,
			[2] = CV_TAKIS.tauntkills,
			[3] = CV_TAKIS.achs,
			[4] = CV_TAKIS.collaterals,
			[5] = CV_TAKIS.heartcards,
			[6] = CV_TAKIS.hammerquake,
			[7] = CV_TAKIS.chaingun,
			[8] = CV_TAKIS.noeffects,
			[9] = CV_TAKIS.forcekart,
		}
		local net = {
			[1] = TAKIS_NET.nerfarma,
			[2] = TAKIS_NET.tauntkillsenabled,
			[3] = TAKIS_NET.noachs,
			[4] = TAKIS_NET.collaterals,
			[5] = TAKIS_NET.cards,
			[6] = TAKIS_NET.hammerquakes,
			[7] = TAKIS_NET.chaingun,
			[8] = TAKIS_NET.noeffects,
			[9] = TAKIS_NET.forcekart,
		}
		local name = {
			[1] = "Nerf arma",
			[2] = "Taunt kills",
			[3] = "Achs",
			[4] = "Collaterals",
			[5] = "Cards",
			[6] = "Hammer quakes",
			[7] = "Chaingun",
			[8] = "No effects",
			[9] = "Forcekart",
		}
		local boolclr = {
			[true] = "\x83",
			[false] = "\x85",
		}
		
		for i = 1,dex
			local bool = net[i]
			if i == 3 then
				bool = not $
			end
			local s1 = cv[i].value and " " or ''
			local s2 = bool and " " or ''
			local c1 = boolclr[cv[i].value == 1]
			local c2 = boolclr[bool]
			v.drawString(100,
				2+(i*8),
				"\x86".."CV: "..c1..string.lower(tostring(cv[i].string))..s1..
				"\x86 NET: "..c2..tostring(bool)..s2.."\x86 - \x80"..
				name[i],
				V_HUDTRANS|V_ALLOWLOWERCASE|V_MONOSPACE,
				"thin"
			)
			local ds = (cv[i].value == 1) ~= bool
			if ds
				v.drawString(100,
					2+(i*8),
					"Desynched!",
					V_HUDTRANS|V_ALLOWLOWERCASE|V_MONOSPACE|V_YELLOWMAP,
					"thin-right"
				)
			end
		end
		
		--other shit
		local bottom = 10+(dex*8)
		local n = TAKIS_NET
		local m = TAKIS_MISC
		v.drawString(100,bottom,
			"FC: "..(n.partdestroy).."/"..(n.numdestroyables).." things",
			V_HUDTRANS|V_ALLOWLOWERCASE,
			"thin"
		)
		v.drawString(100,bottom+8,
			"count: exit: "..m.exitingcount..", takis: "..m.takiscount..", other: "..m.playercount,
			V_HUDTRANS|V_ALLOWLOWERCASE,
			"thin"
		)
		v.drawString(100,bottom+16,
			"cardbump: "..L_FixedDecimal(m.cardbump,2),
			V_HUDTRANS|V_ALLOWLOWERCASE,
			"thin"
		)
		local ss = n.inspecialstage
		local bm = n.inbossmap
		local bk = n.inbrakmap
		local retro = n.isretro == TOL_MARIO
		drawflag(v,100,bottom+24,"spec",
			V_HUDTRANS|V_ALLOWLOWERCASE,
			V_GREENMAP,V_REDMAP,
			"thin",
			ss
		)
		drawflag(v,140,bottom+24,"boss",
			V_HUDTRANS|V_ALLOWLOWERCASE,
			V_GREENMAP,V_REDMAP,
			"thin",
			bm
		)
		drawflag(v,100,bottom+32,"brak",
			V_HUDTRANS|V_ALLOWLOWERCASE,
			V_GREENMAP,V_REDMAP,
			"thin",
			bk
		)
		drawflag(v,140,bottom+32,"retro",
			V_HUDTRANS|V_ALLOWLOWERCASE,
			V_GREENMAP,V_REDMAP,
			"thin",
			retro
		)
		
		v.drawString(100,bottom+40,
			"lifepool: "..m.livescount,
			V_HUDTRANS|V_ALLOWLOWERCASE,
			"thin"
		)
		
		local strings = prtable("SPIKE_LIST",SPIKE_LIST,false)
		for k,va in ipairs(strings)
			v.drawString(100,bottom+40+(8*k),
				va,
				V_HUDTRANS|V_ALLOWLOWERCASE,
				"thin"
			)
		end
		
	end
	if (TAKIS_DEBUGFLAG & DEBUG_MUSIC)
		local flags = V_SNAPTOLEFT|V_HUDTRANS
		v.drawString(5,
			92,
			musname or "null",
			flags,
			"left"
		)
		
		if not TAKIS_BEATMS[string.lower(musname or '')]
			flags = $|V_REDMAP
		end
		
		local leng = S_GetMusicLength()
		local pos = S_GetMusicPosition()
		local posstring = L_FixedDecimal(FixedDiv(pos,MUSICRATE),2).."/"..L_FixedDecimal(FixedDiv(leng,MUSICRATE),2)
		v.drawString(5,
			100,
			posstring,
			flags,
			"left"
		)
		local HAHA = 0
		if (leng ~= 0)
			local percent = L_FixedDecimal(FixedMul(FixedDiv(pos,leng),100*FU),2).."%"
			HAHA = v.stringWidth(percent.."==",0,normal)
			v.drawString(5,
				120,
				percent,
				flags,
				"left"
			)
			
			v.drawString(55,
				120,
				"beat "..TAKIS_MISC.lastbump,
				flags,
				"left"
			)
			
			local pre = "MINFOB_"
			local fill = v.cachePatch(pre.."FILL")
			local erm = FixedDiv(pos,leng)
			local width = FixedMul(erm,fill.width*FU)
			if width < 0 then
				width = 0
			end
			
			v.drawScaled(5*FU,110*FU,FU,fill,flags,v.getColormap(nil,SKINCOLOR_BLACK))
			v.drawCropped(5*FU,110*FU,FU,FU,
				fill,
				flags, 
				nil,
				0,0,
				width,fill.height*FU
			)
		end
	
	end
	--debug end
end

--draw the stuff
--customhud.SetupItem("takis_wareffect", 		modname/*,	,	"game",	1*/)
customhud.SetupItem("takis_clutchstuff",	modname/*,	,	"game",	23*/) --
customhud.SetupItem("takis_combometer", 	modname/*,	,	"game",	27*/) 
customhud.SetupItem("takis_heartcards", 	modname/*,	,	"game",	30*/) --
customhud.SetupItem("takis_bosscards", 		modname)
customhud.SetupItem("takis_statusface", 	modname/*,	,	"game",	31*/) --
customhud.SetupItem("takis_c3jumpscare", 	modname/*,	,	"game",	31*/) --
customhud.SetupItem("takis_tauntmenu", 		modname/*,	,	"game",	31*/) --
customhud.SetupItem("takis_cosmenu", 		modname/*,	,	"game",	31*/) --
customhud.SetupItem("takis_cfgnotifs", 		modname/*,	,	"game",	10*/)
customhud.SetupItem("takis_bonuses", 		modname/*,	,	"game",	10*/)
customhud.SetupItem("takis_crosshair", 		modname/*,	,	"game",	10*/)
customhud.SetupItem("takis_happyhourtime", 	modname/*,	,	"game",	10*/)
customhud.SetupItem("textspectator", 		modname/*,	,	"game",	10*/)
customhud.SetupItem("takis_nadocount",	 	modname/*,	,	"game",	10*/)
customhud.SetupItem("takis_tutbuttons",	 	modname/*,	,	"game",	10*/)
customhud.SetupItem("takis_transfotimer", 	modname/*,	,	"game",	10*/)
customhud.SetupItem("takis_kart_driftmeter",modname/*,	,	"game",	10*/)
customhud.SetupItem("takis_kart_meters",	modname/*,	,	"game",	10*/)
customhud.SetupItem("takis_racelaps",		modname/*,	,	"game",	10*/)
customhud.SetupItem("takis_viewmodel",		modname/*,	,	"game",	10*/)
local altmodname = "vanilla"
local istakisrn = false
local wastakis = false
local gamewastakis = false
addHook("PostThinkFrame",do
	local player = displayplayer
	if not (player and player.valid)
		return
	end
	if not player.takistable
		return
	end
	wastakis = istakisrn
	if player.takistable.isTakis
		istakisrn = true
		wastakis = true
	else
		istakisrn = false
	end
end)
addHook("HUD", function(v,p,cam)
	if not p
	or not p.valid
	or PSO
		return
	end
	
	if not p.takistable
		return
	end
	
	/*
	if p.takistable.inNIGHTSMode
	or (TAKIS_NET.inspecialstage)
		return
	end
	*/
	
	local takis = p.takistable
	local me = p.mo
	
	if takis
		drawhappytime(v,p)
		if takis.isTakis
			
			--haha FUNNY DRRR elemt
			--THIS GAME IS SHIT
			if (p.deadtimer
			and (takis.deathfunny))
				local thok = v.getSpritePatch(SPR_THOK,0,0)
				local scale = FU*20
				local deadtimer = takis.deadtimer
				if deadtimer > 0
					if deadtimer > TR
						scale = 0
					else
						scale = ease.linear((FU/(TR))*deadtimer,20*FU,0)
					end
				end
				scale = max(0,scale)
				v.drawScaled(160*FU,100*FU+(thok.height*scale/2),scale,
					thok,
					V_SUBTRACT,
					v.getColormap(nil,p.skincolor)
				)
			end
			
			gamewastakis = true
			--wastakis = true
			local opmode = (me and me.valid and me.state == S_OBJPLACE_DUMMY) or false
			
			--customhud.SetupItem("takis_wareffect", 		modname)
			customhud.SetupItem("takis_clutchstuff",	modname)
			if opmode
				customhud.SetupItem("rings", 			altmodname) 
				customhud.SetupItem("time", 			altmodname) 
				customhud.SetupItem("score", 			altmodname) 
			else
				customhud.SetupItem("rings", 			modname) 
				customhud.SetupItem("time", 			modname) 
				customhud.SetupItem("score", 			modname) 
			end
			customhud.SetupItem("lives", 				modname)
			customhud.SetupItem("takis_combometer", 	modname) 
			customhud.SetupItem("takis_heartcards", 	modname)
			customhud.SetupItem("takis_bosscards", 		modname)
			customhud.SetupItem("takis_statusface", 	modname)
			customhud.SetupItem("takis_c3jumpscare", 	modname)
			customhud.SetupItem("takis_tauntmenu", 		modname)
			customhud.SetupItem("takis_cfgnotifs", 		modname)
			customhud.SetupItem("takis_bonuses", 		modname)
			customhud.SetupItem("takis_crosshair", 		modname)
			customhud.SetupItem("takis_happyhourtime", 	modname)
			customhud.SetupItem("textspectator", 		modname)
			customhud.SetupItem("takis_nadocount", 		modname)
			customhud.SetupItem("takis_tutbuttons", 	modname)
			customhud.SetupItem("takis_transfotimer", 	modname)
			customhud.SetupItem("bossmeter",			modname)
			customhud.SetupItem("takis_kart_driftmeter",modname)
			customhud.SetupItem("takis_kart_meters",	modname)
			customhud.SetupItem("takis_racelaps",		modname)
			customhud.SetupItem("takis_viewmodel",		modname)
			if takis.transfo & TRANSFO_SHOTGUN
				customhud.SetupItem("crosshair",		modname)
			else
				customhud.SetupItem("crosshair",		altmodname)
			end
			
			if takis.io.nohappyhour == 0
				customhud.SetupItem("PTSR_itspizzatime",modname)
				customhud.SetupItem("PTSR_bar",modname)
				customhud.SetupItem("PTSR_tooltips",modname)
			elseif takis.io.nohappyhour == 1
				customhud.SetupItem("PTSR_itspizzatime","spicerunners")
				customhud.SetupItem("PTSR_bar","spicerunners")
				customhud.SetupItem("PTSR_tooltips","spicerunners")
			end
			customhud.SetupItem("PTSR_rank", modname)
			--customhud.SetupItem("PTSR_combo", modname)
			customhud.SetupItem("PTSR_lap", modname)
			--customhud.SetupItem("rank", modname)
			
			if p.takis
			and p.takis.shotgunnotif
				local waveforce = FU/10
				local ay = FixedMul(waveforce,sin(leveltime*ANG2))
				v.drawScaled(160*FU,65*FU,FU+ay,v.cachePatch("SPIKEYBOX"),0)
				local draw = true
				if p.takis.shotgunnotif >= 5*TR
					if not (p.takis.shotgunnotif % 2)
						draw = false
					end
				elseif p.takis.shotgunnotif <= TR
					if not (p.takis.shotgunnotif % 2)
						draw = false
					end				
				end
				
				if draw
					v.drawString(160,55,"\x85Something's new in",V_ALLOWLOWERCASE,"thin-center")
					v.drawString(160,65,"\x89Ultimate Mode\x85!",V_ALLOWLOWERCASE,"thin-center")
					v.drawString(160,75,"C3 - What's up?",V_ALLOWLOWERCASE,"thin-center")
				end
				
			end
			
			local hasstat = CV_FindVar("perfstats").value
			local mm = gametype == GT_MURDERMYSTERY
			
			drawviewmodel(v,p,cam)
			drawclutches(v,p,cam)
			drawnadocount(v,p,cam)
			drawtransfotimer(v,p,cam)
			drawdriftmeter(v,p,cam)
			
			drawfallout(v,p)
			--drawwareffect(v,p)
			--drawbubbles(v,p,cam)
			if not (hasstat or mm)
				drawrings(v,p)
				drawtimer(v,p)
			end
			drawkartmeters(v,p)
			if not mm
				drawlivesarea(v,p)
			end
			drawracelaps(v,p)
			drawlapanim(v,p)
			if not (opmode or mm)
				drawcombostuff(v,p,cam)
			end
			drawpizzatips(v,p)
			drawpizzatimer(v,p)
			--drawnickranks(v,p)
			
			if takis.nadotuttic
				local trans = 0
				
				if takis.nadotuttic >= 5*TR-9
					trans = (takis.nadotuttic-(5*TR-9))<<V_ALPHASHIFT
				elseif takis.nadotuttic < 10
					trans = (10-takis.nadotuttic)<<V_ALPHASHIFT
				end
				local waveforce = FU/10
				local ay = FixedMul(waveforce,sin(leveltime*ANG2))
				v.drawScaled(160*FU,65*FU,FU+ay,v.cachePatch("SPIKEYBOX"),trans)
				v.drawString(160,55,"\x82Tornado Transfo!",V_ALLOWLOWERCASE|trans,"thin-center")
				v.drawString(160,65,"Spin to go faster!",V_ALLOWLOWERCASE|trans,"thin-center")
				v.drawString(160,75,"C3 - Whatever",V_ALLOWLOWERCASE|trans,"thin-center")
				
			end
			
			drawcfgnotifs(v,p)
			drawtutbuttons(v,p)
			if not (hasstat or mm)
				drawscore(v,p)
			end
			drawbosstitles(v,p)
			if not (hasstat or opmode or mm)
				drawheartcards(v,p)
				drawbosscards(v,p)
				drawface(v,p)
				drawbossface(v,p)
				drawpizzaranks(v,p)
				drawbonuses(v,p)
			end
			drawcrosshair(v,p)
			drawtauntmenu(v,p)
			if (takis.cosmenu.menuinaction)
				drawcosmenu(v,p)
			end
			drawhappyhour(v,p)
			
			--record attack stuff
			if (modeattacking)
			and (p.powers[pw_carry] ~= CR_NIGHTSMODE)
				if (leveltime <= 5*TR)
					local tween = 0
					local et = TR/2
					local trans = 0
					local trans2 = V_50TRANS
					if leveltime <= et
						trans = ((18-leveltime)/2)<<V_ALPHASHIFT
						--trans2 = ((9-leveltime)/4)<<V_ALPHASHIFT
						tween = ease.outexpo((FU/et)*(leveltime),200*FU, 0)				
					elseif leveltime >= 4*TR+et
						local tics = leveltime-(4*TR+et)
						trans = (tics/2)<<V_ALPHASHIFT
						--trans2 = (tics/4)<<V_ALPHASHIFT
						tween = ease.inexpo((FU/et)*tics,0,200*FU)				
					end
					
					local happytime = CV_TAKIS.happytime.value
					local fs = takis.HUD.flyingscore
					local x = fs.scorex*FU+tween
					local y = (fs.scorey+22)*FU
					local constext = true
					local hhtext = "takis_happyhour"
					if (TAKIS_MISC.inescapable[string.lower(G_BuildMapTitle(gamemap) or '')] == true)
						happytime = 0
						constext = false
						hhtext = "Inescapable map"
					end
					local frame = happytime and ((5*leveltime/6)%14) or 0
					local patch = v.cachePatch("TAHHS"..frame)
					
					v.drawScaled(x,
						y-9*FU,
						FU,
						v.cachePatch("TA_HH_BOX"),
						trans2|V_SNAPTORIGHT|V_SNAPTOTOP
					)
					v.drawString(x,
						y+10*FU,
						hhtext,
						V_ALLOWLOWERCASE|V_GRAYMAP|trans|V_SNAPTORIGHT|V_SNAPTOTOP,
						"thin-fixed-right"
					)
					if constext
						v.drawString(x,
							y+18*FU,
							"Change in cons.",
							V_ALLOWLOWERCASE|trans|V_SNAPTORIGHT|V_SNAPTOTOP,
							"thin-fixed-right"
						)
					end
					v.drawString(x-50*FU,
						y-4*FU,
						happytime and "ON" or "OFF",
						V_YELLOWMAP|trans|V_SNAPTORIGHT|V_SNAPTOTOP,
						"fixed"
					)
					v.drawScaled(x-(v.stringWidth("takis_happyhour",0,"thin")*FU),
						y-7*FU,
						FU/2,
						patch,
						trans|V_SNAPTORIGHT|V_SNAPTOTOP
					)
				end
				
				if takis.HUD.rthh.tics
					local time = takis.HUD.rthh.time
					local min = G_TicsToMinutes(time,true)
					local sec = G_TicsToSeconds(time)
					local cen = G_TicsToCentiseconds(time)
					local tstring = tostring(min)..":"..(sec < 10 and "0" or '')..tostring(sec).."."..(cen < 10 and "0" or '')..tostring(cen)
					
					local x = 130*FU
					local y = 150*FU
					
					local waveforce = FU*3
					local ay = FixedMul(waveforce,sin (FixedAngle(leveltime*20*FU)))
					
					local cpatch = v.cachePatch("TAKCOSHARE")
					local color = v.getColormap(nil,
						(leveltime/2 % 2) and SKINCOLOR_GREEN
						or SKINCOLOR_RED
					)
					local xoff = -7*FU
					v.drawScaled(x+8*FU-xoff,y+ay,FU,cpatch,0,color)
					v.drawString(x+8*FU-xoff,y+ay,tstring,V_YELLOWMAP,"fixed-right")
				
				end
			end
			
			if (takis.shotguntuttic)
				local string = ''
				if (takis.tossflag)
					local dec = L_FixedDecimal(
						FixedMul(
							FixedDiv(takis.tossflag*FU,
								17*FU
							),
							100*FU
						),
						1
					)
					string = "("..dec.."%) "
				end
				
				v.drawString(160,200-25,string.."\x82TOSSFLAG\x80: Shotgun Tutorial",
					V_ALLOWLOWERCASE|V_HUDTRANS|V_SNAPTOBOTTOM,
					"thin-center"
				)
			end
			
			--i fucking love this ....
			local lowercase = {
				["o"] = true,
				["u"] = true,
				["v"] = true,
				["e"] = true,
				["h"] = true,
				["u"] = true,
				["r"] = true,
				["t"] = true,
				["a"] = true,
				["k"] = true,
				["i"] = true,
				["s"] = true,
				["m"] = true,
			}
			
			if takis.HUD.timeshit
				local x,y = 160,170
				local trans = 0
				if takis.HUD.timeshit > (5*TR)
					trans = (takis.HUD.timeshit-5*TR)<<V_ALPHASHIFT
				elseif takis.HUD.timeshit < 10
					trans = (10-takis.HUD.timeshit)<<V_ALPHASHIFT
				end
				
				--buggie's tf2 engi code
				local scorenum = "SCREFT"
				local score = "You've hurt Takis "..takis.totalshit.." times..."
				
				local width = 0
				for i = 1,string.len(score)
					local n = string.sub(score,i,i)
					if lowercase[n] ~= nil
						n = $.."TH"
					end
					n = n:upper()
					width = $+v.cachePatch(scorenum+n).width*4/10
				end
				width = $/2
				
				
				local prevw
				if not prevw then prevw = 0 end
				
				for i = 1,string.len(score)
					local n = string.sub(score,i,i)
					if n == " "
						prevw = $+v.cachePatch(scorenum..n).width*4/10
						continue
					end
					if lowercase[n] ~= nil
						n = $.."TH"
					end
					n = n:upper()
					
					local xshake,yshake = happyshakelol(v)
					xshake,yshake = $1/2,$2/2
					v.drawScaled((x+prevw)*FU+xshake-(width*FU),
						y*FU+yshake,
						FU/2,
						v.cachePatch(scorenum..n),
						trans|V_SNAPTOBOTTOM
					)
						
					prevw = $+v.cachePatch(scorenum+n).width*4/10
				end
	
			end
			
		--not takis lol
		else
			if takis.io.morehappyhour == 0
			and (not takis.otherskin
			or takis.otherskintime == 1)
				customhud.SetupItem("PTSR_itspizzatime","spicerunners")
			else
				customhud.SetupItem("PTSR_itspizzatime",modname)
			end
			drawhappyhour(v,p)
			
			if not takis.otherskin
			or takis.otherskintime == 1
			or (wastakis or gamewastakis)
				customhud.SetupItem("rings",			altmodname)
				if not (HAPPY_HOUR.othergt)
					customhud.SetupItem("time",			altmodname)
					customhud.SetupItem("score",		altmodname)
				else
					customhud.SetupItem("time",			"spicerunners")
					customhud.SetupItem("score",		"spicerunners")			
				end
				customhud.SetupItem("lives",			altmodname)
				customhud.SetupItem("PTSR_bar",			"spicerunners")
				customhud.SetupItem("PTSR_tooltips",	"spicerunners")
				customhud.SetupItem("PTSR_rank", 		"spicerunners")
				--customhud.SetupItem("PTSR_combo", 		"spicerunners")
				customhud.SetupItem("PTSR_lap", 		"spicerunners")
				customhud.SetupItem("textspectator",	altmodname)
				customhud.SetupItem("crosshair",		altmodname)
			end
			gamewastakis = false
			--wastakis = false
			--customhud.SetupItem("rank", "pizzatime2.0")
			
			--elfilin stuff
			/*
			if ((me) and (me.valid))
			and (me.skin == "elfilin")
			and (p.elfilin)
				--check out my sweet new ride!
				local ride = p.elfilin.ridingplayer
				
				if p.elfilin
				and ((ride) and (ride.valid))

					local p2 = ride.player
					local takis2 = p2.takistable
					
					if ride.skin == TAKIS_SKIN
						
						if takis2.io.nohappyhour == 0
						and takis.io.morehappyhour == 0
							customhud.SetupItem("PTSR_itspizzatime",modname)
							drawhappyhour(v,p2)
						end
						
						
						local workx = (265*FU)-(35*FU)
						
						--draw p2's heartcards
						for i = 1, TAKIS_MAX_HEARTCARDS
							local patch = v.cachePatch("HEARTCARD2")
							
							if takis2.heartcards >= i
								patch = v.cachePatch("HEARTCARD1")
							end
							
							v.drawScaled(
								workx,
								100*FU,
								FU/2,
								patch,
								V_SNAPTOTOP|V_SNAPTORIGHT|V_PERPLAYER
							)
							
							workx = $+(12*FU)
							
						end
					
						
						--show p2's combo
						drawcombostuff(v,p2)
						
					end
					
				end
				
			end
			*/
			
			if takis.cosmenu.menuinaction
				drawcosmenu(v,p)
			end
		end
		drawjumpscarelol(v,p)
		--prtable("steam",takis.HUD.steam)
		for k,va in ipairs(takis.HUD.steam)
			if va == nil
				continue
			end
			
			local enum = va.enum
			local bottom = 16*FU
			local trans = 0
			local yadd = 28*FU*(k-1)
			yadd = -$
			if va.tics < 10
				trans = (10-va.tics)<<V_ALPHASHIFT
			end
			
			local t = TAKIS_ACHIEVEMENTINFO
			local x = va.xadd
			
			v.drawScaled(178*FU+x,172*FU+yadd,FU,
				v.cachePatch("ACH_BOX"),
				trans|V_SNAPTORIGHT|V_SNAPTOBOTTOM
			)
			v.drawScaled((300*FU)-118*FU+x,(200*FU)-bottom-(8*FU)+yadd,
				t[enum].scale or FU,
				v.cachePatch(t[enum].icon),
				trans|V_SNAPTORIGHT|V_SNAPTOBOTTOM
			)
			v.drawString((300*FU)-100*FU+x,
				(200*FU)-bottom-(8*FU)+yadd,
				t[enum].name or "Ach. Enum "..enum,
				trans|V_SNAPTORIGHT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE|V_RETURN8,
				"thin-fixed"
			)
			v.drawString((300*FU)-100*FU+x,
				(200*FU)-bottom+yadd,
				t[enum].text or "Flavor text goes here",
				trans|V_SNAPTORIGHT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE|V_RETURN8,
				"small-fixed"
			)
			
		end
		
		if takis.HUD.menutext.tics
			local trans = 0
			if takis.HUD.menutext.tics > (3*TR)
				trans = (takis.HUD.menutext.tics-3*TR)<<V_ALPHASHIFT
			elseif takis.HUD.menutext.tics < 10
				trans = (10-takis.HUD.menutext.tics)<<V_ALPHASHIFT
			end
			
			v.drawString(160,200-16,"\x86".."FN+C3+C2 (hold)\x80 - Open Menu",trans|V_ALLOWLOWERCASE|V_SNAPTOBOTTOM,"thin-center")
			v.drawString(160,200-8,"\x86takis_openmenu\x80 - Open Menu",trans|V_ALLOWLOWERCASE|V_SNAPTOBOTTOM,"thin-center")
		end
	
		drawdebug(v,p)
		
		if (me and me.valid)
		and (me.spbtarg and me.spbtarg.valid)
			local spb = me.spbtarg
			local patch,flip = v.getSprite2Patch(TAKIS_SKIN,
				spb.sprite2,
				false,
				spb.frame,
				1,
				0
			)
			
			v.drawScaled(290*FU,
				170*FU+(spb.spriteyoffset/2),
				FU/2,
				patch,
				V_SNAPTORIGHT|V_SNAPTOBOTTOM,
				v.getColormap(nil,spb.color)
			)
			
		end
		
	end
end)

addHook("HUD", function(v)
	if (TAKIS_DEBUGFLAG & DEBUG_SPEEDOMETER)
		v.drawString(0,0,
			"funny: "..L_FixedDecimal(
				FixedMul(
					FixedDiv(TAKIS_TITLETIME,120*TR),
					100*FU
				),
				1
			).."%",
			V_SNAPTOLEFT|V_SNAPTOTOP,
			"left"
		)
	end
	
	if TAKIS_TITLEFUNNY
		v.fadeScreen(35,10)
		
		TAKIS_TITLEFUNNYY = $*3/4
		
		local scale = FU*7/5
		local p = v.cachePatch("BALL_BUSTER")
		
		local x = v.RandomFixed()*3
		if ((TAKIS_TITLETIME%4) < 3)
			x = -$
		end
		
		v.drawScaled((160*FU)+x,TAKIS_TITLEFUNNYY,scale,p,0)	
	else
		if (TAKIS_TITLETIME >= 60*TR)
			local erm = FixedDiv((TAKIS_TITLETIME-60*TR)*FU or 1,60*TR*FU)
			local mul = FixedMul(erm,10*FU)
			
			mul = $/FU
			v.fadeScreen(35,mul)
		end
	end
end,"title")

local emeraldslist = {
	[0] = SKINCOLOR_GREEN,
	[1] = SKINCOLOR_SIBERITE,
	[2] = SKINCOLOR_SAPPHIRE,
	[3] = SKINCOLOR_SKY,
	[4] = SKINCOLOR_TOPAZ,
	[5] = SKINCOLOR_FLAME,
	[6] = SKINCOLOR_SLATE,
}

addHook("HUD", function(v)
	if consoleplayer
	and consoleplayer.takistable
		local p = consoleplayer
		local takis = p.takistable
		if takis.isTakis
			customhud.SetupItem("coopemeralds",modname)
			
			if G_CoopGametype()
			or (gametyperules & GTR_CAMPAIGN)
			and customhud.CheckType("coopemeralds") == modname
				if not multiplayer
					local maxspirits = 6
					local maxspace = 200
					for i = 0,maxspirits
						local patch,flip = v.getSpritePatch(SPR_TSPR,
							TakisFetchSpiritFrame(i,(emeralds & 1<<i ~= 0)),
							(((leveltime/4)+i)%8)+1
						)
						v.drawScaled(
							60*FU+FixedDiv(maxspace*FU,maxspirits*FU)*i,
							120*FU,
							FU,
							patch,
							((flip) and V_FLIP or 0)|((emeralds & 1<<i == 0) and V_50TRANS or 0),
							v.getColormap(nil,emeraldslist[i])
						)
					end
				--mp display
				else
					local maxspirits = 6
					local maxspace = 66
					for i = 0,maxspirits
						local patch,flip = v.getSpritePatch(SPR_TSPR,
							TakisFetchSpiritFrame(i,(emeralds & 1<<i ~= 0)),
							(((leveltime/4)+i)%8)+1
						)
						v.drawScaled(
							20*FU+FixedDiv(maxspace*FU,maxspirits*FU)*i,
							18*FU,
							FU/4,
							patch,
							((flip) and V_FLIP or 0)|((emeralds & 1<<i == 0) and V_50TRANS or 0),
							v.getColormap(nil,emeraldslist[i])
						)
					end			
				end
			end
			
			local flash,timetic,extratext,extrafunc,type = howtotimer(p)
			
			if (type == "regular"
			and (gametyperules & GTR_CAMPAIGN))
			and not modeattacking
			and (takis.io.minhud == 0)
			and (customhud.CheckType("time") == modname)
				drawtimer(v,p,true)
			end
			
			--drawfallout(v,p,true)
			
		else
			--game hud doesnt run while this is in action so set this here
			if not takis.otherskin
			or takis.otherskintime == 1
			or wastakis
				customhud.SetupItem("coopemeralds",altmodname)
			end
		end
		
		drawjumpscarelol(v,p)
	end
end,"scores")

addHook("HUD", function(v,p,tic,endtic)
	if tic >= endtic then return end
	
	if not (p.takistable) then return end
	local takis = p.takistable
	
	if (skins[p.skin].name == TAKIS_SKIN)
		if (mapheaderinfo[gamemap].bonustype == 1)
			if p.takistable.HUD.bosscards.name == ''
				customhud.SetupItem("stagetitle",	altmodname)
				return
			end
		else
			if (p.starpostnum ~= TAKIS_MISC.maxpostcount+32)
				customhud.SetupItem("stagetitle",	altmodname)
				return
			end
		end
		
		customhud.SetupItem("stagetitle", 		modname)
	else
		if not takis.otherskin
		or takis.otherskintime == 1
		or wastakis
			customhud.SetupItem("stagetitle",	altmodname)
		end
	end
end,"titlecard")

addHook("HUD", function(v)
	if consoleplayer
	and consoleplayer.takistable
		local p = consoleplayer
		local takis = p.takistable
		
		if skins[consoleplayer.skin].name == TAKIS_SKIN
			customhud.SetupItem("intermissiontitletext",altmodname)
			if takis.lastss
				if not TAKIS_MISC.stagefailed
					customhud.SetupItem("intermissiontitletext",modname)
					
					local string2 = (All7Emeralds(emeralds)) and "Got them all!" or "Got a Spirit!"
					if string.lower(G_BuildMapTitle(takis.lastmap)) == "black hole zone"
						string2 = "Got nothing LMAO"
					end
					v.drawLevelTitle(160-(v.levelTitleWidth(string2)/2),
						46,
						string2,
						0
					)
				end
				customhud.SetupItem("intermissionemeralds",	modname)
				local maxspirits = 6
				local maxspace = 200
				
				local em = takis.lastemeralds
				if TAKIS_MISC.inttic >= TR then em = emeralds end
				
				for i = 0,maxspirits
					local patch,flip = v.getSpritePatch(SPR_TSPR,
						TakisFetchSpiritFrame(i,(em & 1<<i ~= 0)),
						(((TAKIS_MISC.inttic/4)+i)%8)+1
					)
					v.drawScaled(
						60*FU+FixedDiv(maxspace*FU,maxspirits*FU)*i,
						104*FU,
						FU,
						patch,
						((flip) and V_FLIP or 0)|((em & 1<<i == 0) and V_50TRANS or 0),
						v.getColormap(nil,emeraldslist[i])
					)
				end
				
				--tween
				if TAKIS_MISC.inttic < TR
					local expectedtime = TR
					for i = 0,maxspirits
						--we didnt even get this one
						if (emeralds & 1<<i == 0) then continue end
						--we already have it
						if (em & 1<<i) then continue end
						
						local patch,flip = v.getSpritePatch(SPR_TSPR,
							TakisFetchSpiritFrame(i,true),
							(((TAKIS_MISC.inttic/4)+i)%8)+1
						)
						
						local tweenx = ease.outexpo(( FU / expectedtime )*(TAKIS_MISC.inttic),160*FU, 60*FU+FixedDiv(maxspace*FU,maxspirits*FU)*i)
						local tweeny = ease.outexpo(( FU / expectedtime )*(TAKIS_MISC.inttic),-300*FU, 104*FU)
						
						v.drawScaled(
							tweenx,
							tweeny,
							FU,
							patch,
							((flip) and V_FLIP or 0),
							v.getColormap(nil,emeraldslist[i])
						)
					end
				end
				
			end
		else
			if not takis.otherskin
			or takis.otherskintime == 1
			or wastakis
				customhud.SetupItem("intermissionemeralds",	altmodname)
				customhud.SetupItem("intermissiontitletext",altmodname)
			end
		end
	end
end,"intermission")

filesdone = $+1
