# Name: Manvi Goel
# Roll No: 2019472

# Importing Libraries
import spacy
import nltk
from pyswip import Prolog



# Prolog and consulting the advisory.
swipl = Prolog()
swipl.consult("C:/Users/HP/Desktop/Manvi/Semesters/5_MonsoonSemester2021/Artificial Intelligence/AI-A5-Manvi Goel-2019472/ElectivesAdvisory_.pl")


# NLI
# Finding Interests.

# Opening Input File.
with open("input.txt", mode = "r", encoding = "utf-8") as file:
	text = file.read()

text = text.lower()

# NLP Operations
nlp = spacy.load("en_core_web_sm")
sw_spacy = nlp.Defaults.stop_words

# Splitting into sentences
sentences = nltk.sent_tokenize(text)

# Finding branch.
sen1 = sentences[0]
tokens = nlp(sen1)
# print()

for token in tokens:
	print(token, token.pos_)
	if (token.pos_ == "PROPN"):
		branch = token.text

branch = str(branch).lower()


# Finding Semester: Winter/ Monsoon
sen2 = sentences[1]
new_sen2 = nltk.word_tokenize(sen2)

for word in new_sen2:
	if (word.lower() == "winter" or word.lower() == "monsoon"):
		sem = word.lower()
	
# print(sem)

# Finding Previous done courses.
sen3 = sentences[2]

# check for not or first
prereq = []
no_prereq = False
sen3_tokens = nltk.word_tokenize(sen3)
for word in sen3_tokens:
	if (word == "first" or word == "not" or word == "n't"):
		no_prereq = True

# Write all the courses done
if (not no_prereq):
	doc = nlp(sen3)
	for token in doc:
		if token.pos_ == "PROPN":
			prereq.append(token.text)			

# print(prereq)

# Finding the branches for electives.
sen4 = sentences[3]
branch_reqs = []
doc = nlp(sen4)

for token in doc:
	if (token.text == "other" or token.text == "others"):
		branch_reqs.append("oth")

	if token.pos_ == "PROPN":
		branch_reqs.append(token.text)	

# print(branch_reqs)		

# Finding Interests.
sen_ints = ""
for sentence in sentences[4:]:
	sen_ints += " " + sentence


interests = []
doc = nlp(sen_ints)

for token in doc:
	# Different rules for different formats.
	if token.pos_ == "NOUN":
		if (token.dep_ == "compound"):
			interests.append(token.lemma_ + " " + token.head.lemma_)
		else:
			interests.append(token.lemma_)

	if token.pos_ == "ADJ" and token.head.pos_ == "NOUN":
		interests.append(token.lemma_ + " " + token.head.lemma_)

# Correcting the font to match the prolog database.
final_interests = []
for interest in interests:
	corr_word = ""
	for word in interest.split(" "):
		word = word[0].upper() + word[1:]
		corr_word += " " + word
	final_interests.append(corr_word.strip())

# print(final_interests)

# Helper Function to change list into required string format
def l2s(list_):
	
	if (len(list_) == 0):
		return "[]"

	string = list_[0]
	for item in range(1, len(list_)):
		string += " ," + list_[item]

	return "[ " + string + "]"

# Assert likes
for interest in final_interests:
	swipl.assertz('likes("%s")' % (interest, ))

print()
# Query for courses
courses = list(swipl.query('main(%s, %s, %s, %s, Course)' % (branch, sem, l2s(prereq), l2s(branch_reqs))))


print()
print("The suggested electives are: ")
for course in courses:
	print(course)



# Assumptions: 1st line: branch, 2nd line: semester, 3rd line courses done, rest interests. 


 