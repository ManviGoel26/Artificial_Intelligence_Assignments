# Name: Manvi Goel
# Roll Number: 2019472


# Importing required libraries
from durable.lang import *


# Main RuleSet. -------------------------------------------------------------------------------------------------------------------
with ruleset('choice'):

    # Choice Sport
    @when_all((m.type == 'sports'))
    def sport(c):
        c.assert_fact({ 'subject': 'Choose', 'predicate' : 'activity', 'object' : 'sports' })
    

    # Choice Courses
    @when_all((m.type == 'course') & (m.time == 'short'))
    def course(c):
        c.assert_fact('course', {'time' : 'short', 'interests' : c.m.interests})

    
    @when_all((m.type == 'course') & (m.time == 'long'))
    def course(c):
        c.assert_fact('course', {'time' : 'long', 'interests' : c.m.interests})

    
    # Choice Extracurricular Activities
    @when_all((m.type == 'extracurricular activity') & (m.time == 'short'))
    def course(c):
        c.assert_fact('activities', {'time' : 'short', 'faculty' : c.m.faculty, 'interests' : c.m.interests})

    
    @when_all((m.type == 'extracurricular activity') & (m.time == 'intermediate'))
    def activity(c):
        c.assert_fact('activities', {'time' : 'intermediate', 'faculty' : c.m.faculty, 'interests' : c.m.interests})

    
    @when_all((m.type == 'extracurricular activity') & (m.time == 'long'))
    def activity(c):
        c.assert_fact('activities', {'time' : 'long', 'faculty' : c.m.faculty,  'interests' : c.m.interests})


    # Choice Both
    @when_all((m.type == 'any') & (m.time == 'short'))
    def course(c):
        c.assert_fact('club', {'interests' : c.m.interests})
        c.assert_fact('course', {'time' : 'short', 'faculty' : c.m.faculty, 'interests' : c.m.interests})
        c.assert_fact('activities', {'time' : 'short', 'faculty' : c.m.faculty, 'interests' : c.m.interests})

    
    @when_all((m.type == 'any') & (m.time == 'intermediate'))
    def activity(c):
        c.assert_fact('work', {'interests' : c.m.interests, 'work' : 'none'})
        c.assert_fact('club', {'interests' : c.m.interests}) 
        c.assert_fact('course', {'time' : 'intermediate', 'faculty' : c.m.faculty, 'interests' : c.m.interests})
        c.assert_fact('activities', {'time' : 'intermediate', 'faculty' : c.m.faculty, 'interests' : c.m.interests})
        
    
    @when_all((m.type == 'any') & (m.time == 'long'))
    def activity(c):
        c.assert_fact('work', {'interests' : c.m.interests})
        c.assert_fact('club', {'college_club' : 'information', 'interests' : c.m.interests})
        c.assert_fact('course', {'time' : 'long', 'faculty' : c.m.faculty, 'interests' : c.m.interests})
        c.assert_fact('activities', {'time' : 'long', 'faculty' : c.m.faculty,  'interests' : c.m.interests})
        

    # Choice Neither of them
    @when_all((m.type == 'none') & (m.time == 'long'))
    def none(c):
        c.assert_fact('club', {'interests' : c.m.interests})
        c.assert_fact('work', {'work' : 'none', 'interests' : c.m.interests})
        c.assert_fact({'subject': 'Choose', 'predicate' : 'activity', 'object' : 'volunteering' })
        
    @when_all((m.type == 'none') & (m.time == 'short'))
    def none(c):
        c.assert_fact({ 'subject': 'No', 'predicate' : 'suggested', 'object' : 'activities' })

    
    # Output if selected any facts
    @when_all(+m.subject)
    def output(c):
        print('Fact: {0} {1} {2}'.format(c.m.subject, c.m.predicate, c.m.object))

# Main RuleSet. -------------------------------------------------------------------------------------------------------------------



# Work RuleSet for internships and such -------------------------------------------------------------------------------------------
with ruleset('work'):
    @when_all((m.work == 'programming'))
    def program(c):
        c.assert_fact({'subject': 'Do', 'predicate' : 'internship', 'object' : 'software developer'})
        c.assert_fact({'subject': 'Do', 'predicate' : 'internship', 'object' : 'Open Source'})

    @when_all(m.work == 'machine_learning')
    def program(c):
        c.assert_fact({'subject': 'Do', 'predicate' : 'internship', 'object' : 'Data Analysis'})


    @when_all((m.work == 'none') | ((m.interests.anyItem((item.none >= 1)))))
    def program(c):
        c.assert_fact({'subject': 'Do', 'predicate' : 'internship', 'object' : 'PR'})
        c.assert_fact({'subject': 'Do', 'predicate' : 'internship', 'object' : 'management'})

    @when_all(m.work == 'design')
    def program(c):
        c.assert_fact({'subject': 'Do', 'predicate' : 'internship', 'object' : 'Game Design'})
        c.assert_fact({'subject': 'Do', 'predicate' : 'internship', 'object' : 'Web Design'})
    

    @when_all(m.work == 'leadership')
    def program(c):
        c.assert_fact({'subject': 'Do', 'predicate' : 'internship', 'object' : 'Product management'})
        c.assert_fact({'subject': 'Do', 'predicate' : 'internship', 'object' : 'Startup'})
        

    @when_all(m.work == 'langauge')
    def program(c):
        c.assert_fact({'subject': 'Do', 'predicate' : 'internship', 'object' : 'Translation'})
        c.assert_fact({'subject': 'Do', 'predicate' : 'internship', 'object' : 'Content Creation'})
            
    @when_all((m.interests.anyItem((item.teaching >= 1))))
    def program(c):
        c.assert_fact({'subject': 'Do', 'predicate' : 'internship', 'object' : 'Tutor'})
    

    @when_all((m.interests.anyItem((item.research  >= 1))))
    def program(c):
        c.assert_fact({'subject': 'Do', 'predicate' : 'internship', 'object' : 'Research internship'})

    @when_all((m.interests.anyItem((item.end >= 1))))
    def program(c):
        c.assert_fact({'feature': '-', 'feature' : '-', 'feature': '-'})

    @when_all(+m.subject)
    def output(c):
        print('Fact: {0} {1} {2}'.format(c.m.subject, c.m.predicate, c.m.object))

# Work RuleSet for internships and such -------------------------------------------------------------------------------------------

    
# Clubs RuleSet to suggest clubs from college -------------------------------------------------------------------------------------------
with ruleset('club'):
    @when_all(m.college_club == 'programming')
    def program(c):
        c.assert_fact({'subject': 'Join', 'predicate' : 'club', 'object' : 'ACM'})
        c.assert_fact({'subject': 'Join', 'predicate' : 'club', 'object' : 'Foobar'})
        c.assert_fact({'subject': 'Join', 'predicate' : 'club', 'object' : 'IEEE'})



    @when_all(m.college_club == 'machine_learning')
    def program(c):
        c.assert_fact({'subject': 'Join', 'predicate' : 'club', 'object' : 'BioBytes'})
        c.assert_fact({'subject': 'Join', 'predicate' : 'club', 'object' : 'Robotics'})
        c.assert_fact({'subject': 'Join', 'predicate' : 'club', 'object' : 'Electroholics'})


    @when_all((m.interests.anyItem((item.maths >= 1))))
    def program(c):
        c.assert_fact({'subject': 'Join', 'predicate' : 'club', 'object' : 'Evariste'})



    @when_all(m.college_club == 'information')
    def program(c):
        c.assert_fact({'subject': 'Join', 'predicate' : 'club', 'object' : 'Women In Tech'})
        c.assert_fact({'subject': 'Join', 'predicate' : 'club', 'object' : 'LeanIn'})

    @when_all(m.college_club == 'design')
    def program(c):
        c.assert_fact({'subject': 'Join', 'predicate' : 'club', 'object' : 'WASD'})
        c.assert_fact({'subject': 'Join', 'predicate' : 'club', 'object' : 'Design Hub'})

    
    @when_all(m.college_club == 'music')
    def program(c):
        c.assert_fact({'subject': 'Join', 'predicate' : 'club', 'object' : 'AudioBytes'})
        

    @when_all(m.college_club == 'travel')
    def program(c):
        c.assert_fact({'subject': 'Join', 'predicate' : 'club', 'object' : 'Tasweer'})
        c.assert_fact({'subject': 'Join', 'predicate' : 'club', 'object' : 'Salt n Pepper'})
        


    @when_all(m.college_club == 'dance')
    def program(c):
        c.assert_fact({'subject': 'Join', 'predicate' : 'club', 'object' : 'Madtoes'})



    @when_all((m.interests.anyItem((item.fashion >= 1))))
    def program(c):
        c.assert_fact({'subject': 'Join', 'predicate' : 'club', 'object' : 'Muse'})
        

    @when_all(m.college_club == 'leadership')
    def program(c):
        c.assert_fact({'subject': 'Join', 'predicate' : 'club', 'object' : 'Enactus'})
        c.assert_fact({'subject': 'Join', 'predicate' : 'club', 'object' : 'Girl Up'})
        

    @when_all(m.college_club == 'drawing')
    def program(c):
        c.assert_fact({'subject': 'Join', 'predicate' : 'club', 'object' : 'Meraki'})


    @when_all(m.college_club == 'theatre')
    def program(c):
        c.assert_fact({'subject': 'Join', 'predicate' : 'club', 'object' : 'Muse'})
        c.assert_fact({'subject': 'Join', 'predicate' : 'club', 'object' : 'Machaan'})
        

    @when_all(m.college_club == 'comedy')
    def program(c):
        c.assert_fact({'subject': 'Join', 'predicate' : 'club', 'object' : 'Mic Drop'})

    @when_all((m.interests.anyItem((item.philosophy >= 1))))
    def program(c):
        c.assert_fact({'subject': 'Join', 'predicate' : 'club', 'object' : 'PhiloSoc'})
        

    @when_all(m.college_club == 'langauge')
    def program(c):
        c.assert_fact({'subject': 'Join', 'predicate' : 'club', 'object' : 'LitSoc'})
            
    @when_all((m.interests.anyItem((item.finance >= 1))))
    def program(c):
        c.assert_fact({'subject': 'Join', 'predicate' : 'club', 'object' : 'Finnexia'})
        
    @when_all(m.college_club == 'quiz')
    def program(c):
        c.assert_fact({'subject': 'Join', 'predicate' : 'club', 'object' : 'Triviallis'})

    @when_all((m.interests.anyItem((item.end >= 1))))
    def program(c):
        c.assert_fact({'feature': '-', 'feature' : '-', 'feature': '-'})

    @when_all(+m.subject)
    def output(c):
        print('Fact: {0} {1} {2}'.format(c.m.subject, c.m.predicate, c.m.object))

# Clubs RuleSet to suggest clubs from college -------------------------------------------------------------------------------------------




# Courses RuleSet to suggest courses (from outside) -------------------------------------------------------------------------------------------
with ruleset('course'):
    
    @when_all((m.time == 'short') & (m.interests.anyItem((item.programming == 1))))
    def program(c):
        c.assert_fact('club', {'college_club' : 'programming'})
        c.assert_fact({'subject': 'Choose', 'predicate' : 'course', 'object' : 'Introductary programming'})

    @when_all((m.time == 'long') & (m.interests.anyItem((item.programming < 3))))
    def program(c):
        c.assert_fact('club', {'college_club' : 'programming'})
        c.assert_fact({'subject': 'Choose', 'predicate' : 'course', 'object' : 'Object Oriented programming'})

    @when_all((m.time == 'long') & (m.interests.anyItem((item.programming <= 3))))
    def program(c):
        c.assert_fact('work', {'work' : 'programming'})
        c.assert_fact({'subject': 'Choose', 'predicate' : 'course', 'object' : 'App Development'})

    @when_all((m.time == 'short') & (m.interests.anyItem((item.machine_learning == 1))))
    def ml(c):
        c.assert_fact('club', {'college_club' : 'machine_learning'})
        c.assert_fact({'subject': 'Choose', 'predicate' : 'course', 'object' : 'Introductary Machine Learning'})

    @when_all((m.time == 'long') & (m.interests.anyItem((item.machine_learning < 3))))
    def ml(c):
        c.assert_fact({'subject': 'Choose', 'predicate' : 'course', 'object' : 'Deep Learning and IoT'})

    @when_all((m.time == 'long') & (m.interests.anyItem((item.machine_learning <= 3))))
    def ml(c):
        c.assert_fact('club', {'college_club' : 'machine_learning'})
        c.assert_fact('work', {'work' : 'machine_learning'}) 
        c.assert_fact({'subject': 'Choose', 'predicate' : 'course', 'object' : 'Robotics'})
        
    @when_all((m.time == 'long') & (m.interests.anyItem((item.programming >= 1))))
    def program(c):
        c.assert_fact({'subject': 'Choose', 'predicate' : 'course', 'object' : 'Competetive programming'})

    @when_all((m.time == 'short') & (m.interests.anyItem((item.operating_systems < 3))))
    def program(c):
        c.assert_fact({'subject': 'Choose', 'predicate' : 'course', 'object' : 'Linux Development'})

    @when_all((m.time == 'long') & (m.interests.anyItem((item.none <= 3))))
    def any(c):
        c.assert_fact({'subject': 'Choose', 'predicate' : 'course', 'object' : 'Cloud Computing'})


    @when_all((m.time == 'short') & (m.interests.anyItem((item.design <= 3))))
    def any(c):
        c.assert_fact('club', {'college_club' : 'design'})
        c.assert_fact({'subject': 'Choose', 'predicate' : 'course', 'object' : 'Animation'})

    @when_all(((m.time == 'long') | (m.time == 'intermediate')) & (m.interests.anyItem((item.design <= 3))))
    def any(c):
        c.assert_fact('work', {'work' : 'design'})
        c.assert_fact({'subject': 'Choose', 'predicate' : 'course', 'object' : 'Game Design'})


    @when_all((m.time == 'short') & (m.interests.anyItem((item.none <= 3))))
    def any(c):
        c.assert_fact({'subject': 'Choose', 'predicate' : 'course', 'object' : 'Quantum Computing'})

    @when_all((m.time == 'short') & (m.interests.anyItem((item.none <= 3))))
    def any(c):
        c.assert_fact({'subject': 'Choose', 'predicate' : 'course', 'object' : 'Cognitive Computing'})


    @when_all((m.interests.anyItem((item.end >= 1))))
    def program(c):
        c.assert_fact({'feature': '-', 'feature' : '-', 'feature': '-'})

    @when_all(+m.subject)
    def output(c):
        print('Fact: {0} {1} {2}'.format(c.m.subject, c.m.predicate, c.m.object))
# Courses RuleSet to suggest courses (from outside) -------------------------------------------------------------------------------------------



# Activities RuleSet to suggest extracurricular activities -------------------------------------------------------------------------------------------
with ruleset('activities'):
    
    @when_all(((m.faculty == 'college') | (m.faculty == 'any'))  & ((m.time == 'long') | (m.time == 'intermediate') | (m.time == 'short')) & (m.interests.anyItem((item.games >= 1))))
    def games(c):
        c.assert_fact({'subject': 'Choose', 'predicate' : 'activity', 'object' : 'Chess'})
        c.assert_fact({'subject': 'Choose', 'predicate' : 'activity', 'object' : 'Poker'})

    @when_all(((m.faculty == 'any') | (m.faculty == 'college')) & ((m.time == 'long') | (m.time == 'intermediate')) & (m.interests.anyItem((item.leadership <= 3))))
    def leader(c):
        c.assert_fact('club', {'college_club' : 'leadership'})
        c.assert_fact('work', {'work' : 'leadership'})
        c.assert_fact({'subject': 'Choose', 'predicate' : 'activity', 'object' : 'Student Council'})
        c.assert_fact({'subject': 'Choose', 'predicate' : 'activity', 'object' : 'Community Project'})
        
    @when_all(((m.time == 'long') | (m.time == 'intermediate') | (m.time == 'short')) & (m.interests.anyItem((item.art >= 1))))
    def art(c):
        c.assert_fact('club', {'college_club' : 'drawing'})
        c.assert_fact({'subject': 'Choose', 'predicate' : 'activity', 'object' : 'Drawing'})
        c.assert_fact({'subject': 'Choose', 'predicate' : 'activity', 'object' : 'Painting'})
        

    @when_all((m.interests.anyItem((item.literature >= 1)) & ((m.time == 'long') | (m.time == 'intermediate'))))
    def lit(c):
        c.assert_fact('club', {'college_club' : 'langauge'})
        c.assert_fact('work', {'work' : 'langauge'})
        c.assert_fact({'subject': 'Choose', 'predicate' : 'activity', 'object' : 'debate'})
        c.assert_fact({'subject' : 'Choose', 'predicate' : 'activity', 'object' : 'book - reading'})
        c.assert_fact({'subject' : 'Choose', 'predicate' : 'activity', 'object' : 'Learning another langauge'})
        c.assert_fact({'subject' : 'Choose', 'predicate' : 'activity', 'object' : 'Poetry Appreciation'})
        


    @when_all((m.interests.anyItem((item.literature >= 1)) & (m.time == 'short')))
    def lit(c):
        c.assert_fact({'subject' : 'Choose', 'predicate' : 'activity', 'object' : 'book - reading'})
        c.assert_fact({'subject' : 'Choose', 'predicate' : 'activity', 'object' : 'Poetry Appreciation'})

    @when_all(((m.faculty == 'any') | (m.faculty == 'college')) & (m.interests.anyItem((item.performing <= 3))) & ((m.time == 'long') | (m.time == 'intermediate') | (m.time == 'short')))
    def act(c):
        c.assert_fact('club', {'college_club' : 'theatre'})
        c.assert_fact({'subject': 'Choose', 'predicate' : 'activity', 'object' : 'Theatre'})


    @when_all((m.faculty == 'any') & ((m.time == 'long') | (m.time == 'intermediate') | (m.time == 'short')) & (m.interests.anyItem((item.performing <= 3))) & (m.interests.anyItem(item.music > 2)))
    def act(c):
        c.assert_fact('club', {'college_club' : 'music'})
        c.assert_fact({'subject': 'Choose', 'predicate' : 'activity', 'object' : 'Band'})


    @when_all((m.faculty == 'any') & ((m.time == 'long') | (m.time == 'intermediate') | (m.time == 'short')) & (m.interests.anyItem((item.performing <= 3))) & (m.interests.anyItem(item.dance  >= 1)))
    def act(c):
        c.assert_fact('club', {'college_club' : 'dance'})
        c.assert_fact({'subject': 'Choose', 'predicate' : 'activity', 'object' : 'Dancing'})

    

    @when_all((m.faculty == 'any') & ((m.time == 'long') | (m.time == 'intermediate') | (m.time == 'short')) & (m.interests.anyItem((item.trivia >= 1))))
    def quiz(c):
        c.assert_fact('club', {'college_club' : 'quiz'})
        c.assert_fact({'subject': 'Choose', 'predicate' : 'activity', 'object' : 'Quizzing'})

    @when_all((m.faculty == 'any') & ((m.time == 'long') | (m.time == 'intermediate') | (m.time == 'short')) & (m.interests.anyItem((item.tourism >= 1))))
    def tourism(c):
        c.assert_fact('club', {'college_club' : 'travel'})
        c.assert_fact({'subject': 'Choose', 'predicate' : 'activity', 'object' : 'Photography'})

    @when_all((m.interests.anyItem((item.media >= 1))))
    def media(c):
        c.assert_fact({'subject': 'Choose', 'predicate' : 'activity', 'object' : 'Yearbook Committee'})
        c.assert_fact({'subject': 'Choose', 'predicate' : 'activity', 'object' : 'Local Newspaper'})
        c.assert_fact({'subject': 'Choose', 'predicate' : 'activity', 'object' : 'Blogs and Journels'})


    @when_all((m.faculty == 'any') & ((m.time == 'long') | (m.time == 'intermediate')) & (m.interests.anyItem((item.comedy <= 3))))
    def any(c):
        c.assert_fact('club', {'college_club' : 'comedy'})
        c.assert_fact({'subject': 'Choose', 'predicate' : 'activity', 'object' : 'Standup Comedy'})


    @when_all((m.faculty == 'any') & (m.interests.anyItem((item.none <= 3))))
    def any(c):
        c.assert_fact({'subject': 'Choose', 'predicate' : 'activity', 'object' : 'Cosplaying'})

    @when_all((m.faculty == 'any') & (m.interests.anyItem((item.none <= 3))) & ((m.time == 'long') | (m.time == 'intermediate')))
    def any(c):
        c.assert_fact({'subject': 'Choose', 'predicate' : 'activity', 'object' : 'Gardening'})


    @when_all((m.faculty == 'any') & ((m.time == 'long') | (m.time == 'intermediate') | (m.time == 'short')) &  (m.interests.anyItem((item.none <= 3))))
    def any(c):
        c.assert_fact({'subject': 'Choose', 'predicate' : 'activity', 'object' : 'Yoga'})

    @when_all((m.faculty == 'any') & ((m.time == 'long') | (m.time == 'intermediate') | (m.time == 'short')) & (m.interests.anyItem((item.none <= 3))))
    def any(c):
        c.assert_fact({'subject': 'Choose', 'predicate' : 'activity', 'object' : 'Self Defence'})


    @when_all((m.interests.anyItem((item.end >= 1))))
    def program(c):
        c.assert_fact({'feature': '-', 'feature' : '-', 'feature': '-'})

    @when_all(+m.subject)
    def output(c):
        print('Fact: {0} {1} {2}'.format(c.m.subject, c.m.predicate, c.m.object))

# Activities RuleSet to suggest extracurricular activities -------------------------------------------------------------------------------------------



# Input -----------------------------------------------------------------------------------------------------------------------------------------------------------
print("Welcome to Course and Extracurricular Activity Suggestion System\n")
type_ = input("Enter the type of activity: course, extracurricular activity, any (both), none (neither courses nor extracurricular activities): \n")
print()
time_duration = input("Enter the duration for activity: short (< 1 month), intermediate (1 < month < 3), long (month > 3): \n")
print()
faculty_ = input("Enter the location for activity: college* (available in college/ maintened by college), any (college or outside): \n")
print()

list_interest = [{'end' : 1}]
print("Enter interests and level at the interests. Enter 'end' to stop input\n")
print("Available options: comedy, design, games, music, dance, performing, trivia, tourism, media, leadership, art, literature, machine_learning, programming, operating_systems, teaching, research, maths, fashion, philosophy, finance")

for i in range(21):
    inter = input("Enter interest: ")

    if (inter == "end"):
        break

    num = int(input("Enter level (1, 2, 3): "))
    interest = {inter : num}
    list_interest.append(interest)
    print()

print()
# Input -----------------------------------------------------------------------------------------------------------------------------------------------------------


# Asserting the choices ---------------------------------------------------------------------------------------------------------------------------------------------------------
print("Suggestions: \n")
assert_fact('choice', {'type': type_, 'time': time_duration, 'faculty' : faculty_, 'interests' : list_interest})
# Asserting the choices ---------------------------------------------------------------------------------------------------------------------------------------------------------


# End
