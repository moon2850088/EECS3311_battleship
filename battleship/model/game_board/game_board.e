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

feature{ETF_MODEL}

	board : ARRAY2[ELEMENT]

--	array_ships : ARRAY[INTEGER_64]

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
			score := zero.as_integer_64
			total_score := zero.as_integer_64
			own_score := zero.as_integer_64
			cur_game := zero.as_integer_64
			ships := zero.as_integer_64
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
						if remain_targer_ship(board[coordinate.row.as_integer_32, coordinate.col.as_integer_32].ship_id.as_integer_32) ~ 0 then
							ships := ships + 1
							score := score + board[coordinate.row.as_integer_32, coordinate.col.as_integer_32].ship_id
							own_score := own_score + board[coordinate.row.as_integer_32, coordinate.col.as_integer_32].ship_id

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
						if remain_targer_ship(board[coordinate1.row.as_integer_32, coordinate1.col.as_integer_32].ship_id) ~ 0 then
							ships := ships + 1
							score := score + board[coordinate1.row.as_integer_32, coordinate1.col.as_integer_32].ship_id
							own_score := own_score + board[coordinate1.row.as_integer_32, coordinate1.col.as_integer_32].ship_id

						end
					end
					if (coordinate2 ~ board[w.item, h.item].get_coordinate) then
						board[w.item, h.item].set_hit
						if remain_targer_ship(board[coordinate2.row.as_integer_32, coordinate2.col.as_integer_32].ship_id) ~ 0 then
							ships := ships + 1
							score := score + board[coordinate2.row.as_integer_32, coordinate2.col.as_integer_32].ship_id
							own_score := own_score + board[coordinate2.row.as_integer_32, coordinate2.col.as_integer_32].ship_id

						end
					end
				end
			end
			bomb := bomb + 1
		end

feature

	get_current_level: LEVEL
		do
			Result := level

		end

	get_cur_board : ARRAY2[ELEMENT]
		do
			Result := board
		end

	check_coordinate_adjacent(coord1: TUPLE[row: INTEGER_64; column: INTEGER_64]; coord2: TUPLE[row: INTEGER_64; column: INTEGER_64]): BOOLEAN
		local
			r:INTEGER_64
			l:INTEGER_64
		do
			r := coord1.row - coord2.row
			l := coord1.column - coord2.column
			if ((r ~ 0) and (l.abs ~ 1)) or ((l ~ 0) and (r.abs ~ 1)) then
				Result := true
			else
				Result := false

			end
		end

	score_in_board : INTEGER

		do
			Result := 0
			across 1|..| board.width as w loop
				across 1|..| board.height as h loop
					if  board[w.item, h.item].has_ship  then
						Result := Result + 1
					end
				end
			end

		end
	remain_score_in_board : INTEGER
		do
			Result := 0
			across 1|..| board.width as w loop
						across 1|..| board.height as h loop
							if  board[w.item, h.item].has_ship and (board[w.item, h.item].is_hit ~ false) then
								Result := Result + 1
							end
						end
					end

		end

	remain_targer_ship(id : INTEGER) : INTEGER
		do
			Result := 0
			across 1|..| board.width as w loop
				across 1|..| board.height as h loop
					if  board[w.item, h.item].ship_id ~ id and (board[w.item, h.item].is_hit ~ false) then
						Result := Result + 1
					end
				end
			end
		end

	coordinate_and_statement(id: INTEGER) : STRING
		local
			size:INTEGER
		do
			Result := ""
			size := 0
			across 1|..| board.width as w loop
				across 1|..| board.height as h loop
					if  board[w.item, h.item].ship_id ~ id then
						if board[w.item, h.item].is_hit then
							Result.append("[" + row_indices[w.item].out + ", " + h.item.out + "]->X")
							size := size + 1
						else
							Result.append("[" + row_indices[w.item].out + ", " + h.item.out + "]->" + board[w.item, h.item].ship_dir)
							size := size + 1
						end
					if size < id then
						Result.append (";")

					end

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
