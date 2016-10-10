//genesis 
//1 PSP
//Pre-synaptic parameters
//Pre-synaptic parameters
str prestim = 2
float pulseFreq = 50
int pulses = 1

//Post-synaptic parameters
float inject=1e-9 //1e-9
float burstFreq = 10
int numbursts = 1
float trainFreq= 10
int numtrains=1

AP_durtime=0.005 
float APinterval={1.0/100.0}
int numAP=0

if ({Timing}=="Pre")
	float ISI = 0.010
elif ({Timing}=="Post")
	float ISI = -0.030
end

