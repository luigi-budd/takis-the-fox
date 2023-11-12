if not (rawget(_G, "customhud")) return end
local modname = "takisthefox"

--HEALTH----------

local function drawheartcards(v,p)

	if (customhud.CheckType("takis_heartcards") != modname) return end
	
	local amiinsrbz = false
	
	if (gametype == GT_SRBZ)
		if (not p.chosecharacter)
		or p.shop_open
			amiinsrbz = true
		end
	end
	
	if p.takistable.inNIGHTSMode
	or (TAKIS_NET.inspecialstage)
	or amiinsrbz
		return
	end
	
	local xoff = 20*FU
	local takis = p.takistable
	local halfwidth = (v.width()*FU)/4
	
	local maxx = (15*FU)*TAKIS_MAX_HEARTCARDS
	if TAKIS_MAX_HEARTCARDS > 6
		maxx = $-((TAKIS_MAX_HEARTCARDS-6)*FU)
		xoff = $-((FU)*(TAKIS_MAX_HEARTCARDS-6))
	elseif TAKIS_MAX_HEARTCARDS < 6
		xoff = $+((FU*2)*(TAKIS_MAX_HEARTCARDS))
	end
	
	//heart cards
	for i = 1, TAKIS_MAX_HEARTCARDS do
		
		local j = i
		if (TAKIS_MAX_HEARTCARDS == 1)
			j = 0
		end
		
		local eflag = V_HUDTRANS
		
		local patch = v.cachePatch("HEARTCARD1")
		if ultimatemode
			patch = v.cachePatch("HEARTCARD3")
		end
		
		if TAKIS_MAX_HEARTCARDS-i > takis.heartcards-1
		or p.spectator
			patch = v.cachePatch("HEARTCARD2")
			if p.spectator
				eflag = V_HUDTRANSHALF
			end
		end				
		local add = -3*FU
				
		if (i%2)
			add = 3*FU
		end
		
		if TAKIS_MAX_HEARTCARDS == 1
			add = 0
		end
		
		local shakex,shakey = 0,0
				
		if takis.HUD.heartcards.shake
		and not (paused)
		and not (menuactive and takis.isSinglePlayer)
			
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

		local flags = V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|eflag
		//draw from last to first
		v.drawScaled(maxx-((13*FU)*j)+xoff+shakex,15*FU+add-takis.HUD.heartcards.add+shakey,4*FU/5, patch, flags)
		local x = maxx-((13*FU)*j)+xoff+FixedMul(patch.width*FU,4*FU/5)
		v.drawFill(x,15*FU+FixedMul(patch.height*FU,4*FU/5),
			3,3,
			3|flags
		)
		print("iteration "..i,
			x
			>= halfwidth
		)
		print(L_FixedDecimal(x,3))
		print(L_FixedDecimal(halfwidth,3))
	end

	//heal indc.
	if takis.heartcards ~= TAKIS_MAX_HEARTCARDS
	and not (takis.fakeexiting)
		v.drawString((maxx/FU)+10+(xoff/FU),15+4,takis.heartcardpieces,V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER,"thin")
		v.drawString((maxx/FU)+10+4+(xoff/FU),15+4+4,"/",V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER,"thin")
		v.drawString((maxx/FU)+10+7+(xoff/FU),15+8+3-2+4,"7",V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER,"thin")
		v.drawScaled(maxx+(10*FU)+(25*FU)+xoff, 33*FU, FU/2,v.getSpritePatch("RING", A, 0, 0), V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER)
	end
	
end

--      ----------

--FACE  ----------

//referencing doom's status face code
// https://github.com/id-Software/DOOM/blob/77735c3ff0772609e9c8d29e3ce2ab42ff54d20b/linuxdoom-1.10/st_stuff.c#L752
local function calcstatusface(p,takis)
	local me = p.mo
	
	//idle
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
	
	if takis.HUD.statusface.priority < 10
		
		//dead
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
		
		//pain
		if ((takis.inPain or takis.inFakePain)
		or (takis.ticsforpain)
		or (me.sprite2 == SPR2_PAIN)
		or (me.state == S_PLAY_PAIN)
		or (takis.HUD.statusface.painfacetic))
		and (not takis.resettingtoslide)
		and (me.sprite2 ~= SPR2_SLID)
			takis.HUD.statusface.state = "PAIN"
			takis.HUD.statusface.frame = (leveltime%4)/2
			takis.HUD.statusface.priority = 8
		end
		
	end
	
	
	if takis.HUD.statusface.priority < 8
		
		//evil grin when killing someone
		//or a boss
		if takis.HUD.statusface.evilgrintic
			takis.HUD.statusface.state = "EVL_"
			takis.HUD.statusface.frame = (leveltime/4)%2
			takis.HUD.statusface.priority = 7
		end
		
	end
	
	if takis.HUD.statusface.priority < 7
		
		//happy face
		if takis.HUD.statusface.happyfacetic
		or takis.tauntid == 2
			takis.HUD.statusface.state = "HAPY"
			takis.HUD.statusface.frame = (leveltime/2)%2
			takis.HUD.statusface.priority = 6		
		end
		
	end
	
	
	if takis.HUD.statusface.priority < 6
		
		//doom's godmode face
		if (p.pflags & PF_GODMODE)
			takis.HUD.statusface.state = "GOD_"
			takis.HUD.statusface.priority = 5
		end
		
	end
	
	if takis.HUD.statusface.priority < 2
	
		//space drown
		if ((P_InSpaceSector(me)) and (p.powers[pw_spacetime]))
		or ((p.powers[pw_underwater]) and (p.powers[pw_underwater] <= 11*TR))
			takis.HUD.statusface.state = "SDWN"
			takis.HUD.statusface.frame = (leveltime)%2
			takis.HUD.statusface.priority = 1
		end
		
	end
	
	//isnt this just so retro?
	//god, if only i lived in retroville
	if TAKIS_NET.isretro
		takis.HUD.statusface.frame = 0
	end
	
	return takis.HUD.statusface.state, takis.HUD.statusface.frame
end

local function drawface(v,p)

	if (customhud.CheckType("takis_statusface") != modname) return end

	local amiinsrbz = false
	
	if (gametype == GT_SRBZ)
		if (not p.chosecharacter)
		or p.shop_open
			amiinsrbz = true
		end
	end
	
	if p.takistable.inNIGHTSMode
	or (TAKIS_NET.inspecialstage)
	or amiinsrbz

		return
	end

	local takis = p.takistable
	local me = p.mo
	
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
	local headpatch = v.cachePatch(pre..healthstate..tostring(healthframe))
	
	local y = 0
	local expectedtime = TR
	
	if ( ((JISK_PIZZATIMETICS) and (JISK_PIZZATIMETICS <= 3*TR))
	or ((PTJE) and (PTJE.pizzatime_tics) and (PTJE.pizzatime_tics <= 3*TR)) )
	and (takis.io.nohappyhour == 0)
		local tics = JISK_PIZZATIMETICS or PTJE.pizzatime_tics
		
		if (tics < 2*TR)
			y = ease.inquad(( FU / expectedtime )*tics, 0, -60*FU)
		else
			y = ease.outquad(( FU / expectedtime )*(tics-(2*TR)), -60*FU, 0)
		end
	end
	
	v.drawScaled(20*FU+x,27*FU+y+y2,scale, headpatch, V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|eflags,v.getColormap(nil,headcolor))

end

--      ----------

--RINGS ----------

local function drawrings(v,p)

	if (customhud.CheckType("rings") != modname) return end

	if p.takistable.inNIGHTSMode
	or (TAKIS_NET.inspecialstage)
	or p.takistable.inSRBZ
		return
	end

	local ringpatch = "RING"
	
	local takis = p.takistable
	
	local flash = false
	
	if p.rings == 0
	and takis.heartcards <= 0
		flash = true
	end
			
	local ringFx,ringFy = unpack(takis.HUD.rings.FIXED)
	local ringx,ringy = unpack(takis.HUD.rings.int)
	flash = (flash and ((leveltime%(2*TR)) < 30*TR) and (leveltime/5 & 1))

	if flash
		ringpatch = "TRNG"
	end
	
	local val = p.rings
	v.drawScaled(ringFx, ringFy, FU/2,v.getSpritePatch(ringpatch, A, 0, 0), V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER,v.getColormap(nil,SKINCOLOR_RED))
	v.drawNum(ringx, ringy, val, V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER)
	
end

--      ----------

--TIMER ----------

//this is so minhud
// https://mb.srb2.org/addons/minhud.2927/
local function howtotimer(player)
	local flash, tics = false
	
	local pt, lt = player.realtime, leveltime
	local puretlimit, purehlimit = CV_FindVar("timelimit").value, CV_FindVar("hidetime").value
	local tlimit = puretlimit * 60 * TR
	local hlimit = purehlimit * TR
	local extratext = ''
	local extrafunc = ''
	
	-- Counting down the hidetime?
	if (gametyperules & GTR_STARTCOUNTDOWN)
	and (pt <= hlimit)
		tics = hlimit - pt
		flash = true
		extrafunc = "countinghide"
	else
		-- Time limit?
		if (gametyperules & GTR_TIMELIMIT) and (puretlimit) then -- Gotta thank CobaltBW for spotting this oversight.
			if (tlimit > pt)
				tics = tlimit - pt
			else -- Overtime!
				tics = 0
			end
			flash = true
		-- Post-hidetime normal.
        elseif (gametyperules & GTR_STARTCOUNTDOWN) and (gametyperules & GTR_TIMELIMIT) -- Thanking 'im again.
            tics = tlimit - pt
        elseif (gametyperules & GTR_STARTCOUNTDOWN)
            tics = pt - hlimit
			extrafunc = "hiding"
        else
            tics = pt
        end
	end
	
	flash = (flash and (tics < 30*TR) and (lt/5 & 1)) -- Overtime?
	
	return flash, tics, extratext, extrafunc
end

local function drawtimer(v,p)

	if (customhud.CheckType("time") != modname) return end

	if p.takistable.inNIGHTSMode
	or (TAKIS_NET.inspecialstage)
	or p.takistable.inSRBZ
		return
	end
	
	local takis = p.takistable
	
	//time
	//this is so minhud
	local flashflag = 0
	local flash,timetic,extratext,extrafunc = howtotimer(p)
			
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
	
	//paddgin!!
	if (seconds < 10) then spad = '0' end
	if (tictrn < 10) then tpad = '0' end
	
	local timex, timey = unpack(takis.HUD.timer.int)
	local timetx = takis.HUD.timer.text
			
	if hours > 0
		extrac = ":"
	else
		hours = ''
	end
	
	if minutes >= 10
	and extrafunc == ''
		extra = " (SUCKS)"
	end
	
	if p.spectator
		timex, timey = unpack(takis.HUD.timer.spectator)
	elseif ( ((p.pflags & PF_FINISHED) and (netgame))
	or extrafunc == "hiding"
	or extrafunc == "countinghide")
	and not p.exiting
		timex, timey = unpack(takis.HUD.timer.finished)
	end
	v.drawString(timex, timey, hours..extrac..minutes..":"..spad..seconds.."."..tictrn..tpad,V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER|flashflag,"thin-right")		v.drawString(timetx, timey, "Time"..extra,V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER|flashflag,"thin")
	if extrastring ~= ''
		v.drawString(timetx, timey+8, extratext,V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER|flashflag,"thin")			
	end
end

--      ----------

--SCORE ----------

local function drawscore(v,p)

	if (customhud.CheckType("score") != modname) return end
	
	if p.takistable.inNIGHTSMode
	or (TAKIS_NET.inspecialstage)
	or p.takistable.inSRBZ
		return
	end
	
	local takis = p.takistable
	
	local xshake = takis.HUD.flyingscore.xshake
	local yshake = takis.HUD.flyingscore.yshake
		
	local score = p.score
	if takis.HUD.flyingscore.tics
		score = p.score-takis.HUD.flyingscore.lastscore
	end
	
	//v.drawString((300-15)*FU+xshake, 15*FU+yshake, takis.HUD.flyingscore.scorenum,V_SNAPTORIGHT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER,"fixed-right")
	
	//buggie's tf2 engi code
	local scorenum = "SCREFT"
	score = takis.HUD.flyingscore.scorenum
	
	local prevw
	if not prevw then prevw = 0 end
	
	local width = (string.len(score))*(v.cachePatch(scorenum.."1").width*4/10)
	for i = 1,string.len(score)
		local n = string.sub(score,i,i)
		v.drawScaled((300-15+prevw-width)*FU+xshake,
			15*FU+yshake,
			FU/2,
			v.cachePatch(scorenum+n),
			V_SNAPTORIGHT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER
		)
			
		prevw = $+v.cachePatch(scorenum+n).width*4/10
	end
	
	/*
	for k,va in ipairs(takis.HUD.scoretext)
		if va == nil
			continue
		end
		
		if va.tics
			va.ymin = $-FU
			v.drawString((300-15)*FU,(15+8)*FU-va.ymin,va.text,va.cmap|va.trans|V_SNAPTOTOP|V_SNAPTORIGHT|V_ADD,"thin-fixed-right")
			va.tics = $-1
		else
			table.remove(takis.HUD.scoretext,k)
		end
	end
	*/
	
	if takis.HUD.flyingscore.tics
		local snap = V_SNAPTOLEFT
		if takis.HUD.flyingscore.tics < 4
			snap = V_SNAPTORIGHT
		end
		
		local x = takis.HUD.flyingscore.x
		local y = takis.HUD.flyingscore.y
		
		v.drawString(x, y, 
			takis.HUD.flyingscore.num,
			snap|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER,
			"thin-fixed-center"
		)
		
	end
end

--      ----------

--LIVES ----------

//source lol
// https://github.com/STJr/SRB2/blob/eb1492fe6e501001a2271fa133bd76c0b0612715/src/st_stuff.c#L812
local function drawlivesarea(v,p)

	if (customhud.CheckType("lives") != modname) return end
	
	if p.takistable.inNIGHTSMode
	or (TAKIS_NET.inspecialstage)
	or p.takistable.inSRBZ
		return
	end
	
	local textmap = V_YELLOWMAP
	local candrawlives = true
	local infinite = false
	
	local disp = -20
	
	local me = p.mo
	local takis = p.takistable
	
	if not (p.skincolor)
		return
	end
	
	takis.HUD.hudname = skins[TAKIS_SKIN].hudname
	if p.skincolor == SKINCOLOR_GREEN
		takis.HUD.hudname = "Taykis"
	elseif p.skincolor == SKINCOLOR_RED
		takis.HUD.hudname = "Yakis"
	elseif p.skincolor == SKINCOLOR_SALMON
		takis.HUD.hudname = "Rakis"
	end
		
	//face background
	v.drawScaled(
		(hudinfo[HUD_LIVES].x)*FU,
		hudinfo[HUD_LIVES].y*FU,
		FU/2,
		v.cachePatch("TAK_LIFEBACK"),
		hudinfo[HUD_LIVES].f|V_HUDTRANS|V_PERPLAYER,
		v.getColormap(TAKIS_SKIN, nil)
	)
	
	//face
	if (p.spectator)
		v.drawScaled(
			(hudinfo[HUD_LIVES].x)*FU,
			hudinfo[HUD_LIVES].y*FU,
			FU/2,
			v.getSprite2Patch(TAKIS_SKIN,SPR2_XTRA,false,A,0,0),
			hudinfo[HUD_LIVES].f|V_HUDTRANSHALF|V_PERPLAYER,
			v.getColormap(TAKIS_SKIN, SKINCOLOR_CLOUDY)
		)
	elseif ((me) and (me.color))
		v.drawScaled(
			(hudinfo[HUD_LIVES].x)*FU,
			hudinfo[HUD_LIVES].y*FU,
			FU/2,
			v.getSprite2Patch(TAKIS_SKIN,SPR2_XTRA,false,A,0,0),
			hudinfo[HUD_LIVES].f|V_HUDTRANS|V_PERPLAYER,
			v.getColormap(TAKIS_SKIN, me.color)
		)
	elseif (p.skincolor)
		v.drawScaled(
			(hudinfo[HUD_LIVES].x)*FU,
			hudinfo[HUD_LIVES].y*FU,
			FU/2,
			v.getSprite2Patch(TAKIS_SKIN,SPR2_XTRA,false,A,0,0),
			hudinfo[HUD_LIVES].f|V_HUDTRANS|V_PERPLAYER,
			v.getColormap(TAKIS_SKIN, p.skincolor)
		)		
	end
	
	//text
	if (p.spectator)
		textmap = V_GRAYMAP
	elseif (gametyperules & GTR_TAG)
		if (p.pflags & PF_TAGIT)
			v.drawString(
				hudinfo[HUD_LIVES].x+58,hudinfo[HUD_LIVES].y+8,
				"IT!",
				V_HUDTRANS|hudinfo[HUD_LIVES].f|V_PERPLAYER|V_ALLOWLOWERCASE,
				"thin-right"
			)
			textmap = V_ORANGEMAP
		end
	elseif (G_GametypeHasTeams())
		
		if (p.ctfteam == 1)
			v.drawString(
				hudinfo[HUD_LIVES].x+58,hudinfo[HUD_LIVES].y+8,
				"\x85RED",
				V_HUDTRANS|hudinfo[HUD_LIVES].f|V_PERPLAYER|V_ALLOWLOWERCASE,
				"thin-right"
			)
			textmap = V_REDMAP
		
		elseif (p.ctfteam == 2)
			v.drawString(
				hudinfo[HUD_LIVES].x+58,hudinfo[HUD_LIVES].y+8,
				"\x84".."BLU",
				V_HUDTRANS|hudinfo[HUD_LIVES].f|V_PERPLAYER|V_ALLOWLOWERCASE,
				"thin-right"
			)
			textmap = V_BLUEMAP
		
		end
	end
	
	if (G_GametypeUsesLives())
		if CV_FindVar("cooplives").value == 0
			infinite = true
		end
	elseif (G_PlatformGametype() and not (gametyperules & GTR_LIVES))
		infinite = true
	else
		candrawlives = false
	end
	
	if takis.isSinglePlayer
		if p.lives ~= INFLIVES
			infinite = false
		else
			infinite = true
		end
	end
	
	if (candrawlives)
		v.drawScaled(
			(hudinfo[HUD_LIVES].x+22)*FU,(hudinfo[HUD_LIVES].y+10)*FU,
			FU,
			v.cachePatch("STLIVEX"),
			hudinfo[HUD_LIVES].f|V_PERPLAYER|V_HUDTRANS
		)
		if (infinite)
			
			v.drawScaled(
				(hudinfo[HUD_LIVES].x+50)*FU,(hudinfo[HUD_LIVES].y+8)*FU,
				FU,
				v.cachePatch("STCFN022"),
				hudinfo[HUD_LIVES].f|V_PERPLAYER|V_HUDTRANS
			)
			
		else
			local value = p.lives
			
			if CV_FindVar("cooplives").value == 3
			and (netgame or multiplayer)
				value = TAKIS_NET.livescount
			end
			
			v.drawString(
				hudinfo[HUD_LIVES].x+58,hudinfo[HUD_LIVES].y+9,
				value,
				hudinfo[HUD_LIVES].f|V_PERPLAYER|V_HUDTRANS,
				"thin-right"
			)
		end
			
		
	end
	
	if not (modeattacking)
	
		textmap = $|(V_HUDTRANS|hudinfo[HUD_LIVES].f|V_PERPLAYER|V_ALLOWLOWERCASE)
		v.drawString(
			hudinfo[HUD_LIVES].x+58,hudinfo[HUD_LIVES].y,
			takis.HUD.hudname,
			textmap,
			"thin-right"
		)
	
	else
		disp = $-10
	end
	
	//i guess i gotta draw the stones too
	if (G_RingSlingerGametype())
		disp = $-5
		local workx = hudinfo[HUD_LIVES].x+1
		local additive = 0
		
		local emeraldpics = {
			v.cachePatch("CHAOS1"),
			v.cachePatch("CHAOS2"),
			v.cachePatch("CHAOS3"),
			v.cachePatch("CHAOS4"),
			v.cachePatch("CHAOS5"),
			v.cachePatch("CHAOS6"),
			v.cachePatch("CHAOS7"),
		}
		
		if ((p.powers[pw_invulnerability]) and (p.powers[pw_sneakers] == p.powers[pw_invulnerability] ))
			if (not((leveltime/2)%2))
				additive = V_ADD
			end
			
			for i = 1, 7
				v.drawScaled(
					workx*FU,
					(hudinfo[HUD_LIVES].y-9)*FU,
					FU/4,
					emeraldpics[i],
					V_HUDTRANS|hudinfo[HUD_LIVES].f|V_PERPLAYER|additive
				)
				workx = $+9
			end
		else
		
			for i = 0, 7
				if (p.powers[pw_emeralds] & (1<<i))
					v.drawScaled(
						workx*FU,
						(hudinfo[HUD_LIVES].y-9)*FU,
						FU/4,
						emeraldpics[i+1],
						V_HUDTRANS|hudinfo[HUD_LIVES].f|V_PERPLAYER
					)
				end
				workx = $+9
			end
		
		end
		
	end
	
	if (takis.clutchcombo)
		disp = $-20
	end
	
	if (takis.shotgunned)
		v.drawScaled(hudinfo[HUD_LIVES].x*FU, (hudinfo[HUD_LIVES].y+disp)*FU, (FU/2)+(FU/12), v.cachePatch("TB_C3"), V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER|V_HUDTRANS,v.getColormap(nil, nil))
		v.drawString(hudinfo[HUD_LIVES].x+20, hudinfo[HUD_LIVES].y+(disp+5), "Un-Shotgun",V_ALLOWLOWERCASE|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER|V_HUDTRANS, "small")	
		disp = $-20
	end
	
	if (p.powers[pw_shield] ~= CR_NONE)
		local shieldflag = V_HUDTRANSHALF
		shieldflag = TakisHUDShieldUsability(p) and V_HUDTRANS or V_HUDTRANSHALF
		
		v.drawScaled(hudinfo[HUD_LIVES].x*FU, (hudinfo[HUD_LIVES].y+disp)*FU, (FU/2)+(FU/12), v.cachePatch("TB_C2"), V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER|shieldflag,v.getColormap(nil, nil))
		v.drawString(hudinfo[HUD_LIVES].x+20, hudinfo[HUD_LIVES].y+(disp+5), "Shield Ability",V_ALLOWLOWERCASE|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER|V_HUDTRANS, "small")
	end
	
	//xmom stuff
	/*
	if (S_PLAY_TRICKUP and S_PLAY_TRICKDOWN)
		if me and ((me.state != S_PLAY_TRICKUP) and (me.state != S_PLAY_TRICKDOWN)) return end	
		v.drawScaled(
			(hudinfo[HUD_LIVES].x+8)*FU, (hudinfo[HUD_LIVES].y-7)*FU,
			FU/2,
			v.getSprite2Patch(TAKIS_SKIN,me.sprite2,false,me.frame,2,me.rollangle),
			V_HUDTRANS|V_SNAPTOBOTTOM|V_SNAPTOLEFT,
			v.getColormap(TAKIS_SKIN, p.skincolor)
		)
	end
	*/
	
	if TAKIS_ISDEBUG
		v.drawString(hudinfo[HUD_LIVES].x+60,
			hudinfo[HUD_LIVES].y,
			"w.i.p.",
			V_HUDTRANS|V_REDMAP|V_SNAPTOLEFT|V_SNAPTOBOTTOM,
			"thin"
		)
	end
	
end

--      ----------

--CLUTCH----------

local function drawclutches(v,p)

	if (customhud.CheckType("takis_clutchstuff") != modname) return end
	
	if p.takistable.inNIGHTSMode
	or (TAKIS_NET.inspecialstage)
		return
	end
	
	local takis = p.takistable
	local me = p.mo
	
	local drawclutchbar = function(v, p, takis)

		local maxammo = 13*23/5
		local curammo = 13*(23-takis.clutchtime)/5
		local redarea = 13*(23-11)/5
		local x = hudinfo[HUD_LIVES].x
		local y = hudinfo[HUD_LIVES].y+20
		local barx = x //- maxammo/2
		local bary = y
		local patch1 = v.cachePatch("TAKISEG1") //blue
		local patch3 = v.cachePatch("TAKISEG2") //black
		local color = SKINCOLOR_GREEN
		
		--Ammo bar
		local pos = 0
		while (pos < maxammo)
			local patch = patch3
			pos = $ + 1
			
			if pos <= curammo
				v.draw(barx + pos - 1, bary, patch3, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_HUDTRANS|V_PERPLAYER)
				if pos > curammo - 1
					if (curammo <= 1)
						//first
						patch = patch1
					else
						//fill
						patch = patch1
					end
				else
					patch = patch1
				end
			end
			if (takis.clutchtime <= 11)
			and (takis.clutchtime > 0)
				color = SKINCOLOR_CRIMSON
			end
			v.draw(barx + pos - 1, bary, patch, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_HUDTRANS|V_PERPLAYER,v.getColormap(nil,color))
		end
		color = SKINCOLOR_WHITE
		v.draw(barx + 31 - 1, bary, patch1, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_HUDTRANS|V_PERPLAYER,v.getColormap(nil,color))
		
	end

	//clutch bar
	if takis.clutchtime > 0
		drawclutchbar(v,p,takis)
	end
	//clutch combo
	if takis.clutchcombo
		local y = 0
		if (modeattacking)
			y = -10
		end
		
		v.drawString(hudinfo[HUD_LIVES].x, hudinfo[HUD_LIVES].y-20+y, takis.clutchcombo.."x BOOSTS",V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_HUDTRANS|V_PERPLAYER|V_ALLOWLOWERCASE)			
	end

end

--      ----------

--COMBO ----------

local function drawcombostuff(v,p)

	if (customhud.CheckType("takis_combometer") != modname) return end

	if p.takistable.inNIGHTSMode
	or (TAKIS_NET.inspecialstage)
		return
	end
	
	local takis = p.takistable
	local me = p.mo

	if takis.combo.count
	or takis.combo.outrotics
		
		local comboscale = takis.HUD.combo.scale+FU
		local shake = -FixedMul(takis.HUD.combo.shake,comboscale)
		local backx = 15*FU
		local backy = 70*FU+shake-(takis.combo.gravity or takis.combo.outrotointro)
		
		if ((p.pflags & PF_FINISHED) and (netgame))
		and not p.exiting
			backy = $+(20*FU)
		end
		
		local max = TAKIS_MAX_COMBOTIME*FU or 1
		local erm = FixedDiv((takis.HUD.combo.fillnum),max)
		local width = FixedMul(erm,v.cachePatch("TAKCOFILL").width*FU)
		local color
		if takis.HUD.combo.fillnum <= TAKIS_MAX_COMBOTIME*FU/4
			color = SKINCOLOR_RED
		elseif takis.HUD.combo.fillnum <= TAKIS_MAX_COMBOTIME*FU/2
			color = SKINCOLOR_ORANGE
		elseif takis.HUD.combo.fillnum <= TAKIS_MAX_COMBOTIME*FU*3/4
			color = SKINCOLOR_YELLOW
		end
		if (takis.combo.frozen)
			color = SKINCOLOR_BLACK
		end
		if width < 0 then
			width = 0
		end
		takis.HUD.combo.patchx = v.cachePatch("TAKCOFILL").width*FU/2
		local patchx = takis.HUD.combo.patchx
		
		v.drawCropped(backx,backy,comboscale,comboscale,
			v.cachePatch("TAKCOFILL"),
			V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOTOP, 
			v.getColormap(nil,color),
			0,0,
			width,v.cachePatch("TAKCOFILL").height*FU
		)
		
		v.drawScaled(backx,backy,comboscale,
			v.cachePatch("TAKCOBACK"),
			V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOTOP
		)
		
		v.drawString(backx+5*comboscale+(FixedMul(patchx,comboscale)),
			backy+7*comboscale,
			takis.combo.score,
			V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOTOP,
			"thin-fixed-center"
		)
		
		//draw combo rank
		local length = #TAKIS_COMBO_RANKS
		v.drawString(backx+7*comboscale,
			backy+20*comboscale,
			TAKIS_COMBO_RANKS[ ((takis.combo.rank-1) % length)+1 ],
			V_HUDTRANS|V_ALLOWLOWERCASE|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER,
			"thin-fixed"
		)
		
		local scorenum = "CMBCF"
		local score = takis.combo.count
		
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
				V_ALLOWLOWERCASE|V_GREENMAP|V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOTOP,
				"thin-fixed-center"
			)
		end
		
		//draw the verys
		local maxvery = 19	
		
		local waveforce = FU*2
		waveforce = $+(FU/50*((takis.combo.verylevel-1)))
		if takis.combo.verylevel > 0
			for i = 1, takis.combo.verylevel
				
				local verypatch = v.cachePatch("TAKCOVERY")
				//if not (i % 2)
				//	verypatch = v.cachePatch("TAKCOSUPR")
				//end
				
				local k = ((i-1)%maxvery) //x
				local j = ((i-1)/maxvery) //y
				
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
		
	else
		if takis.combo.failcount
			takis.combo.failcount = 0
		end
	end

	if takis.combo.awardable
	and not takis.combo.dropped
		//takis.combo.awardable = true
		
		if takis.HUD.combo.tokengrow ~= 0
			takis.HUD.combo.tokengrow = $/2
		end
		
		local x = (300-30)*FU
		local y = 35*FU
		if p.ptje_rank
			x = $-20*FU
		end
		local grow = takis.HUD.combo.tokengrow
		
		v.drawScaled(x-(grow*25),y-(grow*20),FU/3+grow,
			v.cachePatch("FCTOKEN"),
			V_HUDTRANS|V_SNAPTORIGHT|V_SNAPTOTOP, 
			v.getColormap(nil, p.skincolor)
		)
	end
	
end

--      ----------

local function drawjumpscarelol(v,p)

	if (customhud.CheckType("takis_c3jumpscare") != modname) return end

	local takis = p.takistable
	local h = takis.HUD.funny
	
	if h.tics
		takis.HUD.funny.y = $*4/5
		takis.HUD.funny.tics = $-1
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
	end
	
end

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

local function drawhappyhour(v,p)

	if (customhud.CheckType("ptje_itspizzatime") != modname) return end
	
	if ((skins[p.skin].name ~= TAKIS_SKIN)
	and (p.takistable.io.morehappyhour == 0))
	and (HAPPY_HOUR.othergt)
		return
	end
	
	local takis = p.takistable
	
	if (HAPPY_HOUR.time) and (HAPPY_HOUR.time <= 5*TR)
	and (takis.io.nohappyhour == 0)
		
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
		
		local h = takis.HUD.happyhour
		local y = 40*FU
		
		local me = p.realmo

		local back = 4*FU/5
		
		local pa = v.cachePatch
		
		if tics > 1
			local shakex,shakey = happyshakelol(v)
			v.drawScaled(h.its.x+shakex, y+h.its.yadd+shakey, h.its.scale,
				pa(h.its.patch..h.its.frame),
				V_SNAPTOTOP|V_HUDTRANS
			)
			
			shakex,shakey = happyshakelol(v)
			v.drawScaled(h.happy.x+shakex, y+h.happy.yadd+shakey, h.happy.scale,
				pa(h.happy.patch..h.happy.frame),
				V_SNAPTOTOP|V_HUDTRANS
			)
			
			shakex,shakey = happyshakelol(v)
			v.drawScaled(h.hour.x+shakex, y+h.hour.yadd+shakey, h.hour.scale,
				pa(h.hour.patch..h.hour.frame),
				V_SNAPTOTOP|V_HUDTRANS
			)
			if tics > 4
				local pat = SPR2_TRNS
				local scale = 6*FU/5
				//if this looks weird, i dont care
				//ADD HHF_ SPRITE!!!!!
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
				
				local face = v.getSprite2Patch(p.skin,pat,false,frame,0,0)
				v.drawScaled(h.face.x+x, (130*FU)+h.face.yadd+yadd, FixedMul(scale,hires),
					face,
					V_HUDTRANS, v.getColormap(nil,p.skincolor)
				)
			end
		end
	end
	
end

local function getlaptext(p)
	local text = ''
	local exitingCount, playerCount = JISK_COUNT()
	local dynamiclapstext = "\x8D".."Dyna Laps"
	local lapsandmaxlapstext = "\x82Laps:"
	local lapstext = "\x82Laps:"
	local lapsperplayertext = "\x82Your Laps:"
	local num = ''
	
	//lots of these for backwards compatability
	local laps = ((PTJE) and (PTJE.laps)) or JISK_LAPS
	local laptype = ((CV_PTJE) and (CV_PTJE.lappingtype.value)) or ((JISK_LAPPINGTYPE) and (JISK_LAPPINGTYPE.value))
	local dynalap = ((CV_PTJE) and (CV_PTJE.dynamiclaps.value)) or ((JISK_DYNAMICLAPS) and (JISK_DYNAMICLAPS.value))
	local mlpp = ((CV_PTJE) and (CV_PTJE.maxlaps_perplayer.value)) or ((JISK_MAXLAPS_PERPLAYER) and (JISK_MAXLAPS_PERPLAYER.value))
	local maxlaps = ((CV_PTJE) and (CV_PTJE.maxlaps.value)) or ((JISK_MAXLAPS) and (JISK_MAXLAPS.value))
	local dynalapsv = ((PTJE) and (PTJE.dynamic_maxlaps)) or JISK_DYNAMICMAXLAPS
	
	if p.pizzaface and laptype == 2 then 
		num = 'dontdraw'
		return text,num
	end
	if laptype == 2 then
		text = lapsperplayertext
		num = p.lapsdid.." / "..mlpp
		return text,num
	end
	
	if dynalap then
		text = dynamiclapstext
		num = laps.." / "..dynalapsv
		return text,num
	end
	
	if maxlaps then
		text = lapsandmaxlapstext
		num = laps.." / "..maxlaps
		return text,num
	else
		text = lapstext
		num = laps
		return text,num
	end

end


local function hhtimerbase(v,p)
	if not HAPPY_HOUR.happyhour
		return
	end
	
	if not HAPPY_HOUR.timelimit
		return
	end
	
	if HAPPY_HOUR.time == 1
		return
	end
	
	local tics = HAPPY_HOUR.timeleft
	
	local takis = p.takistable
	
	if tics == nil
		tics = 0
	end
	
	local min = G_TicsToMinutes(tics,true)
	local sec = G_TicsToSeconds(tics)
	local cen = G_TicsToCentiseconds(tics)
	local spad,cpad,extrastring = '','',''
	
	//paddgin!!
	if (sec < 10) then spad = '0' end
	if (cen < 10) then cpad = '0' end
	
	local timertime = min..":"..spad..sec
	extrastring = "."..cpad..cen 
	if not (TAKIS_DEBUGFLAG & DEBUG_HAPPYHOUR)
		extrastring = ''
	end
	
	local string = timertime..extrastring
	
	local h = takis.HUD.ptje
		
	local frame = ((5*leveltime/6)%14)
	local patch
	local trig = HAPPY_HOUR.trigger
	if (trig and trig.valid)
	and (trig.type == MT_HHTRIGGER)
		patch = v.getSpritePatch(SPR_HHT_,trig.frame,0)
	else
		patch = v.cachePatch("TAHHS"..frame)
	end
	
	if not (takis.inNIGHTSMode)
		v.drawScaled(110*FU+(h.xoffset*FU),168*FU+(h.yoffset),FU,patch,V_HUDTRANS|V_SNAPTOBOTTOM)
		TakisDrawPatchedText(v, 150+(h.xoffset), 173+(h.yoffset/FU), tostring(string),{font = TAKIS_HAPPYHOURFONT, flags = (V_SNAPTOBOTTOM|V_HUDTRANS), align = 'left', scale = 4*FU/5})
	else
		if (p.exiting) then return end
		
		v.drawScaled(100*FU,10*FU-(h.yoffset),
			FU,v.cachePatch("TAHHS"..frame),
			V_HUDTRANS|V_SNAPTOTOP
		)
	
	end

end

local function drawpizzatimer(v,p)

	if (customhud.CheckType("ptje_bar") != modname) return end
	
	if (skins[p.skin].name ~= TAKIS_SKIN)
	and (p.takistable.io.morehappyhour == 0)
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

local function drawtelebar(v,p)

	
	local takis = p.takistable
	local me = p.mo
	local h = takis.HUD.ptje
	
	local charge = p.pizzacharge or 0
	
		local maxammo = TR*7/5
		local curammo = charge*7/5
		local x = 153
		local y = 168
		local barx = x+(h.xoffset)
		local bary = y+(h.yoffset/FU)
		local patch1 = v.cachePatch("TAKISEG1") //blue
		local patch3 = v.cachePatch("TAKISEG2") //black
		local color = p.skincolor
		
			--Ammo bar
			local pos = 0
			while (pos < maxammo)
				local patch = patch3
				pos = $ + 1
				
				
					if pos <= curammo
						v.draw(barx + pos - 1, bary, patch3, V_SNAPTOBOTTOM|V_HUDTRANS)
						if pos > curammo - 1
							if (curammo <= 1)
								//first
								patch = patch1
							else
								//fill
								patch = patch1
							end
						else
							patch = patch1
						end
					end
					
				v.draw(barx + pos - 1, bary, patch, V_SNAPTOBOTTOM|V_HUDTRANS,v.getColormap(nil,color))
			end
			

end

local function drawpizzatips(v,p)

	if (customhud.CheckType("ptje_tooltips") != modname) return end
	
	if (skins[p.skin].name ~= TAKIS_SKIN)
	and (p.takistable.io.morehappyhour == 0)
		return
	end
	
	local takis = p.takistable
	local h = takis.HUD.ptje
	
	h.xoffset = 0
	
	if not ( ((PTJE) and (PTJE.pizzatime)) or (JISK_PIZZATIME))
		return
	end
	
	local tics = JISK_PIZZATIMETICS or PTJE.pizzatime_tics

	
	local text,num = getlaptext(p)
	local exitingCount, playerCount = JISK_COUNT()

	if (not p.pizzaface) and (p.exiting) and (not PTJE.quitting) and (p.playerstate ~= PST_DEAD) and (exitingCount ~= playerCount)
		v.drawString(160, 130, "\x85Press FIRE to try a new lap!", V_ALLOWLOWERCASE|V_SNAPTOBOTTOM, "thin-center")
	end
	
	if tics > 3
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
	
	if p.stuntime
	and tics > 3
		local ft = ((JISK_PIZZATIMESTUN) and (JISK_PIZZATIMESTUN.value)) or ((CV_PTJE) and (CV_PTJE.pizzatimestun.value))
		ft = $*TR
		
		local max = ft*FU
		local erm = FixedDiv(p.stuntime*FU,max)
		
		local scale2 = (30*FU)-FixedMul(erm,30*FU)
		
		if scale2 < 0 then scale2 = FU end
		
		v.drawString(165*FU,(120*FU)+(h.yoffset),"Frozen for "..p.stuntime/TR.." seconds",V_10TRANS|V_HUDTRANS|V_ALLOWLOWERCASE,"thin-fixed-center")
		v.drawScaled(145*FU,135*FU+(h.yoffset),FU,v.cachePatch("TA_ICE2"), V_HUDTRANS)
		v.drawCropped(
		145*FU, 135*FU+(scale2)+(h.yoffset),
		FU,FU,v.cachePatch("TA_ICE"), V_HUDTRANS,nil,
		0,scale2,30*FU,30*FU)	
		
	end
	
	if p.pizzaface
		if (p.pizzachargecooldown)
			v.drawString(153+(h.xoffset),162+(h.yoffset/FU),"Cooling down...",V_SNAPTOBOTTOM|V_HUDTRANS|V_ALLOWLOWERCASE,"small")
		elseif (p.pizzacharge)
			v.drawString(153+(h.xoffset),162+(h.yoffset/FU),"Charging!",V_SNAPTOBOTTOM|V_HUDTRANS|V_ALLOWLOWERCASE,"small")
		else
			v.drawString(153+(h.xoffset),162+(h.yoffset/FU),"Hold FIRE to teleport!", V_SNAPTOBOTTOM|V_HUDTRANS|V_ALLOWLOWERCASE,"small")
		end
		drawtelebar(v,p)
	end
end

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

	if (customhud.CheckType("ptje_rank") != modname) return end
	
	if (skins[p.skin].name ~= TAKIS_SKIN)
		return
	end
	
	if gametype ~= GT_PIZZATIMEJISK then return end
	if p.pizzaface then return end
	
	local takis = p.takistable
	local h = takis.HUD.rank
	
	local x = (300-30)*FU
	local y = 35*FU
	
	if p.ptje_rank
		v.drawScaled(x-(h.grow*25),y-(h.grow*20),FU/3+h.grow,
			v.cachePatch("HUDRANK"..p.ptje_rank),
			V_HUDTRANS|V_SNAPTORIGHT|V_SNAPTOTOP
		)
		if h.percent
		and not ((p.ptje_rank == "S" and p.timeshit) or (p.ptje_rank == "P"))
			//thanks jisk for the help lol
			
			local max = h.percent
			local erm = FixedDiv((h.score),max)
			
			local scale2 = rankheights[p.ptje_rank]-(FixedMul(erm,rankheights[p.ptje_rank]))
			
 			if scale2 < 0 then scale2 = FU end
			
			v.drawCropped(x,y+(scale2/3),FU/3,FU/3,
				v.cachePatch("RANKFILL"..p.ptje_rank),
				V_HUDTRANS|V_SNAPTORIGHT|V_SNAPTOTOP, 
				v.getColormap(nil, nil),
				0,scale2,
				rankwidths[p.ptje_rank],rankheights[p.ptje_rank]
			)
			
		end
		if p.timeshit
		v.drawScaled(x-(h.grow*25),y-(h.grow*20),FU/3+h.grow,
			v.cachePatch("HUDRANKBKN"),
			V_HUDTRANS|V_SNAPTORIGHT|V_SNAPTOTOP|V_50TRANS
		)
		end
	end

end

local function drawnickranks(v,p)

	if (customhud.CheckType("rank") != modname) return end
	
	if (skins[p.skin].name ~= TAKIS_SKIN)
		return
	end
	
	if gametype ~= GT_PIZZATIME2 then return end
	if p.pt_mode.pizzaface then return end
	
	local takis = p.takistable
	local h = takis.HUD.rank
	
	local x = (300-30)*FU
	local y = 35*FU
	
	if p.ptje_rank
		v.drawScaled(x-(h.grow*25),y-(h.grow*20),FU/3+h.grow,
			v.cachePatch("HUDRANK"..p.ptje_rank),
			V_HUDTRANS|V_SNAPTORIGHT|V_SNAPTOTOP
		)
		if h.percent
		and not ((p.ptje_rank == "S" and p.timeshit > 0) or (p.ptje_rank == "P"))
			//thanks jisk for the help lol
			
			local max = h.percent
			local erm = FixedDiv((h.score),max)
			
			local scale2 = rankheights[p.ptje_rank]-(FixedMul(erm,rankheights[p.ptje_rank]))
			
 			if scale2 < 0 then scale2 = FU end
			
			v.drawCropped(x,y+(scale2/3),FU/3,FU/3,
				v.cachePatch("RANKFILL"..p.ptje_rank),
				V_HUDTRANS|V_SNAPTORIGHT|V_SNAPTOTOP, 
				v.getColormap(nil, nil),
				0,scale2,
				rankwidths[p.ptje_rank],rankheights[p.ptje_rank]
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
	v.drawString(15*FU,(75*FU)+yadd,"Taunt",V_ALLOWLOWERCASE|V_HUDTRANS,"fixed")
	v.drawString(305*FU,(75*FU)+yadd,"Hit C1 to Cancel",V_ALLOWLOWERCASE|V_HUDTRANS,"thin-fixed-right")
	v.drawString(15*FU,(90*FU)+yadd,"Hit C3 to join a Partner Taunt",V_ALLOWLOWERCASE|V_HUDTRANS,"thin-fixed")
	v.drawString(305*FU,(86*FU)+yadd,"Quick Taunt: TF+#+C2/C3",V_ALLOWLOWERCASE|V_HUDTRANS,"small-fixed-right")
	v.drawString(305*FU,(94*FU)+yadd,"Delete Quick Taunt: TF+Fire+C2/C3",V_ALLOWLOWERCASE|V_HUDTRANS,"small-fixed-right")
	v.drawScaled(160*FU,100*FU+yadd,FU/2,v.cachePatch("TAUNTSEPAR"),0,nil)
	
	local ydisp = 25*FU
	for i = 1, 7 //#takis.tauntmenu.list
		v.drawScaled((20+(35*i))*FU,103*FU+yadd+ydisp,FU/2,v.cachePatch("TAUNTCELL"),V_10TRANS,v.getColormap(nil, SKINCOLOR_BLACK))
		local name = takis.tauntmenu.list[i]
		local xoffset = takis.tauntmenu.xoffsets[i] or 0
		local showicon = true
		
		local trans = V_HUDTRANS
		if ((name == "")
		or (name == nil))
			name = "\x86None"
			trans = V_HUDTRANSHALF
			showicon = false
		//there IS an entry, but no functions to call for it
		elseif ((TAKIS_TAUNT_INIT[i] == nil) or (TAKIS_TAUNT_THINK[i] == nil))
			name = "\x86"..takis.tauntmenu.list[i]
			trans = V_HUDTRANSHALF
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
	
//	v.fadeScreen(35,fade)
	//drawfill my favorite :kindlygimmesummadat:
	v.drawScaled(0,0,FU*10,v.cachePatch("TAUNTBACK"),(9-fade)<<V_ALPHASHIFT,v.getColormap(nil,SKINCOLOR_RED))
end

//TODO: rewrite this all lel
local function drawcosmenu(v,p)
	if (customhud.CheckType("takis_cosmenu") != modname) return end
	
	local takis = p.takistable
	local me = p.mo
	
	local style = string.upper(takis.io.windowstyle).. "_"
	local menu = takis.cosmenu
	local windowtext = TAKIS_MENU.entries[menu.page].title.." ("..tostring(menu.page+1).."/"..tostring(#TAKIS_MENU.entries+1)..")"
	local maxbar = (string.len(windowtext)/4)+3
	local maxbary = #TAKIS_MENU.entries[menu.page].text
	local L = (maxbar*32)*FU					//length of window
	local A = 320*FU-L							//???
	local Y = 100*FU-(maxbary*25*FU/2)/2		//y to draw from
	local scale = FU/2
	
	//draw outline
	for i = 0,maxbar
		local color = v.getColormap(nil,p.skincolor)
		
		local patch = v.cachePatch(style.."7")
		for j = 0,maxbary
			if j == 0
				if i == 0
					patch = v.cachePatch(style.."5")
				elseif i == maxbarx
					patch = v.cachePatch(style.."6")
				end
			elseif j == maxbary
				if i == 0
					patch = v.cachePatch(style.."8")
				elseif i == maxbarx
					patch = v.cachePatch(style.."9")
				end
			end
			v.drawScaled((A/3)+(32*FU*i),(Y-2*FU)+(25*FU/2*j),scale,patch,V_HUDTRANS,color)
		end
	end
	//draw windoww
	for i = 0,maxbar
		local color = v.getColormap(nil,p.skincolor)
							
		local patch = v.cachePatch(style..'2')
		if i == 0
			patch = v.cachePatch(style.."1")
		end
		if i == maxbar-1
			patch = v.cachePatch(style.."3")
		elseif i == maxbar
			patch = v.cachePatch(style.."4")
		end
		for j = 0,maxbary
			if j > 0
				patch = v.cachePatch(style..'2')
				color = v.getColormap(nil,TAKIS_MENU.entries[menu.page].color)
			else
				if i == maxbar
					v.drawString( (A/3)+(32*FU*i)+16*FU,(Y-2*FU)-(25*FU/2)+(2*FU),"C1",V_HUDTRANS,"thin-fixed")
				end
			end
			v.drawScaled((A/3)+(32*FU*i),(Y-2*FU)+(25*FU/2*j),scale,patch,V_HUDTRANS,color)
		end
	end
	//cursor
	if menu.page ~= 1
		if not (TAKIS_MENU.entries[menu.page].nocursor)
			local color = TAKIS_MENU.entries[menu.page].curcolor or ColorOpposite(TAKIS_MENU.entries[menu.page].color)
			for i = 0,maxbar
				local color = v.getColormap(nil,color)
				local patch = v.cachePatch("CURSOR_M")
				if i == 0
					patch = v.cachePatch("CURSOR_L")
				end
				if i == maxbar
					patch = v.cachePatch("CURSOR_R")
				end
				v.drawScaled((A/3)+(32*FU*i),(Y-2*FU)+(25*FU/2*(menu.y+1)),scale,patch,V_HUDTRANS,color)
			end
		end
	end
	
	//text
	if menu.page ~= 1
		for i = 1,maxbary
			local txt = TAKIS_MENU.entries[menu.page].text[i]
			if txt == "$$$$$"
				if io --load savefile
					DEBUG_print(p,"Using I/O in Menu, Config")
					
					local file = io.openlocal("client/takisthefox/config.dat")
					
					
					//load file
					if file 
					
						local code = file:read("*a")
						
						if code ~= nil and not (string.find(code, ";"))
							txt = "\x86".."Config: "..code
						end
					
						file:close()
					
					else
						txt = "\x86No Config."
					end
					
				end
			end
			v.drawString((A/3)+2*FU,Y+(25*FU/2*i),txt,V_HUDTRANS|V_ALLOWLOWERCASE,"thin-fixed")
			
			if (TAKIS_MENU.entries[menu.page].values ~= nil)
			and (#TAKIS_MENU.entries[menu.page].values)
				local table = TAKIS_NET
				if TAKIS_MENU.entries[menu.page].table == "takis.io"
					table = takis.io
				elseif TAKIS_MENU.entries[menu.page].table == "takis"
					table = takis
				elseif TAKIS_MENU.entries[menu.page].table == "player"
					table = p
				elseif TAKIS_MENU.entries[menu.page].table ~= nil
					table = p[TAKIS_MENU.entries[menu.page].table]
				end
				v.drawString((A/3)+((32*FU)*(maxbar+1))-2*FU,Y+(25*FU/2*i),
					tostring(table[(TAKIS_MENU.entries[menu.page].values[i])]),
					V_HUDTRANS|V_ALLOWLOWERCASE,"thin-fixed-right"
				)
			end
		end
	//achievements, hardcoded
	else
		local flash = true
		local yadd = 0
		flash = (flash and ((leveltime%(2*TR)) < 30*TR) and (leveltime/5 & 1))
		if flash
			yadd = 2*FU
		end
		
		if menu.achscroll > 0
			v.drawScaled((A/3)+((32*FU)*(maxbar+1))-2*FU+(10*FU),Y+(25*FU/2)-yadd,FU,
				v.cachePatch("STCFN026"),
				V_HUDTRANS|V_YELLOWMAP
			)
		end
		if menu.achscroll < NUMACHIEVEMENTS-5
			v.drawScaled((A/3)+((32*FU)*(maxbar+1))-2*FU+(10*FU),Y+(25*FU/2*maxbary)+(yadd),FU,
				v.cachePatch("STCFN027"),
				V_HUDTRANS|V_YELLOWMAP
			)
		end
		
		for i = menu.achscroll, (5+menu.achscroll)-1
			local minus = ((17)*FU)*menu.achscroll
			
			if i > NUMACHIEVEMENTS-1
				continue
			end
			
			local has = V_HUDTRANSHALF
			local number = 0
			TakisReadAchievements(p)
			number = takis.achfile
			
			if (number & (1<<i))
				has = V_HUDTRANS
			end
			
			v.drawScaled((A/3)+2*FU,
				Y+((17)*FU)*i+13*FU-minus,
				TAKIS_ACHIEVEMENTINFO[1<<i].scale or FU,
				v.cachePatch(TAKIS_ACHIEVEMENTINFO[1<<i].icon),
				has
			)
			v.drawString((A/3)+2*FU+(16*FU),
				Y+((17)*FU)*i+13*FU-minus,
				TAKIS_ACHIEVEMENTINFO[1<<i].name or "Ach. Enum "..(1<<i),
				V_ALLOWLOWERCASE|V_RETURN8,
				"thin-fixed"
			)
			v.drawString((A/3)+2*FU+(16*FU),
				Y+((17)*FU)*i+13*FU+(8*FU)-minus,
				TAKIS_ACHIEVEMENTINFO[1<<i].text or "Flavor text goes here",
				V_ALLOWLOWERCASE|V_RETURN8,
				"small-fixed"
			)
		end
		/*
		local barposition = (25*FU/2*maxbary) + FixedDiv(menu.achscroll*FU,NUMACHIEVEMENTS*FU) * (25*FU/2)
		v.drawScaled(160*FU,barposition,FU,v.cachePatch(TAKIS_ACHIEVEMENTINFO[1<<2].icon),0)
		*/
	end
	
	local hinttrans = V_HUDTRANS
	if menu.hintfade > 0
		if menu.hintfade > (3*TR+9)
			hinttrans = (menu.hintfade-(3*TR+9))<<V_ALPHASHIFT
		end
		if menu.hintfade < 10
			hinttrans = (10-menu.hintfade)<<V_ALPHASHIFT
		end
		v.drawString(160*FU,Y+(25*FU/2*(maxbary+1)),
			"[C1] - Exit",
			V_GRAYMAP|V_RETURN8|V_ALLOWLOWERCASE|hinttrans,
			"thin-fixed-center"
		)
		v.drawString(160*FU,Y+(25*FU/2*(maxbary+1))+8*FU,
			"[Jump] - Select",
			V_GRAYMAP|V_RETURN8|V_ALLOWLOWERCASE|hinttrans,
			"thin-fixed-center"
		)
		v.drawString(160*FU,Y+(25*FU/2*(maxbary+1))+16*FU,
			"[Up/Down] - Move Cursor",
			V_GRAYMAP|V_RETURN8|V_ALLOWLOWERCASE|hinttrans,
			"thin-fixed-center"
		)
		v.drawString(160*FU,Y+(25*FU/2*(maxbary+1))+24*FU,
			"[Left/Right] - Flip page",
			V_GRAYMAP|V_RETURN8|V_ALLOWLOWERCASE|hinttrans,
			"thin-fixed-center"
		)
			
		if not paused
			menu.hintfade = $-1
		end
	end
	
	v.drawString((A/3)+16*FU,Y,windowtext,V_HUDTRANS|V_ALLOWLOWERCASE,"fixed")
	
	if takis.HUD.showingletter
		v.fadeScreen(0xFF00,16)
		if (p.cmd.buttons & BT_CUSTOM2)
			takis.HUD.showingletter = false
			P_RestoreMusic(p)
		end
		local color = v.getColormap(nil,p.skincolor)
		v.drawScaled(160*FU,100*FU,FU,v.cachePatch("IMP_LETTER"),V_HUDTRANS,color)
		v.drawString(82,11,"Dear pesky blasters...",V_ALLOWLOWERCASE|V_HUDTRANS|V_INVERTMAP,"thin")
		v.drawString(76,21,"The Badniks and I have taken over\nGreenflower City. The Chaos Emeralds are",V_RETURN8|V_ALLOWLOWERCASE|V_HUDTRANS|V_INVERTMAP,"thin")
		v.drawString(72,37,"now permanent guests at one of my seven",V_ALLOWLOWERCASE|V_HUDTRANS|V_INVERTMAP,"thin")
		v.drawString(69,37+8,"Special Stages. I dare you to find them, if\nyou can! ",V_ALLOWLOWERCASE|V_HUDTRANS|V_INVERTMAP,"thin")
		v.drawString(68,73,"C2 - Exit",V_ALLOWLOWERCASE|V_HUDTRANS|V_GRAYMAP,"left")
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
	
	v.drawString(160,50,"You have no Config, check",trans|V_ALLOWLOWERCASE,"thin-center")
	v.drawString(160,60,"out the \x86takis_openmenu\x80.",trans|V_ALLOWLOWERCASE,"thin-center")
	v.drawString(160,70,"Make sure to get the Music Wad!",trans|V_ALLOWLOWERCASE,"thin-center")
	v.drawString(160,80,"\x86".."C3 - Dismiss",trans|V_ALLOWLOWERCASE,"thin-center")
	
	if takis.c3
		HUD.cfgnotifstuff = 1
	end
	
	HUD.cfgnotifstuff = $-1
end

local function drawbonuses(v,p)
	if (customhud.CheckType("takis_cfgnotifs") != modname) return end
	
	if (skins[p.skin].name ~= TAKIS_SKIN)
		return
	end
	
	local takis = p.takistable
	local HUD = takis.HUD
	local me = p.mo
	
	TakisDrawBonuses(
		v, p, -- Self explanatory.
		(300-15)*FU, 30*FU, V_SNAPTORIGHT|V_SNAPTOTOP|V_ALLOWLOWERCASE, -- Powerups X & Y. Flags.
		'thin-fixed-right', -- string alignment.
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
	
	if (camera.chase)
		return
	end
	
	local trans = V_HUDTRANS
	local scale = FU/2
	if takis.shotguncooldown
		scale = $+FixedDiv(takis.shotguncooldown*FU,6*FU)
		trans = V_HUDTRANSHALF
	end
	
	v.drawScaled(160*FU,100*FU,scale,v.cachePatch("SHGNCRSH"),trans)
end

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
		local x, y = 16, 156
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
		
		v.drawString(x,y-58,"noability",flags|V_GREENMAP,"thin")
		drawflag(v,x+00,y-50,"CL",flags,V_GREENMAP,V_REDMAP,"thin",(takis.noability & NOABIL_CLUTCH))
		drawflag(v,x+15,y-50,"HM",flags,V_GREENMAP,V_REDMAP,"thin",(takis.noability & NOABIL_HAMMER))
		drawflag(v,x+30,y-50,"DI",flags,V_GREENMAP,V_REDMAP,"thin",(takis.noability & NOABIL_DIVE))
		drawflag(v,x+45,y-50,"SL",flags,V_GREENMAP,V_REDMAP,"thin",(takis.noability & NOABIL_SLIDE))
		drawflag(v,x+60,y-50,"WD",flags,V_GREENMAP,V_REDMAP,"thin",(takis.noability & NOABIL_WAVEDASH))
		drawflag(v,x+75,y-50,"SG",flags,V_GREENMAP,V_REDMAP,"thin",(takis.noability & NOABIL_SHOTGUN))
		
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
	if (TAKIS_DEBUGFLAG & DEBUG_PAIN)
		drawflag(v,160,122,"Pain",V_HUDTRANS|V_PERPLAYER|V_ALLOWLOWERCASE,V_GREENMAP,V_REDMAP,"thin",(takis.inPain))
		drawflag(v,160,130,"FakePain",V_HUDTRANS|V_PERPLAYER|V_ALLOWLOWERCASE,V_GREENMAP,V_REDMAP,"thin",(takis.inFakePain))
		drawflag(v,160,138,"WaterSlide",V_HUDTRANS|V_PERPLAYER|V_ALLOWLOWERCASE,V_GREENMAP,V_REDMAP,"thin",(takis.inwaterslide))
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
	end
	if (TAKIS_DEBUGFLAG & DEBUG_QUAKE)
		for k,va in ipairs(takis.quake)
			if va == nil
				continue
			end
			
			v.drawString(40,8*(k-1),
				va.tics.." | "..
				L_FixedDecimal(va.intensity,3),
				V_HUDTRANS,
				"left"
			)
		end
		v.drawString(40,-8,L_FixedDecimal(takis.quakeint,3),V_HUDTRANS,"left")
	end
	if (TAKIS_DEBUGFLAG & DEBUG_HAPPYHOUR)
		local strings = prtable("Happy Hour",HAPPY_HOUR,false)
		for k,va in ipairs(strings)
			v.drawString(100,30+(8*(k-1)),va,V_ALLOWLOWERCASE,"left")
		end
		
	end
	if (TAKIS_DEBUGFLAG & DEBUG_ALIGNER)
		v.draw(160,100,v.cachePatch("ALIGNER"),V_20TRANS)
		v.drawString(hudinfo[HUD_LIVES].x+68,hudinfo[HUD_LIVES].y+8,
			L_FixedDecimal(takis.accspeed,3),
			V_HUDTRANS|V_SNAPTOBOTTOM|V_SNAPTOLEFT,
			"thin"
		)
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
		drawflag(v,170,70,"sa",
			V_HUDTRANS|V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_SHIELDABILITY)
		)
		drawflag(v,100,70,"AA",
			V_HUDTRANS|V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_APPLYAUTOBRAKE)
		)
		
	end
	if (TAKIS_DEBUGFLAG & DEBUG_DEATH)
		
	end
end

//draw the stuff
customhud.SetupItem("takis_wareffect", 		modname/*,	drawfreeze,		"game",	1*/)
customhud.SetupItem("takis_freezing", 		modname/*,	drawfreeze,		"game",	1*/)
customhud.SetupItem("takis_clutchstuff",	modname/*,	drawclutches,	"game",	23*/) --
customhud.SetupItem("rings", 				modname/*,	drawrings,		"game",	24*/) 
customhud.SetupItem("time", 				modname/*,	drawtimer,		"game",	25*/) 
customhud.SetupItem("lives", 				modname/*,	drawlivesarea,	"game",	10*/)
customhud.SetupItem("takis_combometer", 	modname/*,	drawcombostuff,	"game",	27*/) 
customhud.SetupItem("score", 				modname/*,	drawscore,		"game",	26*/) 
customhud.SetupItem("takis_heartcards", 	modname/*,	drawheartcards,	"game",	30*/) --
customhud.SetupItem("takis_statusface", 	modname/*,	drawface,		"game",	31*/) --
customhud.SetupItem("takis_c3jumpscare", 	modname/*,	drawface,		"game",	31*/) --
customhud.SetupItem("takis_tauntmenu", 		modname/*,	drawface,		"game",	31*/) --
customhud.SetupItem("takis_cosmenu", 		modname/*,	drawface,		"game",	31*/) --
customhud.SetupItem("rings", 				modname/*,	drawrings,		"game",	24*/) 
customhud.SetupItem("time", 				modname/*,	drawtimer,		"game",	25*/) 
customhud.SetupItem("score", 				modname/*,	drawscore,		"game",	26*/) 
customhud.SetupItem("lives", 				modname/*,	drawlivesarea,	"game",	10*/)
customhud.SetupItem("takis_cfgnotifs", 		modname/*,	drawlivesarea,	"game",	10*/)
customhud.SetupItem("takis_bonuses", 		modname/*,	drawlivesarea,	"game",	10*/)
customhud.SetupItem("takis_crosshair", 		modname/*,	drawlivesarea,	"game",	10*/)
customhud.SetupItem("takis_happyhourtime", 	modname/*,	drawlivesarea,	"game",	10*/)

addHook("HUD", function(v,p)
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
			
			//customhud.SetupItem("takis_wareffect", 		modname/*,	drawfreeze,		"game",	1*/)
			customhud.SetupItem("takis_freezing", 		modname/*,	drawfreeze,		"game",	1*/)
			customhud.SetupItem("takis_clutchstuff",	modname/*,	drawclutches,	"game",	23*/) --
			customhud.SetupItem("rings", 				modname/*,	drawrings,		"game",	24*/) 
			customhud.SetupItem("time", 				modname/*,	drawtimer,		"game",	25*/) 
			customhud.SetupItem("score", 				modname/*,	drawscore,		"game",	26*/) 
			customhud.SetupItem("lives", 				modname/*,	drawlivesarea,	"game",	10*/)
			customhud.SetupItem("takis_combometer", 	modname/*,	drawcombostuff,	"game",	27*/) 
			customhud.SetupItem("takis_heartcards", 	modname/*,	drawheartcards,	"game",	30*/) --
			customhud.SetupItem("takis_statusface", 	modname/*,	drawface,		"game",	31*/) --
			customhud.SetupItem("takis_c3jumpscare", 	modname/*,	drawface,		"game",	31*/) --
			customhud.SetupItem("takis_tauntmenu", 		modname/*,	drawface,		"game",	31*/) --
			customhud.SetupItem("takis_cfgnotifs", 		modname/*,	drawlivesarea,	"game",	10*/)
			customhud.SetupItem("takis_bonuses", 		modname/*,	drawlivesarea,	"game",	10*/)
			customhud.SetupItem("takis_crosshair", 		modname/*,	drawlivesarea,	"game",	10*/)
			customhud.SetupItem("takis_happyhourtime", 	modname/*,	drawlivesarea,	"game",	10*/)
		
			if takis.io.nohappyhour == 0
				customhud.SetupItem("ptje_itspizzatime",modname)
				customhud.SetupItem("ptje_bar",modname)
				customhud.SetupItem("ptje_tooltips",modname)
			elseif takis.io.nohappyhour == 1
				customhud.SetupItem("ptje_itspizzatime","jiskpizzatime")
				customhud.SetupItem("ptje_bar","jiskpizzatime")
				customhud.SetupItem("ptje_tooltips","jiskpizzatime")
			end
			customhud.SetupItem("ptje_rank", modname)
			//customhud.SetupItem("rank", modname)
			
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
					v.drawString(160,55,"\x85You will be spawning with a",V_ALLOWLOWERCASE,"thin-center")
					v.drawString(160,65,"\x82Shotgun\x85 from now on!",V_ALLOWLOWERCASE,"thin-center")
					v.drawString(160,75,"C3 - Don't Care",V_ALLOWLOWERCASE,"thin-center")
				end
				if (p.cmd.buttons & BT_CUSTOM3)
					p.takis.shotgunnotif = 1
				end
				
				p.takis.shotgunnotif = $-1
			end
			
			//drawwareffect(v,p)
			if not (takis.cosmenu.menuinaction)
				drawclutches(v,p)
				drawrings(v,p)
				drawtimer(v,p)
				drawlivesarea(v,p)
				drawcombostuff(v,p)
				drawbonuses(v,p)
				drawheartcards(v,p)
				drawscore(v,p)
				drawface(v,p)
				drawtauntmenu(v,p)
				drawpizzatips(v,p)
				drawpizzatimer(v,p)
				drawpizzaranks(v,p)
				drawcrosshair(v,p)
				//drawnickranks(v,p)
			else
				drawcosmenu(v,p)
			end
			drawcfgnotifs(v,p)
			drawhappyhour(v,p)
			
			if takis.fchelper
				//fc helper
				local t = V_HUDTRANS
				if takis.thingsdestroyed == TAKIS_NET.numdestroyables
					t = V_HUDTRANSHALF
				end
				v.drawString(300-15,94,takis.thingsdestroyed,V_SNAPTORIGHT|t|V_BLUEMAP,"center")
				v.drawString(300-15,106,TAKIS_NET.numdestroyables,V_SNAPTORIGHT|t|V_BLUEMAP,"center")
			end
			
			for k,v in ipairs(takis.bonuses)
				v.drawString(160,100,v.text,0,"center")
			end
		else
			customhud.SetupItem("rings","vanilla")
			customhud.SetupItem("time","vanilla")
			customhud.SetupItem("score","vanilla")
			customhud.SetupItem("lives","vanilla")
			if takis.io.morehappyhour == 0
				customhud.SetupItem("ptje_itspizzatime","jiskpizzatime")
				customhud.SetupItem("ptje_bar","jiskpizzatime")
			else
				customhud.SetupItem("ptje_itspizzatime",modname)
				drawhappyhour(v,p)			
			end
			customhud.SetupItem("ptje_bar","jiskpizzatime")
			customhud.SetupItem("ptje_tooltips","jiskpizzatime")
			customhud.SetupItem("ptje_rank", "jiskpizzatime")
			//customhud.SetupItem("rank", "pizzatime2.0")
			
			//elfilin stuff
			if ((me) and (me.valid))
			and (me.skin == "elfilin")
			and (p.elfilin)
				//check out my sweet new ride!
				local ride = p.elfilin.ridingplayer
				
				if p.elfilin
				and ((ride) and (ride.valid))

					local p2 = ride.player
					local takis2 = p2.takistable
					
					if ride.skin == TAKIS_SKIN
						
						if takis2.io.nohappyhour == 0
						and takis.io.morehappyhour == 0
							customhud.SetupItem("ptje_itspizzatime",modname)
							drawhappyhour(v,p2)
						end
						
						
						local workx = (265*FU)-(35*FU)
						
						//draw p2's heartcards
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
					
						
						//show p2's combo
						drawcombostuff(v,p2)
						if takis2.combo.count
							
							v.drawString((hudinfo[HUD_RINGS].x+18+combdisp+6+10)*FU,(hudinfo[HUD_RINGS].y+20+35+comby-55-4)*FU,p2.name.."'s Combo",V_HUDTRANS|V_ALLOWLOWERCASE|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER,"thin-fixed-center")
							v.drawString((hudinfo[HUD_RINGS].x+18+combdisp+6+10)*FU,(hudinfo[HUD_RINGS].y+20+35+comby-55+4)*FU,"Cheer to refill!",V_HUDTRANS|V_ALLOWLOWERCASE|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER,"thin-fixed-center")
							
							/*
							local shake = takis2.HUD.combo.meter.shake
							local combdisp = 8
							local comby = 14
							if (p2.pflags & PF_FINISHED)
							or (p.pflags & PF_FINISHED)
								comby = $+16
							end
							comby = $+10
							
							drawcombotimebar(v,p,takis2,comby,0,shake)
							local meterx,metery = unpack(takis2.HUD.combo.meter.FIXED)
							local numx,numy = unpack(takis2.HUD.combo.num.int)
							v.drawScaled(meterx,metery+(comby*FU)+(shake),6*FU/5,v.cachePatch("TAKCOBACK"),V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER, v.getColormap(nil, nil))
							v.drawNum(numx,numy+comby+(shake/FU),takis2.combo.count,V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER)
							v.drawString((hudinfo[HUD_RINGS].x+18+combdisp+6)*FU,(hudinfo[HUD_RINGS].y+20+comby)*FU+(shake),"Combo!",V_HUDTRANS|V_ALLOWLOWERCASE|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER,"thin-fixed")
							
							if takis2.combo.verylevel > 0
								for i = 1, takis2.combo.verylevel
									
									local verypatch = v.cachePatch("TAKCOVERY")
									//if not (i % 2)
									//	verypatch = v.cachePatch("TAKCOSUPR")
									//end
									v.drawScaled(meterx+(7*FU)+(i*(3*FU)),metery+(37*FU)+(i*2*FU)+(comby*FU),FU/3,verypatch,V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER, v.getColormap(nil, color))
									
								end
							end
							
							local length = #TAKIS_COMBO_RANKS
							v.drawString((hudinfo[HUD_RINGS].x+18+combdisp+6+10)*FU,(hudinfo[HUD_RINGS].y+20+35+comby)*FU,TAKIS_COMBO_RANKS[ ((takis2.combo.rank-1) % length)+1 ],V_HUDTRANS|V_ALLOWLOWERCASE|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER,"thin-fixed-center")
							*/
						end
						
					end
					
				end
				
			end
			
			if takis.cosmenu.menuinaction
				drawcosmenu(v,p)
			end
		end
		drawjumpscarelol(v,p)
		//prtable("steam",takis.HUD.steam)
		takis.HUD.showingachs = 0
		for k,va in ipairs(takis.HUD.steam)
			if va == nil
				continue
			end
			
			if not paused
				va.tics = $-1
			end
			
			local enum = va.enum
			local bottom = 16*FU
			local trans = 0
			local yadd = 28*FU*(k-1)
			yadd = -$
			if va.tics < 10
				trans = (10-va.tics)<<V_ALPHASHIFT
			end
			
			if takis.HUD.showingachs & enum
				table.remove(takis.HUD.steam,k)
				return
			end
			
			takis.HUD.showingachs = $|enum
			
			local t = TAKIS_ACHIEVEMENTINFO
			local x = va.xadd
			if va.xadd ~= 0
				va.xadd = $*2/3 //ease.outquad(( FU / et )*(takis.HUD.steam.tics-(3*TR)), 9324919, 0)
			end
			
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
			
			if takis.HUD.steam[k].tics == 0
				table.remove(takis.HUD.steam,k)
			end
			
		end
		
		if takis.HUD.menutext.tics
			local trans = 0
			if takis.HUD.menutext.tics > (3*TR)
				trans = (takis.HUD.menutext.tics-3*TR)<<V_ALPHASHIFT
			elseif takis.HUD.menutext.tics < 10
				trans = (10-takis.HUD.menutext.tics)<<V_ALPHASHIFT
			end
			
			v.drawString(160,200-8,"\x86takis_openmenu\x80 - Open Menu",trans|V_ALLOWLOWERCASE|V_SNAPTOBOTTOM,"thin-center")
			takis.HUD.menutext.tics = $-1
		end
	
		drawdebug(v,p)
	end
end)

addHook("HUD", function(v)
	if TAKIS_TITLEFUNNY
		v.fadeScreen(35,10)
		
		TAKIS_TITLEFUNNYY = $*3/4
		
		local scale = FU*7/5
		local p = v.cachePatch("BALL_BUSTER")
		
		local x = v.RandomFixed()*3
		if ((TAKIS_TITLETIME%4) < 3)
			x = -$
		end
		
		v.drawScaled(((300/2)*FU)+x,TAKIS_TITLEFUNNYY,scale,p,0)	
	end
end,"title")

filesdone = $+1
