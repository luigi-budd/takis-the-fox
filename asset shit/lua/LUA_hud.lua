local drawclutchbar = function(v, p, me, takis)
	local maxammo = 13*23/5
	local curammo = 13*(23-takis.clutchtime)/5
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
			
			//todo: skincolors
			v.draw(barx + pos - 1, bary, patch, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_HUDTRANS|V_PERPLAYER,v.getColormap(nil,color))
		end
		
end
local drawcombotimebar = function(v, p, me, takis, comby,add,shake)
	local mul,div = 20,22
	
	local maxammo = mul*(TAKIS_MAX_COMBOTIME/3)/div
	local curammo = mul*(takis.combo.time/3)/div
	local x,y = unpack(takis.HUD.combo.meter.int)
	y = $+comby
	local barx, bary = x,y
	local patch1 = v.cachePatch("TAKCOSEG") //blue
	local blank = v.cachePatch("TAKISBLANK")
	local color = SKINCOLOR_RED
	
		--Ammo bar
		local pos = 0
		while (pos < maxammo)
			local patch = blank
			pos = $ + 1
			
			
				if pos <= curammo

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
				
			if pos > (3*maxammo/4)
				color = SKINCOLOR_GREEN
			elseif pos > (maxammo/2)
				color = SKINCOLOR_TAKIS_BARYELLOW
			elseif pos > (maxammo/4)
				color = SKINCOLOR_ORANGE
			end
			
			if takis.combo.frozen
				color = SKINCOLOR_CARBON
			end
			
			//todo: skincolors
			v.drawScaled((barx + pos - 1)*FU, (bary*FU)+(add)-((2*FU)/10)+(shake), 6*FU/5, patch, V_SNAPTOTOP|V_SNAPTOLEFT|V_HUDTRANS|V_PERPLAYER,v.getColormap(nil,color))
		end
		
end

//this is so minhud
//never realized how complex the timer is to replicate, i respect
//Lianvee a whoooole lot for spending months making minhud, as
//its just really awesome
//also tf2 minhud lol!
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


//referencing doom's status face code
// https://github.com/id-Software/DOOM/blob/77735c3ff0772609e9c8d29e3ce2ab42ff54d20b/linuxdoom-1.10/st_stuff.c#L752
local function calcstatusface(p,takis)
	local me = p.mo
	
	//idle
	if not ( ((PizzaTime) and (PizzaTime.PizzaTime)) or (JISK_PIZZATIME) )
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
		if (takis.inPain)
		or (takis.ticsforpain)
		or (me.sprite2 == SPR2_PAIN)
		or (me.state == S_PLAY_PAIN)
		or takis.tauntid == 1
		or takis.HUD.statusface.painfacetic
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
		if P_InSpaceSector(me)
		or ((p.powers[pw_underwater]) and (p.powers[pw_underwater] <= 11*TR))
			takis.HUD.statusface.state = "SDWN"
			takis.HUD.statusface.frame = (leveltime)%2
			takis.HUD.statusface.priority = 1
		end
		
	end
	
	return takis.HUD.statusface.state, takis.HUD.statusface.frame
end

addHook("HUD", function(v,p)
	if not p
	or not p.valid
	or PSO
		return
	end
	
	if p.powers[pw_carry] == CR_NIGHTSMODE
	or (TAKIS_NET.inspecialstage)
		return
	end
	
	local takis = p.takistable
	local me = p.mo
	
	if takis
		
		if takis.isTakis
			
			//defualt hud
			if takis.io.hudstyle == 1
			
			//mrce
			if takis.aliments.timetoice
			or takis.aliments.iced
				TakisDrawFreezing(v,p,takis)
			end
			
			hud.disable("score")
			hud.disable("time")
			hud.disable("rings")
			
			if customhud
				customhud.disable("score")
				customhud.disable("time")
				customhud.disable("rings")
				customhud.SetupItem("lives", "vanilla")
			end
			
			
			local xoff = 20*FU
			
			//heart cards
			for i = 1, TAKIS_MAX_HEARTCARDS do
				local flags = V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER
				
				local patch = v.cachePatch("HEARTCARD1")
				if 6-i > takis.heartcards-1
				or p.spectator
					patch = v.cachePatch("HEARTCARD2")
				end
				
				local add = -3*FU
				
				if (i%2)
					add = 3*FU
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
				
				//draw from last to first
				v.drawScaled(90*FU-((13*FU)*i)+xoff+shakex,15*FU+add-takis.HUD.heartcards.add+shakey,4*FU/5, patch, flags)
				//v.drawScaled(15*FU,15*FU,4*FU/5, v.cachePatch("HEARTCARD1"), V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS)
				
			end
			
			
			
			//0 is max health
			//6 is no health
			
			local healthstate,healthframe = calcstatusface(p,takis)
			
			local headpatch = v.cachePatch("TAK"..healthstate..tostring(healthframe))
		
			local headcolor
			if p.spectator
				headcolor = SKINCOLOR_GREY
			else
				if ((me) and (me.valid))
					headcolor = me.color
				else
					headcolor = SKINCOLOR_GREY
				end
			end
			
			v.drawScaled(20*FU,27*FU,2*FU/5, headpatch, V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER,v.getColormap(nil,headcolor))

			//heal indc.
			if takis.heartcards ~= 6
				v.drawString(100+(xoff/FU),15+4,takis.heartcardpieces,V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER,"thin")
				v.drawString(104+(xoff/FU),15+4+4,"/",V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER,"thin")
				v.drawString(107+(xoff/FU),15+8+3-2+4,"7",V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER,"thin")
				v.drawScaled((125*FU)+xoff, 33*FU, FU/2,v.getSpritePatch("RING", A, 0, 0), V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER)
			end
			
			//rings
			local ringpatch = "RING"
			
			if p.rings == 0
			and takis.heartcards <= 0
				if (leveltime % 10) < 4
					ringpatch = "TRNG"
				end
			end
			
			local ringFx,ringFy = unpack(takis.HUD.rings.FIXED)
			local ringx,ringy = unpack(takis.HUD.rings.int)
			
			v.drawScaled(ringFx, ringFy, FU/2,v.getSpritePatch(ringpatch, A, 0, 0), V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER,v.getColormap(nil,SKINCOLOR_RED))
			v.drawNum(ringx, ringy, p.rings, V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER)
			
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
				extra = " (SUCKS)"
			end
			
			if p.spectator
				timex, timey = unpack(takis.HUD.timer.spectator)
			elseif ((p.pflags & PF_FINISHED) and (netgame))
			or extrafunc == "hiding"
			or extrafunc == "countinghide"
			or p.exiting
				timex, timey = unpack(takis.HUD.timer.finished)
			end
			v.drawString(timex, timey, hours..extrac..minutes..":"..spad..seconds.."."..tictrn..tpad,V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER|flashflag,"thin-right")
			v.drawString(timetx, timey, "Time"..extra,V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER|flashflag,"thin")
			if extratext ~= ''
				v.drawString(timetx, timey+8, extratext,V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER|flashflag,"thin")			
			end
			
			//score
			v.drawString(300-15, 15, p.score,V_SNAPTORIGHT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER,"right")
			
			//clutch bar
			if takis.clutchtime > 0
				drawclutchbar(v,p,me,takis)
			end
			//clutch combo
			if takis.clutchcombo
				v.drawString(hudinfo[HUD_LIVES].x, hudinfo[HUD_LIVES].y-20, takis.clutchcombo.."x BOOSTS",V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_HUDTRANS|V_PERPLAYER|V_ALLOWLOWERCASE)			
			end

			local combdisp = 8
			local comby = 14
			if p.pflags & PF_FINISHED
				comby = $+16
			end
			
			//combo stuff
			if takis.combo.count
			or takis.combo.outrotics
				local add
				local shake = takis.HUD.combo.meter.shake
				
				if takis.combo.outrotics
					add = takis.combo.outro
				else
					add = takis.combo.intro
				end
				drawcombotimebar(v,p,me,takis,comby,add,shake)
				local meterx,metery = unpack(takis.HUD.combo.meter.FIXED)
				local numx,numy = unpack(takis.HUD.combo.num.int)
				v.drawScaled(meterx,metery+(comby*FU)+add+(shake),6*FU/5,v.cachePatch("TAKCOBACK"),V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER, v.getColormap(nil, nil))
				v.drawNum(numx,numy+comby+(add/FU)+(shake/FU),takis.combo.count,V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER)
				v.drawString((hudinfo[HUD_RINGS].x+18+combdisp+6)*FU,(hudinfo[HUD_RINGS].y+20+comby)*FU+(add)+(shake),"Combo!",V_HUDTRANS|V_ALLOWLOWERCASE|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER,"thin-fixed")
				
				if takis.combo.verylevel > 0
					for i = 1, takis.combo.verylevel
						
						local verypatch = v.cachePatch("TAKCOVERY")
						//if not (i % 2)
						//	verypatch = v.cachePatch("TAKCOSUPR")
						//end
						v.drawScaled(meterx+(7*FU)+(i*(3*FU)),metery+(37*FU)+(i*2*FU)+(comby*FU)+add,FU/3,verypatch,V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER, v.getColormap(nil, color))
						
					end
				end
				
				local length = #TAKIS_COMBO_RANKS
				v.drawString((hudinfo[HUD_RINGS].x+18+combdisp+6+10)*FU,(hudinfo[HUD_RINGS].y+20+35+comby)*FU+(add),TAKIS_COMBO_RANKS[ ((takis.combo.rank-1) % length)+1 ],V_HUDTRANS|V_ALLOWLOWERCASE|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER,"thin-fixed-center")
				
			end
			
				//aliments
				//so minhud!
				TakisDrawAliments(
					v, p, -- Self explanatory.
					(hudinfo[HUD_LIVES].x+60)*FU, (hudinfo[HUD_LIVES].y)*FU, FU/2, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_HUDTRANS, -- Powerups X & Y. Scale. Flags.
					8*FU, 170*FU, 'thin-fixed-center', -- Timed powerups string X & Y & alignment. Relative to the powerup they're related to.
					17*FU, 0 -- Distance to shift and which angle to do so.
				)
			//srb2 styled hud
			else
				
				if not (customhud)
				and not PSO
					if not hud.enabled("lives")
						hud.enable("lives")
					end
					if not hud.enabled("rings")
						hud.enable("rings")
					end
					if not hud.enabled("time")
						hud.enable("time")
					end
					if not hud.enabled("score")
						hud.enable("score")
					end
					
				end

				//clutch bar
				if takis.clutchtime > 0
					drawclutchbar(v,p,me,takis)
				end
				//clutch combo
				if takis.clutchcombo
					v.drawString(hudinfo[HUD_LIVES].x, hudinfo[HUD_LIVES].y-20, takis.clutchcombo.."x BOOSTS",V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_HUDTRANS|V_PERPLAYER|V_ALLOWLOWERCASE)			
				end

			
			end
		else
			
			//if gametyperules & GTR_FRIENDLY
			//and not G_RingSlingerGametype()
			if not (customhud)
			and not PSO
				if not hud.enabled("lives")
					hud.enable("lives")
				end
				if not hud.enabled("rings")
					hud.enable("rings")
				end
				if not hud.enabled("time")
					hud.enable("time")
				end
				if not hud.enabled("score")
					hud.enable("score")
				end
				
			end
			
			//elfilin stuff
			if me.skin == "elfilin"
				//check out my sweet new ride!
				local ride = p.elfilin.ridingplayer
				
				if p.elfilin
				and ((ride) and (ride.valid))

					local p2 = ride.player
					local takis2 = p2.takistable
					
					if ride.skin == TAKIS_SKIN
						
						//show p2's combo
						if takis2.combo.count
							
							local shake = takis2.HUD.combo.meter.shake
							local combdisp = 8
							local comby = 14
							if p2.pflags & PF_FINISHED
								comby = $+16
							end
							comby = $+10
							
							v.drawString((hudinfo[HUD_RINGS].x+18+combdisp+6+10)*FU,(hudinfo[HUD_RINGS].y+20+35+comby-55)*FU,p2.name.."'s Combo",V_HUDTRANS|V_ALLOWLOWERCASE|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER,"thin-fixed-center")
							
							drawcombotimebar(v,p,me,takis2,comby,0,shake)
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
									v.drawScaled(meterx+(7*FU)+(i*(3*FU)),metery+(37*FU)+(i*2*FU)+(comby*FU)+add,FU/3,verypatch,V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER, v.getColormap(nil, color))
									
								end
							end
							
							local length = #TAKIS_COMBO_RANKS
							v.drawString((hudinfo[HUD_RINGS].x+18+combdisp+6+10)*FU,(hudinfo[HUD_RINGS].y+20+35+comby)*FU,TAKIS_COMBO_RANKS[ ((takis2.combo.rank-1) % length)+1 ],V_HUDTRANS|V_ALLOWLOWERCASE|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER,"thin-fixed-center")
							
						end
						
					end
					
				end
				
			end
			
		end
		
	end
	
end,"game")
