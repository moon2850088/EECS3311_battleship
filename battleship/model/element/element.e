note
	description: "Summary description for {ELEMENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ELEMENT

inherit
	ANY redefine out end

create
	make

feature -- attribute

	is_hit : BOOLEAN
	has_ship : BOOLEAN
	debug_mode : BOOLEAN
	ship_id : INTEGER
	ship_dir : STRING
	coordinate : TUPLE[x: INTEGER_64; y: INTEGER_64]

feature
	make(coord : TUPLE[x: INTEGER_64; y: INTEGER_64])
		do
			is_hit := false
			has_ship := false
			debug_mode := false
			ship_id := 0
			ship_dir := "v"
			coordinate := coord
		end
feature --- command

	set_hit
		do
			is_hit := true
		end
	set_ship_dir(d : STRING)
		require
			correct_input: (d ~ "v") or (d ~ "h")
		do
			ship_dir := d
			has_ship := true
		end

	set_ship_id(id: INTEGER)
		do
			ship_id := id
		end
	debug_to_game
		do
			debug_mode := false
		end
	game_to_debug
		do
			debug_mode := true
		end
feature ---query

	check_has_ship :BOOLEAN
		do
			Result := has_ship
		end

	check_is_hit : BOOLEAN
		do
			Result := is_hit
		end
	get_coordinate : TUPLE[x: INTEGER_64;y: INTEGER_64]
		do
			Result := coordinate
		end
	get_ship_dir :STRING
		do
			Result := ship_dir
		end

feature

	out: STRING
	do
		if debug_mode ~ false then
			if (is_hit ~ true) and (has_ship ~ true) then
				Result := "X"
			elseif (is_hit ~ true) and (has_ship ~ false) then
				Result := "O"
			else
				Result := "_"
			end
		else
			if (is_hit ~ true) and (has_ship ~ true) then
				Result := "X"
			elseif (is_hit ~ true) and (has_ship ~ false) then
				Result := "O"
			elseif (is_hit ~ false) and (has_ship ~ true) then
				Result := ship_dir
			else
				Result := "_"
			end



		end

	end
end
