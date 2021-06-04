This repository will be used to house code, data, and instructions for the paper "Assessing Noninvertibility and its Consequences in ML-Assisted
Time Series Prediction".

## Abstract

The flow of sufficiently smooth differential equations is (when it exists) invertible; 
yet it is easy to see that traditional numerical integrators used to approximate them can be *noninvertible*.
Neural network approximations of the time-$t$ map of nonlinear differential equations also suffer from this potential pathology.
In this work, we briefly review the possibly catastrophic consequences of such noninvertibility on the long-term dynamics prediction. Furthermore, we describe mathematical tools for the characterization of noninvertibility, equally applicable to numerical integrators *and* neural network approximators. Finally, we formulate and solve an optimization problem, in the form of a mixed-integer program (MIP), which quantifies the "safety" of the network dynamic predictions in terms of the distance, in several different norms, from two types of noninvertibility boundary.

## Contents
Below we list only the code entry points for reproducing key figures in the paper.

1. _Figure 1 (inset) (local invertibility of neural Networks; 1D example):_ **`one_D_example.m`**
2. _Figure 2, Figure 3 (top two); Figure 1 (supplemental) (parameter-dependent Brusselator network):_ **`para_dep_bru` folder**
3. _Figure 3 (bottom two) (timestep-dependent Brusselator network):_ **`ts_dep_bru` folder** 
4. _Figure 2 (supplemental) (invertible residual networks):_ **`iResNet` folder**

## License

MIT License

Copyright (c) [2021] [noninvertibility contributors]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
