//genesis 
//no_stim.g

//Pre-synaptic parameters
str prestim = 0
float pulseFreq = 50
int pulses = 0

//Post-synaptic parameters
float inject= 0
float burstFreq = 1
int numbursts = 1
float trainFreq = 10
int numtrains = 0
AP_durtime = 0.030 
float APinterval={1.0/10.0}
int numAP = 0



if ({Timing}=="Pre")
    float ISI = 0
elif ({Timing}=="Post")
    float ISI = 0
end
