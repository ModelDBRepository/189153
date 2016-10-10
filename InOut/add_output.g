//chemesis
//add_output.g
// Create files to save Vm for specified compartments, Gk from specified channels and compartment, and/or calcium objects
//Need to add some string parsing stuff and loops.

function setfilename(fname,prefix,appendval,fheader)
    str fname,prefix,fheader
    int appendval
    if ({exists /output/{fname}}) 
    	str filenam = {prefix}@"_"@{fname}@".txt"
    	setfield /output/{fname}  flush 1  leave_open {appendval} append {appendval} \
    	float_format %0.6g filename {filenam}
    	call /output/{fname} OUT_OPEN
    	call /output/{fname} OUT_WRITE {fheader}   
    else
        echo "Could not open file " {fname}
    end
    reset
end

function fileFLUSH(fname)
    str fname
    if ({exists /output/{fname}})
        call /output/{fname}  FLUSH
    end
end
    

function add_outputVm (compString,ascname,cell)
    str compString, ascname,cell
	create asc_file /output/{ascname}
	setfield /output/{ascname}   flush 1  leave_open 1 append 1 \
    float_format %0.6g
    useclock /output/{ascname} 1

    str compt
    int position=0
    str header="/Time "
    while ({position} > -1)
        position = {findchar {compString} ,}
        if ({position}==-1)
            compt={compString}
        else
            compt={substring {compString} 0 {position-1}}
            compString={substring {compString} {position+1}}
        end
        header=header@" "@compt
        addmsg {cell}/{compt} /output/{ascname}  SAVE Vm
    end
    return {header}
end	

function add_outputGk (compString,ChanString,ascname,cell)
    str compString,ChanString, ascname,cell
	create asc_file /output/{ascname}
	setfield /output/{ascname}   flush 1  leave_open 1 append 1 \
    float_format %0.6g
    useclock /output/{ascname} 1

    str compt, chan, chanStrTmp
    int chanpos,position=0
    str header="/Time "
    str NMDAcomp
    if ({GABAYesNo})
        str gabacompt = "/cell/soma/"
        header = {header}@" "@{gabacompt}@"_GABA_Gk"
        addmsg {gabacompt}GABA /output/{ascname} SAVE Gk
    end
    //string parsing for multiple comps
    while ({position} > -1)
        position = {findchar {compString} ,}
        if ({position}==-1)
            compt={compString}
        else
            compt={substring {compString} 0 {position-1}}
            compString={substring {compString} {position+1}}
        end
        if ({spinesYesNo})
            NMDAcomp={compt}@"/spine_1/"@{spcomp1}
        else
            NMDAcomp={compt}
        end
        if ({exists {cell}/{NMDAcomp}/{subunit}})
            header={header}@" "@{NMDAcomp}@"_"@{subunit}@"GHK "@{NMDAcomp}@"_"@{subunit}@"block"
            addmsg {cell}/{NMDAcomp}/{subunit}/GHK /output/{ascname} SAVE Gk
            addmsg {cell}/{NMDAcomp}/{subunit}/block /output/{ascname} SAVE Gk
        end
       
        //string parsing for multiple chans
        chanpos=0
        chanStrTmp=ChanString
        while ({chanpos} > -1)
            chanpos = {findchar {chanStrTmp} ,}
            if ({chanpos}==-1)
                chan={chanStrTmp}
            else
                chan={substring {chanStrTmp} 0 {chanpos-1}}
                chanStrTmp={substring {chanStrTmp} {chanpos+1}}
            end
            if ({exists {cell}/{compt}/{chan}GHK})
                addmsg {cell}/{compt}/{chan}GHK /output/{ascname} SAVE Gk
                header={header}@" "@{compt}@"_"@{chan}@"GHK"
            elif ({exists {cell}/{compt}/{chan}})
                addmsg {cell}/{compt}/{chan} /output/{ascname} SAVE Gk
                header={header}@" "@{compt}@"_"@{chan}
            else
                echo "add_output: channel" {chan} "doesn't exist in compartment" {compt}
            end
        end
    end
    return {header}

end	

function add_outputIk (compString,ChanString,ascname,cell)
    str compString,ChanString, ascname,cell
	create asc_file /output/{ascname}
	setfield /output/{ascname}   flush 1  leave_open 1 append 1 \
    float_format %0.6g
    useclock /output/{ascname} 1

    str compt, chan, chanStrTmp
    int chanpos,position=0
    str header="/Time "
    str NMDAcomp

    //string parsing for multiple comps
    while ({position} > -1)
        position = {findchar {compString} ,}
        if ({position}==-1)
            compt={compString}
        else
            compt={substring {compString} 0 {position-1}}
            compString={substring {compString} {position+1}}
        end
        if ({spinesYesNo})
            NMDAcomp={compt}@"/spine_1/"@{spcomp1}
        else
            NMDAcomp={compt}
        end
        if ({exists {cell}/{NMDAcomp}/{subunit}})
            header={header}@" "@{NMDAcomp}@"_"@{subunit}@"GHK "@{NMDAcomp}@"_"@{subunit}@"block"
            addmsg {cell}/{NMDAcomp}/{subunit}/GHK /output/{ascname} SAVE Ik
            addmsg {cell}/{NMDAcomp}/{subunit}/block /output/{ascname} SAVE Ik
        end
        //string parsing for multiple chans
        chanpos=0
        chanStrTmp=ChanString
        while ({chanpos} > -1)
            chanpos = {findchar {chanStrTmp} ,}
            if ({chanpos}==-1)
                chan={chanStrTmp}
            else
                chan={substring {chanStrTmp} 0 {chanpos-1}}
                chanStrTmp={substring {chanStrTmp} {chanpos+1}}
            end
            if ({exists {cell}/{compt}/{chan}GHK})
                addmsg {cell}/{compt}/{chan}GHK /output/{ascname} SAVE Ik
                header={header}@" "@{compt}@"_"@{chan}@"GHK"
            elif ({exists {cell}/{compt}/{chan}})
                addmsg {cell}/{compt}/{chan} /output/{ascname} SAVE Ik
                header={header}@" "@{compt}@"_"@{chan}
            else
                echo "add_output: channel" {chan} "doesn't exist in compartment" {compt}
            end
        end
    end

    return {header}

end	


function add_outputCal (compString,CaBufStr,ascname,cell)
    str compString, CaBufStr, ascname,cell
	create asc_file /output/{ascname}
	setfield /output/{ascname}   flush 1  leave_open 1 append 1 \
    float_format %0.6g
    useclock /output/{ascname} 1

    str compt, CaBuf,bufStrTmp
    int bufpos,position=0
    str header="/Time "
    // string parsing for multiple comps
    while ({position} > -1)
        position = {findchar {compString} ,}
        if ({position}==-1)
            compt={compString}
        else
            compt={substring {compString} 0 {position-1}}
            compString={substring {compString} {position+1}}
        end
        if ({calciumtype}==0)
            addmsg {cell}/{compt}/volavg /output/{ascname} SAVE meanValue   
            header=header@" "@{cell}@"/"@{compt}@"/CaAvg "
            if ({calciumdye}>1)
                if ({exists {cell}/{compt}/{bnamefluor}Vavg})
                    addmsg {cell}/{compt}/{bnamefluor}Vavg /output/{ascname} SAVE meanValue
                    header=header@{cell}@"/"@{compt}@"/"@{bnamefluor}@"_Vavg  "    
                else
                    echo "No " {cell}/{compt}/{bnamefluor}Vavg 
                end
            elif ({calciumdye}==1)
                if ({exists {cell}/{compt}/{bnamefluor}})
                    addmsg {cell}/{compt}/{bnamefluor} /output/{ascname} SAVE ratio
                    header=header@{cell}@"/"@{compt}@"/"@{bnamefluor}@"_ratio " 
                else
                    echo "No " {cell}/{compt}/{bnamefluor}
                end
            end
            addmsg {cell}/{compt}/Ca_difshell_1 /output/{ascname} SAVE C
            header=header@{cell}@"/"@compt@"/Ca1"
        end
      
    //string parsing for either multiple Ca_pools for single tau or various buffers
        bufpos=0
        bufStrTmp=CaBufStr
        while ({bufpos} > -1)
            bufpos = {findchar {bufStrTmp} ,}
            if ({bufpos}==-1)
                CaBuf={bufStrTmp}
            else
                CaBuf={substring {bufStrTmp} 0 {bufpos-1}}
                bufStrTmp={substring {bufStrTmp} {bufpos+1}}
            end
            
            if ({spinecalcium}==0)
                if ({CaBuf} != "X") //may not want to see various buffers
                    addmsg {cell}/{compt}/Ca_difshell_1{CaBuf} /output/{ascname} SAVE Bbound
                    header={header}@" "@{cell}@"/"@{compt}@"/Ca1_"@{CaBuf}
                else
                    header={header}@" "
                end
            elif ({spinecalcium}==1) //single time constant of decay
                if ({exists {cell}/{compt}/{CaBuf}})     //may not be nmda pool in dendrites
                   addmsg {cell}/{compt}/{CaBuf} /output/{ascname} SAVE Ca
                   header={header}@" "@{cell}@"/"@{compt}@"/"@{CaBuf}
                end
            else
                echo "unrecognized calcium type"
            end
        end
    end

    return {header}
end	

function write_spine_channel(spinehead,comp_path,ascname,channel)

    str spinehead,comp_path,ascname,channel

    if ({exists {comp_path}{spcomp1}/{channel}})
        addmsg {comp_path}{spcomp1}/{channel}GHK /output/{ascname} SAVE Gk
        spinehead={spinehead}@{comp_path}@{spcomp1}@"/"@{channel}@" "
    end
    
    return {spinehead}
end 

function write_ca_buffers(spinehead,where,label,ascname)
    str spinehead,where,label,ascname
    int bufpos
    str bufStrTmp, CaBuf
    bufpos = 0
    bufStrTmp = {CaBufs}
    while ({bufpos} > -1)
        bufpos = {findchar {bufStrTmp} ,}
        if ({bufpos} == -1)
           CaBuf = {bufStrTmp}
        else            
           CaBuf = {substring {bufStrTmp} 0 {bufpos-1}}
           bufStrTmp = {substring {bufStrTmp} {bufpos+1}}
        end
        if ({spinecalcium})
            if ({exists {where}{CaBuf}})
                addmsg {where}{CaBuf} /output/{ascname} SAVE Ca
                echo addmsg {where}{CaBuf} /output/{ascname} SAVE Ca
                spinehead = {spinehead}@" "@{label}@{CaBuf} 
            end
        else
            if ({exists {where}{CaBuf}})
                addmsg {where}{CaBuf} /output/{ascname} SAVE Bbound
                spinehead = {spinehead}@" "@{label}@{CaBuf}
            end
        end
    end
    return {spinehead@" "}
end
function write_spine_nmda(comp_path,spinehead,ascname)
    str comp_path, spinehead, ascname
    if ({spinesYesNo})
        str NMDAcomp = {comp_path}@"head"
        if ({exists {NMDAcomp}/{subunit}})
            spinehead={spinehead}@" "@{NMDAcomp}@"_"@{subunit}@"GHK "@{NMDAcomp}@"_"@{subunit}@"block "
            addmsg {NMDAcomp}/{subunit}/GHK /output/{ascname} SAVE Gk
            addmsg {NMDAcomp}/{subunit}/block /output/{ascname} SAVE Gk
            echo addmsg {NMDAcomp}/{subunit}/GHK /output/{ascname} SAVE Gk
            echo addmsg {NMDAcomp}/{subunit}/block /output/{ascname} SAVE Gk
        end
    end
    return spinehead
end

function header_to_file_one_spine(spinehead,head,ascname,prestim)
    str spinehead,element,head,ascname,prestim
    str CaBuf,bufStrTmp,spcomp,label,name,comp_path
    int  i,j,slabs, nummsg, bufpos

    comp_path = {strsub {head} /head/ /}
    echo head {head}
    if ({exists {head}})
        addmsg {head} /output/{ascname} SAVE Vm
        spinehead={spinehead}@{head}@"Vm "      
    else
        echo "No spine " {head}
        return
    end
  
    
    if ({exists {head}volavg})
        addmsg  {head}volavg /output/{ascname} SAVE meanValue
        spinehead={spinehead}@{head}@"CaAvg "
    else
        echo "No  volavg  on" {head}
    end
    if (calciumdye==1)
        if ({exists {head}{bnamefluor}})
            addmsg {head}{bnamefluor} /output/{ascname} SAVE ratio
            spinehead={spinehead}@{head}@"Fura2_ratio "
        else
            echo "No " {head}{bnamefluor}
        end
    elif ({calciumdye}>1)
        if ({exists {head}{bnamefluor}Vavg})
             addmsg {head}{bnamefluor}Vavg /output/{ascname} SAVE meanValue
             spinehead={spinehead}@{head}@{bnamefluor}@"_Vavg "
        else
            echo "No " {head}{bnamefluor}Vavg
        end
    end
    if ({plastYesNo})
        if ({prestim})
            addmsg {head}AMPA /output/{ascname} SAVE synapse[0].weight

            spinehead={spinehead}@{head}@"weight "
        end
    end
    
    if ({spinecalcium}==0)
        for (j=1; j<=2; j=j+1)
            spcomp={getglobal spcomp{j}} @ "/"
            if ({strcmp {spcomp} "head/"} == 0)
                slabs = {headSlabs}
                label = "head/"
                name = "head/"
                else
                slabs = {neckSlabs}
                label = "neck/"
                name = ""
            end
        
            for (i=1; i<=slabs; i=i+1)

                addmsg {comp_path}/{name}Ca_difshell_{i} /output/{ascname} SAVE C
  
                spinehead = {spinehead}@" "@{comp_path}@{label}@"Ca"@{i}
                //string parsing for various buffers
                if ({CaBufs}!="X")
                    str where,what
                    where = {comp_path}@{name}@"Ca_difshell_"@{i}
                    what = {comp_path}@"_"@{label}@"_Ca"@{i}@"_"
                    spinehead = {write_ca_buffers {spinehead} {where} {what} {ascname}}
                else
                    spinehead = {spinehead}@" "
                end

            end
        end
        //addmsg {cell}/{compt}/fluorescence /output/{ascname} SAVE ratio

    elif ({spinecalcium}==1)

           
         spinehead = {write_ca_buffers {spinehead} {head} {comp_path} {ascname}}
    end

    spinehead = {write_spine_channel {spinehead} {comp_path} {ascname} CaL13_channel}
    spinehead = {write_spine_channel {spinehead} {comp_path} {ascname} CaL12_channel}       
    spinehead = {write_spine_channel {spinehead} {comp_path} {ascname} CaR_channel}       
    spinehead = {write_spine_channel {spinehead} {comp_path} {ascname} CaT_channel}       
    spinehead = {write_spine_nmda {comp_path} {spinehead} {ascname}}

    return {spinehead}
end
function add_output_hook_up(ascname,cell,StimComp,res_spines,PreStim)

	str ascname,cell,StimComp, res_spines, PreStim, bufStrTmp, whichSpine,compt
    int bufpos=0, position=0
    

	create asc_file /output/{ascname}
	setfield /output/{ascname}  flush 1  leave_open 1 append 1  float_format %0.6g
	useclock /output/{ascname} 1

    str spinehead="/Time "
     
	int i,j,k,slabs, nummsg, bufpos
	str element,head

    if ({strlen {res_spines}}>0)
        while ({position} > -1) //loops through selected StimComps
            position = {findchar {StimComp} ,}
            if ({position}==-1)
                compt={StimComp}
            else
                compt={substring {StimComp} 0 {position-1}}
                StimComp={substring {StimComp} {position+1}}
            end
            bufStrTmp = {res_spines}
            bufpos = 0
            while ({bufpos} > -1)
                bufpos = {findchar {bufStrTmp} ,}
                if ({bufpos} == -1)
                    whichSpine = {bufStrTmp}
                else
                    whichSpine = {substring {bufStrTmp} 0 {bufpos-1}}
                    bufStrTmp = {substring {bufStrTmp} {bufpos+1}}
                end
        
                head = {cell}@"/"@{compt}@"/spine_"@{whichSpine}@"/head/"
                spinehead = {header_to_file_one_spine {spinehead} {head} {ascname} {PreStim}}
            end
        end
    end
	return {spinehead}
end
function add_outputMultiSpines (ascname,prestim)
	str ascname, CaBuf,bufStrTmp,spcomp,label,name

    int prestim,nummsg

	create asc_file /output/{ascname}
	setfield /output/{ascname}  flush 1  leave_open 1 append 1  float_format %0.6g
	useclock /output/{ascname} 1

    str spinehead="/Time "
	int i,j,k,slabs, nummsg, bufpos
	str element,head

    if ({prestim}>0)
		nummsg={getmsg {precell}/spikegen -out -count}
        
        str comp_path, previous = ""
		//This loop skips the 1st output/vm message - loop from i=0 if that message is eliminated
        if ({GABAYesNo})
            int begining = 2
        else
            int begining = 1
        end
		for (k=begining;k<nummsg-1;k=k+1)
			element ={getmsg {precell}/spikegen -out -destination {k}}
            echo {element}
			head = {getpath {element} -head}
            echo {head}
            if ({strcmp {head} {previous}} != 0)
                spinehead = {header_to_file_one_spine {spinehead} {head} {ascname}}
            end
            previous = {head}       
        end
    end
	return {spinehead}
end

function add_outputOneSpinePerComp(ascname,cell,StimComp)

    str ascname, cell, StimComp, compt, head
    int position

    create asc_file /output/{ascname}
	setfield /output/{ascname}  flush 1  leave_open 1 append 1  float_format %0.6g
	useclock /output/{ascname} 1

    str spinehead="/Time "

    while ({position} > -1) //loops through selected StimComps
        position = {findchar {StimComp} ,}
        if ({position}==-1)
            compt={StimComp}
        else
            compt={substring {StimComp} 0 {position-1}}
            StimComp={substring {StimComp} {position+1}}
        end
        head = {cell}@"/"@{compt}@"/spine_1/head/"
        if ({exists {head}})
            spinehead = {header_to_file_one_spine {spinehead}  {head} {ascname}}
        else
            echo "No spines on " {head}
        end     

    end
    return {spinehead}
end
function add_outputPulseGen(ascname,pulsegen)
    str ascname, pulsegen

    create asc_file /output/{ascname}
    setfield /output/{ascname}   flush 1  leave_open 1 append 1\
        float_format %0.6g
    useclock /output/{ascname} 1

    str header="/Time "
    addmsg {pulsegen} /output/{ascname} SAVE output
    
    header = {header}@"inject"
    return header
end
function add_outputSpikeHistory(precell,fname,prefix)
    str precell, fname
    str filenam = {prefix}@"_"@{fname}@".txt"
    echo {filenam}
    create spikehistory SynTimes.history
    setfield SynTimes.history ident_toggle 1 filename {filenam} initialize 1 leave_open 1 flush 1
    addmsg {precell}/spikegen SynTimes.history SPIKESAVE
    reset
end
