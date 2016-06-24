This code is implementation of the following paper:

Xikang Zhang, Yin Wang, Mengran Gou, Mario Sznaier, and Octavia Camps: Efficient Temporal Sequence Comparison and Classification using Gram Matrix Embeddings On a Riemannian Manifold, CVPR 2016

Project website page:
http://robustsystems.coe.neu.edu/sites/robustsystems.coe.neu.edu/files/systems/projectpages/cvpr16gram.html

Prerequisites:
MSR3dAction and UTKinect datasets are with this code. But for the datasets MHAD and HDM05, you need to download by yourself before you can use them. The download websites are:
HDM05 (http://resources.mpi-inf.mpg.de/HDM05)
MHAD (http://tele-immersion.citris-uc.org/berkeley_mhad)

The parser code for HDM05 is:
GramRiemannian/matlab/dataGeneration/parseHDM05.m
The parser code for MHAD datasets is:
GramRiemannian/skeleton_data/MHAD/parseMHAD.m

You need to set up the correct path before running the parser code.


The main function “skeletal_action_classification.m” is in the folder “matlab”. It is used in the following way:

% skeletal_action_classification(dataset_idx)
% dataset_idx is set:
% 1 if UTKinect
% 2 if MHAD
% 3 if MSRAction3D
% 4 if HDM05

Author:
Xikang Zhang (zhangxk@ece.neu.edu)