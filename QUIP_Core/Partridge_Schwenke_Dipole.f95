#include "error.inc"


module partridge_schwenke_dipole_module

use error_module
use system_module, only : dp, print, inoutput, optional_default, system_timer, operator(//), system_abort
use units_module

implicit none
private

public :: dipole_moment_PS, dipole_moment_gradients_PS

real(dp) :: coef(823)
integer ::i, idx(823,3)
data (idx(i,1),i=1,823 )/ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, &
 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,  &
 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4,  &
 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5,  &
 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 7,  &
 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8,  &
 8, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9,10,10,10,10,10,10,10,10,10,10,  &
11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11, 1, 1, 1, 1,  &
 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2,  &
 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,  &
 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5,  &
 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,  &
 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 8, 8, 8, 8, 8, 8, 8, 8,  &
 8, 8, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9,10,10,10,10,10,10,10,10,10, 1,  &
 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2,  &
 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,  &
 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5,  &
 5, 5, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 7,  &
 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 9, 9, 9,  &
 9, 9, 9, 9, 9, 9, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,  &
 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3,  &
 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5,  &
 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 7,  &
 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 8, 8, 8, 8, 8, 8, 8, 8, 1, 1, 1, 1,  &
 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,  &
 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4,  &
 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6,  &
 6, 6, 6, 6, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 1, 1, 1, 1, 1, 1, 1, 1,  &
 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3,  &
 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5,  &
 5, 5, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 1, 1, 1, 1, 1,  &
 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3,  &
 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5,  &
 5, 5, 5, 5, 5, 5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2,  &
 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4,  &
 4, 4, 4, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2,  &
 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,  &
 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1/  
data (idx(i,2),i=1,823 )/ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, &
 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,  &
 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,  &
 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,  &
 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,  &
 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,  &
 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,  &
 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2,  &
 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,  &
 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,  &
 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,  &
 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,  &
 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,  &
 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3,  &
 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,  &
 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,  &
 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,  &
 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,  &
 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,  &
 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,  &
 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,  &
 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,  &
 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,  &
 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5,  &
 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,  &
 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,  &
 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,  &
 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6, 6, 6,  &
 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,  &
 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,  &
 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 7, 7, 7, 7,  &
 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,  &
 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,  &
 7, 7, 7, 7, 7, 7, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8,  &
 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8,  &
 8, 8, 8, 8, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9,  &
 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9,10,10,10,10,10,10,10,10,10,10,  &
10,10,10,10,10,10,10,10,10,11,11,11,11,11,11,11,11,11/ 
data (idx(i,3),i=1,823)/ 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14, &
15,16,17,18,19, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,17,  &
18, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,17, 1, 2, 3, 4,  &
 5, 6, 7, 8, 9,10,11,12,13,14,15,16, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,  &
11,12,13,14,15, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14, 1, 2, 3,  &
 4, 5, 6, 7, 8, 9,10,11,12,13, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,  &
 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11, 1, 2, 3, 4, 5, 6, 7, 8, 9,10, 1,  &
 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,17,18, 1, 2, 3, 4, 5,  &
 6, 7, 8, 9,10,11,12,13,14,15,16,17,18, 1, 2, 3, 4, 5, 6, 7, 8, 9,  &
10,11,12,13,14,15,16,17, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,  &
15,16, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15, 1, 2, 3, 4, 5,  &
 6, 7, 8, 9,10,11,12,13,14, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,  &
 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,  &
11, 1, 2, 3, 4, 5, 6, 7, 8, 9,10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 1, 2,  &
 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,17, 1, 2, 3, 4, 5, 6, 7,  &
 8, 9,10,11,12,13,14,15,16, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,  &
14,15, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14, 1, 2, 3, 4, 5, 6,  &
 7, 8, 9,10,11,12,13, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12, 1, 2, 3,  &
 4, 5, 6, 7, 8, 9,10,11, 1, 2, 3, 4, 5, 6, 7, 8, 9,10, 1, 2, 3, 4,  &
 5, 6, 7, 8, 9, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16, 1,  &
 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15, 1, 2, 3, 4, 5, 6, 7, 8,  &
 9,10,11,12,13,14, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13, 1, 2, 3,  &
 4, 5, 6, 7, 8, 9,10,11,12, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11, 1, 2,  &
 3, 4, 5, 6, 7, 8, 9,10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 1, 2, 3, 4, 5,  &
 6, 7, 8, 9,10,11,12,13,14,15, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,  &
13,14, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13, 1, 2, 3, 4, 5, 6, 7,  &
 8, 9,10,11,12, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11, 1, 2, 3, 4, 5, 6,  &
 7, 8, 9,10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 1, 2, 3, 4, 5, 6, 7, 8, 9,  &
10,11,12,13,14, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13, 1, 2, 3, 4,  &
 5, 6, 7, 8, 9,10,11,12, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11, 1, 2, 3,  &
 4, 5, 6, 7, 8, 9,10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 1, 2, 3, 4, 5, 6,  &
 7, 8, 9,10,11,12,13, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12, 1, 2, 3,  &
 4, 5, 6, 7, 8, 9,10,11, 1, 2, 3, 4, 5, 6, 7, 8, 9,10, 1, 2, 3, 4,  &
 5, 6, 7, 8, 9, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12, 1, 2, 3, 4, 5,  &
 6, 7, 8, 9,10,11, 1, 2, 3, 4, 5, 6, 7, 8, 9,10, 1, 2, 3, 4, 5, 6,  &
 7, 8, 9, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11, 1, 2, 3, 4, 5, 6, 7, 8,  &
 9,10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 1, 2, 3, 4, 5, 6, 7, 8, 9,10, 1,  &
 2, 3, 4, 5, 6, 7, 8, 9, 1, 2, 3, 4, 5, 6, 7, 8, 9/  
data (coef(i),i=1,296 )/3.3059356035504D-01,-6.5251838873142D-02, &
  4.1240972465648D-02, -2.2116144218802D-02,  1.2580837420455D-02,  &
  7.8310787716761D-03,  2.2288047625127D-02, -1.3669697654061D-01,  &
  2.4937882844205D-02,  4.3657889120529D-01, -4.6471342590799D-01,  &
 -5.5058444686450D-01,  1.5887018737408D+00, -6.5038773968250D-01,  &
 -1.9774754735667D+00,  2.3124888370313D+00,  3.8251566080155D-01,  &
 -1.6334099937156D+00,  6.2881257157520D-01, -1.8927984910357D-01,  &
 -7.2499911946761D-02, -3.1228675269345D-02, -5.6242287160400D-02,  &
 -1.3290140915015D-02, -1.1339837953158D-01,  4.1911643453876D-01,  &
  1.0878140964594D+00, -2.1578445557330D+00, -6.0750507724534D+00,  &
  9.1561006195652D+00,  1.3224003890557D+01, -2.0748430357416D+01,  &
 -1.0449365066054D+01,  2.1628595870529D+01, -4.2431457957766D-01,  &
 -7.5571164522298D+00,  2.0524343250386D+00,  5.5868906350997D-01,  &
 -5.9721805154700D-02,  9.3334456754609D-02,  1.0923671353769D-01,  &
 -3.3757729524242D-03, -8.1955430151354D-01,  5.6496735493995D-01,  &
 -1.3011057288355D+00,  5.3901118329658D+00,  1.3568988621720D+01,  &
 -3.7808429693587D+01, -2.0739014515304D+01,  8.3199919232595D+01,  &
 -9.8755630053578D+00, -6.1652207627820D+01,  2.7023074052020D+01,  &
  2.4525958185483D+00, -5.5149034988337D-01,  1.5103514025733D-01,  &
 -2.4618413187533D-01, -4.1804716531894D-01,  2.6714852474484D+00,  &
 -3.9168656863665D+00, -2.4125252717845D+01,  4.3527442372053D+01,  &
  5.9633945281439D+01, -1.4203637448798D+02, -2.5686288988000D+01,  &
  1.8623562080820D+02, -7.1111780955171D+01, -8.1445438601723D+01,  &
  7.5998791997709D+01, -1.9604047605233D+01,  6.9877155195411D-01,  &
  2.7810300377705D-01, -5.2931179377996D-01, -1.0053094346116D+01,  &
  1.4814307367778D+01,  7.8108768923701D+01, -1.0805092078057D+02,  &
 -2.3239081566836D+02,  3.7213457783017D+02,  3.0496349672975D+02,  &
 -6.3411783219992D+02, -1.4879340998406D+02,  5.0022502992215D+02,  &
 -1.3111459794329D+01, -1.2290268190725D+02, -5.8654536308254D-01,  &
 -3.2431931793368D+00, -4.3010113145914D+00,  6.0041429939524D+01,  &
 -5.6492374908452D+01, -2.3766509586367D+02,  5.7464248240814D+02,  &
 -1.1755625188188D+01, -1.3722806921925D+03,  1.1416528991599D+03,  &
  1.0319638945490D+03, -1.3181474199324D+03, -2.8780475896443D+02,  &
  4.8041729027996D+02,  2.5765411421547D-01,  3.0320582307308D+00,  &
  1.8801635566723D+01, -1.0807887522259D+01, -9.2855800489316D+01,  &
 -2.0023372590061D+02,  3.7208691892624D+01,  1.2333932023660D+03,  &
 -2.3854122885654D+02, -2.2719119490167D+03,  1.2845178202043D+03,  &
  1.0639169133522D+03, -8.1775958686613D+02, -2.5657303999430D+00,  &
  3.2500673972889D+01,  2.7614957583093D+01, -6.3541800745099D+02,  &
  3.7542804251488D+02,  3.1023608042457D+03, -3.2841743471965D+03,  &
 -3.9310047363443D+03,  5.9367773903877D+03, -5.6931755253618D+02,  &
 -1.6343922939315D+03,  5.6921856317329D+02,  6.9934412991284D+00,  &
 -9.0226351470208D+01, -1.6210263409154D+02,  1.5895772244284D+03,  &
 -2.3411885205624D+02, -7.0717394064325D+03,  6.2987514309228D+03,  &
  7.4402200861379D+03, -1.1416901914882D+04,  3.3350622040450D+03,  &
  3.1195654244768D+02, -6.2871212585897D+00,  7.9926393798994D+01,  &
  1.7167392636067D+02, -1.3658290879599D+03, -5.6544576497080D+01,  &
  5.9229738209174D+03, -4.7443933784239D+03, -6.0256769257614D+03,  &
  9.1534258978092D+03, -3.1293931276615D+03,  1.6169861139146D+00,  &
 -2.0468415192255D+01, -4.6075981473614D+01,  3.4557095272353D+02,  &
  2.6381121398946D+01, -1.4631669362241D+03,  1.2299345022018D+03,  &
  1.2705573668289D+03, -2.5152540533899D+03,  1.7151603225554D+03,  &
  8.6865937684802D+01, -1.6707195632608D+03,  6.2315981153506D+02,  &
  1.4270102465207D+03, -1.0493951381706D+03, -3.7380369214480D+02,  &
  5.5457941332705D+02, -1.4236914052765D+02, -6.1540053279229D-02,  &
  1.5531427659386D-01, -3.1860760875349D-02,  3.2654417741389D-02,  &
 -2.2987178066698D-01,  3.0488522568491D-01,  2.2933076978782D+00,  &
 -3.7563267358823D+00, -1.0753342561066D+01,  2.0419223364673D+01,  &
  2.2747341950651D+01, -5.4709940439901D+01, -1.5369671127204D+01,  &
  7.1082849961840D+01, -1.2914573886419D+01, -3.5970581259398D+01,  &
  1.6891394219063D+01, -7.5177127154281D-02, -5.5097454571807D-02,  &
  1.3178003090885D-02, -7.3713198218206D-02,  1.0116574180841D-01,  &
 -5.6479840733797D-01,  7.0154865623363D-01,  1.0496975433616D+00,  &
 -5.0788071354498D+00,  5.5950672093606D+00,  8.3560432301710D+00,  &
 -2.4631240429059D+01,  6.4228976148411D+00,  2.9716418329629D+01,  &
 -2.5429959665417D+01, -7.0743350880142D+00,  1.6290654019047D+01,  &
 -5.5863925933866D+00, -1.2201221052153D-01,  2.9211663541558D-01,  &
 -5.0527445973303D-02, -1.1499331650193D+00, -1.1524746330230D+00,  &
  1.4889417611659D+01,  1.8304400502439D+01, -7.0581115296041D+01,  &
 -7.0486462006098D+01,  1.9124714847398D+02,  1.0441968375963D+02,  &
 -2.7288439929057D+02, -6.4888829584091D+01,  1.8924747244095D+02,  &
  2.4269853698223D+01, -6.0338716812716D+01, -3.5328088267763D-02,  &
  3.0902606918779D-01,  1.2053004980265D+00, -6.0803513996890D+00,  &
 -1.7483113565255D-01, -6.2625401449884D+00, -2.7246752169995D+01,  &
  2.0444304756919D+02, -7.7839322800197D+01, -5.3730625493358D+02,  &
  4.7830647603102D+02,  4.6597134541889D+02, -6.1259392504536D+02,  &
 -1.1548852899995D+02,  2.3547566621563D+02, -2.3347154414735D-02,  &
 -1.1968693854390D+00,  1.0224938597971D+01,  5.3446850508065D+01,  &
 -1.4111836292138D+02, -3.1522742996746D+02,  4.8421928937666D+02,  &
  6.7783542838211D+02, -5.2424354383194D+02, -9.1849951039291D+02,  &
  2.9732037903974D+01,  1.0861777943385D+03,  3.0719961746829D+01,  &
 -5.0010435278295D+02,  1.8839519932092D+00, -1.7599267033384D+01,  &
 -1.0219850683350D+02,  1.8829260033990D+02,  7.3803356268807D+02,  &
 -3.8632754653668D+02, -1.7644793500072D+03, -8.8777283880817D+02,  &
  2.9449590358391D+03,  2.0536359693554D+03, -3.3452415814017D+03,  &
 -3.1293172119834D+02,  1.0127512420257D+03, -3.0193368209445D+00,  &
  4.1095352165196D+01,  4.4348552320534D+01, -7.9321796890387D+02,  &
  3.2539233560467D+02,  3.1868226505597D+03, -2.0997414646993D+03,  &
 -1.8521962831455D+03,  9.1469297093176D+02, -2.3634831297013D+03,  &
  3.4289073363414D+03, -1.1416454795844D+03, -1.5199034217066D+01,  &
  1.4232675696336D+02,  9.3114014166986D+02, -1.4217668280744D+03,  &
 -6.6892280796250D+03,  4.5183848177059D+03,  1.2162309555107D+04,  &
 -6.0881419416832D+03, -6.5629804880923D+03,  4.3337118077328D+03,  &
 -8.1558350744764D+02,  4.3004262747050D+01, -4.5882304802650D+02,  &
 -2.0410524329200D+03,  6.1474199330111D+03,  1.1724980372884D+04,  &
 -2.3175030314049D+04, -1.1837559831675D+04,  2.5197118132844D+04,  &
 -3.2683703679870D+03, -2.7866974850481D+03, -2.8591617842506D+01,  &
  3.1751114848550D+02,  1.2298684178193D+03, -4.5417151814417D+03,  &
 -6.2204390702960D+03,  1.7700472889577D+04,  2.6246105174545D+03/  
data (coef(i),i=297,590 ) / &
 -1.8861366382775D+04,  7.9585442979514D+03,  3.9716425665863D-02,  &
 -7.6680420565681D-02, -2.9794073611373D-02,  2.9651275363141D-01,  &
  2.3617540011178D-01, -5.3814608941930D+00,  4.0147726416215D+00,  &
  3.7532098679521D+01, -3.9135190680333D+01, -1.1925521735589D+02,  &
  1.2926060949759D+02,  1.9857026702725D+02, -2.0774883055076D+02,  &
 -1.7655360260354D+02,  1.7333813535796D+02,  6.9917438328193D+01,  &
 -6.5021997846616D+01,  3.8151219229796D-02,  4.3843768950232D-02,  &
 -2.4086574908239D-01,  2.3158689464466D-02,  6.9158105021969D+00,  &
 -1.2586455424488D+01, -5.0585593269608D+01,  7.3347518061775D+01,  &
  1.4968744302400D+02, -1.6800393040240D+02, -2.4320433942912D+02,  &
  2.0861481767385D+02,  2.1775727676924D+02, -1.6369018032037D+02,  &
 -7.3208995085005D+01,  5.4436885233608D+01,  1.1600348167678D-01,  &
 -4.9809340646254D-01,  1.5047843655988D+00,  8.3092068539797D+00,  &
 -3.8274991517389D+01, -1.4955961155500D+01,  2.0476668028645D+02,  &
 -1.4680118753568D+02, -3.4810875016780D+02,  4.4949122123679D+02,  &
  2.1140330213824D+02, -3.4203945153975D+02, -1.7142290576617D+02,  &
  8.0503251494110D+01,  1.0907423981457D+02, -3.0813919972698D-01,  &
  5.3469826239172D+00,  4.1194843505592D+00, -1.1308670564800D+02,  &
  4.5037871493300D+01,  6.4697558804757D+02, -3.3915227244081D+02,  &
 -1.3127082959971D+03,  4.7475537719540D+02,  8.1252490358818D+02,  &
  3.0426799712395D+02,  2.9160486418388D+02, -6.4609348432963D+02,  &
 -2.1720015797288D+02, -4.0717901122888D-01, -2.1775365635881D+00,  &
  2.0109616610057D+01,  1.1840212900112D+02, -2.3299581294368D+01,  &
 -1.3804184017780D+03, -3.7864690931221D+02,  5.4422454262195D+03,  &
  1.1731401502819D+02, -7.8538796156468D+03,  1.2681623750875D+03,  &
  2.4245427250637D+03,  5.2537243990115D+02,  4.9012179973933D+00,  &
 -5.8422833107136D+01, -1.1959337380958D+02,  7.6197184851275D+02,  &
 -5.4004121440061D+02, -6.5752094811032D+02,  5.0117235022499D+03,  &
 -8.3195437886163D+03, -4.0923671328069D+03,  1.4067572094755D+04,  &
 -5.1926504471740D+03, -1.8352378595347D+03,  1.8348460774400D+00,  &
  4.4232889207825D+01, -2.8532180098981D+02, -5.7783235501804D+02,  &
  4.7469633395506D+03, -2.7717073870747D+03, -1.5477480217467D+04,  &
  2.0164435060594D+04,  7.6472187060327D+03, -1.4329906429453D+04,  &
  2.7654174295895D+03, -2.4933719687704D+01,  1.6938637652995D+02,  &
  1.1725472236032D+03, -2.6185152590142D+03, -9.5402134640010D+03,  &
  1.7455906770618D+04,  1.7071726465930D+04, -4.2977938350785D+04,  &
  8.3240887122425D+03,  8.9751790796763D+03,  2.1229895778839D+01,  &
 -1.8436561758379D+02, -8.5222313684980D+02,  2.8331698142703D+03,  &
  5.3669935127176D+03, -1.4884070826991D+04, -4.6728813976088D+03,  &
  2.8923002872424D+04, -1.5729684853032D+04, -9.1001855777311D-02,  &
  1.2606953268180D-01, -3.1519952720694D-01,  1.0882246949699D-02,  &
  6.1775970589028D+00,  4.0310495365214D+00, -6.9928682686748D+01,  &
  9.0965453694424D+00,  3.2158833968308D+02, -1.6194149323382D+02,  &
 -6.7791173776787D+02,  4.6669667687548D+02,  6.5699669870691D+02,  &
 -5.2009876671815D+02, -2.3449493492895D+02,  2.0039592779180D+02,  &
  3.8802318093898D-03, -4.9919819499055D-01, -2.6557572554758D+00,  &
  2.2769271640128D+00,  1.7001242162874D+01,  3.3420756287497D+01,  &
 -2.9261140751289D+01, -2.1451913425330D+02, -8.3514798161063D+01,  &
  6.0390350949326D+02,  2.4911128495358D+02, -8.8970779087907D+02,  &
 -6.1341985024217D+01,  5.2339793092702D+02, -1.4773870434232D+02,  &
 -7.3018652841179D-02,  1.2511869964145D-01, -9.0051305439079D-01,  &
  1.5938093544128D+01,  3.6086128531278D+01, -1.5519028779513D+02,  &
 -3.6378153009876D+02,  7.4515812347262D+02,  9.4098545547879D+02,  &
 -2.0232105093403D+03, -6.3656643380741D+02,  2.2768813182156D+03,  &
 -1.1769679117170D+02, -7.5095701817072D+02, -6.3164626178965D-02,  &
 -2.4973821350993D+00,  7.5448861484495D+00,  1.1635606223809D+02,  &
 -2.2524693749573D+02, -1.0556395012207D+03,  1.8778696180785D+03,  &
  2.4814533070907D+03, -4.9001417316772D+03,  2.8787017655091D+02,  &
  1.9230152500049D+03, -2.4720091192153D+03,  2.2231531670467D+03,  &
 -1.5972254758261D+00,  3.3358952350678D+01, -1.5349485484053D+02,  &
 -1.0222605060145D+03,  2.6058333596737D+03,  5.5066961210604D+03,  &
 -1.0260746375597D+04, -9.5244944213392D+03,  1.4445465194127D+04,  &
  6.7693189472350D+03, -7.0519076729418D+03, -2.2351446735772D+03,  &
 -4.0377331481523D+00, -2.1309356232702D+01,  1.0932116051132D+03,  &
  1.8951040191421D+03, -1.2638353905062D+04, -7.8334339454752D+03,  &
  3.7355822038927D+04, -3.2070232783474D+02, -2.7752315703767D+04,  &
  3.0703700646355D+03,  6.7196527978088D+03,  1.8589753977584D+01,  &
 -1.1531237755348D+02, -1.9071791312915D+03, -5.0507717540472D+02,  &
  1.8671838329812D+04,  1.8782898019424D+03, -4.9077963825250D+04,  &
  1.9663501548405D+04,  1.6775956075880D+04, -6.8797694636129D+03,  &
 -1.5392769605278D+01,  1.4314231518070D+02,  9.2742914488985D+02,  &
 -8.6369670411176D+02, -7.5732720415571D+03,  1.2303421777411D+03,  &
  1.9655249072421D+04, -1.1356364687235D+04, -1.5516005133570D+03,  &
  7.7063768526421D-02,  7.0426469599854D-02,  2.0761670250555D+00,  &
 -2.8634959354359D+00, -3.1164263380429D+01,  6.3325838362807D+01,  &
  1.3440137971042D+02, -4.2450130534225D+02, -1.7557989913336D+02,  &
  1.1703417590195D+03, -1.5736118502704D+02, -1.4314931107424D+03,  &
  5.4735799135351D+02,  6.5228691636034D+02, -3.4649449001593D+02,  &
  3.3658722082134D-01, -5.0676809602213D+00, -2.9106727200001D+00,  &
  8.2676750156482D+01, -1.3148704459247D+02, -2.5035771616523D+02,  &
  8.8155125325036D+02,  1.5760038417742D+01, -1.7669112592171D+03,  &
  3.7903643238106D+02,  1.3940556790468D+03,  9.5473923100084D+01,  &
 -5.9488289804203D+02, -1.0375305686597D+02,  1.0611853628745D-01,  &
  6.8018645407458D-01, -3.8241143585196D+01, -1.4180657093351D+02,  &
  5.5839462134171D+02,  8.9083861487365D+02, -2.2428731955568D+03,  &
 -1.0696194575091D+03,  3.3044661448638D+03, -1.1680010201567D+02,  &
 -1.7920012637278D+03, -6.1232642612491D+02,  1.3836367193425D+03,  &
  2.0417520570553D-01, -7.9433513459797D+00,  4.9941677146710D+01,  &
  3.8556761998824D+02, -4.3354401901645D+02, -2.9252579756013D+03,  &
  7.0787648712498D+02,  7.4494602120593D+03, -7.2827828707273D+02,  &
 -6.2503713255535D+03,  9.7289221009631D+02,  7.7312858527177D+01,  &
 -6.6197854413995D+00,  1.0995202663404D+02,  4.2496312130364D+02,  &
 -1.0926295063977D+03, -3.4735863505250D+03,  3.8366949704567D+03,  &
  6.8787898380604D+03, -5.5632277387875D+03, -4.8778452478220D+03,  &
  3.2616178520528D+03,  2.0068291316213D+03,  3.5777786501690D+00,  &
 -5.7449163082074D+01, -1.1330140975813D+03, -2.3867994586921D+02,  &
  1.2486261487440D+04, -2.9307104402199D+03, -2.7262386305868D+04,  &
  1.3625571370624D+04,  9.8571450057540D+03, -5.6749289072923D+03/  
data (coef(i),i=591,823)/ &
  4.1553990812089D+00, -7.9039807148033D+01,  8.8968879497294D+02,  &
  1.3455454325898D+03, -1.0988450257158D+04,  2.1243056081888D+03,  &
  2.2695927933545D+04, -1.6151195263114D+04,  5.7162399438863D+02,  &
 -1.4707745858430D-01,  9.7352979651830D-01, -1.3963979746230D+00,  &
 -5.0620597759579D+00,  4.1889115153715D+01, -1.6750935186307D+02,  &
  5.4153300234594D+01,  8.6519209898296D+02, -9.9771562423031D+02,  &
 -1.1954597331072D+03,  1.9130571891052D+03,  3.2970524550364D+02,  &
 -1.0799252122230D+03,  2.3188545562150D+02, -2.3260472371895D+00,  &
  2.8778841876862D+01,  7.3729117301464D+01, -3.9665840600899D+02,  &
 -1.0492975222219D+02,  9.8391313374665D+02, -8.7153556883620D+02,  &
  1.2925482149096D+02,  2.8407542775704D+03, -2.5510566959515D+03,  &
 -2.6562766587407D+03,  1.9418505402370D+03,  6.4880930217887D+02,  &
 -6.6339523191321D-01, -6.7652338227873D+00,  1.2595758727568D+02,  &
  2.6358517711430D+02, -1.9491350746858D+03, -8.1556544124539D+02,  &
  8.0674120988159D+03, -2.8030710355945D+03, -8.2835866894133D+03,  &
  8.5200522744880D+03, -1.4823246514080D+03, -1.8582682447107D+03,  &
  1.3411433749499D+01, -1.0724377110067D+02, -7.3011900696809D+02,  &
  3.2986284159027D+02,  5.4422009200589D+03,  5.1612586434237D+03,  &
 -1.5408182231606D+04, -1.7219721238496D+04,  2.3099974160780D+04,  &
  7.5627594219128D+03, -7.2222488902078D+03,  9.0134473169245D+00,  &
 -1.8141737623666D+02, -1.6250043077780D+02,  2.7734466811064D+03,  &
 -1.7603482955414D+03, -8.4261842852894D+03,  1.1505910416517D+04,  &
  2.3905813350797D+03, -9.9322452343220D+03,  2.5033774697627D+03,  &
 -1.5504722193729D+01,  2.3356522943559D+02,  5.0446696501510D+02,  &
 -2.7974049426340D+03, -2.1728892649799D+03,  8.8232547331869D+03,  &
 -8.8130817256117D+02, -5.5988385752909D+03,  2.4600534679954D+03,  &
  2.9839839544840D-01, -2.5151376007022D+00, -1.6128107429533D+01,  &
  1.5815400376918D+01,  1.7510608940292D+02,  9.2482388065900D+01,  &
 -9.7809220540734D+02, -2.4201666223881D+02,  2.3142988047960D+03,  &
 -4.5860050306794D+02, -1.8750958557472D+03,  7.4085721397343D+02,  &
  2.8053172515762D+02,  4.1947911256955D-02,  1.0075005360980D+01,  &
 -6.7719600149183D+01, -3.0685585897860D+02,  1.1072385861168D+03,  &
  1.6789916295748D+03, -4.8695580803695D+03, -2.0262753920751D+03,  &
  5.5980332463152D+03,  6.2850579996277D+02,  2.3166144606877D+02,  &
 -2.2309515494369D+03,  2.5859761872220D+00, -1.0732897589540D+01,  &
 -1.4608367222295D+02,  7.3151950872768D+02,  2.0691657871185D+03,  &
 -6.2964172055131D+03, -7.0631065409304D+03,  1.3988300813956D+04,  &
 -6.8942777509668D+02, -7.6064339013414D+03,  5.2175199344330D+03,  &
 -2.9738335062942D+01,  2.6716014780161D+02,  1.4275147307938D+03,  &
 -2.6294668536922D+03, -9.2629448907848D+03,  3.1355735803168D+03,  &
  2.1600693888086D+04,  3.6602362688419D+03, -2.6634480984280D+04,  &
  7.9284616538140D+03,  6.7932985538261D+00, -4.0715244679510D+01,  &
 -2.9625172153656D+02,  6.2654153362437D+01,  3.1592520545123D+03,  &
 -1.2656094035574D+03, -6.9719119937501D+03,  5.0452169759528D+03,  &
  6.3580318228825D+02,  4.9487190936163D-01, -8.1704383753618D+00,  &
  3.0866575425802D+01,  1.2890521782151D+02, -7.1868218834493D+02,  &
  1.2673007356194D+02,  2.5550860147502D+03, -1.7241055434141D+03,  &
 -2.3386125844583D+03,  1.9632048623696D+03,  4.8684298042802D+02,  &
 -6.0019082249152D+02,  1.8914198671144D+01, -2.5768302141778D+02,  &
 -4.5268033914720D+02,  4.0156097099637D+03, -1.2034046445670D+03,  &
 -1.2847127836559D+04,  1.2601534082468D+04,  1.0123828204742D+04,  &
 -1.8277570534558D+04,  4.9534460864680D+03,  1.7746905955483D+03,  &
 -5.6579196192910D+00,  6.8763882806458D+01,  8.2283065915338D+01,  &
 -2.4462084382260D+03, -4.0910387942633D+02,  1.5800388896523D+04,  &
 -1.5542381059831D+03, -2.2695400772600D+04,  1.4191039695857D+04,  &
 -3.1236918418556D+03,  1.5730605077744D+01, -1.4806541142544D+02,  &
 -7.3549773901344D+02,  1.9567318545056D+03,  3.8451428102190D+03,  &
 -5.0356609530826D+03, -5.0370354604727D+03,  1.8104166969353D+03,  &
  3.4573735155463D+03, -2.2310791296488D+00,  3.0309038289269D+01,  &
  2.4387010913574D-02, -4.0609309840901D+02,  9.8147125540770D+02,  &
 -1.2887853697751D+02, -2.9863513297012D+03,  2.9859066623897D+03,  &
  7.5810452433204D+02, -1.3633646747081D+03,  2.3494005037572D+02,  &
 -3.6049971507842D+01,  4.6341305915926D+02,  1.0179406463565D+03,  &
 -6.8412635604360D+03, -3.4856750931568D+02,  1.9896790284724D+04,  &
 -1.0548394707187D+04, -1.5786132878027D+04,  1.5616388325597D+04,  &
 -3.8177104809982D+03,  3.9840698767479D+00, -5.5640306634995D+01,  &
 -4.1773631283442D+01,  1.6530852321701D+03,  3.5846651873594D+01,  &
 -1.0125455268494D+04,  1.4310619082953D+03,  1.4684788370590D+04,  &
 -7.5655604775677D+03,  2.1863563084839D+00, -2.8676540512968D+01,  &
 -2.5470438201247D+01,  3.6758591398511D+02, -5.7140314000597D+02,  &
  3.8434447269712D+01,  1.5820008738722D+03, -2.0663067220802D+03,  &
  3.5807377993698D+02,  2.8966278527317D+02,  1.9992892131663D+01,  &
 -2.5091839059403D+02, -5.9493849732297D+02,  3.6040463692465D+03,  &
  6.8425945490518D+02, -9.8117448904512D+03,  2.9842697258990D+03,  &
  7.8691352095489D+03, -4.3817966235099D+03, -5.5702600343214D-01,  &
  7.2587027792799D+00,  8.6351336949194D+00, -8.9552953762538D+01,  &
  1.1575980363922D+02, -3.0029982429047D+01, -2.8073588184232D+02,  &
  5.1929492676140D+02, -2.3951066467556D+02/  

contains
    ! some wrapper functions and the Partridge Schwenke Dipole moment surface for water - published 
    ! J. Chem. Phys. 113, 6592 (2000); http://dx.doi.org/10.1063/1.1311392
    ! retreived from EPAPS : EPAPS Document No. E-JCPSA6-113-304040

   subroutine dipole_moment_PS(atomic_positions,dipole)
      real(dp), dimension(3,3),intent(in)      :: atomic_positions ! dimension 1 is component, dimension 2 is atom
      real(dp), dimension(3),intent(inout)     :: dipole
      real(dp), dimension(1,3,3)               :: x ! rank 3 array because that's what vibdip takes as an argument      
      real(dp), dimension(1,3)                 :: d ! rank 2 array because that's what vibdip takes as an argument      
      x(1,:,:) = atomic_positions *(1.0_dp/BOHR) ! convert to a.u.
      call vibdip(x,d,1)
      dipole = d(1,:)* BOHR ! convert from a.u.
   end subroutine dipole_moment_PS

   subroutine dipole_moment_gradients_PS(atomic_positions,grad,step,test)

      ! calculate gradients of dipole moment components wrt atomic positions, using finite differences
      ! step is an optional parameter, but should be chosen to get maximal precision in the gradients

      real(dp),intent(in), optional            :: step ! distance in Angstroms to move atoms for finite diff
      logical,intent(in), optional             :: test !  whether to test to find the best step size
      real(dp)                                 :: my_step
      real(dp), dimension(1,3)                 :: d_plus, d_minus, d_plus_fd, d0
      real(dp), dimension(3,3),intent(in)      :: atomic_positions ! dimension 1 is component, dimension 2 is atom
      real(dp), dimension(1,3,3)               :: x ! working array to hold temporary positions
      real(dp), dimension(3,3,3),intent(inout) :: grad
      integer                                  :: i, j ,k
      logical                                  :: do_test

      do_test = optional_default(.False.,test)
      my_step = optional_default(1e-8_dp *BOHR, step)

      if (do_test) then
        call print("RESULT OF GRADIENT TESTING THE FINITE DIFFERENCE GRADS")
      end if

      grad = 0.0_dp

      do i=1,3 ! loop over atoms
        do j=1,3 ! loop over position components
          x(1,:,:) = atomic_positions  *(1.0_dp/BOHR) 
          x(1,j,i) = x(1,j,i) + my_step
          call vibdip(x,d_plus,1)
          x(1,j,i) = x(1,j,i) - 2.0_dp*my_step
          call vibdip(x,d_minus,1)
          do k=1,3 ! loop over dipole components
            grad(k,j,i) = (d_plus(1,k) - d_minus(1,k)) / (2.0_dp * my_step) ! this already in QUIP units, since dipole gradient with position just has units of charge (e).
          end do
        end do
      end do

      if (do_test) then
         call print("Testing gradient of PS dipole moment components wrt atomic positions : ")
         my_step = 0.9_dp*my_step
         do i=1,3 ! loop over atoms
           do j=1,3 ! loop over position components
             do k=1,3 ! loop over dipole components
               x(1,:,:) = atomic_positions  *(1.0_dp/BOHR) 
               call vibdip(x,d0,1)
               x(1,j,i) = x(1,j,i) + my_step
               call vibdip(x,d_plus,1)
               call print(" Step Size : "// my_step //" (d(i)-d0(i)) / (grad*step) : "//(d_plus(1,k) -d0(1,k))/ (grad(k,j,i)*my_step))
             end do
           end do
         end do
      end if

   end subroutine dipole_moment_gradients_PS
                
   subroutine vibdip(x,d,n)
     integer :: n, isump,nf,i,j, ifirst=0
     real(dp), dimension(n,3,3) :: x
     real(dp), dimension(n,3) :: d
     real(dp), dimension(19,3) :: fmat
     real(dp) :: reoh, thetae,b1,toang,rad,cabc,ce,r1x,r1y,r1z,r1,r2x,r2y,r2z,r2, &
                   x1,x2,x3,p1,p2,damp1,damp2,term,term1,term2
     save
   
          !!$c
          !!$c     dipole moment surface for h2o,
          !!$c     David W. Schwenke and Harry Partridge, J. Chem. Phys.,
          !!$c     submitted May, 2000.
          !!$c
          !!$c     x(i,j,k) is cartesian coordinate (in a.u.) of atoms in some frame
          !!$c              of reference, i is geometry no., j=1 x, j=2 y, j=3 z,
          !!$c              k=1,2 h, k=3 o.
          !!$c     n is number of geometries.
          !!$c
          !!$c     return dipole moment d(i,j) (in a.u.), i is geometry no., j=1 x,
          !!$c              j=2 y, j=3 z in the same frame of reference as input
          !!$c              cartesians.
          !!$c

      if(ifirst.eq.0)then
         ifirst=1
          ! write(6,1)
          !!$1  format(/1x,'dipole moment surface for h2o',
          !!$     $        /1x,'by David W. Schwenke and Harry Partridge ',
          !!$     $        /1x,'submitted to J. Chem. Phys. May, 2000',
          !!$     $        /1x,'use parameters for FIT2')                            !6d6s00
         reoh= 0.958648999999999973d0
         thetae= 104.347499999999997d0
         b1= 1.50000000000000000d0
          !!$           write(6,4)reoh,thetae,b1
          !!$      4  format(/1x,'reoh = ',f10.4,' thetae = ',f10.4,
          !!$       $        /1x,'beta = ',f10.4)
         nf=1
         isump=0
         toang=1d0/1.889725989d0
         reoh=reoh*1.889725989d0
         b1=b1/1.889725989d0**2
         nf=823                                                           !6d6s00
         do i=1,nf                                                      !6d6s00
           !write(6,5)(idx(i,j),j=1,3),coef(i)
           !5  format(1x,3i5,1pe15.7)
           isump=max(isump,idx(i,1),idx(i,2),idx(i,3))
         end do
         rad=acos(-1d0)/1.8d2
         ce=cos(thetae*rad)
      end if


      do i=1,n

         r1x=x(i,1,1)-x(i,1,3)
         r1y=x(i,2,1)-x(i,2,3)
         r1z=x(i,3,1)-x(i,3,3)
         r1=sqrt(r1x**2+r1y**2+r1z**2)
         r2x=x(i,1,2)-x(i,1,3)
         r2y=x(i,2,2)-x(i,2,3)
         r2z=x(i,3,2)-x(i,3,3)
         r2=sqrt(r2x**2+r2y**2+r2z**2)
         cabc=(r1x*r2x+r1y*r2y+r1z*r2z)/(r1*r2)
         x1=(r1-reoh)/reoh
         x2=(r2-reoh)/reoh
         x3=cabc-ce
         fmat(1,1)=1d0
         fmat(1,2)=1d0
         fmat(1,3)=1d0

         do j=2,isump

           fmat(j,1)=fmat(j-1,1)*x1
           fmat(j,2)=fmat(j-1,2)*x2
           fmat(j,3)=fmat(j-1,3)*x3
         end do
         p1=0d0
         p2=0d0
         damp1=exp(-b1*((r1-reoh)**2))                                    !6d6s00
         damp2=exp(-b1*((r2-reoh)**2))                                    !6d6s00

         do j=1,nf
           term=coef(j)*fmat(idx(j,3),3)
           term1=term*fmat(idx(j,1),1)*fmat(idx(j,2),2)
           term2=term*fmat(idx(j,2),1)*fmat(idx(j,1),2)
           if(idx(j,2).gt.1.or.idx(j,3).gt.1)then                          !2d26s99
             term1=term1*damp2                                              !2d26s99
             term2=term2*damp1                                              !2d26s99
           end if                                                          !2d26s99
           p1=p1+term1
           p2=p2+term2
         end do
         p1=p1*damp1
         p2=p2*damp2
         d(i,1)=p1*(x(i,1,1)-x(i,1,3))+p2*(x(i,1,2)-x(i,1,3))
         d(i,2)=p1*(x(i,2,1)-x(i,2,3))+p2*(x(i,2,2)-x(i,2,3))
         d(i,3)=p1*(x(i,3,1)-x(i,3,3))+p2*(x(i,3,2)-x(i,3,3))
      end do
      return
  end subroutine vibdip

end module partridge_schwenke_dipole_module
