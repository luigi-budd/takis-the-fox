assert(TAKIS_INVITELINK,"\x85This must be loaded after Takis.\80")

COM_AddCommand("setinvite", function(p,link)
	if not p.valid
		return
	end
	
	if (link == nil)
		CONS_Printf(p,"Put your Discord invite link after the command")
		return
	end
	
	TAKIS_INVITELINK = tostring(link)
	
end, COM_ADMIN)