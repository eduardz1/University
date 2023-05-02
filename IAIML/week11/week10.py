"""
Module for programming exercises week 10.
"""

import numpy as np
import matplotlib.pyplot as plt
import tensorflow as tf
from tensorflow.keras import layers


def generateData(n=100):
    """
    Return a dataset.

    Parameters
    ----------
    n : int
        Number of examples in dataset.

    Returns
    -------
    dataset : tupple
        Dataset (x, y). x.shape = (n, 2), y.shape = (n, 2).
    """
    x1 = np.random.uniform(low=-np.pi, high=np.pi, size=(n, 1)).astype(np.float32)
    x2 = np.random.uniform(low=0, high=1, size=(n, 1)).astype(np.float32)

    y = np.empty((n, 2), dtype=float)
    y[:, 0] = np.sin(x1).flatten() + np.random.normal(loc=0, scale=0.05, size=n) + x2.flatten()
    y[:, 1] = np.cos(x1).flatten() + np.random.normal(loc=0, scale=0.05, size=n) + x2.flatten()

    return (np.concatenate((x1, x2), axis=1), y)


def set_axis_style(ax, n_layers):
    """
    Helper function. Adapted from:
    https://matplotlib.org/3.1.1/gallery/statistics/customized_violin.html#sphx-glr-gallery-statistics-customized-violin-py
    """
    ax.get_xaxis().set_tick_params(direction='out')
    ax.xaxis.set_ticks_position('bottom')
    ax.set_xticks(np.arange(1, n_layers + 1))
    ax.set_xlim(0.25, n_layers + 0.75)


def plot_grad(model):
    """
    Plot histogram of gradients for the weights in each layer of model.
    """
    (inputs, targets) = generateData(100)

    loss = tf.losses.MeanSquaredError()
    with tf.GradientTape(persistent=True) as tape:
        pred = model(inputs, training=True)

        loss_list = []
        for y_hat, y in zip(pred, targets):
            loss_list.append(loss(y, y_hat))

    grads_list = []
    for loss_value in loss_list:
        grads_list.append(tape.gradient(loss_value, model.trainable_variables))

    del tape # Tape is set to persisten so we explicitly drop it here.

    grad_data = []
    for i, layer_grads in enumerate(zip(*grads_list)):
        if i%2 == 1:
            continue

        grad_list_flat = np.array([grad for grad in layer_grads]).flatten()
        grad_data.append(grad_list_flat)

    fig, ax = plt.subplots()
    ax.violinplot(grad_data)

    ax.grid()
    set_axis_style(ax, len(model.layers))
    ax.set_xlabel("Layer")
    ax.set_ylabel("Gradient values")

    return fig
