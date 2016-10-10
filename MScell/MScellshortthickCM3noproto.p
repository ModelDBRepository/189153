//***************************		MS Model, Version 5.0	**********************
//*************************** 	      MScell.p 			**********************
//			Tom Sheehan tsheeha2@gmu.edu	thsheeha@vt.edu	703-538-836
//*****************************************************************************

*relative
*cartesian
*asymmetric
*lambda_warn

*start_cell
*spherical
soma none 16.000 0 0 16.000

*cylindrical
primdend1 soma 12 0 0 1.7
primdend2 soma 12 0 0 1.7
primdend3 soma 12 0 0 1.7
primdend4 soma 12 0 0 1.7

secdend11 primdend1 14 0 0 1.4
secdend12 primdend1 14 0 0 1.4
secdend21 primdend2 14 0 0 1.4
secdend22 primdend2 14 0 0 1.4
secdend31 primdend3 14 0 0 1.4
secdend32 primdend3 14 0 0 1.4
secdend41 primdend4 14 0 0 1.4
secdend42 primdend4 14 0 0 1.4

tertdend1_1 secdend11 18  0  0  1.2
tertdend1_2 . 18 0 0 1.2 
tertdend1_3 . 18 0 0 1.2
tertdend1_4 . 18 0 0 1.2
tertdend1_5 . 18 0 0 1.2
tertdend1_6 . 18 0 0 1.2
tertdend1_7 . 18 0 0 1.2
tertdend1_8 . 18 0 0 1.2
tertdend1_9 . 18 0 0 1.2
tertdend1_10 . 18 0 0 1.2
tertdend1_11 . 18 0 0 1.2

tertdend2_1 secdend11 18  0  0  1.2
tertdend2_2 . 18 0 0 1.2 
tertdend2_3 . 18 0 0 1.2
tertdend2_4 . 18 0 0 1.2
tertdend2_5 . 18 0 0 1.2
tertdend2_6 . 18 0 0 1.2
tertdend2_7 . 18 0 0 1.2 
tertdend2_8 . 18 0 0 1.2
tertdend2_9 . 18 0 0 1.2
tertdend2_10 . 18 0 0 1.2
tertdend2_11 . 18 0 0 1.2

tertdend3_1 secdend12 18  0  0  1.2
tertdend3_2 . 18 0 0 1.2 
tertdend3_3 . 18 0 0 1.2
tertdend3_4 . 18 0 0 1.2
tertdend3_5 . 18 0 0 1.2
tertdend3_6 . 18 0 0 1.2
tertdend3_7 . 18 0 0 1.2 
tertdend3_8 . 18 0 0 1.2
tertdend3_9 . 18 0 0 1.2
tertdend3_10 . 18 0 0 1.2
tertdend3_11 . 18 0 0 1.2
   
tertdend4_1 secdend12 18  0  0  1.2
tertdend4_2 . 18 0 0 1.2 
tertdend4_3 . 18 0 0 1.2
tertdend4_4 . 18 0 0 1.2
tertdend4_5 . 18 0 0 1.2
tertdend4_6 . 18 0 0 1.2
tertdend4_7 . 18 0 0 1.2 
tertdend4_8 . 18 0 0 1.2
tertdend4_9 . 18 0 0 1.2
tertdend4_10 . 18 0 0 1.2
tertdend4_11 . 18 0 0 1.2
   
tertdend5_1 secdend21 18  0  0  1.2
tertdend5_2 . 18 0 0 1.2 
tertdend5_3 . 18 0 0 1.2
tertdend5_4 . 18 0 0 1.2
tertdend5_5 . 18 0 0 1.2
tertdend5_6 . 18 0 0 1.2
tertdend5_7 . 18 0 0 1.2 
tertdend5_8 . 18 0 0 1.2
tertdend5_9 . 18 0 0 1.2
tertdend5_10 . 18 0 0 1.2
tertdend5_11 . 18 0 0 1.2
   
tertdend6_1 secdend21 18  0  0  1.2
tertdend6_2 . 18 0 0 1.2 
tertdend6_3 . 18 0 0 1.2
tertdend6_4 . 18 0 0 1.2
tertdend6_5 . 18 0 0 1.2
tertdend6_6 . 18 0 0 1.2
tertdend6_7 . 18 0 0 1.2 
tertdend6_8 . 18 0 0 1.2
tertdend6_9 . 18 0 0 1.2
tertdend6_10 . 18 0 0 1.2
tertdend6_11 . 18 0 0 1.2
   
tertdend7_1 secdend22 18  0  0  1.2
tertdend7_2 . 18 0 0 1.2 
tertdend7_3 . 18 0 0 1.2
tertdend7_4 . 18 0 0 1.2
tertdend7_5 . 18 0 0 1.2
tertdend7_6 . 18 0 0 1.2
tertdend7_7 . 18 0 0 1.2 
tertdend7_8 . 18 0 0 1.2
tertdend7_9 . 18 0 0 1.2
tertdend7_10 . 18 0 0 1.2
tertdend7_11 . 18 0 0 1.2
   
tertdend8_1 secdend22 18  0  0  1.2
tertdend8_2 . 18 0 0 1.2 
tertdend8_3 . 18 0 0 1.2
tertdend8_4 . 18 0 0 1.2
tertdend8_5 . 18 0 0 1.2
tertdend8_6 . 18 0 0 1.2
tertdend8_7 . 18 0 0 1.2
tertdend8_8 . 18 0 0 1.2
tertdend8_9 . 18 0 0 1.2
tertdend8_10 . 18 0 0 1.2
tertdend8_11 . 18 0 0 1.2
   
tertdend9_1 secdend31 18  0  0  1.2
tertdend9_2 . 18 0 0 1.2 
tertdend9_3 . 18 0 0 1.2
tertdend9_4 . 18 0 0 1.2
tertdend9_5 . 18 0 0 1.2
tertdend9_6 . 18 0 0 1.2
tertdend9_7 . 18 0 0 1.2 
tertdend9_8 . 18 0 0 1.2
tertdend9_9 . 18 0 0 1.2
tertdend9_10 . 18 0 0 1.2
tertdend9_11 . 18 0 0 1.2
   
tertdend10_1 secdend31 18  0  0  1.2
tertdend10_2 . 18 0 0 1.2 
tertdend10_3 . 18 0 0 1.2
tertdend10_4 . 18 0 0 1.2
tertdend10_5 . 18 0 0 1.2
tertdend10_6 . 18 0 0 1.2
tertdend10_7 . 18 0 0 1.2 
tertdend10_8 . 18 0 0 1.2
tertdend10_9 . 18 0 0 1.2
tertdend10_10 . 18 0 0 1.2
tertdend10_11 . 18 0 0 1.2
   
tertdend11_1 secdend32 18  0  0  1.2
tertdend11_2 . 18 0 0 1.2 
tertdend11_3 . 18 0 0 1.2
tertdend11_4 . 18 0 0 1.2
tertdend11_5 . 18 0 0 1.2
tertdend11_6 . 18 0 0 1.2
tertdend11_7 . 18 0 0 1.2 
tertdend11_8 . 18 0 0 1.2
tertdend11_9 . 18 0 0 1.2
tertdend11_10 . 18 0 0 1.2
tertdend11_11 . 18 0 0 1.2
   
tertdend12_1 secdend32 18  0  0  1.2
tertdend12_2 . 18 0 0 1.2 
tertdend12_3 . 18 0 0 1.2
tertdend12_4 . 18 0 0 1.2
tertdend12_5 . 18 0 0 1.2
tertdend12_6 . 18 0 0 1.2
tertdend12_7 . 18 0 0 1.2 
tertdend12_8 . 18 0 0 1.2
tertdend12_9 . 18 0 0 1.2
tertdend12_10 . 18 0 0 1.2
tertdend12_11 . 18 0 0 1.2
   
tertdend13_1 secdend41 18  0  0  1.2
tertdend13_2 . 18 0 0 1.2 
tertdend13_3 . 18 0 0 1.2
tertdend13_4 . 18 0 0 1.2
tertdend13_5 . 18 0 0 1.2
tertdend13_6 . 18 0 0 1.2
tertdend13_7 . 18 0 0 1.2 
tertdend13_8 . 18 0 0 1.2
tertdend13_9 . 18 0 0 1.2
tertdend13_10 . 18 0 0 1.2
tertdend13_11 . 18 0 0 1.2
   
tertdend14_1 secdend41 18  0  0  1.2
tertdend14_2 . 18 0 0 1.2 
tertdend14_3 . 18 0 0 1.2
tertdend14_4 . 18 0 0 1.2
tertdend14_5 . 18 0 0 1.2
tertdend14_6 . 18 0 0 1.2
tertdend14_7 . 18 0 0 1.2 
tertdend14_8 . 18 0 0 1.2
tertdend14_9 . 18 0 0 1.2
tertdend14_10 . 18 0 0 1.2
tertdend14_11 . 18 0 0 1.2
   
tertdend15_1 secdend42 18  0  0  1.2
tertdend15_2 . 18 0 0 1.2 
tertdend15_3 . 18 0 0 1.2
tertdend15_4 . 18 0 0 1.2
tertdend15_5 . 18 0 0 1.2
tertdend15_6 . 18 0 0 1.2
tertdend15_7 . 18 0 0 1.2 
tertdend15_8 . 18 0 0 1.2
tertdend15_9 . 18 0 0 1.2
tertdend15_10 . 18 0 0 1.2
tertdend15_11 . 18 0 0 1.2
   
tertdend16_1 secdend42 18  0  0  1.2
tertdend16_2 . 18 0 0 1.2 
tertdend16_3 . 18 0 0 1.2
tertdend16_4 . 18 0 0 1.2
tertdend16_5 . 18 0 0 1.2
tertdend16_6 . 18 0 0 1.2
tertdend16_7 . 18 0 0 1.2
tertdend16_8 . 18 0 0 1.2
tertdend16_9 . 18 0 0 1.2
tertdend16_10 . 18 0 0 1.2
tertdend16_11 . 18 0 0 1.2
