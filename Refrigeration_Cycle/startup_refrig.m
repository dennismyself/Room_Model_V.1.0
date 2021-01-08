addpath([pwd '/Libraries']);
addpath([pwd '/Images']);
addpath([pwd '/Scripts_Data']);

pm_addunit('kJ', 1e3, 'J')
pm_addunit('uPa', 1e-6, 'Pa')

cd Libraries
if exist('refrigeration_lib', 'file')
    ssc_build refrigeration
end
cd ..

refrigerationCycle

% Copyright 2013-2014 The MathWorks, Inc.
