-module(home_handler).
-behavior(cowboy_rest).

-export([init/2]).

init(Req0, State) ->
  true = cowboy_req:has_body(Req0),
  {ok, JsonBody, _Header} = cowboy_req:read_body(Req0),
  io:format("~s~n", [JsonBody]),
  Body = jsone:decode(JsonBody),
  {ok, Message} = case maps:find(<<"message">>, Body) of
    {ok, X} -> {ok, X};
    error -> maps:find(<<"edited_message">>, Body)
  end,
  {ok, Text} = maps:find(<<"text">>, Message),
  {ok, Chat} = maps:find(<<"chat">>, Message),
  {ok, NumId} = maps:find(<<"id">>, Chat),
  Id = list_to_binary(integer_to_list(NumId)),
  Ans = adding:from_binary(Text),
  telegram_apis:send_message(Id, Ans),
  Req = cowboy_req:reply(200, #{
    <<"content-type">> => <<"text/plain">>
  }, <<"Fizzy Home">>, Req0),
  {ok, Req, State}.
