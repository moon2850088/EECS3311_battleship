note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_BOMB
inherit
	ETF_BOMB_INTERFACE
		redefine bomb end
create
	make
feature -- command
	bomb(coordinate1: TUPLE[row: INTEGER_64; column: INTEGER_64] ; coordinate2: TUPLE[row: INTEGER_64; column: INTEGER_64])
		require else
			bomb_precond(coordinate1, coordinate2)
    	do
			-- perform some update on the model state
			model.default_update
			if not model.started then
				model.msg.set_error_message("Game not started")
				model.msg.set_game_state ("Start a new game")
			elseif model.game.get_current_level.bombs ~ model.game.bomb then
				model.msg.set_error_message("No bombs remaining")
				model.msg.set_game_state ("Keep Firing!")
			elseif not model.game.check_coordinate_adjacent (coordinate1, coordinate2) then
				model.msg.set_error_message("Bomb coordinates must be adjacent")
				model.msg.set_game_state ("Keep Firing!")
			else	if (coordinate1.row > model.game.get_current_level.g_size or coordinate1.row < 0) or ( coordinate1.column > model.game.get_current_level.g_size or coordinate1.column < 0)
					or (coordinate2.row > model.game.get_current_level.g_size or coordinate2.row < 0) or ( coordinate2.column > model.game.get_current_level.g_size or coordinate2.column < 0)then
				model.msg.set_error_message("Invalid coordinate")
				model.msg.set_game_state ("Keep Firing!")
			else	if model.game.get_cur_board[coordinate1.row.as_integer_32,coordinate1.column.as_integer_32].is_hit
					or model.game.get_cur_board[coordinate2.row.as_integer_32,coordinate2.column.as_integer_32].is_hit then
				model.msg.set_error_message("Already fired there")
				model.msg.set_game_state ("Keep Firing!")
			else
				model.game.bomb_on_board (coordinate1, coordinate2)

				if (model.game.remain_targer_ship (model.game.get_cur_board[coordinate1.row.as_integer_32,coordinate1.column.as_integer_32].ship_id) ~ 0)
				and (model.game.remain_targer_ship (model.game.get_cur_board[coordinate2.row.as_integer_32,coordinate2.column.as_integer_32].ship_id) ~ 0)
					then
				model.msg.set_error_message("OK")
						if (model.game.remain_targer_ship (model.game.get_cur_board[coordinate1.row.as_integer_32,coordinate1.column.as_integer_32].ship_id) ~
						model.game.remain_targer_ship (model.game.get_cur_board[coordinate2.row.as_integer_32,coordinate2.column.as_integer_32].ship_id))
						then
							if model.game_finish and model.won then
								model.msg.set_game_state(model.game.get_cur_board[coordinate1.row.as_integer_32,coordinate1.column.as_integer_32].ship_id.out + "x1 ship sunk! You Win!")
							elseif model.game_finish and model.lose  then
								model.msg.set_game_state(model.game.get_cur_board[coordinate1.row.as_integer_32,coordinate1.column.as_integer_32].ship_id.out + "x1 ship sunk! Game Over!")
							else
								model.msg.set_game_state(model.game.get_cur_board[coordinate1.row.as_integer_32,coordinate1.column.as_integer_32].ship_id.out + "x1 ship sunk! Keep Firing!")
							end
						else
							if model.game_finish and model.won then
								model.msg.set_game_state(model.game.get_cur_board[coordinate1.row.as_integer_32,coordinate1.column.as_integer_32].ship_id.out + "x1 and " +
								model.game.get_cur_board[coordinate2.row.as_integer_32,coordinate2.column.as_integer_32].ship_id.out + "x1 ship sunk! You Win!")
							elseif model.game_finish and model.lose  then
								model.msg.set_game_state(model.game.get_cur_board[coordinate1.row.as_integer_32,coordinate1.column.as_integer_32].ship_id.out + "x1 and " +
								model.game.get_cur_board[coordinate2.row.as_integer_32,coordinate2.column.as_integer_32].ship_id.out + "x1 ship sunk! Game Over!")
							else
								model.msg.set_game_state(model.game.get_cur_board[coordinate1.row.as_integer_32,coordinate1.column.as_integer_32].ship_id.out + "x1 and " +
								model.game.get_cur_board[coordinate2.row.as_integer_32,coordinate2.column.as_integer_32].ship_id.out + "x1 ship sunk! Keep Firing!")
							end
						end
				elseif model.game.remain_targer_ship (model.game.get_cur_board[coordinate1.row.as_integer_32,coordinate1.column.as_integer_32].ship_id) ~ 0 then
					model.msg.set_error_message("OK")
						if model.game_finish and model.won then
							model.msg.set_game_state(model.game.get_cur_board[coordinate1.row.as_integer_32,coordinate1.column.as_integer_32].ship_id.out + "x1 ship sunk! You Win!")
						elseif model.game_finish and model.lose  then
							model.msg.set_game_state(model.game.get_cur_board[coordinate1.row.as_integer_32,coordinate1.column.as_integer_32].ship_id.out + "x1 ship sunk! Game Over!")
						else
							model.msg.set_game_state(model.game.get_cur_board[coordinate1.row.as_integer_32,coordinate1.column.as_integer_32].ship_id.out + "x1 ship sunk! Keep Firing!")
						end
				elseif model.game.remain_targer_ship (model.game.get_cur_board[coordinate2.row.as_integer_32,coordinate2.column.as_integer_32].ship_id) ~ 0 then
					model.msg.set_error_message("OK")
						if model.game_finish and model.won then
							model.msg.set_game_state(model.game.get_cur_board[coordinate2.row.as_integer_32,coordinate2.column.as_integer_32].ship_id.out + "x1 ship sunk! You Win!")
						elseif model.game_finish and model.lose  then
							model.msg.set_game_state(model.game.get_cur_board[coordinate2.row.as_integer_32,coordinate2.column.as_integer_32].ship_id.out + "x1 ship sunk! Game Over!")
						else
							model.msg.set_game_state(model.game.get_cur_board[coordinate2.row.as_integer_32,coordinate2.column.as_integer_32].ship_id.out + "x1 ship sunk! Keep Firing!")
						end
				elseif model.game.get_cur_board[coordinate1.row.as_integer_32,coordinate1.column.as_integer_32].check_has_ship
					or model.game.get_cur_board[coordinate2.row.as_integer_32,coordinate2.column.as_integer_32].check_has_ship then
					model.msg.set_error_message("OK")
						if model.game_finish then
							model.msg.set_game_state ("Hit! Game Over")
						else
							model.msg.set_game_state("Hit! Keep Firing!")
						end
				else
						if model.game_finish then
							model.msg.set_game_state("Miss! Game Over")
						else
							model.msg.set_game_state("Miss! Keep Firing!")
						end
				end
			end



			etf_cmd_container.on_change.notify ([Current])
    	end
    end
end
end
