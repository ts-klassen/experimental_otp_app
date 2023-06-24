-module(adding).

-export([from_binary/1]).

from_binary(Str) ->
  from_list(binary_to_list(<<Str/binary, <<"=">>/binary>>), []).

from_list([], Ans) ->
  <<"ERROR">>;



from_list([$+|Str], [{add, First, Second}|[{add, first, second}|Ans]])
  when is_integer(First), is_integer(Second) ->
    from_list([$+|Str], [{add, First+Second, next}|Ans]);

from_list([$+|Str], [{add, First, Second}|[{add, Num, _}|Ans]])
  when is_integer(First), is_integer(Second), is_integer(Num) ->
    from_list([$+|Str], [{add, Num, First+Second}|Ans]);




from_list([$+|Str], Ans) ->
  from_list(Str, [{add, first, second}|Ans]);

from_list([Char|Str], [{add, first, second}|Ans]) when $0=<Char,Char=<$9 ->
  Num = Char - $0,
  from_list(Str, [{add, Num, second}|Ans]);

from_list([_Char|Str], [{add, first, second}|Ans]) ->
  from_list(Str, [{add, first, second}|Ans]);

from_list([Char|Str], [{add, First, second}|Ans]) when $0=<Char,Char=<$9 ->
  Num = Char - $0,
  from_list(Str, [{add, 10*First+Num, second}|Ans]);

from_list([_Char|Str], [{add, Num, second}|Ans]) ->
  from_list(Str, [{add, Num, next}|Ans]);

from_list([Char|Str], [{add, First, next}|Ans]) when $0=<Char,Char=<$9 ->
  Num = Char - $0,
  from_list(Str, [{add, First, Num}|Ans]);

from_list([Char|Str], [{add, First, next}|Ans]) ->
  from_list(Str, [{add, First, next}|Ans]);

from_list([Char|Str], [{add, First, Second}|Ans]) when $0=<Char,Char=<$9 ->
  Num = Char - $0,
  from_list(Str, [{add, First, 10*Second+Num}|Ans]);

from_list(_Str, [{add, First, Second}|[]]) ->
  list_to_binary(integer_to_list(First + Second));

from_list(Str, [{add, First, Second}|[{add, first, second}|Ans]])
  when is_integer(First), is_integer(Second) ->
    from_list(Str, [{add, First+Second, next}|Ans]);

from_list(Str, [{add, First, Second}|[{add, Num, _}|Ans]])
  when is_integer(First), is_integer(Second), is_integer(Num) ->
    from_list(Str, [{add, Num, First+Second}|Ans]);


from_list([_Char|Str], Ans) ->
  from_list(Str, Ans).
