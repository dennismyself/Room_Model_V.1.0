function [u, v] = twoPhaseInitialConditions(p, T, x, TLU, sat)
%twoPhaseInitialConditions   computes the specific internal energy and
%   specific volume corresponding to the given values of any two of
%   pressure, temperature, or vapor quality.
%
%   [U, V] = twoPhaseInitialConditions(P, T, X, TLU, SAT) returns the
%   specific internal energy U and the specific volume V corresponding to
%   any two of pressure P, temperature T, and vapor quality X using the
%   fluid properties tables in the structure TLU and fluid saturation
%   tables in the structure SAT.
%
%   By default, U and V are computed from P and T and X is ignored. To
%   compute U and V from P and X, specify a negative value for T. Likewise,
%   to compute U and V from T and X, specify a negative value for P.
%
%   The structure TLU contains the fields p, u, v, and T, corresponding to
%   fluid property tables of pressure, specific internal energy, specific
%   volume, and temperature, respectively. The structure SAT contains the
%   fields u_liq and u_vap, corresponding to fluid saturation tables of
%   liquid specific internal energy and vapor specific internal energy,
%   respectively.

%   Copyright 2013-2014 The MathWorks, Inc.

% Initial pressure and initial temperature specified.
% Initial vapor quality ignored.
if (p > 0) && (T > 0)
    
    % Initial pressure must be within range of the fluid property tables.
    if p < TLU.p(1)
        pm_error('simscape:GreaterThanOrEqual', 'Initial pressure', 'minimum allowable pressure');
    end
    if p > TLU.p(end)
        pm_error('simscape:LessThanOrEqual', 'Initial pressure', 'maximum allowable pressure');
    end
    
    % Initial temperature must be within range of the fluid property tables.
    T_interp = griddedInterpolant({TLU.p, TLU.u}, TLU.T, 'linear', 'nearest');
    if T < T_interp(p, TLU.u(1))
        pm_error('simscape:GreaterThanOrEqual', 'Initial temperature', 'minimum allowable temperature');
    end
    if T > T_interp(p, TLU.u(end))
        pm_error('simscape:LessThanOrEqual', 'Initial temperature', 'maximum allowable temperature');
    end
    
    % Determine the initial specific enthalpy from the fluid property tables.
    [u, ~, exitflag] = fzero(@(u) T - T_interp(p, u), [TLU.u(1) TLU.u(end)]);
    pm_assert(exitflag > 0, 'Failed to solve for the initial density and specific internal energy from the specified initial pressure and temperature.');
    
    % Interpolate for the specific volume.
    v_interp = griddedInterpolant({TLU.p, TLU.u}, TLU.v, 'linear', 'nearest');
    v = v_interp(p, u);
    
    return
end

% Initial pressure and initial vapor quality specified.
% Initial temperature ignored.
if T <= 0
    
    % Initial pressure must be within range of the fluid property tables.
    if p < TLU.p(1)
        pm_error('simscape:GreaterThanOrEqual', 'Initial pressure', 'minimum allowable pressure');
    end
    if p > TLU.p(end)
        pm_error('simscape:LessThanOrEqual', 'Initial pressure', 'maximum allowable pressure');
    end
end

% Initial temperature and initial vapor quality specified.
% Initial pressure ignored.
if p <= 0
    
    % Interpolate for the saturation temperature for each pressure.
    T_interp = griddedInterpolant({TLU.p, TLU.u}, TLU.T, 'linear', 'nearest');
    T_sat = T_interp(TLU.p, (sat.u_liq + sat.u_vap)/2);
    
    % Initial temperature must be within range of the fluid property tables.
    if T < T_sat(1)
        pm_error('simscape:GreaterThanOrEqual', 'Initial temperature', 'minimum saturation temperature');
    end
    if T > T_sat(end)
        pm_error('simscape:LessThanOrEqual', 'Initial temperature', 'maximum saturation temperature');
    end
    
    % Interpolate for the pressure.
    p_interp = griddedInterpolant(T_sat, TLU.p, 'linear', 'nearest');
    p = p_interp(T);
end

% Initial vapor quality must be between 0 and 1.
if x < 0
    pm_error('simscape:GreaterThanOrEqualToZero', 'Initial vapor quality');
end
if x > 1
    pm_error('simscape:LessThanOrEqual', 'Initial vapor quality', '1');
end

% Interpolate for the saturated specific internal energy.
u_liq_interp = griddedInterpolant(TLU.p, sat.u_liq, 'linear', 'nearest');
u_vap_interp = griddedInterpolant(TLU.p, sat.u_vap, 'linear', 'nearest');

% Determine the initial specific enthalpy for the mixture.
u = x*u_vap_interp(p) + (1 - x)*u_liq_interp(p);

% Interpolate for the specific volume.
v_interp = griddedInterpolant({TLU.p, TLU.u}, TLU.v, 'linear', 'nearest');
v = v_interp(p, u);

end