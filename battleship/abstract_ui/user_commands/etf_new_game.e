note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_NEW_GAME
inherit
	ETF_NEW_GAME_INTERFACE
		redefine new_game end
create
	make
feature -- command
	new_game(level: INTEGER_64)
		require else
			new_game_precond(level)
    	do
			-- perform some update on the model state
		if model.started then
					model.msg.set_error_message ("Game already started")
					model.msg.set_game_state ("Fire Away!")
					model.default_update
				else
					model.msg.set_error_message("OK")
					model.msg.set_game_state ("Fire Away!")
					model.default_update
					model.set_game_started(true)
					model.start_new_game (level)
				end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
