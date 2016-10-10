//genesis
//IF.g
//Create pulse generator for current injection
//function for running IF and IV curves

function createPulseGen(inject,basal_curr, delay, delay2, currentdur,compt,pgname,trigger,message)
    float inject, basal_curr, delay, delay2, currentdur
    int trigger
    str compt,pgname, message

    if (!{exists {pgname}})
        create pulsegen {pgname}
        if ({strcmp {message} "no message"} != 0)
            addmsg {pgname} {compt} {message} output
        end
    end
    setfield {pgname} level1 {inject} baselevel {basal_curr} \
                        width1 {currentdur} \
                        delay1 {delay} \
                        delay2 {delay2} trig_mode {trigger}
end


function IFcurve(inject1, increment, numcurrents, delay, duration, file)
    float inject1, increment
    int numcurrents
    float delay, duration
    str file

    echo {neuronname}/soma {file}

    createPulseGen 0 {basal_current} {delay} {99999.} {duration} {neuronname}/soma {injectName} 0 "INJECT"
    str inj_header = {add_outputPulseGen {somainjfile} {injectName}}
    
    
    float total_duration = delay*2+duration
    float inj
    int i

    str filenam = {file}@"_IF"
    

    setfilename {Vmfile} {filenam} 1 {Vmhead}
    setfilename {Cafile} {filenam} 1 {Cahead}
    setfilename {Gkfile} {filenam} 1 {Gkhead}
    
    setfilename {somainjfile} {filenam} 1 {inj_header}

    for (i=0; i<numcurrents; i=i+1)
        inj={inject1+i*increment}
        reset
        call /output/{Vmfile} OUT_WRITE "/newplot" 
        call /output/{Vmfile} OUT_WRITE "/plotname "{inj*1e9} 
        if ({exists /output/{Cafile}})
            call /output/{Cafile} OUT_WRITE "/newplot" 
            call /output/{Cafile} OUT_WRITE "/plotname "{inj*1e9} 
        end
        if ({exists /output/{Gkfile}})
            call /output/{Gkfile} OUT_WRITE "/newplot" 
            call /output/{Gkfile} OUT_WRITE "/plotname "{inj*1e9} 
        end
     
        echo {inj} = "I inject"
        setfield {injectName} level1 {inj}
        step {total_duration} -time
    end

    fileFLUSH {Vmfile} 
    fileFLUSH {Cafile} 
    fileFLUSH {Gkfile} 
    
    fileFLUSH {somainjfile}

    setfield {injectName} level1 0
//gen2spkShape {filename}{Vmfile} {delay} {duration} {total_duration} -stepsize {outputclock}
end
