//genesis 
//HookUp.g
//Can give pattern of current injection and/or pattern of pre-syn stim, allowing STDP, HFS, Theta, etc
//pulse>=1 and numtrains>=1 else there will be NO pre-syn stim (good for evaluating AP alone)
//AND preStimPct>0, else there will be NO pre-syn stim
//inject=0 will give pre-syn stim alone, without triggered AP (e.g. hfs or theta)
//set TooFast = 100 will revert to stimulating just one spine, even for 50 Hz stimulation
//If no synaptic stimulation StimComp is where one specifies which spine output to save
/*Commented out lines allow giving a pulse before and after, to test the plasticity
and also repeating the pairings.  BUT, these will mess up the alignment of the 
pre-synaptic stim and the post-synaptic depol.  So, fix the pulse generators when you uncomment them */
function set_timetable(inputname,maxTime,filename)
        str inputname, filename
        float maxTime
        echo {inputname}
        setfield {inputname} maxtime maxTime,
            method 4 \
            act_val 1.0 \       
            fname filename
        
        call {inputname} TABFILL
        create spikegen {inputname}/spikes
        setfield {inputname}/spikes output_amp 1 thresh 0.5 abs_refract 0.0001
        addmsg {inputname}  {inputname}/spikes INPUT activation


        pope    
end

function connect_synapse(input,spikegen,stimname,name)
    str input,spikegen,stimname,name
    if ({exists {stimname}/{name}})
        addmsg {input}/{spikegen}  {stimname}/{name} SPIKE 
    else    
        echo could not find {stimname}/{name}
    end
end
//pass the name of the paradigm, because it is used in naming spine stimulation files

function HookUp(PreStim, paradigm, timing, StimComp, file,numAP,inj,dur,interval, isi, pulseFreq, pulses, burstFreq, numbursts, trainFreq, numtrains, jitter)
    int PreStim
    str StimComp,file, compt, paradigm, timing
//These are parameters related to both pre-and post-synaptic AP (EPSP) pattern
    int numbursts, numtrains
    float trainFreq, burstFreq
    float isi //interval between onset of EPSP and onset of AP
//These are parameters related to pre-synaptic stimulation - pulses in a burst
    int pulses
	float pulseFreq
//These parameters describe post-synaptic stimulation - AP in a burst
	int numAP 
    float inj, dur, interval, interpulse=0, bufpos
    str spikegen = "spikes", bufStrTmp, whereStim
// Determine the interpulse intervals for pre-synaptic stimulation
    if ({pulses}>1)
        interpulse=1./{pulseFreq}
    end
// Determine the interburst and intertrain intervals for pre- and post- stimulation
    float intertrain=0, interburst=0
    interburst = 1.0/{burstFreq}
    intertrain = 1.0/{trainFreq}
    int pulse, train, burst

    //delay refers to onset of current injection relative to first pulse, which occurs at initSim
    //float TooFast = 30     //if pre-syn pulses in burst are too fast, distribute them among multiple spines
    if ({pulseYN})
    	float AP_delay= {2*initSim + isi}//+ (pulses-1)*interpulse}
    else
        float AP_delay = {initSim + isi}// + (pulses-1)*interpulse}
    end

    if ({isi} > 0) 
        AP_delay = {AP_delay}
    else
        AP_delay = {AP_delay} - ({numAP}-1)*{interval}
    end

    echo {AP_delay}
		//parameters for post-synaptic spike generators

    if ({interval} == 0 )
        echo "Wrong paradigm chosen. You can choose: P_and_K (Pawlak and Kerr), K_and_P (Kerr and Plenz), Shindou, Shen and IF (IF curves)"
        return
    end

    if ({interval}<{dur})
        echo "please define lower AP frequency"
    end

    //**********set the filenames, and 
    //set up presynaptic element for stimulating
    
    str filenam={file}
    if ({GABAYesNo})
        filenam={file}@"_gaba_delay_"@{GABAdelay}@"_"
        bufStrTmp = {StimComp}
        bufpos = 0 
        str gaba_file = {paradigm}@"_"@{timing}@"_gaba" 
        int i = 0
        while ({bufpos} > -1)
            bufpos = {findchar {bufStrTmp} ,}
            if ({bufpos} == -1)
                whereStim = {bufStrTmp}
            else
                whereStim = {substring {bufStrTmp} 0 {bufpos-1}}
                bufStrTmp = {substring {bufStrTmp} {bufpos+1}}
            end
        
            pushe / 
            create timetable GABA[{i}]
            //set_timetable {input_name}/GABA[{i}] {numtrains}/{trainFreq} {gaba_file}
            float maxt = {numtrains/trainFreq+initSim}
            filenam = {filenam}@"_"@whereStim@"_"@"GABAtau2"@{GABAtau2}@"_"
            setfield GABA[{i}] maxtime {maxt} \
                        method 4 \
                        act_val 1.0 \ 
                        fname {gaba_file}
            echo      GABA[{i}] {gaba_file}
            call GABA[{i}] TABFILL
            create spikegen GABA[{i}]/{spikegen}
            setfield GABA[{i}]/{spikegen} output_amp 1 thresh 0.5 abs_refract 0.0001
            addmsg GABA[{i}] GABA[{i}]/{spikegen} INPUT activation
            echo GABA[{i}]
            
            pope
            str stimname = {neuronname}@"/"@{whereStim}
            connect_synapse GABA[{i}] {spikegen} {stimname} {GABAname} 
            i = i + 1
        end
    else
        filenam={file}@"_no_gaba_"
    end

    if ({jitter} == 1)
        filenam = {filenam}@"jitter_"
    end

    if ({abs {isi}}<{SMALLNUMBER})
        isi=0
    end
    //Used for stimulation during simulation
    filenam={filenam}@"Stim_"@{StimComp}@"_AP_"@{numAP}@"_ISI_"@{isi}
        
    if ({spinesYesNo})       
        if ({PreStim}>0)
            echo "before pulseFreq entry pulseFreq" {pulseFreq} {TooFast} {pulses}
            str fname_base = paradigm@"_"@timing@"_stimulation_spine_"
            bufpos =0
            bufStrTmp  = whichSpines 
            str whichSpine
            str stimname
            str res_spines = ""
            
            if ({pulseFreq}>{TooFast} && {pulses}>1)
                int i = 0
                res_spines = whichSpines
                while ({bufpos} > -1)
                    bufpos = {findchar {bufStrTmp} ,}
                    if ({bufpos} == -1)
                        whichSpine = {bufStrTmp}
                    else
                        whichSpine = {substring {bufStrTmp} 0 {bufpos-1}}
                        bufStrTmp = {substring {bufStrTmp} {bufpos+1}}
                    end
                    
                    pushe /
                    create timetable {input_name}[{i}]
                    //set_timetable {fname_base}[{i}] {numtrains}/{trainFreq} {filename}
                    

                    float maxt = {numtrains/trainFreq+initSim}
                    echo "max time"  {maxt}
                setfield {input_name}[{i}] maxtime {maxt} \
                        method 4 \
                        act_val 1.0 \ 
                        fname {fname_base}{whichSpine}
                    echo      {input_name}[{i}] {fname_base}{whichSpine}
                    call {input_name}[{i}] TABFILL
                    create spikegen {input_name}[{i}]/{spikegen}
                    setfield {input_name}[{i}]/{spikegen} output_amp 1 thresh 0.5 abs_refract 0.0001
                    addmsg {input_name}[{i}] {input_name}[{i}]/{spikegen} INPUT activation
                    echo {input_name}[{i}]
                    str fnam = {filenam}@"_spikes_"@{whichSpine}
                    echo {fnam}
                    create spikehistory SynTimes[{i}].history
                    setfield SynTimes[{i}].history ident_toggle 1 filename {fnam} initialize 1 leave_open 1 flush 1
                    addmsg {input_name}/spikes SynTimes[{i}].history SPIKESAVE
                    reset
                    pope
                    
                    stimname = {neuronname}@"/"@{StimComp}@"/spine_"@{whichSpine}@"/"@{spcomp1}
                    
                    connect_synapse {input_name}[{i}] {spikegen} {stimname} {NMDAname}
                    connect_synapse {input_name}[{i}] {spikegen} {stimname} {AMPAname}

                    
                    i = {i+1}
                end
            else
                //If only one spine gets stimulated, it is the first on the list
                // or if 0<PreStim <1, python script will select which spine or set up
                // PreStim = 0 (Don't know how yet, but I will)
                bufpos = {findchar {bufStrTmp} ,}
                if ({bufpos} == -1)
                    whichSpine = {bufStrTmp}
                else
                    whichSpine = {substring {bufStrTmp} 0 {bufpos-1}}
                    bufStrTmp = {substring {bufStrTmp} {bufpos+1}}
                end
                
                res_spines = whichSpine
                stimname={neuronname}@"/"@{StimComp}@"/spine_"@{whichSpine}@"/"@{spcomp1}
                echo "1 pulse" {stimname}
                
                pushe /
                create timetable {input_name}
                float maxt = {numtrains/trainFreq+ initSim}
                echo "max time" {maxt}
                setfield {input_name} maxtime {maxt} \
                        method 4 \
                        act_val 1.0 \ 
                        fname {fname_base}{whichSpine}
                            
                call {input_name} TABFILL
                create spikegen {input_name}/{spikegen}
                setfield {input_name}/{spikegen} output_amp 1 thresh 0.5 abs_refract 0.0001
                addmsg {input_name} {input_name}/{spikegen} INPUT activation
                str fnam = {filenam}@"_spikes_"@{whichSpine}
                echo {fnam}
                create spikehistory SynTimes.history
                setfield SynTimes.history ident_toggle 1 filename {fnam} initialize 1 leave_open 1 flush 1
                addmsg {input_name}/spikes SynTimes.history SPIKESAVE
                reset
                pope
                //set_timetable {input_name} {numtrains}/{trainFreq} {filename}

                connect_synapse {input_name} {spikegen} {stimname} {NMDAname}
                connect_synapse {input_name} {spikegen} {stimname} {AMPAname}
                
            end 
        else
            str res_spines = "1"
        end
    end
    /*    //Does not really work, should be rewritten
        str stimname={StimComp}
        create timetable {input_name}
        set_timetable {input_name} {numtrains}/{trainFreq} {filename}
        connect_synapse {input_name} {NMDAname} {neuronname} {stimname}
        connect_synapse {input_name} {AMPAname} {neuronname} {stimname}

    end
*/       

    echo "################ simulating STDP, " {numAP} "AP, ISI: " {isi} 

    //set-up file names, post-synaptic spike generators
    if ({spinesYesNo}) 
        spinehead={add_output_hook_up {spinefile} {neuronname} {StimComp} {res_spines} {PreStim}}
    end

    

    setfilename {Vmfile} {filenam} 1 {Vmhead}
    setfilename {Cafile} {filenam} 1 {Cahead}
    setfilename {Gkfile} {filenam} 1 {Gkhead}
    setfilename {spinefile} {filenam} 1 {spinehead}

    int go = 1

    float width_burst = {numAP}*{interval}
    float width_train = {numbursts}/{burstFreq}

    float very_big_number = {1e9}
    float exp_duration = {numtrains}/{trainFreq}
    if ({dur} > {interval})
        go = 0
        echo "The AP is wider than the inter AP interval"
    else
        if ({width_burst} > {interburst})
            if (({numbursts} == 1) && ({numtrains} == 1))
                interburst = 2*{width_burst}
                width_train = {interburst}
                if ({width_train} > {intertrain})
                    echo "Train frequency smaller than duration of all bursts"
                    intertrain = 2*{width_train}
                    exp_duration = 2*{width_train}
                end
            else
                go = 0
            end
        else
            if ({width_train} > {intertrain})
                if ({numtrains} == 1)
                    intertrain = 2*{width_train}
                    exp_duration = 1.2*{width_train}
                    echo "Train frequency smaller than duration of all bursts"
                else
                    go = 0
                    echo "The train is wider than the intertrain interval"
                end
            end
        end
    end
    if ({go} == 1)
        //onset of the injections jitter (shift lower than 1 ms):
        if ({jitter} == 1)
            AP_delay = {AP_delay} + {rand 0 0.0005}
            //amplitude jitter
            inj = {inj} + {rand 0 {inj}/20.}
            //width jitter
            dur = {dur} + {rand 0 0.0005}
        end

        echo AP_delay {AP_delay} inj {inj} AP_duration {dur}
        createPulseGen {inj} {basal_current} 0 {interval} {dur} {neuronname}/soma {injectName} 2 "INJECT"
        createPulseGen {inj} {basal_current} 0 {interburst} {width_burst} {injectName}  {injectName}/burst_gate 2 "INPUT"
        createPulseGen {inj} {basal_current} 0 {intertrain} {width_train}  {injectName}/burst_gate  {injectName}/train_gate 2 "INPUT"
        createPulseGen {inj} {basal_current} {AP_delay} {very_big_number} {exp_duration}  {injectName}/train_gate  {injectName}/experiment_gate 0 "INPUT"
        str inj_header
        inj_header = {add_outputPulseGen {somainjfile} {injectName}}
        setfilename {somainjfile} {filenam} 1 {inj_header}
    end

   
    reset
    
    
 
end
