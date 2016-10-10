//genesis
// PSim_Params.g

/***************************		MS Model, Version 12	***************/
//*********** includes - functions for constructing model and outputs, and  doing simulations
include SimParams.g                   //simulation control parameters, can be overridden in this file
simdt=5e-6//2e-5
//outputclock=1e-4
spinesYesNo=1
synYesNo=1
delay= 0.2
duration = 0.4
//****** Globals and Parameters that can be changed in this script for the simulation
pfile="MScell/MScelltaperspines.p"//"MScell/MScellPrimSecSpines.p"//"MScell/MScelltaperspines.p"//"MScell/MScelltaperspines_SingleBranchNarrow.p" //Simplified morphology for tuning
str comps="soma,primdend1,secdend11,tertdend1_1,tertdend1_2,tertdend1_3,tertdend1_4,tertdend1_5,tertdend1_6,tertdend1_7,tertdend1_8,tertdend1_9,tertdend1_10,tertdend1_11" //These should include comps of stim spines to see NMDA
str chans="CaL12_channel,CaL13_channel,CaR_channel,CaN_channel,CaR_channel,CaT_channel,BK_channel,KIR_channel,KAf_channel,NaF_channel,SK_channel,NaFd_channel,KAs_channel,Krp_channel"


include MScell/globals.g //change below

//ELEAK = -.071//-.077 best//-.072//ELEAK*.4985//{ELEAK*.3*1.667}//-.075//-0.029478
//RA = 1.5//2.0//RA*7.199//{RA*6.9*1.67}//1.5//13.7657
//RM = 1.5//1.5= better IF//1.05//1.05 is best so far//.6//.5//0.8//0.5//0.75//1.0//10.0//RM*.5503//2//{RM*0.99*0.759}//.4//.1//.5//.2//8.97763
//CM = .005//.01//2*CM*.2734//{CM*0.5*0.95*4}//0.035
EREST_ACT = -.0835

//float qfactorKir = 1.2//1.2   


//gNaFsoma_UI = 0
gNaFprox_UI =2500
gNaFdist_UI = 450
//gNaFsoma_UI=44000//{40000} //50000
//gNaFprox_UI={2730}
//gNaFdist_UI={975}
gCaL13soma_UI = {{2*3e-7}/{GHKluge}}
gCaL13dend_UI = {{.5*0.5e-8}/{GHKluge}}
//gCaTprox  =  {{0e-8}/{GHKluge}}
gCaTdist  =  {{.5*8e-8}/{GHKluge}}
gCaRsoma  =  {{2*8e-7}/{GHKluge}}
gCaRdend  ={{.5*10e-7}/{GHKluge}}
gCaNsoma =   {{2*12e-7}/{GHKluge}}
//gCaNdend =   {{0}/{GHKluge}}
gCaL12soma_UI = {{2*6e-7}/{GHKluge}}
gCaL12dend_UI = {{.5*1*1e-7}/{GHKluge}}
//gKIRsoma_UI = 9.5//9 best//14//gKIRsoma_UI*.6826//{gKIRsoma_UI*.67*.867}// {10.0} //25.0658
//gKIRdend_UI = 0//9.5//10//10=best//14//20//gKIRsoma_UI//{15}
//gKAfsoma_UI=217//190//170//100//160= good//50//25//50//100//315//250//{200}
//gKAfdend_UI=0//gKAfsoma_UI//{90}
//gKAssoma_UI=12//9//40//100//100//25//{100}
//gKAsdend_UI=0//gKAssoma_UI//{10}
//gKrpsoma =5//6//6
//gKrpdend=0//gKrpsoma//3 //6

//gBKdend =0//2// 5//5
//gBKsoma = 3//10//10 //20

//gSKdend = 0//1//1
//gSKsoma = 2//2//3

//qfactorkAs=2//3//9//2
//qfactorNaF = 2.5
//qfactorKrp = 3
//qfactorkAf=2.0//1.5 orig//2//3//2

include MScell/Ca_constants.g
calciumdye = 0//2
calciuminact = 1
calciumtype=0
if (calciumdye == 0)
	btotal2 = 15.0e-3 	//was 30.0e-3, but Rodrigo's paper seems to have about half the CaM as Myungs.
else
	btotal2 = 0.0e-3		//CaM is 'dialyzed' when there is a calcium dye present
end
if (calciumdye == 0)
	 btotal4 = 15.0e-3 	//was 30.0e-3, but Rodrigo's paper seems to have about half the CaM as Myungs.
else
	 btotal4 = 0.0e-3		//CaM is 'dialyzed' when there is a calcium dye present
end
if (calciumdye==1)
    btotalfluor={btotal3}
    kffluor={kf3}
    kbfluor={kb3}
    bnamefluor={bname3}
    dfluor={d3}
elif (calciumdye==2)
    btotalfluor={btotal5}
    kffluor={kf5}
    kbfluor={kb5}
    bnamefluor={bname5}
    dfluor={d5}
end

include MScell/SynParamsCtx.g
AMPAgmax=1.0e-9//1.7e-9 //0.3e-9
N2Aratio=1.0//1.0
NMDAgmax   = {AMPAgmax}*{N2Aratio}
float	Kmg       = 18 //18 new //3.57 old overwrites 1/eta in nmda_channel.g

include MScell/spineParams.g
//spineRa= 0.5e15//0.5e9
spineRM = {RM} //10
//spineRA = {RA}//1//1
//gCaL12spine       = 0//{getglobal gCaL12dend_{DA}} //3.35e-7
//gCaL13spine       = 0//{getglobal gCaL13dend_{DA}} //4.25e-7
//gCaRspine         = 0//{gCaRdend}   //13e-7
gCaTspine         = {gCaTdist}   //0.235e-7
spineDensity=1.12//1.12//0.8//1//0.3 //in units of per micron

