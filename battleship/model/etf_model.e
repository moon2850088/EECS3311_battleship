note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MODEL

inherit
	ANY
		redefine
			out
		end

create {ETF_MODEL_ACCESS}
	make

feature {NONE} -- Initialization
	make
			-- Initialization for `Current'.
		do
			create s.make_empty
			create {NEW_GAME}game.make
			i := 0
			started := false

		end

feature -- model attributes
	s : STRING
	i : INTEGER
	started: BOOLEAN

	game: GAME_BOARD

feature -- model operations
	default_update
			-- Perform update to the model state.
		do
			i := i + 1
		end

	reset
			-- Reset model state.
		do
			make
		end
feature

	set_game_started
		do
			started := true
		end
feature
	start_new_game (l : INTEGER_64)
		do
			if attached {DEBUG_GAME}game as d then
				create {NEW_GAME}game.make
				game.change_level (l)
			else
				game.change_level (l)
			end
		end

	start_debug_test(l :INTEGER_64)
		do
			if attached {NEW_GAME}game as n then
				create {DEBUG_GAME}game.make
				game.change_level (l)
			else
				game.change_level (l)

			end
		end

--	start_debug_test(l : level)

feature -- queries
	out : STRING
		do
			create Result.make_from_string ("  state " + i.out)
--			Result.append ("System State: default model state ")
--			Result.append ("(")
--			Result.append (i.out)
--			Result.append (")")
--			Result.append (.out)
			if started then
			Result.append (game.out)
			end
		end

end




