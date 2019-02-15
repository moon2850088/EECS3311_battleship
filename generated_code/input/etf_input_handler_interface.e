note
	description: "Input Handler"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ETF_INPUT_HANDLER_INTERFACE
inherit
	ETF_TYPE_CONSTRAINTS

feature {NONE}

	make_without_running(etf_input: STRING; a_commands: ETF_ABSTRACT_UI_INTERFACE)
			-- convert an input string into array of commands
	  	do
	  		create on_error
		  	input_string := etf_input
		  	abstract_ui  := a_commands
	  	end

	make(etf_input: STRING; a_commands: ETF_ABSTRACT_UI_INTERFACE)
			-- convert an input string into array of commands
	  	do
	  		make_without_running(etf_input, a_commands)
			parse_and_validate_input_string
	  	end

feature -- auxiliary queries

	etf_evt_out (evt: TUPLE[name: STRING; args: ARRAY[ETF_EVT_ARG]]): STRING
		local
			etf_local_i: INTEGER
			name: STRING
			args: ARRAY[ETF_EVT_ARG]
		do
			name := evt.name
			args := evt.args
			create Result.make_empty
			Result.append (name + "(")
			from
				etf_local_i := args.lower
			until
				etf_local_i > args.upper
			loop
				if args[etf_local_i].src_out.is_empty then
					Result.append (args[etf_local_i].out)
				else
					Result.append (args[etf_local_i].src_out)
				end
				if etf_local_i < args.upper then
					Result.append (", ")
				end
				etf_local_i := etf_local_i + 1
			end
			Result.append (")")
		end

feature -- attributes

	etf_error: BOOLEAN

	input_string: STRING -- list of commands to execute

	abstract_ui: ETF_ABSTRACT_UI_INTERFACE
		-- output generated by `parse_string'

feature -- error reporting

	on_error: ETF_EVENT [TUPLE[STRING]]

feature -- error messages

	input_cmds_syntax_err_msg : STRING =
		"Syntax Error: specification of command executions cannot be parsed"

	input_cmds_type_err_msg : STRING =
		"Type Error: specification of command executions is not type-correct"

feature -- parsing

	parse_and_validate_input_string
	  local
		trace_parser : ETF_EVT_TRACE_PARSER
		cmd : ETF_COMMAND_INTERFACE
		invalid_cmds: STRING
	  do
		create trace_parser.make (evt_param_types_list, enum_items)
		trace_parser.parse_string (input_string)

	    if trace_parser.last_error.is_empty then
	  	  invalid_cmds := find_invalid_evt_trace (
		    	trace_parser.event_trace)
		  if invalid_cmds.is_empty then
		    across trace_parser.event_trace
		    as evt
		    loop
		      cmd := evt_to_cmd (evt.item)
		      abstract_ui.put (cmd)
		    end
		  else
		    etf_error := TRUE
		    on_error.notify (
		  	  input_cmds_type_err_msg + "%N" + invalid_cmds)
		  end
	    else
	      etf_error := TRUE
	      on_error.notify (
		    input_cmds_syntax_err_msg + "%N" + trace_parser.last_error)
	    end
	end

	evt_to_cmd (evt : TUPLE[name: STRING; args: ARRAY[ETF_EVT_ARG]]) : ETF_COMMAND_INTERFACE
		local
			cmd_name : STRING
			args : ARRAY[ETF_EVT_ARG]
			dummy_cmd : ETF_DUMMY
		do
			cmd_name := evt.name
			args := evt.args
			create dummy_cmd.make("dummy", [], abstract_ui)

			if cmd_name ~ "new_game" then 
				 if attached {ETF_ENUM_INT_ARG} args[1] as level and then (level.value = easy or else level.value = medium or else level.value = hard or else level.value = advanced) then 
					 create {ETF_NEW_GAME} Result.make ("new_game", [level.value], abstract_ui) 
				 else 
					 Result := dummy_cmd 
				 end 

			elseif cmd_name ~ "debug_test" then 
				 if attached {ETF_ENUM_INT_ARG} args[1] as level and then (level.value = easy or else level.value = medium or else level.value = hard or else level.value = advanced) then 
					 create {ETF_DEBUG_TEST} Result.make ("debug_test", [level.value], abstract_ui) 
				 else 
					 Result := dummy_cmd 
				 end 

			elseif cmd_name ~ "fire" then 
				 if (attached {ETF_TUPLE_ARG} args[1] as coordinate) and then coordinate.value.count = 2 and then (attached {ETF_ENUM_INT_ARG} coordinate.value[1] as coordinate_row) and then (attached {ETF_INT_ARG} coordinate.value[2] as coordinate_column) and then (coordinate_row.value = A or else coordinate_row.value = B or else coordinate_row.value = C or else coordinate_row.value = D or else coordinate_row.value = E or else coordinate_row.value = F or else coordinate_row.value = G or else coordinate_row.value = H or else coordinate_row.value = I or else coordinate_row.value = J or else coordinate_row.value = K or else coordinate_row.value = L) and then 1 <= coordinate_column.value and then coordinate_column.value <= 12 then 
					 create {ETF_FIRE} Result.make ("fire", [[coordinate_row.value, coordinate_column.value]], abstract_ui) 
				 else 
					 Result := dummy_cmd 
				 end 

			elseif cmd_name ~ "bomb" then 
				 if (attached {ETF_TUPLE_ARG} args[1] as coordinate1) and then coordinate1.value.count = 2 and then (attached {ETF_ENUM_INT_ARG} coordinate1.value[1] as coordinate1_row) and then (attached {ETF_INT_ARG} coordinate1.value[2] as coordinate1_column) and then (coordinate1_row.value = A or else coordinate1_row.value = B or else coordinate1_row.value = C or else coordinate1_row.value = D or else coordinate1_row.value = E or else coordinate1_row.value = F or else coordinate1_row.value = G or else coordinate1_row.value = H or else coordinate1_row.value = I or else coordinate1_row.value = J or else coordinate1_row.value = K or else coordinate1_row.value = L) and then 1 <= coordinate1_column.value and then coordinate1_column.value <= 12 and then (attached {ETF_TUPLE_ARG} args[2] as coordinate2) and then coordinate2.value.count = 2 and then (attached {ETF_ENUM_INT_ARG} coordinate2.value[1] as coordinate2_row) and then (attached {ETF_INT_ARG} coordinate2.value[2] as coordinate2_column) and then (coordinate2_row.value = A or else coordinate2_row.value = B or else coordinate2_row.value = C or else coordinate2_row.value = D or else coordinate2_row.value = E or else coordinate2_row.value = F or else coordinate2_row.value = G or else coordinate2_row.value = H or else coordinate2_row.value = I or else coordinate2_row.value = J or else coordinate2_row.value = K or else coordinate2_row.value = L) and then 1 <= coordinate2_column.value and then coordinate2_column.value <= 12 then 
					 create {ETF_BOMB} Result.make ("bomb", [[coordinate1_row.value, coordinate1_column.value] , [coordinate2_row.value, coordinate2_column.value]], abstract_ui) 
				 else 
					 Result := dummy_cmd 
				 end 
			else 
				 Result := dummy_cmd 
			end 
		end

	find_invalid_evt_trace (
		event_trace: ARRAY[TUPLE[name: STRING; args: ARRAY[ETF_EVT_ARG]]])
	: STRING
	local
		loop_counter: INTEGER
		evt: TUPLE[name: STRING; args: ARRAY[ETF_EVT_ARG]]
		cmd_name: STRING
		args: ARRAY[ETF_EVT_ARG]
		evt_out_str: STRING
	do
		create Result.make_empty
		from
			loop_counter := event_trace.lower
		until
			loop_counter > event_trace.upper
		loop
			evt := event_trace[loop_counter]
			evt_out_str := etf_evt_out (evt)

			cmd_name := evt.name
			args := evt.args

			if cmd_name ~ "new_game" then 
				if NOT( ( args.count = 1 ) AND THEN attached {ETF_ENUM_INT_ARG} args[1] as level and then (level.value = easy or else level.value = medium or else level.value = hard or else level.value = advanced)) then 
					if NOT Result.is_empty then
						Result.append ("%N")
					end
					Result.append (evt_out_str + " does not conform to declaration " +
							"new_game(level: LEVEL = {easy, medium, hard, advanced})")
				end

			elseif cmd_name ~ "debug_test" then 
				if NOT( ( args.count = 1 ) AND THEN attached {ETF_ENUM_INT_ARG} args[1] as level and then (level.value = easy or else level.value = medium or else level.value = hard or else level.value = advanced)) then 
					if NOT Result.is_empty then
						Result.append ("%N")
					end
					Result.append (evt_out_str + " does not conform to declaration " +
							"debug_test(level: LEVEL = {easy, medium, hard, advanced})")
				end

			elseif cmd_name ~ "fire" then 
				if NOT( ( args.count = 1 ) AND THEN (attached {ETF_TUPLE_ARG} args[1] as coordinate) and then coordinate.value.count = 2 and then (attached {ETF_ENUM_INT_ARG} coordinate.value[1] as coordinate_row) and then (attached {ETF_INT_ARG} coordinate.value[2] as coordinate_column) and then (coordinate_row.value = A or else coordinate_row.value = B or else coordinate_row.value = C or else coordinate_row.value = D or else coordinate_row.value = E or else coordinate_row.value = F or else coordinate_row.value = G or else coordinate_row.value = H or else coordinate_row.value = I or else coordinate_row.value = J or else coordinate_row.value = K or else coordinate_row.value = L) and then 1 <= coordinate_column.value and then coordinate_column.value <= 12) then 
					if NOT Result.is_empty then
						Result.append ("%N")
					end
					Result.append (evt_out_str + " does not conform to declaration " +
							"fire(coordinate: COORDINATE = TUPLE[row: ROW = {A, B, C, D, E, F, G, H, I, J, K, L}; column: COLUMN = 1 .. 12])")
				end

			elseif cmd_name ~ "bomb" then 
				if NOT( ( args.count = 2 ) AND THEN (attached {ETF_TUPLE_ARG} args[1] as coordinate1) and then coordinate1.value.count = 2 and then (attached {ETF_ENUM_INT_ARG} coordinate1.value[1] as coordinate1_row) and then (attached {ETF_INT_ARG} coordinate1.value[2] as coordinate1_column) and then (coordinate1_row.value = A or else coordinate1_row.value = B or else coordinate1_row.value = C or else coordinate1_row.value = D or else coordinate1_row.value = E or else coordinate1_row.value = F or else coordinate1_row.value = G or else coordinate1_row.value = H or else coordinate1_row.value = I or else coordinate1_row.value = J or else coordinate1_row.value = K or else coordinate1_row.value = L) and then 1 <= coordinate1_column.value and then coordinate1_column.value <= 12 and then (attached {ETF_TUPLE_ARG} args[2] as coordinate2) and then coordinate2.value.count = 2 and then (attached {ETF_ENUM_INT_ARG} coordinate2.value[1] as coordinate2_row) and then (attached {ETF_INT_ARG} coordinate2.value[2] as coordinate2_column) and then (coordinate2_row.value = A or else coordinate2_row.value = B or else coordinate2_row.value = C or else coordinate2_row.value = D or else coordinate2_row.value = E or else coordinate2_row.value = F or else coordinate2_row.value = G or else coordinate2_row.value = H or else coordinate2_row.value = I or else coordinate2_row.value = J or else coordinate2_row.value = K or else coordinate2_row.value = L) and then 1 <= coordinate2_column.value and then coordinate2_column.value <= 12) then 
					if NOT Result.is_empty then
						Result.append ("%N")
					end
					Result.append (evt_out_str + " does not conform to declaration " +
							"bomb(coordinate1: COORDINATE = TUPLE[row: ROW = {A, B, C, D, E, F, G, H, I, J, K, L}; column: COLUMN = 1 .. 12] ; coordinate2: COORDINATE = TUPLE[row: ROW = {A, B, C, D, E, F, G, H, I, J, K, L}; column: COLUMN = 1 .. 12])")
				end
			else
				if NOT Result.is_empty then
					Result.append ("%N")
				end
				Result.append ("Error: unknown event name " + cmd_name)
			end
			loop_counter := loop_counter + 1
		end
	end
end