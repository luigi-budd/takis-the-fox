--textbox lib, original is by clonefighter!
--modified to resemble the banjo games
-- https://mb.srb2.org/addons/c-fighters-textbox-library.4487/
local function choosething(...)
	local args = {...}
	local choice = P_RandomRange(1,#args)
	return args[choice]
end

if CFTextBoxes then
    filesdone = $+1
    error("A version of Clone Fighter's Text Boxes is already loaded. Aborting...", -1)
	return
end

-- The main library for the textboxes.
-- Made by Clone Fighter; v1.0.0
rawset(_G, "CFTextBoxes", {
    version = {1, 0, 0}, -- Major, minor, hotfix
    globalBox = {}
})

local function BreakUpText(v, s) -- lol
    local str = {s}
    local i = 1
    while v.stringWidth(str[i], V_ALLOWLOWERCASE, "normal") > 306 do
        if i > 5 then break end
        
        str[i+1] = str[i]
        local a
        while true do
            str[i] = string.sub($, 1, -2)
            if v.stringWidth(str[i], V_ALLOWLOWERCASE, "normal") <= 306 and (string.sub(str[i], -1, -1) == " " or string.find(str[i], "\n")) then
                if string.find(str[i], "\n") then str[i] = string.sub($, 1, string.find($, "\n")-1) else str[i] = string.sub(str[i], 1, -2) end
                a = string.len(str[i])
                break
            end
        end
        str[i+1] = string.sub($, a+2, -1)
        i = $+1
        
        if string.find(str[i], "\n") then
            str[i+1] = string.sub(str[i], string.find(str[i], "\n")+1, -1)
            str[i] = string.sub($, 1, string.find($, "\n")-1)
            
            if str[i]:len() == 0 then
                str[i] = str[i+1]
                str[i+1] = ""
            end
        end
        str[i+2] = str[i+1]
    end
        
    if string.find(str[i], "\n") then
        str[i+1] = string.sub(str[i], string.find(str[i], "\n")+1, -1)
        str[i] = string.sub($, 1, string.find($, "\n")-1)
        
        if str[i]:len() == 0 then
            str[i] = str[i+1]
            str[i+1] = ""
        end
    end
    
    if str[i+2] == str[i+1] then str[i+2] = "" end
    return str
end

freeslot("SPR2_TBXA", "SPR2_TBXM") -- Slots for any custom animations required. I'm generous enough to give you a whole 64 extra slots for free! As well as 64 mini slots.

local TB = CFTextBoxes -- shortcut

-- Set up a textbox set. This makes the affected player unable to move, just so that they can interact with the textbox.
-- You can set a delay for the textboxes to close/progress automatically in their options.
-- You are also able to disable the control lock, in which case you cannot interact with the textbox. Default delay is set to 3 seconds.
-- And of course, you can make the box display globally.
function TB:DisplayBox(player, table, move)
    if player then
        player.textBox = {
            tree = table,
            current = 1,
            move = move
        }
		S_StartSound(nil,sfx_tb_tin,player)
    else
        self.globalBox = {
            tree = table,
            current = 1,
            move = move,
            global = true
        }
        for p in players.iterate do
            p.textBox = self.globalBox
			S_StartSound(nil,sfx_tb_tin,p)
        end
    end
end

-- Close any box the player might have up.
function TB:CloseBox(player)
    if player then
		player.textBoxClose = {
			xscale = 0,
			xtween = 0,
			tics = 17
		}
		player.textBox = {}
    else
		self.globalBox = {}
	end
end

-- Advance.
function TB.AdvanceBox(player)
    if player.textBox.choice then player.textBox.current = player.textBox.tree[player.textBox.current].choices[player.textBox.choice].box
        player.textBox.choice = 0
    else player.textBox.current = player.textBox.tree[$].next end
    
	S_StartSound(nil,sfx_tb_cls,player)
    if player.textBox.current != 0
	and player.textBox.tree[player.textBox.current].script then 
		player.textBox.tree[player.textBox.current].script(player)
	else
		TB:CloseBox(player)
		return
	end
    player.textBox.settings = {
        timer = 1,
        atonce = 1,
        prev = nil,
        curt = 17,
		
		xtween = 0,
		tweento = true,
		xscale = 0,
		
        copied = 0,
        wait = 0,
        mode = {},
        escape = {}
    }
    player.textBox.render = ""
    player.textBox.txfilter = nil
end

-- Box handler
local move, move2 = 0, 0

addHook("KeyDown", function(keyevent)
    -- spaget
    local aa, ab = input.gameControlToKeyNum(GC_STRAFELEFT)
    local ac, ad = input.gameControlToKeyNum(GC_STRAFERIGHT)
    local ba, bb = input.gameControl2ToKeyNum(GC_STRAFELEFT)
    local bc, bd = input.gameControl2ToKeyNum(GC_STRAFERIGHT)
    
    if keyevent.num == aa or keyevent.num == ab then
        move = -1
    elseif keyevent.num == ac or keyevent.num == ad then
        move = 1
    end
    if keyevent.num == ba or keyevent.num == bb then
        move2 = -1
    elseif keyevent.num == bc or keyevent.num == bd then
        move2 = 1
    end
end)

local punct = {
    ["."] = true,
    [","] = true,
    [";"] = true,
    [":"] = true,
    ["?"] = true,
    ["!"] = true,
}

addHook("PlayerThink", function(player)	
	if player.textBoxClose
		if (player.textBoxClose.tics > 6)
			player.textBoxClose.xscale = ease.linear(FU/3,$,FU-FU/6)
		else
			if player.textBoxClose.tics == 6
				S_StartSound(nil,sfx_tb_tot,player)
			end
			player.textBoxClose.xtween = ease.inquad(FU/4,$,-700*FU)
		end
		player.textBoxClose.tics = $-1
		if player.textBoxClose.tics == 0
			player.textBoxClose = nil
		end
	end
	
    player.textBox = $ or {}
	player.textBoxInAction = $ or false
    if not player.textBox.tree then
		player.textBoxInAction = false
		if not player.textBox.complete then 
			player.textBox = TB.globalBox
		end
		return 
	end
    if player.textBox.global and not TB.globalBox.tree then player.textBox = {}; return end
    
    if not player.textBox.move then player.pflags = $|PF_FULLSTASIS; player.powers[pw_flashing] = 1 end
    
    local box = player.textBox
    local tree = box.tree
    local curbox = tree[player.textBox.current]
    player.textBoxInAction = true
	
    -- KeyDown momento
    if player == consoleplayer then player.select = move
    elseif player == secondarydisplayplayer then player.select = move2 end
    
    if curbox.choices then
        box.choice = $ or 1
        
        if player.select then
            box.choice = $+player.select
            if box.choice > #curbox.choices then box.choice = 1
            elseif box.choice < 1 then box.choice = #curbox.choices end
            S_StartSound(nil, sfx_menu1, player)
        end
    end
    
    -- Onto the box.
    box.render = $ or ""
    box.settings = $ or {
        timer = 1,
        atonce = 1,
        prev = nil,
        
        curt = 17,
        copied = 0,
        
		xtween = -700*FU,
		tweento = false,
		xscale = FU-FU/6,
		
        wait = 0,
        mode = {},
        escape = {}
    }
    if curbox.text then
        box.txfilter = curbox.text
        local i = 1
        while i < #box.txfilter do
            while string.sub(box.txfilter, i, i) == '|' do
                if string.sub(box.txfilter, i+1, i+3) == "del" or string.sub(box.txfilter, i+1, i+3) == "pau" then
                    box.txfilter = string.sub($, 1, i-1) .. string.sub($, i+6, -1)
                elseif string.sub(box.txfilter, i+1, i+3) == "shk" or string.sub(box.txfilter, i+1, i+3) == "esc" then
                    box.txfilter = string.sub($, 1, i-1) .. string.sub($, i+5, -1)
                elseif string.sub(box.txfilter, i+1, i+3) == "wav" or string.sub(box.txfilter, i+1, i+3) == "rst" then
                    box.txfilter = string.sub($, 1, i-1) .. string.sub($, i+4, -1)
                else
                    break
                end
            end
            i = $+1
        end
    end
    
    if box.txfilter and box.render != box.txfilter then
        box.settings.curt = $-1
		if (box.settings.xtween ~= 0)
			box.settings.xtween = ease.outquad(FU/3,$,0)
		end
		if (box.settings.curt <= 6)
			if (box.settings.tweento)
				box.settings.tweento = false
			end
			if (box.settings.curt == 6)
				S_StartSound(nil,sfx_tb_opn,player)
			end
			if (box.settings.xscale ~= 0)
				box.settings.xscale = ease.linear(FU/3,$,0)
			end
		else
			if (box.settings.tweento)
				box.settings.xscale = ease.linear(FU/3,$,FU-FU/6)
			end
		end
		
        if box.settings.curt == 0 then
            box.settings.curt = box.settings.timer
            
            local iter = 0
            while iter < box.settings.atonce do
                box.settings.copied = $+1
                local cpy = string.sub(curbox.text, box.settings.copied, box.settings.copied)
                while cpy == "|" do
                    box.settings.copied = $+3
                    cpy = string.sub(curbox.text, box.settings.copied-2, box.settings.copied)
                    local vd = false
                    
                    if cpy == "del" then
                        box.settings.copied = $+2
                        local x, y = tonumber(string.sub(curbox.text, box.settings.copied-1, box.settings.copied-1)) or 1,
                                tonumber(string.sub(curbox.text, box.settings.copied, box.settings.copied)) or 1
                        box.settings.atonce, box.settings.timer = x, y
                        vd = true
                    elseif cpy == "pau" then
                        box.settings.copied = $+2
                        local x = tonumber(string.sub(curbox.text, box.settings.copied-1, box.settings.copied)) or 1
                        box.settings.curt = $+x
                        vd = true
                        iter = box.settings.atonce --hack to stop right here
                    elseif cpy == "shk" then
                        box.settings.copied = $+1
                        local x = tonumber(string.sub(curbox.text, box.settings.copied, box.settings.copied))
                        box.settings.mode[#box.render+1] = x
                        vd = true
                    elseif cpy == "esc" then
                        box.settings.copied = $+1
                        box.settings.escape[#box.render+1] = string.sub(curbox.text, box.settings.copied, box.settings.copied)
                        vd = true
                    elseif cpy == "wav" then
                        box.settings.mode[#box.render+1] = 4
                        vd = true
                    elseif cpy == "rst" then
                        box.settings.mode[#box.render+1] = 0
                        vd = true
                    end
                    
                    if vd then
                        box.settings.copied = $+1
                        cpy = string.sub(curbox.text, box.settings.copied, box.settings.copied)
                    else
                        box.settings.copied = $-3
                        cpy = string.sub(curbox.text, box.settings.copied, box.settings.copied)
                        break
                    end
                end
                box.render = $..cpy
                iter = $+1
                
                if box.settings.mode[#box.render] == nil then box.settings.mode[#box.render] = box.settings.mode[#box.render-1] or 0 end
                if not box.settings.escape[#box.render] then box.settings.escape[#box.render] = box.settings.escape[#box.render-1] or "\x80" end
            end
			local sounds = curbox.sound
			if sounds ~= nil
			and (P_RandomChance(curbox.soundchance or FU))
				S_StartSound(nil,
					choosething(unpack(sounds)),
					player
				)
			end
            
            if punct[string.sub(box.render, -1, -1)] then box.settings.curt = $*4 end
        end
    else
        box.settings.wait = $+1
        if curbox.delay and box.settings.wait == curbox.delay then TB.AdvanceBox(player) end
    end
    
    if player.cmd.buttons & BT_JUMP and not player.textBox.move then
        if not box.txfilter or box.render == box.txfilter then
            if not player.boxadvance then
                TB.AdvanceBox(player)
            end
        else
            if not player.boxadvance then box.settings.prev = box.settings.atonce end
            if box.settings.prev then box.settings.atonce = box.settings.prev*5; box.settings.curt = 1 end
        end
        player.boxadvance = true
    else if player.boxadvance and box.settings.prev then box.settings.atonce = box.settings.prev; box.settings.prev = nil end; player.boxadvance = false end
    
    if player.cmd.buttons & BT_SPIN and not player.textBox.move then
        if box.txfilter and box.render != box.txfilter then
            if not player.boxskip then box.settings.prev = box.settings.atonce end
            box.settings.atonce = string.len(box.txfilter); box.settings.curt = 1
        end
        player.boxskip = true
		box.settings.xscale = 0
		box.settings.xtween = 0
    else if player.boxskip and box.settings.prev then box.settings.atonce = box.settings.prev; box.settings.prev = nil end; player.boxskip = false end
    
    if player.textBox.current == 0 then
        if not player.textBox.move then player.powers[pw_flashing] = TICRATE/2 end
        player.textBox = {complete = true}
    return end
    
    -- reset
    move, move2 = 0, 0
end)

local posTable = {
    up = {x = 160, y = 155, a = "center"},
    down = {x = 160, y = 183, a = "center"},
    left = {x = 7, y = 169, a = "left"},
    right = {x = 313, y = 169, a = "right"},
    ul = {x = 7, y = 155, a = "left"},
    ur = {x = 313, y = 155, a = "right"},
    dl = {x = 7, y = 183, a = "left"},
    dr = {x = 313, y = 183, a = "right"},
    center = {x = 160, y = 169, a = "center"}
}
local cursTable = {
    up = {x = 152, y = 163},
    down = {x = 152, y = 191},
    left = {x = 7, y = 177},
    right = {x = 296, y = 177},
    ul = {x = 7, y = 163},
    ur = {x = 296, y = 163},
    dl = {x = 7, y = 191},
    dr = {x = 296, y = 191},
    center = {x = 152, y = 177}
}

-- Box drawer
local function textboxStringDrawer(v, x, y, sss, f, box)
    local t = BreakUpText(v, sss)
    
    for i, str in ipairs(t) do
        local space = 0
        if not (box and box.settings) then return end
        for j = 1, #str do
            local k = 0
            for l = 1, i-1 do
                if t[l] then k = $+#t[l]+1 end
            end
            local rendstr = str:sub(j,j)
            if box.settings.escape[j+k] then rendstr = box.settings.escape[j+k]..$ end
            
            if box.settings.mode[j+k] == 0 then -- Normal
                v.drawString(x+space, y+8*(i-1), rendstr, f)
            elseif box.settings.mode[j+k] == 4 then -- Wavy
                v.drawString(x+space, y+8*(i-1)+(2*sin(FixedAngle(ease.linear(((j+leveltime)%10)*FRACUNIT/10, 0, 360)*FRACUNIT))/FRACUNIT), rendstr, f)
            else -- Shake
                local shkchnc = {FRACUNIT/20, FRACUNIT/5, FRACUNIT/2}
                local randx,randy = 0,0
                if v.RandomChance(shkchnc[box.settings.mode[j+k]]) then
                    randx,randy = v.RandomRange(-1,1),v.RandomRange(-1,1)
                end
                v.drawString(x+space+randx, y+8*(i-1)+randy, rendstr, f)
            end
            space = $+v.stringWidth(rendstr, f)
        end
    end
end

hud.add(function(v, player)
	if (player.textBoxClose)
		local box = player.textBoxClose
		local xt = box.xtween
		local xs = box.xscale
		
		v.drawStretched(0+xt,146*FU,
			FU-xs, FU,
			v.cachePatch("TA_SPCHBOX"), V_SNAPTOBOTTOM
		)
		    
	end
	
    if not player.textBox or not player.textBox.tree then return end
    local tb = player.textBox
    local box = tb.tree[tb.current]
    local xt = -700*FU
	local xs = FU-FU/6
	if tb.settings
		xt = tb.settings.xtween
		xs = tb.settings.xscale
	end
	
    -- Portrait
    if box.portrait then
        local spr, flip = v.getSprite2Patch(box.portrait[1], box.portrait[2], false, box.portrait[3], box.portrait[4])
        local colr = v.getColormap(box.portrait[1], box.color)
		local hires = skins[box.portrait[1]].highresscale or FU
        v.drawScaled(32*FRACUNIT+xt,
			146*FRACUNIT + (spr.topoffset*hires/3),
			hires,
			spr,
			(flip and V_FLIP or 0)|V_SNAPTOBOTTOM,
			colr
		)
    end
    
    -- Box
    v.drawStretched(0+xt,146*FU,
		FU-xs, FU,
		v.cachePatch("TA_SPCHBOX"), V_SNAPTOBOTTOM
	)
	
    if box.name then 
		v.drawString(48*FU+xt, 138*FU,
			box.name,
			V_YELLOWMAP|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE,
			"fixed"
		)
	end
    
    if tb.render then
		--actually draw the text
        textboxStringDrawer(v, 7, 153, tb.render, V_SNAPTOBOTTOM|V_ALLOWLOWERCASE, tb)
    end
    
    if box.choices then
        local e = ""
        for i, j in ipairs(box.choices) do
            local h = (tb.choice == i) and V_YELLOWMAP or 0
            v.drawString(posTable[j.pos].x, posTable[j.pos].y, j.text, V_SNAPTOBOTTOM|V_ALLOWLOWERCASE|h, posTable[j.pos].a)
            if tb.choice == i then e = j.pos end
        end
        if e and cursTable[e] then v.draw(cursTable[e].x, cursTable[e].y, v.cachePatch("M_CURSOR"), V_SNAPTOBOTTOM) end
    end
    
    if box.mini then
        for i, j in ipairs(box.mini) do
            local a = "thin-"..posTable[j.pos].a
            if a == "thin-left" then a = "thin" end
            
            local spr = v.getSprite2Patch(j.portrait[1], SPR2_TBXM, false, j.portrait[2], 1)
            local col = v.getColormap(j.portrait[1], j.color)
            
            if tb.settings.wait < 2+i and tb.settings.wait > i then
                if a == "thin" then
                    v.draw(posTable[j.pos].x+8, posTable[j.pos].y+10, spr, V_SNAPTOBOTTOM|V_50TRANS, col)
                    v.drawString(posTable[j.pos].x+16, posTable[j.pos].y+2, j.text, V_SNAPTOBOTTOM|V_ALLOWLOWERCASE|V_50TRANS, a)
                elseif a == "thin-right" then
                    v.draw(posTable[j.pos].x-8, posTable[j.pos].y+10, spr, V_SNAPTOBOTTOM|V_FLIP|V_50TRANS, col)
                    v.drawString(posTable[j.pos].x-16, posTable[j.pos].y+2, j.text, V_SNAPTOBOTTOM|V_ALLOWLOWERCASE|V_50TRANS, a)
                else
                    v.draw(posTable[j.pos].x-(v.stringWidth(j.text, V_ALLOWLOWERCASE, "thin")/2), posTable[j.pos].y+10, spr, V_SNAPTOBOTTOM|V_50TRANS, col)
                    v.drawString(posTable[j.pos].x+8, posTable[j.pos].y+2, j.text, V_SNAPTOBOTTOM|V_ALLOWLOWERCASE|V_50TRANS, a)
                end
            elseif tb.settings.wait >= 2+i then
                if a == "thin" then
                    v.draw(posTable[j.pos].x+8, posTable[j.pos].y+8, spr, V_SNAPTOBOTTOM, col)
                    v.drawString(posTable[j.pos].x+16, posTable[j.pos].y, j.text, V_SNAPTOBOTTOM|V_ALLOWLOWERCASE, a)
                elseif a == "thin-right" then
                    v.draw(posTable[j.pos].x-8, posTable[j.pos].y+8, spr, V_SNAPTOBOTTOM|V_FLIP, col)
                    v.drawString(posTable[j.pos].x-16, posTable[j.pos].y, j.text, V_SNAPTOBOTTOM|V_ALLOWLOWERCASE, a)
                else
                    v.draw(posTable[j.pos].x-(v.stringWidth(j.text, V_ALLOWLOWERCASE, "thin")/2), posTable[j.pos].y+8, spr, V_SNAPTOBOTTOM, col)
                    v.drawString(posTable[j.pos].x+8, posTable[j.pos].y, j.text, V_SNAPTOBOTTOM|V_ALLOWLOWERCASE, a)
                end
            end
        end
    end
end)

local takisname = "\x83Takis"
local takisvox = {sfx_s_tak1,sfx_s_tak2,sfx_s_tak3}
local takischance = FU/3

rawset(_G,"TAKIS_TEXTBOXES",{
	shotgun = {
		[1] = { 
			name = takisname,
			portrait = {TAKIS_SKIN, SPR2_STND, A, 8},
			color = SKINCOLOR_FOREST,
			text = "This is the shotgun tutorial! Handling a shotgun is not very hard, and this tutorial won't be either!",
			sound = takisvox,
			soundchance = takischance,
			delay = 2*TICRATE,
			script = function(player)
			end,
			next = 2
		},
		[2] = { 
			name = takisname,
			portrait = {TAKIS_SKIN, SPR2_STND, A, 8},
			color = SKINCOLOR_FOREST,
			text = "I will get a new moveset, completely different from what you're used to! "
			.."Clutching and whatnot cannot be used with the shotgun!",
			sound = {sfx_antow1,sfx_antow2,sfx_antow3},
			soundchance = takischance,
			delay = 2*TICRATE,
			script = function(player)
			end,
			next = 3
		},
		[3] = { 
			name = takisname,
			portrait = {TAKIS_SKIN, SPR2_STND, A, 8},
			color = SKINCOLOR_FOREST,
			text = "Press |esc\x82[SPIN]|esc\x80 to shoot the shotgun. The bullets can launch badniks and break spikes! "
			.."Press |esc\x82[CUSTOM2]|esc\x80 midair to shoot the ground, and start stomping!",
			sound = {sfx_antow1,sfx_antow2,sfx_antow3},
			soundchance = takischance,
			delay = 3*TICRATE,
			script = function(player)
			end,
			next = 4
		},
		[4] = { 
			name = takisname,
			portrait = {TAKIS_SKIN, SPR2_STND, A, 8},
			color = SKINCOLOR_FOREST,
			text = "I can still slide (|esc\x82[CUSTOM2]|esc\x80) with the shotgun. "
			.."The slide is not great for gaining speed on flat ground, so I can |esc\x83"
			.."Shoulder Bash|esc\x80 with |esc\x82[CUSTOM1]|esc\x80 to get speed!",
			sound = {sfx_antow1,sfx_antow2,sfx_antow3},
			soundchance = takischance,
			delay = 4*TICRATE,
			script = function(player)
			end,
			next = 5
		},
		[5] = { 
			name = takisname,
			portrait = {TAKIS_SKIN, SPR2_STND, A, 8},
			color = SKINCOLOR_FOREST,
			text = "That is about it! There is nothing else for me to teach you. Get blastin'!",
			sound = {sfx_antow1,sfx_antow2,sfx_antow3},
			soundchance = takischance,
			delay = 2*TICRATE,
			script = function(player)
			end,
			next = 0
		},
	},
})

addHook("LinedefExecute",function(line,mo,sec)
	if not mo.valid
	or not mo.health
	or not mo.player
	or not mo.player.valid
		return
	end
	
	if TAKIS_TEXTBOXES["gmap"..gamemap] ~= nil
		if TAKIS_TEXTBOXES["gmap"..gamemap][sec.tag] ~= nil
			CFTextBoxes:DisplayBox(mo.player,
				TAKIS_TEXTBOXES["gmap"..gamemap][sec.tag]
			)
		end
	end
end,"TAK_TBOX")

/*
	a map specific textbox would be listed like this:
	TAKIS_TEXTBOXES.gmap1 = {			-this is the gamemap
		[1] = {							-the first set of boxes
										 indexed by the calling
										 sector's tag
			[1] = {						-the textboxes whatever
				...
			}
			...
		}
		[2] = {
			...
		}
	}
	
	TAKIS_TEXTBOXES.gmap1 = {
		[1] = {							
			[1] = {						
			}
		}
	}
	
	--for stuff that isnt loaded alongside takis, use this
	
	local addeddia = false
	addHook("ThinkFrame",do
		if TAKIS_TEXTBOXES ~= nil
		and not addeddia
			-- add the dialog...
			addeddia = true
			print("Added Takis Dialog")
		end
	end)
*/

filesdone = $+1
