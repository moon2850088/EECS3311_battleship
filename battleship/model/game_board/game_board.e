note
	description: "Summary description for {GAME_BOARD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	GAME_BOARD

inherit
	ANY
		undefine out end

feature

	board : ARRAY2[ELEMENT]

	ships_in_game: ARRAY[TUPLE[size: INTEGER; row: INTEGER; col: INTEGER; dir: BOOLEAN]]

	new_ship : GENERATE_SHIP

	row_indices :ARRAY[CHARACTER]
		once
			Result := <<'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L'>>
		end
	game_level :ARRAY[INTEGER_64]
		once
			Result := <<13, 14, 15, 16>> -- easy:13  medium:14 hard:15 advanced: 16
		end
	level : LEVEL
feature --game information
	shots, bomb, score, ships, total_score, cur_game , own_score: INTEGER_64


feature{NONE}
	make
		local
			zero: INTEGER
		do
			zero := 0
			create level.make (13)
			create board.make_filled (create {ELEMENT}.make([zero.to_integer_64,zero.to_integer_64]), level.g_size, level.g_size)
			create new_ship
			create ships_in_game.make_empty
			score := zero.as_integer_64
			total_score := zero.as_integer_64
			own_score := zero.as_integer_64
			cur_game := zero.as_integer_64
			initial_record

		end

	clear_board
		local
			zero: INTEGER
		do
			zero := 0
			create board.make_filled (create {ELEMENT}.make ([zero.as_integer_64,zero.as_integer_64]), level.g_size, level.g_size)
			across 1|..| board.height as i loop
				across 1|..| board.width as j loop
					board[i.item, j.item] := create {ELEMENT}.make ([i.item.to_integer_64, j.item.to_integer_64])
					end
				end
		end

	initial_record
		local
			zero : INTEGER
		do
			zero := 0
			shots := zero.as_integer_64 bomb := zero.as_integer_64 ships := zero.as_integer_64 score := zero.as_integer_64
		end

feature
	change_level(l: INTEGER_64)
		do
			create level.make (l)
			own_score := own_score + score
			initial_record
			clear_board
			place_new_ships
			total_score := total_score + score_in_board.as_integer_64
			cur_game := cur_game + 1

		end

feature --- attack

	fire_on_board(coordinate: TUPLE[row: INTEGER_64; col: INTEGER_64])
		do
			across 1|..| board.width as w loop
				across 1|..| board.height as h loop
					if (coordinate ~ board[w.item, h.item].get_coordinate) then
						board[w.item, h.item].set_hit
						shots := shots + 1
						if board[w.item,h.item].has_ship then
						score := score + 1
						end
					end
				end
			end
		end

	bomb_on_board(coordinate1: TUPLE[row: INTEGER_64; col: INTEGER_64] ;coordinate2: TUPLE[row: INTEGER_64; col: INTEGER_64])
		do
			across 1|..| board.width as w loop
				across 1|..| board.height as h loop
					if (coordinate1 ~ board[w.item, h.item].get_coordinate) then
						board[w.item, h.item].set_hit
						if board[w.item, h.item].has_ship then
							score := score + 1
						end
					end
					if (coordinate2 ~ board[w.item, h.item].get_coordinate) then
						board[w.item, h.item].set_hit
						if board[w.item,h.item].has_ship then
							score := score + 1
						end
					end
				end
			end
			bomb := bomb + 1

		end
feature
	score_in_board : INTEGER

		do
			across 1|..| board.width as w loop
				across 1|..| board.height as h loop
					if  board[w.item, h.item].has_ship  then
						Result := Result + 1
					end
				end
			end

		end


feature
	place_new_ships
--		require
--			across new_ship.lower |..| new_ship.upper as i all
--			across new_ship.lower |..| new_ship.upper as j all
--				i.item /= j.item implies not new_ship.collide_with_each_other (new_ships[i.item], new_ships[j.item])
--			end
--			end
		deferred
		end


end
