%% Copyright (c) 2011, Loïc Hoguin <essen@dev-extend.eu>
%%
%% Permission to use, copy, modify, and/or distribute this software for any
%% purpose with or without fee is hereby granted, provided that the above
%% copyright notice and this permission notice appear in all copies.
%%
%% THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
%% WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
%% MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
%% ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
%% WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
%% ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
%% OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

-module(cowboy_tcp_transport).
-export([name/0, listen/1, accept/1, recv/3, send/2, setopts/2,
	controlling_process/2, peername/1, close/1]).

-include("include/types.hrl").

-spec name() -> tcp.
name() -> tcp.

-spec listen([{port, Port::port_number()}])
	-> {ok, LSocket::socket()} | {error, Reason::posix()}.
listen(Opts) ->
	{port, Port} = lists:keyfind(port, 1, Opts),
	gen_tcp:listen(Port, [binary, {active, false},
		{packet, raw}, {reuseaddr, true}]).

-spec accept(LSocket::socket())
	-> {ok, Socket::socket()} | {error, Reason::closed | timeout | posix()}.
accept(LSocket) ->
	gen_tcp:accept(LSocket).

-spec recv(Socket::socket(), Length::integer(), Timeout::timeout())
	-> {ok, Packet::term()} | {error, Reason::closed | posix()}.
recv(Socket, Length, Timeout) ->
	gen_tcp:recv(Socket, Length, Timeout).

-spec send(Socket::socket(), Packet::iolist())
	-> ok | {error, Reason::posix()}.
send(Socket, Packet) ->
	gen_tcp:send(Socket, Packet).

-spec setopts(Socket::socket(), Opts::list(term()))
	-> ok | {error, Reason::posix()}.
setopts(Socket, Opts) ->
	inet:setopts(Socket, Opts).

-spec controlling_process(Socket::socket(), Pid::pid())
	-> ok | {error, Reason::closed | not_owner | posix()}.
controlling_process(Socket, Pid) ->
	gen_tcp:controlling_process(Socket, Pid).

-spec peername(Socket::socket())
	-> {ok, {Address::ip_address(), Port::port_number()}} | {error, posix()}.
peername(Socket) ->
	inet:peername(Socket).

-spec close(Socket::socket()) -> ok.
close(Socket) ->
	gen_tcp:close(Socket).
