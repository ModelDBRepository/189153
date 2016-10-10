//genesis

/***************************		MS Model, Version 9.1	**********************
**************************** 	      	globals.g 			**********************

******************************************************************************/
//Updated 6 November 2014 by Dan Dorman: ELEAK, RA, RM, CM, EREST_ACT, somaLen,gKIRsoma_UI, gKIRdend_UI were updated following optimization to hyperpolarized experimental current injection responses and changing soma morphology to cylindrical
str compartment = "symcompartment" //set compartment type
//Careful - all of these can be overridden in the .p file
if ({GABAtonic})
    float ELEAK = -.18//.29
else
    float ELEAK = -.071//-0.029478
end
float PI = 3.1415926
float RA = 1.5//13.7657 Range = 1 - 3
float RM = 1.5//8.97763 Range from KochSegev p175 = 2 - 10
float CM = 0.005//0.035  Range = .005 to .015
float EREST_ACT = -0.0805//-.087
float TEMPERATURE = 35
float GHKluge=1e-7  //This param is required because getglobals only has 6 figs to right of decimal
                    //dividing by GHKluge is reversed in AddCaSpines.g and 
//parameters determined by hand tuning to match spike width, AHP shape &amp, fI curve

float somaLen=11.3137e-6 
float prox=42.1e-6 //26.1e-6 //primary and secondary
float mid=60.1e-6 //62.1e-6 //tert1 
float dist=1000e-6

	float gNaFsoma_D1={47500}    //50000 0.95x
        float gNaFprox_D1={2593}     //5700 6000	//includes mid
        float gNaFdist_D1={926}     //1900 2000	

	float gNaFsoma_D2={55000}    //50000 1.1x
        float gNaFprox_D2={2730}     //6000	//includes mid
        float gNaFdist_D2={975}     //2000	

	float gNaFsoma_D1PD={47500}    //50000 0.95x
        float gNaFprox_D1PD={2593}     //6000	//includes mid
        float gNaFdist_D1PD={926}     //2000	

	float gNaFsoma_D2PD={55000}    //55000 1.1x
        float gNaFprox_D2PD={2730}     //6600	//includes mid
        float gNaFdist_D2PD={975}     //2200	

	float gNaFsoma_UI={44000}    //50000 1.1x
        float gNaFprox_UI={1*2730}     //6000	//includes mid
        float gNaFdist_UI={1*975}     //2000	


/*This set of KAf*/
        float gKAfsoma_UI={217}      //{300}

        float gKAfdend_UI={217} //{550}
	//If gKAfdend is too low, get bursting, if too high, no spikes

	float gKAfsoma_D1={200}      //{300}

        float gKAfdend_D1={100} //{550}
	//If gKAfdend is too low, get bursting, if too high, no spikes

	float gKAfsoma_D2={200}      //{300}

        float gKAfdend_D2={100} //{550}
	//If gKAfdend is too low, get bursting, if too high, no spikes

	float gKAfsoma_D1PD={200}      //{300}

        float gKAfdend_D1PD={100} //{550}

	float gKAfsoma_D2PD={200}      //{300}
	float gKAfdend_D2PD={56} //{550}


        float gKAssoma_D1={250}  
        float gKAsdend_D1={38.93}  //includes mid 

	float gKAssoma_D2={275}  //220 1.1x 
        float gKAsdend_D2={47.02} //22 //includes mid 

	float gKAssoma_D1PD={250}  
        float gKAsdend_D1PD={38.93}  //includes mid 

	float gKAssoma_D2PD={275}  //220 1.1x 
        float gKAsdend_D2PD={47.02} //22.2 //includes mid 

	float gKAssoma_UI={13}  //220 1.1x 
        float gKAsdend_UI={13} //22 //includes mid 
//Has effect on number of spikes, but not AHP amplitude

//Need to repeat sims with gKAs blocked - similar results to Shen .. Surmeier?

        float gKIRsoma_D1={31.3322} //{11} 1.25x        
        float gKIRdend_D1={31.3322}

	float gKIRsoma_D2={25.0658} //{11}        
        float gKIRdend_D2={25.0658}

	float gKIRsoma_D1PD={31.3322} //{11} 1.25x        
        float gKIRdend_D1PD={31.3322}

	float gKIRsoma_D2PD={25.0658} //{11}        
        float gKIRdend_D2PD={25.0658}

	float gKIRsoma_UI={9.5} //{11}        
        float gKIRdend_UI={9.5}

	float gKrpsoma={5}  //10.008 is 14    
	float gKrpdend={5}
//Has effect on number of spikes, but not AHP amplitude

//Better to lower this and raise gKAs?

	float gBKsoma={3}
	float gBKdend={2}
//Higher value gave better AHPs.  
//Increase in gBKsoma was compensated by lower gKAfdend and gKAssoma
//Perhaps a bit too high - does this prevent KAs from doing its thing?

	float gSKsoma={2}
	float gSKdend={1}

	float gCaL13soma_D1 = {{3e-7}/{GHKluge}}  //{{6e-7}/{Cafactor}}  		
	float gCaL13dend_D1 = {{0.5e-8}/{GHKluge}} //{{gCaL13soma}/{Dendfactor}} 

	float gCaL13soma_D2 = {{0.75}*{3e-7}/{GHKluge}}  //{{6e-7}/{Cafactor}}  //0.75x		
	float gCaL13dend_D2 = {{0.75}*{0.5e-8}/{GHKluge}} //{{gCaL13soma}/{Dendfactor}} 

	float gCaL13soma_D1PD = {{3e-7}/{GHKluge}}  //{{6e-7}/{Cafactor}}  		
	float gCaL13dend_D1PD = {{0.5e-8}/{GHKluge}} //{{gCaL13soma}/{Dendfactor}} 

	float gCaL13soma_D2PD = {{0.75}*{3e-7}/{GHKluge}}  //{{6e-7}/{Cafactor}}  //0.75x		
	float gCaL13dend_D2PD = {{0.75}*{0.5e-8}/{GHKluge}} //{{gCaL13soma}/{Dendfactor}} 

	float gCaL13soma_UI = {{3e-7}/{GHKluge}}  //{{6e-7}/{Cafactor}}  		
	float gCaL13dend_UI = {{0.5e-8}/{GHKluge}} //{{gCaL13soma}/{Dendfactor}} 
	
	float gCaTprox  =  {{0e-8}/{GHKluge}} //{{10e-8}/{Cafactor}}         
	float gCaTdist  =  {{8e-8}/{GHKluge}} 

	float gCaRsoma  =  {{8e-7}/{GHKluge}} //{{18e-7}/{Cafactor}}		
	float gCaRdend  =  {{10e-7}/{GHKluge}} //{{gCaRsoma}/{Dendfactor}}	

	float gCaNsoma =   {{12e-7}/{GHKluge}} //{{10e-7}/{Cafactor}}       
	float gCaNdend =   {{0}/{GHKluge}} //{{gCaNsoma}/{Dendfactor}}       

	float gCaL12soma_D1 = {{2}*{6e-7}/{GHKluge}} //{{6e-7}/{Cafactor}} //2x   	
	float gCaL12dend_D1 = {{2}*{1e-7}/{GHKluge}} //{{gCaL12soma}/{Dendfactor}} 

	float gCaL12soma_D2 = {{6e-7}/{GHKluge}} //{{6e-7}/{Cafactor}}    	
	float gCaL12dend_D2 = {{1e-7}/{GHKluge}} //{{gCaL12soma}/{Dendfactor}} 

	float gCaL12soma_D1PD = {{2}*{6e-7}/{GHKluge}} //{{6e-7}/{Cafactor}} //2x   	
	float gCaL12dend_D1PD = {{2}*{1e-7}/{GHKluge}} //{{gCaL12soma}/{Dendfactor}} 

	float gCaL12soma_D2PD = {{6e-7}/{GHKluge}} //{{6e-7}/{Cafactor}}    	
	float gCaL12dend_D2PD = {{1e-7}/{GHKluge}} //{{gCaL12soma}/{Dendfactor}} 

	float gCaL12soma_UI = {{6e-7}/{GHKluge}} //{{6e-7}/{Cafactor}}    	
	float gCaL12dend_UI = {{1e-7}/{GHKluge}} //{{gCaL12soma}/{Dendfactor}} 
    
	float gtonicGABAdend={650e-2} //tonic GABA parameters//1300e-2
    float x0GABA = 40e-6 //sigmoidal function parameters//20e-6
    float kGABA = 0.8e-4

float qfactorKir = 1.2   
float qfactorKrp = 3   //3 2
float qfactorNaF = 2.5  //2.5  1.7
float qfactorkAs=2     //3  2
float qfactorkAf=2   //1.5  1.5
float qfactCa = 2      //3  2
//bk and sk qfacts are taken into account in their channel files. 
