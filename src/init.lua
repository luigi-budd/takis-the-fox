--reminder that this mod is "ASK ME" reusability, despite what 
--the discussion page says

-- "Terrible Character..."

if (VERSION == 202) and (SUBVERSION < 12)
	local special = P_RandomChance(FRACUNIT/13)
	local ticker = 0
	
	addHook("ThinkFrame",do
		ticker = $+1
		
		for p in players.iterate
			if skins[p.skin].name == "takisthefox"
				R_SetPlayerSkin(p,0)
			end
		end
	end)
	
	local function dep(v)
		local waveforce = FU*3
		local ay = FixedMul(waveforce,sin(FixedAngle(ticker*5*FU)))
		
		local box = v.cachePatch("BLACK_BOX_NUMBER_23423423")
		local x = 160*FU-(box.width*FU/2)
		local y = ay+80*FU--(box.height/2)
		
		
		local txt = {
			"Your version of \x82SRB2",
			"is \x85outdated!",
			"Please update to",
			"\x82".."2.2.12+\x80!"
		}
		
		v.fadeScreen(0xFF00,20)
		
		v.drawScaled(x,y,FU,box,V_50TRANS)
		
		local shitter = v.cachePatch("TA_POOPSHIT")
		v.drawScaled(x+(shitter.width*FU/2),
			y+(shitter.height*FU/2),
			FU/2,
			shitter,
			0
		)
		
		v.drawString(x+(box.width*FU/2)-2*FU,
			y+2*FU,
			"takis:",
			V_GREENMAP,
			"fixed"
		)
		
		for k,va in ipairs(txt)
			v.drawString(x+(box.width*FU/2)-2*FU,
				y+2*FU+(k*8*FU),
				va,
				V_ALLOWLOWERCASE,
				"thin-fixed"
			)
		end
		
	end
	
	local hudlist = {
		"title",
		"game",
		"intermission",
		"scores",
	}
	
	for _,type in pairs(hudlist)
		addHook("HUD",dep,type)
	end
	
	S_StartSound(nil,sfx_skid)
	return
end

--file tree
local guh = {
	"init",
	"net",
}
--libs
local filelistt1 = {
	"CustomHud",
	"functions",
	"achievements",
	"taunts",
	"menu",
	"happyhour",
	"NFreeroam",
	"Textboxes",
	"battlemod",
}
local filelist = {
	"io",
	"main",
	"cmds",
	"DNU-net",
	"devcmds",
	"hud",
	"misc",
	"MOTD",
	"finaldemo",
	"compat",
}
--

rawset(_G, "filesdone", 0)
rawset(_G, "NUMFILES", (#guh)+(#filelistt1)+(#filelist-1))
--from chrispy chars!!! by Lach!!!!
rawset(_G,"SafeFreeslot",function(...)
	for _, item in ipairs({...})
		if rawget(_G, item) == nil
			freeslot(item)
		end
	end
end)


rawset(_G, "takis_printdebuginfo",function(p)
	if not p
		print("\x82".."Extra Debug Stuff:\n"..
			/*
			"\x8D".."Build Date (MM/DD/YYYY) = \x80"..TAKIS_BUILDDATE.."\n"..
			"\x8D".."Build Time = \x80"..TAKIS_BUILDTIME.."\n"..
			*/
			"\x8D".."# of files done = \x80"..filesdone.."/"..NUMFILES.."\n"
			
		)	
	else
		CONS_Printf(p,"\x82".."Extra Debug Stuff:\n"..
			/*
			"\x8D".."Build Date (MM/DD/YYYY) = \x80"..TAKIS_BUILDDATE.."\n"..
			"\x8D".."Build Time = \x80"..TAKIS_BUILDTIME.."\n"..
			*/
			"\x8D".."# of files done = \x80"..filesdone.."/"..NUMFILES.."\n"
		)	
	end
end)

rawset(_G, "takis_printwarning",function(p)
	if not p
		print("\x82This is free for anyone to host!\n"..
			"Please send feedback and bug reports to \x83@luigibudd\x82 on Discord, or the Github!\nhttps://github.com/luigi-budd/takis-the-fox"
			
		)	
	else
		CONS_Printf(p,"\x82This is free for anyone to host!\n"..
			"Please send feedback and bug reports to \x83@luigibudd\x82 on Discord, or the Github!\nhttps://github.com/luigi-budd/takis-the-fox"
		)	
	end
	
end)



--the file stuff
local pre = "LUA_"
local suf = ".lua"

for k,v in ipairs(guh)
	if k == 1
		dofile("1-"..pre..v)
	else
		dofile("5-"..pre..v)
	end
	print("Done "..filesdone.." file(s)")
end

for k,v in ipairs(filelistt1)
	dofile("libs/"..k.."-"..pre..v..suf)
	print("Done "..filesdone.." file(s)")
end

for k,v in ipairs(filelist)
	if (string.sub(v,1,4) == "DNU-") then continue end
	dofile((k+1).."-"..pre..v..suf)
	print("Done "..filesdone.." file(s)")
end

takis_printdebuginfo()

if filesdone ~= NUMFILES
	print("\x85"..(NUMFILES-filesdone).." file(s) were not executed.\n")
	S_StartSound(nil,sfx_skid)
end

takis_printwarning()
