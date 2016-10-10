//genesis

/***************************		MS Model, Version 9.1	**********************
**************************** 	      	globals.g 			**********************

******************************************************************************/

//Careful - all of these can be overridden in the .p file
        float ELEAK = -0.06
        float PI = 3.1415926
        //float RA = 1.0 //determined by .p file (6)
        float RM = 2.8  //8.69565217  not overwritten in .p file, this is the right value
        //float CM = 0.01  //is determined in .p file (altered to compensate for lack of spines)
        float EREST_ACT = -0.085 //-85 mV
 	float TEMPERATURE = 35

//parameters determined by hand tuning to match spike width, AHP shape &amp, fI curve

float somaLen=16.1e-6
float prox=26.1e-6
float mid=60e-6
float dist=1000e-6

	float gNaFprox={50000}    
        float gNaFmid={6000}	
        float gNaFdist={1000}	

        float gKAfprox={300}      
        float gKAfmid={{550}}     
        float gKAfdist={{550}}	

        float gKAsprox={200}  
        float gKAsdist={22}  //includes mid 

        float gKIRsoma={11} //{11}        
        float gKIRdend={11}

	float gKrpsoma={14}  //10.008 is 14     
	float gKrpdend={14}
	
	float gBKsoma={10}
	float gBKdend={10}

	float gSKsoma={1}
	float gSKdend={1}

float Cafactor = 1 	//multiply by 
float Dendfactor = 1

	float gCaL13soma = {{3e-7}*{Cafactor}}  //{{6e-7}/{Cafactor}}  		
	float gCaL13dend = {{1.5e-8}*{Dendfactor}} //{{gCaL13soma}/{Dendfactor}} 
	
	float gCaTsoma  =  {{7e-8}*{Cafactor}} //{{10e-8}/{Cafactor}}         
	float gCaTdend  =  {{3e-8}*{Dendfactor}} //{{gCaTsoma}/{Dendfactor}} 

	float gCaRsoma  =  {{8e-7}*{Cafactor}} //{{18e-7}/{Cafactor}}		
	float gCaRdend  =  {{10e-7}*{Dendfactor}} //{{gCaRsoma}/{Dendfactor}}	

	float gCaNsoma =   {{12e-7}*{Cafactor}} //{{10e-7}/{Cafactor}}       
	float gCaNdend =   {{0}*{Dendfactor}} //{{gCaNsoma}/{Dendfactor}}       

	float gCaL12soma = {{6e-7}*{Cafactor}} //{{6e-7}/{Cafactor}}    	
	float gCaL12dend = {{1.5e-7}*{Dendfactor}} //{{gCaL12soma}/{Dendfactor}} 
			


float qfactorKir = 3
float qfactorKrp = 3
float qfactorNaF = 2.5
float qfactorkAs=3
float qfactorkAf=1.5
float qfactCa = 3
//bk and sk qfacts are taken into account in their channel files. 
