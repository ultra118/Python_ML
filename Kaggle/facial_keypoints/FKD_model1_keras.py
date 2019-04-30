
# coding: utf-8

# In[1]:


from keras.models import Sequential
from keras.layers import Dense, Conv2D, Flatten, AvgPool2D, BatchNormalization, Dropout, Activation, MaxPool2D
from keras.optimizers import Adam
from keras import regularizers
import numpy as np
from keras.models import load_model
from keras.callbacks import CSVLogger
from keras.backend.tensorflow_backend import set_session
import tensorflow as tf

config = tf.ConfigProto()
#동적으로 gpu memory 할당할 수 있게
config.gpu_options.allow_growth = True
# to log device placement (on which device the operation ran)
config.log_device_placement = True
sess = tf.Session(config=config)
# Tensorflow session을 Keras default session으로 set
set_session(sess)


class CNNmodel:
    def __init__(self, epoch):
        self.epoch = epoch
        self.load_data()
    def load_data(self):
        xy_data_path = 'C:/python_ML/Kaggle/data/facial/xy_tdata.npz'
        self.xy_savez_load = np.load(xy_data_path)

    def build_model(self):
        self.model = Sequential()
        # 첫번째 layer는 input_shape을 줘야함
        # filter, kernel size, activation, initializers(he_normal은 정규분포로 부터 표본)
        self.model.add(Conv2D(72, (4, 4), input_shape=(96, 96, 1), use_bias=False, kernel_initializer='he_normal', kernel_regularizer=regularizers.l2(0.01)))
        self.model.add(BatchNormalization(axis=-1))
        self.model.add(Activation('relu'))
        self.model.add(AvgPool2D(pool_size=(2, 2)))
        self.model.add(Conv2D(48, (2, 2), use_bias=False, kernel_initializer='he_normal', kernel_regularizer=regularizers.l2(0.01)))
        self.model.add(BatchNormalization(axis=-1))
        self.model.add(Activation('relu'))
        self.model.add(Flatten())
        self.model.add(Dropout(0.5))
        self.model.add(Dense(72, kernel_initializer='he_normal', use_bias=True, bias_initializer='he_normal', kernel_regularizer=regularizers.l2(0.01)))
        self.model.add(BatchNormalization(axis=-1))
        self.model.add(Activation('relu'))
        self.model.add(Dense(30, kernel_initializer='he_normal', use_bias=True, bias_initializer='he_normal', kernel_regularizer=regularizers.l2(0.01)))
        # mae(Mean Absolute Error)
        self.model.compile(optimizer=Adam(0.001), loss='mse', metrics=['mae'])

    def training_model(self):
        csv_logger = CSVLogger('model1.log', separator=',', append=True)
        log = self.model.fit(self.xy_savez_load['xtn'], self.xy_savez_load['yt'], verbose=2, epochs=self.epoch, batch_size=5, validation_data=[self.xy_savez_load['xvn'], self.xy_savez_load['yv']], callbacks=[csv_logger])
        self.model.save('model1.h5')


model1 = CNNmodel(150)
model1.build_model()
model1.training_model()