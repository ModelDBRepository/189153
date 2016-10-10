//genesis
// MSsimSyn.g 

/***************************		MS Model, Version 12	***************/
//*********** includes - functions for constructing model and outputs, and  doing simulations
include SimParams.g                   //simulation control parameters, can be overridden in this file
include MScell/globals.g
include MScell/Ca_constants.g
include MScell/SynParamsCtx.g
include MScell/spineParams.g
include MScell/MScellSynSpines	      // access make_MS_cell 
include InOut/add_output.g            //functions for ascii file output
include InOut/IF.g                    //function to create pulse generator for current injection, also IF & IV curves
include InOut/HookUp.g                  //run STDP protocols - single PSP with current injection
//include InOut/SpikeMakerFunctions.g   //functions to create randomspikes and connect to synapes
//include InOut/PreSynSync.g            //functions for setting up synchronous pre-synaptic stimulation
//include InOut/UpState.g               //run upstate simulations - asynchronous synaptic stimulation
//include InOut/UpStateSTDP.g           //run upstate simulations
//include InOut/PlasStim.g              //run plasticity protocols - pattern of PSPS, no current injection

/*//include InOut/ConstrainUp.g
//include RebekahSims/Store_Parameters.g
//include graphics7.g

//set random seed so for each simulation the randomspike train will be the same
//3 = 5757538
//5 = 9824501
//4 = 2394075
//6 = 492
//7 = 2370
//int seedvalue= 5757538

//**************** end of parameters, now contruct model and do simulations*/

setclock 0 {simdt}         
setclock 1 {outputclock}
echo Paradigm list: Fino, Shen, P_and_K (Pawlak and Kerr), K_and_P (Kerr and Plenz), Shindou, 3_AP (just the soma injections from Shindou), 1_AP, 1_PSP
str DA = {input "MSN type:" "UI"} 
str Protocol = {input "Protocol:" "P_and_K"}
str Timing = {input "Timing:" "Pre"}
str Location = {input "Location:" "tertdend1_1"}
str jitter = {input "With jitter:" "No"}
int seedvalue = {input "Random seed:" 5757538}

echo "DA" {DA}
echo "Protocol" {Protocol}
echo "Timing" {Timing}
echo "Jitter" {jitter}
if ({Protocol}=="P_and_K")
        str  pname = "PandK"
elif ({Protocol}=="P_and_K_1_AP")
        str  pname = "PandK1AP"
elif  ({Protocol}=="K_and_P")
        str  pname = "KandP"
else
        str pname = {Protocol}
end

int jitter_int = 0
if (({jitter}!="No") && ({jitter}!="no"))
    jitter_int = 1
end

str diskpath="SimData/"@{pname}@"_"@{DA}@"_"@{Timing}@"_randseed_"@{seedvalue}@"_high_res"
if ({GABAtonic})
        diskpath = {diskpath}@"_tonic_gaba"
end
if ({calciumtype})
        diskpath = {diskpath}@"_simple_calcium"
end
//include PSim_Params.g
int totspine={make_MS_cell_SynSpine {neuronname} {pfile} {spinesYesNo} {DA}}	// MS_cell.g
reset

/*uncomment the following lines (and one line in MScell.g) to use the hsolver
        setfield  {neuronname}  chanmode 1 
        call {neuronname} SETUP
        setmethod 11
*/	
//Store_Parameters
echo {Vmfile}
//Set up asc_file outputs and get headers for the files
if ( {calciumdye} == 0)
        Vmfile = {Vmfile}
elif ( {calciumdye} == 1)
        Vmfile = {Vmfile}@"_Ca_Fura_2"
elif  ( {calciumdye} == 2)
        Vmfile = {Vmfile}@"_Ca_Fluo_5f"
elif  ( {calciumdye} == 3)
        Vmfile = {Vmfile}@"_Ca_Fluo_4"
else
        Vmfile = {Vmfile}@"_Ca_unnkown_dye"
end 

 Vmhead={add_outputVm {comps} {Vmfile} {neuronname}}
        
if ({CaOut})
    if ( {calciumdye} == 0)
        Cafile = "Ca"
    elif  ( {calciumdye} == 1)
        Cafile = "Ca_Fura_2"
    elif  ( {calciumdye} == 2)
        Cafile = "Ca_Fluo_5f"
    elif  ( {calciumdye} == 3)
        Cafile = "Ca_Fluo_4"
    else
        Cafile = "Ca_unnkown_dye"
    end
    if ({plastYesNo})
        Cafile = {Cafile}@"_plasticity"
    end 
    Cahead={add_outputCal {comps} {CaBufs} {Cafile} {neuronname}}
else
    Cafile="Unknown_Ca"
     if ({plastYesNo})
        Cafile = {Cafile}@"_plasticity"
    end    
    Cahead=""
end

if ({GkOut})
    Gkfile="Gk"
    if ({plastYesNo})
        Gkfile = {Gkfile}@"_plasticity"
    end
    if ( {calciumdye}== 0)
        Gkfile = {Gkfile}
    elif ( {calciumdye}== 1)
        Gkfile = {Gkfile}@"_Ca_Fura_2"
    elif  ( {calciumdye}== 2)
        Gkfile = {Gkfile}@"_Ca_Fluo_5f"
    elif  ( {calciumdye}== 3)
        Gkfile = {Gkfile}@"_Ca_Fluo_4"
    else
        Gkfile = {Gkfile}@"_Ca_unnkown_dye"
    end
    Gkhead={add_outputGk {comps} {chans} {Gkfile} {neuronname}}
else
    Gkfile="Unknown_Gk"
    if ({plastYesNo})
        Gkfile = {Gkfile}@"_plasticity"
    end
    if ( {calciumdye}== 0)
        Gkfile = {Gkfile}
    elif ( {calciumdye}== 1)
        Gkfile = {Gkfile}@ "_Ca_Fura_2"
    elif  ( {calciumdye}== 2)
        Gkfile = {Gkfile}@"_Ca_Fluo_5f"
    elif  ( {calciumdye}== 3)
        Gkfile = {Gkfile}@"_Ca_Fluo_4"
    else
        Gkfile = {Gkfile}@"_Ca_unnkown_dye"
    end    
    Gkhead=""
end
 
str stimcomp= {Location}
str spinefile="spine"

if ({plastYesNo})
        spinefile = {spinefile}@"_plasticity"

            
end
if ( {calciumdye} == 0)
        spinefile = {spinefile}
elif ( {calciumdye} == 1)
        spinefile = {spinefile}@"_Ca_Fura_2"
elif  ( {calciumdye} == 2)
        spinefile = {spinefile}@"_Ca_Fluo_5f"
elif  ( {calciumdye} == 3)
        spinefile = {spinefile}@"_Ca_Fluo_4"
else
        spinefile = {spinefile}@"_Ca_unnkown_dye"
end    
ce /

/***************************** Simulations of STDP */
if ({Protocol}=="Shen")
	include InOut/Shen.g
    if ({DA} == "D1")
        inject = 1.45e-9
    elif ({DA} == "D2")
        inject = 1.3e-9
    end
elif ({Protocol}=="P_and_K")
	include InOut/P_K.g
elif ({Protocol}=="P_and_K_1_AP")
	include InOut/P_K_1_AP.g
elif ({Protocol}=="Fino")
	include InOut/Fino.g
elif ({Protocol}=="Shindou")
	include InOut/Shindou.g
elif ({Protocol}=="K_and_P")
    include InOut/Kerr_and_Plenz.g
elif ({Protocol}=="3_AP")
    include InOut/3_AP.g
elif ({Protocol}=="1_AP")
    include InOut/1_AP.g
elif ({Protocol}=="1_PSP")
    include InOut/1_PSP.g
elif ({Protocol}=="no_stim")
    include InOut/no_stim.g
elif ({Protocol}=="IF")
    //setclock 1 {outputclock}
    setclock 0 {simdt}         
    setclock 1 {simdt}    
	numcurr = 5 
	injectstart = .1e-9
	IFcurve {injectstart} {inc} {numcurr} {delay} {duration} {diskpath}
        
end





// if ({Protocol}!="IF")
//     float newTrainFreq = {burstFreq}/{numbursts}
//     echo {newTrainFreq}
//     echo {prestim} {Protocol} {Timing} {stimcomp} {diskpath} {numAP} {inject} {AP_durtime} {APinterval} {ISI} {pulseFreq} {pulses} {burstFreq} {numbursts} {newTrainFreq} 1 {jitter_int}
// 	HookUp {prestim} {Protocol} {Timing} {stimcomp} {diskpath} {numAP} {inject} {AP_durtime} {APinterval} {ISI} {pulseFreq} {pulses} {burstFreq} {numbursts} {newTrainFreq} 1 {jitter_int}
   
//     step 2.6 -time

//     fileFLUSH {Vmfile} 
//     fileFLUSH {Cafile} 
//     fileFLUSH {Gkfile} 
//     fileFLUSH {spinefile}
//     fileFLUSH {somainjfile}

// end

reset
if ({numtrains}>1)
        reset

        //uncomment the following lines (and one line in MScell.g) to use the hsolver
      
  //setfield  {neuronname}  chanmode 1 
        //call {neuronname} SETUP
        //setmethod 11
        	

        ce /

        setclock 0 {simdt}        
        setclock 1 {outputclock}

        str diskpath="SimData/"@{pname}@"_"@{DA}@"_"@{Timing}@"_randseed_"@{seedvalue}@"_low_res"

        if ({Protocol}!="IF")
    
            HookUp {prestim} {Protocol} {Timing} {stimcomp} {diskpath} {numAP} {inject} {AP_durtime} {APinterval} {ISI} {pulseFreq} {pulses} {burstFreq} {numbursts} {trainFreq} {numtrains} {jitter_int}
           
            step {numtrains/trainFreq} -time
        
        
            fileFLUSH {Vmfile} 
            fileFLUSH {Cafile} 
            fileFLUSH {Gkfile} 
            fileFLUSH {spinefile}
            fileFLUSH {somainjfile}
        end
end
