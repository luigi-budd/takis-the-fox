--THANKS MARILYN FOR LETTIN ME USE THIS!!!!!!!!!

local desonic
local dehand0
local dehand1
local dehand2
local dehand3
local deblink1
local deblink2

local animtimer = 0

local timetonext

local finalestage
local finalecount
local finaletextcount

local mouthtic = 0

local textstep = 1
local textdowait = true
local textwait = 0
local textdex = 1
local textlimit = 6
local textlist = {
	--phase1
	[1] = "Thanks for playing the Takis",
	[2] = "demo. This is the last release",
	[3] = "before the final addon comes",
	[4] = "out, but here are several",
	[5] = "things you you can do to",
	[6] = "tide you over:",
	--phase2
	[7] = ' ',
	[8] = "1) Visit the community server at",
	[9] = TAKIS_INVITELINK,
	[10] = "for news and updates.",
	--phase3
	[11] = ' ',
	[12] = "2) Mess around with other",
	[13] = "people in Takis netgames.",
	--phase4
	[14] = ' ',
	[15] = "3) Stop by the SRB2 Discord at",
	[16] = "discord.gg/b3BGb8A",
	--phase5
	[17] = ' ',
	[18] = "Well, now you're being sent to GFZ2.", 
}
local punct = {
    ["."] = true,
    [","] = true,
    [";"] = true,
    [":"] = true,
    ["?"] = true,
    ["!"] = true,
}

local taksfx = {sfx_s_tak1,sfx_s_tak2,sfx_s_tak3}
	
local demomap = 1001

local function F_DemoEndTicker()
	if(animtimer) then
		animtimer = $ - 1
	end

	if (timetonext > 0) then
		local score = textlist[textdex]
		
		if textwait then textwait = $-1 end
		
		if not (textdex == textlimit
		and textstep == string.len(score)+1)
		and (textwait == 0)
		
			textstep = $+1
			if P_RandomChance(FU/4)
				S_StartSound(nil,taksfx[P_RandomRange(1,3)])
				mouthtic = 6+P_RandomRange(-1,1)
			end
			
			if textstep >= string.len(score)+1
			and (textdex ~= textlimit)
				textstep = 1
				textdex = $+1
			end
			
			if punct[string.sub(score,textstep,textstep)] == true
			and (textdowait == true)
				textwait = 7
			end
			
		end
		
		timetonext = $ - 1
	else // Switch finalestages
		finalestage = $ + 1
		if finalestage == 2 then
			finalecount = 0
			textstep = 1
			textdex = 7
			textlimit = 10
			timetonext = 3*TICRATE
			textdowait = false
		elseif finalestage == 3 then
			finalecount = 0
			textstep = 1
			textdex = 11
			textlimit = 13
			timetonext = 3*TICRATE
			textdowait = true
		elseif finalestage == 4 then
			finalecount = 0
			textstep = 1
			textdex = 14
			textlimit = 16
			timetonext = (3*TICRATE)
			textdowait = false
		elseif finalestage == 5 then
			finalecount = 0
			textstep = 1
			textdex = 17
			textlimit = 18
			timetonext = 3*TICRATE
			textdowait = true
		elseif finalestage == 6 then
			finalecount = 0
			timetonext = TICRATE
		--like marilyn told me, "exitgame" causes a tmthing set
		--crash that i have no idea how to fix, so....
		elseif finalestage == 7 then
			--back to gfz2...
			G_ExitLevel(2,2)
		end
	end
end

local function F_DemoEndDrawer(v)
	if gamemap ~= demomap then return end
	// advance animation
	finalecount = $ + 1
	finaletextcount = $ + 1

	local color = SKINCOLOR_FOREST
	v.drawFill(0,0,v.width(),v.height(),
		--even if there is tearing, you wont see the black void
		skincolors[color].ramp[15]|V_SNAPTOLEFT|V_SNAPTOTOP
	)
	
	--need the scale before the loops
	local s = FU*3/2
	local bgp = v.cachePatch("TA_MENUBG")
	--this will overflow in 15 minutes + some change
	local timer = FixedDiv(leveltime*FU,2*FU) or 1
	local bgoffx = FixedDiv(timer,2*FU)%(bgp.width*s)
	local bgoffy = FixedDiv(timer,2*FU)%(bgp.height*s)
	for i = 0,(v.width()/bgp.width)--+1
		for j = 0,(v.height()/bgp.height)--+1
			--Complicated
			local x = 300
			local y = bgp.height*(j-1)
			local f = V_SNAPTORIGHT|V_SNAPTOTOP|V_70TRANS
			local c = v.getColormap(nil,color)
			
			v.drawScaled(((x-bgp.width*(i-1)))*s-bgoffx,
				(y)*s+bgoffy,
				s,
				bgp, --v.cachePatch("?"),
				f,
				c
			)
			v.drawScaled(((x-bgp.width*i))*s-bgoffx,
				(y)*s+bgoffy,
				s,
				bgp, --v.cachePatch("?"),
				f,
				c
			)
		end
	end
	v.drawFill(260, 0, 32768, 32768, 45|V_SNAPTOLEFT|V_SNAPTOTOP) // White

	desonic = v.cachePatch("SONCDEND")
	dehand0 = v.cachePatch("DEHAND0")
	dehand1 = v.cachePatch("DEHAND1")
	dehand2 = v.cachePatch("DEHAND2")
	dehand3 = v.cachePatch("DEHAND3")
	deblink1 = v.cachePatch("DEBLINK1")
	deblink2 = v.cachePatch("DEBLINK2")

	local takisx = 185
	local takisy = 36
	local takiscolor = v.getColormap(nil,SKINCOLOR_FOREST)

	// Sonic puts his hand out...
	if((finalestage == 1 and timetonext <= TICRATE/2) or (finalestage >= 2 and finalestage <= 4)
		or (finalestage == 5 and timetonext > 3*TICRATE))
		v.draw(takisx, takisy, dehand3, V_SNAPTORIGHT,takiscolor)
	elseif(finalestage == 1 and timetonext >= TICRATE/2 + 1*NEWTICRATERATIO
		and timetonext <= TICRATE/2 + 5*NEWTICRATERATIO)
		v.draw(takisx, takisy, dehand2, V_SNAPTORIGHT,takiscolor)
	elseif(finalestage == 1 and timetonext >= TICRATE/2 + 6*NEWTICRATERATIO
		and timetonext <= TICRATE/2 + 8*NEWTICRATERATIO)
		v.draw(takisx, takisy, dehand1, V_SNAPTORIGHT,takiscolor)
	else
		v.draw(takisx, takisy, dehand0, V_SNAPTORIGHT,takiscolor)
	end

	// And brings it back in.
	if(finalestage == 5 and timetonext <= 3*TICRATE-1*NEWTICRATERATIO
		and timetonext >= 3*TICRATE-3*NEWTICRATERATIO) then
		v.draw(takisx, takisy, dehand1, V_SNAPTORIGHT,takiscolor)
	end
	
	v.draw(takisx, takisy, desonic, V_SNAPTORIGHT,takiscolor) // Sonic

	// Have Sonic blink every so often. (animtimer is used for this)
	if (v.RandomChance(FU/50) and animtimer == 0)
		animtimer = 3*2
	end
	
	if animtimer/2 == 3 then
		v.draw(takisx, takisy, deblink1, V_SNAPTORIGHT,takiscolor)
	elseif animtimer/2 == 1 then
		v.draw(takisx, takisy, deblink1, V_SNAPTORIGHT,takiscolor)
	elseif animtimer/2 == 2 then
		v.draw(takisx, takisy, deblink2, V_SNAPTORIGHT,takiscolor)
	end
	v.draw(takisx, takisy, v.cachePatch("DEHAIR"), V_SNAPTORIGHT,takiscolor)
	
	if mouthtic
		if v.patchExists("DEMOUTH"..(mouthtic/2))
			v.draw(takisx, takisy, v.cachePatch("DEMOUTH"..(mouthtic/2)), V_SNAPTORIGHT,takiscolor)		
		end
		mouthtic = $-1
	end
	
	// Draw the text over everything else
	local textflags = V_SNAPTOLEFT|V_ALLOWLOWERCASE
	local score = textlist[textdex]
	local prevw = 0
	for i = 1,textstep
		local n = string.sub(score,i,i)
		v.drawString(8+prevw,4+(8*(textdex-1)),n,textflags)
			
		prevw = $+v.stringWidth(n,textflags,"normal")
		
	end
	
	for i = 1,textlimit
		if textdex > i
			v.drawString(8,4+(8*(i-1)),textlist[i],textflags)
		end
	end
end

local set = false
local function F_StartDemoEnd()

	finalestage = 1
	finalecount = 0
	finaletextcount = 0
	timetonext = 6*TICRATE
	set = true
end

addHook("KeyDown", function(key)
	if gamemap == demomap
		local conskey = input.gameControlToKeyNum(GC_CONSOLE)
		local menukey = input.gameControlToKeyNum(GC_SYSTEMMENU)
		local capkey = input.gameControlToKeyNum(GC_SCREENSHOT)
		local gifkey = input.gameControlToKeyNum(GC_RECORDGIF)
		--HOLY SHIT, SPECKY???
		local speckey = false
		
		if conskey == key.num
		or menukey == key.num
		or capkey == key.num
		or gifkey == key.num
			speckey = true
		end
		
		if not speckey
			return true
		end
	end
end)

addHook("ThinkFrame", function()
	if gamemap ~= demomap then return end
	if not multiplayer
		if set == false then
			F_StartDemoEnd()
		else
			F_DemoEndTicker()
		end
	else
		G_ExitLevel(2,2)
	end
end)

hud.add(F_DemoEndDrawer)

filesdone = $+1