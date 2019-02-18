note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_DEBUG_TEST
inherit
	ETF_DEBUG_TEST_INTERFACE
		redefine debug_test end
create
	make
feature -- command
	debug_test(level: INTEGER_64)
		require else
			debug_test_precond(level)
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
				model.start_debug_test (level)
			end


			etf_cmd_container.on_change.notify ([Current])
    	end

end
