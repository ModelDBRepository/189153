//genesis


/***************************		MS Model, Version 12	*********************
**************************** 	      MScellshort.g 	*********************
	Avrama Blackwell 	kblackw1@gmu.edu
	Rebekah Evans 		rcolema2@gmu.edu
	Sriram 			dsriraman@gmail.com	
******************************************************************************/

if ({exists {getglobal ELEAK}}) // if a global in globals.g exists, globals.g has already been included so do not include; otherwise, include globals.g
    include MScell/globals  		// Defines & initializes cell specific parameters
    echo "include MScell/globals"
end
if ({exists {getglobal calciumdye}})
    include MScell/Ca_constants.g
    echo "include MScell/Ca_constants"
end
include MScell/proto  // provides access to make_prototypes (and individual channels) 
include MScell/addchans	// provides access to add_uniform_channel & add_CaShells 
include MScell/CaDifshell.g        
    	
//************************ Begin function set_position *********************
//**************************************************************************
function set_position (cellpath)
    //********************* Begin Local Variables ************************
    str compt, cellpath
    float dist2soma,x,y,z
    //********************* End Local Variables *****************************
 		

    if (!{exists {cellpath}})
        echo The current input {cellpath} does not exist (set_position) 
        return
    end
 
    foreach compt ({el {cellpath}/##[TYPE={compartment}]})
        x={getfield {compt} x}
        y={getfield {compt} y}
        z={getfield {compt} z}
        dist2soma={sqrt {({pow {x} 2 }) + ({pow {y} 2}) + ({pow {z} 2})} }  
        setfield {compt} position {dist2soma}
    end
end
//************************ End function set_position ***********************
//**************************************************************************

//************************ Begin function add_channels *********************
//**************************************************************************
function sigmoida(x,x0,k,gbar)
    float x, x0, k
 
    return {gbar/(1+{exp {-(x-x0)/k}})}
    
end

function add_sigmoid_channel(chan_name,gbar,x0,k,cellpath,type)
    str cellpath, chan_name,type
    float gbar,x0,k
    float  primdend = 14.e-6, otherdend = 18.e-6
    int i
    
    add_uniform_channel {chan_name} 0 {somaLen} 0 {cellpath} {type}

    add_uniform_channel {chan_name} {somaLen} {somaLen+primdend} 0 {cellpath} {type}

    float pom_len = {somaLen+primdend}

    for (i = 4; i <= 16;i = i+1)
        add_uniform_channel {chan_name} {pom_len} {pom_len+otherdend} {sigmoida {pom_len} {x0} {k} {gbar}} {cellpath} {type}

        pom_len = {pom_len} + {otherdend}
    end

end

function add_channels (cellpath, DA)
    str cellpath, DA

    /* add_uniform_channel (from addchans.g)
       channel_Name	a    		b 	density	  channeltype - VC for calcium permeable, KC for calcium dep*/

    // Naf in the soma 
    add_uniform_channel "NaF_channel"   0      {somaLen}	{getglobal gNaFsoma_{DA}} {cellpath} "V"
    // Naf in the dendrites
    add_uniform_channel "NaF_channel"   {somaLen} {mid} 	{getglobal gNaFprox_{DA}}  {cellpath} "V"
    add_uniform_channel "NaF_channel"   {mid}  {dist} 	{getglobal gNaFdist_{DA}}  {cellpath} "V"  

    // potassium channels
    add_uniform_channel "KAf_channel"   0      {somaLen}	{getglobal gKAfsoma_{DA}} {cellpath} "V"
    add_uniform_channel "KAf_channel"   {somaLen} {dist}	{getglobal gKAfdend_{DA}}   {cellpath} "V"  
		
    add_uniform_channel "KAs_channel"  0       {somaLen}	{getglobal gKAssoma_{DA}} {cellpath}  "V" 
    add_uniform_channel "KAs_channel"  {somaLen}  {dist} 	{getglobal gKAsdend_{DA}} {cellpath} "V"
    
		
    //note that these two channels don't have distance dependent  conductances
    add_uniform_channel "KIR_channel"   0        {somaLen}	 {getglobal gKIRsoma_{DA}}  {cellpath} "V"
    add_uniform_channel "KIR_channel"   {somaLen}  {dist}	 {getglobal gKIRdend_{DA}}  {cellpath} "V"

    add_uniform_channel "Krp_channel"    0        {somaLen}     {gKrpsoma}  {cellpath} "V"
    add_uniform_channel "Krp_channel"    {somaLen}  {dist}     {gKrpdend}  {cellpath} "V"

		
    echo "add VGCC"
    add_uniform_channel "CaR_channel" 		0 	{somaLen}  {gCaRsoma} {cellpath} "VC"
    add_uniform_channel "CaR_channel" 		{somaLen} 	{dist}  {gCaRdend} {cellpath} "VC"
 
    add_uniform_channel "CaN_channel" 		0 	{somaLen}  {gCaNsoma}  {cellpath} "VC"
		
    add_uniform_channel "CaL12_channel"     0 	{somaLen}  {getglobal gCaL12soma_{DA}}  {cellpath} "VC"
    add_uniform_channel "CaL12_channel"     {somaLen} 	{dist}  {getglobal gCaL12dend_{DA}}  {cellpath} "VC"
		
    add_uniform_channel "CaL13_channel" 	0 		{somaLen}  {getglobal gCaL13soma_{DA}} {cellpath} "VC"
    add_uniform_channel "CaL13_channel" 	{somaLen} 	{mid}  {getglobal gCaL13dend_{DA}} {cellpath} "VC"
    add_uniform_channel "CaL13_channel" 	{mid} 	{dist}  {getglobal gCaL13dend_{DA}} {cellpath} "VC"
		
    add_uniform_channel "CaT_channel" 	{prox} 	{dist}  {gCaTdist} {cellpath} "VC"

    echo "add KCa"
    add_uniform_channel "BK_channel" 		0 	{somaLen}	{gBKsoma} {cellpath} "KC"  
    add_uniform_channel "BK_channel" 		{somaLen}	{dist}	{gBKdend} {cellpath} "KC"  

    add_uniform_channel "SK_channel" 		0 	{somaLen} {gSKsoma} {cellpath} "KC"
    add_uniform_channel "SK_channel" 		{somaLen} 	{dist}  {gSKdend} {cellpath} "KC"
    if ({GABAtonic})
        add_sigmoid_channel "tonic_GABA" {gtonicGABAdend} {x0GABA} {kGABA} {cellpath} "V"
    end
end

 
//************************ End function add_channels ***********************
//**************************************************************************

//************************ Begin Primary Routine ******************************
//*****************************************************************************

//************************ Begin function make_MS_cell *********************
//**************************************************************************
function make_MS_cell (cellpath,pfile, DA)
    str cellpath,pfile,DA
    echo "Cellname=" {cellpath}
 	// function make_MS_cell is the first call from the primary file (MSsim.g). 
	// Note that the first thing it does is to call make_protypes in proto.g. 
	// These prototypes must be made before the call to add_channels. 

    make_prototypes					//	see proto.g
    //	readcell {pfile} {cellpath} -hsolve	//	see MScell.g
    readcell {pfile} {cellpath}
    echo "Pfile: " {pfile}
		set_position {cellpath}					// local call
		set_pathlen {cellpath} "/soma"
//allow either the full calcium dynamics or the old single time constant of decay
    if (calciumtype==0)
        add_caconcen_objects {CalciumName} {cellpath}
        //make_extra_pools 0 500e-6 {cellpath} 
    else 
        // to be coupled with T/L Ca2+ channels 
        add_CaConcen {bufferLT}  0 500e-6   {cellpath} 
        // to be coupled with N/R Ca2+ channels 
        add_CaConcen {bufferNR}  0 500e-6  {cellpath} 
        // to be coupled with all Ca2+ channels    
        add_CaConcen {bufferAll}  0 500e-6   {cellpath}
    end

    echo "finished adding calcium"
    add_channels {cellpath} {DA}					// local call
end	
//************************ End function make_MS_cell ***********************
//**************************************************************************			
