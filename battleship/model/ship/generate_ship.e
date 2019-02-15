note
	description: "Summary description for {GENERATE_SHIP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GENERATE_SHIP


feature ---- random generators

	rand_gen: RANDOM_GENERATOR

		attribute

			create result.make_random
		end

	debug_gen: RANDOM_GENERATOR

		attribute
			create result.make_debug
		end

feature -- utilities

	generator_ships (is_debug_mode: BOOLEAN; board_size: INTEGER; num_ships: INTEGER): ARRAYED_LIST[TUPLE[size: INTEGER; row: INTEGER; col: INTEGER; dir: BOOLEAN]]
			-- places the ships on the board
			-- either deterministicly random or completely random depending on debug mode
		local
			size: INTEGER
			c,r : INTEGER
			d: BOOLEAN
			gen: RANDOM_GENERATOR
			new_ship: TUPLE[size: INTEGER; row: INTEGER; col: INTEGER; dir: BOOLEAN]
		do
			create Result.make (num_ships)
			if is_debug_mode then
				gen := debug_gen
			else
				gen := rand_gen
			end
			from
				size := num_ships
			until
				size = 0
			loop
				d := (gen.direction \\ 2 = 1)
				if d then
					c := (gen.column \\ board_size) + 1
					r := (gen.row \\ (board_size - size)) + 1
				else
					r := (gen.row \\ board_size) + 1
					c := (gen.column \\ (board_size - size)) + 1
				end

				new_ship := [size, r, c, d]

				if not collide_with (Result, new_ship) then
					-- If the generated ship does not collide with
					-- ones that have been generated, then
					-- add it to the set.
					Result.extend (new_ship)
					size := size - 1
				end
				gen.forth
				
			end
		ensure
			-- not sure how to best check this
		end

	collide_with_each_other (ship1, ship2: TUPLE[size: INTEGER; row: INTEGER; col: INTEGER; dir: BOOLEAN]): BOOLEAN
				-- Does `ship1' collide with `ship2'?
			local
				ship1_head_row, ship1_head_col, ship1_tail_row, ship1_tail_col: INTEGER
				ship2_head_row, ship2_head_col, ship2_tail_row, ship2_tail_col: INTEGER
			do
					ship1_tail_row := ship1.row
					ship1_tail_col := ship1.col
					if ship1.dir then
						ship1_tail_row := ship1_tail_row + 1
						ship1_head_row := ship1_tail_row + ship1.size - 1
						ship1_head_col := ship1_tail_col
					else
						ship1_tail_col := ship1_tail_col + 1
						ship1_head_col := ship1_tail_col + ship1.size - 1
						ship1_head_row := ship1_tail_row
					end

					ship2_tail_row := ship2.row
					ship2_tail_col := ship2.col
					if ship2.dir then
						ship2_tail_row := ship2_tail_row + 1
						ship2_head_row := ship2_tail_row + ship2.size - 1
						ship2_head_col := ship2_tail_col
					else
						ship2_tail_col := ship2_tail_col + 1
						ship2_head_col := ship2_tail_col + ship2.size - 1
						ship2_head_row := ship2_tail_row
					end

					Result :=
						ship1_tail_col <= ship2_head_col and then
 						ship1_head_col >= ship2_tail_col and then
 						ship1_tail_row <= ship2_head_row and then
 						ship1_head_row >= ship2_tail_row
			end

	collide_with (existing_ships: ARRAYED_LIST[TUPLE[size: INTEGER; row: INTEGER; col: INTEGER; dir: BOOLEAN]];
		new_ship: TUPLE[size: INTEGER; row: INTEGER; col: INTEGER; dir: BOOLEAN]): BOOLEAN
				-- Does `new_ship' collide with the set of `existing_ships'?
			do
					across
						existing_ships as existing_ship
					loop
						Result := Result or collide_with_each_other (new_ship, existing_ship.item)
					end
			ensure
				Result =
					across existing_ships as existing_ship
					some
						collide_with_each_other (new_ship, existing_ship.item)
					end
			end

end
