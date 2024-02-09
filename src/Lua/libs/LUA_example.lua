/* Hi, CobaltBW here.
This is a tutorial action script that will teach you how to create a character's special moves for use with BattleMod.
To help explain the process, I'll be adding multiple comments detailing how everything works and what we need to do to make our script work properly.

A quick overview of what you'll need:
	local variable at the top level
	A ThinkFrame hook
	"if CBW_Battle" check
	A function for your action script, stored locally or globally
	A character that will use the function, defined via CBW_Battle.SkinVars[<yourskinname>]

You may also want to enable 'battledebug 10' in the console as your are testing your character's abilities.
This will display battle- and action-related variables in real time to help you troubleshoot any issues you may come across along the way.


Let's begin! */



--First it's important that we keep track of whether BattleMod has been loaded so that we can tell the game when to create our function.
--To do this, we're going to start off by creating a local variable.
local ScriptLoaded = false

--Now let's encase the rest of our code inside of ThinkFrame...
addHook("ThinkFrame", function()
	--... so that we can check each frame to see if the script has been loaded yet.
	if not(ScriptLoaded)
		and CBW_Battle --CBW_Battle is the master table for all of BattleMod's functions. Attempting to run our scripts without Battle loaded will result in a lua error, so we have to check before trying to run the rest of the code.
		then
		ScriptLoaded = true --Flip this to true so that we don't try to run this code more than once.
		local B = CBW_Battle --Just for convenience, we're going to truncate this table; it'll make writing functions a little less cumbersome.
				
		--Now let's create our action.
		local RingBarrage = function(mo,doaction)
			/* Notes on action functions
			Action functions follow the format of (mo,doaction).
			mo is the player object that is performing the action.
			doaction is the state of whether the player is attempting to perform an action or not, depending on current key inputs.
				0 = no button pressed
				1 = button has been pressed and action can be performed
				2 = button is being held down and action can be performed
				-1 = Player is attempting to perform an action, but can't because of one of the following conditions:
					- The player is exiting the level
					- The player's action is on cooldown
					- The player character is in pain
					- The player's controls have been disabled
					- The player is "not it" in tag mode
					- The player has the flag in CTF or the crystal in Diamond in the Rough
			*/
			local player = mo.player
			
			--Now for some definitions:
			player.actiontext = "Ring Barrage" --This is the HUD text that appears next to the red ring icon.
			player.actionrings = 10 --This is the amount of rings your action costs, and will also display in the HUD if set above 0.
			player.action2text = nil --If a string is defined, this will display below the first string, next to the flag icon.
			player.action2rings = 0 --"ring amount" displayed next to action2text, if applicable. Unused by default, but still available as a HUD item.
			--Note that these variables are reset on every frame to nil or 0.
			
			if not(B.CanDoAction(player)) --CBW_Battle.CanDoAction will return true/false whether actions are "allowed" based on certain external conditions.
			--Note that this function is not as comprehensive as the conditions checked for doaction, so you will still need to check doaction to make sure the player's action isn't, say, on cooldown, before spending rings on an action.
				player.actionstate = 0 --Default action state
				return end	
	
			--Let's define behavior for the action's neutral state
			if player.actionstate == 0 --actionstate can be used to determine the phase of a character's attack.
				--In this case, we're checking for 0 because it is every character's "neutral" state. (Any time actionstate is higher than 0, the HUD action text will be highlighted yellow.)			
				--At this point we're going to see if the player is pushing buttons
				if doaction == 1 --Action key was pressed and we can perform an action
					player.actionstate = 1 --This moves us onto the next actionstate
					player.actiontime = 0 --This can be used to keep track of time in a certain state. Unlike its name suggests, this variable does NOT automatically tic up or down, so you will have to add or subtract from this variable manually if you want it to operate like a timer.
					B.PayRings(player) --Spend actionring amount and plays the anti-ring sfx.
					S_StartSound(mo,sfx_s3k3c)
					
				end
			end
			
			if player.actionstate == 1 --This state will serve as our startup lag
				player.actiontime = $+1 --Tic this upwards to keep track of how long we've been in this state.
				
				--Halt our momentum
				P_InstaThrust(mo,mo.angle,0)
				P_SetObjectMomZ(mo,P_MobjFlip(mo)*mo.scale,0)
				--Make us spin
				player.pflags = ($|PF_SPINNING)&~PF_JUMPED
				mo.state = S_PLAY_ROLL
				P_SpawnThokMobj(player) --Just a little aesthetics
				
				if player.actiontime == 20 then --Set time till next state
					player.actionstate = 2
					player.actiontime = 0
				end
			end
			
			if player.actionstate == 2 --In this state our character is currently performing their action.
				player.actiontime = $+1
				--Creating our projectile stream
				if player.actiontime%3==0 --This condition will return true once every four tics
					P_SPMAngle(mo,MT_REDRING,mo.angle,0)
				end
				
				--Do some recoil
				P_SetObjectMomZ(mo,P_MobjFlip(mo)*mo.scale*2,0)
				P_InstaThrust(mo,mo.angle+ANGLE_180,mo.scale*6)
				B.ApplyCooldown(player,TICRATE*2) --Waittime before player can use this action again. If the player used this action without any rings on-hand, the waittime is doubled.
				mo.state = S_PLAY_FALL
				player.pflags = $&~(PF_SPINNING)
				player.drawangle = mo.angle
				
				--Reset player state
				if player.actiontime == 20
					player.actionstate = 0
				end
			end
			
		end --End of action function.
		
		-- Let's say we want our character to be more resistant to attacks while his move is being used.
		local PriorityFunc = function(player)
			if player.actionstate == 1 then
				B.SetPriority(player,1,3,nil,1,3,"midair charge spin")
				/* Arguments
					1: Player properties to modify
					2: Attack priority. Higher priorities will pierce through stronger enemy defense.
					3: Defense priority. Higher priorities will resist enemy attacks.
					4: "Special" priority condition. If returns true, uses arguments 5 & 6 to determine attack/defense priority for this frame.
						Functions used must first be stored via CBW_Battle.AddPriorityFunction(stringname,function)
						Argument #4 must then refer to the given "stringname" from AddPriorityFunction(). Do not use the priority function itself as argument #4!
					5: Special attack, if argument 4's function returns true.
					6: Special defense, if argument 4's function returns true.
					7: Attack text to display in the console when an opponent takes damage from a player-to-player collision
						(i.e. "Sonic's midair charge spin hit Knuckles"
				*/
				-- In this instance, the player will have an attack priority of 1 and a defense priority of 3 so long as his actionstate is 1.
			end
		end
		
		--Exhaust functions can be used to limit the duration of certain actions that would cause degenerate play in Battle without changing the experience unless Battle is loaded.
		--For this example, we'll limit sonic's spindash charge to 5 seconds.
		--Battle will automatically handle the exhaustion sfx and color blinking, so all you need to do is decrement the player.exhaustmeter value from FRACUNIT to 0.
		--	~Krabs
		local ExhaustFunc = function(player)
			if player.pflags & PF_STARTDASH
				local maxtime = 5*TICRATE
				player.exhaustmeter = max(0,$-FRACUNIT/maxtime)
				if player.exhaustmeter <= 0
					player.pflags = $ & ~(PF_STARTDASH|PF_SPINNING)
					player.mo.state = S_PLAY_STND
				end
				return true--Returning true will prevent the exhaustion meter from refilling on floor touch - useful for this example, since it's on the floor already
			end
			return false
		end
		
		--Collide functions allow for special behaviors on player collision
		--For this example, we'll make sonic's roll state play a sound effect and bypass the standard collision physics if it clashes with an enemy without dealing damage.
		--The collision code is not exactly a cakewalk to work with, but another example of its use can be found in Fang's combat roll script (Lua\3-Functions\3-Player\Special Moves\Lib_ActCombatRoll.lua).
		--That combatroll script also contains an example of precollide and postcollide's usefulness.
		--	~Krabs
		
		local CollideFunc = function(n1,n2,plr,mo,atk,def,weight,hurt,pain,ground,angle,thrust,thrust2,collisiontype)
			--There's a lot of arguments here, apologies...
			
			--n1: id number of player 1
			--n2: id number of player 2
			--plr: stores players in plr[n1] and plr[n2]
			--mo: stores mobjs in mo[n1] and mo[n2]
			--atk: stores atk values in atk[n1] and atk[n2]
			--def: stores def values in def[n1] and def[n2]
			--weight: stores weight values in weight[n1] and weight[n2]
			--hurt: stores a number that shows who was hurt by the collision
				-- 0: nobody was hurt
				-- 1: t was hurt by s
				---1: s was hurt by t
				-- 2: both hurt
			--pain: stores booleans that are true if the player is in pain in pain[n1] and pain[n2]
			--ground: stores booleans that are true if the player is touching solid ground in ground[n1] and ground[n2]
			--angle: stores collision angle in angle[n1] and angle[n2]
			--thrust: stores collision thrust in thrust[n1] and thrust[n2]
			--thrust2: stores collision thrust2 in thrust2[n1] and thrust2[n2]
			--collisiontype: stores collisiontype
				-- 0 = No interaction
				-- 1 = Bump
				-- 3 = Full damage code
			
			if not (plr[n1] and plr[n1].valid and plr[n1].playerstate == PST_LIVE)
				or not mo[n1].health
				or not mo[n1].state == S_PLAY_ROLL
				or pain[n1]
				return false
			end
			if (hurt != 1 and n1 == 1) or (hurt != -1 and n1 == 2) --Make sure the other player wasn't damaged
				S_StartSound(mo[n1], sfx_lose)
				return true
			end
		end
		
		--Let's now assign these functions to the character:
		CBW_Battle.SkinVars["sonic"] = {
			special = RingBarrage,
			func_priority_ext = PriorityFunc,
			func_exhaust = ExhaustFunc,
			func_collide = CollideFunc
		}

		/* All of the vanilla six character's specials can also be assigned to custom characters too. The functions for them are as follows:
			Sonic: CBW_Battle.Action.SuperSpinJump
			Tails: CBW_Battle.Action.RoboMissile
			Knuckles: CBW_Battle.Action.Dig
			Amy: CBW_Battle.Action.PikoSpin
			Fang: CBW_Battle.Action.BombThrow
			Metal Sonic: CBW_Battle.Action.EnergyAttack
		*/
	end
end)