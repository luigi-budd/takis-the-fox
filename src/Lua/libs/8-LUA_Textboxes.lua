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

SafeFreeslot("SPR2_TBXA", "SPR2_TBXM") -- Slots for any custom animations required. I'm generous enough to give you a whole 64 extra slots for free! As well as 64 mini slots.

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
			tics = 17,
			flag = (player.textBox.move) and V_50TRANS or 0
		}
		player.textBox = {}
    else
		self.globalBox = {}
	end
end

-- Advance.
function TB.AdvanceBox(player)
	local lasttree = player.textBox.current
    if player.textBox.choice then 
		player.textBox.current = player.textBox.tree[player.textBox.current].choices[player.textBox.choice].box
        player.textBox.choice = 0
    else 
		if player.textBox.tree
			player.textBox.current = player.textBox.tree[$].next
		end
	end
    
	S_StartSound(nil,sfx_tb_cls,player)
    if player.textBox.current != 0
		print(player.textBox.current)
		if lasttree
			if player.textBox.tree[lasttree].advancescript then
				player.textBox.tree[lasttree].advancescript(player)
			end
		end
		player.textBox.move = player.textBox.tree[player.textBox.current].move
	else
		if player.textBox.tree[lasttree].closescript then 
			player.textBox.tree[lasttree].closescript(player)
		end
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
	
	player.textboxuse = $ or 0
	if (player.cmd.buttons & BT_USE)
		player.textboxuse = $+1
	else
		player.textboxuse = 0
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
 	if player.textBox.tree[player.textBox.current].script then 
		player.textBox.tree[player.textBox.current].script(player)
	end
   
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
    
	if (player.textboxuse == 1) and not player.textBox.move then
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
			v.cachePatch("TA_SPCHBOX"), V_SNAPTOBOTTOM|box.flag
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
	
	if not box then return end
	
	local colormap = box.color
	if box.color == "playercolor"
		colormap = player.skincolor
	end
    -- Portrait
    if box.portrait then
		local yoff = box.portyoffset or 0
        local spr, flip = v.getSprite2Patch(box.portrait[1], box.portrait[2], box.portrait[5] or false, box.portrait[3], box.portrait[4])
        local colr = v.getColormap(box.portrait[1], colormap)
		local hires = skins[box.portrait[1]].highresscale or FU
        v.drawScaled(32*FRACUNIT+xt,
			146*FRACUNIT + (spr.topoffset*hires/3)+yoff,
			hires,
			spr,
			(flip and V_FLIP or 0)|V_SNAPTOBOTTOM,
			colr
		)
    end
    
    -- Box
	local bflag = (player.textBox.move) and V_50TRANS or 0
    v.drawStretched(0+xt,146*FU,
		FU-xs, FU,
		v.cachePatch("TA_SPCHBOX"), V_SNAPTOBOTTOM|bflag
	)
	
    if box.name then 
		local name = box.name
		local map = box.namemap or V_YELLOWMAP
		if box.name == "takisname"
			map = 0
			if colormap == SKINCOLOR_GREEN
				name = "\x83Taykis"
			elseif colormap == SKINCOLOR_RED
			and not ((colormap == skincolor_redteam) and G_GametypeHasTeams())
				name = "\x85Yakis"
			elseif colormap == SKINCOLOR_SALMON
				name = "\x85Rakis"
			else
				name = "\x83Takis"
			end
		end
		
		v.drawString(48*FU+xt, 138*FU,
			name,
			map|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE,
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
            local colormap = j.color
			if j.color == "playercolor"
				colormap = player.skincolor
			end
			
			local col = v.getColormap(j.portrait[1], colormap)
            
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


local takisport = {TAKIS_SKIN, SPR2_STND, A, 8}
local takisname = "takisname"
local takisvox = {sfx_s_tak1,sfx_s_tak2,sfx_s_tak3}
local takischance = FU/3

rawset(_G,"TAKIS_TEXTBOXES",{
	shotgun = {
		[1] = { 
			name = takisname,
			portrait = takisport,
			color = "playercolor",
			text = "This is the shotgun tutorial! Handling a shotgun is not very hard, and this tutorial won't be either!",
			sound = takisvox,
			soundchance = takischance,
			delay = 2*TICRATE,
			script = function() end,
			next = 2
		},
		[2] = { 
			name = takisname,
			portrait = takisport,
			color = "playercolor",
			text = "I will get a new moveset, completely different from what you're used to! "
			.."Clutching and whatnot cannot be used with the shotgun!",
			sound = takisvox,
			soundchance = takischance,
			delay = 2*TICRATE,
			script = function() end,
			next = 3
		},
		[3] = { 
			name = takisname,
			portrait = takisport,
			color = "playercolor",
			text = "Press |esc\x82[SPIN]|esc\x80 to shoot the shotgun. The bullets can launch badniks and break spikes! "
			.."Press |esc\x82[CUSTOM2]|esc\x80 midair to shoot the ground, and start stomping!",
			sound = takisvox,
			soundchance = takischance,
			delay = 3*TICRATE,
			script = function() end,
			next = 4
		},
		[4] = { 
			name = takisname,
			portrait = takisport,
			color = "playercolor",
			text = "I can still slide (|esc\x82[CUSTOM2]|esc\x80) with the shotgun. "
			.."The slide is not great for gaining speed on flat ground, so I can |esc\x83"
			.."Shoulder Bash|esc\x80 with |esc\x82[CUSTOM1]|esc\x80 to get speed!",
			sound = takisvox,
			soundchance = takischance,
			delay = 4*TICRATE,
			script = function() end,
			next = 5
		},
		[5] = { 
			name = takisname,
			portrait = takisport,
			color = "playercolor",
			text = "That is about it! There is nothing else for me to teach you. Get blastin'!",
			sound = takisvox,
			soundchance = takischance,
			delay = 2*TICRATE,
			script = function() end,
			next = 0
		},
	},
	shotgunnotif = {
		[1] = { 
			name = takisname,
			portrait = takisport,
			color = "playercolor",
			text = "In |esc\x89Ultimate Mode|esc\x80, a Shotgun Monitor will spawn besides me.",
			sound = takisvox,
			soundchance = takischance,
			delay = 2*TICRATE,
			script = function() end,
			next = 2
		},
		[2] = { 
			name = takisname,
			portrait = takisport,
			color = "playercolor",
			text = "Finishing a level with the Shotgun will award |esc\x82".."2000|esc\x80 bonus points.",
			sound = takisvox,
			soundchance = takischance,
			delay = 2*TICRATE,
			script = function() end,
			next = 3
		},
		[3] = { 
			name = takisname,
			portrait = takisport,
			color = "playercolor",
			text = "The shotgun doesn't provide an extra hit! Try not to be careless, or else I will face the consequences!",
			sound = takisvox,
			soundchance = takischance,
			delay = 2*TICRATE,
			script = function() end,
			next = 0
		},
	},
	tutexit = {
		[1] = { 
			name = takisname,
			portrait = takisport,
			color = "playercolor",
			text = "You don't need this tutorial, why are you here?",
			sound = takisvox,
			soundchance = takischance,
			delay = 2*TICRATE,
			closescript = function(p)
				if p.takistable.isElevated
					G_SetCustomExitVars(1,2)
					G_ExitLevel()
				end
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
		local tag = tonumber(mapheaderinfo[gamemap].takis_hh_tag or "0")
		if sec and sec.valid
			tag = sec.tag
		end
		
		if TAKIS_TEXTBOXES["gmap"..gamemap][tag] ~= nil
			CFTextBoxes:DisplayBox(mo.player,
				TAKIS_TEXTBOXES["gmap"..gamemap][tag],
				TAKIS_TEXTBOXES["gmap"..gamemap][tag][1].move
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

--RED ROOM
TAKIS_TEXTBOXES.gmap1000 = {
	timeshit = {							
		[1] = { 
			text = "Ouch! That looked like it hurt!",
			soundchance = 0,
			delay = 2*TICRATE*3/2,
			next = 2,
		},
		[2] = { 
			text = "Be careful! You'll lose a Heartcard each time you get hurt! Replenish them from dropped Heartcards!",
			soundchance = 0,
			delay = 2*TICRATE*3/2,
			next = 0,
		},
	},
	kys = {							
		[1] = { 
			text = "What are you trying to do, kill yourself?",
			soundchance = 0,
			delay = 2*TICRATE,
			move = true,
			next = 0,
		},
	},
	[1] = {							
		[1] = { 
			text = "Welcome to the tutorial. I hope you like red. You will all you need to know about Takis' moveset. Press |esc\x82[JUMP]|esc\x80 to advance.",
			soundchance = 0,
			delay = 2*TICRATE*3/2,
			next = 2,
		},
		[2] = { 
			text = "The |esc\x82".."Clutch Boost|esc\x80 can be activated with |esc\x82[SPIN]|esc\x80. It'll give you a boost forward. Time each press so the meter is in the green, the speed boosts will increase with the chain.",
			soundchance = 0,
			delay = 2*TICRATE*3/2,
			next = 3,
		},
		[3] = { 
			text = "The |esc\x82".."Clutch Boost|esc\x80 can also break bustables, like walls. Try breaking the cracked wall up ahead.",
			soundchance = 0,
			delay = 2*TICRATE*3/2,
			next = 0,
			closescript = function(p)
				if p.takis_noabil
					p.takis_noabil = $ &~NOABIL_CLUTCH
				end
			end,
		},
	},
	[3] = {							
		[1] = { 
			text = "Nice job on breaking the wall. The |esc\x82".."Clutch Boost|esc\x80 is your main form of attack, capable of launching enemies far away, and even into other enemies.",
			soundchance = 0,
			delay = 2*TICRATE*3/2,
			next = 2,
		},
		[2] = { 
			text = "Clutch into the wall of spikes ahead, trust me.",
			soundchance = 0,
			delay = 2*TICRATE*3/2,
			next = 0,
		},
	},
	[4] = {							
		[1] = { 
			text = "Check that out! The Clutch can destroy spikes as well.",
			soundchance = 0,
			delay = 2*TICRATE*3/2,
			next = 2,
		},
		[2] = { 
			text = "Now double jump to cross this wall.",
			soundchance = 0,
			delay = 2*TICRATE*3/2,
			closescript = function(p)
				if p.takis_noabil
					p.takis_noabil = $ &~NOABIL_THOK
				end			
			end,
			next = 0,
		},
	},
	[5] = {							
		[1] = { 
			text = "The next move you'll need to learn is the |esc\x82Hammer Blast|esc\x80. "..
			"Activate it by holding |esc\x82[SPIN]|esc\x80 midair for a bit.",
			soundchance = 0,
			delay = 2*TICRATE*3/2,
			next = 2,
		},
		[2] = { 
			text = "The |esc\x82Hammer Blast|esc\x80 can also break bustables. There's a bustable floor ahead, go over there and break it.",
			soundchance = 0,
			delay = 2*TICRATE*3/2,
			closescript = function(p)
				if p.takis_noabil
					p.takis_noabil = $|(NOABIL_THOK|NOABIL_CLUTCH) &~NOABIL_HAMMER
				end			
			end,
			next = 0,
		},
	},
	[6] = {							
		[1] = {
			text = "Keep in mind the Hammer Blast can destroy any bustable, even walls and strong ones!",
			soundchance = 0,
			delay = 2*TICRATE*3/2,
			move = true,
			next = 0,
		},
	},
	[11] = {							
		[1] = {
			text = "Use these springs to advance. Hammer Blast them to get more height out of them.",
			soundchance = 0,
			delay = 2*TICRATE,
			next = 0,
		},
	},
	[12] = {							
		[1] = {
			text = "You'll be using one of the Hammer Blast's actions to progress.",
			soundchance = 0,
			delay = 2*TICRATE,
			move = true,
			advancescript = function(p)
				if p.takis_noabil
					p.takis_noabil = $ &~NOABIL_THOK
				end			
			end,
			next = 2,
		},
		[2] = {
			text = "Start a Hammer Blast and hold |esc\x82[JUMP]|esc\x80 before landing. It will bounce you up, and scale the longer you fall. Try using it to scale these walls.",
			soundchance = 0,
			delay = 2*TICRATE,
			next = 3,
		},
		[3] = {
			text = "Note that you can double jump to try and gain more height. You can also double jump after bouncing.",
			soundchance = 0,
			delay = 2*TICRATE,
			next = 0,
		},
	},
	[14] = {							
		[1] = {
			text = "Awesome! Let's try out the other action, called the Hammer Boost. Holding |esc\x82[SPIN]|esc\x80 before landing will launch you forward. It will also stale and take away your speed.",
			soundchance = 0,
			delay = 4*TICRATE,
			advancescript = function(p)
				if p.takis_noabil
					p.takis_noabil = $|NOABIL_THOK &~NOABIL_CLUTCH
				end			
			end,
			next = 2,
		},
		[2] = {
			text = "You can break this bustable wall with a Clutch, the Hammer Blast, or a Hammer Boost (spin).",
			soundchance = 0,
			delay = 2*TICRATE,
			next = 0,
		},
	},
	[20] = {							
		[1] = {
			text = "Ok, look at this. There's a spin gap in our way, and we don't know how to cross it. Takis can't spin, but he can slide with |esc\x82[CUSTOM2]|esc\x80.",
			soundchance = 0,
			delay = 3*TICRATE,
			next = 2,
		},
		[2] = {
			name = takisname,
			portrait = takisport,
			color = "playercolor",
			text = "Hey, I can spin!",
			sound = takisvox,
			soundchance = takischance,
			delay = TICRATE*2,
			next = 3,
		},
		[3] = {
			text = "Yeah but that's only on slopes, so whatever.",
			soundchance = 0,
			delay = TICRATE*3/2,
			next = 0,
			closescript = function(p)
				if p.takis_noabil
					p.takis_noabil = $|NOABIL_HAMMER|NOABIL_CLUTCH &~NOABIL_SLIDE
				end
			end
		},
	},
	[22] = {							
		[1] = {
			text = "Look at these big gaps. Takis can jump pretty far, but not far enough for these gaps.",
			soundchance = 0,
			delay = 2*TICRATE,
			next = 2,
		},
		[2] = {
			text = "Extend your jumps by Clutching right before jumping. If you fall, there is a path at the start to bring you back.",
			soundchance = 0,
			delay = TICRATE*3/2,
			next = 0,
			closescript = function(p)
				if p.takis_noabil
					p.takis_noabil = $|NOABIL_SLIDE &~(NOABIL_CLUTCH)
				end
			end
		},
	},
	[23] = {							
		[1] = {
			text = "This one's a bit tricky. Even Clutch jumping can't get you through this one.",
			soundchance = 0,
			delay = 2*TICRATE,
			next = 2,
		},
		[2] = {
			text = "This is where the Dive comes in handy. Pressing |esc\x82[CUSTOM1]|esc\x80 midair will thrust you forward a bit in the direction of your inputs and remove your downwards momentum.",
			soundchance = 0,
			delay = 3*TICRATE,
			next = 3,
		},
		[3] = {
			text = "Use this to jump around the wall and to the goal!",
			soundchance = 0,
			delay = TICRATE*3/2,
			next = 0,
			closescript = function(p)
				if p.takis_noabil
					p.takis_noabil = $ &~(NOABIL_DIVE)
				end
			end
		},
	},
	[24] = {
		[1] = {
			text = "Ok, lets move onto the Transformations.",
			soundchance = 0,
			delay = 2*TICRATE,
			next = 2,
		},
		[2] = {
			text = "This first one is the Fireass Transformation. Get hurt by lava and you'll become invulnerable to fire damage, and you'll be able to shoot fireballs!",
			soundchance = 0,
			delay = 3*TICRATE,
			next = 3,
		},
		[3] = {
			text = "It expires after 10 seconds, after 7, a hissing sound will play, indicating to go back into lava to extend the timer.",
			soundchance = 0,
			delay = TICRATE*3,
			next = 0,
		},
	},
	[39] = {
		[1] = {
			text = "Let's check out the Shotgun. The shotgun is an |esc\x89Ultimate Mode|esc\x80 exclusive. Break open the Shotgun Monitor in front of you, Takis will tell you how to use it.",
			soundchance = 0,
			delay = 2*TICRATE,
			next = 2,
		},
		[2] = {
			text = "Shoot the targets to the right to progress.",
			soundchance = 0,
			delay = 3*TICRATE,
			next = 0,
		},
	},
	[42] = {
		[1] = {
			text = "Getting crushed isn't fatal in small doses. It'll also squish you into a pancake.",
			soundchance = 0,
			delay = 2*TICRATE,
			next = 2,
		},
		[2] = {
			text = "The pancake lasts for 10 seconds, allowing you to fit under small gaps and float by holding jump.",
			soundchance = 0,
			delay = 3*TICRATE,
			next = 0,
		},
	},
	[44] = {
		[1] = {
			text = "Float across this pit with jump. There's springs at the bottom if you fall.",
			soundchance = 0,
			delay = 2*TICRATE,
			next = 0,
			closescript = function(p)
				if p.takis_noabil
					p.takis_noabil = $|NOABIL_CLUTCH
				end
			end,
			move = true,
		},
	},
	[9999] = {
		[1] = {
			text = "|esc\x87IT'S HAPPY HOUR!! Run back to the elevator to exit the level!",
			soundchance = 0,
			delay = 2*TICRATE,
			script = function(p)
				if p.takis_noabil
					p.takis_noabil = 0
				end
			end,
			move = true,
			next = 0,
		},
	},
}

--TEST MAP
TAKIS_TEXTBOXES.gmap1003 = {
	[3] = {							
		[1] = { 
			name = takisname,
			portrait = takisport,
			color = "playercolor",
			text = "This is a dialog box executed through linedef",
			sound = takisvox,
			soundchance = takischance,
			delay = TICRATE*2,
			next = 2,
		},
		[2] = { 
			name = takisname,
			portrait = takisport,
			color = "playercolor",
			text = "Transparent boxes let you move",
			sound = takisvox,
			soundchance = takischance,
			delay = TICRATE*2,
			move = true,
			next = 3,
		},
		[3] = { 
			name = takisname,
			portrait = takisport,
			color = "playercolor",
			text = "Closing this box will give you 5 rings",
			sound = takisvox,
			soundchance = takischance,
			delay = TICRATE*2,
			closescript = function(p)
				p.rings = $+5
			end,
			next = 0,
		},
	},
}

filesdone = $+1
