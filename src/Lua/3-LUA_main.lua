/*
	--CODE TODO
	-[done]afterimages. not pt, antone blast :)
	-[done]wavedashing lol (nick wants this)
	-[done]fix up sort hitbox (uughghhh)
	-[done]combo stuff (ghiugdjk)
	-[done]erm, death messages
	-[done]make sure stuff slike clutch works in nonfriendly w/o ff
	-[done]hide hud in specialstages
	-[done]alt yellow for combo meter
	-do hud styles like modernsonic and toggling like mrce
	-[done]add sunstroke. already got the texasarea net
	-[done]port hud stuff to customhud
	-[done]give spikeballs a deathstate
	-[done]make freezing actually kill you
	-[done]freeze combo while finished in pizza time
	-[done]movecollide for springs to keep momentum (booster boost)
	-[done]stupid thinkframe for detecting PF_SLIDING
	-[done]also make speedpad sectors keep momentum
	-[done]reuse soap code for ptje ranks
	-[scrapped]wall bonk lol
	-add bot stuff
	-[done]happy hour for other skins?
	-[done]fc stuff?
	-[done]custom arma to bbreak more stuff (like spikes)
	-[done]PASSWORD!!!
	-[done]make recov jump not rely on flashing
	-[done]dont kill team boxes on other teams
	-[done]conga?
	-[done]string the combo bar into 1, long graphic, use cropped to crop?
	-[done]tf2 taunt menu1
	-[scrapped]countdown nums for drawtimer
	-[done?]instant finishes in multiplayer, prob after a special stage, most
	 noticable in stages with capsules
	-[done]make heartcards give score at the end
	-[done]maybe increase the homerun bat hitbox? because, yknow, the hammer
	 is big
	-[done]cursor style for the taunt menu, nums <-> cursor
	-[done? what was this referring to?]crit sfx
	-[scrapped]war timer and war timer custom gfx
	-[done]RETRO STATUSFACE FOR MARIO TOLS
	-[done]save after loading to remove invalid saves
	-[done]save during exiting
	-finish death anims
	-[done]cosmenu like soap's
	-[scapped]homework varient of happy hour
	-[done]toggle for loud and dangerous taunts
	-taunt_t info?
	-rs neo stuff for taunt functions
	-[done]fix io quicktaunts being broken
	-dont let quick taunts spam "you cant do this"
	-[done]MORE WIND LINES
	-[done]little icon above people with cosmenus open'
	-[done]cosmenu "dear pesky plumbers..." letter
	-[done? what was this reffering to?]update customhud init funcs
	-[done]find out whats making the erz1 fof conveyors hyperspeed
	-[done]only sweat if we're running
	-[scapped]make a function to add takis_menu pages
	-[scrapped]move all hud related code in shorts to their respective hud
	 drawing function
	 actually,, maybe dont, thatll make it fps dependant
	-[scrapped]spingebobb #1 hat option
	-[done]add cosmenu scolling
	-[done]when counting num destroyables, add a var to the mobj to mark it
	 as yet-to-be-destroyed. only increase thingsdestroyed if that
	 var is true
	-[done]make sure shields function properly
	-[scrapped]optional paperdoll over statusface
	-[done]pw_strong?
	-[done]still break other types of "spikes" alongside STR_SPIKE
	-[scrapped]milne kick
	-[done]taunt icons
	-ach icons
	-[done]move all takis.HUD editting code from LUA_hud to TakisHUDStuff
	-[scrapped]set takis.issuperman to random when nightserized, if true,
	 spawn a superman cape
	-[scrapped]if the Verys draw past the bottom of the screen, only draw 1 and
	 put a x3240 for the # of Verys
	-maybe give all hud elements V_PERPLAYER??
	-[done]fix the clutch being slow with smaller scales
	-MORE EFFECTS!!
	-placements in drawscore?
	-[done]happy hour trigger and exit objects
	-[done??]dedicated servers may be breaking heart cards?
	-[done]rings give too much score
	-[done?]we may be loading other people's cfgs??
	-[done]offset afterimages to start at salmon
	-[done?]sometimes shotgun shots dont give combo?
	-[done]cap clutch boosts at 5
	-[done]linedef trigger to open dialog
	-[done]pt spice runners support
	-[done]replace menu patches with drawfill
	-[done?]takisfest ach being buggy as hell, keeps doign every tiem
	-[done]redo the cos menu. antonblast styled?
	-[done]remove disciplinary action
	-[done]happy hour is weird when it is synched
	-replace hud items only when switching, like engi
	-cosmenu scrolling if text goes past hints
	-[done?]sometimes the PTSR bar doesnt show with nohappyhour?
	-[done]synch happy hour for joining players
	-[done]transformations
	-[scrapped]bat taunt keeps colorization if interuppted
	-[scrapped]textspectator hud stuff
	-[pretty much done]shields are squished with pancake
	-[done?]wtf is resynching & crashing servers!?? DEBUG!!!!
	-[done?]death slam not activating sometimes
	-[done]remove fc stuf
	-fling solids kill stuff
	-[done]thoks respawn flung solids
	-[done]switch all the takismusic funcs back to normal S_Sound stuff
	-[done]happy hour quakes not working
	-[done]bubbles reset state and stuff
	-[done]use takis.HUD.flyingscore to align all the rank stuff
	-[done?]2d mode is SHIT!! fix weird state bugs
	-[done?]SHIT IS STILL RESYNCHING!!
	-[done]fireass in nights freeroam
	-hitlag?
	-[done]clutch speed adjustmensts fro 2d & underwater
	-[done]killing blow sfx when clutching into
	-[done]ambush makes shotgun boxes gold
	-[done]metal detector to remove shotgun
	-[done]happyhour mus vars arent used in musichange if hh is activated
	 on spawn
	-battlemod stuff
	-[done]you can still clutch in waterslides
	-[done?]make gibs face screen in 2d instead of being a straight line
	-udmf arguments for all the mapthings
	-[done]bots can give takis leaders combo
	-[done]ujl coop score thing for combo sharing
	-[done but better]make the server execute a command when cheats are activated to
	 set a var in TAKIS_NET
	-[done]replace all dust effects with the cool funny takis_steam
	-[done]the weird *[Splash] bug with dustdevils
	-[done]make shotgun scatters their own MT_
	-mt_gunshot sprites
	-birdword timing and 2nd part
	-[done]skidding spawn takis dust
	-[done]no afterimages when clutching out of a slide
	-[done]no pt happy hour is broken
	
	--ANIM TODO
	-redo smug sprites
	-reuse spng for jump
	-the tail on roll frames doesnt point the right way
	-redo walk 4th angle
	-retro faces for the new faces
	-[done]redo tailees dead
	
	--PLANNED MAPHEADERS
	-[done]Takis_HH_Music - regular happyhour mus, ignore styles
	-[done]Takis_HH_EndMusic - ending happyhour mus, ignore styles
	-[done]Takis_HH_NoMusic - disable happyhour mus
	-[done]Takis_HH_NoEndMusic - disable happyhour end mus
	-[done]Takis_HH_Timelimit - timelimit (in seconds)
	-[done]Takis_HH_NoInter - disable the intermission screen
	-[done]Takis_HH_NoHappyHour - disable allhappyhour from doin the lvl
	-Takis_HH_NoClang - disable mysterious clanging
	-[done]Takis_HH_Exit_[x,y,z] - exit pos
	-[done]Takis_HH_Trig_[x,y,z] - trigger pos
	
	--OTHER SHIT
	-update map for new transfos and fix stuff
	
*/

--leave some invuln for the rest of the cast, you greedy jerk!
local flashingtics = flashingtics/2

--thanks katsy for this function
local function stupidbouncesectors(mobj, sector)
    for fof in sector.ffloors()
        if not (fof.fofflags & FOF_BOUNCY) and (GetSecSpecial(fof.master.frontsector.special, 1) != 15)
            continue
        end
        if not (fof.fofflags & FOF_EXISTS)
            continue
        end
        if (mobj.z+mobj.height+mobj.momz < fof.bottomheight) or (mobj.z-mobj.momz > fof.topheight)
            continue
        end
        return true
    end
end
local function choosething(...)
	local args = {...}
	local choice = P_RandomRange(1,#args)
	return args[choice]
end

--from clairebun
local function L_ZCollide(mo1,mo2)
	if mo1.z > mo2.height+mo2.z then return false end
	if mo2.z > mo1.height+mo1.z then return false end
	return true
end
local function collide2(me,mob)
	if me.z > (mob.height*2)+mob.z then return false end
	if mob.z > me.height+me.z then return false end
	return true
end
--lazy
local function spawnragthing(tm,t,source)
	SpawnRagThing(tm,t,source)
end
local function LaunchTargetFromInflictor(type,target,inflictor,basespeed,speedadd)
	if (string.lower(type) == "instathrust") or type == 1
		P_InstaThrust(target, R_PointToAngle2(inflictor.x, inflictor.y, target.x, target.y), basespeed+(speedadd))
	else
		P_Thrust(target, R_PointToAngle2(inflictor.x, inflictor.y, target.x, target.y), basespeed+(speedadd))
	end
end
--also lazy
local function MeSoundHalfVolume(sfx,p)
	S_StartSoundAtVolume(nil,sfx,4*255/5,p)
end

--buggie gave me this
local function peptoboxed(mobj)
	if mobj.player.pep and mobj.skin == "peppino"
		mobj.player.height = mobj.player.spinheight
		mobj.player.mo.radius = 3*skins[mobj.skin].radius/2
		mobj.player.pflags = $&~PF_SPINNING
		  
		if not mobj.player.pep.transfo
			PT_SpawnEffect(mobj,"sfx_peppino_transform") --Custom peppino function, would not work
			mobj.player.pep.transfoappear = 16
		end
		PT_SpawnEffect(mobj,"poof") --Custom peppino function, would not work
		mobj.player.pep.transfo = "box"
		mobj.player.pep.transfovars = {}
		mobj.state = S_BOXPEP_TRNS
		mobj.player.pep.transfovars["transanimtime"] = 20
		mobj.player.pep.transfotime = 30*TICRATE
		mobj.player.jumpfactor = 2*skins[mobj.skin].jumpfactor/3
	end
end

local ranktonum = {
	["P"] = 6,
	["S"] = 5,
	["A"] = 4,
	["B"] = 3,
	["C"] = 2,
	["D"] = 1,
}

--"Trust me, I'm a programmer."
local emdex = {
	[0] = 0,
	[EMERALD1] = 1,
	[EMERALD1|EMERALD2] = 2,
	[EMERALD1|EMERALD2|EMERALD3] = 3,
	[EMERALD1|EMERALD2|EMERALD3|EMERALD4] = 4,
	[EMERALD1|EMERALD2|EMERALD3|EMERALD4|EMERALD5] = 5,
	[EMERALD1|EMERALD2|EMERALD3|EMERALD4|EMERALD5|EMERALD6] = 6,
}

addHook("PreThinkFrame",function()
	for p in players.iterate
		if not p
		or not p.valid
			continue
		end
		
		--p.HAPPY_HOURscream = {}
		
		if not p.takistable
			continue
		end
		
		local takis = p.takistable
		
		--handle input stuff here now because ermmmm
		--pw_nocontrol stuff
		
		if takis.noability
			takis.noability = 0
		end
		if (p.takis_noabil ~= nil)
			takis.noability = $|p.takis_noabil
			takis.lastminhud = takis.io.minhud
			takis.io.minhud = 0
		end
		
		TakisButtonStuff(p,takis)
		
		if (takis.cosmenu.menuinaction)
			TakisMenuThinker(p)
		end
		
		if (takis.transfo & TRANSFO_TORNADO)
		and not (takis.nadocrash)
			local force = 50
			--brake a bit
			if P_GetPlayerControlDirection(p) == 2
				force = $-((25-p.cmd.forwardmove)/2)
				force = min(50,$)
			end
			p.cmd.forwardmove = force
			p.cmd.sidemove = $/2
		end
		
	end
end)

addHook("PlayerThink", function(p)
	if not p
	or not p.valid
		return
	end
	
	if not p.takistable
		TakisInitTable(p)
		--return
	end
	
	if not p.takistable.io.loaded
		if p.takistable.io.loadwait
			p.takistable.io.loadwait = $-1
		else
			TakisLoadStuff(p)
		end
	end
	
	if not (p.takistable.io.loadedach)
		p.takistable.io.loadedach = true
		TakisLoadAchievements(p)
	end
	
	--whatev
	p.takistable.isTakis = skins[p.skin].name == TAKIS_SKIN
	TakisHappyHourThinker(p)
	
	if ((p.realmo) and (p.realmo.valid))
		local me = p.realmo
		local takis = p.takistable
		
		if (not p.exiting)
		and takis.camerascale
			p.camerascale = takis.camerascale
			takis.camerascale = nil
		end
		
		if p.takis
		and (takis.isTakis)
			--shotgun monitor
			if p.takis.shotgunnotif
				if (takis.c3)
					CFTextBoxes:DisplayBox(p,TAKIS_TEXTBOXES.shotgunnotif)
					p.takis.shotgunnotif = 1
				end
				p.takis.shotgunnotif = $-1
			else
				p.takis = nil
			end
		end
		
		TakisBooleans(p,me,takis,TAKIS_SKIN)
		--more accurate speed thing
		takis.accspeed = FixedDiv(abs(FixedHypot(p.rmomx,p.rmomy)), me.scale)
		takis.gravflip = P_MobjFlip(me)
		
		if me.skin == TAKIS_SKIN
			
			/*
			takis.HUD.happyhour.its.patch = "TAHY_ITS"
			takis.HUD.happyhour.happy.patch = "TAHY_HAPY"
			takis.HUD.happyhour.hour.patch = "TAHY_HOUR"
			*/
			
			local shouldntcontinueslide = false
			--if something youre looking for isnt here, theres a good
			--chance that its in shorts!
			TakisDoShorts(p,me,takis)
			
			takis.afterimaging = false
			takis.applyfriction = true
			
			--skin name then sfx
			p.happyhourscream = {skin = TAKIS_SKIN,sfx = sfx_hapyhr}
			
			--just switched
			if (takis.otherskin)
				takis.otherskin = false
				takis.otherskintime = 0
			end
			
		
			if not (p.powers[pw_invulnerability])
				p.scoreadd = 0
			end
			
			/*
			if takis.c3 == 1
				for i = 0,6
					local soda = P_SpawnMobjFromMobj(me,0,0,0,MT_TAKIS_SPIRIT)
					soda.tracer = me
					soda.emeralddex = i
					takis.spiritlist[soda.emeralddex] = soda
				end
			end
			*/
			
			--dude stop!!!
			if (p.charflags & SF_SUPER)
				p.charflags = $ &~SF_SUPER
			end
			
			--forced strafe
			if takis.io.nostrafe == 0
			and (takis.notCarried)
			and not ((p.pflags & (PF_SPINNING|PF_STASIS))
			or (p.powers[pw_nocontrol] or takis.nocontrol))
			and (takis.notCarried)
			and not (takis.dived and me.state == S_PLAY_GLIDE)
				p.drawangle = me.angle
			end
			
		 	if (takis.dived and me.state == S_PLAY_GLIDE)
				p.drawangle = R_PointToAngle2(0,0,me.momx,me.momy)
			end
			
			if (takis.bashtime)
				takis.bashtime = $-1
				takis.noability = $|NOABIL_SLIDE|NOABIL_SHOTGUN
				local doswitch = true
				if (me.state == S_PLAY_JUMP)
					me.state = S_PLAY_TAKIS_SHOULDERBASH_JUMP
					doswitch = false
				end
				
				if (me.state == S_PLAY_TAKIS_SHOULDERBASH)
					if (me.tics > takis.bashtics)
					and (me.tics ~= takis.bashtics)
					and (takis.bashtics >= 4)
						me.tics = takis.bashtics-4
					end
					takis.bashtics = me.tics
				end
				
				
				local instates = (me.state == S_PLAY_TAKIS_SHOULDERBASH) or (me.state == S_PLAY_TAKIS_SHOULDERBASH_JUMP)
				if not instates
				and doswitch
					takis.bashtime = 0
				end
				
				if (takis.accspeed <= 15*FU)
					me.state = S_PLAY_WALK
					P_MovePlayer(p)
					S_StopSoundByID(me,sfx_shgnbs)
					takis.bashtime = 0
					takis.bashcooldown = true
				end
				
			else
				if takis.bashtics ~= 0
					takis.bashtics = 0
				end
			end
	
			--nights stuff
			if (maptol & TOL_NIGHTS)
				if not multiplayer
					if p.powers[pw_carry] == CR_NIGHTSMODE
						if HAPPY_HOUR.happyhour
							if p.exiting
								takis.nightsexplode = true
								HH_Reset()
								P_RestoreMusic(p)
							end
						end
					elseif (p.powers[pw_carry] ~= CR_NIGHTSMODE)
					or (p.powers[pw_carry] == CR_NIGHTSFALL)
						if HAPPY_HOUR.happyhour
						and not p.nightstime
							if p.exiting
								takis.nightsexplode = true
								HH_Reset()
								P_RestoreMusic(p)
							end
						end
					
					end
					
					/*
					if HAPPY_HOUR.happyhour
					and not (takis.gotspirit and takis.gotspirit.valid)
					and (emdex[emeralds] ~= nil)
						takis.gotspirit = P_SpawnMobjFromMobj(me,0,0,0,MT_TAKIS_SPIRIT)
						--i would use some bitmath but i cant figure
						--out exactly how to get the decimal
						takis.gotspirit.emeralddex = emdex[emeralds]
						takis.gotspirit.tracer = me
					end
					*/
				end
				if p.powers[pw_carry] == CR_NIGHTSMODE
					
					if (p.exiting)
						
						--fancy explosions for HH
						if takis.nightsexplode
							
							--exiting starts at 99
							print("a")
							print(p.exiting)
							print(max(2,50-(p.exiting/2)))
							if P_RandomChance(
								FU/
								(
									max(2,50-(p.exiting/2))
								)
							)
								local fa = FixedAngle(P_RandomRange(0,360)*FU)
								local x,y = ReturnTrigAngles(fa)
								local range = 300
								local xvar = 50*P_RandomRange(1,2)
								local yvar = 50*P_RandomRange(1,2)
								local thok = P_SpawnMobjFromMobj(me,
									range*x+P_RandomRange(-yvar,yvar)*me.scale,
									range*y+P_RandomRange(-yvar,yvar)*me.scale,
									P_RandomRange(-yvar,yvar)*me.scale,
									MT_THOK
								)
								thok.scale = P_RandomRange(1,5)*FU+P_RandomFixed()
								thok.flags2 = $|MF2_DONTDRAW
								A_BossScream(thok,1,choosething(MT_BOSSEXPLODE,MT_SONIC3KBOSSEXPLODE))
								
								local sfx = P_SpawnGhostMobj(thok)
								sfx.flags2 = $|MF2_DONTDRAW
								sfx.tics = TR
								sfx.fuse = TR
								S_StartSound(sfx,sfx_tkapow)
							end
						end
						
						if (p.exiting <= 45)
						and (me.health)
						--ends your run?
						and not ultimatemode
							P_KillMobj(me)
							S_StopSoundByID(me,skins[TAKIS_SKIN].soundsid[SKSPLDET4])
							me.frame = A
							me.sprite2 = SPR2_TDED
							for i = 1, 6
								A_BossScream(me,1,MT_SONIC3KBOSSEXPLODE)
							end
							S_StartSound(me,sfx_tkapow)
							DoQuake(p,me.scale*8,10,8*me.scale)
							takis.altdisfx = 3
							
						end
					end
				end
			else
				if (takis.nightsexplode)
					takis.nightsexplode = false
				end
			end
			
			--add ffoxD's FFDMomentum here because its awesome
			if (p.cmd.forwardmove or p.cmd.sidemove)
			and p.normalspeed <= takis.accspeed
			and me.friction < FU
				me.friction = FU
			end
			
			if me.friction > 29*FU/32
				--if not (leveltime % 4)
				if takis.onGround
				and not p.powers[pw_sneakers]
					me.friction = $-(FU/200)
				end
			end
			
			--spin specials
			if takis.use > 0
			and p.powers[pw_carry] ~= CR_NIGHTSMODE
			
				if (not takis.shotgunned)
					--clutch
					if takis.use == 1
					/*
					and (takis.onGround or 
					(takis.coyote/2 > 0
					and not (p.pflags & (PF_JUMPED|PF_JUMPSTASIS|PF_THOKKED))))
					*/
					and (takis.onGround)
					and not takis.taunttime
					and me.health
					and (me.state ~= S_PLAY_GASP)
					and (me.sprite2 ~= SPR2_PAIN)
					and not PSO
					and not (takis.yeahed)
					and (p.realtime > 0)
					and not (takis.c2 and me.state == S_PLAY_TAKIS_SLIDE)
					and not (takis.noability & NOABIL_CLUTCH)
						
						TakisDoClutch(p)
						
					end
					
					--hammer blast
					if takis.use == (TR/5)
					and not takis.onGround
					and not takis.hammerblastdown
					and not (takis.inPain or takis.inFakePain)
					and me.health
					and (takis.notCarried)
					and not (takis.noability & NOABIL_HAMMER)
						S_StartSoundAtVolume(me,sfx_airham,3*255/5)
						takis.hammerblastdown = 1
						p.pflags = $|PF_THOKKED
						takis.thokked = true
						L_ZLaunch(me,
							10*FU*skins[TAKIS_SKIN].jumpfactor
						)
						me.state = S_PLAY_MELEE
						me.tics = -1
						takis.hammerblastangle = p.drawangle
						p.pflags = $ &~PF_SHIELDABILITY
						--P_SetObjectMomZ(me,-9*FU)
					end
					
					--wavedash
					if takis.c3 == 1
					and takis.use < 13
					and takis.wavedashcapable
					and not (takis.noability & NOABIL_WAVEDASH)
						p.pflags = $ &~(PF_JUMPED)
						P_SetObjectMomZ(me,-8*FRACUNIT)
						local ang = GetControlAngle(p)
						S_StartSoundAtVolume(me,sfx_takdiv,255/4)
						P_Thrust(me,ang,14*me.scale)
					end
				else
					
					--shotgun shot
					if ((takis.use and TAKIS_NET.chaingun)
					or (takis.use == 1 and not TAKIS_NET.chaingun))
					and not (takis.shotguncooldown and not TAKIS_NET.chaingun)
					and not (takis.inPain or takis.inFakePain)
					and not (takis.noability & NOABIL_SHOTGUN
					or p.pflags & PF_SPINNING)
						if (not TAKIS_NET.chaingun)
							P_Thrust(me,p.drawangle,-10*me.scale)
							P_MovePlayer(p)
							
							takis.shotguncooldown = 18
						else
							if takis.use == 1
								P_Thrust(me,p.drawangle,-10*me.scale)
								P_MovePlayer(p)
								TakisAwardAchievement(p,ACHIEVEMENT_RIPANDTEAR)
							end
						end
						
						S_StartSound(me,sfx_shgns)
						
						TakisDoShotgunShot(p)
					end
					
				end	
				
			end
			
			--c1 specials
			if takis.c1 > 0
			and p.powers[pw_carry] ~= CR_NIGHTSMODE
			
				if not takis.shotgunned
					--dive
					--not to be confused with soap's dive!
					--mario dive
					if takis.c1 == 1
					and not takis.onGround
					and not (takis.dived)
					and (takis.notCarried)
					and me.state ~= S_PLAY_PAIN
					and me.health
					and not takis.hammerblastdown
					and not PSO
					and not (takis.noability & NOABIL_DIVE)
						takis.hammerblastjumped = 0
					
						local ang = GetControlAngle(p)
						S_StartSound(me,sfx_takdiv)
						
						--im not sure if this actually does anything
						--but it seems to work so im leaving it
						if ((me.flags2 & MF2_TWOD)
						or (twodlevel))
							if (p.cmd.sidemove > 0)
								ang = p.drawangle
							elseif (p.cmd.sidemove < 0)
								ang = InvAngle(p.drawangle)
							end
						end
						
						P_InstaThrust(me,ang,FixedMul(20*FU+(3*takis.accspeed/5),me.scale))
						
						p.drawangle = ang
						--CreateWindRing(p,me)
						TakisSpawnDustRing(me,16*me.scale,0)

						p.pflags = $|PF_THOKKED &~(PF_JUMPED)
						takis.dived = true
						takis.thokked = true
						
						me.state = S_PLAY_GLIDE
						local momz = FixedDiv(me.momz,me.scale)*takis.gravflip
						local thrust = min((momz/2)+7*FU,18*FU)
						L_ZLaunch(me,thrust)
					end
					
				else
				
					--shoulder bash
					if takis.c1 == 1
					and not (takis.tossflag)
					and not takis.bashtime
					and not (takis.inPain or takis.inFakePain)
					and not (takis.hammerblastdown)
					and (me.state ~= S_PLAY_TAKIS_SLIDE)
					and not (takis.noability & NOABIL_SHOTGUN)
					and (takis.notCarried)
					and not takis.bashcooldown
						local ang = GetControlAngle(p)
						if ((me.flags2 & MF2_TWOD)
						or (twodlevel))
							if (p.cmd.sidemove > 0)
								ang = p.drawangle
							elseif (p.cmd.sidemove < 0)
								ang = InvAngle(p.drawangle)
							end
						end
						p.drawangle = ang
						
						if (takis.accspeed >= skins[TAKIS_SKIN].runspeed)
							P_InstaThrust(me,p.drawangle,
								FixedMul(takis.accspeed,me.scale)
								+
								23*me.scale
							)
						else
							P_InstaThrust(me,p.drawangle,
								FixedMul(takis.accspeed,me.scale)+
								FixedMul(
									skins[TAKIS_SKIN].runspeed-takis.accspeed,
									me.scale
								)
							)
							
						end
						S_StartSound(me,sfx_shgnbs)
						P_MovePlayer(p)
						if (me.momz*takis.gravflip < 0)
							L_ZLaunch(me,3*FU)
						end
						me.state = S_PLAY_TAKIS_SHOULDERBASH
						
						takis.bashtime = TR
						
					end
					
				end
				
			end
			
			--quick taunts
			if ((takis.tossflag > 0) and ((takis.c2 > 0) or (takis.c3 > 0)))
			and takis.onGround
			and p.panim == PA_IDLE
			and takis.taunttime == 0
			and not takis.yeahed
			and not (takis.tauntmenu.open)
				if ((takis.c2) and (not takis.c3))
					if takis.tauntquick1
						if ((TAKIS_TAUNT_INIT[takis.tauntquick1] ~= nil)
						and (TAKIS_TAUNT_THINK[takis.tauntquick1] ~= nil))
							takis.tauntid = takis.tauntquick1
						
							--init func
							local func = TAKIS_TAUNT_INIT[takis.tauntquick1]
							func(p)
							
						else
							if (takis.c2 == 1)
								S_StartSound(nil,sfx_notadd,p)
							end
						end
					else
						if (takis.c2 == 1)
							S_StartSound(nil,sfx_notadd,p)
						end
					end
				elseif ((takis.c3) and (not takis.c2))
					if takis.tauntquick2
						
						if ((TAKIS_TAUNT_INIT[takis.tauntquick2] ~= nil)
						and (TAKIS_TAUNT_THINK[takis.tauntquick2] ~= nil))
							takis.tauntid = takis.tauntquick2
						
							--init func
							local func = TAKIS_TAUNT_INIT[takis.tauntquick2]
							func(p)
							
						else
							if (takis.c3 == 1)
								S_StartSound(nil,sfx_notadd,p)
							end
						end
					else
						if (takis.c3 == 1)
							S_StartSound(nil,sfx_notadd,p)
						end
					end
				end
			end
			
			--tf2-styled taunt menu!
			if not (takis.tauntmenu.open)
				local menu = takis.tauntmenu
				menu.tictime = 0
				
				if ((takis.tossflag) and (takis.c1))
				and not ((takis.yeahed) or (takis.taunttime))
				and not p.spectator
					menu.yadd = 500*FU
					menu.open = true
				end
				
				menu.cursor = 1
				
			else
				local menu = takis.tauntmenu
				menu.tictime = $+1
				
				if not menu.closingtime
					--close
					if takis.c1 == 1
						menu.closingtime = TR/2
					end
					
					if (takis.io.tmcursorstyle == 2)
						if (takis.weaponnext == 1)
							if (menu.cursor < 7)
								menu.cursor = $+1
							end
						end
						if (takis.weaponprev == 1)
							if (menu.cursor > 1)
								menu.cursor = $-1
							end
						end
					end
					
					local num = takis.weaponmask
					if (takis.io. tmcursorstyle == 2)
						num = menu.cursor
					end
					local id = menu.list[takis.weaponmask or menu.cursor]
					
					--set quick taunts
					if takis.tossflag
						
						--slot one
						if (takis.c2 == 1)
							--remove
							--delete quicktaunt
							if takis.fire
							and takis.tauntquick1
								takis.tauntquick1 = 0
								S_StartSound(nil,sfx_adderr,p)
								TakisSaveStuff(p)
							else
								local selectable = true
								if ((id == "") or (id == nil))
								or ((TAKIS_TAUNT_INIT[takis.weaponmask] == nil) or (TAKIS_TAUNT_THINK[takis.weaponmask] == nil))
									selectable = false
								end
								
								if selectable
								and takis.weaponmasktime
								and (takis.tauntquick1 ~= takis.weaponmask)
								and (takis.weaponmask ~= takis.tauntquick2)
									S_StartSound(nil,sfx_addfil,p)
									takis.tauntquick1 = takis.weaponmask
									TakisSaveStuff(p)
								end
							end
						--slot two
						elseif (takis.c3 == 1)
							--remove
							if takis.fire
							and takis.tauntquick2
								takis.tauntquick2 = 0
								S_StartSound(nil,sfx_adderr,p)
								TakisSaveStuff(p)
							else
								local selectable = true
								if ((id == "") or (id == nil))
								or ((TAKIS_TAUNT_INIT[takis.weaponmask] == nil) or (TAKIS_TAUNT_THINK[takis.weaponmask] == nil))
									selectable = false
								end
								
								if selectable
								and takis.weaponmasktime
								and (takis.tauntquick2 ~= takis.weaponmask)
								and (takis.weaponmask ~= takis.tauntquick1)
									S_StartSound(nil,sfx_addfil,p)
									takis.tauntquick2 = takis.weaponmask
									TakisSaveStuff(p)
								end
							end
						
						end 
					else
						--choose the taunt!
						if not (takis.c3)
							num = takis.weaponmask
							if (takis.io. tmcursorstyle == 2)
								num = menu.cursor
							end
							
							local selectable = true
							if ((id == "") or (id == nil))
							or ((TAKIS_TAUNT_INIT[num] == nil) or (TAKIS_TAUNT_THINK[num] == nil))
								selectable = false
							end
							
							if ( ((takis.weaponmasktime == 1) and (takis.io.tmcursorstyle == 1))
							or ((takis.firenormal == 1) and (takis.io.tmcursorstyle == 2)) )
							and selectable
							and takis.onGround
								
								takis.tauntid = num
								
								--init func
								local func = TAKIS_TAUNT_INIT[num]
								func(p)
								
								--close
								menu.open = false
							end
						--we're joining a partner taunt!
						elseif ((takis.c3 == 1) and not takis.tossflag)
							
							for p2 in players.iterate
								if p2 == p
									continue
								end
								
								local m2 = p2.realmo
								
								local dx = me.x-m2.x
								local dy = me.y-m2.y
								
								--in range!
								if FixedHypot(dx,dy) <= TAKIS_TAUNT_DIST
									if skins[p2.skin].name == TAKIS_SKIN
										if p2.takistable.tauntjoinable
										
											--we want their taunt number!
											takis.tauntid = p2.takistable.tauntid
											
											if (p2.takistable.tauntacceptspartners)
												takis.tauntpartner = p2
												p2.takistable.tauntpartner = p
											end
											
											local func = TAKIS_TAUNT_INIT[p2.takistable.tauntid]
											func(p)
											
											--close
											menu.open = false
										end
									elseif skins[p2.skin].name == "inazuma"
										--Holy MOLY!
										CFTextBoxes:DisplayBox(p,TAKIS_TEXTBOXES.ultzuma)
										
										menu.open = false
									end
								end
								
							end
						end
					end
				--closing anim
				else
					menu.closingtime = $-1
					if menu.closingtime == 1
						menu.open = false
					end
				end
			end
			
			--c2 specials
			if takis.c2 > 0
			
				--slide
				if takis.c2 == 1
				and takis.onGround
				and not (p.pflags & PF_SPINNING)
				and takis.taunttime == 0
				and not takis.yeahed
		--		and (p.realtime > 0)
				and me.health
				and not ((takis.tauntmenu.open) and (takis.tossflag))
				and not (takis.inwaterslide or takis.resettingtoslide)
				and not (takis.noability & NOABIL_SLIDE)
					S_StartSound(me,sfx_eeugh)
					S_StartSound(me,sfx_taksld)
					P_InstaThrust(me,p.drawangle,FixedMul(20*FU+(4*takis.accspeed/5),me.scale))
					me.state = S_PLAY_TAKIS_SLIDE
					p.pflags = $|PF_SPINNING
					P_MovePlayer(p)
					if not ((p.cmd.forwardmove) and (p.cmd.sidemove))
					and takis.accspeed < 13*FU
						takis.slidetime = max(1,$)
						P_InstaThrust(me,p.drawangle,15*me.scale)
					end
					
				end
				
				--cash in combo
				if (takis.c2 < 8)
				and ((takis.c1) and  (takis.c1 < 8))
				and (takis.combo.cashable)
					takis.combo.time = 0
				end
				
				if not takis.shotgunned
				
					--shield ability
					--team new
					if takis.c2 == 1
					and not takis.onGround
					--and (p.pflags & PF_JUMPED)
					and p.powers[pw_shield] ~= SH_NONE
					and not (takis.hammerblastdown)
						TakisTeamNewShields(p)
					end
					
				else
					
					--shotgun stomp
					--literally just hammerblast lol
					if (takis.c2 == 1)
					and not takis.onGround
					and not (takis.shotguncooldown)
					and not (takis.hammerblastdown)
					and (takis.notCarried)
					and not (takis.inPain or takis.inFakePain)
					and not (takis.noability & NOABIL_SHOTGUN)
						S_StartSound(me,sfx_shgns)
						
						
						takis.hammerblastdown = 1
						p.pflags = $|PF_THOKKED
						takis.thokked = true
						P_DoJump(p,false)
						L_ZLaunch(me,101*FU,true)
						
						TakisDoShotgunShot(p,true)
					end
				end
				
			end
			
			--c3 specials
			if (takis.c3 > 0)
			
				--deshotgun
				--unshotgun
				--un-shotgun
				if takis.c3 == 1
				and (takis.transfo & TRANSFO_SHOTGUN)
				and not (takis.tossflag)
				and (takis.shotgunforceon == false)
				and not (takis.hammerblastdown)
					TakisDeShotgunify(p)
				end
				
				--this is stupid lol
				if takis.c3 == TR
					if (P_RandomChance(10))
						P_DamageMobj(me,nil,nil,1,DMG_INSTAKILL)
					end
					if P_RandomChance(1)
					and (takis.isSinglePlayer)
						G_ExitLevel()
					end
					if P_RandomChance(FU/70)
						TakisJumpscare(p)
					end
				end
			end
			
			--shotgun tutorial
			if takis.tossflag == 17
			and (takis.shotguntuttic)
				CFTextBoxes:DisplayBox(p,TAKIS_TEXTBOXES.shotgun)
				takis.shotguntuttic = 0
			end
			
			if takis.taunttime > 0
				takis.stasistic = 1
				
				--taunt anims
				if me.health
					local think = TAKIS_TAUNT_THINK[takis.tauntid]
					think(p)
			end
				takis.taunttime = $-1
			else
				TakisResetTauntStuff(takis,false)
				
				if me.state == S_PLAY_TAKIS_SMUGASSGRIN
					me.tics = 1
				end
			end
			
			--stuff to do while in pain
			if takis.inPain
			or takis.inFakePain
				takis.ticsinpain = $+1
				
				takis.noability = $|NOABIL_SHOTGUN
				
				TakisResetTauntStuff(takis)
			
				takis.hammerblastjumped = 0
				takis.recovwait = $+1
				
				if (takis.taunttime)
					P_RestoreMusic(p)
					takis.taunttime = 0
				end
				
				-- recov / recovery jump
				if (takis.jump)
				and (takis.recovwait >= TR)
				and (me.state == S_PLAY_PAIN)
					takis.ticsforpain = 0
					takis.stasistic = 0
					p.pflags = $ &~(PF_JUMPED|PF_THOKKED)
					P_DoJump(p,true)
					takis.dived,takis.thokked = false,false
					takis.inFakePain = false
				end
			else
				takis.recovwait = 0
				takis.ticsinpain = 0
			end
			
			if me.sprite2 == SPR2_PAIN
			and me.health
				me.frame = (leveltime%4)/2
			end
			
			if (p.pflags & PF_JUMPED) and not (takis.thokked)
			and me.state == S_PLAY_JUMP
				takis.thokked = false
				takis.dived = false
				takis.jumptime = $+1
			else
				takis.jumptime = 0
			end
			if takis.jumptime > 0
				if takis.jumptime < 11
				and p.pflags & PF_JUMPDOWN
					takis.wavedashcapable = true
				else
					takis.wavedashcapable = false
				end
			else
				takis.wavedashcapable = false
			end
			
			--hammer blast thinker
			--hammerblast thinker
			--hammerblast stuff
			if takis.hammerblastdown
				p.charflags = $ &~SF_RUNONWATER
				p.powers[pw_strong] = $|(STR_SPRING|STR_HEAVY)
				takis.noability = $|NOABIL_SHOTGUN|NOABIL_HAMMER
				--control better
				p.thrustfactor = $*3/2
				
				if (p.pflags & PF_SHIELDABILITY)
					p.pflags = $ &~PF_SHIELDABILITY
				end
				
				if (takis.shotgunned)
					if me.state ~= S_PLAY_TAKIS_SHOTGUNSTOMP
						me.state = S_PLAY_TAKIS_SHOTGUNSTOMP
						p.panim = PA_FALL
					end
					--wind ring
					if not (takis.hammerblastdown % 6)
					and takis.hammerblastdown > 6
					and (me.momz*takis.gravflip < 0)
						local ring = P_SpawnMobjFromMobj(me,
							0,0,-5*me.scale*takis.gravflip,MT_WINDRINGLOL
						)
						if (ring and ring.valid)
							ring.renderflags = RF_FLOORSPRITE
							ring.frame = $|FF_TRANS50
							ring.startingtrans = FF_TRANS50
							ring.scale = FixedDiv(me.scale,2*FU)
							P_SetObjectMomZ(ring,10*me.scale)
							--i thought this would fade out the object
							ring.fuse = 10
							ring.destscale = FixedMul(ring.scale,2*FU)
							ring.colorized = true
							ring.color = SKINCOLOR_WHITE
						end
					end
					
				else
					if me.state ~= S_PLAY_MELEE
						me.state = S_PLAY_MELEE
					end
					
				end
				
				takis.hammerblastjumped = 0
				if takis.hammerblastdown == 1
					L_ZLaunch(me,12*FU)
					takis.hammerblastwentdown = false
				end
				
				takis.thokked,takis.dived = true,true
				
				if (me.flags2 & MF2_TWOD)
					p.drawangle = takis.hammerblastangle
				end
				
				me.momz = $+P_GetMobjGravity(me)
				
				--the main stuff
				local fallingspeed = (8*me.scale)
				if (takis.inWater) then fallingspeed = $*3/4 end
				if me.momz*takis.gravflip <= fallingspeed
				or takis.hammerblastwentdown == true
					
					local x = cos(p.drawangle)
					local y = sin(p.drawangle)
					
					if takis.hammerblastwentdown == false
					and not (takis.shotgunned)
						takis.hammerblasthitbox = P_SpawnMobjFromMobj(
							me,
							42*x+me.momx,
							42*y+me.momy,
							(-FixedMul(TAKIS_HAMMERDISP,me.scale)*takis.gravflip)+me.momz,
							MT_TAKIS_HAMMERHITBOX
						)
						local box = takis.hammerblasthitbox
						P_SetOrigin(box,box.x,box.y,box.z)
						box.takis_flingme = false
						box.parent = me
						--takis.hammerblasthitbox.flags2 = $|MF2_DONTDRAW
					end
					
					--wind ring
					if not (takis.hammerblastdown % 6)
					and takis.hammerblastdown > 6
					and (me.momz*takis.gravflip < 0)
					and (takis.hammerblasthitbox and takis.hammerblasthitbox.valid)
						local ring = P_SpawnMobjFromMobj(takis.hammerblasthitbox,
							0,0,-5*me.scale*takis.gravflip,MT_WINDRINGLOL
						)
						if (ring and ring.valid)
							ring.renderflags = RF_FLOORSPRITE
							ring.frame = $|FF_TRANS50
							ring.startingtrans = FF_TRANS50
							ring.scale = FixedDiv(me.scale,2*FU)
							P_SetObjectMomZ(ring,10*me.scale)
							--i thought this would fade out the object
							ring.fuse = 10
							ring.destscale = FixedMul(ring.scale,2*FU)
							ring.colorized = true
							ring.color = SKINCOLOR_WHITE
						end
					end
					
					--me.momz = $*15/8
					me.momz = $-((me.scale*11/10)*takis.gravflip)
					if (takis.shotgunned)
						me.momz = $-((me.scale*14/10)*takis.gravflip)
					end
					
					takis.hammerblastwentdown = true
					
					if not (takis.shotgunned)
						if not S_SoundPlaying(me,sfx_takhmb)
							S_StartSound(me,sfx_takhmb)
						end
						
						if takis.hammerblastdown
						and (takis.hammerblastdown % 5 == 0)
						and (me.momz*takis.gravflip <= 16*me.scale)
							P_SpawnGhostMobj(me)
						end
					end
					
				end
				
				if takis.hammerblasthitbox
				and takis.hammerblasthitbox.valid
					local x = cos(p.drawangle)
					local y = sin(p.drawangle)
					local z = GetActorZ(me,takis.hammerblasthitbox,1)
					P_MoveOrigin(takis.hammerblasthitbox,me.x+(42*x)+me.momx,
						me.y+(42*y)+me.momy,
						z-(FixedMul(TAKIS_HAMMERDISP,me.scale)*takis.gravflip)+me.momz
					)
					TakisBreakAndBust(p,takis.hammerblasthitbox)
				end
				
				local superspeed = -60*me.scale
				if (me.momz*takis.gravflip <= superspeed)
				and not (takis.lastmomz*takis.gravflip <= superspeed)
					S_StartSound(me,sfx_fastfl)
				end
				
				takis.hammerblastdown = $+1
				
				--cancel conds.
				if not (takis.notCarried)
					
					if ((takis.hammerblasthitbox) and (takis.hammerblasthitbox.valid))
						P_RemoveMobj(takis.hammerblasthitbox)
						takis.hammerblasthitbox = nil
					end
					takis.hammerblastdown = 0
					
				elseif (me.eflags & MFE_SPRUNG
				or takis.fakesprung)
				
					takis.hammerblastdown = 0
					me.state = S_PLAY_SPRING
					P_MovePlayer(p)
					
					p.pflags = $ &~(PF_JUMPED|PF_THOKKED)
					takis.thokked = false
					takis.dived = false
				elseif not me.health
				or ((takis.inPain) or (takis.inFakePain))
				or not (takis.notCarried)
				
					if ((takis.hammerblasthitbox) and (takis.hammerblasthitbox.valid))
						P_RemoveMobj(takis.hammerblasthitbox)
						takis.hammerblasthitbox = nil
					end
					takis.hammerblastdown = 0
					
				end
				
				if not (takis.shotgunned)
					takis.dontlanddust = true
				end
				
				--hit ground
				if (takis.onGround or P_CheckDeathPitCollide(me))
				or (stupidbouncesectors(me,me.subsector.sector))
				or (takis.justHitFloor)
					if ((takis.hammerblasthitbox) and (takis.hammerblasthitbox.valid))
						P_RemoveMobj(takis.hammerblasthitbox)
						takis.hammerblasthitbox = nil
					end
					
					--dust effect
					if not (me.eflags & MFE_TOUCHWATER)
					and not (takis.shotgunned)
						local maxi = 16+abs(takis.lastmomz*takis.gravflip/me.scale/5)
						for i = 0, maxi
							local radius = me.scale*16
							local fa = FixedAngle(i*(FixedDiv(360*FU,maxi*FU)))
							local mz = takis.lastmomz/7
							local dust = TakisSpawnDust(me,
								fa,
								0,
								P_RandomRange(-1,2)*me.scale,
								{
									xspread = 0,
									yspread = 0,
									zspread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
									
									thrust = 0,
									thrustspread = 0,
									
									momz = P_RandomRange(0,1)*me.scale,
									momzspread = P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1),
									
									scale = me.scale,
									scalespread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
									
									fuse = 23+P_RandomRange(-2,3),
								}
							)
							dust.momx = FixedMul(FixedMul(sin(fa),radius),mz)/2
							dust.momy = FixedMul(FixedMul(cos(fa),radius),mz)/2
							
						end
					end
					
					--impact sparks
					if ((takis.lastmomz*takis.gravflip) <= superspeed)
						S_StartSound(me,sfx_s3k9b)
						local radius = abs(takis.lastmomz)
						for i = 0, 16
							local fa = (i*ANGLE_22h)
							local spark = P_SpawnMobjFromMobj(me,0,0,0,MT_SUPERSPARK)
							spark.momx = FixedMul(sin(fa),radius)
							spark.momy = FixedMul(cos(fa),radius)
							local spark2 = P_SpawnMobjFromMobj(me,0,0,0,MT_SUPERSPARK)
							spark2.color = me.color
							spark2.momx = FixedMul(sin(fa),radius/20)
							spark2.momy = FixedMul(cos(fa),radius/20)
						end
						DoQuake(p,FU*37,20)
						
						if not (G_RingSlingerGametype() or TAKIS_NET.hammerquakes == false)
							--KILL!
							local rad = takis.lastmomz
							local px = me.x
							local py = me.y
							local br = abs(rad*10)
							local h = 20
							
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
									if CanFlingThing(found)
										spawnragthing(found,me)
										S_StartSound(found,sfx_sdmkil)
									elseif (found.type == MT_PLAYER)
										if CanPlayerHurtPlayer(p,found.player)
											TakisAddHurtMsg(found.player,HURTMSG_HAMMERQUAKE)
											P_DamageMobj(found,me,me,abs(me.momz/FU/4))
										end
										DoQuake(found.player,
											FixedMul(
												75*FU, FixedDiv( br-FixedHypot(found.x-me.x,found.y-me.y),br )
											),
											15
										)
									elseif (SPIKE_LIST[found.type] == true)
										P_KillMobj(found,me,me)
									end
								end
							end, me, px-br, px+br, py-br, py+br)		
						end
					end
					
					if not (takis.shotgunned)
						S_StartSoundAtVolume(me, sfx_pstop,4*255/5)
					else
						S_StartSound(me,sfx_slam)
					end
					
					local quake = 25
					if (takis.shotgunned)
						quake = 34
					end
					DoQuake(p,me.scale*quake,10)
					TakisBreakAndBust(p,me)
					P_MovePlayer(p)
					
					if not (takis.shotgunned)
						--holding jump while landing? boost us up!
						if takis.jump > 0
						and me.health
						and not ((takis.inPain) or (takis.inFakePain))
						and not (takis.noability & NOABIL_THOK)
							local time = min(takis.hammerblastdown,TR*25/10)
							takis.hammerblastjumped = 1
							P_DoJump(p,false)
							me.state = S_PLAY_ROLL
							me.momz = 20*takis.gravflip*me.scale+(time*takis.gravflip*me.scale/8)
							S_StartSoundAtVolume(me,sfx_kc52,180)
							p.pflags = $|PF_JUMPED &~PF_THOKKED
							takis.thokked = false
							shouldntcontinueslide = true
							
						--holding spin while landing? boost us forward!
						elseif (takis.use > 0)
						and me.health
						and not (takis.noability & NOABIL_CLUTCH)
							if not takis.dropdashstale
								S_StartSound(me,sfx_cltch2)
							else
								S_StartSound(me,sfx_didbad)
							end
							
							me.state = S_PLAY_RUN
							
							takis.clutchingtime = 0
							takis.glowyeffects = takis.hammerblastdown/3
							
							local ang = GetControlAngle(p)
							
							if ((me.flags2 & MF2_TWOD)
							or (twodlevel))
								if (p.cmd.sidemove > 0)
									ang = p.drawangle
								elseif (p.cmd.sidemove < 0)
									ang = InvAngle(p.drawangle)
								end
							end
							
							if takis.accspeed+15*FU <= 80*FU
								P_InstaThrust(me,ang,
									FixedDiv(
										FixedMul(
											FixedMul(takis.accspeed+15*FU,me.scale),
											p.powers[pw_sneakers] and FU*7/5 or FU
										),
										max(FU,takis.dropdashstale*3/2*me.scale)
									),
									true
								)
							else
								me.friction = FU
							end
							P_MovePlayer(p)
							
							--effect
							local ghost = P_SpawnGhostMobj(me)
							ghost.scale = 3*me.scale/2
							ghost.destscale = FixedMul(me.scale,2)
							ghost.colorized = true
							ghost.frame = $|TR_TRANS10
							ghost.blendmode = AST_ADD
							for i = 0, 4 do
								P_SpawnSkidDust(p,25*me.scale)
							end
							
							takis.dropdashstale = $+1
							takis.dropdashstaletime = 2*TR
						end
					end
					
					takis.hammerblastdown = 0
				end
				
			else
				p.powers[pw_strong] = $ &~(STR_SPRING|STR_HEAVY)
				if ((takis.hammerblasthitbox) and (takis.hammerblasthitbox.valid))
					P_RemoveMobj(takis.hammerblasthitbox)
					takis.hammerblasthitbox = nil
				end
				S_StopSoundByID(me,sfx_fastfl)
				S_StopSoundByID(me,sfx_takhmb)
			end
			
			if takis.hammerblastjumped
				takis.hammerblastjumped = $+1
				if takis.hammerblastjumped == (6*7)
					takis.hammerblastjumped = 0
				end
			end
			
			if stupidbouncesectors(me,me.subsector.sector)
				if me.state ~= S_PLAY_ROLL
					me.state = S_PLAY_ROLL
				end
				p.pflags = $|PF_JUMPED &~PF_THOKKED
				takis.thokked = false
				takis.dived = false
			end
			
			if not (takis.noability & NOABIL_AFTERIMAGE)
				if takis.clutchingtime
				or takis.glowyeffects
				and ((me.health) or (p.playerstate == PST_LIVE))
				or (takis.hammerblastdown and (me.momz*takis.gravflip <= -60*me.scale)
					and not takis.shotgunned)
				or (takis.drilleffect and takis.drilleffect.valid)
				and not takis.shotgunned
				or (takis.bashtime)
					if not takis.shotgunned
						takis.clutchingtime = $+1
					end
					takis.afterimaging = true
					
					if not (takis.bashtime)
						takis.dustspawnwait = $+FixedDiv(takis.accspeed,64*FU)
						while takis.dustspawnwait > FU
							takis.dustspawnwait = $-FU
							--xmom code
							if (takis.onGround)
							and not (takis.clutchingtime % 10)
							and (takis.accspeed >= 45*FU)
								local d1 = P_SpawnMobjFromMobj(me, -20*cos(p.drawangle + ANGLE_45), -20*sin(p.drawangle + ANGLE_45), 0, MT_TAKIS_CLUTCHDUST)
								local d2 = P_SpawnMobjFromMobj(me, -20*cos(p.drawangle - ANGLE_45), -20*sin(p.drawangle - ANGLE_45), 0, MT_TAKIS_CLUTCHDUST)
								--d1.scale = $*2/3
								d1.destscale = FU/10
								d1.angle = R_PointToAngle2(me.x+me.momx, me.y+me.momy, d1.x, d1.y) --- ANG5

								--d2.scale = $*2/3
								d2.destscale = FU/10
								d2.angle = R_PointToAngle2(me.x+me.momx, me.y+me.momy, d2.x, d2.y) --+ ANG5
								
								for i = 3,P_RandomRange(5,7)
									TakisSpawnDust(me,
										p.drawangle+FixedAngle(P_RandomRange(-20,20)*FU+P_RandomFixed()),
										P_RandomRange(0,-20),
										P_RandomRange(-1,2)*me.scale,
										{
											xspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
											yspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
											zspread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
											
											thrust = 0,
											thrustspread = 0,
											
											momz = P_RandomRange(6,1)*me.scale,
											momzspread = P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1),
											
											scale = me.scale,
											scalespread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
											
											fuse = 23+P_RandomRange(-2,3),
										}
									)
								end
								/*
								for i = 3,P_RandomRange(5,7)
									local angle = p.drawangle+FixedAngle(P_RandomRange(-20,20)*FU+P_RandomFixed())
									local dist = P_RandomRange(0,-20)
									local x,y = ReturnTrigAngles(angle)
									local steam = P_SpawnMobjFromMobj(me,
										dist*x+P_RandomFixed(),
										dist*y+P_RandomFixed(),
										P_RandomRange(-1,2)*me.scale+P_RandomFixed(),
										MT_TAKIS_STEAM
									)
									P_SetObjectMomZ(steam,
										P_RandomRange(6,1)*me.scale+P_RandomFixed(),
										false
									)
									steam.angle = angle
									steam.scale = me.scale+(P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1))
									steam.timealive = 1
									steam.tracer = me
									steam.destscale = 1
									steam.fuse = 20
								end
								*/
							end
						end
					end
					
					--p.charflags = $|SF_CANBUSTWALLS
					
					p.powers[pw_strong] = $|STR_WALL
					if (takis.accspeed >= skins[TAKIS_SKIN].normalspeed*2)
						p.charflags = $|SF_RUNONWATER|SF_CANBUSTWALLS
					else
						p.charflags = $ &~(SF_RUNONWATER|SF_CANBUSTWALLS)
					end
					
					if not (p.pflags & PF_SPINNING)
					and not (takis.glowyeffects)
					and not (takis.clutchingtime % 2)
						TakisCreateAfterimage(p,me)
					end
					
					if (takis.accspeed > FU)
						p.runspeed = takis.accspeed-FU
					else
						p.runspeed = skins[TAKIS_SKIN].runspeed
					end
					
				else
					p.charflags = $ &~(SF_CANBUSTWALLS|SF_RUNONWATER)
					p.powers[pw_strong] = $ &~STR_WALL
					p.runspeed = skins[TAKIS_SKIN].runspeed
					takis.clutchingtime = 0
					if not takis.starman
						takis.afterimagecolor = 1
					end
				end
			else
				p.charflags = $ &~(SF_CANBUSTWALLS|SF_RUNONWATER)
				p.powers[pw_strong] = $ &~STR_WALL
				p.runspeed = skins[TAKIS_SKIN].runspeed
				takis.clutchingtime = 0
				if not takis.starman
					takis.afterimagecolor = 1
				end
			end
			
			--stuff to do while grounded
			if takis.onGround
				takis.coyote = 4
				takis.bashcooldown = false
				
				if (p.pflags & PF_SHIELDABILITY)
				and (p.powers[pw_shield] == SH_BUBBLEWRAP)
					P_DoBubbleBounce(p)
					p.pflags = $ &~PF_THOKKED
					takis.thokked = false
					me.state = S_PLAY_ROLL
				end
				
				if takis.inFakePain
					takis.fakeflashing = flashingtics
					if (me.flags2 & MF2_TWOD or twodlevel)
					and (me.state == S_PLAY_PAIN)
						me.state = S_PLAY_STND
						P_MovePlayer(p)
					end
				end
				
				if not (takis.justHitFloor)
				and (takis.ticsinpain >= 2)
				and takis.inFakePain
					takis.inFakePain = false
				end
				takis.ticsforpain = 0
				
				if not P_CheckDeathPitCollide(me)
					takis.timesdeathpitted = 0
				end
				if p.pflags & PF_SPINNING
				and takis.accspeed >= 10*FU
				and (me.state == S_PLAY_TAKIS_SLIDE)
					local chance = P_RandomChance(FU/3)
					if takis.accspeed >= 30*FU
						chance = true
					end
					if takis.accspeed <= 20*FU
						chance = false
					end
					
					if chance
						TakisSpawnDust(me,
							p.drawangle+FixedAngle(P_RandomRange(-45,45)*FU+(P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1))),
							P_RandomRange(0,-50),
							P_RandomRange(-1,2)*me.scale,
							{
								xspread = 0,--(P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
								yspread = 0,--(P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
								zspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
								
								thrust = P_RandomRange(0,-10)*me.scale,
								thrustspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
								
								momz = P_RandomRange(4,0)*P_RandomRange(3,10)*(me.scale/2),
								momzspread = ((P_RandomChance(FU/2)) and 1 or -1),
								
								scale = me.scale,
								scalespread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
								
								fuse = 15+P_RandomRange(-5,5),
							}
						)
						S_StartSound(me,sfx_s3k7e)
					end
					
					P_ButteredSlope(me)
					takis.clutchingtime = $-2
					takis.noability = $|NOABIL_SHOTGUN|NOABIL_AFTERIMAGE
				end
				takis.dived = false
				if takis.hammerblastjumped >= 3
					takis.hammerblastjumped = 0
				end
				if not ((me.eflags & MFE_TOUCHWATER) and not ((me.eflags & MFE_UNDERWATER) or (P_IsObjectInGoop(me))))
					takis.lastgroundedpos = {me.x,me.y,me.z}
				end
				takis.thokked = false
				takis.firethokked = false
				
				--keep sliding
				if (takis.c2)
				and (takis.accspeed > 5*FU)
				and (takis.notCarried)
				and (not shouldntcontinueslide)
				and not (takis.noability & NOABIL_SLIDE)
					if me.state ~= S_PLAY_TAKIS_SLIDE
					and me.health
						S_StartSound(me,sfx_taksld)
						me.state = S_PLAY_TAKIS_SLIDE
					end
					takis.slidetime = max(1,$)
					p.pflags = $|PF_SPINNING
				end
					
				--footsteps
				if (me.state == S_PLAY_WALK
				or me.sprite2 == SPR2_WALK)
				and (me.health)
				and not takis.dontfootdust
					local frame = me.frame & FF_FRAMEMASK
					if ((frame == A) or (frame == E))
						if not takis.steppedthisframe
							local sfx = P_RandomRange(sfx_takst1,sfx_takst3)
							
							S_StartSoundAtVolume(me,sfx_takst0,255/2)
							S_StartSound(me,sfx)
							takis.steppedthisframe = true
							TakisSpawnDust(me,
								p.drawangle+FixedAngle(P_RandomRange(-20,20)*FU+P_RandomFixed()),
								P_RandomRange(0,-10),
								P_RandomRange(-1,2)*me.scale+P_RandomFixed(),
								{
									xspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
									yspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
									zspread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
									
									thrust = 0,
									thrustspread = 0,
									
									momz = 0,
									momzspread = 0,
									
									scale = me.scale*4/5,
									scalespread = 0,--(P_RandomFixed()/4*((P_RandomChance(FU/2)) and 1 or -1)),
									
									fuse = 15+P_RandomRange(-2,3),
								}
							)
							
						end
					else
						takis.steppedthisframe = false
					end
				else
					takis.steppedthisframe = false
					takis.dontfootdust = false
				end
				if takis.justHitFloor
				and not (me.eflags & (MFE_TOUCHWATER|MFE_TOUCHLAVA))
				and not P_CheckDeathPitCollide(me)
				and me.health
					if (takis.dontlanddust == false)
					and (takis.onPosZ)
						S_StartSoundAtVolume(me,sfx_takst0,255*4/5)
						S_StartSound(me,sfx_takst4)
						p.jp = 1
						p.jt = -5
						if not takis.crushtime
						and (takis.saveddmgt ~= DMG_CRUSHED)
							DoTakisSquashAndStretch(p,me,takis)
						else
							p.jt = 0
							p.jp = 0
							p.sp = 0
							p.tk = 0
							p.tr = 0
						end
						P_SetOrigin(me,me.x,me.y,me.z)
						for i = 0, 8
							local radius = me.scale*16
							local fa = (i*ANGLE_45)
							local mz = takis.prevmomz/10
							local dust = TakisSpawnDust(me,
								fa,
								0,
								P_RandomRange(-1,2)*me.scale,
								{
									xspread = 0,
									yspread = 0,
									zspread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
									
									thrust = 0,
									thrustspread = 0,
									
									momz = P_RandomRange(0,1)*me.scale,
									momzspread = P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1),
									
									scale = me.scale,
									scalespread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
									
									fuse = 23+P_RandomRange(-2,3),
								}
							)
							dust.momx = FixedMul(FixedMul(sin(fa),radius),mz)/2
							dust.momy = FixedMul(FixedMul(cos(fa),radius),mz)/2
							
							takis.dontlanddust = true
						end
					end
				end
				
				--speedpads conserve speed too
				if P_PlayerTouchingSectorSpecial(p, 3, 5)
				and takis.onGround
				and not takis.fakesprung
					P_Thrust(me,me.angle,takis.prevspeed)
					takis.fakesprung = true
				end
			else
				if me.eflags & MFE_SPRUNG
					takis.coyote = 0
				end
				
				--coyote time
				if takis.coyote
					takis.coyote = $-1
					if takis.jump == 1
					and not (p.pflags & (PF_JUMPED|PF_JUMPSTASIS|PF_THOKKED))
						takis.coyote = 0
						P_DoJump(p,true)
					end
				end
			end
			takis.prevmomz = me.momz
			
			/*
			if takis.hurtfreeze > 0
				me.momx,me.momy,me.momz = 0,0,0
				p.powers[pw_flashing] = 3
				if takis.hurtfreeze <= TR
					if not (leveltime % 2)
						me.flags2 = $|MF2_DONTDRAW
					else
						me.flags2 = $ &~MF2_DONTDRAW
					end
				end
				
				if takis.hurtfreeze == TR
					local x
					local y
					local z
					x,y,z = unpack(takis.lastgroundedpos)
					P_SetOrigin(me,x,y,z+(me.height*takis.gravflip))
				end
				
				if takis.hurtfreeze == 1
					takis.fakeflashing = flashingtics
				end
				
				takis.hurtfreeze = $-1
			end
			*/
			
			if takis.beingcrushed
				me.spriteyscale = FU/3
				me.spritexscale = FU*3
				
				--keep increasing this until it reaches
				--2*TR, kill if then
				if G_BuildMapTitle(gamemap) ~= "Red Room"
					takis.timescrushed = $+1
				end
				takis.crushscale = FU/3
				
				if not takis.crushtime
				and not (takis.transfo & TRANSFO_PANCAKE)
					S_StartSound(me,sfx_tsplat)
					S_StartSound(me,sfx_trnsfo)
					takis.transfo = $|TRANSFO_PANCAKE
					TakisAwardAchievement(p,ACHIEVEMENT_PANCAKE)
				end
				takis.pancaketime = 10*TR
				
				p.pflags = $ &~PF_SPINNING
				P_MovePlayer(p)
				if (me.state == S_PLAY_ROLL)
					me.state = S_PLAY_STND
				end
				
				--used to reset crushed
				takis.crushtime = TR
			else
				if not takis.crushtime
					if (takis.saveddmgt ~= DMG_CRUSHED)
						DoTakisSquashAndStretch(p,me,takis)
					end
				else
					local s = FixedDiv(takis.crushtime*FU,TR*FU)
					takis.crushscale = ease.inexpo(FU-s,takis.crushscale,FU)
					
					me.spriteyscale = FixedMul(FU,takis.crushscale)
					me.spritexscale = FixedDiv(FU,takis.crushscale)				
					p.jt = 0
					p.jp = 0
					p.sp = 0
					p.tk = 0
					p.tr = 0
				end
			end
			
			takis.beingcrushed = false
			
			--are we dead?
			if (not me.health)
			or (p.playerstate ~= PST_LIVE)
				
				TakisDeathThinker(p,me,takis)
				if (takis.shotgunned)
					TakisDeShotgunify(p)
				end
				
				if (takis.transfo)
					S_StartSound(me,sfx_shgnk)
					takis.transfo = 0
				end
				
				if ((takis.body) and (takis.body.valid))
					P_MoveOrigin(takis.body,me.x,me.y,me.z)
					takis.body.rollangle = me.rollangle
				end
				
				takis.goingfast = false
				takis.wentfast = 0
				
				--death thinker and anims are called in 
				--TakisDoShorts
				
				takis.heartcards = 0
				TakisResetHammerTime(p)
				TakisResetTauntStuff(takis)
				
				takis.clutchingtime = 0
				takis.afterimaging = false
				
				if S_SoundPlaying(me,skins[TAKIS_SKIN].soundsid[SKSPLDET3])
					S_StopSoundByID(me,skins[TAKIS_SKIN].soundsid[SKSPLDET3])
					me.frame = A
					me.sprite2 = SPR2_TDED
					for i = 1, 6
						A_BossScream(me,1,MT_SONIC3KBOSSEXPLODE)
					end
					S_StartSound(me,sfx_tkapow)
					DoQuake(p,me.scale*8,10,8*me.scale)
					takis.altdisfx = 3
				elseif S_SoundPlaying(me,skins[TAKIS_SKIN].soundsid[SKSPLDET4])
					S_StopSoundByID(me,skins[TAKIS_SKIN].soundsid[SKSPLDET4])
					me.frame = A
					me.sprite2 = SPR2_FASS
					S_StartSound(me,sfx_takoww)
					takis.altdisfx = 4
				end
				
			elseif (p.playerstate == PST_REBORN
			or p.playerstate == PST_LIVE)
				takis.deathanim = 0
				takis.altdisfx = 0
				takis.saveddmgt = 0
				takis.stoprolling = false
				takis.deathfloored = false
				if p.bot == BOT_2PAI
					takis.heartcards = TAKIS_MAX_HEARTCARDS
				end
			end
			
			--handle combo stuff here
			if takis.combo.time ~= 0
				if not (takis.notCarried)
				or ((p.pflags & PF_STASIS) and not (takis.taunttime and takis.tauntid))
				--or (takis.hurtfreeze ~= 0)
				or ((p.exiting) and not (p.pflags & PF_FINISHED))
				or (p.powers[pw_nocontrol])
				or (takis.nocontrol)
				or (me.pizza_in or me.pizza_out)
				or (takis.inWaterSlide)
				or (p.ptsr_outofgame)
				or (HAPPY_HOUR.othergt and HAPPY_HOUR.overtime)
					takis.combo.frozen = true
					if ((p.exiting) and not (p.pflags & PF_FINISHED))
					or (p.ptsr_outofgame)
						takis.combo.cashable = true
					end
				else
					takis.combo.time = $-1
					takis.combo.frozen = false
					takis.combo.cashable = false
				end
				
				if takis.combo.time > TAKIS_MAX_COMBOTIME	
					takis.combo.time = TAKIS_MAX_COMBOTIME
				end
				
				--give ultiamte combo token
				if takis.combo.lastcount < TAKIS_MISC.partdestroy
				and takis.combo.count >= TAKIS_MISC.partdestroy
				and not takis.combo.dropped
				and (gametype == GT_COOP)
				and not (maptol & TOL_NIGHTS)
				and not (TAKIS_MISC.inbossmap or TAKIS_MISC.inbrakmap)
					takis.combo.awardable = true
					takis.HUD.combo.tokengrow = FU/2
					MeSoundHalfVolume(sfx_rakupp,p)
				end
				
				local cc = takis.combo.count
				--be fair to the other runners
				if (HAPPY_HOUR.othergt)
					takis.combo.score = ((cc*cc)/2)+(10*cc)
				else
					takis.combo.score = ((cc*cc)/2)+(17*cc)
				end
				
				takis.combo.outrotics = 0
				
				takis.combo.verylevel = takis.combo.count/(#TAKIS_COMBO_RANKS*TAKIS_COMBO_UP)
				
			else
				takis.combo.frozen = false
				takis.combo.cashable = false
				takis.HUD.combo.shake = 0
				
				if takis.combo.count
					takis.combo.failcount = takis.combo.count
					takis.combo.failtics = 4*TR
					takis.combo.failrank = takis.combo.rank
					
					takis.combo.count = 0
					S_StartSound(nil,sfx_kc59,p)
					
					takis.combo.outrotointro = 0
					takis.combo.outrotics = 7*TR/5
					takis.HUD.flyingscore.lastscore = takis.combo.score
					takis.HUD.combo.momy = 3*FU
					takis.HUD.combo.momx = 3*FU
					
					S_StartSound(nil,sfx_chchng,p)
					P_AddPlayerScore(p,takis.combo.score)
					
					takis.HUD.flyingscore.num = takis.combo.score
					takis.HUD.flyingscore.tics = $+2*TR
					local backx = 15*FU
					local backy = takis.HUD.combo.basey
					takis.HUD.flyingscore.x = backx+5*FU+takis.HUD.combo.patchx
					takis.HUD.flyingscore.y = backy+7*FU
				
					if not (p.pflags & PF_FINISHED)
						if not takis.combo.dropped
							takis.combo.dropped = true
							if takis.combo.lastcount >= TAKIS_MISC.partdestroy
								MeSoundHalfVolume(sfx_rakdns,p)
							end
						end
					end
				end
				
				takis.combo.score = 0
				
				if takis.combo.time < 0
					takis.combo.time = 0
				end
				
				takis.combo.verylevel = 0
				takis.combo.rank = 1
			end
			
			if not (takis.combo.count
			or takis.combo.outrotics)
				takis.failcount = 0
			end
			
			--we're being carried!
			if not (takis.notCarried)
				takis.thokked,takis.dived = false,false
				takis.inFakePain = false
				if not (takis.inwaterslide)
					takis.afterimaging = false
				end
				--TakisResetHammerTime(p)
				takis.dontfootdust = true
				
				if (p.powers[pw_carry] == CR_ROLLOUT)
					if me.state == S_PLAY_FALL
					or (me.state == S_PLAY_TAKIS_SHOTGUNSTOMP)
						me.state = S_PLAY_STND
						P_MovePlayer(p)
					end
				end
			end
			
			--this is actually stupid
			if p.exiting > 0
				
				if (p.pflags & PF_FINISHED)
					takis.combo.time = 0
					takis.fakeexiting = $+1
					
					local hadbonus = false
					--time for bonuses!
					if takis.fakeexiting == 1
						
						if takis.shotgunned
							if ((takis.shotgun) and (takis.shotgun.valid))
								P_KillMobj(takis.shotgun,me)
							end
							takis.transfo = $ &~TRANSFO_SHOTGUN
							takis.shotgun = 0
							takis.shotgunned = false
							P_AddPlayerScore(p,2000)
							takis.bonuses["shotgun"].tics = 3*TR+18
							takis.bonuses["shotgun"].score = 2000
							takis.HUD.flyingscore.scorenum = $+2000
							hadbonus = true
						end	
					end
					
					if takis.combo.awardable
						takis.combo.awardable = false
						P_AddPlayerScore(p,5000)
						takis.HUD.flyingscore.scorenum = $+5000
						takis.bonuses["ultimatecombo"].tics = 3*TR+18
						takis.bonuses["ultimatecombo"].score = 5000
						hadbonus = true
						TakisAwardAchievement(p,ACHIEVEMENT_COMBO)
					end
					
					if hadbonus
						S_StartSound(nil,sfx_chchng,p)
						hadbonus = false
					end
					
					if (p.exiting ~= 1)
						if (takis.heartcards)
							local tic = 77/TAKIS_MAX_HEARTCARDS
							tic = $ or 1
							
							if not (takis.fakeexiting % tic)
								
								if takis.heartcards
									takis.heartcards = $-1
									S_StartSound(nil,sfx_takhel,p)
									P_AddPlayerScore(p,100)
									table.insert(takis.bonuses.cards,{tics = TR+18,score = 100,text = "\x8EHeart Card\x80"})
									--takis.bonuses["heartcard"].tics = TR+18
									--takis.bonuses["heartcard"].score = 1000
									takis.HUD.flyingscore.scorenum = $+1000
								end
								
							end
						end
					--about to leave and still have cards left? cash them all in at once!
					else
						if takis.heartcards 
							S_StartSound(nil,sfx_takhel,p)
							P_AddPlayerScore(p,1000*takis.heartcards)
							takis.heartcards = 0
							takis.HUD.flyingscore.scorenum = $+1000*takis.heartcards
						end
						TakisSaveStuff(p)
					end
				else
					--exiting and no pf_finished?
					if TAKIS_MISC.inbossmap
					and (gametype == GT_COOP)
					/*
					or (TAKIS_NET.exitingcount == TAKIS_NET.playercount)
						if (TAKIS_NET.exitingcount == TAKIS_NET.playercount)
						and takis.finishwait == 0
							takis.finishwait = TR
						end
					*/	
						--if not takis.finishwait
							p.pflags = $|PF_FINISHED
						--end
					end
				end
				
				local candomusic = true
				if (PTSR)
					if PTSR.gameover then candomusic = false end
				end
				
				if not takis.setmusic
				and (p.pflags & PF_FINISHED)
				and candomusic
					S_ChangeMusic("_abclr", false, p)
					takis.setmusic = true
					takis.yeahwait = (2*TR)+(TR/2)+5
				end

				--Yyyeah!
				if takis.yeahwait == 0
				and (p.powers[pw_carry] ~= CR_NIGHTSMODE)
				--and (p.pflags & PF_FINISHED)
					
					if not takis.yeahed
						if p.panim == PA_IDLE
						and ((takis.onGround) or P_CheckDeathPitCollide(me))
						and takis.yeahwait == 0
							if not takis.camerascale
							--keep the camera zoomed out on the door
							and not (HAPPY_HOUR.exit and HAPPY_HOUR.exit.valid)
								takis.camerascale = p.camerascale
								p.camerascale = 28221
							end
							S_StartSound(me,sfx_tayeah)
							takis.yeahed = true
						end
					end
				end
			else
				takis.fakeexiting = 0
				takis.yeahed = false
				takis.setmusic = false
				takis.yeahwait = 0
			end
			
			/*
			if takis.io.nostrafe == 0
			and (p.powers[pw_carry] ~= CR_NIGHTSMODE)
				if ((me.momx) and (me.momy))
					p.drawangle = R_PointToAngle2(0,0, me.momx,me.momy)
				end
			end
			*/
			
			if p.ptsr_rank
			and (HAPPY_HOUR.othergt)
				local per = (PTSR.maxrankpoints)/6
				takis.HUD.rank.percent = per
				local rank = p.ptsr_rank
				
				if (rank == "D")
					takis.HUD.rank.score = p.score
				elseif (rank == "C")
					takis.HUD.rank.score = p.score-(per)
					takis.HUD.rank.percent = $/2
				elseif (rank == "B")
					takis.HUD.rank.score = p.score-(per*2)
				elseif (rank == "A")
					takis.HUD.rank.score = p.score-(per*3)
					takis.HUD.rank.percent = $*5/2
				elseif (rank == "S")
					takis.HUD.rank.score = p.score-(per*8)
					takis.HUD.rank.percent = $*4
				end
				
				takis.HUD.rank.score = $+takis.combo.score
				if takis.HUD.flyingscore.tics
					takis.HUD.rank.score = $-takis.HUD.flyingscore.lastscore
				end
				
				if ranktonum[rank] ~= takis.lastrank
				and not (p.pizzaface)
					local r = ranktonum[rank]
					--we went up!
					if r > takis.lastrank
						if r == 6
							MeSoundHalfVolume(sfx_rakupp,p)
						elseif r == 5
							MeSoundHalfVolume(sfx_rakups,p)
						elseif r == 4
							MeSoundHalfVolume(sfx_rakupa,p)
						elseif r == 3
							MeSoundHalfVolume(sfx_rakupb,p)
						elseif r == 2
							MeSoundHalfVolume(sfx_rakupc,p)
						end
					--down?
					else
						if r == 5
							MeSoundHalfVolume(sfx_rakdns,p)
						elseif r == 4
							MeSoundHalfVolume(sfx_rakdna,p)
						elseif r == 3
							MeSoundHalfVolume(sfx_rakdnb,p)
						elseif r == 2
							MeSoundHalfVolume(sfx_rakdnc,p)
						elseif r == 1
							MeSoundHalfVolume(sfx_rakdnd,p)

						end
					end
					takis.HUD.rank.grow = FRACUNIT/3
				end		
			end
			
			takis.dontlanddust = false
			takis.prevspeed = takis.accspeed
			takis.lastmomz = me.momz
			--these are stupid
			takis.lastskincolor = p.skincolor
			takis.lastlives = p.lives
			if CV_FindVar("cooplives").value == 3
			and (netgame or multiplayer)
				takis.lastlives = TAKIS_MISC.livescount
			end
		else
		
			--just switched
			if not takis.otherskin
				takis.otherskin = true
				TakisResetTauntStuff(takis,true)
			else
				takis.otherskintime = $+1
			end
			
			takis.combo.time = 0
			TakisHUDStuff(p)
			
			if HAPPY_HOUR.time
			and (takis.io.nohappyhour == 0
			and takis.io.morehappyhour == 1)
			and not HAPPY_HOUR.gameover
				local tics = HAPPY_HOUR.time
				
				if (tics == 1)
					S_StartSound(nil,sfx_mclang)
					takis.HUD.ptsr.yoffset = 200*FU
				end
				
		
				if tics <= 2*TR
					if takis.HUD.ptsr.yoffset ~= 0
						local et = 2*TR
						takis.HUD.ptsr.yoffset = ease.outquad(( FU / et )*tics,200*FU,0)
					end
				else
					if takis.HUD.ptsr.yoffset ~= 0
						takis.HUD.ptsr.yoffset = 0
					end
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
				
				if (tics <= TR)
					P_StartQuake((72-(2*tics))*FU,1)
				end
				
			end
			
			if (takis.shotgunned)
				TakisDeShotgunify(p)
			end
		end
		
		--outside of shorts (and skin check!!!!) to check for
		--last rank
		takis.lastrank = ranktonum[p.ptsr_rank or "D"]

		for i = 0,#takis.hurtmsg
			if takis.hurtmsg[i].tics > 0
				takis.hurtmsg[i].tics = $-1
			end
		end
		
		takis.placement = 0
		for k,v in ipairs(TAKIS_MISC.scoreboard)
			if v == p
				takis.placement = k
				break
			else
				continue
			end
		end
		if takis.placement ~= takis.lastplacement
			takis.HUD.lives.bump = FU*3/2
		end
		
		--holding FN, C3, C2 open menu
		if (takis.firenormal >= TR)
		and (takis.c3 >= TR)
		and (takis.c2 >= TR)
		and not (takis.cosmenu.menuinaction)
			TakisMenuOpenClose(p)
		end
		
		if me.battime then me.battime = $-1 end
		if me.touchingdetector then me.touchingdetector = $-1 end
		
		takis.combo.lastcount = takis.combo.count
		takis.lastmap = gamemap
		takis.lastgt = gametype
		takis.lastss = G_IsSpecialStage(takis.lastmap)
		takis.lastplacement = takis.placement
	end
	
end)

--this is really stupid
addHook("ThinkFrame", function ()
    for p in players.iterate() do
        if not (p and p.valid) then continue end
		
		local takis = p.takistable
		
		if takis
			takis.inwaterslide = p.pflags & PF_SLIDING
		end
	end
end)

--thanks to Unmatched Bracket for this code!!!
--:iwantsummadat:
addHook("PostThinkFrame", function ()
    for p in players.iterate() do
        if not (p and p.valid) then continue end
		if not (p.mo and p.mo.valid) then continue end
		if not (p.mo.skin == TAKIS_SKIN) then continue end
		
		local me = p.realmo
		local takis = p.takistable
		
		if (takis.transfo & TRANSFO_TORNADO)
			p.drawangle = me.angle+takis.nadoang
		end
		
		if p.powers[pw_nocontrol] then takis.nocontrol = p.powers[pw_nocontrol] end
		
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
		
		--get rid of ugliness
		if takis.ballretain
		and me.state ~= S_PLAY_ROLL
			me.state = S_PLAY_ROLL
		end
		
		if takis.inwaterslide
            takis.resettingtoslide = true
			me.state = S_PLAY_DEAD
			me.sprite2 = SPR2_SLID
            me.frame = ($ & ~FF_FRAMEMASK) | (leveltime % 4) / 2
            p.drawangle = me.angle
			continue
        end
		
		takis.resettingtoslide = false
    end
end)

addHook("PlayerSpawn", function(p)
	local x,y = ReturnTrigAngles(FixedAngle(180*FU-AngleFixed(p.realmo.angle)))
	/*
	if (TAKIS_DEBUGFLAG & DEBUG_HAPPYHOUR)
		P_SpawnMobjFromMobj(p.mo,100*x,100*y,0,MT_HHTRIGGER)
	end
	*/
	--	P_SpawnMobjFromMobj(p.mo,100*x,100*y,0,MT_HHEXIT)
	
	P_RestoreMusic(p)
	local takis = p.takistable
	p.happydeath = false
	
	if (skins[p.skin].name == TAKIS_SKIN)
		if (mapheaderinfo[gamemap].bonustype == 1)
			if (leveltime < 5)
			or (p.jointime < 5)
				if takis
					local title = takis.HUD.bosstitle
					title.takis[1],title.takis[2] = unpack(title.basetakis)
					title.egg[1],title.egg[2] = unpack(title.baseegg)
					title.vs[1],title.vs[2] = unpack(title.basevs)
					title.mom = 1980
					title.tic = 3*TR
 				else
					p.takis_dotitle = true
				end
			end
		end
		
		if (mapheaderinfo[gamemap].lvlttl == "Tutorial")
			CFTextBoxes:DisplayBox(p,TAKIS_TEXTBOXES.tutexit)
		elseif (mapheaderinfo[gamemap].lvlttl == "Red Room")
			if p.takis_noabil ~= (NOABIL_ALL|NOABIL_THOK) &~NOABIL_SHOTGUN
				p.takis_noabil = (NOABIL_ALL|NOABIL_THOK) &~NOABIL_SHOTGUN
			end
			CFTextBoxes:DisplayBox(p,TAKIS_TEXTBOXES["gmap1000"][1])
		else
			p.takis_noabil = nil
		end
		
		if (maptol & TOL_NIGHTS)
			p.jumpfactor = FixedMul(skins[TAKIS_SKIN].jumpfactor,6*FU/10)
		else
			if (p.jumpfactor < skins[TAKIS_SKIN].jumpfactor)
				p.jumpfactor = skins[TAKIS_SKIN].jumpfactor
			end
		end
	else
		if (p.jumpfactor < skins[p.skin].jumpfactor)
			p.jumpfactor = skins[p.skin].jumpfactor
		end
	
	end
	
	if takis
		local me = p.realmo
		
		if takis.lastmap == 1000
		and G_BuildMapTitle(1000) == "Red Room"
		and takis.lastminhud ~= nil
			takis.io.minhud = takis.lastminhud
			takis.lastminhud = nil
			print("AA")
		end
		
		if takis.cosmenu.menuinaction
			TakisMenuOpenClose(p)
		end
		
		if All7Emeralds(emeralds)
		and not All7Emeralds(takis.lastemeralds)
			TakisAwardAchievement(p,ACHIEVEMENT_SPIRIT)
		end
		
		if takis.gotemeralds ~= emeralds
		and (gametyperules & GTR_FRIENDLY)
			takis.emeraldcutscene = 3*TR
		end
		
		takis.lastemeralds = emeralds
		takis.spiritlist = {}
		
		TakisResetHammerTime(p)
		TakisDeShotgunify(p)
		takis.transfo = 0
		p.jumpfactor = skins[p.skin].jumpfactor
		
		takis.heartcards = TAKIS_MAX_HEARTCARDS
		
		takis.taunttime = 0
		takis.tauntid = 0
		
		takis.clutchingtime = 0
		takis.clutchspamcount = 0
		
		takis.yeahed = false
		takis.yeahwait = 0
		
		takis.thokked, takis.dived = false,false
		
		takis.combo.time = 0
		
		takis.wentfast = 0
		
		if ((takis.body) and (takis.body.valid))
			P_KillMobj(takis.body)
		end
		takis.body = 0
		
		/*
		if ((takis.shotgun) and (takis.shotgun.valid))
			P_KillMobj(takis.shotgun,me)
		end
		takis.shotgun = 0
		takis.shotgunned = false
		
		if ((S_MusicName() == "WAR") or (S_MusicName() == "war"))
			P_RestoreMusic(p)
		end
		
		if ((p.mo) and (p.mo.valid))
			takis.lastgroundedpos = {p.mo.x,p.mo.y,p.mo.z}
		end
		*/
		
		takis.fakeflashing = 0
		takis.stasistic = 0
		
		takis.timeshit = p.timeshit
		
		takis.combo.outrotics = 0
		
		TakisResetTauntStuff(takis,true)
		
		if gamemap ~= takis.lastmap
		or gamemap ~= takis.lastgt
		or (leveltime < 3)
			takis.combo.dropped = false
			takis.combo.awardable = false
		end
		
		if not (splitscreen or multiplayer)
		and p.starpostnum == 0
			takis.combo.dropped = false
			takis.combo.awardable = false
		end
		
	else
		if ultimatemode
			p.takis = {
				shotgunnotif = 6*TR
			}
		end
	end
	if ultimatemode
	and not (G_IsSpecialStage(gamemap) or maptol & TOL_NIGHTS)
	and (skins[p.skin].name == TAKIS_SKIN)
		x,y = ReturnTrigAngles(p.realmo.angle+ANGLE_90)
		P_SpawnMobjFromMobj(p.realmo,55*x,55*y,0,MT_SHOTGUN_BOX)
	end

end)

addHook("PlayerCanDamage", function(player, mobj)
	if not player.mo 
	or not player.mo.valid 
		return
	end
	
	if player.mo and player.mo.valid and player.mo.skin == TAKIS_SKIN
		--basically if we can do the pt afterimages
		if not player.takistable
			return
		end
		
		local me = player.mo
		local takis = player.takistable
		
		if takis.afterimaging
		or (
			( me.state == S_PLAY_TAKIS_SLIDE or (takis.transfo & TRANSFO_BALL))
			and
			--we need to be able to make afterimages to do this!
			not (takis.noability & (NOABIL_CLUTCH|NOABIL_HAMMER))
		)
		or (takis.transfo & TRANSFO_TORNADO)
			if L_ZCollide(me,mobj)
			/*
			and ((mobj.flags & MF_ENEMY)
			--and (mobj.type ~= MT_ROSY)
			and (mobj.type ~= MT_SHELL))
			or (mobj.takis_flingme)
			*/
			and CanFlingThing(mobj)
				--prevent killing blow sound from mobjs way above/below us
				SpawnEnemyGibs(me,mobj)
				SpawnBam(mobj)
				
				--P_KillMobj(mobj, me, me) --actually kill the thing. looking at you, lance-a-bots!
				
				spawnragthing(mobj,me)
				if (me.state == S_PLAY_TAKIS_SLIDE)
					S_StartSound(me,sfx_smack)
				end
				if (takis.transfo & TRANSFO_BALL)
					S_StartSound(me,sfx_bowl)
				end
				S_StartSound(me,sfx_sdmkil)
				
				return true
				
			end
			
		end
	end
end)

--handle takis damage here
--freeroam damage is handled in the ShouldDamage
addHook("MobjDamage", function(mo,inf,sor,_,dmgt)
	if not mo
	or not mo.valid
		return
	end
	
	local p = mo.player 
	local takis = p.takistable

	if takis.inFakePain
		return true
	end
	
	if ((p.powers[pw_flashing])
	and (p.powers[pw_carry] == CR_NIGHTSMODE))
		return
	end

	if p.deadtimer > 10
		return
	end
	
	if mo.skin ~= TAKIS_SKIN
		return
	end
	
	if takis.pittime then return end
	if p.ptsr_outofgame then return end
	
	--BUT!!
	if (p.powers[pw_shield] == SH_ARMAGEDDON)
		TakisPowerfulArma(p)
		takis.fakeflashing = flashingtics*2
		return true
	end
	
	p.pflags = $ &~PF_SHIELDABILITY
	
	--fireass
	local extraheight = false
	if dmgt == DMG_FIRE
	and (p.powers[pw_carry] ~= CR_NIGHTSMODE)
		if not (p.powers[pw_shield] & SH_PROTECTFIRE)
		and not (takis.transfo & TRANSFO_FIREASS)
			S_StartSound(mo,sfx_fire)
			S_StartSound(mo,sfx_trnsfo)
			takis.transfo = $|TRANSFO_FIREASS
			takis.fireasssmoke = TR/2
			takis.fireasstime = 10*TR
			extraheight = true
			mo.state = S_PLAY_DEAD
			mo.frame = A
			mo.sprite2 = SPR2_FASS
			TakisAwardAchievement(p,ACHIEVEMENT_FIREASS)
		else
			return true
		end
	end
	
	if mo.health
	or (takis.heartcards)
		S_StartSound(mo,sfx_smack)
		DoQuake(p,30*FU*(max(1,p.timeshit*2/3)),15)
		if takis.heartcards > 1
			S_StartAntonOw(mo)
		end
	end

	if p.powers[pw_carry] == CR_NIGHTSMODE
		if not multiplayer
			if HAPPY_HOUR.happyhour
				HAPPY_HOUR.timelimit = p.nightstime
				p.powers[pw_flashing] = $*2
			end
		end
		
		return
	end
	
	--combo penalty
	if (takis.shotgunned)
		TakisGiveCombo(p,takis,false,false,true)
	end
	
	if takis.heartcards > 0
		
		TakisResetTauntStuff(p)
		
		if (p.takis_noabil ~= nil)
			if (takis.heartcards ~= 1)
				if (takis.timeshit == 0)
					CFTextBoxes:DisplayBox(p,TAKIS_TEXTBOXES["gmap1000"].timeshit)
				end
			else
				S_StartSound(mo,sfx_cdfm46)
				P_InstaThrust(mo,mo.angle,-5*mo.scale)
				L_ZLaunch(mo,8*mo.scale)
				mo.state = S_PLAY_ROLL
				p.pflags = $ &~(PF_THOKKED|PF_JUMPED)
				CFTextBoxes:DisplayBox(p,TAKIS_TEXTBOXES["gmap1000"].kys,true)
				takis.fakeflashing = flashingtics*2
				return true
			end
			
		end
		
		SpawnEnemyGibs(inf or mo,mo)
		TakisResetHammerTime(p)
		--DIE
		if takis.heartcards == 1
			P_KillMobj(mo,inf,sor,dmgt)
			
			--lose EVERYTHING
			P_PlayerRingBurst(p,p.rings)
			P_PlayerWeaponAmmoBurst(p)
			P_PlayerWeaponPanelBurst(p)
			P_PlayerEmeraldBurst(p)
			
			if (p.gotflag)
				P_PlayerFlagBurst(p,false)
			end
			--award points to source
			if (sor and sor.valid
			and sor.player and sor.player.valid)
				if (gametyperules &
				(GTR_POINTLIMIT|GTR_RINGSLINGER|GTR_HURTMESSAGES)
				or G_RingSlingerGametype())
					P_AddPlayerScore(sor.player,100)
				end
			end
			return true
		end
		TakisHurtMsg(p,inf,sor,dmgt)
		
		P_DoPlayerPain(p,sor,inf)
		--p.powers[pw_flashing] = TR
		takis.ticsforpain = TR
		S_StartSound(mo,sfx_shldls)
		if (dmgt == DMG_SPIKE)
			S_StartSound(mo,sfx_spkdth)
		end
		
		if (p.powers[pw_shield] == SH_NONE)
			TakisHealPlayer(p,mo,takis,3)
			if (p.rings >= 15)
				P_PlayerRingBurst(p,15)
				p.rings = $-15
			else
				P_PlayerRingBurst(p,-1)
				p.rings = 0
			end
			P_PlayerWeaponAmmoBurst(p)
			P_PlayerWeaponPanelBurst(p)
		else
			P_RemoveShield(p)
		end
		p.timeshit = $+1
		takis.timeshit = $+1
		takis.totalshit = $+1
		
		if takis.totalshit >= 100 then TakisAwardAchievement(p,ACHIEVEMENT_OFFICER) end
		
		if inf
		and inf.valid
			local ang = R_PointToAngle2(mo.x,mo.y, inf.x, inf.y)
			P_InstaThrust(mo,ang,-GetPainThrust(mo,inf,sor))
		end
		L_ZLaunch(mo,(extraheight) and 17*mo.scale or 8*mo.scale)
		if not extraheight
			mo.state = S_PLAY_PAIN
		end
		
		takis.inFakePain = true
		p.pflags = $ &~(PF_THOKKED|PF_JUMPED)
		takis.thokked = false
		takis.dived = false
		if (dmgt == DMG_ELECTRIC)
			S_StartSound(mo,sfx_buzz2)
			mo.state = S_PLAY_DEAD
			takis.transfo = $|TRANSFO_ELEC
			takis.electime = TR*3/2
			L_ZLaunch(mo,4*mo.scale)
		end
		
		if (p.gotflag)
			P_PlayerFlagBurst(p,false)
		end
		--award points to source
		if (sor and sor.valid
		and sor.player and sor.player.valid)
			if (gametyperules &
			(GTR_POINTLIMIT|GTR_RINGSLINGER|GTR_HURTMESSAGES)
			or G_RingSlingerGametype())
				P_AddPlayerScore(sor.player,50)
			end
		end
		
		return true
	
	end
	
end,MT_PLAYER)

addHook("MobjDamage", function(tar,inf,src)
	if not tar
	or not tar.valid
		return
	end
	
	if not src
	or not src.valid
		return
	end
	
	if src.player
	and src.skin == TAKIS_SKIN
	and src.player.takistable.combo.time
		TakisGiveCombo(src.player,src.player.takistable,false,true)
	end
end,MT_PLAYER)

--enemy knockback
local function stopmom(takis,me,ang)
	if takis.accspeed < (6*(40*FU)/5)
	and (me.player.powers[pw_invulnerability] == 0)
	and not (me.player.pflags & PF_SPINNING)
	and not (HAPPY_HOUR.othergt
	and HAPPY_HOUR.happyhour)
		me.momx,me.momy = 0,0
		me.state = S_PLAY_TAKIS_KILLBASH
		TakisResetHammerTime(me.player)
		L_ZLaunch(me,6*me.scale)
		P_Thrust(me,ang,-6*me.scale)
	end
	/*
	takis.hitlag.tics = TR/4
	takis.hitlag.speed = takis.accspeed
	takis.hitlag.momz = me.momz*takis.gravflip
	takis.hitlag.angle = me.player.drawangle
	takis.hitlag.frame = me.frame
	takis.hitlag.sprite2 = me.sprite2
	takis.hitlag.pflags = me.player.pflags
	*/
end

local function clutchhurt(t,tm)
	local p = t.player
	local takis = p.takistable
	local me = p.mo
	
	if CanPlayerHurtPlayer(p,tm.player)
		local ang = R_PointToAngle2(t.x,t.y, tm.x,tm.y)
		stopmom(takis,me,ang)
		
		TakisAddHurtMsg(tm.player,HURTMSG_CLUTCH)
		P_DamageMobj(tm,t,t,4)
		
		SpawnEnemyGibs(t,tm)
		SpawnBam(tm,{me.momx,me.momy})

		S_StartSound(tm,sfx_smack)
		
		ang = R_PointToAngle2(tm.x,tm.y, t.x,t.y)
		if tm.health
			P_Thrust(tm,ang,-6*me.scale)
			P_MovePlayer(tm.player)
		end
	end
end

local function knockbacklolll(t,tm)
	if not t
	or not t.valid
		return
	end
	
	if not tm
	or not tm.valid
		return
	end
	
	if not L_ZCollide(t,tm)
		return
	end
	
	local p = t.player
	local takis = p.takistable
	local me = p.mo
	
	--BUT.....
	if t.skin ~= TAKIS_SKIN
		return
	end

	if tm.parent == t
		return false
	
	end
	
	local takis = t.player.takistable
	
	local ff = CV_FindVar("friendlyfire").value

	--is this a player we're running into?
	if tm.type == MT_PLAYER
		if t.skin == TAKIS_SKIN
			if (takis.accspeed < 60*FU)
			
				--are we both afterimaging?
				if ((takis.afterimaging) and (tm.player.takistable.afterimaging))
					
					--heartcard priority
					if takis.heartcards > tm.player.takistable.heartcards
						clutchhurt(t,tm)
					
					--port priority
					--melee reference !!
					elseif #p < #tm.player
						clutchhurt(t,tm)
					end
				elseif (takis.afterimaging)
					clutchhurt(t,tm)
				end
			
			--going fast turns the other person into mush
			else
				--this strangly still kills momentum,,,
				--ehh whatever
				
				--are we both afterimaging?
				if ((takis.afterimaging) and (tm.player.takistable.afterimaging))
					
					--we have to be going faster than the other guy
					if takis.accspeed > tm.player.takistable.accspeed
					and CanPlayerHurtPlayer(p,tm.player)
						SpawnEnemyGibs(t,tm)
						SpawnBam(tm)

						S_StartSound(t,sfx_bsnipe)
						
						TakisAddHurtMsg(tm.player,HURTMSG_CLUTCH)
						P_DamageMobj(tm,t,t,1,DMG_INSTAKILL)
						
						LaunchTargetFromInflictor(1,t,tm,63*t.scale,takis.accspeed/5)
						P_MovePlayer(tm.player)
						return true
					end
				
				elseif (takis.afterimaging)
					if CanPlayerHurtPlayer(p,tm.player)
						
						SpawnEnemyGibs(t,tm)
						SpawnBam(tm)

						S_StartSound(t,sfx_bsnipe)
						
						TakisAddHurtMsg(tm.player,HURTMSG_CLUTCH)
						P_DamageMobj(tm,t,t,1,DMG_INSTAKILL)
						
						LaunchTargetFromInflictor(1,t,tm,63*t.scale,takis.accspeed/5)
						P_MovePlayer(tm.player)
						return true
					end
				end
				
			end
		end
		return
	end
	
	if CanFlingThing(tm,MF_ENEMY|MF_BOSS|MF_SHOOTABLE)
		if takis.afterimaging
		or p.pflags & PF_SPINNING
			local ang = R_PointToAngle2(t.x,t.y, tm.x,tm.y)
			stopmom(takis,me,ang)
			
			--if not (p.pflags & PF_SPINNING)
				S_StartSound(tm,sfx_smack)
				S_StartSound(me,sfx_sdmkil)
				SpawnEnemyGibs(t,tm,ang)
				SpawnBam(tm)
				
				spawnragthing(tm,t)
				if (me.state == S_PLAY_TAKIS_SLIDE)
					S_StartSound(me,sfx_smack)
				end
				if (takis.transfo & TRANSFO_BALL)
					S_StartSound(me,sfx_bowl)
				end
				
			--end
			
		end
		
	end
	
end

addHook("ShouldDamage", function(mo,inf,sor,dmg,dmgt)
	if not mo
	or not mo.valid
		return
	end
	
	if mo.skin ~= TAKIS_SKIN
		return
	end
	
	local p = mo.player
	local takis = p.takistable

	if p.deadtimer > 10
		return
	end
	
	if (takis.transfo & TRANSFO_SHOTGUN)
	and (TAKIS_NET.chaingun)
	and ((inf and inf.valid) and inf.type == MT_TAKIS_GUNSHOT)
		return false
	end

	if p.nightsfreeroam
	and p.powers[pw_carry] != CR_NIGHTSMODE
	and not p.powers[pw_flashing]
		if (inf == mo
		or sor == mo)
			return
		end
		
		--fireass
		local extraheight = false
		if dmgt == DMG_FIRE
		and (p.powers[pw_carry] ~= CR_NIGHTSMODE)
			if not (p.powers[pw_shield] & SH_PROTECTFIRE)
			and not (takis.transfo & TRANSFO_FIREASS)
				S_StartSound(mo,sfx_trnsfo)
				takis.transfo = $|TRANSFO_FIREASS
				takis.fireasssmoke = TR/2
				takis.fireasstime = 10*TR
				extraheight = true
				TakisAwardAchievement(p,ACHIEVEMENT_FIREASS)
			else
				takis.fireasstime = $+3
				if takis.fireasstime > 10*TR
					takis.fireasstime = 10*TR
				end
				return false
			end
		end
		
		if not extraheight
			S_StartSound(mo,sfx_nghurt)
			if p.nightstime > TICRATE*5
				p.nightstime = $-TICRATE*5
			else
				p.nightstime = 0
			end
		end
		
		S_StartSound(mo,sfx_smack)
		DoQuake(p,30*FU*(max(1,p.timeshit*2/3)),15)
		S_StartAntonOw(mo)

		SpawnEnemyGibs(inf or mo,mo)

		TakisResetHammerTime(p)

		P_DoPlayerPain(p,sor,inf)
		takis.ticsforpain = TR

		S_StartSound(mo,sfx_shldls)
		if (dmgt == DMG_SPIKE)
			S_StartSound(mo,sfx_spkdth)
		end
		
		p.timeshit = $+1
		takis.timeshit = $+1
		takis.totalshit = $+1
		
		if takis.totalshit >= 100 then TakisAwardAchievement(p,ACHIEVEMENT_OFFICER) end
		if inf
		and inf.valid
			local ang = R_PointToAngle2(mo.x,mo.y, inf.x, inf.y)
			P_InstaThrust(mo,ang,GetPainThrust(mo,inf,sor))
		end
		L_ZLaunch(mo,(extraheight) and 17*mo.scale or 8*mo.scale)
		if not extraheight
			mo.state = S_PLAY_PAIN
		else
			mo.state = S_PLAY_DEAD
		end
		
		takis.inFakePain = true
		p.pflags = $ &~(PF_THOKKED|PF_JUMPED)
		takis.thokked = false
		takis.dived = false
		if (dmgt == DMG_ELECTRIC)
			S_StartSound(mo,sfx_buzz2)
			mo.state = S_PLAY_DEAD
			takis.transfo = $|TRANSFO_ELEC
			takis.electime = TR*3/2
			L_ZLaunch(mo,4*mo.scale)
		end
		
		return
	end
	
	--quit camping, crawla!
	if takis.inFakePain
		return false
	end
	
	if dmgt == DMG_DEATHPIT
		if p.exiting then return end
		if TAKIS_MISC.inspecialstage then return end
		
		if takis.timesdeathpitted > 5
			takis.saveddmgt = DMG_DEATHPIT
			return true
		end
		if takis.heartcards ~= 1
			if p.powers[pw_flashing] == 0
				TakisHealPlayer(p,mo,takis,3)
				DoQuake(p,30*FU*(max(1,p.timeshit*2/3)),15)
				
				p.timeshit = $+1
				takis.timeshit = $+1
				takis.totalshit = $+1
				if takis.totalshit >= 100 then TakisAwardAchievement(p,ACHIEVEMENT_OFFICER) end
				
				S_StartSound(mo,sfx_smack)
				S_StartAntonOw(mo)
				TakisHurtMsg(p,inf,sor,DMG_DEATHPIT)
				takis.pittime = 6
			end
			
			takis.timesdeathpitted = $+1
			TakisResetHammerTime(p)
			
			L_ZLaunch(mo,20*mo.scale*takis.timesdeathpitted)
			mo.state = S_PLAY_ROLL
			p.pflags = $|PF_JUMPED &~(PF_THOKKED|PF_SPINNING)
			takis.thokked = false
			takis.dived = false
			takis.fakeflashing = flashingtics*2
			takis.HUD.statusface.painfacetic = 3*TR
			
			return false
		end
		
	elseif dmgt == DMG_CRUSHED
		if takis.timescrushed < TR
			takis.beingcrushed = true
			return false
		end
	elseif dmgt == DMG_FIRE
		if takis.transfo & TRANSFO_FIREASS
			return false
		end
	end
	
end,MT_PLAYER)

addHook("PlayerHeight",function(p)
	if not p
	or not p.valid
		return
	end
	
	if not p.takistable
		return
	end
	
	if ((p.realmo) and (p.realmo.valid))
		local me = p.realmo
		local takis = p.takistable
		
		if me.skin == TAKIS_SKIN
			if takis.crushtime
			or (p.playerstate == PST_DEAD and takis.saveddmgt == DMG_CRUSHED)
				local high = P_GetPlayerHeight(p)
				if p.pflags & PF_SPINNING
					high = P_GetPlayerSpinHeight(p)
				end
				
				return FixedMul(high,FixedDiv(me.spriteyscale,FU))
			end
			if (takis.transfo & TRANSFO_TORNADO)
			and not (takis.nadocrash)
				return P_GetPlayerSpinHeight(p)
			end
		end
	end
end)

addHook("PlayerCanEnterSpinGaps",function(p)
	if not p
	or not p.valid
		return
	end
	
	if not p.takistable
		return
	end
	
	if ((p.realmo) and (p.realmo.valid))
		local me = p.realmo
		local takis = p.takistable
		
		if me.skin == TAKIS_SKIN
			local phigh = me.height
			
			if takis.crushtime
				local high = P_GetPlayerHeight(p)
				if p.pflags & PF_SPINNING
					high = P_GetPlayerSpinHeight(p)
				end
				phigh = FixedMul(high,FixedDiv(me.spriteyscale,FU))
			end
			if ((takis.transfo & TRANSFO_TORNADO)
			and not (takis.nadocrash))
			or (me.state == S_PLAY_TAKIS_SLIDE)
				phigh = P_GetPlayerSpinHeight(p)
			end
			
			if phigh <= P_GetPlayerSpinHeight(p)
				return true
			end
		end
	end
end)

local function hammerhitbox(t,tm)
	if not t
	or not t.valid
		return
	end
	
	if not tm
	or not tm.valid
		return
	end
	
	if not (t.parent and t.parent.valid) then return end
	
	if tm == t.parent
		return
	end
	
	if not L_ZCollide(t,tm)
		return
	end
	
	if tm.type == MT_PLAYER
		
		if CanPlayerHurtPlayer(t.parent.player,tm.player)
			TakisAddHurtMsg(tm.player,HURTMSG_HAMMERBOX)
			P_DamageMobj(tm,t,t.parent,5)
		else
			if tm.skin == "peppino"
				peptoboxed(tm)
			end
		end
	else
		
		if CanFlingThing(tm)
			P_DamageMobj(tm,t,t.parent)
		elseif SPIKE_LIST[tm.type]
			P_KillMobj(tm,t,t.parent)
		end
		
		
	end
end

addHook("MobjCollide",hammerhitbox,MT_TAKIS_HAMMERHITBOX)

local function tauntbox(t,tm)
	if not t
	or not t.valid
		return
	end
	
	if not tm
	or not tm.valid
		return
	end
	
	if tm == t.tracer
		return
	end
	
	if not L_ZCollide(t,tm)
		return
	end
	
	if (t.boxtype == "bat")
		if tm.type == MT_PLAYER
			
			if tm.battime then return end 
			
			SpawnEnemyGibs(t,tm)
			SpawnEnemyGibs(t,tm)
			TakisResetTauntStuff(tm.player.takistable)
			TakisAwardAchievement(t.tracer.player,ACHIEVEMENT_HOMERUN)
			
			--this wont kill without ff in coop, but its funnier that way
			P_DamageMobj(tm,t,t.tracer,1,DMG_INSTAKILL)
			
			local ang = t.tracer.player.drawangle
			
			P_InstaThrust(tm,ang, 175*FU)
			L_ZLaunch(tm,60*FU)
			
			S_StartSound(nil,sfx_homrun,tm.player)
			
			local ghs = P_SpawnGhostMobj(t)
			ghs.fuse = 10*TR
			ghs.flags2 = $|MF2_DONTDRAW
			S_StartSound(ghs,sfx_homrun)
			
			if tm.health
				tm.state = S_PLAY_PAIN
			end
			
			tm.battime = 4
		else
			if (t.alreadydid) then return end
			
			if CanFlingThing(tm)
				SpawnEnemyGibs(t,tm)
				SpawnEnemyGibs(t,tm)
				spawnragthing(tm,t.tracer)
				local ghs = P_SpawnGhostMobj(t)
				ghs.fuse = 10*TR
				ghs.flags2 = $|MF2_DONTDRAW
				S_StartSound(ghs,sfx_homrun)
				t.alreadydid = true
			end
		end
	end
end

addHook("MobjCollide",tauntbox,MT_TAKIS_TAUNT_HITBOX)

local function givecardpieces(mo, _, source)

	if not source
	or not source.valid
		return
	end
	
	
	if source
	and source.skin == TAKIS_SKIN
	and source.player
	and source.player.valid
	
		if source.player.takistable.combo.time
		and mo.takis_givecombotime
			TakisGiveCombo(source.player,source.player.takistable,false)
		end
		
		local givescore = true
		if G_RingSlingerGametype()
			givescore = false
		end
		if (HAPPY_HOUR.othergt) then givescore = false end
		
		--stop being OP >:(
		if (mo.takis_givecombotime
		or mo.takis_givecardpieces)
		and (givescore == true)
			P_AddPlayerScore(source.player,10)
		end
		
	end
	
end

addHook("MobjDeath", givecardpieces)

--thing died by takis
local function hurtbytakis(mo,inf,sor,_,dmgt)
	
	if (not mo.health
	and CanFlingThing(mo,MF_ENEMY))
	and (sor and sor.skin == TAKIS_SKIN)
		if CanFlingThing(mo,MF_ENEMY)
			if P_RandomChance(FU/2)
			and (TAKIS_NET.cards)
				local card = P_SpawnMobjFromMobj(mo,0,0,mo.height*P_MobjFlip(mo),MT_TAKIS_HEARTCARD)
				L_ZLaunch(card,10*mo.scale)
				mo.heartcard = card
			end
		end
	end
	
	if not sor
	or not sor.valid
		--did something die outta nowhere?
		if not mo.health
		and CanFlingThing(mo)
			for p2 in players.iterate
				if not (p2 and p2.valid) then continue end
				if p2.quittime then continue end
				if p2.spectator then continue end
				if not (p2.mo and p2.mo.valid) then continue end
				if (not p2.mo.health) or (p2.playerstate ~= PST_LIVE) then continue end
				if (p2.mo.skin ~= TAKIS_SKIN) then continue end
				
				--forgot radius
				if not P_CheckSight(mo,p2.mo) then continue end
				local dx = p2.mo.x-mo.x
				local dy = p2.mo.y-mo.y
				local dz = p2.mo.z-mo.z
				local dist = TAKIS_TAUNT_DIST*5
				
				if FixedHypot(FixedHypot(dx,dy),dz) > dist
					continue
				end
				
				TakisGiveCombo(p2,p2.takistable,true,nil,nil,true)
				
			end
		end
		
		return
	end
	
	if not (sor.player and sor.player.valid) then return end
	
	if sor.skin ~= TAKIS_SKIN
		local bleader = sor.player.botleader
		
		if sor.player.bot
		and (bleader and bleader.valid)
		and (bleader.mo and bleader.mo.valid)
		and (bleader.mo.skin == TAKIS_SKIN)
		and (CanFlingThing(mo,MF_ENEMY|MF_BOSS)
		or (SPIKE_LIST[mo.type] == true)
		or (mo.type == MT_PLAYER)
		and (not mo.ragdoll))
			if not mo.health
				TakisGiveCombo(bleader,bleader.takistable,true)
			else
				TakisGiveCombo(bleader,bleader.takistable,false,true)
			end
		end
		
		return
	end
	
	if mo.ragdoll
		return
	end
	
	if CanFlingThing(mo,MF_MONITOR)
		TakisGiveCombo(sor.player,sor.player.takistable,true)
		sor.player.takistable.HUD.statusface.happyfacetic = 3*TR/2
	end
	
	if sor.player
	and sor.player.takistable
		if CanFlingThing(mo)
		and (dmgt ~= DMG_NUKE)
			if (inf and inf.valid and inf.player and inf.player.valid)
			and (inf.player.takistable.dived
			or inf.player.takistable.thokked)
				inf.player.takistable.dived = false
				inf.player.takistable.thokked = false
				inf.player.pflags = $ &~PF_THOKKED
			end
			/*
			if inf.type == MT_THROWNSCATTER
			and inf.shotbytakis
				spawnragthing(mo,inf,sor)
			end
			*/
		end
		
		if CanFlingThing(mo,MF_ENEMY|MF_BOSS)
		or (SPIKE_LIST[mo.type] == true)
		or (mo.type == MT_PLAYER)
		and (not mo.ragdoll)
			if (mo.type ~= MT_PLAYER)
			and (dmgt == DMG_NUKE)
			and not (TAKIS_NET.nerfarma)
				SpawnRagThing(mo,sor)
			end
			
			if not mo.health
				if not (mo.flags & MF_BOSS)
					TakisGiveCombo(sor.player,sor.player.takistable,true)
				else
					if not (TAKIS_MISC.inbossmap
					or TAKIS_MISC.inbrakmap)
						TakisGiveCombo(sor.player,sor.player.takistable,true)
					end
				end
			--only damaged
			else
				TakisGiveCombo(sor.player,sor.player.takistable,false,true)
			end
			
			if mo.type == MT_PLAYER
				if (not mo.health)
				--not if we killed ourselves though
				and (mo ~= sor)
					sor.player.takistable.HUD.statusface.evilgrintic = 2*TR
				end
				if mo.player.takistable.tauntjoinable
				or mo.player.takistable.tauntacceptspartners
					TakisAwardAchievement(sor.player,ACHIEVEMENT_PARTYPOOPER)
				end
			end
		
		end
		
	end

end
local function diedbytakis(mo,inf,sor)
	hurtbytakis(mo,inf,sor)
end

addHook("MobjDeath", hurtbytakis)
addHook("MobjDamage", diedbytakis)

--takis died by thing
addHook("MobjDeath", function(mo,i,s,dmgt)
	local p = mo.player
	local takis = p.takistable
	
	if (s and s.valid)
	and (s.skin == TAKIS_SKIN)
	and (s.player and s.player.valid)
	and (s.player.takistable.heartcards ~= TAKIS_MAX_HEARTCARDS)
	and (not (gametyperules & GTR_FRIENDLY))
		TakisHealPlayer(s.player,s,s.player.takistable,1,1)
		S_StartSound(mo,sfx_takhel,s.player)
	end
	
	if mo.skin ~= TAKIS_SKIN
		return
	end
	
	if (p.gotflag)
		P_PlayerFlagBurst(p,false)
	end
	
	if (mo.state ~= S_PLAY_DEAD)
		mo.state = S_PLAY_DEAD
	end
	
	TakisResetHammerTime(p)
	
	if (takis.heartcards > 0)
		takis.HUD.heartcards.shake = $+TAKIS_HEARTCARDS_SHAKETIME
	end
	
	takis.combo.time = 0
	takis.saveddmgt = dmgt
	
	if (mo.eflags & MFE_UNDERWATER)
		takis.saveddmgt = DMG_DROWNED
	end
	if P_InSpaceSector(mo)
		takis.saveddmgt = DMG_SPACEDROWN
	end
	
	if takis.saveddmgt == DMG_DROWNED
		if (not takis.inWater) and mo.player.powers[pw_spacetime]
			--we need to set this because srb2 is silly
			takis.saveddmgt = DMG_SPACEDROWN
		else
			takis.saveddmgt = DMG_DROWNED
		end
	elseif takis.saveddmgt == DMG_SPACEDROWN
		takis.saveddmgt = DMG_SPACEDROWN
	end
	
	if p == consoleplayer
		S_StopSoundByID(mo,sfx_antow1)
		S_StopSoundByID(mo,sfx_antow2)
		S_StopSoundByID(mo,sfx_antow3)
		S_StopSoundByID(mo,sfx_antow4)
		S_StopSoundByID(mo,sfx_antow5)
		S_StopSoundByID(mo,sfx_antow6)
		S_StopSoundByID(mo,sfx_antow7)
	end
	
end,MT_PLAYER)

--double jump
addHook("AbilitySpecial", function(p)
	if p.mo.skin ~= TAKIS_SKIN then return end
	
	if p.takistable.thokked
	or (p.takistable.noability & NOABIL_THOK)
	or (p.pflags & PF_JUMPSTASIS)
		return true
	end
	if ((p.takistable.inPain) or (p.takistable.inFakePain))
		return true
	end
	
	local me = p.mo
	local takis = p.takistable
	
	P_DoJump(p,false)
	S_StopSoundByID(me,skins[TAKIS_SKIN].soundsid[SKSJUMP])
	takis.thokked = true
	takis.hammerblastjumped = 0
	
	P_SetObjectMomZ(p.mo,15*FU)
	
	p.mo.state = S_PLAY_ROLL
	if ((takis.transfo & TRANSFO_FIREASS) and (takis.firethokked))
		p.mo.state = S_PLAY_FALL
		P_MovePlayer(p)
		S_StartSound(me,sfx_fire)
		takis.fireasssmoke = TR/2
		
		TakisSpawnDustRing(me,16*me.scale,-3*me.scale,8)
		
	else
		--wind ring
		local ring = P_SpawnMobjFromMobj(me,
			0,0,-5*me.scale*takis.gravflip,MT_WINDRINGLOL
		)
		if (ring and ring.valid)
			ring.renderflags = RF_FLOORSPRITE
			ring.frame = $|FF_TRANS50
			ring.startingtrans = FF_TRANS50
			ring.scale = FixedDiv(me.scale,2*FU)
			P_SetObjectMomZ(ring,-me.momz*2*takis.gravflip)
			--i thought this would fade out the object
			ring.fuse = 10
			ring.destscale = FixedMul(ring.scale,2*FU)
			ring.colorized = true
			ring.color = SKINCOLOR_WHITE
		end
	
		S_StartSoundAtVolume(me,sfx_takdjm,4*255/5)
	end
	
	p.jp = 1
	p.jt = 5
	p.pflags = $|(PF_JUMPED|PF_JUMPDOWN|PF_THOKKED|PF_STARTJUMP) & ~(PF_SPINNING|PF_STARTDASH)
	if takis.isSuper
	or ((takis.transfo & TRANSFO_FIREASS) and (takis.firethokked == false))
		p.pflags = $ &~PF_THOKKED
		takis.thokked = false
		takis.firethokked = true
	end
	return true
end)

--jump effect
addHook("JumpSpecial", function(p)
	if p.mo.skin ~= TAKIS_SKIN then return end
	
	local me = p.mo
	local takis = p.takistable
	
	if not takis then return end
	
	if takis.jump > 1 then return end
	if (takis.thokked or p.pflags & PF_THOKKED) then return end
	if (takis.jumptime > 0) then return end
	
	if takis.onGround
	or takis.coyote
		local maxi = P_RandomRange(8,16)
		for i = 0, maxi
			local fa = FixedAngle(i*FixedDiv(360*FU,maxi*FU))
			local dust = TakisSpawnDust(me,
				fa,
				0,
				P_RandomRange(-1,2)*me.scale,
				{
					xspread = 0,
					yspread = 0,
					zspread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
					
					thrust = 0,
					thrustspread = 0,
					
					momz = P_RandomRange(0,1)*me.scale,
					momzspread = P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1),
					
					scale = me.scale,
					scalespread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
					
					fuse = 12+P_RandomRange(-2,3),
				}
			)
			dust.momx = FixedMul(sin(fa),me.radius)/2
			dust.momy = FixedMul(cos(fa),me.radius)/2
		end

		local wind = P_SpawnMobjFromMobj(me,0,0,0,MT_WINDRINGLOL)
		wind.scale = me.scale
		
		wind.fuse = 7
		wind.tics = -1
		
		wind.frame = A
		wind.sprite = SPR_RAIN
		wind.frame = B
		
		wind.renderflags = $|RF_PAPERSPRITE
		wind.startingtrans = FF_TRANS10
		
		wind.angle = R_PointToAngle2(0, 0, me.momx, me.momy)
		wind.spritexscale,wind.spriteyscale = me.scale,me.scale
		wind.rollangle = R_PointToAngle2(0, 0, R_PointToDist2(0, 0, me.momx, me.momy),FixedMul(9*FU,p.jumpfactor)) + ANGLE_90
	end
end)

--takis moved into a thing
--this should be used as the main movecollide hook from now on
addHook("MobjMoveCollide",function(tm,t)
	if not (tm.player or ((t) and (t.valid)))
		return
	end
	
	--erm, again?
	if not (t and t.valid)
		return
	end
	
	if (tm.skin ~= TAKIS_SKIN)
		return
	end
	
	local p = tm.player
	local takis = p.takistable
	
	if not (L_ZCollide(tm,t))
		return
	end
	
	if takis
		
		knockbacklolll(tm,t)
		
		--destroy these stupid doors
		if ((t.type == MT_SALOONDOOR) or (t.type == MT_SALOONDOORCENTER))
			if ((t.valid) and (t.health) and not (t.flags & MF_NOCLIP))
			and (takis.afterimaging)
			and (gametyperules & GTR_FRIENDLY)
				S_StartSound(t,sfx_wbreak)
				S_StartSound(t,sfx_s3k59)
				
				SpawnEnemyGibs(tm,t,nil,true)
				
				SpawnBam(t)
				
				if (t.type == MT_SALOONDOOR)
					t.flags = $|MF_NOCLIP
					TakisGiveCombo(p,takis,true)
					P_KillMobj(t, tm, tm)
				--waht !??
				elseif (t.type == MT_SALOONDOORCENTER)
					t.flags = $|MF_NOCLIP
				end
				
				return false
			end
		--springs keep our momentum!
		--only horizontal springs
		elseif (t.flags & MF_SPRING)
		and L_ZCollide(t,tm)
			if ((mobjinfo[t.type].mass == 0) and (mobjinfo[t.type].damage > 0))
				TakisResetHammerTime(p)
				P_InstaThrust(tm,t.angle,takis.prevspeed+mobjinfo[t.type].damage)
				tm.angle,p.drawangle = t.angle,t.angle
				tm.eflags = $|MFE_SPRUNG
				takis.fakesprung = true
				p.homing = 0
				
				S_StartSound(t,mobjinfo[t.type].painsound)
				t.state = mobjinfo[t.type].raisestate
				
				if (mobjinfo[t.type].painsound == sfx_cdfm62)
					if (t.flags2 & MF2_AMBUSH)
					and not (takis.transfo & TRANSFO_BALL)
						S_StartSound(tm,sfx_trnsfo)
						tm.state = S_PLAY_ROLL
						p.pflags = $|PF_SPINNING
						takis.transfo = $|TRANSFO_BALL
						TakisAwardAchievement(p,ACHIEVEMENT_BOWLINGBALL)
					end
					
					/*
					takis.nadocount = 3
					if not (takis.transfo & TRANSFO_TORNADO)
						takis.transfo = $|TRANSFO_TORNADO
					end
					if not (TakisReadAchievements(p) & ACHIEVEMENT_TORNADO)
						takis.nadotuttic = 5*TR
					end
					
					TakisAwardAchievement(p,ACHIEVEMENT_TORNADO)
					*/
				end
				
				return false
			end
		--people bowling
		elseif (t.type == MT_PLAYER)
		and ((t.player) and (t.player.valid))
		and (p.pflags & PF_SPINNING)
		and L_ZCollide(t,tm)
			if CanPlayerHurtPlayer(p,t.player)
				if not (takis.transfo & TRANSFO_BALL)
					TakisAddHurtMsg(t.player,HURTMSG_SLIDE)
				else
					TakisAddHurtMsg(t.player,HURTMSG_BALL)
				end
				P_DamageMobj(t,tm,tm,10)
				LaunchTargetFromInflictor(1,t,tm,63*tm.scale,takis.accspeed/5)
				P_Thrust(tm,p.drawangle,5*tm.scale)
				L_ZLaunch(t,P_RandomRange(5,15)*tm.scale,true)
				
				SpawnEnemyGibs(t,tm)
				SpawnBam(tm)
				
				S_StartSound(t,sfx_bowl)
				S_StartSound(tm,sfx_smack)
			end
		--spike stuff
		elseif (SPIKE_LIST[t.type] == true)
			--we mightve ran into a spike thing
			if t.health
			and ((p.powers[pw_strong] & STR_SPIKE) 
			or (takis.afterimaging)
			or (takis.transfo & (TRANSFO_TORNADO|TRANSFO_BALL)))
				P_KillMobj(t,tm,tm)
				if takis.transfo & TRANSFO_BALL
					local sfx = P_SpawnGhostMobj(tm)
					sfx.flags2 = $|MF2_DONTDRAW
					sfx.tics,sfx.fuse = 3*TR,3*TR
					S_StartSound(sfx,sfx_bowl)
				end
				return false
			end
		--fling solids
		elseif CanFlingSolid(t,tm)
		and (takis.afterimaging or p.powers[pw_invulnerability] or takis.isSuper or takis.transfo & TRANSFO_BALL)
			if not (t and t.valid) then return end
			local j1,j2 = t,tm
			local tm = j1
			local t = j2
			
			for i = 0, 34
				A_BossScream(tm,1,MT_SONIC3KBOSSEXPLODE)
			end
			local sfx = P_SpawnGhostMobj(tm)
			sfx.flags2 = $|MF2_DONTDRAW
			sfx.tics = 3*TR
			sfx.fuse = 3*TR
			S_StartSound(sfx,sfx_tkapow)
			
			local fling = P_SpawnMobjFromMobj(tm,0,0,0,MT_TAKIS_FLINGSOLID)
			local ang = R_PointToAngle2(tm.x,tm.y, t.x,t.y)
			fling.angle = ang
			fling.radius = tm.radius
			fling.height = tm.height
			fling.state = tm.state
			fling.fuse = 3*TR
			fling.color = tm.color
			L_ZLaunch(fling,
				P_RandomRange(10,15)*tm.scale+P_RandomFixed()
			)
			P_Thrust(fling,
				ang,
				-FixedMul(takis.accspeed,tm.scale)/3
			)
			if (fling.renderflags & RF_PAPERSPRITE)
			or (fling.frame & FF_PAPERSPRITE)
				fling.angle = $+ANGLE_90
			end
			
			SpawnBam(tm)
			local rad = 600*tm.scale
			for p2 in players.iterate
				
				local m2 = p2.realmo
				
				if not m2 or not m2.valid
					continue
				end
				
				if (FixedHypot(m2.x-tm.x,m2.y-tm.y) <= rad)
					DoQuake(p,
						FixedMul(
							20*FU, FixedDiv( rad-FixedHypot(m2.x-tm.x,m2.y-tm.y),rad )
						),
						10
					)
				end
			end
			S_StartSound(fling,sfx_crumbl)
			S_StartSound(fling,sfx_wbreak)
			
			if (multiplayer)
				--thok does our bidding for us
				local thok = P_SpawnMobjFromMobj(tm,0,0,0,MT_THOK)
				thok.camefromsolid = true
				thok.respawntime = CV_FindVar("respawnitemtime").value * TICRATE
				thok.solid = {
					type = tm.type,
					state = tm.state,
					pos = {tm.x,tm.y,tm.z},
					flags = tm.flags,
					flags2 = tm.flags2,
					angle = tm.angle,
					scale = tm.scale,
					color = tm.color
				}
			end
			
			P_RemoveMobj(tm)
			TakisGiveCombo(p,takis,true)
			
			return false
		end
		
	end
end,MT_PLAYER)

-- collision stuff for 'nado
addHook("MobjMoveBlocked", function(mo, thing, line)
	if not mo
	or not mo.valid
		return
	end
	
	local p = mo.player
	local takis = p.takistable
	
	if p.mo
	and p.mo.valid
		local me = p.mo
		
		if me.skin ~= TAKIS_SKIN
			return
		end
		
		if ((thing) and (thing.valid)) or ((line) and (line.valid))
			if (takis.transfo & TRANSFO_TORNADO)
				if takis.nadotic then return end
				if takis.accspeed <= 7*FU then return end
				
				local oldangle = me.angle
				if thing and thing.valid
					if thing.flags & MF_MONITOR
						return
					end
					
					P_BounceMove(me)
					me.angle = FixedAngle(AngleFixed($)+(180*FU))
					p.drawangle = me.angle
				elseif line and line.valid
					--me.angle = FixedAngle(180*FU-AngleFixed($))
					P_BounceMove(me)
					me.angle = FixedAngle(AngleFixed($)+(180*FU))
					p.drawangle = me.angle
				end
				
				DoQuake(p,15*me.scale,5)
				S_StartSound(me,sfx_slam)
				
				takis.nadotic = 3
				if (takis.nadocount == 1)
					takis.nadocrash = TR*3/2
					me.state = S_PLAY_DEAD
				end
				
				if (takis.nadocount > 0)
					takis.nadocount = $-1
				end
				
				return true
			end
		end
	end
end, MT_PLAYER)

addHook("MobjDeath", function(mobj, inflictor, source)
	if source 
	and source.valid 
	and source.player 
	and source.player.valid
	and source.player.mo
	and source.player.mo.valid
	and source.skin == TAKIS_SKIN
		local p = source.player
		
		TakisResetHammerTime(p)
		
		source.state = S_PLAY_GASP
	end
end, MT_EXTRALARGEBUBBLE)

filesdone = $+1
