COM_AddCommand("takis_setmaxhp",function(p,amt)
	if gamestate ~= GS_LEVEL
		CONS_Printf(p,"You can't use this right now.")
	end

	amt = abs(tonumber(amt))

	if (amt == nil)
		CONS_Printf(p,"Type number lel")
		return
	else
		if amt == 0
			CONS_Printf(p,"You do this you die")
			return
		end
		TAKIS_MAX_HEARTCARDS = amt
	end
end,COM_ADMIN)