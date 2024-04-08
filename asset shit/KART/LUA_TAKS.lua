--kart
local FU = FRACUNIT
local TR = TICRATE
local TAKIS_SKIN = "takisthefox"
local TAKIS_HIGHSPEED = 46*FU 
local TAKIS_EASY_HIGHSPEED = 36*FU 
local TAKIS_HARD_HIGHSPEED = 56*FU 

--this sucks
local skincolors = {}
local colorlist = {
	SKINCOLOR_WHITE,
	SKINCOLOR_SILVER,
	SKINCOLOR_GREY,
	SKINCOLOR_NICKEL,
	SKINCOLOR_BLACK,
	SKINCOLOR_SKUNK,
	SKINCOLOR_FAIRY,
	SKINCOLOR_POPCORN,
	SKINCOLOR_ARTICHOKE,
	SKINCOLOR_PIGEON,
	SKINCOLOR_SEPIA,
	SKINCOLOR_BEIGE,
	SKINCOLOR_WALNUT,
	SKINCOLOR_BROWN,
	SKINCOLOR_LEATHER,
	SKINCOLOR_SALMON,
	SKINCOLOR_PINK,
	SKINCOLOR_ROSE,
	SKINCOLOR_BRICK,
	SKINCOLOR_CINNAMON,
	SKINCOLOR_RUBY,
	SKINCOLOR_RASPBERRY,
	SKINCOLOR_CHERRY,
	SKINCOLOR_RED,
	SKINCOLOR_CRIMSON,
	SKINCOLOR_MAROON,
	SKINCOLOR_LEMONADE,
	SKINCOLOR_FLAME,
	SKINCOLOR_SCARLET,
	SKINCOLOR_KETCHUP,
	SKINCOLOR_DAWN,
	SKINCOLOR_SUNSET,
	SKINCOLOR_CREAMSICLE,
	SKINCOLOR_ORANGE,
	SKINCOLOR_PUMPKIN,
	SKINCOLOR_ROSEWOOD,
	SKINCOLOR_BURGUNDY,
	SKINCOLOR_TANGERINE,
	SKINCOLOR_PEACH,
	SKINCOLOR_CARAMEL,
	SKINCOLOR_CREAM,
	SKINCOLOR_GOLD,
	SKINCOLOR_ROYAL,
	SKINCOLOR_BRONZE,
	SKINCOLOR_COPPER,
	SKINCOLOR_QUARRY,
	SKINCOLOR_YELLOW,
	SKINCOLOR_MUSTARD,
	SKINCOLOR_CROCODILE,
	SKINCOLOR_OLIVE,
	SKINCOLOR_VOMIT,
	SKINCOLOR_GARDEN,
	SKINCOLOR_LIME,
	SKINCOLOR_HANDHELD,
	SKINCOLOR_TEA,
	SKINCOLOR_PISTACHIO,
	SKINCOLOR_MOSS,
	SKINCOLOR_CAMOUFLAGE,
	SKINCOLOR_ROBOHOOD,
	SKINCOLOR_MINT,
	SKINCOLOR_GREEN,
	SKINCOLOR_PINETREE,
	SKINCOLOR_EMERALD,
	SKINCOLOR_SWAMP,
	SKINCOLOR_DREAM,
	SKINCOLOR_PLAGUE,
	SKINCOLOR_ALGAE,
	SKINCOLOR_CARRIBEAN,
	SKINCOLOR_AZURE,
	SKINCOLOR_TEAL,
	SKINCOLOR_CYAN,
	SKINCOLOR_JAWZ,
	SKINCOLOR_CERULEAN,
	SKINCOLOR_NAVY,
	SKINCOLOR_PLATINUM,
	SKINCOLOR_SLATE,
	SKINCOLOR_STEEL,
	SKINCOLOR_THUNDER,
	SKINCOLOR_RUST,
	SKINCOLOR_WRISTWATCH,
	SKINCOLOR_JET,
	SKINCOLOR_SAPPHIRE,
	SKINCOLOR_PERIWINKLE,
	SKINCOLOR_BLUE,
	SKINCOLOR_BLUEBERRY,
	SKINCOLOR_NOVA,
	SKINCOLOR_PASTEL,
	SKINCOLOR_MOONSLAM,
	SKINCOLOR_UNTRAVIOLET,
	SKINCOLOR_DUSK,
	SKINCOLOR_BUBBLEGUM,
	SKINCOLOR_PURPLE,
	SKINCOLOR_FUCHSIA,
	SKINCOLOR_TOXIC,
	SKINCOLOR_MAUVE,
	SKINCOLOR_LAVENDER,
	SKINCOLOR_BYZANTIUM,
	SKINCOLOR_POMEGRANATE,
	SKINCOLOR_LILAC
}
for k,v in ipairs(colorlist)
	skincolors[k] = v
end

local numtotrans = {
	[9] = FF_TRANS90,
	[8] = FF_TRANS80,
	[7] = FF_TRANS70,
	[6] = FF_TRANS60,
	[5] = FF_TRANS50,
	[4] = FF_TRANS40,
	[3] = FF_TRANS30,
	[2] = FF_TRANS20,
	[1] = FF_TRANS10,
	[0] = 0,
}

freeslot("MT_TAKIS_AFTERIMAGE")
mobjinfo[MT_TAKIS_AFTERIMAGE] = {
	doomednum = -1,
	spawnstate = S_NULL,
	radius = 12*FRACUNIT,
	height = 10*FRACUNIT,
	flags = MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOGRAVITY|MF_NOBLOCKMAP		
}
freeslot("SPR_TGIB")
freeslot("S_TAKIS_GIB")
freeslot("MT_TAKIS_GIB")
states[S_TAKIS_GIB] = {
	sprite = SPR_TGIB,
	frame = A,
	tics = -1,
}
mobjinfo[MT_TAKIS_GIB] = {
	doomednum = -1,
	spawnstate = S_TAKIS_GIB,
	flags = MF_NOCLIPTHING,
	height = 4*FRACUNIT,
	radius = 4*FRACUNIT,
}

addHook("MobjThinker",function(gib)
	if not (gib and gib.valid) then return end
	local grav = P_GetMobjGravity(gib)
	grav = $*3/5
	gib.momz = $+(grav*P_MobjFlip(gib))
	gib.speed = FixedHypot(gib.momx,gib.momy)
	if (P_IsObjectOnGround(gib)
	and not gib.bounced)
		if not gib.iwillbouncetwice
			gib.flags = $|MF_NOCLIPHEIGHT|MF_NOCLIP
			gib.bounced = true
			gib.tics = 3*TR
			P_SetObjectMomZ(gib,
				(gib.lessbounce and P_RandomRange(2,4) or P_RandomRange(4,9))
				*FU+P_RandomFixed()
			)
		else
			gib.iwillbouncetwice = nil
			gib.lessbounce = true
			P_SetObjectMomZ(gib,P_RandomRange(6,9)*FU+P_RandomFixed())
		end
	end
	
	if gib.speed == 0
		if gib.bounced then return end
		P_BounceMove(gib)
		gib.angle = FixedAngle(AngleFixed($)+180*FU)
	end
	
end,MT_TAKIS_GIB)

addHook("MobjThinker", function(ai)
	if not ai
	or not ai.valid
		return
	end
	
	--we need a thing to follow
	if not ai.target
	or not ai.target.valid
		P_RemoveMobj(ai)
		return
	end
	
	local p = ai.target.player
	local me = p.mo
	
	--bruh
	if not me
	or not me.valid
		P_RemoveMobj(ai)
		return	
	end
	
	P_SetOrigin(ai,
		ai.x,
		ai.y,
		ai.z
	)
	
	ai.colorized = true
	if not ai.timealive
		ai.timealive = 1	
	else
		ai.timealive = $+1
	end
	
	local transnum = numtotrans[((ai.timealive*2/3)+1) %9]
	ai.frame = ai.takis_frame|transnum
	
	local fuselimit = 3

	--because fuse doesnt wanna work
	if ai.timealive > fuselimit
		P_RemoveMobj(ai)
		return
	end
	
end, MT_TAKIS_AFTERIMAGE)

local function TakisInitTable(p)
	p.takistable = {
		accspeed = 0,
		afterimaging = false,
		afterimagecolor = 0,
		gibtic = 0,
	}
end

local function TakisCreateAfterimage(p,me)
	if not me
	or not me.valid
		return
	end
	
	local takis = p.takistable
	
	local ghost = P_SpawnMobj(
		me.x,
		me.y,
		me.z,
		MT_TAKIS_AFTERIMAGE
	)
	ghost.target = me
		
	ghost.skin = me.skin
	ghost.scale = me.scale
	ghost.destscale = me.scale/2
	ghost.scalespeed = FixedDiv(me.scale/2,5*me.scale)
	
	ghost.sprite = me.sprite
	
	ghost.state = me.state
	ghost.takis_frame = me.frame
	ghost.tics = -1
	ghost.colorized = true
	
	ghost.angle = p.frameangle
	
	local color = SKINCOLOR_GREEN
	
	--not everyone is salmon
	--but in kart, everyone is
	local salnum = SKINCOLOR_RED
	takis.afterimagecolor = $+1
	if (takis.afterimagecolor > #skincolors-salnum)
		takis.afterimagecolor = 1
	end
	color = salnum+takis.afterimagecolor
	
	if p.kartstuff[k_invincibilitytimer]
		color = me.color
	end
	
	--every other tic, the ai has its color matched to the drift level
	if p.kartstuff[k_driftcharge] > 0
	and (leveltime & 1)
		--if rainbow, stay the same
		if p.kartstuff[k_driftcharge] >= K_GetKartDriftSparkValue(p)*2
			color = SKINCOLOR_KETCHUP
		elseif p.kartstuff[k_driftcharge] >= K_GetKartDriftSparkValue(p)
			color = SKINCOLOR_SAPPHIRE
		end
	end
	
	ghost.color = color
	--sad
	--ghost.blendmode = AST_ADD
	return ghost
end

local function P_ButteredSlope(mo)
	local thrust
	
	if not mo.standingslope
		return
	end
	
	local slope = mo.standingslope
	
	if slope.flags & SL_NOPHYSICS
		return
	end
	
	if mo.flags & (MF_NOGRAVITY|MF_NOCLIPHEIGHT)
		return
	end
	
	local p = mo.player
	local speed = p.takistable.accspeed
	local minspeed = 10*FU
	
	if abs(slope.zdelta) < FU/4
	and not (speed >= minspeed)
		return
	end
	
	if abs(slope.zdelta) < FU/2
	and not (speed)
		return
	end
	
	thrust = sin(slope.zangle)*3 / 2*(mo.eflags & MFE_VERTICALFLIP and 1 or -1)

	if (mo.player) and (speed >= minspeed)
		local mult = 0
		if (mo.momx or mo.momy)
			local angle = R_PointToAngle2(0,0,mo.momx,mo.momy) - slope.xydirection
			
			if P_MobjFlip(mo)*slope.zdelta < 0
				angle = $^ANGLE_180
			end
			
			mult = cos(angle)
		end
		
		thrust = FixedMul(thrust, FU*2/3+mult/8)
	end
	
	if (mo.momx or mo.momy)
		thrust = FixedMul(thrust, FU+FixedHypot(mo.momx,mo.momy)/16)
	end
	
	thrust = FixedMul(thrust, abs(P_GetMobjGravity(mo)))
	
	thrust = FixedMul(thrust, FixedDiv(mo.friction, 29*FU/3))
	
	P_Thrust(mo,slope.xydirection,thrust)
end

local function choosething(...)
	local args = {...}
	local choice = P_RandomRange(1,#args)
	return args[choice]
end

--t is the thing causing, tm is the thing gibbing
local function SpawnEnemyGibs(t,tm,ang)
	local speed
	if (t and t.valid)
		speed = t.player and t.player.takistable.accspeed or FixedHypot(t.momx,t.momy)
		if ang == nil
			ang = R_PointToAngle2(t.x,t.y, tm.x,tm.y)
		end
	else
		ang = FixedAngle( AngleFixed(R_PointToAngle2(tm.x,tm.y, tm.momx,tm.momy)) + 180*FU)
		speed = FixedHypot(tm.momx,tm.momy)
	end
	
	
	local x,y,z = tm.x,tm.y,tm.z
	
	if (t and t.valid)
		x = ((t.x + tm.x)/2)+P_RandomRange(-1,1)+P_RandomFixed()
		y = ((t.y + tm.y)/2)+P_RandomRange(-1,1)+P_RandomFixed()
		z = ((t.z + tm.z)/2)+P_RandomRange(-1,1)+P_RandomFixed()
	end
	
	local mo = tm or t
	for i = 0,P_RandomRange(5,16)
		local gib = P_SpawnMobj(x,y,z,MT_TAKIS_GIB)
		gib.flags2 = $ &~MF2_TWOD
		gib.scale = mo.scale
		gib.iwillbouncetwice = P_RandomChance(FU/2)
		
		gib.frame = P_RandomRange(A,I)
		if (mo and mo.valid)
			gib.frame = choosething(A,B,E,G,H,I)
		end
		gib.flags2 = $|(mo.flags2 & MF2_OBJECTFLIP)
		
		local angrng = P_RandomChance(FU/2)
		gib.angle = angrng and ang or ang-ANGLE_180
		gib.fuse = 3*TR
		P_SetObjectMomZ(gib,P_RandomRange(6,20)*gib.scale+P_RandomFixed())
		if (t and t.valid)
			P_Thrust(gib,
				R_PointToAngle2(t.x,t.y, tm.x,tm.y),
				speed/6
			)
		end
		P_Thrust(gib,gib.angle,P_RandomRange(1,10)*gib.scale+P_RandomFixed())
	end
end

local function GetHighSpeed()
	local speed = TAKIS_HIGHSPEED
	if gamespeed == 0
		speed = TAKIS_EASY_HIGHSPEED
	elseif gamespeed == 2
		speed = TAKIS_HARD_HIGHSPEED
	end
	return speed
end

addHook("PlayerThink",function(p)
	if not (p and p.valid) then return end
	
	local me = p.mo
	
	if not (me and me.valid) then return end
	
	local takis = p.takistable
	if not takis
		TakisInitTable(p)
		return
	end
	
	takis.accspeed = FixedDiv(abs(FixedHypot(p.rmomx,p.rmomy)), me.scale)
	
	if takis.gibtic
		SpawnEnemyGibs(me,me,me.angle+ANGLE_90)
		takis.gibtic = $-1
	end
	
	if me.skin ~= TAKIS_SKIN then return end
	
	P_ButteredSlope(me)
	
	if (takis.accspeed >= GetHighSpeed()
	or p.kartstuff[k_invincibilitytimer])
	and p.playerstate == PST_LIVE
		takis.afterimaging = true
		TakisCreateAfterimage(p,me)
	else
		takis.afterimaging = false
		takis.afterimagecolor = 1
	end
	
end)

addHook("PlayerSpin",function(p,inf,sor)
	local me = p.mo
	
	if not ((me.skin == TAKIS_SKIN)
	or ((sor and sor.valid) and sor.skin == TAKIS_SKIN))
		return
	end
	
	local takis = p.takistable
	
	if not takis then return end
	
	takis.gibtic = 7
end)