//genesis
//ConstrainUp.g
/*Functions used to connect a set of spines that are constrained by
 *pathlength from soma
 *sharing a common parent branch, either soma, primary, secondary, or tertiary
*/

function ConnectWithDelay (minDelay, maxDelay, othercell, compt, meanDelay)
	str othercell, compt
	float maxDelay, minDelay, meanDelay

	float StimDelay
	int i

	StimDelay={rand {minDelay} {maxDelay}}
    //echo "minDelay: " {minDelay} " maxDelay: " {maxDelay} " StimDelay: " {StimDelay}
	addmsg   {othercell}/spikegen  {compt}/{NMDAname} SPIKE 
	addmsg   {othercell}/spikegen  {compt}/{AMPAname} SPIKE 
	int msgnum = {getfield {compt}/{NMDAname} nsynapses} - 1
    setfield {compt}/{NMDAname} synapse[{msgnum}].weight 1 synapse[{msgnum}].delay {StimDelay+meanDelay}
	msgnum = {getfield {compt}/{AMPAname} nsynapses} - 1
    setfield {compt}/{AMPAname} synapse[{msgnum}].weight 1 synapse[{msgnum}].delay {StimDelay+meanDelay}

	return {StimDelay}

end

/* This function loops through all spines to either count the number filling criteria
   or to connect one of those spines */
function spineLoop(startcomp,parenttype,maxpath,connectProb,maxdelay,mindelay)
    int parenttype
	str startcomp, connectProb
	float maxpath,maxdelay,mindelay

	float compPathLen,ConnProb, rannum,StimDelay,meanDelay=0
	str compt,compParent,commonBranch
	int numsp=0,connect=0
    //echo "spineLoop function minDelay= " {mindelay}
	//extract minpath from the starting compartment
	//maxpath is the total distance between start comp and most distance spine
	float minpath={getfield {neuronname}/{startcomp} pathlen}-{getfield {neuronname}/{startcomp} len}/2
	maxpath={minpath}+{maxpath}

	//strcmp returns 0 if connectProb = 0, so we do this only if NE 0
	if ({strcmp {connectProb} "0"})
		connect=1
		ConnProb={connectProb}
	end
		
	//parenttype is either 0:soma, 1:parentprim, 2:parentsec, 3:parenttert
	if ({parenttype}==0)
		commonBranch="soma"
	elif ({parenttype}==1)
		commonBranch={getfield {neuronname}/{startcomp} parentprim}
	elif ({parenttype}==2)
		commonBranch={getfield {neuronname}/{startcomp} parentsec}
	elif ({parenttype}==3)
		commonBranch={getfield {neuronname}/{startcomp} parenttert}
	end

	foreach compt ({el {neuronname}/##[TYPE=symcompartment]}) 
		//is this a spine head, if so, determine pathlength
		if ({strcmp {getpath {compt} -tail} "head"} == 0)
			compPathLen={getfield {compt} pathlen}
			//is pathlength within min and max?  If so, determine parent branch
			if ((compPathLen > minpath) && (compPathLen < maxpath))
				if ({parenttype} == 1)
					compParent={getfield {compt} parentprim}
				elif ({parenttype} == 2)
					compParent={getfield {compt} parentsec}
				elif ({parenttype} == 3)
					compParent={getfield {compt} parenttert}
				else
					compParent="soma"
				end
				//is parent branch correct?  if so either count it (first time through loop) or connect with probability
				if ({strcmp {compParent} {commonBranch}}==0)
					if (connect)
						rannum={rand 0 1}
						if ({rannum}<{ConnProb})
							StimDelay={ConnectWithDelay {mindelay} {maxdelay} {precell} {compt} {meanDelay}}
							//count connected spines
							numsp=numsp+1
							meanDelay=meanDelay+StimDelay
							echo "connect" {compt} "ranum" {rannum} "stimdelay" {StimDelay} "totaldelay" {meanDelay} 
						else
							echo "no connect" {compt} {rannum} "gt" {ConnProb}
						end
					else
						//count valid spines
						echo "valid sp" {compt} {compPathLen} "bt" {minpath} "&" {maxpath} "par:" {compParent} "numsp" {numsp+1}
						numsp=numsp+1
					end
				end
			end
		end
	end
	if (connect)
		echo "meanDelay=" {meanDelay/numsp} "num connect=" {numsp}
	end
	return {numsp}
end

function ConstrainUp(numstim,startcomp,parenttype,maxpath,mindelay,maxdelay,file)
    int numstim,parenttype
	str startcomp,file
	float maxpath,maxdelay,mindelay

	str noConnect="0"
	int nummsg=0
	float initSim=0.1,postSim=0.52

    //*********set up presynaptic element for stimulating
	PreSynStim {precell}
	addmsg {precell}/spikegen /output/{Vmfile} SAVE state

	//call spineloop to count number of valid spines
	int numsp = {spineLoop {startcomp} {parenttype} {maxpath} {noConnect} {maxdelay} {mindelay}}

	if ({numsp}<{numstim})
        echo "PROBLEM in SpineLoop:" {numsp} "spines < " {numstim} ": not enough spines fill criteria" 
	else
		//calculate connection prob, then call spineloop to connect spines
		float nstim=numstim
		float prob=nstim/numsp
		echo "spines" {numsp} "stim" {numstim} "connecting with probability" {prob}
		numsp = {spineLoop {startcomp} {parenttype} {maxpath} {prob} {maxdelay} {mindelay}}
	end

	//**********set the file name and headers.  Must be after spines connected

    spinehead={add_outputMultiSpines {spinefile} {prob}}
    str filenam={file}@"p"@{parenttype}@{startcomp}@{maxpath}

    setfilename {Vmfile} {filenam} 1 {Vmhead}
    setfilename {Cafile} {filenam} 1 {Cahead} 
    setfilename {Gkfile} {filenam} 1 {Gkhead}
    setfilename {spinefile} {filenam} 1 {spinehead}


	//run the simulation
    step {initSim} -time
    setfield {precell} Vm 10
    step 1
    showfield {precell}/spikegen state lastevent
    setfield {precell} Vm 0
	step {postSim} -time

    fileFLUSH {Vmfile} 
    fileFLUSH {Cafile} 
    fileFLUSH {Gkfile} 
    fileFLUSH {spinefile}

	//disconnect the spike generator, in preparation for another stimulation paradigm
	nummsg={getmsg {precell}/spikegen -out -count}
	int i
	for (i=0; i<nummsg; i=i+1)
		deletemsg {precell}/spikegen 0 -outgoing 
	end

end
