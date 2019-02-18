note
	description: "Summary description for {DEBUG_GAME}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DEBUG_GAME

inherit
	GAME_BOARD

create
	make


feature

	place_new_ships
		local
			e: ELEMENT
		do
			across new_ship.generator_ships (True, level.g_size, level.n_ships.as_integer_32) as ship loop
				if ship.item.dir then
					across 1 |..| ship.item.size as i loop		-- vertical
						create e.make ([(ship.item.row + i.item).to_integer_64, ship.item.col.to_integer_64])
						e.game_to_debug
						e.set_ship_dir ("v")
						e.set_ship_id (ship.item.size)
						board[ship.item.row + i.item, ship.item.col] := e
					end
				else
					across 1 |..| ship.item.size as i loop		-- horizontal
						create e.make ([ship.item.row.to_integer_64, (ship.item.col + i.item).to_integer_64])
						e.game_to_debug
						e.set_ship_dir ("h")
						e.set_ship_id (ship.item.size)
						board[ship.item.row, ship.item.col + i.item] := e
					end
				end

			end
		end


feature


feature
	out: STRING
			-- Return string representation of current game.
			-- You may reuse this routine.
		local
			fi: FORMAT_INTEGER
			n_ships: INTEGER
		do
			create fi.make (2)
			create Result.make_from_string ("%N   ")
			across 1 |..| board.width as i loop Result.append(" " + fi.formatted (i.item)) end
			across 1 |..| board.width as i loop
				Result.append("%N  "+ row_indices[i.item].out)
				across 1 |..| board.height as j loop
					Result.append ("  " + board[i.item,j.item].out)
				end
			end
			Result.append ("%N "+ "Current Game (debug): " + cur_game.out)
			Result.append ("%N "+ "Shots: " + shots.out +"/"+ level.shots.out )
			Result.append ("%N "+ "Bombs: " + bomb.out + "/" + level.bombs.out)
			Result.append ("%N "+ "Score: " + score.out + "/" + score_in_board.out + " (Total: " + own_score.out + "/" + total_score.out + ")" )
			Result.append ("%N "+ "Ships: " + ships.out + "/" + level.n_ships.out)
			from
				n_ships := level.n_ships.as_integer_32
			until
				n_ships = 0
			loop
				Result.append("%N  " + n_ships.out + "x1: " + coordinate_and_statement(n_ships))
				n_ships := n_ships - 1
					end
		end



end
