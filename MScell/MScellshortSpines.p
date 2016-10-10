//***************************		MS Model, Version 5.0	**********************
//*************************** 	      MScell.p 			**********************
//			Tom Sheehan tsheeha2@gmu.edu	thsheeha@vt.edu	703-538-836
//*****************************************************************************

*relative
*cartesian
*asymmetric
*lambda_warn

//*set_global ELEAK -0.070
//*set_global RA 1.0 
//*set_global RM 8.695652
//*set_global RM 1.8

*set_global CM 0.01
//*set_global EREST_ACT -0.085

*start_cell /library/tert_dend
tert_dend none 17.964 0 0 0.80
tert_dend2 . 17.964 0 0 0.79 
tert_dend3 . 17.964 0 0 0.78
tert_dend4 . 17.964 0 0 0.77
tert_dend5 . 17.964 0 0 0.76
tert_dend6 . 17.964 0 0 0.75
tert_dend7 . 17.964 0 0 0.74 
tert_dend8 . 17.964 0 0 0.73
tert_dend9 . 17.964 0 0 0.72
tert_dend10 . 17.964 0 0 0.71
tert_dend11 . 17.964 0 0 0.70
*makeproto /library/tert_dend

*start_cell /library/sec_dend

sec_dend none 12 0 0 1.200
*makeproto /library/sec_dend

*start_cell /library/prim_dend

prim_dend none 10.000 0 0 2.5
*makeproto /library/prim_dend

*start_cell
*spherical
*set_compt_param RA 4
soma none 16.000 0 0 16.000

*cylindrical

*set_compt_param RA 4
*compt /library/prim_dend
primdend1 soma 10 0 0 2.5
primdend2 soma 10 0 0 2.5
primdend3 soma 10 0 0 2.5
primdend4 soma 10 0 0 2.5

*set_compt_param RA 4
*compt /library/sec_dend
secdend1 primdend1 12 0 0 1.2
secdend2 primdend1 12 0 0 1.2
secdend3 primdend2 12 0 0 1.2
secdend4 primdend2 12 0 0 1.2
secdend5 primdend3 12 0 0 1.2
secdend6 primdend3 12 0 0 1.2
secdend7 primdend4 12 0 0 1.2
secdend8 primdend4 12 0 0 1.2

*set_compt_param        RA      4
*compt /library/tert_dend
tertdend1 secdend1 17.964  0  0  0.8
tertdend2 secdend1 17.964  0  0  0.8
tertdend3 secdend2 17.964  0  0  0.8
tertdend4 secdend2 17.964  0  0  0.8
tertdend5 secdend3 17.964  0  0  0.8
tertdend6 secdend3 17.964  0  0  0.8
tertdend7 secdend4 17.964  0  0  0.8
tertdend8 secdend4 17.964  0  0  0.8
tertdend9 secdend5 17.964  0  0  0.8
tertdend10 secdend5 17.964  0  0  0.8
tertdend11 secdend6 17.964  0  0  0.8
tertdend12 secdend6 17.964  0  0  0.8
tertdend13 secdend7 17.964  0  0  0.8
tertdend14 secdend7 17.964  0  0  0.8
tertdend15 secdend8 17.964  0  0  0.8
tertdend16 secdend8 17.964  0  0  0.8
