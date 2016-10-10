// genesis
//How to use/call this function:
//make_vclamp "somaVmCompartmentName" {clampdur} {clampval} {clampdelay} {clamphold}

function make_vclamp(path,dur,clampval,delay,hold)
str	path
float	dur, hold, delay
float	clampval

  create pulsegen {path}/pulsegen_hold
  setfield    ^    level1 {hold} \
      width1    {delay+(dur+delay)*10} \
      delay1    {delay}       \
      delay2    {9999} \
      baselevel {EREST_ACT}


	create pulsegen {path}/pulsegen_clamp
	setfield    ^ 	level1		{clampval-hold} \
		  trig_mode 0 \
    	width1		{dur} \
			delay1		{2*delay} \
			delay2		{delay+dur} \
      width2    {dur} \
      level2    {clampval-hold} \
			baselevel	{hold-hold}
   
 //float test1 = {getfield {path}/pulsegen baselevel}
//echo "baselevel: "{test1}
//echo "clampval should be: " {clampval}


	create 	diffamp {path}/Vclamp
	setfield    	^	saturation	999.0 \
			gain		1 
     

	create 	RC 	{path}/lowpass
	setfield    	^ 	R		1 \  
			C		.00001 

	create 	PID 	{path}/PID
//These parameters may need to be tweaked for morphology or time step
	/* parameters for 0.001 time step */
/*	setfield ^	gain		0.003 \ 
			tau_i	        3e-7 \  
			tau_d		0.01 \      	
			saturation	400.00	
*/	/* parameters for 0.005 time step */
/*	setfield ^	gain 		0.35 \
			tau_i		4e-5 \
			tau_d		0.2 \
			saturation	400.00
*/
    setfield ^ gain   2e-5 \
         saturation  400.00  \      
         tau_i .000001 \
         tau_d .00000025 
         
       
 
	addmsg {path}/pulsegen_hold {path}/lowpass INJECT  output
  addmsg {path}/pulsegen_clamp  {path}/lowpass	INJECT  output
	//addmsg {path}/lowpass  	{path}/Vclamp 	PLUS	state
 // addmsg {path}/Vclamp    {path}/PID	CMD	output
	addmsg {path}/lowpass {path}/PID CMD state
  addmsg {path}	    	{path}/PID	SNS	Vm
	addmsg {path}/PID 	{path}		INJECT  output
end
function make_vcgraph(path)
str path

  create xform /vclamp [10,10,600,400]

  create xgraph /vclamp/pulsegen -title "Pulse generator" -hgeom 50% -wgeom 50%
 setfield ^ ymin -80e-3 ymax 20e-3 xmax .5 XUnits sec YUnits volts
  create xgraph /vclamp/inject -title "injected current" -hgeom 50% -wgeom 50%
 setfield ^ ymin -50e-3 ymax 100e-3 xmax .5 XUnits sec YUnits Amps
  create xgraph /vclamp/vclamp -title "command voltage" -xgeom 300 -ygeom 0 -hgeom 50% -wgeom 50%
  setfield ^ ymin -80e-3 ymax 20e-3 xmax .5 XUnits sec YUnits volts
  create xgraph /vclamp/vm -title "membrane potential" -xgeom 300 -hgeom 50% -wgeom 50%
  setfield ^ XUnits Sec YUnits V xmax .5 ymin -80e-3 ymax 20e-3
  xshow /vclamp

  // send messages from vlcamp devices to their graphs
  addmsg {path}/pulsegen_hold /vclamp/pulsegen PLOT output *pulsegen *red
  addmsg {path}/pulsegen_clamp /vclamp/pulsegen PLOT output *pulsegen *green
  addmsg {path}/PID /vclamp/inject PLOT output *PID *blue
  addmsg {path}/lowpass /vclamp/vclamp	PLOT state *Vclamp *black
  addmsg {path} /vclamp/vm PLOT Vm *voltage *black
  useclock 0 {path}/#
  useclock 0 /vclamp/#
end




