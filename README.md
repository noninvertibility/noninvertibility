This repository will be used to house code, data, and instructions for the paper "Assessing Noninvertibility and its Consequences in ML-Assisted
Time Series Prediction".

## Abstract

The flow of sufficiently smooth differential equations is (when it exists) invertible; 
yet it is easy to see that traditional numerical integrators used to approximate them can be *noninvertible*.
Neural network approximations of the time-$t$ map of nonlinear differential equations also suffer from this potential pathology.
In this work, we briefly review the possibly catastrophic consequences of such noninvertibility on the long-term dynamics prediction. Furthermore, we describe mathematical tools for the characterization of noninvertibility, equally applicable to numerical integrators *and* neural network approximators. Finally, we formulate and solve an optimization problem, in the form of a mixed-integer program (MIP), which quantifies the "safety" of the network dynamic predictions in terms of the distance, in several different norms, from two types of noninvertibility boundary.

## Contents
1. _Local-Invertibility-of-Neural-Networks Local Invertibility of Neural Networks 1D example:_ Inset of Figure 1 (main), **"one_D_example.m"**
2. _Parameter-dependent Brusselator network:_ Figure 2 (main), Figure 3 (main, top two), Figure 1 (supporting materials) **"para_dep_bru" folder**
3. _Timestep-dependent Brusselator network:_ Figure 3 (main, bottom two) **"ts_dep_bru" folder** 
4. _Invertible residual networks:_ Figure 2 (supporting materials) **"iResNet" folder** 
