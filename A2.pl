%Name: Manvi Goel
%Roll Number: 2019472

%Import Modules
:- use_module(library(csv)).


start :-
    % Retract the values from previous search.
    retractall(distance(_, _, _)),
    retractall(heuristics(_, _, _)),

    % Open the road distances and heuristics csv file and read the predicates.
    assertDistances,
    assertHeuristics,

    % Select and start the search.
    startSearch.



assertHeuristics:-
    % Open the heuritics file and assert the heuristics of form (City1, City 2, Heuristic of City 2 for  goal as City 1).
    csv_read_file('heuristics.csv', Rows, [functor(heuristics)]),
    maplist(assert, Rows).



assertDistances:-
    % Open the distances file and form the correct form of predicates.
    csv_read_file('A2_roaddistance.csv', Rows, [functor(table)]),
    table_entry(Rows).


%Wrapper functions
startSearch:-
    writeln("India Major City Road Distance Search..."), nl,
    write("Enter the start Node: "),
    read(Start),
    write("Enter the goal Node: "),
    read(Goal), nl,
    writeln("Select the search algorithm"),
    writeln("Depth First Search with maximum depth restraint - (1)"),
    writeln("Best First Search with straight line distance heuristics - (2)"),
    read(Search), nl,
    search(Start, Goal, Search, Path, Len),
    write("The path is: "),
    writeln(Path),
    write("The path length: "),
    write(Len).


%Wrapper function for DFS
search(Start, Goal, 1, Path, Len):-
    writeln("Selected Search: Depth First Search"),
    writeln("Provide the maximum depth for Depth First Search: "),
    read(Depth), nl,
    writeln("----searching----"), nl,
    solveDFS(Start, Goal, Path, Depth, Len).


%wrapper function for BFS
search(Start, Goal, 2, Path, Len):-
    writeln("Selected Search: Best First Search"), nl,
    writeln("----searching----"), nl,
    solveBFS(Start, Goal, Path, Len).




% Dynamic Functions.
:- dynamic(distance/3).
:- dynamic(goal/1).
:- dynamic(heuristics/3).


% Making the table entries in the form of required predicates.

getNames(Index, Header, Row, _RowName):-
    % predicate: distance(City, City, 0).
    % ignoring the predicates of above forms.
    arg(Index, Header, _ColName),
    arg(Index, Row, '-').

getNames(Index, Header, Row, RowName):-
    % predicate: distance(City 1, City 2, Distance).
    arg(Index, Header, ColName),
    arg(Index, Row, Value),
    assert(distance(RowName, ColName, Value)).



header_row_entry(Header, Row):-

    %Select the row name.
    arg(1, Row, RowName),
    functor(Header, _, Arity),

    % For all cities in one row.
    findall(ArgIndex, between(2, Arity, ArgIndex), Bag),
    forall(member(Index, Bag), getNames(Index, Header, Row, RowName)).



table_entry(Entries):-

    %Divide the header and row in th original csv file.
    Entries = [Header | Rows],
    forall(member(Row, Rows), header_row_entry(Header, Row)).



road(C1, C2, Distance):-

    %predicate distance(City 1, City 2, Distance).
    distance(C1, C2, Distance).

road(C1, C2, Distance):-

    % undirected roads
    distance(C2, C1, Distance),

    %avoid repetition.
    \+distance(C1, C2, Distance).






%Depth First Search.

%Helper Functions.
% Calculating the path lenght.
list_len(Xs, L):- list_length(Xs, 0, L).

list_length([],L ,L).
list_length([_H], L, L).

list_length([H|[H2|Xs]], T, L ) :-

    % Calculate the distances
    road(H, H2, Dist),

    %Add the distances
    T1 is T + Dist,

    %Recursion.
    list_length([H2|Xs], T1, L).





%Depth First Search.
solveDFS(Node, Goal, Solution, MaxDepth, Len):-
    retractall(goal(_)),

    %Assert the goal
    assert(goal(Goal)),

    %Search.
    depthfirst([], Node, Solution, MaxDepth),

    %Path Length
    list_len(Solution, Len).

depthfirst(Path, Node, [Node | Path], _MaxDepth)  :-

    % Goal
    % Cut.
    goal(Node), !.

depthfirst(Path, Node, Sol, MaxDepth)  :-

    %Check the max depth to prevent infinite depth.
    MaxDepth > 0,

    %Check the direct children of node
    road(Node, Node1, _),

    % Prevent a loop
    \+ member(Node1, Path),
    MaxD is MaxDepth - 1,

    %Recursion
    depthfirst([Node | Path], Node1, Sol, MaxD).







%Best First Search.

%Helper Functions.

%Adding an element in a list.
addElement(X, [], [X]).

addElement(X, [Y | Rest], [X, Y | Rest]).


% Union of two list.
union_set([],[],[]).

union_set(List1,[],List1).

union_set(List1, [Head2|Tail2], [Head2|Output]):-
    \+(member(Head2,List1)), union(List1, Tail2, Output).

union_set(List1, [Head2|Tail2], Output):-
    member(Head2,List1), union(List1, Tail2, Output).


% Quick sort for a list
quick_sort2(List, Sorted):-
    q_sort(List,[], Sorted).

q_sort([] ,Acc, Acc).

q_sort([[N, H]|T],Acc,Sorted):-
    pivoting(H, T, L1, L2),
    q_sort(L1, Acc, Sorted1),
    q_sort(L2, [[N, H]|Sorted1], Sorted).


% Path Lenght for BFS.
list_len2(Xs, L):-
    list_length2(Xs, 0, L).



list_length2([], L, L).

list_length2([[_H, _]], L, L).

list_length2([[N, _]|[[N2, _]|Xs]], T, L ) :-

    %Backtracking
    road(N, N2, Dist),
    T1 is T + Dist,

    % Recursion.
    list_length2([[N2, _]|Xs], T1, L).



% Pivot function for quick sort using recursion
pivoting(_H,[],[],[]).

pivoting(H,[[N, X]|T],[[N, X]|L], G):-
    X >= H,
    pivoting(H, T, L, G).

pivoting(H,[[N, X]|T], L,[[N, X]|G]):-
    X<H,
    pivoting(H, T, L, G).




%Best First Search
solveBFS(Node, Goal, Solution, Len):-
    retractall(goal(_)),
    assert(goal(Goal)),

    % Heuristics for the start and goal.
    % Cut
    heuristics(Node, Goal, H), !,

    % Search
    bestfirst([[Node, H]], [], Goal, Solution),

    % Path Length.
    list_len2(Solution, Len).


bestfirst(_Open, [[Node, H]| T], Goal, [[Node, H]| T]):-

    % Goal Found.
    Node =  Goal, !.


bestfirst(Open, Closed, Goal, Solution):-

    % Sorting the Open array
    quick_sort2(Open, [Head|Tail]),

    % Adding the opened element to path.
    addElement(Head, Closed, NewClosed),

    % Calculating the children
    children_of(NewClosed, Open, Goal, Head, Children),

    % Adding the children to Open
    union_set(Children, Tail, NewOpen),

    % Recursion
    bestfirst(NewOpen, NewClosed, Goal, Solution).



children_of(Closed, Open, Goal, [He, _], Children):-

    % All children and heuristics value.
    bagof([Child, H], finalH(Closed, Open, Child, Goal, He, H), Children).



finalH(Closed, Open, Child, Goal, He, H):-

    % Children
    road(He, Child, _),

    % Avoid Loop
    not(member(Child, Closed)),
    not(member(Child, Open)),

    % Finding heuristics value.
    heuristics(Child, Goal, H).




