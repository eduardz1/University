############################################################################################
# Copyright (C) 2024 by Sandro Cumani                                                      #
#                                                                                          #
# This file is provided for didactic purposes only, according to the Politecnico di Torino #
# policies on didactic material.                                                           #
#                                                                                          #
# Any form of re-distribution or online publication is forbidden.                          #
#                                                                                          #
# This file is provided as-is, without any warranty                                        #
############################################################################################

import numpy
import sklearn.datasets 

import matplotlib
import matplotlib.pyplot as plt

import scipy.linalg

def load_iris():

    import sklearn.datasets
    return sklearn.datasets.load_iris()['data'].T, sklearn.datasets.load_iris()['target']

def vcol(x):
    return x.reshape((x.size, 1))

def vrow(x):
    return x.reshape((1, x.size))

def compute_mu_C(D):
    mu = vcol(D.mean(1))
    C = ((D-mu) @ (D-mu).T) / float(D.shape[1])
    return mu, C

def compute_pca(D, m):

    mu, C = compute_mu_C(D)
    U, s, Vh = numpy.linalg.svd(C)
    P = U[:, 0:m]
    return P

def apply_pca(P, D):
    return P.T @ D
    

if __name__ == '__main__':

    D, L = load_iris()
    mu, C = compute_mu_C(D)
    print(mu)
    print(C)
    P = compute_pca(D, m = 4)
    print(P)
    PSol = numpy.load('IRIS_PCA_matrix_m4.npy') # May have different signs for the different directions
    print(PSol)
