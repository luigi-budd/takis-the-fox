rawset(_G, "TAKIS_TAUNT_DIST",75*FU)

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

local function think_conga(p)
	local me = p.mo
	local takis = p.takistable
	
	takis.nocontrol = 2
	takis.taunttime = 2
	takis.tauntjoinable = true
	
	p.drawangle = me.angle
	P_InstaThrust(me,p.drawangle,2*me.scale)
	P_MovePlayer(p)
	if me.state ~= S_PLAY_TAKIS_CONGA
		me.state = S_PLAY_TAKIS_CONGA
	else
		me.frame = (leveltime/3)%8
	end
	
	
	--cancel conga
	if (takis.c1)
		TakisResetTauntStuff(takis)
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
			local x = cos(p.drawangle)
			local y = sin(p.drawangle)
			local b = P_SpawnMobjFromMobj(me,28*x,28*y,0,MT_TAKIS_TAUNT_HITBOX)
			b.tracer = me
			b.boxtype = "bat"
			b.fuse = 2
			b.takis_flingme = false
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
		TakisResetTauntStuff(takis)
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
