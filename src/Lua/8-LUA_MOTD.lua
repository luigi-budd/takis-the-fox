rawset(_G, "TAKIS_INVITELINK", 'discord.gg/JY6ukFuQJV')
rawset(_G, "TAKIS_INVITELINK2", 'https:--github.com/luigi-budd/takis-the-fox')

addHook("PlayerSpawn", function(p)
	if p.discord == nil then
		p.discord = true
	end
end)

hud.add(function(v, p)
	--if not netgame
	if not TAKIS_ISDEBUG
		return
	end
	
	if p.discord == true
		local off = 0
		if (gametype == GT_SRBZ)
			off = 10
			off = $+#SRBZ:GetActiveTimers()*20
		end
		v.drawString(160, 0+off, TAKIS_INVITELINK2,V_SNAPTOTOP|V_ALLOWLOWERCASE|V_30TRANS, "thin-center")
		v.drawString(160, 8+off, TAKIS_INVITELINK,V_SNAPTOTOP|V_ALLOWLOWERCASE|V_30TRANS, "thin-center")
	end
end)

COM_AddCommand("displayInvite", function(p)
	if p.valid
		if p.discord
			p.discord = false
		else
			p.discord = true
		end
	end
end, COM_ADMIN)

COM_AddCommand("setinvite", function(p,link)
	if not p.valid
		return
	end
	
	if (link == nil)
		CONS_Printf(p,'Put your Discord invite link after the command. Put "" to hide the text.')
		CONS_Printf(p,'Current text is...')
		CONS_Printf(p,TAKIS_INVITELINK)
		return
	end
	
	TAKIS_INVITELINK = tostring(link)
	
end, COM_ADMIN)

addHook("NetVars",function(n)
	TAKIS_INVITELINK = n($)
end)

filesdone = $+1
