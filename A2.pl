:- use_module(library(csv)).

open :-
    retractall(distance(_, _, _)),
    csv_read_file('A2_roaddistance.csv', Rows, [functor(table)]),
    table_entry(Rows).

:- dynamic(distance/3).
:- dynamic(goal/1).

getNames(Index, Header, Row, _RowName):-
    arg(Index, Header, _ColName),
    arg(Index, Row, '-').
    %assert(distance(RowName, ColName, 0)).


getNames(Index, Header, Row, RowName):-
    arg(Index, Header, ColName),
    arg(Index, Row, Value),
    assert(distance(RowName, ColName, Value)).


header_row_entry(Header, Row):-
    arg(1, Row, RowName),
    functor(Header, _, Arity),
    findall(ArgIndex, between(2, Arity, ArgIndex), Bag),
    forall(member(Index, Bag), getNames(Index, Header, Row, RowName)).

table_entry(Entries):-
    Entries = [Header | Rows],
    forall(member(Row, Rows), header_row_entry(Header, Row)).


road(C1, C2, Distance):-
    distance(C1, C2, Distance);
    distance(C2, C1, Distance).





%Depth First Search without path length

list_len(Xs, L):- list_length(Xs,0,L) .

list_length([]    , L , L ) .
list_length([_|Xs], T , L ) :-
    T1 is T+1 ,
    list_length(Xs, T1, L).

solve(Node, Goal, Solution, MaxDepth):-
    retractall(goal(_)),
    assert(goal(Goal)),
    depthfirst([], Node, Solution, MaxDepth),
    list_len(Solution, Len),
    write(Len).

depthfirst(Path, Node, [Node | Path], _MaxDepth)  :-
    goal(Node), !.

depthfirst(Path, Node, Sol, MaxDepth)  :-
    MaxDepth > 0,
    road(Node, Node1, _),
    \+ member( Node1, Path),                % Prevent a cycle
    MaxD is MaxDepth - 1,
    depthfirst([Node | Path], Node1, Sol, MaxD).





