%%——————————————— Data —————————————————%%

% Rooms: small (one group/slot) or big (can host multiple groups for lectures)
room(room1, small).
room(room2, small).
room(room3, big).
room(room4, big).

% Weekdays and periods (e.g. 1–5 slots per day)
weekday(mon). weekday(tue). weekday(wed). weekday(thu). weekday(fri).
period(p1). period(p2). period(p3). period(p4). period(p5).

% A timeslot is a Day+Period pair
timeslot(Day,Per) :- weekday(Day), period(Per).

% Groups
group(g1). group(g2). group(g3).

% Subjects and how many lessons per week each group needs
subject(math).
subject(physics).
subject(cs).
subject(chemistry).

hours(math, 3).
hours(physics, 2).
hours(cs, 2).
hours(chemistry, 1).

% Which subjects are “lectures” (can share big room)
lecture(math).
lecture(physics).

% Which subjects each group studies
subject_of_group(g1, math).     subject_of_group(g1, physics).
subject_of_group(g2, math).     subject_of_group(g2, cs).
subject_of_group(g3, physics).  subject_of_group(g3, chemistry).

% Teachers (multiple per subject allowed)
teacher_of(math, smith).  teacher_of(math, brown).
teacher_of(physics, jones). teacher_of(physics, white).
teacher_of(cs, taylor).
teacher_of(chemistry, clark).

%%———————————Run———————————%%

run_timetable :-
    timetable(S),          % 1) build the schedule
    print_timetable(S).    % 2) display every entry


%%——————————— Entry Point —————————————————%%

% Build the schedule: each lesson is schedule(Room,Day,Per,Group,Subj,Teacher)
timetable(Schedule) :-
    % 1) generate one “slot placeholder” per needed hour
    findall(lesson(Group,Subject),
            ( subject_of_group(Group,Subject),
              hours(Subject,H),
              between(1,H,_)
            ),
            Lessons),
    % 2) schedule them (choosing a teacher at placement time)
    schedule_lessons(Lessons, [], Schedule).

%%——————— Scheduling Predicate ————————%%

schedule_lessons([], Acc, Acc).
schedule_lessons([lesson(G,S)|Rest], Acc, Schedule) :-
    % pick a teacher for this slot
    teacher_of(S,T),
    % pick a room & timeslot
    room(R,Type),
    timeslot(Day,Per),
    % check all conflicts & capacity
    valid(R,Type,Day,Per,G,S,T,Acc),
    % record it
    schedule_lessons(Rest, [schedule(R,Day,Per,G,S,T)|Acc], Schedule).

%%——————— Conflict & Capacity Rules ————————%%

% Small rooms: at most one class, plus group & teacher free
valid(R,small,Day,Per,G,_,T,Sched) :-
    \+ member(schedule(R,Day,Per,_,_,_), Sched),
    \+ member(schedule(_,Day,Per,G,_,_), Sched),
    \+ member(schedule(_,Day,Per,_,_,T), Sched).

% Big rooms: only lectures; can share if same S+T; plus group & teacher free
valid(R,big,Day,Per,G,S,T,Sched) :-
    lecture(S),
    \+ member(schedule(_,Day,Per,G,_,_), Sched),
    \+ member(schedule(_,Day,Per,_,_,T), Sched),
    (   % either empty
        \+ member(schedule(R,Day,Per,_,_,_), Sched)
    ;   % or same lecture already there
        member(schedule(R,Day,Per,_,S,T), Sched)
    ).


% the printer
print_timetable([]).
print_timetable([schedule(R,D,P,G,S,T)|Rest]) :-
    format('~w  ~w  ~w  ~w  ~w  ~w~n',
           [R,D,P,G,S,T]),
    print_timetable(Rest).
