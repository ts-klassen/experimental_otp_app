-module(telegram_apis).

-export([send_message/2, set_webhook/1, webhook_info/0]).

-define(TIMEOUT, 60000).

send_message(To, Message) ->
  EncodedMessage = cow_uri:urlencode(Message),
  BaseUri = add_key_to_endpoint(<<"/sendMessage?chat_id=">>),
  ApiUri = <<
    BaseUri/binary,
    To/binary,
    <<"&text=">>/binary,
    EncodedMessage/binary
  >>,
  {ok, ConnPid} = gun:open("api.telegram.org", 443),
  StreamRef = gun:get(ConnPid, ApiUri),
  {response, nofin, 200, _} = gun:await(ConnPid, StreamRef, ?TIMEOUT),
  {ok, Res} = gun:await_body(ConnPid, StreamRef),
  gun:close(ConnPid),
  Res.

set_webhook(Url) ->
  EncodedUrl = cow_uri:urlencode(Url),
  ApiUri = add_key_to_endpoint(<<"/setWebhook?url=">>),
  {ok, ConnPid} = gun:open("api.telegram.org", 443),
  StreamRef = gun:get(ConnPid, <<ApiUri/binary, EncodedUrl/binary>>),
  {response, nofin, 200, _} = gun:await(ConnPid, StreamRef, ?TIMEOUT),
  {ok, Res} = gun:await_body(ConnPid, StreamRef),
  gun:close(ConnPid),
  Res.

webhook_info() ->
  ApiUri = add_key_to_endpoint(<<"/getWebhookInfo">>),
  {ok, ConnPid} = gun:open("api.telegram.org", 443),
  StreamRef = gun:get(ConnPid, ApiUri),
  {response, nofin, 200, _} = gun:await(ConnPid, StreamRef, ?TIMEOUT),
  {ok, Res} = gun:await_body(ConnPid, StreamRef),
  gun:close(ConnPid),
  Res.



add_key_to_endpoint(Endpoint) ->
  Key = list_to_binary(os:getenv("TELEGRAM_BOT_API_KEY")),
  BaseUri = <<"/bot">>,
  <<BaseUri/binary, Key/binary, Endpoint/binary>>.

