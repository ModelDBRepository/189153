//***************************		MS Model, Version 5.0	**********************
//*************************** 	      MScell.p 			**********************
//			Tom Sheehan tsheeha2@gmu.edu	thsheeha@vt.edu	703-538-836
//*****************************************************************************

*relative
*cartesian
*asymmetric
*lambda_warn

*set_global ELEAK -0.070
*set_global RA 4.0 
*set_global RM 8.7
//change Cm to account for no spines - make 3x higher?
*set_global CM 0.01  
*set_global EREST_ACT -0.085

*start_cell
*spherical
soma none 16.000 0 0 16.000

*cylindrical
primdend1 soma 20 0 0 2.5
primdend2 soma 20 0 0 2.5
primdend3 soma 20 0 0 2.5
primdend4 soma 20 0 0 2.5

