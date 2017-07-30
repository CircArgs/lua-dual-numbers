from keras.models import load_model
import numpy as np
import pandas as pd


#modify helper function to transform test data
import csv

def transformcsv(in_name, out_name):
	with open(in_name, 'r') as csvfile:
		with open(out_name, 'w', newline='') as writeFile:
			reader = csv.DictReader(csvfile)
			field_names = ['PassengerId', 'pClass', 'sex', 'age', 'SiblingsOrSpouse', 'ParentOrChildren', 'Fare']
			writer = csv.DictWriter(writeFile, field_names)
			writer.writeheader()
			for row in reader:
				sex = 0
				age = row['Age']
				if(row['Sex'] == 'male'):
					sex = 1
				if(age in (None, "")):
					age = 0
				writer.writerow({'PassengerId': row['PassengerId'], 'pClass': row['Pclass'], 'sex': sex, 'age': age, 'SiblingsOrSpouse': row['SibSp'], 'ParentOrChildren' : row['Parch'], 'Fare': row['Fare']})



transformcsv('test.csv', 'test_non_stringified.csv')

model = load_model('random_keras.h5')

fullData = pd.read_csv('test_non_stringified.csv', quotechar='"').values #as_matrix()
print(fullData[0])

other_data = fullData[:,1:7]
predictions = model.predict(other_data)

with open('test_out.csv', 'w', newline='') as writeFile:
    field_names = ['PassengerId', 'Survived']
    writer = csv.DictWriter(writeFile, field_names)
    writer.writeheader()
    count = 0
    for prediction in predictions:
        writer.writerow({'PassengerId': int(fullData[count][0]), 'Survived': int(round(prediction[0]))})
        count+=1