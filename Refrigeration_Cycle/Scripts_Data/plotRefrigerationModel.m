function plotRefrigerationModel(simlog)
%plotRefrigerationModel   plots the simulation results of the Simscape
%   model 'ssc_refrigeration'.
%
%   plotRefrigerationModel(SIMLOG) plots the refrigeration cycle
%   performance, vapour quality, and the pressure-enthalpy diagram from the
%   logged simulation data SIMLOG.

%   Copyright 2013-2014 The MathWorks, Inc.

% Extract data from simlog.
t      = simlog.Compressor.Mass_Flow_Sensor.Mass_And_Energy_Flow_Sensor.M.series.time; % s
mdot12 = simlog.Compressor.Mass_Flow_Sensor.Mass_And_Energy_Flow_Sensor.M.series.values; % kg/s
mdot34 = simlog.Expansion_Valve.Mass_Flow_Sensor.Mass_And_Energy_Flow_Sensor.M.series.values; % kg/s
W      = simlog.Compressor.Controlled_Mass_Flow_Rate_Source.W.series.values; % kW
Q      = simlog.Refrigerator_Compartment.Heat_Flow_Sensor.Ideal_Heat_Flow_Sensor.H.series.values; % W
Tc     = simlog.Refrigerator_Compartment.Temperature_Sensor.Ideal_Temperature_Sensor.T.series.values; % K
p1     = simlog.Compressor.Cycle_Sensor_1.Pressure_And_Energy_Sensor.P.series.values; % MPa
u1     = simlog.Compressor.Cycle_Sensor_1.Pressure_And_Energy_Sensor.U.series.values; % kJ/kg
v1     = simlog.Compressor.Cycle_Sensor_1.Thermodynamic_Properties_Sensor.V.series.values; % m^3/kg
x1     = simlog.Compressor.Cycle_Sensor_1.Thermodynamic_Properties_Sensor.X.series.values; % --
p2     = simlog.Compressor.Cycle_Sensor_2.Pressure_And_Energy_Sensor.P.series.values; % MPa
u2     = simlog.Compressor.Cycle_Sensor_2.Pressure_And_Energy_Sensor.U.series.values; % kJ/kg
v2     = simlog.Compressor.Cycle_Sensor_2.Thermodynamic_Properties_Sensor.V.series.values; % m^3/kg
x2     = simlog.Compressor.Cycle_Sensor_2.Thermodynamic_Properties_Sensor.X.series.values; % --
p3     = simlog.Expansion_Valve.Cycle_Sensor_3.Pressure_And_Energy_Sensor.P.series.values; % MPa
u3     = simlog.Expansion_Valve.Cycle_Sensor_3.Pressure_And_Energy_Sensor.U.series.values; % kJ/kg
v3     = simlog.Expansion_Valve.Cycle_Sensor_3.Thermodynamic_Properties_Sensor.V.series.values; % m^3/kg
x3     = simlog.Expansion_Valve.Cycle_Sensor_3.Thermodynamic_Properties_Sensor.X.series.values; % --
p4     = simlog.Expansion_Valve.Cycle_Sensor_4.Pressure_And_Energy_Sensor.P.series.values; % MPa
u4     = simlog.Expansion_Valve.Cycle_Sensor_4.Pressure_And_Energy_Sensor.U.series.values; % kJ/kg
v4     = simlog.Expansion_Valve.Cycle_Sensor_4.Thermodynamic_Properties_Sensor.V.series.values; % m^3/kg
x4     = simlog.Expansion_Valve.Cycle_Sensor_4.Thermodynamic_Properties_Sensor.X.series.values; % --
T4     = simlog.Expansion_Valve.Cycle_Sensor_4.Thermodynamic_Properties_Sensor.T.series.values; % K

% Unit conversions.
W = W*1e3;
mdot12 = mdot12*1e3;
mdot34 = mdot34*1e3;

% Calculate specific enthalpy.
h1 = u1 + p1.*v1*1e3;
h2 = u2 + p2.*v2*1e3;
h3 = u3 + p3.*v3*1e3;
h4 = u4 + p4.*v4*1e3;


% Create plots of the refrigeration cycle performance.
figure('Position', [100 100 1000 500], 'Name', 'Cycle Performance')

handles(1) = subplot(2, 3, 1);
plot(t, p1, 'Color', [0.7, 0.9, 1], 'LineWidth', 2); hold on;
plot(t, p2, 'Color', [1, 0.7, 0.7], 'LineWidth', 2); hold off;
ylabel('Pressure (MPa)')
title('Compressor Pressures', 'FontWeight', 'bold')
legend('p_{in}', 'p_{out}', 'Location', 'northeast')

handles(2) = subplot(2, 3, 2);
plot(t, -Q, 'Color', [0.7, 0.9, 1], 'LineWidth', 2)
ylabel('Heat Flow Rate (W)')
title('Compartment Heat Extracted', 'FontWeight', 'bold')

handles(3) = subplot(2, 3, 3);
plot(t, mdot12, 'Color', [1, 0.7, 0.7], 'LineWidth', 2); hold on;
plot(t, mdot34, 'Color', [0.4 ,0.4 ,1], 'LineWidth', 2); hold off;
ylabel('Mass Flow Rate (g/s)')
title('Mass Flow Rate', 'FontWeight', 'bold')
legend('Compressor', 'Valve', 'Location', 'northeast')

handles(4) = subplot(2, 3, 4);
plot(t, p2./p1, 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2)
xlabel('Time (s)')
ylabel('Pressure ratio')
title('Compressor Pressure Ratio', 'FontWeight', 'bold')

handles(5) = subplot(2, 3, 5);
plot(t, W, 'Color', [1, 0.7, 0.7], 'LineWidth', 2)
xlabel('Time (s)')
ylabel('Power (W)')
title('Compressor Power', 'FontWeight', 'bold')

handles(6) = subplot(2, 3, 6);
plot(t, T4, 'Color', [0.4, 0.4, 1], 'LineWidth',2); hold on;
plot(t, Tc, 'Color', [0.7, 0.9, 1], 'LineWidth',2); hold off;
xlabel('Time (s)')
ylabel('Temperature (K)')
title('Evaporator Temperature', 'FontWeight', 'bold')
legend('Inlet', 'Compartment', 'Location', 'northeast')

linkaxes(handles, 'x')


% Create plots of the vapour quality at refrigeration cycles points.
figure('Position', [600 100 650 500], 'Name', 'Refrigeration Cycle Vapor Qualities')

h_x(1) = subplot(2, 2, 1);
plot(t, x3, 'Color', [1, 0.4, 0.4], 'LineWidth', 2)
ylabel('Vapor Quality')
title('Point 3: Condenser Output', 'FontWeight', 'bold')

h_x(2) = subplot(2, 2, 2);
plot(t, x2, 'Color', [1, 0.7, 0.7], 'LineWidth', 2)
ylabel('Vapor Quality')
title('Point 2: Compressor Output', 'FontWeight', 'bold')

h_x(3) = subplot(2, 2, 3);
plot(t, x4, 'Color', [0.4, 0.4, 1], 'LineWidth', 2)
xlabel('Time (s)')
ylabel('Vapor Quality')
title('Point 4: Valve Output', 'FontWeight', 'bold')

h_x(4) = subplot(2, 2, 4);
plot(t, x1, 'Color', [0.7, 0.9 ,1], 'LineWidth', 2)
xlabel('Time (s)')
ylabel('Vapor Quality')
title('Point 1: Evaporator Output', 'FontWeight', 'bold')

% Set common y-axis limits.
set(h_x, 'YLim', [0 1])
linkaxes(h_x)


% Load fluid property tables and saturation data.
load R134aPHDiagram p_TLU h_TLU T_TLU h_sat p_sat

% Interpolate cycle points to obtain equal time steps.
t_mov = linspace(t(1), t(end), 300);
p_cycle = interp1(t, [p1 p2 p3 p4 p1], t_mov);
h_cycle = interp1(t, [h1 h2 h3 h4 h1], t_mov);

% Create pressure-enthalpy diagram with temperature contours.
figure('Name', 'Pressure-Enthalpy Diagram', 'Toolbar', 'figure', ...
    'Position', [600 300 650 500])
[contourC, contourh] = contour(h_TLU, p_TLU, T_TLU, 200:20:400, 'Color', [0.5, 0.5, 0.5], 'LineStyle', ':');
clabel(contourC, contourh, 'Rotation', 0, 'LabelSpacing', 432)
hold on
plot(h_sat, p_sat, '-', 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2);
handle_cycle = plot(h_cycle(1,:), p_cycle(1,:), '-', 'color', [0 0.5 0]);
handle1 = plot(h_cycle(1,1), p_cycle(1,1), 'o', 'MarkerFaceColor', [0.7, 0.9, 1], 'MarkerEdgeColor', [0.7, 0.9, 1]);
handle2 = plot(h_cycle(1,2), p_cycle(1,2), '^', 'MarkerFaceColor', [1, 0.7, 0.7], 'MarkerEdgeColor', [1, 0.7, 0.7]);
handle3 = plot(h_cycle(1,3), p_cycle(1,3), 's', 'MarkerFaceColor', [1, 0.4 ,0.4], 'MarkerEdgeColor', [1, 0.4 ,0.4]);
handle4 = plot(h_cycle(1,4), p_cycle(1,4), 'd', 'MarkerFaceColor', [0.4, 0.4, 1], 'MarkerEdgeColor', [0.4 ,0.4, 1]);
legend([handle1 handle2 handle3 handle4], 'Point 1', 'Point 2', 'Point 3', 'Point 4', 'Location', 'southeast')
set(gca, 'YScale', 'log')
xlabel('Specific Enthalpy (kJ/kg)')
ylabel('Pressure (MPa)')
titleHandle = title('Pressure-Enthalpy Diagram', 'FontWeight', 'bold');

% Create Play/Pause button for animation.
status = 'paused';
idxPaused = 1;
hButton = uicontrol('Style', 'pushbutton', 'String', 'Pause', ...
    'Units', 'normalized', 'Position', [0.13 0.94, 0.1, 0.05], ...
    'Callback', @(hObject, eventData) playMovie);
playMovie


    function playMovie
        try
            if strcmp(status, 'playing')
                status = 'paused';
                set(hButton, 'String', 'Play')
                return
            end
            
            status = 'playing';
            set(hButton, 'String', 'Pause')
            
            % Plot pressure and specific enthalpy at cycle points.
            for i = idxPaused : length(t_mov)
                if strcmp(status, 'paused')
                    % Save state of the animation.
                    idxPaused = i;
                    return
                end
                set(handle_cycle, 'XData', h_cycle(i,:), 'YData', p_cycle(i,:))
                set(handle1, 'XData', h_cycle(i,1), 'YData', p_cycle(i,1))
                set(handle2, 'XData', h_cycle(i,2), 'YData', p_cycle(i,2))
                set(handle3, 'XData', h_cycle(i,3), 'YData', p_cycle(i,3))
                set(handle4, 'XData', h_cycle(i,4), 'YData', p_cycle(i,4))
                set(titleHandle, 'String', sprintf('Pressure-Enthalpy Diagram (t = %.f s)', t_mov(i)))
                drawnow
            end
            
            status = 'paused';
            set(hButton, 'String', 'Play')
            idxPaused = 1;
            
        catch ME
            % End gracefully if user closed figure during the animation.
            if ~strcmp(ME.identifier, 'MATLAB:class:InvalidHandle')
                rethrow(ME)
            end
        end
    end

end