note
	description: "Summary description for {MESSAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MESSAGE

inherit
	ANY
		redefine out end


create
	make

feature
	make
		do
			error_message := "OK"
			game_state := "Start a new game"
		end

feature --attribute

	 error_message : STRING
	 game_state : STRING

feature
	set_error_message(msg:STRING)
		do
			error_message := msg
		end
	set_game_state(msg:STRING)
		do
			game_state := msg
		end

feature

	out : STRING
		do
			create Result.make_from_string (error_message + " -> " + game_state)
		end

end
