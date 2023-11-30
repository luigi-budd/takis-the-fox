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
	-make freezing actually kill you
	-[done]freeze combo while finished in pizza time
	-[done]movecollide for springs to keep momentum (booster boost)
	-[done]stupid thinkframe for detecting PF_SLIDING
	-[done]also make speedpad sectors keep momentum
	-[done]reuse soap code for ptje ranks
	-death anims
	-[scrapped]wall bonk lol
	-add bot stuff
	-[done]happy hour for other skins?
	-[done]fc stuff?
	-[done]custom arma to bbreak more stuff (like spikes)
	-[done]PASSWORD!!!
	-[done]make recov jump not rely on flashing
	-[done]dont kill team boxes on other teams
	-conga?
	-string the combo bar into 1, long graphic, use cropped to crop?
	-[done]tf2 taunt menu
	-countdown nums for drawtimer
	-instant finishes in multiplayer, prob after a special stage, most
	 noticable in stages with capsules
	-[done]make heartcards give score at the end
	-[done]maybe increase the homerun bat hitbox? because, yknow, the hammer
	 is big
	-[done]cursor style for the taunt menu, nums <-> cursor
	-crit sfx
	-war timer and war timer custom gfx
	-[done]RETRO STATUSFACE FOR MARIO TOLS
	-[done]save after loading to remove invalid saves
	-[done]save during exiting
	-finish death anims
	-[done]cosmenu like soap's
	-homework varient of happy hour
	-[done]toggle for loud and dangerous taunts
	-taunt_t info?
	-rs neo stuff for taunt functions
	-[done]fix io quicktaunts being broken
	-dont let quick taunts spam "you cant do this"
	-[done]MORE WIND LINES
	-[done]little icon above people with cosmenus open'
	-[done]cosmenu "dear pesky plumbers..." letter
	-update customhud init funcs
	-find out whats making the erz1 fof conveyors hyperspeed
	-[done]only sweat if we're running
	-make a function to add takis_menu pages
	-move all hud related code in shorts to their respective hud
	 drawing function
	 actually,, maybe dont, thatll make it fps dependant
	-spingebobb #1 hat option
	-[done]add cosmenu scolling
	-[done]when counting num destroyables, add a var to the mobj to mark it
	 as yet-to-be-destroyed. only increase thingsdestroyed if that
	 var is true
	-[done]make sure shields function properly
	-[scrapped]optional paperdoll over statusface
	-[done]pw_strong?
	-[done]still break other types of "spikes" alongside STR_SPIKE
	-milne kick
	-taunt icons
	-ach icons
	-move all takis.HUD editting code from LUA_hud to TakisHUDStuff
	-set takis.issuperman to random when nightserized, if true,
	 spawn a superman cape
	-if the Verys draw past the bottom of the screen, only draw 1 and
	 put a x3240 for the # of Verys
	-maybe give all hud elements V_PERPLAYER??
	-[done]fix the clutch being slow with smaller scales
	-MORE EFFECTS!!
	-placements in drawscore?
	-happy hour trigger and exit objects
	-[done??]dedicated servers may be breaking heart cards?
	-[done]rings give too much score
	-we may be loading other people's cfgs??
	-[done]offset afterimages to start at salmon
	-sometimes shotgun shots dont give combo?
	-[done]cap clutch boosts at 5
	-[done]linedef trigger to open dialog
	-[done]pt spice runners support
	-[done]replace menu patches with drawfill
	-takisfest ach being buggy as hell, keeps doign every tiem
	-[done]redo the cos menu. antonblast styled?
	-[done]remove disciplinary action
	-[done]happy hour is weird when it is synched
	-replace hud items only when switching, like engi
	-cosmenu scrolling if text goes past hints
	-sometimes the PTSR bar doesnt show with nohappyhour?
	-synch happy hour for joining players
	-transformations
	-bat taunt keeps colorization if interuppted
	-textspectator hud stuff
	
	--ANIM TODO
	-redo smug sprites
	-reuse spng for jump
	-the tail on roll frames doesnt point the right way
	-redo walk 4th angle
	
	--PLANNED MAPHEADERS
	-[done]Takis_HH_Music - regular happyhour mus, ignore styles
	-[done]Takis_HH_EndMusic - ending happyhour mus, ignore styles
	-[done]Takis_HH_NoMusic - disable happyhour mus
	-[done]Takis_HH_NoEndMusic - disable happyhour end mus
	-[done]Takis_HH_Timelimit - timelimit (in tics)
	
	
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

local ranktonum = {
	["P"] = 6,
	["S"] = 5,
	["A"] = 4,
	["B"] = 3,
	["C"] = 2,
	["D"] = 1,
}

addHook("PlayerThink", function(p)
	if not p
	or not p.valid
		return
	end
	
	if not p.takistable
		TakisInitTable(p)
		return
	end
	
	if not p.takistable.io.loaded
		if p.takistable.io.loadwait
			p.takistable.io.loadwait = $-1
		else
			TakisLoadStuff(p)
		end
	end
	
	--whatev
	p.takistable.isTakis = skins[p.skin].name == TAKIS_SKIN
	
	if ((p.realmo) and (p.realmo.valid))
		local me = p.realmo
		local takis = p.takistable
		
		if not (p.powers[pw_invulnerability])
			p.scoreadd = 0
		end
		
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
		
		TakisButtonStuff(p,takis)
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
			
			--dude stop!!!
			if (p.charflags & SF_SUPER)
				p.charflags = $ &~SF_SUPER
			end
			
			--forced strafe
			if takis.io.nostrafe == 0
			and (takis.notCarried)
			and not ((p.pflags & (PF_SPINNING|PF_STASIS))
			or (p.powers[pw_nocontrol]))
			and not (p.powers[pw_carry] == CR_NIGHTSMODE)
				p.drawangle = me.angle
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
				end
				if p.powers[pw_carry] == CR_NIGHTSMODE
					
					if (p.exiting)
						--fancy explosions for HH
						if takis.nightsexplode
							
							for k = 0,2
								for i = 0,18-(p.exiting/7)
									local fa = i*FixedAngle(FU*20)+
										FixedAngle(P_RandomRange(-3,3)*FU)
									local x,y = ReturnTrigAngles(fa)
									local range = 365+(p.exiting*22/20)
									local xvar = 50
									local yvar = 50*(i+1)
									local thok = P_SpawnMobjFromMobj(me,
										range*x+P_RandomRange(-yvar,yvar)*me.scale,
										range*y+P_RandomRange(-yvar,yvar)*me.scale,
										P_RandomRange(-yvar,yvar)*me.scale,
										MT_THOK
									)
									
									thok.flags2 = $|MF2_DONTDRAW
									A_BossScream(thok,1,MT_SONIC3KBOSSEXPLODE)
								end
							end
						end
						
						if (p.exiting <= 45)
						and (me.health)
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
				if not (leveltime % 4)
				and takis.onGround
				and not p.powers[pw_sneakers]
					me.friction = $-(FU/50)
				end
			end
			
			--spin specials
			if takis.use > 0
			and p.powers[pw_carry] ~= CR_NIGHTSMODE
			
				if (not takis.shotgunned)
					--clutch
					if takis.use == 1
					and takis.onGround
					and not takis.taunttime
					and me.health
					and (me.state ~= S_PLAY_GASP)
					and (takis.notCarried)
					and (me.sprite2 ~= SPR2_PAIN)
					and not PSO
					and not (takis.yeahed)
					and (p.realtime > 0)
					and not (takis.c2 and me.state == S_PLAY_TAKIS_SLIDE)
					and not (takis.noability & NOABIL_CLUTCH)
						
						local ccombo = min(takis.clutchcombo,3)
						
						if takis.io.nostrafe == 1
							local ang = (p.cmd.angleturn << 16) + R_PointToAngle2(0, 0, p.cmd.forwardmove << 16, -p.cmd.sidemove << 16)
							p.drawangle = ang
						end
						
						S_StartSoundAtVolume(me,sfx_clutch,255/2)
						if not takis.clutchingtime
							S_StartSoundAtVolume(me,sfx_cltch2,255/2)
						end
						
						p.pflags = $ &~PF_SPINNING
						takis.clutchingtime = 1
						--print(takis.clutchtime)
						
						local thrust = FixedMul( (4*FU), (ccombo*FU)/2 )
						
						--not too fast, now
						if thrust >= 13*FU
						and not (p.powers[pw_sneakers])
							thrust = 13*FU
						end
						
						--clutch boost
						if (takis.clutchtime > 0)
							if (takis.clutchtime <= 11)
								--if takis.clutchcombo > 1
								
									takis.clutchcombo = $+1
									takis.clutchcombotime = 2*TR
									
									S_StartSoundAtVolume(me,sfx_kc5b,255/3)
									
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
									
									P_Thrust(me,p.drawangle,3*me.scale/2)
									thrust = $+(3*FU/2)+FU
								--end
							--dont thrust too early, now!
							elseif takis.clutchtime > 16
								
								takis.clutchspamcount = $+1
								takis.clutchcombo = 0
								takis.clutchcombotime = 0
								thrust = FU/5
								
							end
						end
						
						/*
						for i = 0, 10 do
							P_SpawnSkidDust(p,15*me.scale)
						end
						*/
						
						if p.powers[pw_sneakers]
							thrust = $*9/5
						end
						
						if p.gotflag
							thrust = $/4
						end
						
						local  ang = (p.cmd.angleturn << 16) + R_PointToAngle2(0, 0, p.cmd.forwardmove << 16, -p.cmd.sidemove << 16)
						
						if (takis.accspeed > 55*FU)
						and not (p.powers[pw_sneakers])
							thrust = 0
						end
						
						thrust = FixedMul(thrust,me.scale)
						
						P_Thrust(me,/*p.drawangle*/ang,thrust)
						
						/*
						local x,y = ReturnTrigAngles(p.drawangle-ANGLE_90)
						local d1 = P_SpawnMobjFromMobj(me,16*x,16*y,0,MT_TAKIS_CLUTCHDUST)
						x,y = ReturnTrigAngles(p.drawangle)
						P_SetOrigin(d1,d1.x-16*x,d1.y-16*y,d1.z)
 						d1.angle = R_PointToAngle2(me.x+me.momx,me.y+me.momy,d1.x,d1.y)
						P_SetOrigin(d1,d1.x,d1.y,d1.z)
						*/
						
						--xmom code
						local d1 = P_SpawnMobjFromMobj(me, -20*cos(p.drawangle + ANGLE_45), -20*sin(p.drawangle + ANGLE_45), 0, MT_TAKIS_CLUTCHDUST)
						local d2 = P_SpawnMobjFromMobj(me, -20*cos(p.drawangle - ANGLE_45), -20*sin(p.drawangle - ANGLE_45), 0, MT_TAKIS_CLUTCHDUST)
						d1.angle = R_PointToAngle2(me.x+me.momx, me.y+me.momy, d1.x, d1.y) --- ANG5
						d2.angle = R_PointToAngle2(me.x+me.momx, me.y+me.momy, d2.x, d2.y) --+ ANG5
						
						if takis.accspeed < skins[TAKIS_SKIN].runspeed
							P_Thrust(me,p.drawangle,FixedMul(skins[TAKIS_SKIN].runspeed-takis.accspeed,me.scale))
						end
						
						--TODO replace with clutchstart
						me.state = S_PLAY_RUN
						P_MovePlayer(p)
						takis.clutchtime = 23
						takis.clutchspamtime = 23
						
						if takis.clutchspamcount == 5
							TakisAwardAchievement(p,ACHIEVEMENT_CLUTCHSPAM)
						end
						
						p.jp = 2
						p.jt = -5
						
					end
					
					--hammer blast
					if takis.use == (TR/4)
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
						P_SetObjectMomZ(me,
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
						local ang = (p.cmd.angleturn << 16) + R_PointToAngle2(0, 0, p.cmd.forwardmove << 16, -p.cmd.sidemove << 16)
						S_StartSoundAtVolume(me,sfx_takdiv,255/4)
						P_Thrust(me,ang,14*me.scale)
					end
				else
					
					--shotgun shot
					if (takis.use == 1)
					and not (takis.shotguncooldown)
					and not (takis.inPain or takis.inFakePain)
					and not (takis.noability & NOABIL_SHOTGUN
					or p.pflags & PF_SPINNING)
						P_Thrust(me,p.drawangle,-10*me.scale)
						P_MovePlayer(p)
						
						takis.shotguncooldown = 18
						
						local x,y = ReturnTrigAngles(p.drawangle)
						
						/*
						local sht = P_SpawnMobjFromMobj(me,85*x+me.momx,85*y+me.momy,0,MT_TAKIS_SHOTGUN_HITBOX)
						sht.tracer = me
						sht.tics = 5
						sht.angle = p.drawangle
						*/
						
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
					
						local ang = (p.cmd.angleturn << 16) + R_PointToAngle2(0, 0, p.cmd.forwardmove << 16, -p.cmd.sidemove << 16)
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
						CreateWindRing(p,me)

						p.pflags = $|PF_THOKKED &~(PF_JUMPED)
						takis.dived = true
						takis.thokked = true
						
						me.state = S_PLAY_GLIDE
						P_SetObjectMomZ(me,7*FU)
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
						local ang = (p.cmd.angleturn << 16) + R_PointToAngle2(0, 0, p.cmd.forwardmove << 16, -p.cmd.sidemove << 16)
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
							P_SetObjectMomZ(me,3*FU)
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
							if takis.fire
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
				and not (takis.inwaterslide)
				and not (takis.noability & NOABIL_SLIDE)
					S_StartSound(me,sfx_eeugh)
					S_StartSound(me,sfx_taksld)
					P_InstaThrust(me,p.drawangle,20*FU+FixedMul(3*takis.accspeed/5,me.scale))
					me.state = S_PLAY_TAKIS_SLIDE
					p.pflags = $|PF_SPINNING
					P_MovePlayer(p)
					if not ((p.cmd.forwardmove) and (p.cmd.sidemove))
					and takis.accspeed < 13*FU
						takis.slidetime = max(1,$)
						P_InstaThrust(me,p.drawangle,15*FU)
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
						P_SetObjectMomZ(me,101*FU,true)
						
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
				and takis.shotgunned
				and not (takis.tossflag)
					TakisDeShotgunify(p)
				end
				
				if takis.c3 == TR
					if (P_RandomChance(10))
						P_DamageMobj(me,nil,nil,1,DMG_INSTAKILL)
					end
					if P_RandomChance(1)
					and (takis.isSinglePlayer)
						G_ExitLevel()
					end
					if P_RandomChance(FU/70)
						if takis.HUD.funny.tics == 0
							S_StartSound(nil,sfx_jumpsc,p)
							TakisAwardAchievement(p,ACHIEVEMENT_JUMPSCARE)
							takis.HUD.funny.tics = 3*TR
							takis.HUD.funny.y = 400*FU
							takis.HUD.funny.alsofunny = P_RandomChance(FU/10)
						end
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
				or me.state == S_PLAY_TAKIS_SMUGASSGRIN2
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
				and not (takis.tauntcanparry)
					P_RestoreMusic(p)
					takis.taunttime = 0
					me.colorized = takis.wascolorized
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
			if takis.hammerblastdown
				p.charflags = $ &~SF_RUNONWATER
				p.powers[pw_strong] = $|(STR_SPRING|STR_HEAVY)
				takis.noability = $|NOABIL_SHOTGUN|NOABIL_HAMMER
				--control better
				p.thrustfactor = $*3/2
				
				if (takis.shotgunned)
					if me.state ~= S_PLAY_TAKIS_SHOTGUNSTOMP
						p.panim = PA_FALL
						me.state = S_PLAY_TAKIS_SHOTGUNSTOMP
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
					
				end
				
				takis.hammerblastjumped = 0
				if takis.hammerblastdown == 1
					if not (me.eflags & MFE_UNDERWATER)
						P_SetObjectMomZ(me,12*FU)
					else
						P_SetObjectMomZ(me,7*FU)
					end
					takis.hammerblastwentdown = false
				end
				
				takis.thokked,takis.dived = true,true
				
				if (me.flags2 & MF2_TWOD)
					p.drawangle = takis.hammerblastangle
				end
				
				if me.momz*takis.gravflip < (8*me.scale)
				or takis.hammerblastwentdown == true
					
					local x = cos(p.drawangle)
					local y = sin(p.drawangle)
					
					
					if takis.hammerblastwentdown == false
					and not (takis.shotgunned)
						takis.hammerblasthitbox = P_SpawnMobjFromMobj(me,42*x,42*y,me.momz,MT_TAKIS_HAMMERHITBOX)
						takis.hammerblasthitbox.parent = me
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
					
					me.momz = $-((3*me.scale/2)*takis.gravflip)		
					if (takis.shotgunned)
						me.momz = $-((me.scale*14/10)*takis.gravflip)
					end
					
					takis.hammerblastwentdown = true
					
				end
				
				if takis.hammerblasthitbox
				and takis.hammerblasthitbox.valid
					local x = cos(p.drawangle)
					local y = sin(p.drawangle)
					local z = me.z
					if me.eflags & MFE_VERTICALFLIP
						z = (me.z+me.height-takis.hammerblasthitbox.height)
					end
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
					if ((takis.hammerblasthitbox) and (takis.hammerblasthitbox.valid))
						me.state = S_PLAY_MELEE_FINISH
						P_RemoveMobj(takis.hammerblasthitbox)
						takis.hammerblasthitbox = nil
					end
					
					--dust effect
					if not (me.eflags & MFE_TOUCHWATER)
					and not (takis.shotgunned)
						for i = 0, 16
							local mt = MT_SPINDUST
							if me.eflags & MFE_UNDERWATER
								mt = MT_MEDIUMBUBBLE
							end

							local radius = me.scale*16
							local fa = (i*ANGLE_22h)
							local x = cos(me.angle)
							local y = sin(me.angle)
							local dust = P_SpawnMobjFromMobj(me,25*x,25*y,0,mt)
							dust.momx = FixedMul(sin(fa),radius)
							dust.momy = FixedMul(cos(fa),radius)
							dust.destscale = dust.scale/2
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
									if (found.type ~= MT_EGGMAN_BOX)
									or (found.takis_flingme ~= false)
										if (found.flags & (MF_ENEMY|MF_BOSS))
										or (found.flags & MF_MONITOR)
										or (found.takis_flingme)
											spawnragthing(found,me)
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
							local time = min(takis.hammerblastdown,TR*3/2)
							takis.hammerblastjumped = 1
							P_DoJump(p,false)
							me.state = S_PLAY_ROLL
							me.momz = 20*takis.gravflip*me.scale+(time*takis.gravflip*me.scale/8)
							S_StartSoundAtVolume(me,sfx_kc52,180)
							shouldntcontinueslide = true
							
						--holding spin while landing? boost us forward!
						elseif (takis.use > 0)
						and me.health
							if not takis.dropdashstale
								S_StartSound(me,sfx_cltch2)
							else
								S_StartSound(me,sfx_didbad)
							end
							
							me.state = S_PLAY_RUN
							
							takis.clutchingtime = 0
							takis.glowyeffects = takis.hammerblastdown/3
							
							local ang = (p.cmd.angleturn << 16) + R_PointToAngle2(0, 0, p.cmd.forwardmove << 16, -p.cmd.sidemove << 16)
							
							if ((me.flags2 & MF2_TWOD)
							or (twodlevel))
								if (p.cmd.sidemove > 0)
									ang = p.drawangle
								elseif (p.cmd.sidemove < 0)
									ang = InvAngle(p.drawangle)
								end
							end
							
							local thrust = (10*me.scale)+((takis.hammerblastdown*me.scale)/2)+(takis.use*me.scale/8)
							if (p.powers[pw_sneakers])
								thrust = $*9/5
							end
							
							P_InstaThrust(me,ang,
								FixedDiv(
									FixedMul(takis.accspeed,me.scale)+thrust,
									max(FU,takis.dropdashstale*3/2*me.scale)
								),
								true
							)
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
			end
			
			if takis.hammerblastjumped
				takis.hammerblastjumped = $+1
				if takis.hammerblastjumped == (6*7)
					takis.hammerblastjumped = 0
				end
			end
			
			if takis.clutchingtime
			or takis.glowyeffects
			and ((me.health) or (p.playerstate == PST_LIVE))
			or (takis.hammerblastdown and (me.momz*takis.gravflip <= -40*me.scale)
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
						end
					end
				end
				
				p.charflags = $|SF_CANBUSTWALLS
				
				if (takis.accspeed >= skins[TAKIS_SKIN].normalspeed)
					p.charflags = $|SF_RUNONWATER
				else
					p.charflags = $ &~SF_RUNONWATER
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
				p.runspeed = skins[TAKIS_SKIN].runspeed
				takis.afterimagecolor = 1
			end
			
			--hold this off until we can detect udmf bouncy fofs
			/*
			print(stupidbouncesectors(me,me.subsector.sector))
			stupidbouncesectors(me,me.subsector.sector)
			if (stupidbouncesectors(me,me.subsector.sector))
				print(":bouncy fof")
			end
			*/
			
			--stuff to do while grounded
			if takis.onGround
				if (p.pflags & PF_SHIELDABILITY)
				and (p.powers[pw_shield] == SH_BUBBLEWRAP)
					P_DoBubbleBounce(p)
					p.pflags = $ &~PF_THOKKED
					takis.thokked = false
					me.state = S_PLAY_ROLL
				end
				
				if takis.inFakePain
					takis.fakeflashing = 4*flashingtics/5
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
					P_SpawnSkidDust(p,8*me.scale+( FixedMul(takis.accspeed-(10*FU),me.scale)*4/5 ),sfx_s3k64)
					if takis.accspeed >= 40*FU
						P_SpawnSkidDust(p,3*me.scale+( FixedMul(takis.accspeed-(10*FU),me.scale)*3/5 ))
					end
					P_ButteredSlope(me)
					takis.clutchingtime = $-2
					takis.noability = $|NOABIL_SHOTGUN
				end
				takis.dived = false
				if takis.hammerblastjumped >= 3
					takis.hammerblastjumped = 0
				end
				if not ((me.eflags & MFE_TOUCHWATER) and not ((me.eflags & MFE_UNDERWATER) or (P_IsObjectInGoop(me))))
					takis.lastgroundedpos = {me.x,me.y,me.z}
				end
				takis.thokked = false
				
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
					if ((me.frame == A) or (me.frame == E))
						if not takis.steppedthisframe
							local sfx = P_RandomRange(sfx_takst1,sfx_takst3)
							
							S_StartSoundAtVolume(me,sfx_takst0,255/2)
							S_StartSound(me,sfx)
							takis.steppedthisframe = true
							P_SpawnSkidDust(p,3*me.scale)
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
						end
						P_SetOrigin(me,me.x,me.y,me.z)
						for i = 0, 8
							local mt = MT_SPINDUST
							if me.eflags & MFE_UNDERWATER
								mt = MT_MEDIUMBUBBLE
							end
							local radius = me.scale*16
							local fa = (i*ANGLE_45)
							local dust = P_SpawnMobjFromMobj(me,0,0,0,mt)
							local mz = takis.prevmomz/10
							dust.momx = FixedMul(FixedMul(sin(fa),radius),mz)
							dust.momy = FixedMul(FixedMul(cos(fa),radius),mz)
							dust.destscale = dust.scale/2
							takis.dontlanddust = true
						end
					end
				end
				
				if (P_PlayerTouchingSectorSpecial(p, 3, 6) 
				or P_PlayerTouchingSectorSpecial(p, 3, 5))
					P_Thrust(me,me.angle,takis.prevspeed)
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
				takis.timescrushed = $+1
				
				if not takis.crushtime
					S_StartSound(me,sfx_tsplat)
				end
				--used to reset crushed
				takis.crushtime = TR
			else
				if not takis.crushtime
					if (takis.saveddmgt ~= DMG_CRUSHED)
						DoTakisSquashAndStretch(p,me,takis)
					end
				else
					local div = (takis.crushtime/8)
					div = max(1,$)
					me.spriteyscale = FU/div
					me.spritexscale = FU*div					
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
				
				if ((takis.body) and (takis.body.valid))
					P_MoveOrigin(takis.body,me.x,me.y,me.z)
					takis.body.rollangle = me.rollangle
				end
				
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
					takis.combo.frozen = true
					if ((p.exiting) and not (p.pflags & PF_FINISHED))
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
				
				if takis.combo.lastcount < TAKIS_NET.partdestroy
				and takis.combo.count >= TAKIS_NET.partdestroy
				and not takis.combo.dropped
				and (gametype == GT_COOP)
				and not (maptol & TOL_NIGHTS)
				and not (TAKIS_NET.inbossmap or TAKIS_NET.inbrakmap)
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
					takis.combo.count = 0
					S_StartSound(nil,sfx_kc59,p)
					takis.combo.outrotics = 7*TR/5
					
					takis.HUD.flyingscore.lastscore = takis.combo.score
					
					S_StartSound(nil,sfx_chchng,p)
					P_AddPlayerScore(p,takis.combo.score)
					
					takis.HUD.flyingscore.num = takis.combo.score
					takis.HUD.flyingscore.tics = $+2*TR
					local backx = 15*FU
					local backy = 70*FU
					takis.HUD.flyingscore.x = backx+5*FU+takis.HUD.combo.patchx
					takis.HUD.flyingscore.y = backy+7*FU
				
					if not (p.pflags & PF_FINISHED)
						if not takis.combo.dropped
							takis.combo.dropped = true
							if takis.combo.lastcount >= TAKIS_NET.partdestroy
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
			
			--we're being carried!
			if not (takis.notCarried)
				takis.thokked,takis.dived = false,false
				takis.inFakePain = false
				if not (takis.inwaterslide)
					takis.afterimaging = false
				end
				TakisResetHammerTime(p)
				takis.dontfootdust = true
			end
			
			--this is actually stupid
			if p.exiting > 0
				
				if (p.pflags & PF_FINISHED)
					takis.combo.time = 0
					takis.fakeexiting = $+1
					--time for bonuses!
					if takis.fakeexiting == 1
						
						if (takis.heartcards == 1)
						and (p.timeshit >= 3)
						and (p.playerstate == PST_LIVE)
							TakisAwardAchievement(p,ACHIEVEMENT_HARDCORE)
						end
						
						if takis.shotgunned
							if ((takis.shotgun) and (takis.shotgun.valid))
								P_KillMobj(takis.shotgun,me)
							end
							takis.shotgun = 0
							takis.shotgunned = false
							P_AddPlayerScore(p,80000)
							takis.bonuses["shotgun"].tics = 3*TR+18
							takis.bonuses["shotgun"].score = 80000
							takis.HUD.flyingscore.scorenum = $+80000
							S_StartSound(nil,sfx_chchng,p)
						end	
					end
					
					if takis.combo.awardable
						takis.combo.awardable = false
						P_AddPlayerScore(p,50000)
						takis.HUD.flyingscore.scorenum = $+50000
						takis.bonuses["ultimatecombo"].tics = 3*TR+18
						takis.bonuses["ultimatecombo"].score = 50000
						S_StartSound(nil,sfx_chchng,p)
						TakisAwardAchievement(p,ACHIEVEMENT_COMBO)
					end
					
					if (p.exiting ~= 1)
						if (takis.heartcards)
							local tic = 77/TAKIS_MAX_HEARTCARDS
							tic = $ or 1
							
							if not (takis.fakeexiting % tic)
								
								if takis.heartcards
									takis.heartcards = $-1
									S_StartSound(nil,sfx_takhel,p)
									P_AddPlayerScore(p,1000)
									table.insert(takis.bonuses.cards,{tics = TR+18,score = 1000,text = "\x8EHeart Card"})
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
					if TAKIS_NET.inbossmap
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
				
				if not takis.setmusic
				and (p.pflags & PF_FINISHED)
					ChangeTakisMusic("_ABCLR", false, p)
					takis.setmusic = true
					takis.yeahwait = (2*TR)+(TR/2)+5
				end

			
				if takis.yeahwait == 0
				and (p.powers[pw_carry] ~= CR_NIGHTSMODE)
				--and (p.pflags & PF_FINISHED)
					
					if not takis.yeahed
						if p.panim == PA_IDLE
						and ((takis.onGround) or P_CheckDeathPitCollide(me))
						and takis.yeahwait == 0
							if not takis.camerascale
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
				elseif (rank == "B")
					takis.HUD.rank.score = p.score-(per*2)
					takis.HUD.rank.percent = $*2
				elseif (rank == "A")
					takis.HUD.rank.score = p.score-(per*3)
					takis.HUD.rank.percent = $*5
				elseif (rank == "S")
					takis.HUD.rank.score = p.score-(per*8)
					takis.HUD.rank.percent = $*5
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
		else
		
			--just switched
			if not takis.otherskin
				takis.otherskin = true
				me.colorized = takis.wascolorized
				TakisResetTauntStuff(takis,true)
			else
				takis.otherskintime = $+1
			end
			
			takis.combo.time = 0
			TakisAnimateHappyHour(p)
			if HAPPY_HOUR.time
			and (takis.io.nohappyhour == 0
			and takis.io.morehappyhour == 1)
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
			if HAPPY_HOUR.timelimit
			
				if HAPPY_HOUR.timeleft
					local tics = HAPPY_HOUR.timeleft
					local time = hud.timeshake
					
					if tics <= (56*TR)
					and (takis.io.nohappyhour == 0)
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
			end

			if (takis.shotgunned)
				TakisDeShotgunify(p)
			end
		end
		
		--outside of shorts (and skin check!!!!) to check for
		--last rank
		if (p.ptsr_rank)
			takis.lastrank = ranktonum[p.ptsr_rank]
		end

		for i = 0,#takis.hurtmsg-1
			if takis.hurtmsg[i].tics > 0
				takis.hurtmsg[i].tics = $-1
			end
		end
		
		--holding FN, C3, C1 open menu
		if (takis.firenormal >= TR)
		and (takis.c3 >= TR)
		and (takis.c2 >= TR)
		and not (takis.cosmenu.menuinaction)
			TakisMenuOpenClose(p)
		end
		
		takis.combo.lastcount = takis.combo.count
		takis.lastmap = gamemap
		takis.lastgt = gametype
		takis.lastdestroyed = takis.thingsdestroyed
	end
	
end)

addHook("PlayerSpawn", function(p)
	local x,y = ReturnTrigAngles(p.realmo.angle)
	/*
	if (TAKIS_DEBUGFLAG & DEBUG_HAPPYHOUR)
		P_SpawnMobjFromMobj(p.mo,100*x,100*y,0,MT_HHTRIGGER)
	end
	*/
	
	if (skins[p.skin].name == TAKIS_SKIN)
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
	
	if p.takistable
		local takis = p.takistable
		local me = p.realmo
		
		TakisResetHammerTime(p)
		TakisDeShotgunify(p)
		
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
		
		takis.thingsdestroyed = 0
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
		
		if player.takistable.afterimaging
		or (
			me.state == S_PLAY_TAKIS_SLIDE
			and
			--we need to be able to make afterimages to do this!
			not (player.takistable.noability & (NOABIL_CLUTCH|NOABIL_HAMMER))
		)
			if L_ZCollide(me,mobj)
			and ((mobj.flags & MF_ENEMY)
			--and (mobj.type ~= MT_ROSY)
			and (mobj.type ~= MT_SHELL))
			or (mobj.takis_flingme)
				
				--prevent killing blow sound from mobjs way above/below us
				
				SpawnBam(mobj)
				
				--P_KillMobj(mobj, me, me) --actually kill the thing. looking at you, lance-a-bots!
				
				spawnragthing(mobj,me)
				if (me.state == S_PLAY_TAKIS_SLIDE)
					S_StartSound(me,sfx_smack)
				end
				
				return true
				
			end
			
		end
	end
end)

--handle takis damage here
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
	
	if (sor and sor.valid)
	and (sor.skin == TAKIS_SKIN)
	and( not (gametyperules & GTR_FRIENDLY))
	and (sor.player.takistable.heartcards ~= TAKIS_MAX_HEARTCARDS)
	and not (mo.health)
		TakisHealPlayer(sor.player,sor,1,1)
		S_StartSound(mo,sfx_takhel,sor.player)
	end
	
	if mo.skin ~= TAKIS_SKIN
		return
	end

	--BUT!!
	if (p.powers[pw_shield] == SH_ARMAGEDDON)
		TakisPowerfulArma(p)
		takis.fakeflashing = flashingtics
		return true
	end
	
	p.pflags = $ &~PF_SHIELDABILITY
	
	--do parry
	if (takis.taunttime > 0)
	and inf and inf.valid
	and (takis.tauntcanparry)
		local me = mo
		local p = p
		
		S_StartSound(me,sfx_sparry)
		if (inf.player and inf.player.valid)
			S_StartSound(inf,sfx_sparry,inf.player)
		end
		
		takis.taunttime = 0
		takis.tauntid = 0
		
		P_SetObjectMomZ(me,10*me.scale)
		local pthrust = R_PointToAngle2(inf.x-inf.momx,inf.y-inf.momy,me.x-me.momx,me.y-me.momy)
		P_Thrust(me,pthrust,5*me.scale)
		P_MovePlayer(p)
		me.state = S_PLAY_ROLL
		
		S_StopSoundByID(mo,sfx_antow1)
		S_StopSoundByID(mo,sfx_antow2)
		S_StopSoundByID(mo,sfx_antow3)
		S_StopSoundByID(mo,sfx_antow4)
		S_StopSoundByID(mo,sfx_antow5)
		S_StopSoundByID(mo,sfx_antow6)
		S_StopSoundByID(mo,sfx_antow7)
		S_StopSoundByID(me, sfx_tawhip)
		
		SpawnBam(mo)

		if inf.player
			if inf.player.powers[pw_invulnerability]
				inf.player.powers[pw_invulnerability] = 0
				P_RestoreMusic(inf.player)
			end
			P_DoPlayerPain(inf.player,mo,mo)
			local angle = R_PointToAngle2(mo.x,mo.y,inf.x,inf.y )
			local thrust = FU*10
			P_SetObjectMomZ(inf,thrust)
			P_Thrust(inf,angle,thrust)
			inf.player.powers[pw_flashing] = 2
		end
		if inf
			P_DamageMobj(inf,mo,mo)
		end
		
		if ((sor) and (sor.valid))
			P_DamageMobj(sor,mo,mo)
		end
		
		p.powers[pw_flashing] = TICRATE
		return true
	end
	
	if mo.health
	or (takis.heartcards)
		S_StartSound(mo,sfx_smack)
		DoQuake(p,30*FU*(max(1,p.timeshit*2/3)),15)
		S_StartAntonOw(mo)
	end

	if p.powers[pw_carry] == CR_NIGHTSMODE
		if not multiplayer
			if HAPPY_HOUR.happyhour
				HAPPY_HOUR.timelimit = p.nightstime
			end
		end
		
		return
	end
	
	--combo penalty
	if (takis.shotgunned)
		TakisGiveCombo(p,takis,false,false,true)
	end
	
	if takis.heartcards > 0
	and (p.powers[pw_shield] == SH_NONE)
		TakisResetHammerTime(p)
		if takis.heartcards == 1
			P_KillMobj(mo,inf,sor,dmgt)
			
			--lose EVERYTHING
			P_PlayerRingBurst(p,p.rings)
			P_PlayerWeaponAmmoBurst(p)
			P_PlayerWeaponPanelBurst(p)
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
		
		--award points to source
		if (sor and sor.valid
		and sor.player and sor.player.valid)
			if (gametyperules &
			(GTR_POINTLIMIT|GTR_RINGSLINGER|GTR_HURTMESSAGES)
			or G_RingSlingerGametype())
				P_AddPlayerScore(sor.player,50)
			end
		end
		
		p.powers[pw_flashing] = TR
		takis.ticsforpain = TR
		S_StartSound(mo,sfx_shldls)
		if (dmgt & DMG_SPIKE)
			S_StartSound(mo,sfx_spkdth)
		end
		TakisHealPlayer(p,mo,takis,3)
		p.timeshit = $+1
				
		if inf
		and inf.valid
			local ang = R_PointToAngle2(mo.x,mo.y, inf.x, inf.y)
			P_InstaThrust(mo,ang,-9*mo.scale)
		end
		P_SetObjectMomZ(mo,14*mo.scale)
		mo.state = S_PLAY_PAIN
		takis.inFakePain = true
		p.pflags = $ &~(PF_THOKKED|PF_JUMPED)
		takis.thokked = false
		takis.dived = false
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
		P_SetObjectMomZ(me,6*me.scale)
		P_Thrust(me,ang,-6*me.scale)
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
						if CanPlayerHurtPlayer(p,tm.player)
							local ang = R_PointToAngle2(t.x,t.y, tm.x,tm.y)
							stopmom(takis,me,ang)
							
							TakisAddHurtMsg(tm.player,HURTMSG_CLUTCH)
							P_DamageMobj(tm,t,t,4)
							
							SpawnBam(tm)

							S_StartSound(tm,sfx_smack)
							
							ang = R_PointToAngle2(tm.x,tm.y, t.x,t.y)
							if tm.health
								P_Thrust(tm,ang,-6*me.scale)
								P_MovePlayer(tm.player)
							end
						end
					--port priority
					--melee reference !!
					elseif #p < #tm.player
						if CanPlayerHurtPlayer(p,tm.player)
							local ang = R_PointToAngle2(t.x,t.y, tm.x,tm.y)
							stopmom(takis,me,ang)
							
							TakisAddHurtMsg(tm.player,HURTMSG_CLUTCH)
							P_DamageMobj(tm,t,t,4)
							
							SpawnBam(tm)

							S_StartSound(tm,sfx_smack)
							
							ang = R_PointToAngle2(tm.x,tm.y, t.x,t.y)	
							if tm.health
								P_Thrust(tm,ang,-6*me.scale)
								P_MovePlayer(tm.player)
							end
						end
					end
				elseif (takis.afterimaging)
				
					if CanPlayerHurtPlayer(p,tm.player)
						local ang = R_PointToAngle2(t.x,t.y, tm.x,tm.y)
						stopmom(takis,me,ang)
						
						TakisAddHurtMsg(tm.player,HURTMSG_CLUTCH)
						P_DamageMobj(tm,t,t,4)
						
						SpawnBam(tm)

						S_StartSound(tm,sfx_smack)
						
						ang = R_PointToAngle2(tm.x,tm.y, t.x,t.y)		
						if tm.health
							P_Thrust(tm,ang,-6*me.scale)
							P_MovePlayer(tm.player)
						end
					end
					
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
	
	if tm.flags & (MF_ENEMY|MF_BOSS|MF_SHOOTABLE)
	or tm.takis_flingme
		if takis.afterimaging
		or p.pflags & PF_SPINNING
			local ang = R_PointToAngle2(t.x,t.y, tm.x,tm.y)
			stopmom(takis,me,ang)
			
			if not (p.pflags & PF_SPINNING)
				S_StartSound(tm,sfx_smack)
				SpawnBam(tm)				
				
				spawnragthing(tm,t)
			end
			
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
	
	if p.nightsfreeroam
	and p.powers[pw_carry] != CR_NIGHTSMODE
	and not p.powers[pw_flashing]
		if (inf == mo
		or sor == mo)
			return
		end
		S_StartSound(mo,sfx_nghurt)
		if p.nightstime > TICRATE*5
			p.nightstime = $-TICRATE*5
		else
			p.nightstime = 0
		end
		takis.fakeflashing = flashingtics
		DoQuake(p,30*FU*(max(1,p.timeshit*2/3)),15)
		p.timeshit = $+1
		S_StartSound(mo,sfx_smack)
		S_StartAntonOw(mo)
		P_DoPlayerPain(p,sor,inf)
		
		return
	end
	
	--quit camping, crawla!
	if takis.inFakePain
		return false
	end
	
	if dmgt == DMG_DEATHPIT
		if p.exiting then return end
		if TAKIS_NET.inspecialstage then return end
		
		if takis.timesdeathpitted > 5
			takis.saveddmgt = DMG_DEATHPIT
			return true
		end
		if takis.heartcards ~= 1
			if p.powers[pw_flashing] == 0
				TakisHealPlayer(p,mo,takis,3)
				DoQuake(p,30*FU*(max(1,p.timeshit*2/3)),15)
				p.timeshit = $+1
				S_StartSound(mo,sfx_smack)
				S_StartAntonOw(mo)
			end
			
			takis.timesdeathpitted = $+1
			TakisResetHammerTime(p)
			
			P_SetObjectMomZ(mo,20*mo.scale*takis.timesdeathpitted)
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
	end
	
end,MT_PLAYER)

/*
local function KillSpike(spike, plmo)
    if not (plmo and plmo.valid and plmo.skin == TAKIS_SKIN) then return end
    if plmo.type ~= MT_PLAYER then return end
    if plmo.z + plmo.height < spike.z or (spike.z + (spike.height+(spike.height/2))) < plmo.z then return end

    local player = plmo.player
	
    if player.takistable.afterimaging
	or player.powers[pw_invulnerability]
	and L_ZCollide(spike,plmo)
		P_KillMobj(spike, plmo, plmo)
    end
end

addHook("MobjCollide", KillSpike, MT_SPIKE)
addHook("MobjCollide", KillSpike, MT_WALLSPIKE)
addHook("MobjCollide", KillSpike, MT_SPIKEBALL)
addHook("MobjCollide", KillSpike, MT_BOMBSPHERE)
*/

local function hammerhitbox(t,tm)
	if not t
	or not t.valid
		return
	end
	
	if not tm
	or not tm.valid
		return
	end
	
	if tm == t.parent
		return
	end
	
	if not collide2(t,tm)
		return
	end
	
	if tm.type == MT_PLAYER
		
		if CanPlayerHurtPlayer(t.parent.player,tm.player)
			TakisAddHurtMsg(tm.player,HURTMSG_HAMMERBOX)
			P_DamageMobj(tm,t,t.parent,5)
		end
	else
		
		if SPIKE_LIST[tm.type]
			P_KillMobj(tm,t,t.parent)
			return
		end
		
		if tm.flags & (MF_ENEMY|MF_BOSS|MF_MONITOR)
			P_DamageMobj(tm,t,t.parent)
		--	P_SetObjectMomZ(t.parent,14*t.parent.scale)
		end
		
		/*
		if tm.flags & MF_SPRING
			local z = tm.z
			if (P_MobjFlip(tm) == -1)
				z = tm.z+tm.height
			end
			if P_CheckPosition(t.parent,tm.x,tm.y,z)
			and P_CheckSight(t.parent,tm)
				P_MoveOrigin(t.parent,tm.x,tm.y,z)
				TakisResetHammerTime(t.parent.player)
			end
			return
		end
		*/
		
	end
end

local function hammerhitbox2(tm,t)
	hammerhitbox(tm,t)
end

addHook("MobjCollide",hammerhitbox,MT_TAKIS_HAMMERHITBOX)
addHook("MobjMoveCollide",hammerhitbox2,MT_TAKIS_HAMMERHITBOX)

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
	
	if (t.alreadydid) then return end
	
	if (t.boxtype == "bat")
		if tm.type == MT_PLAYER
			
			TakisResetTauntStuff(tm.player.takistable)
			TakisAwardAchievement(t.tracer.player,ACHIEVEMENT_HOMERUN)
			
			--this wont kill without ff in coop, but its funnier that way
			P_DamageMobj(tm,t,t.tracer,1,DMG_INSTAKILL)
			
			local ang = t.tracer.player.drawangle
			
			P_InstaThrust(tm,ang, 175*FU)
			P_SetObjectMomZ(tm,60*FU)
			
			S_StartSound(nil,sfx_homrun,tm.player)
			
			local ghs = P_SpawnGhostMobj(t)
			ghs.fuse = 10*TR
			ghs.flags2 = $|MF2_DONTDRAW
			S_StartSound(ghs,sfx_homrun)
			
			if tm.health
				tm.state = S_PLAY_PAIN
			end
			
			t.alreadydid = true
		else
			
			if tm.flags & (MF_ENEMY|MF_BOSS)
			or (tm.flags & MF_MONITOR)
			or (tm.takis_flingme ~= false)
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
		if ((gametyperules & GTR_RINGSLINGER) or G_RingSlingerGametype())
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
local function hurtbytakis(mo,inf,sor)
	
	if (not mo.health
	and (mo.takis_flingme ~= false))
	and (sor and sor.skin == TAKIS_SKIN)
		if (mo.flags & MF_ENEMY)
		or (mo.takis_flingme == true)
			if P_RandomChance(FU/2)
			and (TAKIS_NET.cards)
				local card = P_SpawnMobjFromMobj(mo,0,0,mo.height*P_MobjFlip(mo),MT_TAKIS_HEARTCARD)
				P_SetObjectMomZ(card,10*mo.scale)
				mo.heartcard = card
			end
		end
	end
	
	if not sor
	or not sor.valid
		--did something die outta nowhere?
		if not mo.health
		and (((mo.flags & MF_ENEMY) or (mo.flags & MF_BOSS))
		or ( mo.flags & MF_MONITOR)
		or (mo.takis_flingme))
		
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
	
	if sor.skin ~= TAKIS_SKIN
		return
	end
	
	if mo.ragdoll
		return
	end
	
	if mo.flags & MF_MONITOR
		if mo.type ~= MT_EGGMAN_BOX
			TakisGiveCombo(sor.player,sor.player.takistable,true)
			sor.player.takistable.HUD.statusface.happyfacetic = 3*TR/2
			if mo.partofdestoys
			and (sor.player.powers[pw_carry] ~= CR_NIGHTSMODE)
				sor.player.takistable.thingsdestroyed = $+1
			end
		end
	end
	
	if sor.player
	and sor.player.takistable
		if ((mo.flags & MF_ENEMY) or (mo.flags & MF_BOSS))
		or ( mo.flags & MF_MONITOR)
		or (mo.takis_flingme)
			if sor.player.takistable.dived
			or sor.player.takistable.thokked
				sor.player.takistable.dived = false
				sor.player.takistable.thokked = false
				sor.player.pflags = $ &~PF_THOKKED
			end
			/*
			if inf.type == MT_THROWNSCATTER
			and inf.shotbytakis
				spawnragthing(mo,inf,sor)
			end
			*/
		end
		
		if ((mo.flags & MF_ENEMY) or (mo.flags & MF_BOSS))
		or (SPIKE_LIST[mo.type] == true)
		or (mo.type == MT_PLAYER)
		or (mo.takis_flingme)
		and (not mo.ragdoll)
			if not mo.health
				if not (mo.flags & MF_BOSS)
					TakisGiveCombo(sor.player,sor.player.takistable,true)
					if mo.partofdestoys
						sor.player.takistable.thingsdestroyed = $+1
					end
				else
					if not (TAKIS_NET.inbossmap
					or TAKIS_NET.inbrakmap)
						TakisGiveCombo(sor.player,sor.player.takistable,true)
					end
				end
			--only damaged
			else
				TakisGiveCombo(sor.player,sor.player.takistable,false,true)
			end
			
			if mo.type == MT_PLAYER
				if (not mo.health)
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
addHook("MobjDeath", function(mo,_,_,dmgt)
	if mo.skin ~= TAKIS_SKIN
		return
	end
	
	if (mo.state ~= S_PLAY_DEAD)
		mo.state = S_PLAY_DEAD
	end
	
	TakisResetHammerTime(mo.player)
	
	if (mo.player.takistable.heartcards > 0)
		mo.player.takistable.HUD.heartcards.shake = $+TAKIS_HEARTCARDS_SHAKETIME
	end
	
	mo.player.takistable.combo.time = 0
	mo.player.takistable.saveddmgt = dmgt
	
	if (mo.eflags & MFE_UNDERWATER)
		mo.player.takistable.saveddmgt = DMG_DROWNED
	end
	if P_InSpaceSector(mo)
		mo.player.takistable.saveddmgt = DMG_SPACEDROWN
	end
	
	if mo.player.takistable.saveddmgt == DMG_DROWNED
		if (not mo.player.takistable.inWater) and mo.player.powers[pw_spacetime]
			--we need to set this because srb2 is silly
			mo.player.takistable.saveddmgt = DMG_SPACEDROWN
		else
			mo.player.takistable.saveddmgt = DMG_DROWNED
		end
	elseif mo.player.takistable.saveddmgt == DMG_SPACEDROWN
		mo.player.takistable.saveddmgt = DMG_SPACEDROWN
	end
	
	S_StopSoundByID(mo,sfx_antow1)
	S_StopSoundByID(mo,sfx_antow2)
	S_StopSoundByID(mo,sfx_antow3)
	S_StopSoundByID(mo,sfx_antow4)
	S_StopSoundByID(mo,sfx_antow5)
	S_StopSoundByID(mo,sfx_antow6)
	S_StopSoundByID(mo,sfx_antow7)
	
end,MT_PLAYER)
addHook("AbilitySpecial", function(p)
	if p.mo.skin ~= TAKIS_SKIN then return end
	
	if p.takistable.thokked
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
	
	local sfactor = FU
	if (me.eflags & MFE_UNDERWATER)
		sfactor = FixedDiv(117*FRACUNIT, 200*FRACUNIT)
	end
	
	P_SetObjectMomZ(p.mo,FixedMul(15*FU, sfactor))
	
	S_StartSoundAtVolume(me,sfx_takdjm,4*255/5)

	--wind ring
	if not (takis.hammerblastdown % 6)
		local ring = P_SpawnMobjFromMobj(me,
			0,0,-5*me.scale*takis.gravflip,MT_WINDRINGLOL
		)
		if (ring and ring.valid)
			ring.renderflags = RF_FLOORSPRITE
			ring.frame = $|FF_TRANS50
			ring.startingtrans = FF_TRANS50
			ring.scale = FixedDiv(me.scale,2*FU)
			P_SetObjectMomZ(ring,-me.momz*2)
			--i thought this would fade out the object
			ring.fuse = 10
			ring.destscale = FixedMul(ring.scale,2*FU)
			ring.colorized = true
			ring.color = SKINCOLOR_WHITE
		end
	end
	
	p.mo.state = S_PLAY_ROLL
	p.jp = 1
	p.jt = 5
	p.pflags = $|(PF_JUMPED|PF_JUMPDOWN|PF_THOKKED|PF_STARTJUMP) & ~(PF_SPINNING|PF_STARTDASH)
	return true
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
	
	if not (L_ZCollide(tm,t))
		return
	end
	
	local p = tm.player
	local takis = p.takistable
	
	if takis
		
		knockbacklolll(tm,t)
		
		--destroy these stupid doors
		if ((t.type == MT_SALOONDOOR) or (t.type == MT_SALOONDOORCENTER))
			if ((t.valid) and (t.health) and not (t.flags & MF_NOCLIP))
			and (takis.afterimaging)
			and (gametyperules & GTR_FRIENDLY)
				S_StartSound(t,sfx_wbreak)
				S_StartSound(t,sfx_s3k59)
				
				for i = 0,P_RandomRange(5,10)
					local x,y = ReturnTrigAngles(t.angle)
					local debris = P_SpawnMobjFromMobj(t,
						P_RandomRange(-(t.radius/t.scale),(t.radius/t.scale))*x,
						P_RandomRange(-(t.radius/t.scale),(t.radius/t.scale))*y,
						0,
						MT_THOK
					)
					debris.fuse = TR
				end
				
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
				P_InstaThrust(tm,t.angle,takis.prevspeed+mobjinfo[t.type].damage)
				tm.angle,p.drawangle = t.angle,t.angle
				tm.eflags = $|MFE_SPRUNG
				takis.fakesprung = true
				p.homing = 0
				
				S_StartSound(t,mobjinfo[t.type].painsound)
				t.state = mobjinfo[t.type].raisestate
				return false
			end
		--people bowling
		elseif (t.type == MT_PLAYER)
		and ((t.player) and (t.player.valid))
		and (p.pflags & PF_SPINNING)
		and L_ZCollide(t,tm)
			if CanPlayerHurtPlayer(p,t.player)
				TakisAddHurtMsg(t.player,HURTMSG_SLIDE)
				P_DamageMobj(t,tm,tm,10)
				LaunchTargetFromInflictor(1,t,tm,63*tm.scale,takis.accspeed/5)
				P_Thrust(tm,p.drawangle,5*tm.scale)
				P_SetObjectMomZ(t,P_RandomRange(5,15)*tm.scale,true)
				
				SpawnBam(tm)
				
				S_StartSound(t,sfx_bowl)
				S_StartSound(tm,sfx_smack)
			end
		--spike stuff
		elseif (SPIKE_LIST[t.type] == true)
			--we mightve ran into a spike thing
			if t.health
			and (p.powers[pw_strong] & STR_SPIKE)
				P_KillMobj(t,tm,tm)
				return false
			end
		--TODO: fling solids
		elseif (t.flags & MF_SOLID|MF_SCENERY == MF_SOLID|MF_SCENERY)
		and not (t.flags & (MF_SPECIAL|MF_ENEMY|MF_MONITOR|MF_PUSHABLE))
		and (t.health)
		and (takis.afterimaging)
		and (t.parent ~= tm)
		and (t.type ~= MT_PLAYER)
			P_RemoveMobj(t)
			TakisGiveCombo(p,takis,true)
			CONS_Printf(p,"Destroyed solid. TODO: this!")
			return false
		end
		
	end
end,MT_PLAYER)

filesdone = $+1
