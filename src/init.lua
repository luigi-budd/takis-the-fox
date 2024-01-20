--LOOKING AT MY CODE,,, CURSED!!!
--𓀀 𓀁 𓀂 𓀃 𓀄 𓀅 𓀆 𓀇 𓀈 𓀉 𓀊 𓀋 𓀌 𓀍 𓀎 𓀏 𓀐 𓀑 𓀒 𓀓 𓀔 𓀕 𓀖 𓀗 𓀘 𓀙 𓀚
--/j

-- "Terrible Character..."

if (VERSION == 202) and (SUBVERSION < 12)
	local special = P_RandomChance(FRACUNIT/13)

	local function deprecated(v)
	
		v.fadeScreen(0xFF00, 20)
		v.drawString(130, 60, "Your copy of SRB2 outdated!",V_ORANGEMAP|V_ALLOWLOWERCASE, "thin")
		v.drawString(130, 60+8, "This mod requires 2.2.12+,",V_ORANGEMAP|V_ALLOWLOWERCASE, "thin")
		v.drawString(130, 60+8+8, "please update your game!",V_ORANGEMAP|V_ALLOWLOWERCASE, "thin")
		
		local patch = v.cachePatch("PIRATESOAP")
		local size = FU/5
		local x = 0
		
		if special
			patch = v.cachePatch("HOLYMOLY")
			size = 3*FU/5
			x = 30*FU
		end
		
		v.drawScaled(50*FU+x, 35*FU, size, patch)
	end
	hud.add(deprecated, "title")
	hud.add(deprecated, "game")
	
	error("\x85".."Your copy of 2.2 (".."2.2."..SUBVERSION..") is too outdated for this mod.\x80", 0)
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
}
--

rawset(_G, "filesdone", 0)
rawset(_G, "NUMFILES", (#guh)+(#filelistt1)+(#filelist-1))

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
			"Please send feedback and bug reports to \x83@gerald55555\x82 on Discord, or the Github!\nhttps://github.com/luigi-budd/takis-the-fox"
			
		)	
	else
		CONS_Printf(p,"\x82This is free for anyone to host!\n"..
			"Please send feedback and bug reports to \x83@gerald55555\x82 on Discord, or the Github!\nhttps://github.com/luigi-budd/takis-the-fox"
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
