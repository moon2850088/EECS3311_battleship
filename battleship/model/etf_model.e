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
			create msg.make
			i := 0
			started := false
			won := false
			lose := false
		end

feature -- model attributes
	s : STRING
	i : INTEGER
	started: BOOLEAN
	won: BOOLEAN
	lose : BOOLEAN
	msg : MESSAGE
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

	set_game_started( s_f: BOOLEAN)
		do
			started := s_f
		end

	set_game_won(w: BOOLEAN)
		do
			won := w
		end
	set_game_lose(l: BOOLEAN)
		do
			lose := l
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
	game_finish : BOOLEAN
		do
			if ((game.bomb ~ game.get_current_level.bombs) and (game.shots ~ game.get_current_level.shots)) then
				if (game.remain_score_in_board ~ 0) then
					set_game_won(true)
				else
					set_game_lose(true)
				end
				set_game_started(false)
				Result := true
			else
				if (game.remain_score_in_board ~ 0) then
					set_game_won(true)
					set_game_started(false)
					Result := true
				end
				Result := false
			end
		end

--	start_debug_test(l : level)

feature -- queries
	out : STRING
		do
			create Result.make_from_string ("  state " + i.out + " " + msg.out)
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
