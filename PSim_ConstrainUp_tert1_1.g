//genesis
// MSsimSyn.g 

/***************************		MS Model, Version 12	***************/
//*********** includes - functions for constructing model and outputs, and  doing simulations
include PSim_Params.g                   //simulation control parameters, can be overridden in this file

include MScell/MScellSynSpines	      // access make_MS_cell 
include InOut/add_output.g            //functions for ascii file output
include InOut/IF.g                    //function to create pulse generator for current injection, also IF & IV curves
include InOut/SpikeMakerFunctions.g   //functions to create randomspikes and connect to synapes
include InOut/PreSynSync.g            //functions for setting up synchronous pre-synaptic stimulation
include InOut/UpState.g               //run upstate simulations - asynchronous synaptic stimulation
include InOut/UpStateSTDP.g           //run upstate simulations
include InOut/PlasStim.g              //run plasticity protocols - pattern of PSPS, no current injection
include InOut/STDP.g                  //run STDP protocols - single PSP with current injection
include InOut/ConstrainUp.g
//include RebekahSims/Store_Parameters.g
include graphics7.g

str prestim = 2
float pulseFreq = 1
int pulses = 1
pulseYN = 0
//Post-synaptic parameters
float inject=1e-9 //1e-9
float burstFreq = 1 
int numbursts = 1
float trainFreq=1
int numtrains=1

AP_durtime=0.005 
float APinterval={1.0/50.0}
int numAP=1

float isi=0.4

//block spine channels
//gCaL12spine = 0
//gCaL13spine = 0
//gCaRspine = 0
//gCaTspine = 0

//set random seed so for each simulation the randomspike train will be the same
//3 = 5757538
//5 = 9824501
//4 = 2394075
//6 = 492
//7 = 2370
int seedvalue= 5757538

//**************** end of parameters, now contruct model and do simulations

setclock 0 {simdt}         
setclock 1 {outputclock}





str diskpath="SimData/PSim_ConstrainUp"

int totspine={make_MS_cell_SynSpine {neuronname} {pfile} {spinesYesNo} {DA}}	// MS_cell.g
reset

/*uncomment the following lines (and one line in MScell.g) to use the hsolver
        setfield  {neuronname}  chanmode 1 
        call {neuronname} SETUP
        setmethod 11
*/	
//Store_Parameters

//Set up asc_file outputs and get headers for the files
Vmhead={add_outputVm {comps} {Vmfile} {neuronname}}
if ({CaOut})
    Cafile="Ca"
    Cahead={add_outputCal {comps} {CaBufs} {Cafile} {neuronname}}
else
    Cafile="X"
    Cahead=""
end
if ({GkOut})
    Gkfile="Gk"
    Gkhead={add_outputGk {comps} {chans} {Gkfile} {neuronname}}
else
    Gkfile="X"
    Gkhead=""
end

str stimcomp= "tertdend1_1"
str spinefile="spine"

multispinefile = "multispines"
//multispinehead={add_outputSpines {substring {comps} 15} {CaBufs} {multispinefile} {neuronname}}

ce /

//Simulation of "upstate" by stimulation of limited number of spines, e.g. Plotkin et al.
//This is specific to a neuron with spines.  Won't work otherwise
int numstim=20
str startcomp=stimcomp//"tertdend1_1" //tertdend1_1 or 1_5
int parenttype=3
float maxpath= 0.0001
float maxdelay= 0.002
float mindelay = 0.002
//Note that function call to setup multi spine files is within ConstrainUp
ConstrainUp {numstim} {startcomp} {parenttype} {maxpath} {mindelay} {maxdelay} {diskpath}

quit

