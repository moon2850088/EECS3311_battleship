note
	description: "Summary description for {SHIP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SHIP


create
	make
feature

	make
		local zero : INTEGER
		do
			zero := 0
			ship_id := zero.as_integer_64
			create coordinates.make_empty
			ship_size := zero.as_integer_64
			hit_t := zero.as_integer_64
			sunk := false
		end

feature
	ship_id : INTEGER_64
	coordinates : ARRAY[TUPLE[row: INTEGER_64; col: INTEGER_64]]
	ship_size: INTEGER_64
	hit_t: INTEGER_64
	sunk : BOOLEAN


feature
	set_ship_id(s_id: INTEGER_64)
		do
			ship_id := s_id
		end

	collect_coord(cood: TUPLE[row: INTEGER_64; col: INTEGER_64])
		do
			coordinates.force (cood, coordinates.upper + 1)
		end

	set_ship_size(s_size: INTEGER_64)
		do
			ship_size := s_size
		end
	be_hit
		do

		end


end
