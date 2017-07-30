from keras.layers import Dense, Activation
from keras.models import Sequential
import numpy as np
import pandas as pd
from keras.models import load_model
import time

start = time.time()

#get the data
fullData = pd.read_csv('nonStringified.csv', quotechar='"').values #as_matrix()
print(fullData[0])
print(fullData.shape)
#fullData = np.genfromtxt('train.csv', delimiter=',', dtype=None, missing_values='')
survived = fullData[:,0]
other_data = fullData[:,1:7]


#setup the model
model = Sequential()
model.add(Dense(10, input_dim=6, activation='relu'))
model.add(Dense(12,init='uniform', activation='relu'))
model.add(Dense(8, init='uniform',  activation='relu'))
model.add(Dense(1, init='uniform', activation='sigmoid'))
#model.add(Activation('softmax'))

#compile it
model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])

#fit it
model.fit(other_data, survived, epochs =50000, batch_size=50, verbose=2)

#scores = model.evaluate(other_data, survived)
model.save('random_keras.h5')



# calculate predictions
predictions = model.predict(other_data)

# round predictions
rounded = [round(x[0]) for x in predictions]
print(rounded)





#print("\n%s: %.2f%%" % (model.metrics_names[1], scores[1]*100))





#daata = numpy.loadtxt('train.csv', delimiter =',')
#passId, survived, Pclass, Name, Sex, Age, SibSp, Parch, Ticket, Fare, Cabin, Embarked
end = time.time()
print(end-start)