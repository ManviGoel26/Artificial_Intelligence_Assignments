main(Branch, Sem, ListPrereq, ListBranch, Course):-
    start,

    %removing the dynamic predicate values.
    %reset_courses,

    %Inputing the branch for core courses.
    %write("What is your branch? (cse/ csai/ des/ ece/ mth/ bio)"), nl,
    %read(Branch),

    %inputing the semester type.
    %write("What is the ? (winter/ monsoon)"), nl,
    %read(Sem),

    %Getting the courses done for prerequisites and antirequisites.
    %writeln("Input the course code of the courses done. (Type 'stop' to complete) "),
    %getPre(ListPrereq),!,
    %Uses cut.
    %cutting the backtrack so does not delete items from course list.

    %Getting the preference order for course type.
    %writeln("Input the preference order of branch of course. (cse/ csai/ des/ ece/ mth/ bio/ ssh/ oth)"),
    %getPre(ListBranch),!,
    %uses cut.
    %cutting the backtrack so does not delete items from  branch list.

    %Search all the courses.
    search_electives(Branch, Sem, ListPrereq, ListBranch),
    suggestCourse(Course).



start:-
    write("Welcome to Elecives Prediction System"), nl,
    write("The prediction is based on your career interests, branch preferances and courses done."), nl, nl.

%initiating the dynamic predictes.
:- dynamic(likes/1).
:- dynamic(suggestCourse/1).


%retrating the dynamic predicate values.
reset_courses:-
    retractall(likes(_, _)),
    retractall(suggestCourse(_)),
    fail.
reset_courses.


%Making a list for courses done and branch preference.
%Uses Recursion
getPre([Pre|ListPre]):-
    write("Enter: "),
    read(Pre),

    %Stop when input is "stop".
    dif(Pre, stop),
    getPre(ListPre).

getPre([]).

%suggest core courses, and then according to branch preference.
search_electives(B, S, ListP, ListBranches):-

    %Core Courses
    suggestCoreCourses(B, S, ListP);

    %Electives, Negated as function uses backtracking and hence fails to complete.
    foreach(member(Element, ListBranches), \+assertElectives(S, Element, ListP)).


%checking the anti requisites.
%uses recursion
intersection([],_).
intersection([Head|Tail],List) :-
   \+ member(Head,List),
   intersection(Tail,List).


%for pre requisites.
%uses maplist.
contained(L1, L2) :- maplist(contains(L2), L1).
contains(L, X) :- member(X, L), !.

%using branch for course selection. Uses backtracking.
assertElectives(Sem, Branch, ListP):-

    %Check all courses with given branch and semester.
    course_information(Code, Name, L1, _L2, L3, Sem, Branch, L4),

    %don't suggest courses that are already completed.
    \+contains(ListP, Code),

    %check if the courses completed has prerequistes.
    contained(L1, ListP),

    %check if courses completed does not include antirequisites.
    intersection(L3, ListP),

    %check if all the work fields are interesting for user.
    checkInterests(L4),
    foreach(member(Element, L4), likes(Element)),

    %if the course is not already suggested before, assert the predicate.
    \+ suggestCourse(Name),

    %fail to ensure that predicate backtracks.
    assertz(suggestCourse(Name)), fail.




%using code of course.
assertCoreCourse(Code, _Sem, ListP):-

    %if the course is already completed, continue.
    contains(ListP, Code).


assertCoreCourse(Code, Sem, ListP):-

    %similar to checking electives. Does not ask interests as the courses are core for the branch.
    \+contains(ListP, Code),
    course_information(Code, Name, L1, _L2, L3, Sem, _Branch, _L4),
    contained(L1, ListP),
    intersection(L3, ListP),
    \+ suggestCourse(Name),
    assertz(suggestCourse(Name)).


%using core course list.
suggestCoreCourses(Branch, Semester, ListCoursesDone):-

    %get the list of core courses.
    core(ListCore, Branch),

    %suggest each core course.
    foreach(member(Element, ListCore), assertCoreCourse(Element, Semester, ListCoursesDone)).



%writing the dynamic predicate of like.
%uses Recursion
checkInterests([]).
checkInterests([H|T]):-

    %if the interest is already defined. check the rest of list.
    likes(H),
    checkInterests(T).

/*checkInterests([H|T]):-
    \+(likes(H, _A)),

    %ask the preference of user for the current work field.
    write("Are you interested in working in the field of "), write(H), write(" ? (y/ n)"),
    read(R),
    assertz(likes(H, R)),
    checkInterests(T).*/


%Core Courses
core([cse101, ece111, mth100, des130, com101, cse102, cse112, mth201, ece113, cse201, cse231, cse121, cse202, cse222, cse232, com301A, esc207A], cse).

core([cse101, ece111, mth100, des130, com101, cse102, cse112, mth201, cse140, cse201, cse231, cse121, cse342,  cse202, cse222, mth577, cse343, cse643, com301A, esc207A], csai).

core([cse101, ece111, mth100, des130, com101, cse102, cse112, mth201, bio101, cse201, cse231, mth203, bio221, bio214, cse222, cse202, ece113, bio221, bio213, bio361, bio512, com301A, esc207A], bio).

core([cse101, ece111, mth100, des130, com101, cse102, cse112, mth201, des101, des202, cse231, cse201, des201, mth203, cse222, des204, cse202, cse232, ssh201, com301A, esc207A], mth).

core([cse101, ece111, mth100, des130, com101, cse102, cse112, mth201, ece113, cse201, cse231, cse121, cse202, cse222, cse232, com301A, esc207A], des).

core([cse101, ece111, mth100, des130, com101, cse102, cse112, mth201, ece113, ece215, ece270, ece250, mth203, ece230,ece214, ece240,mth204, com301A, esc207A], ece).



%Course Informations.
%CSE Courses and CSAI Courses
course_information(cse320, "Advanced Algorithms", [cse102], [], [], monsoon, cse, ["Algorithms"]).
course_information(cse441, "Advanced Biometrics",[mth201], [cse343], [], winter, cse,["Biometric Systems"]).
course_information(cse562, "Advanced Computer Vision", [cse343], [], [], monsoon, csai,["Computer Vision"]).
course_information(cse577, "Advanced Internet of Things", [cse343], [], [], winter, csai, ["Internet of Things", "Android Programming"]).
course_information(cse642, "Advanced Machine Learning", [mth201, cse343], [cse641], [], monsoon, csai, ["Deep Learning"]).
course_information(cse631, "Advanced Operating Systems", [cse231], [], [], winter, cse, ["Unix Systems", "OS Kernels"]).
course_information(cse201, "Advanced Programming", [cse101, cse102], [], [], monsoon, cse,["Object Oriented Programming"]).
course_information(cse734, "Advanced Topics in Mobile Computing", [cse232, cse231], [], [], winter, cse, ["Challenges In Mobile Computing Domain"]).
course_information(cse661, "Affective Computing", [cse101, cse102, cse201], [cse343, cse643], [], monsoon, dse, "Affective Computing").
course_information(cse222, "Algorithm Design and Analysis", [cse102], [], [], winter, cse, ["Algorithms", "Correctness"]).
course_information(cse546, "Applied Cryptography", [cse121], [], [], monsoon, cse, ["Perfect Security", "Cryptographic Protocols"]).
course_information(cse529, "Approximation Algorithms", [cse222], [], [], winter, cse, ["Np Hard Problems"]).
course_information(cse643, "Artificial Intelligence", [cse102], [], [], monsoon, csai, ["Logic", "Artificial Intelligence"]).
course_information(cse515, "Bayesian Machine Learning", [mth201], [cse343, mth577], [], monsoon, csai, ["Bayesian Approach"]).
course_information(cse557, "Big Data Analytics",[cse202], [cse343], [], winter, cse, ["Data Analysis"]).
course_information(cse640, "Collaborative Filtering", [mth100], [], [], monsoon, cse, ["Recommender Systems"]).
course_information(cse636, "Communication Networks", [mth201], [ece501], [], winter, cse, ["Communication Networking"]).
course_information(cse301, "Compilers", [mth100, cse101, cse201, cse102], [], [], monsoon, cse, ["Compilers"]).
course_information(cse421, "Complexity Theory", [cse102, mth201, cse322, cse121], [], [], monsoon, cse, ["Computaional Complexity"]).
course_information(cse511, "Computer Architecture", [], [], [], monsoon, cse,["Computer Architecture"]).
course_information(cse333, "Computer Graphics", [cse101], [cse102], [], monsoon, cse, ["Computer Graphics"]).
course_information(cse232, "Computer Networks", [cse101, cse231, cse222], [], [], monsoon, cse, ["Network Analysis"]).
course_information(cse112, "Computer Organization", [ece111], [], [], winter, cse, ["Assembly Language"]).
course_information(cse344, "Computer Vision", [mth100], [], [], winter, csai, ["Computer Vision"]).
course_information(cse585, "Computing for Medicine", [], [], [], monsoon, cse, ["Health Data"]).
course_information(cse606A, "Data Lifecycle Management", [cse343], [], [], monsoon, csai, ["Data Research", "Machine Learning"]).
course_information(cse506, "Data Mining", [cse202, cse101, mth100, mth201], [], [], monsoon, cse, ["Patterns In Data"]).
course_information(cse558, "Data Science",[cse101, cse343], [mth101], [], monsoon, csai,["Exploratary Data Analysis"]).
course_information(cse102, "Data Structures And Algorithms", [cse101], [], [], winter, cse,["Data Strcutures"]).
course_information(cse606, "Data Warehouse", [cse202], [], [], winter, cse, ["Data Warehouses"]).
course_information(cse507, "Database System Implementation", [cse202, cse102], [], [], monsoon, cse, ["Database Systems"]).
course_information(cse504, "Decision Procedures", [cse102, cse201, mth210], [], [], winter, cse, ["Decision Procedures"]).
course_information(cse641, "Deep Learning", [], [cse343], [], winter, csai,["Neural Networks"]).
course_information(cse501, "Designing Human Centered Systems", [], [], [des204], monsoon, cse, ["Design Paradigms"]).
course_information(cse121, "Discrete Mathematics", [], [], [mth210], monsoon, cse, "Problem Solving Skills").
course_information(cse530, "Distributed Systems: Concepts And Designs", [cse232, cse222], [], [], monsoon, cse, ["Distrbuted Systems"]).
course_information(cse663, "EdgeAI", [cse343], [], [], winter, csai, ["On Device AI"]).
course_information(cse345, "Foundations of Computer Security", [], [cse232], [], monsoon, cse, ["Computer Security"]).
course_information(cse502, "Foundations of Parallel Programming", [cse102, cse101, cse201], [], [], winter, cse, ["Parallel Programming"]).
course_information(cse202, "Fundamentals of Database Management System", [cse102], [], [], winter, cse, ["Database Manegement"]).
course_information(cse5GP, "Geometry Processing",[cse101], [cse102], [], winter, cse, ["3D Geometry"]).
course_information(cse560, "GPU Computing", [cse101], [cse102], [], winter, cse, ["Parallel Programming"]).
course_information(cse656, "Information Integration and Applications", [cse202], [cse102], [], monsoon, cse, ["Integrating Information", "Database Management"]).
course_information(cse508, "Information Retrieval", [cse202, cse201, cse102], [], [], winter, cse, ["Search Engines", "Information Retrieval"]).
course_information(cse528, "Introduction to Blockchain and cryptocurrency", [], [cse546], [], monsoon, cse, ["Blockchains", "Cryptocurrency"]).
course_information(cse525, "Introduction to Graduate Algorithms", [cse222], [], [], monsoon, cse,["Algorithms"]).
course_information(cse140, "Introduction to Intelligent Systems", [], [], [], winter, csai, ["Logic", "Artificial Intelligence"]).
course_information(cse571, "Introduction to Media Computing", [], [], [], monsoon, cse, ["Digital Representation"]).
course_information(cse101, "Introduction to Programming", [], [], [], monsoon, cse, ["Programming"]).
course_information(cse622, "Introduction to Quantum Computing", [mth100], [mth102],[], winter, cse, ["Quantum Computing"]).
course_information(cse555, "Introduction to Spatial Computing", [cse102, cse202], [], [], monsoon, cse, ["Spatial Computing"]).
course_information(cse343, "Machine Learning", [mth100, mth201, mth101], [], [], monsoon, csai, ["Research", "Machine Learning"]).
course_information(ece577, "Machine Learning Techniques for Real Time Control", [], [cse343, ece570], [], monsoon, cse, ["Machine Learning"]).
course_information(cse559, "Mining Large Networks",[cse222, cse101, mth201], [cse343], [], winter, cse,["Graphs", "Networks"]).
course_information(cse556, "Mobile and Middleware Systems", [cse535, cse232], [], [], monsoon, cse,["Mobile Systems"]).
course_information(cse535, "Mobile Computing", [cse101], [cse231, cse232], [], monsoon, cse, ["Mobile Systems", "Android Programming"]).
course_information(cse319, "Modern Algorithm Design", [cse232], [cse641], [], monsoon, cse, ["Algorithms"]).
course_information(cse563, "Multimedia Computing and Applications", [], [], [], winter, cse, ["Multimedia Computing"]).
course_information(cse694F, "Multimedia Security", [ece350], [], [], winter, cse,["Security", "Multimedia Computing"]).
course_information(cse556, "Natural Language Processing", [cse101, cse222, mth201, mth100], [], [], monsoon, csai, ["Natural Language Processing", "Deep Learning"]).
course_information(cse233, "Network Adminstration", [], [cse230], [], winter, cse, "Networks").
course_information(cse749, "Network Anonymity and Privacy", [], [], [], monsoon, cse, ["Networks", "Privacy"]).
course_information(cse655, "Network Science", [], [], [], winter, cse, ["Networks"]).
course_information(cse350, "Network Security", [], [], [], monsoon, cse, ["Networks", "Security"]).
course_information(cse354, "Network and System Security", [cse231, cse232], [], [], winter, cse, ["Networks", "Security"]).
course_information(cse231, "Operating Systems", [cse102], [], [], monsoon, cse, ["Operating Systems", "Kernels"]).
course_information(cse634, "Parallel Runtimes for Modern Processors",[cse201, cse231], [cse343], [], monsoon, cse, ["Parallel Processing"]).
course_information(cse645, "Privacy and Security in Online Social Media", [], [], [], winter, cse, ["Priavcy", "Security"]).
course_information(cse561, "Probabilistic Graphic Models", [mth201], [ece501], [], winter, cse, ["Probability"]).
course_information(cse503, "Program Analysis", [cse201, cse102], [cse322], [], monsoon, cse, ["Analysis"]).
course_information(cse584, "Program Verification", [mth210], [], [], monsoon, cse, ["Program Verification", "Correctness"]).
course_information(cse523, "Randomized Algorithms", [cse222, cse121, mth201], [], [], monsoon, cse,["Algorithms"]).
course_information(cse564, "Reinforcement Learning", [mth201], [], [], monsoon, csai, ["Reinforcement Learning"]).
course_information(cse633, "Robotics", [], [], [], winter, csai, ["Robotics"]).
course_information(cse552, "Security Engineering", [cse231], [], [], monsoon, cse, ["Security"]).
course_information(cse632, "Sematic Web", [cse101, cse202], [cse201], [], winter, cse, ["Web"]).
course_information(cse576, "Smart Sensing for Internet of Things", [], [], [], monsoon, csai, ["Internet Of Things"]).
course_information(cse565, "Software Defined Networking", [cse232], [], [], monsoon, cse, ["Networks"]).
course_information(cse583, "Software Development using Open Source", [], [], [], monsoon, cse, ["Open Source"]).
course_information(cse582, "Software Production Evolution and Maintenance",[], [], [], monsoon, cse, ["Software Cycle"]).
course_information(cse572, "Speech and Audio Processing", [mth100, ece250], [mth201, ece351], [], monsoon, cse,["Audio"]).
course_information(cse609, "Statistical Computation", [mth201], [], [], winter, cse, ["Statistics"]).
course_information(cse342, "Statistical Machine Learning", [cse101, mth201], [], [], winter, csai, ["Statistics", "Machine Learning"]).
course_information(cse322, "Theory Of Computation", [mth210], [], [], winter, cse, ["Automata Theory"]).
course_information(cse516, "Thories of Deep Learning", [], [mth100, mth203, cse343], [], winter, csai,["Deep Learning"]).
course_information(cse524, "Theory of Modern cryptography", [], [], [], monsoon, cse, ["Cryptography"]).
course_information(cse651, "Topics in Adaptive Cybersecurity", [cse345], [], [], monsoon, cse, ["Cybersecurity"]).
course_information(cse701, "Topics in SE: AI in SE", [], [], [], monsoon, cse, ["Artificial Intelligence"]).
course_information(cse660, "Trustworthy AI systems", [cse643, cse343], [], [], winter, csai, ["Artificial Intelligence"]).
course_information(cse570, "Virtual Reality", [], [], [], winter, cse, ["Virtual Reality"]).
course_information(cse538, "Wireless Networks", [cse232], [], [], winter, cse, ["Networks"]).



%ECE Courses
course_information(ece573, "Advanced Embedded Logic Design", [cse234], [], [], winter, ece, ["Embedded Logic"]).
course_information(ece315, "Analog CMOS Circuit Design",[], [], [], monsoon, ece, ["Circuit Design"]).
course_information(ece431, "Antennas Theory and Design", [ece230], [], [], monsoon, ece, ["Antenna"]).
course_information(ece581, "Autonomous Driving", [ece570], [], [], winter, ece, ["Autonomous Driving"]).
course_information(ece215, "Circuit Thoery and Design", [], [], [], monsoon, ece, ["Circuit Design"]).
course_information(ece554, "Compressive Sensing", [mth100], [], [], monsoon, ece, ["Compressive Sensing"]).
course_information(ece560, "Data Processing and Management", [], [], [cse201], monsoon, ece,["Data Processing"]).
course_information(ece111, "Digital Circuits", [], [], [], monsoon, ece, ["Circuits"]).
course_information(ece340, "Digital Communication Systems", [ece240], [], [], monsoon, ece, ["Communication Systems"]).
course_information(ece510, "Digital Hardware Design", [ece270], [], [], monsoon, ece, ["Hardware Design"]).
course_information(ece351, "Digital Signal Processing", [ece250], [],[], monsoon, ece, ["Signal Processing"]).
course_information(ece314, "Digital VLSI Design", [ece270], [], [], monsoon, ece, ["Vlsi Design"]).
course_information(ece270, "Embedded Logic Design", [], [], [], monsoon, ece, ["Logic Design"]).
course_information(ece230, "Fields and Waves", [mth100], [], [], winter, ece, ["Fields", "Waves"]).
course_information(ece522, "Integrated Circuit Fabrication",[], [], [], monsoon, ece, ["Circuit Design"]).
course_information(ece214, "Integrated Electronics", [ece111, ece113, des130], [], [], monsoon, ece, ["Electronics"]).
course_information(ece519, "Intelligent Application Implementation on Hetrogeneous Platforms", [cse112], [], [], monsoon, ece, ["Intelligent Systems"]).
course_information(ece517, "Introduction to Nanoelectronics", [], [], [], winter, ece, ["Nanoelectronics"]).
course_information(ece570, "Linear Systems Thoery", [], [], [], monsoon, ece, ["Linear Systems"]).
course_information(ece520, "Low Voltage Analog Circuit Design", [ece315], [], [], monsoon, ece,["Circuit Design"]).
course_information(ece611, "Memory Design and testing", [ece111, ece113], [], [], winter, ece, ["Memory Design"]).
course_information(ece612, "Mixed Signal Design", [ece315], [], [], winter, ece, ["Signal Processing"]).
course_information(ece343, "Mobile Communications", [ece240], [], [], winter, ece, ["Communication"]).
course_information(ece579, "Nonlinear and Adaptive Control of RObotic Systems", [], [],[], monsoon, ece, ["Robotics"]).
course_information(ece534, "Optical Communications Systems", [ece240], [], [], winter, ece, ["Communication Systems"]).
course_information(ece532, "Optical Fiber Networks for Industry", [], [], [], monsoon, ece, ["Fiber Networks"]).
course_information(ece571, "Optimal Control Systems", [], [], [], winter, ece, ["Control Systems"]).
course_information(ece545, "Photonics: Fundamentals & Applications",[ece230], [], [], monsoon, ece, ["Photonics"]).
course_information(ece543, "Principals of Digital Communication Systems", [ece240], [], [], monsoon, ece, ["Communication Systems"]).
course_information(ece240, "Principals of Communication Systems", [ece250, mth201], [], [], winter, ece, ["Communications Systems"]).
course_information(ece501, "Probability and Random Processes", [ece240], [], [], monsoon, ece, ["Random Process", "Probability"]).
course_information(ece524, "Quantum Materials and Devices", [], [], [], monsoon, ece, ["Quantum Computing"]).
course_information(ece432, "Radar Systems", [ece250], [], [], winter, ece,["Radar Systems"]).
course_information(ece321, "RF Circuit Design", [ece230], [], [], monsoon, ece, ["Circuits"]).
course_information(ece533, "Satellite Navigation and Sensor Fusion", [ece351], [], [], monsoon, ece, ["Satellites"]).
course_information(ece250, "Signals and Systems", [mth100], [], [], monsoon, ece, ["Signals"]).
course_information(ece318, "Solid State Devices", [], [],[], monsoon, ece, ["Solid State"]).
course_information(ece557, "Speech Recognition and Understanding", [ece250], [], [], winter, ece, ["Speech Recognition"]).
course_information(ece672, "Statistical Signal Processing", [mth100, mth201, ece250], [], [], winter, ece, ["Signal Processing", "Statistics"]).
course_information(ece513, "VLSI Design Flow", [ece101], [], [], monsoon, ece, ["Vlsi"]).
course_information(ece537, "Wireless Communication from 3G to 5G",[ece240], [], [], winter, ece, ["Wireless Communication"]).
course_information(ece538, "Wireless Networks", [ece232], [], [], winter, ece, ["Networks"]).
course_information(ece539, "Wireless System Implementation", [ece240], [], [], winter, ece, ["Wireless Systems"]).




%Maths Courses
course_information(mth212, "Abstract Algebra I", [], [], [mth302], winter, mth, ["Algebra"]).
course_information(mth513, "Abstract Algebra II", [mth100, mth212], [], [], winter, mth, ["Algebra"]).
course_information(mth510, "Advanced Linear Algebra", [mth100], [], [], winter, mth,["Algebra"]).
course_information(mth302, "Algebra", [], [], [mth212], monsoon, mth, ["Algebra"]).
course_information(mth512, "Algebraic Number Theory", [], [], [], monsoon, mth, ["Algebra", "Number Theory"]).
course_information(mth516, "Analytic Number Theory", [mth341], [], [], winter, mth, ["Number Theory"]).
course_information(mth544, "Calculas in R^N", [mth100, mth203], [],[], winter, mth, ["Calculas"]).
course_information(mth576, "Categorical Data Analysis", [mth201], [], [], monsoon, mth, ["Data Analysis"]).
course_information(mth514, "Coding Theory", [mth100, mth212, mth513], [], [], winter, mth, ["Programming"]).
course_information(mth517, "Combinatorial Optimization", [mth374], [], [], winter, mth, ["Optimization"]).
course_information(mth311, "Combinatorics and Its Applications",[mth100], [], [], winter, mth, ["Combinatorics"]).
course_information(mth341, "Complex Analysis", [mth240], [], [], monsoon, mth, ["Complex Numbers", "Analysis"]).
course_information(mth577, "Convex Optimization", [mth100], [], [], winter, mth, ["Convex Structures", "Optimization"]).
course_information(mth204, "Diffrential Equations", [mth203], [], [], winter, mth, ["Calculas"]).
course_information(mth210, "Discrete Structure", [], [], [cse121], monsoon, mth, ["Discrete Maths"]).
course_information(mth545, "Finite & SPectral Element Methods", [mth100, mth203, mth204], [], [], monsoon, mth,["Spectral Elements"]).
course_information(mth375, "Fluid Mechainics", [mth204], [], [], monsoon, mth, ["Fluid Mechanics"]).
course_information(mth310, "Graph Theory", [], [], [], winter, mth, ["Graphs"]).
course_information(mth571, "Integral Transforms", [mth204], [], [], winter, mth, ["Calculas"]).
course_information(mth343, "Introduction to Dynamical Systems", [], [],[], monsoon, mth, ["Dynamic Systems"]).
course_information(mth542, "Introduction to Functial Analysis", [mth100], [], [], winter, mth, ["Function Analysis"]).
course_information(mth300, "Introduction to Mathematical Logic", [], [], [], winter, mth, ["Logic"]).
course_information(mth550, "Introduction to PDE", [mth204], [], [], winter, ece, ["Calculas"]).
course_information(mth100, "Linear Algebra",[], [], [], monsoon, mth, ["Algebra"]).
course_information(mth374, "Linear Optimization", [mth100], [], [], winter, mth, ["Optimization"]).
course_information(mth203, "Multivariate Calculas", [], [], [mth240], monsoon, mth, ["Calculas"]).
course_information(mth211, "Number Theory", [], [], [], monsoon, mth, ["Number Theory"]).
course_information(mth270, "Numerical Methods", [mth100, mth204], [], [], monsoon, mth, ["Number Theory"]).
course_information(mth562, "Point Set Topology", [], [], [], monsoon, mth,["Point Sets"]).
course_information(mth201, "P&S", [], [], [], winter, mth, ["Probability", "Statistics"]).
course_information(mth240, "Real Analyisis", [], [], [mth203], monsoon, mth, ["Real Analysis"]).
course_information(mth340, "Real Analyisis", [mth240], [], [], monsoon, mth, ["Real Analysis"]).
course_information(mth372, "Statistical Inference", [mth201], [],[], monsoon, mth, ["Statistics"]).
course_information(mth518, "Topics in Number Theory", [mth211], [], [], monsoon, mth, ["Number Theory"]).




%Bio Courses
course_information(bio321, "Algorithms in Bioinformatics", [cse222], [], [], monsoon, bio, ["Bioinformatics"]).
course_information(bio524, "Biomedical Image Processing", [], [], [], monsoon, bio, ["Image Processing"]).
course_information(bio361, "Biophysics", [], [], [], monsoon, bio, ["Biophysics"]).
course_information(bio545, "Biostatistics", [], [], [], winter, bio,["Biostatistics"]).
course_information(bio211, "Cell Biology", [], [], [], monsoon, bio, ["Cells"]).
course_information(bio534, "Introduction to Computational Neuroscience", [], [], [bio505], winter, bio, ["Neuroscience"]).
course_information(bio213, "Introduction to Quantitative Biology", [mth100], [], [], winter, bio, ["Quanititive Biology"]).
course_information(bio531, "Introduction to Mathemaical Biology", [mth100], [],[bio303], winter, bio, ["Mathematical Biology"]).
course_information(bio542, "ML for biomedical applications", [], [cse343], [], monsoon, bio, ["Machine Learning"]).
course_information(bio532, "Network Biology", [], [], [], monsoon, bio, ["Networks"]).


%Des Courses
course_information(des506, "Advanced topics in Human Centered Computing", [des204], [], [], winter, des, ["Human Centered Computing"]).
course_information(des101, "Design Drawing and Visualization",[], [], [], winter, des, ["Visualization"]).
course_information(des509, "Design Futures", [des519], [], [], monsoon, des, ["Design Futures"]).
course_information(des519, "Design of Interactive Systems", [], [], [], monsoon, des, ["Interactive Systems"]).
course_information(des201, "Design Process and Perspectives", [des101], [], [], monsoon, des, ["Desgin Process"]).
course_information(des512, "Game design and Development", [], [], [], winter, des, ["Game Design"]).
course_information(des520, "Human Centered AI", [des204, cse343], [], [], monsoon, des,["Artificial Intelligence"]).
course_information(des204, "Human Computer Interaction", [], [], [cse501], winter, des, ["HCI"]).
course_information(des502, "Introduction to 2D animation", [des518], [], [], winter, des, ["Animation"]).
course_information(des302, "Introduction to Animation and Graphics", [], [], [], monsoon, des, ["Animation"]).
course_information(des102, "Introduction to HCI", [], [],[], winter, des, ["Hci"]).
course_information(des518, "Introduction to Motion Graphics", [des518], [], [], monsoon, des, ["Animation"]).
course_information(des130, "Prototyping Interactive Systems", [], [], [], monsoon, des, ["Interactive Systems"]).
course_information(des504, "Narratives in Visual Communication", [], [], [], winter, des, ["Visual Communication"]).
course_information(des202, "Visual Design and Communication",[des101], [], [], monsoon, des, ["Visual Communication"]).
course_information(des513, "WARDI", [], [], [], monsoon, des, ["Wearables"]).




%SSH Courses
course_information(ssh311, "Advanced Writing", [], [], [], winter, ssh, ["Writing"]).
course_information(ssh321, "Applied Ethics", [], [], [], winter, ssh, ["Ethics"]).
course_information(psy305, "Attention and Perception", [], [], [], winter, ssh, ["Psychology"]).
course_information(eco314, "Behavioroul Economics", [mth201], [], [], winter, ssh,["Economics"]).
course_information(psy301, "Cognitive Psychology", [], [], [psy201], winter, ssh, ["Psychology"]).
course_information(ssh124, "Critical Thinking", [], [], [ssh101], winter, ssh, ["Psychology"]).
course_information(soc206, "Business Anthropology", [], [], [], monsoon, ssh, ["Economics"]).
course_information(eco503, "Decision Theory", [], [],[], monsoon, ssh, ["Decision Theory"]).
course_information(eco221, "Econometrics I", [mth201], [], [eco302], monsoon, ssh, ["Economics"]).
course_information(eco322, "Econometrics II", [eco221], [], [], monsoon, ssh, ["Economics"]).
course_information(eco331, "Foundations of Finance", [], [], [fin401], winter, ssh, ["Finance", "Economics"]).
course_information(eco311, "Game Theory", [], [], [eco304], monsoon, ssh, ["Game Theory"]).
course_information(ssh121, "Introduction to Philosophy", [], [], [], monsoon, ssh,["Philosophy"]).
course_information(psy201, "Introduction to Psychology", [ssh101], [], [], monsoon, ssh, ["Psychology"]).
course_information(eco201, "Macroeconomics", [], [], [], monsoon, ssh, ["Economics"]).
course_information(psy306, "Learning and Memory", [], [], [], winter, ssh, ["Psychology"]).
course_information(eco301, "Microeconomics", [], [],[eco101], winter, ssh, ["Economics"]).
course_information(eco223, "Money and Banking", [], [], [], winter, ssh, ["Economics"]).
course_information(ssh323, "New Media and Politics", [], [], [], monsoon, ssh, ["Media", "Politics"]).
course_information(ssh324, "Philosophy of Mind", [ssh121], [], [], winter, ssh, ["Philosophy"]).
course_information(psy202, "Positive Psychology", [], [], [], winter, ssh, ["Psychology"]).
course_information(psy302, "Social Psychology", [], [], [], winter, ssh,["Psychology"]).
course_information(soc210, "Sociological Theory", [], [], [], winter, ssh, ["Psychology"]).
course_information(ssh211, "Theatre Appreciation", [], [], [hss211], monsoon, ssh, ["Theatre"]).
course_information(soc302, "Urban Sociology", [], [], [], winter, ssh, ["Sociology"]).


%Other Courses
course_information(ent416, "Creativity, Innovation, and Inventive Problem Solving", [], [],[], winter, oth, ["Problem Solving", "Enterpreunership"]).
course_information(ent411, "Entrepreneurial Communication", [], [], [], monsoon, oth, ["Entrepreneurship"]).
course_information(ent413, "Entrepreneurial Finance", [], [], [], winter, oth, ["Entrepreneurship"]).
course_information(esc205, "Environmental Sciences", [], [], [esc207A], monsoon, oth, ["Environment"]).
