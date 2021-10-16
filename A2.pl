:- use_module(library(csv)).

open :-
    retractall(distance(_, _, _)),
    retractall(heuristics(_, _, _)),
    csv_read_file('heuristics.csv', Rows2, [functor(heuristics)]),
    maplist(assert, Rows2),
    csv_read_file('A2_roaddistance.csv', Rows, [functor(table)]),
    table_entry(Rows).

:- dynamic(distance/3).
:- dynamic(goal/1).
:- dynamic(heuristics/3).


getNames(Index, Header, Row, _RowName):-
    arg(Index, Header, _ColName),
    arg(Index, Row, '-').

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
    distance(C1, C2, Distance).

road(C1, C2, Distance):-
    distance(C2, C1, Distance),
    \+distance(C1, C2, Distance).





%Depth First Search with path length
list_len(Xs, L):- list_length(Xs, 0, L).

list_length([],L ,L).
list_length([_H], L, L).
list_length([H|[H2|Xs]], T, L ) :-
    road(H, H2, Dist),
    T1 is T+Dist,
    list_length([H2|Xs], T1, L).




solveDFS(Node, Goal, Solution, MaxDepth, Len):-
    retractall(goal(_)),
    assert(goal(Goal)),
    depthfirst([], Node, Solution, MaxDepth),
    list_len(Solution, Len).

depthfirst(Path, Node, [Node | Path], _MaxDepth)  :-
    goal(Node), !.

depthfirst(Path, Node, Sol, MaxDepth)  :-
    MaxDepth > 0,
    road(Node, Node1, _),
    \+ member(Node1, Path),                % Prevent a cycle
    MaxD is MaxDepth - 1,
    depthfirst([Node | Path], Node1, Sol, MaxD). %Recursion



%Best First Search.
addElement(X, [], [X]).
addElement(X, [Y | Rest], [X, Y | Rest]).

union_set([],[],[]).
union_set(List1,[],List1).
union_set(List1, [Head2|Tail2], [Head2|Output]):-
    \+(member(Head2,List1)), union(List1, Tail2, Output).
union_set(List1, [Head2|Tail2], Output):-
    member(Head2,List1), union(List1, Tail2, Output).

quick_sort2(List, Sorted):- q_sort(List,[],Sorted).
q_sort([] ,Acc, Acc).
q_sort([[N, H]|T],Acc,Sorted):-
    pivoting(H, T, L1, L2),
    q_sort(L1, Acc, Sorted1),q_sort(L2,[[N, H]|Sorted1], Sorted).

list_len2(Xs, L):- list_length2(Xs, 0, L).

list_length2([], L, L).
list_length2([[_H, _]], L, L).
list_length2([[N, _]|[[N2, _]|Xs]], T, L ) :-
    road(N, N2, Dist),
    T1 is T + Dist,
    list_length2([[N2, _]|Xs], T1, L).


pivoting(_H,[],[],[]).
pivoting(H,[[N, X]|T],[[N, X]|L], G):- X >= H, pivoting(H, T, L, G).
pivoting(H,[[N, X]|T], L,[[N, X]|G]):- X<H, pivoting(H, T, L, G).



solveBFS(Node, Goal, Solution, Len):-
    retractall(goal(_)),
    assert(goal(Goal)),
    heuristics(Node, Goal, H),!,
    bestfirst([[Node, H]], [], Goal, Solution),
    list_len2(Solution, Len).

bestfirst(_Open, [[Node, H]| T], Goal, [[Node, H]| T]):-
    Node =  Goal, !.

bestfirst(Open, Closed, Goal, Solution):-
    quick_sort2(Open, [Head|Tail]),
    addElement(Head, Closed, NewClosed),
    children_of(NewClosed, Open, Goal, Head, Children),
    union_set(Children, Tail, NewOpen),
    bestfirst(NewOpen, NewClosed, Goal, Solution).

children_of(Closed, Open, Goal, [He, _], Children):-
    bagof([Child, H], finalH(Closed, Open, Child, Goal, He, H), Children).


finalH(Closed, Open, Child, Goal, He, H):-
    road(He, Child, _),
    not(member(Child, Closed)),
    not(member(Child, Open)),
    heuristics(Child, Goal, H).




