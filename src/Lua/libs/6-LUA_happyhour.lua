--happy hour stuff
local function L_ZCollide(mo1,mo2)
	if mo1.z > mo2.height+mo2.z then return false end
	if mo2.z > mo1.height+mo1.z then return false end
	return true
end

rawset(_G,"HAPPY_HOUR",{
	happyhour = false,
	timelimit = 0,
	timeleft = 0,
	time = 0,
	othergt = false,
	trigger = 0,
	overtime = false,
})
local hh = HAPPY_HOUR

rawset(_G,"HH_Trigger",function(actor,timelimit)
	if actor == nil
		print("HH_Trigger() needs a trigger mobj to run")
		return
	end
	
	if hh.happyhour == true
		return
	end
	
	if timelimit == nil
		timelimit = 3*60*TR
	end
	
	hh.timelimit = timelimit
	hh.happyhour = true
	for p in players.iterate
		ChangeTakisMusic("HAPYHR",p)
	end
	local tag = actor.lastlook
	if (actor.type == MT_HHTRIGGER)
		tag = AngleFixed(actor.angle)/FU
		P_LinedefExecute(tag,actor,nil)
	end
	hh.trigger = actor
end)

rawset(_G,"HH_Reset",function()
	hh.happyhour = false
	hh.timelimit = 0
	hh.timeleft = 0
	hh.time = 0
	hh.trigger = 0
end)

addHook("ThinkFrame",function()
	if (gamestate == GS_LEVEL)
		if (leveltime < 3)
			return
		end
		
		--cool
		if (gametype == GT_PTSPICER)
			hh.happyhour = PTSR.pizzatime
			hh.timelimit = CV_PTSR.timelimit.value*TICRATE*60 or 0
			hh.timeleft = PTSR.timeleft
			hh.time = PTSR.pizzatime_tics
			hh.othergt = true
			hh.overtime = hh.timeleft == 0 and hh.happyhour
			return
		else
			if (hh.overtime)
				hh.overtime = false
			end
			if (hh.othergt)
				hh.othergt = false 
			end
		end
		
		if hh.happyhour
			
			if (hh.timelimit ~= nil or hh.timelimit ~= 0)
				if hh.timelimit < 0
					hh.timelimit = 3*60*TR
				end
				
				hh.timeleft = hh.timelimit-hh.time
				
				if hh.timeleft == 0
					if not hh.othergt
						for p in players.iterate
							if not (p and p.valid) then continue end
							if not (p.mo and p.mo.valid) then continue end
							--already dead
							if (not p.mo.health) or (p.playerstate ~= PST_LIVE) then continue end
							if (p.exiting or p.pflags & PF_FINISHED) then continue end
							P_KillMobj(p.mo)
						end
					end
					return
				end
			end
			
			hh.time = $+1
		else
			hh.timelimit = 0
			hh.timeleft = 0
			hh.time = 0
		end
	else
		if hh.happyhour
			hh.timelimit = 0
			hh.timeleft = 0
			hh.time = 0
			hh.happyhour = false
		end
	end
end)

freeslot("SPR_HHT_")
freeslot("S_HHTRIGGER_IDLE")
freeslot("S_HHTRIGGER_PRESSED")
freeslot("S_HHTRIGGER_ACTIVE")
freeslot("MT_HHTRIGGER")
sfxinfo[freeslot("sfx_hhtsnd")] = {
	flags = SF_X2AWAYSOUND,
	caption = "/"
}

states[S_HHTRIGGER_IDLE] = {
	sprite = SPR_HHT_,
	frame = A,
	tics = -1
}
states[S_HHTRIGGER_PRESSED] = {
	sprite = SPR_HHT_,
	frame = A,
	tics = 5,
	nextstate = S_HHTRIGGER_ACTIVE
}
states[S_HHTRIGGER_ACTIVE] = {
	sprite = SPR_HHT_,
	frame = A,
	tics = -1,
}

mobjinfo[MT_HHTRIGGER] = {
	doomednum = 3000,
	spawnstate = S_HHTRIGGER_IDLE,
	spawnhealth = 1,
	deathstate = S_HHTRIGGER_PRESSED,
	deathsound = sfx_mclang,
	height = 60*FU,
	radius = 35*FU, --FixedDiv(35*FU,2*FU),
	flags = MF_SOLID,
}

addHook("MobjSpawn",function(mo)
--	mo.height,mo.radius = $1*2,$2*2
	mo.shadowscale = mo.scale*9/10
	mo.spritexoffset = 19*FU
	mo.spriteyoffset = 26*FU
end,MT_HHTRIGGER)

addHook("MobjThinker",function(trig)
	if not trig
	or not trig.valid
		return
	end
	
	trig.spritexscaleadd = $ or 0
	trig.spriteyscaleadd = $ or 0
	
	if trig.state == S_HHTRIGGER_ACTIVE
		trig.frame = ((5*(HAPPY_HOUR.time)/6)%14)
		if not S_SoundPlaying(trig,sfx_hhtsnd)
			S_StartSound(trig,sfx_hhtsnd)
		end
	end
	
	trig.spritexscale = 2*FU+trig.spritexscaleadd
	trig.spriteyscale = 2*FU+trig.spriteyscaleadd
	if trig.spritexscaleadd ~= 0
		trig.spritexscaleadd = 4*$/5
	end
	if trig.spriteyscaleadd ~= 0
		trig.spriteyscaleadd = 4*$/5
	end
	
end,MT_HHTRIGGER)

addHook("MobjCollide",function(trig,mo)
	if not mo
	or not mo.valid
		return
	end
	
	if HAPPY_HOUR.happyhour
		if L_ZCollide(trig,mo)
			return true
		end
		return
	end
	
	if not trig.health
		if L_ZCollide(trig,mo)
			return true
		end
		return
	end
	
	
	if P_MobjFlip(trig) == 1
		local myz = trig.z+trig.height
		if not (mo.z <= myz+trig.scale and mo.z >= myz-trig.scale)
			if L_ZCollide(trig,mo)
				return true
			end
		return
		end
		if (mo.momz)
			return true
		end
		
		HH_Trigger(trig,3*60*TR)
		S_StartSound(trig,trig.info.deathsound)
		trig.state = trig.info.deathstate
		trig.spritexscaleadd = 2*FU
		trig.spriteyscaleadd = -FU*3/2
		P_AddPlayerScore(mo.player,5000)
		local takis = mo.player.takistable
		takis.bonuses["happyhour"].tics = 3*TR+18
		takis.bonuses["happyhour"].score = 5000
		takis.HUD.flyingscore.scorenum = $+5000
		return true
		
	end
	
end,MT_HHTRIGGER)

filesdone = $+1
