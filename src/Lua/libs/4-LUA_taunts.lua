rawset(_G, "TAKIS_TAUNT_DIST",75*FU)

local function L_ZCollide(mo1,mo2)
	if mo1.z > mo2.height+mo2.z then return false end
	if mo2.z > mo1.height+mo1.z then return false end
	return true
end

--taunt inits

local function init_ouch(p)
	local me = p.mo
	local takis = p.takistable
	local menu = takis.tauntmenu
	
	takis.taunttime = 24
	S_StartAntonOw(me)
end

local function init_smug(p)
	local me = p.mo
	local takis = p.takistable
	local menu = takis.tauntmenu
	
	takis.taunttime = 12
	takis.tauntspecial = P_RandomChance(FRACUNIT/10)
	S_StartSound(me,sfx_tawhip)
end

local function init_conga(p)
	local me = p.mo
	local takis = p.takistable
	local menu = takis.tauntmenu
	
	takis.taunttime = 2
	takis.stasistic = 2
	takis.tauntacceptspartners = false
	P_PlayJingleMusic(p,"_conga",0,true,JT_OTHER)
end

local function init_bat(p)
	local me = p.mo
	local takis = p.takistable
	local menu = takis.tauntmenu
	
	if not (TAKIS_NET.tauntkillsenabled)
		CONS_Printf(p,"You cannot use this taunt as the server has tauntkills disabled.")
		S_StartSound(nil,sfx_adderr,p)
		return false
	end
	
	takis.taunttime = 3*TR
	S_StartSound(me,sfx_spndsh)
end

local function init_bird(p)
	local me = p.mo
	local takis = p.takistable
	local menu = takis.tauntmenu
	
	takis.taunttime = 2
	takis.stasistic = 2
	takis.tauntacceptspartners = false
	me.state = S_PLAY_TAKIS_BIRD
	P_PlayJingleMusic(p,"brdwrd",0,true,JT_OTHER)
end

local function init_yeah(p)
	local me = p.mo
	local takis = p.takistable
	local menu = takis.tauntmenu
	
	takis.taunttime = 99
	takis.stasistic = 2
	takis.tauntacceptspartners = false
	TakisSpawnConfetti(me)
	S_StartSound(me,sfx_tayeah)
end



--taunt thinks

local function think_ouch(p)
	local me = p.mo
	local takis = p.takistable
	
	me.state = S_PLAY_PAIN
end

local function think_smug(p)
	local me = p.mo
	local takis = p.takistable

	me.state = S_PLAY_TAKIS_SMUGASSGRIN
	if not takis.tauntspecial
		me.frame = A
	else
		me.frame = B
	end
	if me.tics == -1
		me.tics = 12
	end

end

local congalist = {
	[0] = {FU*12/10,	FixedDiv(FU,FU*12/10)	},
	[1] = {FU*3/2,		FixedDiv(FU,FU*3/2)		},
	[2] = {FU*8/10,		FixedDiv(FU,FU*7/10)	},
	[3] = {FU*3/2,		FixedDiv(FU,FU*3/2)		},
	[4] = {FU*3/2,		FixedDiv(FU,FU*3/2)		},
	[5] = {FU*3/2,		FixedDiv(FU,FU*3/2)		},
	[6] = {FU*3/2,		FixedDiv(FU,FU*3/2)		},
	[7] = {FU*3/2,		FixedDiv(FU,FU*3/2)		},
}

local function think_conga(p)
	local me = p.mo
	local takis = p.takistable
	
	takis.nocontrol = 2
	takis.taunttime = 4
	takis.tauntjoinable = true
	
	p.drawangle = me.angle
	P_InstaThrust(me,p.drawangle,2*me.scale)
	P_MovePlayer(p)
	if me.state ~= S_PLAY_TAKIS_CONGA
		me.state = S_PLAY_TAKIS_CONGA
	end
	
	local tic = (leveltime/3)%8
	me.spritexscale = congalist[tic][1]
	me.spriteyscale = congalist[tic][2]
	
	--cancel conga
	if (takis.c1)
		TakisResetTauntStuff(p)
		P_RestoreMusic(p)
		me.state = S_PLAY_STND
		P_MovePlayer(p)
	end
end

local function think_bat(p)
	local me = p.mo
	local takis = p.takistable
	
	if not takis.onGround
		TakisResetTauntStuff(p)
		return
	end
	
	takis.stasistic = 2
	if (takis.taunttime ~= 3*TR)
		if takis.taunttime > TR
			--
		elseif takis.taunttime == TR
			S_StartSound(me,sfx_mswing)
		elseif takis.taunttime == 32
			local didit = false
			
			local dispx = FixedMul(42*me.scale+(20*me.scale),cos(p.drawangle))
			local dispy = FixedMul(42*me.scale+(20*me.scale),sin(p.drawangle))
			local thok = P_SpawnMobjFromMobj(
				me,
				dispx+me.momx,
				dispy+me.momy,
				0,
				MT_THOK
			)
			thok.radius = 40*FU
			thok.height = 60*FU
			thok.fuse = 1
			thok.flags2 = $|MF2_DONTDRAW
			thok.parent = me
			TakisBreakAndBust(p,thok)
			
			local fakerange = 250*FU
			local range = 80*FU
			searchBlockmap("objects", function(ref, found)
				if R_PointToDist2(found.x, found.y, ref.x, ref.y) <= range
				and L_ZCollide(found,ref)
				and (found.health)
				and (found ~= me)
					if CanFlingThing(found)
						SpawnBam(ref)
						SpawnEnemyGibs(thok,found)
						S_StartSound(found,sfx_smack)
						S_StartSound(me,sfx_sdmkil)
						SpawnRagThing(found,me,me)
						local ghs = P_SpawnGhostMobj(found)
						ghs.fuse = 10*TR
						ghs.flags2 = $|MF2_DONTDRAW
						S_StartSound(ghs,sfx_homrun)
						didit = true
					elseif SPIKE_LIST[found.type]
						P_KillMobj(found,me,me)
					elseif (found.player and found.player.valid)
						if CanPlayerHurtPlayer(p,found.player)
							P_KillMobj(found,me,me)
							didit = true
						end
						TakisAwardAchievement(p,ACHIEVEMENT_HOMERUN)
						SpawnBam(ref)
						SpawnEnemyGibs(found,found)
						S_StartSound(found,sfx_smack)
						S_StartSound(me,sfx_sdmkil)
						local ang = p.drawangle
						
						P_InstaThrust(found,ang,175*FU)
						L_ZLaunch(found,60*FU)
						P_MovePlayer(found.player)
						found.state = S_PLAY_PAIN
						
						local ghs = P_SpawnGhostMobj(me)
						ghs.fuse = 10*TR
						ghs.flags2 = $|MF2_DONTDRAW
						S_StartSound(ghs,sfx_homrun)
						S_StartSound(nil,sfx_homrun,found.player)
						
						if found.health
							found.state = S_PLAY_PAIN
						end
					else
						return false
					end
				end
			end, 
			thok,
			thok.x-fakerange, thok.x+fakerange,
			thok.y-fakerange, thok.y+fakerange)		
			if didit
				TakisResetTauntStuff(p)
			end
			return didit
		end
	end
end

local function think_bird(p)
	local me = p.mo
	local takis = p.takistable
	
	takis.nocontrol = 2
	takis.taunttime = $+2
	
	if me.state == S_PLAY_TAKIS_BIRD
		--me.state = S_PLAY_TAKIS_BIRD
		--me.frame = ((takis.taunttime-2) % 6)
		me.frame = ((takis.taunttime-2)/4 % 6)
	end
	
	--cancel conga
	if (takis.c1)
		TakisResetTauntStuff(p)
		P_RestoreMusic(p)
		me.state = S_PLAY_STND
		P_MovePlayer(p)
	end
end

local function think_yeah(p)
	local me = p.mo
	local takis = p.takistable
	
	takis.nocontrol = 2
	
	if takis.taunttime > 1
		if me.sprite2 ~= SPR2_THUP
			me.frame = A
			me.sprite2 = SPR2_THUP
		end
		
		takis.HUD.statusface.happyfacetic = 2
		
		if P_RandomChance(FRACUNIT-((takis.taunttime*655)+36))
			me.frame = B
		else
			me.frame = A
		end
	else
		me.state = S_PLAY_STND
		P_MovePlayer(p)
		takis.taunttime = 0
	end
		
end

rawset(_G, "TAKIS_TAUNT_INIT", {
	[1] = init_ouch,
	[2] = init_smug,
	[3] = init_conga,
	[4] = init_bat,
	[5] = init_bird,
	[6] = init_yeah,
})

rawset(_G, "TAKIS_TAUNT_THINK", {
	[1] = think_ouch,
	[2] = think_smug,
	[3] = think_conga,
	[4] = think_bat,
	[5] = think_bird,
	[6] = think_yeah,
})

filesdone = $+1
