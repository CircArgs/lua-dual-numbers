import csv

def transformcsv(in_name, out_name):
	with open(in_name, 'r') as csvfile:
		with open(out_name, 'w') as writeFile:
			reader = csv.DictReader(csvfile)
			field_names = ['survived', 'pClass', 'sex', 'age', 'SiblingsOrSpouse', 'ParentOrChildren', 'Fare']
			writer = csv.DictWriter(writeFile, field_names)
			writer.writeheader()
			for row in reader:
				sex = 0
				age = row['Age']
				if(row['Sex'] == 'male'):
					sex = 1
				if(age in (None, "")):
					age = 0
				writer.writerow({'survived': row['Survived'], 'pClass': row['Pclass'], 'sex': sex, 'age': age, 'SiblingsOrSpouse': row['SibSp'], 'ParentOrChildren' : row['Parch'], 'Fare': row['Fare']})