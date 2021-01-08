Run startup_refrig.m" to get started. It will add the necessary units,
build the "refrigeration" library if necessary and open the model.

Double-click on "Plot Latest Results" to plot the results of the simulation
and to show an animation of the results on a pressure-enthalpy curve.

Double-click on "Plot Fluid Properties" to plot the properties of the
refrigerant.

This model contains a refrigeration model built using a custom Simscape
two-phase flow domain. The model contains five subsystems: a compressor, a
condenser, an expansion valve, an evaporator and a refrigerator
compartment. The R-134a refrigerant leaves the compressor as a hot gas. It
condenses in the condenser via heat transfer with the environment. The
pressure drops as the refrigerant passes through the expansion valve. The
drop in pressure causes the refrigerant to boil in the evaporator as it
absorbs heat from the refrigerator compartment. The cold gas then returns
to the compressor to repeat the cycle. The controller turns the compressor
on and off to maintain the refrigerator compartment temperature around the
desired temperature.

The fluid properties of the R-134a refrigerant spanning the liquid phase
to the vapor phase are described by look-up tables as a function of
pressure and specific internal energy. Homogeneous equilibrium is assumed
in the phase transition region. The values are obtained from the NIST
Chemistry WebBook "Thermophysical Properties of Fluid Systems":
http://webbook.nist.gov/chemistry/fluid/

Copyright 2013-2014 The MathWorks, Inc.