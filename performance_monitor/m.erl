-module(m).

-compile(export_all).

uname() ->
	cmd("uname -a").


ping5(Host) when is_list(Host)->
	R= cmd("ping -c 5 "++ Host),
	string:tokens(R,"\n").


cmd(Command) ->
	Exec = hd(string:tokens(Command, " ")),
	case os:find_executable(Exec) of
		false -> throw({command_not_found, Exec});
		_     -> os:cmd(Command)
	end.