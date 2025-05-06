# NitraclineDepth
Code used to measure the nitracline depth in the CCE LTER

CalcNitracline is used to calculate the standard nitracline depth (defined as the depth at which nitrate first reaches 1 umol L-1).  

CalcNitracline_ex is used to calculate the nitracline depth extended (NCDx).  NCDx is defined as the depth at which nitrate first reaches 1 µmol L-1 if surface nitrate is less than one.  However, if surface nitrate is greater than one, NCDx is defined as zshallow - nitrateshallow/mNO3z, where zshallow is the shallowest sampling depth for nitrate (typically <5 m), nitrateshallow is the concentration of nitrate at the shallowest sampling depth and mNO3z is the slope of the ordinary least squares regression of nitrate concentration on depth from all CalCOFI samples collected in the upper 100 m of the water column from Aug, 1959 to May, 2021.  mNO3z was determined to be  0.1365 µM m-1.  CalcNitracline should be called as: CalcNitracline_ex(z,NO3,1,0.1365 ,'exact') where z is a vector of depths (in units of meters) for the nitrate profile and NO3 is the associated nitrate concentration data (umol L-1).  
