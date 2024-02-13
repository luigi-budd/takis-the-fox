local added = false

--TODO: move this to compat.lua

/*
		hurtmsg = {
			[HURTMSG_CLUTCH] = {text = "Clutch Boost",tics = 0},
			[HURTMSG_SLIDE] = {text = "Slide",tics = 0},
			[HURTMSG_HAMMERBOX] = {text = "Hammer",tics = 0},
			[HURTMSG_HAMMERQUAKE] = {text = "Earthquake",tics = 0},
			[HURTMSG_ARMA] = {text = "Armageddon Shield",tics = 0},
			[HURTMSG_BALL] = {text = "tumble",tics = 0},
			[HURTMSG_NADO] = {text = "Tornado Spin",tics = 0},
		},
*/

local function takis_priority(p)
	local B = CBW_Battle
	
	local takis = p.takistable
	if not takis then return end
	
	local hurtmsg = nil
	
	if (takis.transfo & TRANSFO_TORNADO)
		hurtmsg = "Tornado Spin"
	elseif (p.pflags & PF_SPINNING)
		if not (takis.transfo & TRANSFO_BALL)
			hurtmsg = "slide"
		else
			hurtmsg = "tumble"
		end
	elseif (takis.afterimaging)
		hurtmsg = "Clutch Boost"
	end
	
	if hurtmsg ~= nil
		print("AS")
		B.SetPriority(p,2,2,nil,2,2,hurtmsg)
	end
end

addHook("ThinkFrame",do
	if not added
	and (CBW_Battle ~= nil)
		
		local B = CBW_Battle
		
		B.SkinVars["takisthefox"] = {
			skinvars = SKINVARS_GUARD|SKINVARS_NOSPINSHIELD,
			weight = 120,
			shields = 1, 
			guard_frame = 2,
			func_priority_ext = takis_priority,
			sprites = {}
		}
		
		S_StartSound(nil,sfx_strpst)
		print("Battlemod moveset added")
		added = true
	end
end)

filesdone = $+1