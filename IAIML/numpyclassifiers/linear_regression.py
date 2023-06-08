import abc

import numpy as np
from numpy_classifier import NumpyClassifier


class LinearRegression(NumpyClassifier):
    def __init__(self):
        super().__init__()

    def forward(self, X):
        return np.dot(X, self.weights) + self.bias

    def predict(self, X):
        return self.forward(X)

    def loss(self, y_pred, y):
        return np.mean((y_pred - y) ** 2)

    def gradient(self, X, y):
        return np.dot(X.T, (self.forward(X) - y)) / X.shape[0]

    def train(self, X, y):
        if self.bias:
            X = self.add_bias(X)

        self.weights = np.zeros(X.shape[1])

        for _ in range(self.n_iters):
            self.weights -= self.learning_rate * self.gradient(X, y)
