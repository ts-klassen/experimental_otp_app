%%%-------------------------------------------------------------------
%% @doc telegram2 public API
%% @end
%%%-------------------------------------------------------------------

-module(telegram2_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    spawn(telegram_apis, set_webhook, [
        <<"https://telegram2.ttsapis.com/addbot">>
    ]),
    Dispatch = cowboy_router:compile([
            {'_', [
                {"/addbot", home_handler, []}
            ]}
    ]),
    {ok, _} = cowboy:start_clear(fizzy_http_listener,
        [{port, 8002}],
        #{env => #{dispatch => Dispatch}
    }),
    telegram2_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
