--io file

--we load other people's config sometimes, maybe add another file
--with the player name? dont load if they mismatch?
--obv we cant put it in the config file, we need to be...
--conservative with file size

--thank you SMS reborn for being reusable!
--Y7GDSUYFHIDJPK AAAAAAAAAAAHHHHHHHHH!!!!!!!!

--if you use this manually and mess something up, its not my fault!
COM_AddCommand("takis_load", function(p,sig, a1,a2,a3,a4,t1,t2,a5,a6,a7,a8,a9,a10,a11,a12,timeshit)
	
	if sig ~= TAKIS_ACHIEVEMENTINFO.luasig
		CONS_Printf(p,"\x85"+"Do not use this command manually!")
		return
	end
	
	if not p.takistable then return end

	a1 = tonumber($) --Turn all of you to numbers!
	a2 = tonumber($)
	a3 = tonumber($)
	a4 = tonumber($)
	--quick taunts
	t1 = tonumber($)
	t2 = tonumber($)

	a5 = tonumber($)
	a6 = tonumber($)
	a7 = tonumber($)
	a8 = tonumber($)
	a9 = tonumber($)
	a10 = tonumber($)
	a11 = tonumber($)
	a12 = tonumber($)
	timeshit = tonumber($)

	local takis = p.takistable
	local errored = false

	if a1 == 1
		takis.io.nostrafe = 1
	elseif a1 == 0
		takis.io.nostrafe = 0
	else
		CONS_Printf(p,"\x85"+"Error loading No-Strafe! Defaulting to 0...")
		errored = true
	end

	if a2 == 1
		takis.io.nohappyhour = 1
	elseif a2 == 0
		takis.io.nohappyhour = 0
	else
		CONS_Printf(p,"\x85"+"Error loading No Happy Hour! Defaulting to 0...")
		errored = true
	end
	
	if a3 == 1
		takis.io.minhud = 1
	elseif a3 == 0
		takis.io.minhud = 0
	else
		CONS_Printf(p,"\x85"+"Error loading MinHud! Defaulting to 0...")
		errored = true
	end
	
	if a4 == 1
		takis.io.morehappyhour = 1
	elseif a4 == 0
		takis.io.morehappyhour = 0
	else
		CONS_Printf(p,"\x85"+"Error loading More Happy Hour! Defaulting to 0...")
		errored = true
	end

	--1-7 pls
	if t1 ~= nil
	and (t1 < 8)
		takis.tauntquick1 = t1
	else
		CONS_Printf(p,"\x85"+"Error loading Quick Taunt slot 1! Defaulting to 0...")
		errored = true
	end

	--1-7 pls
	if t2 ~= nil
	and (t2 < 8)
		takis.tauntquick2 = t2
	else
		CONS_Printf(p,"\x85"+"Error loading Quick Taunt slot 2! Defaulting to 0...")
		errored = true
	end

	if a5 == 1
		takis.io.tmcursorstyle = 1
	elseif a5 == 2
		takis.io.tmcursorstyle = 2
	else
		CONS_Printf(p,"\x85"+"Error loading Cursor Style! Defaulting to 1...")
		errored = true
	end

	if a5 == 1
		takis.io.quakes = 1
	elseif a5 == 0
		takis.io.quakes = 0
	else
		CONS_Printf(p,"\x85"+"Error loading Quakes! Defaulting to 1...")
		errored = true
	end

	if a7 == 1
		takis.io.flashes = 1
	elseif a7 == 0
		takis.io.flashes = 0
	else
		CONS_Printf(p,"\x85"+"Error loading Flashes! Defaulting to 1...")
		errored = true
	end

	if a10 == 1
		takis.io.clutchstyle = 1
	elseif a10 == 0
		takis.io.clutchstyle = 0
	else
		CONS_Printf(p,"\x85"+"Error loading Clutch Style! Defaulting to 1..")
		errored = true
	end

	if a11 == 1
		takis.io.sharecombos = 1
	elseif a11 == 0
		takis.io.sharecombos = 0
	else
		CONS_Printf(p,"\x85"+"Error loading Share Combos! Defaulting to 1...")
		errored = true
	end

	if a12 == 1
		takis.io.dontshowach = 1
	elseif a12 == 0
		takis.io.dontshowach = 0
	else
		CONS_Printf(p,"\x85"+"Error loading Don't show Achs.! Defaulting to 1...")
		errored = true
	end
	
	if a8 == 1
		takis.io.laggymodel = 1
	elseif a8 == 0
		takis.io.laggymodel = 0
	else
		CONS_Printf(p,"\x85"+"Error loading Laggy Model! Defaulting to 0...")
		errored = true
	end
	
	if a9 == 1
		takis.io.autosave = 1
	elseif a9 == 0
		takis.io.autosave = 0
	else
		CONS_Printf(p,"\x85"+"Error loading Autosave! Defaulting to 1...")
		errored = true
	end
	
	if (timeshit ~= nil)
	and timeshit > 0
		takis.totalshit = abs(timeshit)
	end

	CONS_Printf(p, "\x82Loaded "..skins[TAKIS_SKIN].realname.."' Settings!")
	p.takistable.io.savestate = (errored and 4 or 2)
	p.takistable.io.savestatetime = 2*TR
	p.takistable.io.loaded = true
end)

rawset(_G, "TakisConstructSaveCode", function(p, default)
	local a1 = 0	--nostrafe
	local a2 = 0	--nohappyhour
	local a3 = 0	--minhud
	local a4 = 0	--morehappyhour
	local t1 = 0	--quicktaunt1
	local t2 = 0	--quicktaunt2
	local a5 = 1	--cursorstyle
	local a6 = 1	--quakes
	local a7 = 1	--flashes
	local a8 = 0	--laggymodel
	local a9 = 1	--autosave
	local a10 = 1	--clutchstyle
	local a11 = 1	--sharecombos
	local a12 = 0	--dontshowach
	local timeshit = 0	--idk what this one does lmao
	
	if not default
		local t = p.takistable.io
		local tay = p.takistable
		
		a1 = t.nostrafe
		a2 = t.nohappyhour
		a3 = t.minhud
		a4 = t.morehappyhour
		t1 = tay.tauntquick1
		t2 = tay.tauntquick2
		a5 = t.tmcursorstyle
		a6 = t.quakes
		a7 = t.flashes
		a8 = t.laggymodel
		a9 = t.autosave
		a10 = t.clutchstyle
		a11 = t.sharecombos
		a12 = t.dontshowach
		timeshit = tay.totalshit
	end
	
	return	" "..a1.." "..a2.." "..a3.." "..a4.." "..t1.." "
			..t2.." "..a5.." "..a6.." "..a7.." "..a8.." "..a9.." "
			..a10.." "..a11.." "..a12.." "..timeshit
end)

rawset(_G, "TakisSaveStuff", function(p, silent, forcebackup)
	if not (p and p.valid) then return end
	if (p ~= consoleplayer) then return end
	if forcebackup == nil then forcebackup = false end
	
	local t = p.takistable.io
	local tay = p.takistable
	--well i dont see why not
	TakisSaveAchievements(p)
	p.takistable.io.savestate = 1
	
	--write
	--TODO: version numbers to prevent messed up saves
	if io
		DEBUG_print(p,IO_CONFIG|IO_SAVE)
		
		t.hasfile = true
		
		local file = io.openlocal("client/takisthefox/config.dat", "r")
		local backup = io.openlocal("client/takisthefox/backupconfig.dat","r")
		if file
			if file
			and not p.takistable.io.loaded
				CONS_Printf(p, "\x85".."Couldn't save "..skins[TAKIS_SKIN].realname.."' settings! (Save not loaded yet!)")
				file:close()
				p.takistable.io.savestate = 3
				p.takistable.io.savestatetime = 2*TR
				return
			end
			
			local lastcode = file:read("*a")
			local savestring = TakisConstructSaveCode(p)
			
			if backup
				if (lastcode ~= savestring) or forcebackup
					backup = io.openlocal("client/takisthefox/backupconfig.dat", "w+")
					backup:write(lastcode)
				end
			else
				backup = io.openlocal("client/takisthefox/backupconfig.dat", "w+")
				backup:write(savestring)
			end
			
			if not forcebackup
				file = io.openlocal("client/takisthefox/config.dat", "w+")
				file:write(savestring)
			end
			
			if not silent
				CONS_Printf(p, "\x82Saved "..skins[TAKIS_SKIN].realname.."' settings!")
			end
				
			file:close()
			if backup
				backup:close()
			end
			p.takistable.io.savestate = 2
			p.takistable.io.savestatetime = 2*TR
			return
		end
	end
	p.takistable.io.savestate = 3
	p.takistable.io.savestatetime = 2*TR
end)

rawset(_G, "TakisLoadStuff", function(p)
	
	if p.takistable.io.loaded
		return
	end
	
	if io --load savefile
		DEBUG_print(p,IO_CONFIG|IO_SAVE)
		
		local file = io.openlocal("client/takisthefox/config.dat")
		
		--load file
		if file 
			
			p.takistable.io.hasfile = true
			
			local code = file:read("*a")
			local defaultsave = TakisConstructSaveCode(p,true)
			if code == defaultsave
				file = io.openlocal("client/takisthefox/backupconfig.dat")
				code = file:read("*a")
			end
			
			if code ~= nil and not (string.find(code, ";"))
				if p.takistable.io.loadtries < 3
					p.takistable.io.savestate = 1
					COM_BufInsertText(p, "takis_load "..TAKIS_ACHIEVEMENTINFO.luasig..code)
				else
					p.takistable.io.savestate = 3
					p.takistable.io.savestatetime = 2*TR
					p.takistable.io.loaded = true
				end
			end
			
			file:close()
			
		else
			
			p.takistable.HUD.cfgnotifstuff = 6*TR+18
			--whatever...
			p.takistable.io.loaded = true
			
		end
		
	end
end)

filesdone = $+1
