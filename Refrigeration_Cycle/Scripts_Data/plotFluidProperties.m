function plotFluidProperties()
%plotFluidProperties()   plots the fluid properties used in the Simscape
%   model 'ssc_refrigeration' as a function of specific internal energy and
%   pressure.

%   Copyright 2013-2014 The MathWorks, Inc.

load R134aProperties p_TLU u_TLU v_TLU T_TLU mu_TLU k_TLU Pr_TLU

fluidProps = {
    'Specific Volume (m^3/kg)',       v_TLU;
    'Temperature (K)',                T_TLU;
    'Dynamic Viscosity (uPa*s)',      mu_TLU;
    'Thermal Conductivity (W/(m*K))', k_TLU;
    'Prandtl Number',                 Pr_TLU};

figure('Name', 'Fluid Properties', 'Toolbar', 'figure', ...
    'Position', [12   202   628   471])

hPopup = uicontrol('Style', 'popupmenu', 'String', fluidProps(:,1), ...
    'Units', 'normalized', 'Position', [0.331 0.932, 0.431, 0.05], ...
    'Value', 1, 'Callback', @(hObject, eventData) plotProperties, ...
    'FontWeight', 'bold');

plotProperties

    function plotProperties
        idx = get(hPopup, 'Value');
        surf(u_TLU, p_TLU, fluidProps{idx, 2});
        set(gca, 'yscale', 'log')
        xlabel('Specific Internal Energy (kJ/kg)')
        ylabel('Pressure (MPa)')
        zlabel(fluidProps{idx, 1});
    end

end
