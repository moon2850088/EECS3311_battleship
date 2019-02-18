note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_FIRE
inherit
	ETF_FIRE_INTERFACE
		redefine fire end
create
	make
feature -- command
	fire(coordinate: TUPLE[row: INTEGER_64; column: INTEGER_64])
		require else
			fire_precond(coordinate)
    	do
			-- perform some update on the model state
			model.default_update
			if  not model.started then
				model.msg.set_error_message("Game not started")
				model.msg.set_game_state ("Start a new game")
			elseif model.game.get_current_level.shots ~ model.game.shots then
				model.msg.set_error_message("No shots remaining")
				model.msg.set_game_state ("Keep Firing!")
			else	if (coordinate.row > model.game.get_current_level.g_size or coordinate.row < 0) or ( coordinate.column > model.game.get_current_level.g_size or coordinate.column < 0) then
				model.msg.set_error_message("Invalid coordinate")
				model.msg.set_game_state ("Keep Firing!")
			elseif model.game.get_cur_board[coordinate.row.as_integer_32,coordinate.column.as_integer_32].is_hit then
				model.msg.set_error_message("Already fired there")
				model.msg.set_game_state ("Keep Firing!")
			else
				model.game.fire_on_board (coordinate)
			end

			if model.game.remain_targer_ship (model.game.get_cur_board[coordinate.row.as_integer_32,coordinate.column.as_integer_32].ship_id) ~ 0 then
				if model.game_finish and model.won then
					model.msg.set_game_state(model.game.get_cur_board[coordinate.row.as_integer_32,coordinate.column.as_integer_32].ship_id.out + "x1 ship sunk! You Win!")
				elseif model.game_finish and model.lose  then
					model.msg.set_game_state(model.game.get_cur_board[coordinate.row.as_integer_32,coordinate.column.as_integer_32].ship_id.out + "x1 ship sunk! Game Over!")
				else
					model.msg.set_game_state(model.game.get_cur_board[coordinate.row.as_integer_32,coordinate.column.as_integer_32].ship_id.out + "x1 ship sunk! Keep Firing")
				end

			elseif model.game.get_cur_board[coordinate.row.as_integer_32,coordinate.column.as_integer_32].check_has_ship then
				if model.game_finish then
					model.msg.set_game_state ("Hit! Game Over")
				else
					model.msg.set_game_state("Hit! Keep Firing!")
				end

			else
				if model.game_finish then
					model.msg.set_game_state("Miss! Game Over")
				else
					model.msg.set_game_state("Miss! Keep Firing")
				end
			end

			etf_cmd_container.on_change.notify ([Current])
    	end
    end
end
