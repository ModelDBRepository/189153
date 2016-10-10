//genesis
//SynParamsCtx.g
str AMPAname = "AMPA"
float EkAMPA = 0.0
float AMPAtau1 = 1.1e-3   //wolf with qfact of 2 taken into account (t1 and t2)
//float AMPAtau2 = 5.75e-3  //these tau are quite slow compared to hippocampal values
//float AMPAgmax = 0.51e-9 // 45 mV PSP, AP calcium trivial compared to PSP
//float AMPAtau1=0.2e-3
float AMPAtau2=2.0e-3 // double hippo values; faster than GABA
float AMPAgmax=0.125e-9  //0.15 0.19 25 mV PSP, AP calcium higher than PSP calcium 0.342e-9
float AMPACaper = 0.00 //0.001 //percent AMPA conductance that is carried by calcium. value from wolf							//more like 2/1 for thalamus so should be 0.47e-9 for thalamo-striatal syanpnse if NMDA is 0.94e-9 Rebekah Evans 6/25/10
float AMPAdes = 1 // 1  		//desensitization factor, (depr_per_spike field of facsynchan)
float AMPAdestau = 100e-3 // 100e-3	// desensitization tau (how fast des recovers)
float depr = 1
float deprtau = 100e-3 


str GABAname = "GABA"
float GABAtau1 = 0.25e-3    // From Galarreta and Hestrin 1997 
float GABAtau2 = 80.75e-3    //(used in Wolfs model)
float EkGABA = -0.060  		//calculated Kerr and Plenz 2004 Erev for Cl, is -60 mV 5/2/12 RCE
float GABAgmax = 5000e-12  //was 750, Sri uses 900 //Modified Koos 2004 (Wolf uses 435e-12)//5000 if GABAtau2 is 75 ms (NPY neurons)
//10000e-12 if GABAtau2 is 3.75ms
float GABAdelay =  0.015
int ghk_yesno=1  //0 no ghk objects for NMDA, 1 add ghk to NMDA 
			 //ghk reduction factor and hoook ups to calcium shells are in Addsynapticchannels.g


// parameters for NMDA subunits
// cortex
str	    subunit = "ctx" 
float   EkNMDA   = 0
float	Kmg       = 18 //18 new //3.57 old overwrites 1/eta in nmda_channel.g
if ({subunit}=="NR2A")
    float	NMDAtau2      = {(50e-3)/2} 
elif ({subunit}=="NR2B")
    float NMDAtau2 = (300e-3)/2 
elif ({subunit}=="ctx")
    float NMDAtau2 =  (112.5e-3)/2  //	ctx avg for .25 NR2B and .75 NR2A. 
else
    echo "no other NMDA subunits defined in SynParamsCtx.g"
end
float   N2Aratio=1.0  //NMDA to AMPA ratio of 1:1 is in middle of measured range for striatum
float	NMDAgmax   = {AMPAgmax}*{N2Aratio} //0.94e-9 NR2A and B from (Moyner et al., 1994 figure 7)
                      //0.47e-9 using 2.75:1 NMDA:AMPA (Ding 2008), which is extreme.  
float   NMDAperCa = 0.2 // percent calcium influx Note: Divided by 2 in AddSynapticChannel for GHK case because of the enhanced driving potential: ohmic to GHK, reversal potentail from 0 to huge value
float 	NMDAfactGHK = 55e-9//35e-9 	//adjustment factor for GHK to calcium shell/pool
//This is necessary because GHK reads in Gk from block and interprets it as permeability.  this results in ridiculous current, restored to normal by factor of ~e-8
float   NMDAdes = 0 //1  		//desensitization factor, (depr_per_spike field of facsynchan)
float   NMDAdestau = 0 //200e-3	// desensitixation t (how fast des recovers)
str NMDAname = {subunit}

//for saving info on distal or proximal dendrites or massed and spaced. formula typeof dend, # of spines.

//parameters for NMDA calcium interactions
int NMDABufferMode = 0  // 1, connect both NMDA and AMPA calcium to Calcium_pool
                            // 0, connect only NMDA currents to calcium_pool
str bufferNMDA="Ca_pool_nmda"
if ({calciumtype}==0)
    str NMDApool= {CalciumName}@"1"
else
    str NMDApool={bufferNMDA}
end
