//genesis
//Ca_constants.g

/***************************		MS Model, Version 12 *********************

	Avrama Blackwell 	kblackw1@gmu.edu
	Wonryull Koh		wkoh1@gmu.edu
	Rebekah Evans 		rcolema2@gmu.edu
	Sriram 			dsriraman@gmail.com	

*****************************************************************************/
    str  CalciumName = "Ca_difshell_"
    str  bufferLT = "Ca_pool_LT"     // L and T type channels
    str  bufferNR = "Ca_pool_NR"     // coupled to the other channels (N and R)
    str  bufferAll = "Ca_pool_all"     // all calcium channels

	int calciumdye = 0 //  flags for cacium  dye. "0" means NO calcium dyes.
                     // 1= Fura-2 (default conc 100 uM, can change below), not defined in spines.g
                     // 3= Fluo4 - not defined in CaDifshell.g
                     // 2= Fluo-5F (300uM for Shindou, 100uM for Sabatini (check) and Lovinger)
                     // 4 = EGTA + Fluo-5f for Fluo-5f calibration is Shindou
	int calciumtype = 0     // we  have two types of calcium:
                     //  0 : detailed multi-shell model, using "difshell" object
                     //  1 : simple calcium pool adopted from Sabatini's 2001, 2004
	int calciuminact = 1 //calcium dependent inactivation of calcium channels, CaL1.2 and 1.3
		//0 = no CDI
		//1 = CDI for 1.3 and 1.2 N and R
	float cdiqfact = 1

float Ca_basal = 50e-6 //50nM

float outershell_thickness = 0.1e-6 //outermostshell thickness
float thicknessincrease=2.0 //perhaps only 1.5, set to 1 for no increase
float minthick=1.1*outershell_thickness	

float dca = 200.0e-12 //200 (um^2)(s^(-1))
//dca = 0.1*dca

//buffer variables [Kim et al 2010 (J Neurosci)]
str bname1 = "calbindin"
if (calciumdye == 0)
    float btotal1 = 80.0e-3    //4 * 20 uM total (no?)
else
    float btotal1 = 0 //If you don't dialize calbindin, soma Ca is too low (Kerr and Plenz 2008)
end
float kf1 =  0.028e6 //0.028 (nM^(-1))(s^(-1))  
float kb1 = 19.6 //19.6 (s^(-1))
float d1 = 66e-12 

str bname2 = "CaMC"
if (calciumdye == 0)
	float btotal2 = 15.0e-3 	//was 30.0e-3, but Rodrigo's paper seems to have about half the CaM as Myungs.
else
	float btotal2 = 0.0e-3		//CaM is 'dialyzed' when there is a calcium dye present
end
float kf2 =  0.006e6 //0.006 (nM^(-1))(s^(-1))  
float kb2 = 9.1 //9.1 (s^(-1))
float d2 = 66.0e-12// 11 ((um)^2)(s^(-1)) 

str bname4 = "CaMN" //Ca4? in Kim et al. 2011
if (calciumdye == 0)
	float btotal4 = 15.0e-3 	//was 30.0e-3, but Rodrigo's paper seems to have about half the CaM as Myungs.
else
	float btotal4 = 0.0e-3		//CaM is 'dialyzed' when there is a calcium dye present
end		
float kf4 =  0.1e6 //0.1 (nM^-1)(s^-1)
float kb4 = 1000 // (s^(-1))
float d4 = 66.0e-12 

str bname3 = "Fura-2"  //parameters fall within ranges given in  deshutter's book chapter in Methods in Neuronal Modeling 
float btotal3 = 100e-3 	//100uM?  Kerr uses 100? 
float kf3 =  100e3 //1000e3  // 1e5(mM^(-1))(s^(-1))  (deschutter range: 0.25-6e8 M-1sec-1) (25e3 to 6e5 mM-1sec-1) kb kf ratio 185nM (0.000185) 
float kb3 = 18.5 //185 //(s^(-1))  17-380 s^-1 range given in deShutter's chapter(methods in neuronal modeling)
float d3 = 6e-11 //((m)^2)(s^(-1)) (deschutter range: 0.4e-11 m^2sec-1 to 2e-10 m^2sec-1) 6e-11 based on Young's eqn and a viscossity of 4.1, eqn is in Rodrigo's EPAC paper

str bname5 = "Fluo5F" 
float btotal5 = 300.0e-3 //Shindou and Wickens use 300uM, Lovinger will use 100uM
float kf5 = 2.36e5 // (mM^-1)(s^-1) (2.36e8 M^-1 sec^-1, from Zenisek et al., 2003 kd=2.3uM) 
float kb5 = 542.8 //pe sec, for kb/kf=Kd=2.3uM (0.0023 mM) from Shindou 2011
float d5 = 6e-11 //mol weight similar to Fura2, using same dif constants.  

if (calciumdye==1)
    float btotalfluor={btotal3}
    float kffluor={kf3}
    float kbfluor={kb3}
    str bnamefluor={bname3}
    float dfluor={d3}
elif (calciumdye==2)
    float btotalfluor={btotal5}
    float kffluor={kf5}
    float kbfluor={kb5}
    str bnamefluor={bname5}
    float dfluor={d5}
elif (calciumdye==4) 
    float btotalfluor={btotal5}
    float kffluor={kf5}
    float kbfluor={kb5}
    str bnamefluor={bname5}
    float dfluor={d5}
    float egtatot = 10
    float kfegta = 50e3
    float kbegta = 2.73 //R. P. Schuhmeier, B. Dietze, D. Ursu, F. Lehmann-Horn, and W. Melzer 2003 Biophys J
    float degta = 15e-12 //Egta parameters Naragi & Neher, J Neurosci 1997, 17(18):6961
    str egtaname = "EGTA"
    CaBufs="CaMN,CaMC,calbindin,EGTA"
end

//kcat & km for MMPump
float km = 0.3e-3
str MMpumpName= "MMpump"
float kcatsoma = 85e-8  //75 pmol ((cm)^(-2)) (s^(-1)) //Markram et al 1998
float kcatdend = 8e-8 //12e-8	

//kcat & km for NCX
//not yet used in dendrites
float kmNCX=1e-3
float kcatNCX=0
str NCXname="NCX"
