
# coding: utf-8

# In[1]:


from keras.models import Sequential
from keras.layers import Dense, Conv2D, Flatten, AvgPool2D, BatchNormalization, Dropout, Activation, MaxPool2D
from keras.optimizers import Adam
from keras import regularizers
import numpy as np
from keras.models import load_model
from keras.callbacks import CSVLogger

xy_savez_load = np.load('../data/facial/xy_tdata.npz')

model = Sequential()
# 첫번째 layer는 input_shape을 줘야함
# filter, kernel size, activation, initializers(he_normal은 정규분포로 부터 표본)
model.add(Conv2D(72, (4,4), input_shape = (96,96,1), use_bias = False, kernel_initializer='he_normal', kernel_regularizer = regularizers.l2(0.01)))
model.add(BatchNormalization(axis = -1))
model.add(Activation('relu'))
model.add(AvgPool2D(pool_size=(2,2)))
model.add(Conv2D(48, (2,2), use_bias = False,  kernel_initializer='he_normal', kernel_regularizer = regularizers.l2(0.01)))
model.add(BatchNormalization(axis = -1))
model.add(Activation('relu'))
model.add(Flatten())
model.add(Dropout(0.5))
model.add(Dense(48, kernel_initializer = 'he_normal', use_bias = True, bias_initializer = 'he_normal', kernel_regularizer = regularizers.l2(0.01)))
model.add(BatchNormalization(axis = -1))
model.add(Activation('relu'))
model.add(Dense(30, kernel_initializer = 'he_normal', use_bias = True, bias_initializer = 'he_normal', kernel_regularizer = regularizers.l2(0.01)))
# mae(Mean Absolute Error)
model.compile(optimizer = Adam(0.01), loss='mse', metrics=['mae'])

csv_logger = CSVLogger('model1.log', separator=',', append=True)
log = model.fit(xy_savez_load['xtn'], xy_savez_load['yt'], epochs = 100, batch_size = 5, validation_data= [xy_savez_load['xvn'],xy_savez_load['yv']], callbacks = [csv_logger])


model.save('model1.h5')
# model = load_model('model1_h5')
#keras.callbacks.CSVLogger('model1log.csv', separator=',', append=False)
# csv_logger = CSVLogger('training.log')
# model.fit(X_train, Y_train, callbacks=[csv_logger])


# In[3]:


log

