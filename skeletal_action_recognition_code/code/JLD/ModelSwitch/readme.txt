

Before you start using any of the functions, please make sure you have downloaded 
and installed cvx toolbox from:

http://www.stanford.edu/%7Eboyd/cvx/download.html

Sparsification code:

Test files: hyperplane_test.m, dynamic_regressor_test.m

Functions:

**********************************************************
- Affine Hyperplane Segmentation (not passing thru origin)

group = l1_switch_detect(data,norm_used,epsilon)

inputs:

data : m by n matrix where m is the number of data points and n is the
dimension of data (this implementation is a bit inefficient, i have a more
efficient one which I could not find at the moment. if you get memory errors
do a dimensionality reduction to your data. on a 2gb machine largest data
I tried was 850x30, and it works..)

norm_used : inf, 1, 2, ... Norm by which the noise is measured

epsilon	: noise level

output:

group: m by 1 vector showing the labels

**********************************************************



**********************************************************
- Dynamic Segmentation

y(t) = \sum_{i=1}^{order}a_i*y(t-i) + f_i(t)

For multioutput data, assume all coordinates evolve independently


(fit affine model)
group = indep_dyn_switch_detect_offset(data,norm_used,epsilon,order)

(fit linear model, without f_i)
group = indep_dyn_switch_detect(data,norm_used,epsilon,order)


inputs:

data : t by n matrix where t is the number of time instants and n is the
dimension of data (y \in R^n)

norm_used : inf, 1, 2, ... Norm by which the noise is measured

epsilon	: noise level

order: order of the regressor


output:

group: (m-order) by 1 vector showing the labels

**********************************************************



Additional tips:

If you want to see what the solver is doing, you can comment out the lines
cvx_quiet(true); cvx_quiet(false). 

If the solver complains, increasing delta (the regularization constant in
reweighted l1 approximation) helps.
