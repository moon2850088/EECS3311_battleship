note
	description: "Summary description for {LEVEL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LEVEL


create
	make

feature --attribute
	level_in : INTEGER_64
	g_size : INTEGER
	shots: INTEGER_64
	bombs: INTEGER_64
	n_ships: INTEGER_64

feature{NONE}
	make(l : INTEGER_64)
		do

		if l = 13 then
			level_in := 13
			g_size := 4
			shots := 8
			bombs := 2
			n_ships := 2
		elseif l = 14 then
			level_in := 14
			g_size := 6
			shots := 16
			bombs := 	3
			n_ships := 3
		elseif l =15 then
			level_in := 15
			g_size := 8
			shots := 24
			bombs := 5
			n_ships := 5
		elseif l = 16 then
			level_in := 16
			g_size := 12
			shots := 40
			bombs := 7
			n_ships := 7
		else
			check false end
		end



		end

end
