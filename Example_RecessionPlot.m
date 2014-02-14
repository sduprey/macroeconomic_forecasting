function Example_RecessionPlot(dates,Recessions, graphicsHandle)
%EXAMPLE_RECESSIONPLOT Add recession bands to time series plot
%
% Syntax:
%
%   Example_RecessionPlot(dates,Recessions)
%
% Description:
%
%   Overlay shaded bands to identify recessions on a time series plot.
%
% Input Arguments:
%
%   dates - Date numbers used in time series plot.
%
%   Recessions - numRecessions x 2 array of date numbers. Each row contains
%     the start and end date of a recession.

% Copyright 2010 The MathWorks, Inc.
% $Revision: 1.1.6.1 $   $Date: 2009/09/23 14:00:52 $
if (nargin == 2)
graphicsHandle = gca;
end

for r = 1:size(Recessions,1)
    
	if Recessions(r,2) > min(dates) && Recessions(r,1) <= max(dates)
        
		ph(r) = patch([Recessions(r,1) Recessions(r,1) Recessions(r,2) Recessions(r,2)], ...
			          [get(graphicsHandle,'YLim') fliplr(get(graphicsHandle,'YLim'))], [0 0 0 0], 'm');
		set(ph(r),'FaceAlpha',0.1,'EdgeColor','none');
        
	end
    
end