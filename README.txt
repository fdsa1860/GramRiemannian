This code is implementation of the following paper:

Xikang Zhang, Yin Wang, Mengran Gou, Mario Sznaier, and Octavia Camps: Efficient Temporal Sequence Comparison and Classification using Gram Matrix Embeddings On a Riemannian Manifold, CVPR 2016

Project website page:
http://robustsystems.coe.neu.edu/sites/robustsystems.coe.neu.edu/files/systems/projectpages/cvpr16gram.html

The data for MSR, MHAD and UTKinect is with this code. The parser code for HDM05 dataset is given, but you need download the data by yourself. (http://resources.mpi-inf.mpg.de/HDM05)

The main function “skeletal_action_classification.m” is in the folder “matlab”. It is used in the following way:

% skeletal_action_classification(dataset_idx)
% dataset_idx is set:
% 1 if UTKinect
% 2 if MHAD
% 3 if MSRAction3D
% 4 if HDM05

Author:
Xikang Zhang (zhangxk@ece.neu.edu)