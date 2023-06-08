import abc

import numpy as np


class NumpyClassifier(metaclass=abc.ABCMeta):
    @abc.abstractmethod
    def __init__(self, learning_rate=0.01, n_iters=1000, bias=True):
        self.weights = np.empty(0)
        self.bias = bias
        self.learning_rate = learning_rate
        self.n_iters = n_iters

    def add_bias(self, X):
        return np.c_[np.ones((X.shape[0], 1)), X]

    @abc.abstractmethod
    def predict(self, X):
        pass

    @abc.abstractmethod
    def loss(self, X, y):
        pass

    @abc.abstractmethod
    def train(self, X, y):
        pass
