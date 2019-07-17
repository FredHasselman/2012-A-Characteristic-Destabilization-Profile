# Data, analysis scripts and supplementary materials for:

> [Lichtwarck-Aschoff, A., Hasselman, F., Cox, R., Pepler, D., & Granic, I. (2012). A Characteristic Destabilization Profile in Parent-Child Interactions Associated with Treatment Efficacy for Aggressive Children. *Nonlinear Dynamics Psychology and Life Sciences, 16(3)*, 353-379.](
https://www.researchgate.net/profile/Fred_Hasselman/publication/225306593_A_Characteristic_Destabilization_Profile_in_Parent-Child_Interactions_Associated_with_Treatment_Efficacy_for_Aggressive_Children/links/0046352b1edb89a44d000000.pdf)

## **Requirements**

Open the Matlab file: `EntropyPeak_NDPLS.m`. Running it will reproduce the results reported in the paper. However, it is important that the correct files, scripts and software (MPlus) are avalilable to the script.

### RAW DATA FILE:

* `TS_5s.txt`

### MATLAB CODE BY AUTHORS

* `catrqa.m`   - Performs categorical qa on an rp matrix; depends on Marwan's Toolbox `tt.m`, `dl.m`
* `writeS2T.m` - Write a structure to a tab-delimited file
* `writeM2T.m` - Write a matrix to a tab-delimited file
* `grab.m`     - Grab the current figure to EPS file

### MATLAB CODE BY OTHERS

* `dl.m` - NOT INCLUDED IN THE ARCHIVE Download and install Marwan's toolbox: http://www.agnld.uni-potsdam.de/~marwan/toolbox/ 
* `tt.m` - NOT INCLUDED IN THE ARCHIVE Download and install Marwan's toolbox: http://www.agnld.uni-potsdam.de/~marwan/toolbox/
* `keep.m` - Reverse of clear; Minor adjustment to scripts by Martin Barugel and Xiaoning Yang

### MPLUS DEMO (TESTED ON MAC OSX)

* `mpdemo` - NOT INCLUDED IN THE ARCHIVE Download and install from the Mplus site: http://www.statmodel.com/demo.shtml
* `Mplus_CRQA_ENT.inp` - Mplus input file


> Compiled and programmed by Fred Hasselman (me@fredhasselman.com) - December 2011

