
# coding: utf-8

# In[ ]:


# 결측 값을 채운 데이터 셋을 통해 학습시키는 모델
# 7000개의 data set

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
        # self.load_data()
#     def load_data(self):
#         xy_data_path = 'C:/python_ML/Kaggle/data/facial/xy_tdata_7000.npz'
#         self.xy_savez_load = np.load(xy_data_path)

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
        self.model.add(Dense(84, kernel_initializer='he_normal', use_bias=True, bias_initializer='he_normal', kernel_regularizer=regularizers.l2(0.01)))
        self.model.add(BatchNormalization(axis=-1))
        self.model.add(Activation('relu'))
        self.model.add(Dense(62, kernel_initializer='he_normal', use_bias=True, bias_initializer='he_normal', kernel_regularizer=regularizers.l2(0.01)))
        self.model.add(BatchNormalization(axis=-1))
        self.model.add(Activation('relu'))
        self.model.add(Dense(30, kernel_initializer='he_normal', use_bias=True, bias_initializer='he_normal', kernel_regularizer=regularizers.l2(0.01)))
        # mae(Mean Absolute Error)
        self.model.compile(optimizer = Adam(lr=0.001, beta_1=0.9, beta_2=0.999, epsilon=None, decay=0.0, amsgrad=False), loss='mse', metrics = ['mae'])
        self.model.summary()
    def training_model(self, file_name, xy_savez):
        csv_logger = CSVLogger(file_name + '.csv', separator=',', append=True)
        log = self.model.fit(xy_savez['xtn'], xy_savez['yt'], verbose=2, epochs=self.epoch, batch_size=10, validation_data=[xy_savez['xvn'], xy_savez['yv']], callbacks=[csv_logger])
        self.model.save(file_name + '.h5')

xy_data_path = 'C:/python_ML/Kaggle/data/facial/xy_tdata_7000.npz'
xy_savez_load = np.load(xy_data_path)

model3 = CNNmodel(200)
model3.build_model()
model3.training_model('model3_norm_7000_200', xy_savez_load)

