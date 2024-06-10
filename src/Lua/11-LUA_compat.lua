--external compatability

local compat = {
	oldcname = false,
	skipmonitor = false,
	mrcemom = false,
	inatext = false,
	peptext = false,
	speckismash = false,
	ptsrhook = false,
}

local function printf(...)
	
	local texts = {...}
	for k,v in ipairs(texts)
		print("\x83TAKIS:\x80 "..v)
	end
	
	if not TAKIS_ISDEBUG then return end
	prtable("compat",compat)
end

addHook("ThinkFrame",do
	if (OLDC and OLDC.SetSkinFullName) and not compat.oldcname
		OLDC.SetSkinFullName(TAKIS_SKIN,"Takis")
		compat.oldcname = true
		printf("Added OLDC Fullname.")
	end
	if (AddSkipMonitor) and not compat.skipmonitor
		AddSkipMonitor(MT_SHOTGUN_BOX,35,"Time to kick ass!","")
		compat.skipmonitor = true
		printf("Added Shotgun box for Skip.")
	end
	if skins["inazuma"]
	and not compat.inatext
		TAKIS_TEXTBOXES.ultzuma = {
			[1] = { 
				name = takisname,
				portrait = takisport,
				color = "playercolor",
				text = "Holy MOLY! Is that |esc\x88Ultimate Inazuma|esc\x80!?",
				sound = takisvox,
				soundchance = takischance,
				delay = 2*TICRATE,
				next = 2
			},
			[2] = { 
				name = "Ultimate Inazuma",
				namemap = V_SKYMAP,
				portrait = {"inazuma", SPR2_CLNG, A, 8, true},
				portyoffset = -30*FU,
				color = SKINCOLOR_ULTIMATE1,
				text = "Yeah, it's me.",
				sound = {sfx_menu1},
				soundchance = FU,
				delay = 2*TICRATE,
				next = 0
			},
		}
		compat.inatext = true
		printf("Added Silverhorn textboxes.")
	end
	if skins["npeppino"]
	and not compat.peptext
		TAKIS_TEXTBOXES.ntopp = {
			[1] = { 
				name = takisname,
				portrait = takisport,
				color = "playercolor",
				text = "Holy crap, Peppino Spaghetti!?",
				sound = takisvox,
				soundchance = takischance,
				delay = 2*TICRATE,
				next = 2
			},
			[2] = { 
				name = "Peppino",
				portrait = {"npeppino", SPR2_STND, A, 8, true},
				color = SKINCOLOR_WHITE,
				text = "Peppino",
				sound = {sfx_menu1},
				soundchance = FU/2,
				delay = 2*TICRATE,
				next = 0
			},
		}
		compat.peptext = true
		printf("Added NTOPP textboxes.")
	end
	if (mrceCharacterPhysics)
	and not compat.mrcemom
		--forces thrustfactor,,, stinky....
		mrceCharacterPhysics(TAKIS_SKIN,false,false,1)
		compat.mrcemom = true
		printf("Disabled MRCE momentum.")
	end
	if (specki and specki.gimmicks.smash)
	and not compat.speckismash
		local ctf = specki.gimmicks.smash
		ctf.stuff["takisthefox"] = {
			jumpheight = 12*FU,
			weight = FU,
		}
		compat.speckismash = true
		printf("Added Specki stuff.")
	end
	if (PTSR
	and PTSR_AddHook)
	and not compat.ptsrhook
		PTSR_AddHook("pfdamage",function(touch,pizza)
			if not (touch and touch.valid) then return end
			if touch.skin ~= TAKIS_SKIN then return end
			
			local p = touch.player
			local takis = p.takistable
			if takis.pitanim
				return true
			end
			
		end)
		
		PTSR_AddHook("pfthink",function(pizza)
			if not (pizza and pizza.valid) then return end
			
			pizza.takis_flingme = false
		end)
		
		PTSR_AddHook("onlap",function(lapper)
			if not (lapper and lapper.valid) then return end
			if lapper.skin ~= TAKIS_SKIN then return end
			
			local p = lapper.player
			local takis = p.takistable
			TakisGiveCombo(p,takis,false,true)
			local hud = takis.HUD
			hud.lapanim.lapnum = p.ptsr.laps+1
			hud.lapanim.tics = 80
			hud.lapanim.time = p.ptsr.laptime
		end)
		
		compat.ptsrhook = true
		printf("Added PTSR stuff.")
	end
end)

filesdone = $+1