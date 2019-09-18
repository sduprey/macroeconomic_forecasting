function varargout = esg_gui(varargin)
% ESG_GUI MATLAB code for esg_gui.fig
%      ESG_GUI, by itself, creates a new ESG_GUI or raises the existing
%      singleton*.
%
%      H = ESG_GUI returns the handle to a new ESG_GUI or the handle to
%      the existing singleton*.
%
%      ESG_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ESG_GUI.M with the given input arguments.
%
%      ESG_GUI('Property','Value',...) creates a new ESG_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before esg_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to esg_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help esg_gui

% Last Modified by GUIDE v2.5 03-Nov-2011 12:07:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @esg_gui_OpeningFcn, ...
    'gui_OutputFcn',  @esg_gui_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before esg_gui is made visible.
function esg_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to esg_gui (see VARARGIN)

% Choose default command line output for esg_gui
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

ha=handles.axes8;
set(gcf,'CurrentAxes',ha);
axis off;
ha=handles.axes9;
set(gcf,'CurrentAxes',ha);
axis off;
ha=handles.axes10;
set(gcf,'CurrentAxes',ha);
axis off;
ha=handles.axes11;
set(gcf,'CurrentAxes',ha);
axis off;
ha=handles.axes12;
set(gcf,'CurrentAxes',ha);
axis off;
ha=handles.axes13;
set(gcf,'CurrentAxes',ha);
axis off;
ha=handles.axes14;
set(gcf,'CurrentAxes',ha);
axis off;
ha=handles.axes15;
set(gcf,'CurrentAxes',ha);
axis off;

% UIWAIT makes esg_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = esg_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in data_download_button.
function data_download_button_Callback(hObject, eventdata, handles)
% hObject    handle to data_download_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% loading the data
if license('test', 'datafeed_toolbox')
    % Load data from FRED and convert to quarterly periodicity
    % Note that dates are start-of-period dates in the FRED database
    fprintf('Loading time series data from St. Louis Federal Reserve (FRED) ...\n');
    % FRED time series to be used for our analysis
    series = { 'COE', 'CPIAUCSL', 'FEDFUNDS', 'GCE', 'GDP', 'GDPDEF', 'GPDI', ...
        'GS10', 'HOANBS', 'M1SL', 'M2SL', 'PCEC', 'TB3MS', 'UNRATE' };
    % Obtain data with "try-catch" and load Data_USEconModel.mat if problems occur
    try
        Universe = [];
        % Open a Datafeed Toolbox connection to FRED
        c = fred;
        for i = 1:numel(series)
            contents = cellstr(get(handles.log_listbox,'String'));
            contents = {contents{:},['Downloading %s ... ', series{i}, 'from FED'] }; %#ok<AGROW>
            set(handles.log_listbox,'String',contents);
            set(handles.log_listbox,'Value',length(contents));
            drawnow;
            fprintf('Started loading %s ... ',series{i});
            % Fetch data from FRED
            FredData = fetch(c, series{i});
            % Dates are start-of-period dates so move to end-of-period date
            offset = 1;
            if strcmpi(strtrim(FredData.Frequency),'Quarterly')
                offset = 2;
            elseif strmatch('Mar', strtrim(FredData.Frequency))
                offset = 2;
            else
                offset = 0;
            end
            % Set up dates
            dates = FredData.Data(:,1);
            mm = month(dates) + offset;
            yy = year(dates);
            for t = 1:numel(dates)
                if mm(t) > 12
                    mm(t) = mm(t) - 12;
                    yy(t) = yy(t) + 1;
                end
            end
            dates = lbusdate(yy, mm);
            % Set up data
            Data = FredData.Data(:,2);
            % Create financial time series
            fts = fints(dates, Data, series{i});
            % Convert to quarterly periodicity
            if strcmpi(strtrim(FredData.Frequency), 'Quarterly')
                fprintf('Quarterly ... ');
            elseif strmatch('Mar', strtrim(FredData.Frequency))
                fprintf('Quarterly ... ');
            else
                fprintf('Monthly ... ');
                fts = toquarterly(fts);
            end
            % Combine time series
            Universe = merge(fts, Universe);
            fprintf('Finished loading %s ...\n',series{i});
            contents = {contents{:},[series{i}, ' downloaded'] }; %#ok<AGROW>
            set(handles.log_listbox,'String',contents);
            set(handles.log_listbox,'Value',length(contents));
        end
        close(c);
        Universe.desc = 'U.S. Macroeconomic Data';
        Universe.freq = 'quarterly';
        % Trim date range to period from 1947 to present
        StartDate = datenum('31-Mar-1947');
        EndDate = datenum(Universe.dates(end));
        Universe = Universe([datestr(StartDate,1) '::' datestr(EndDate,1)]);
        % Convert combined time series into date and data arrays
        dates = Universe.dates;
        Data = fts2mat(Universe.(series));
        Dataset = dataset([{Data},series],'ObsNames',cellstr(datestr(dates,'QQ-YY')));
        % Uncomment next line to save data in Data_USEconModelUpdate.mat
        % save Data_USEconModelUpdate series dates Data Dataset
    catch E
        % Case with no internet connection
        fprintf('Loading data from Data_USEconModel.mat ...\n');
        load DATA_MOST_RECENT
        series = { 'COE', 'CPIAUCSL', 'FEDFUNDS', 'GCE', 'GDP', 'GDPDEF', 'GPDI', ...
            'GS10', 'HOANBS', 'M1SL', 'M2SL', 'PCEC', 'TB3MS', 'UNRATE' };
        % Obtain data with "try-catch" and load Data_USEconModel.mat if problems occur
        
        for i = 1:numel(series)
            contents = cellstr(get(handles.log_listbox,'String'));
            contents = {contents{:},['Downloading %s ... ', series{i}, 'from FED'] }; %#ok<AGROW>
            contents = {contents{:},[series{i}, ' downloaded'] }; %#ok<AGROW>
            set(handles.log_listbox,'String',contents);
            set(handles.log_listbox,'Value',length(contents));
            drawnow;
        end
    end
else
    % Case with no Datafeed Toolbox
    fprintf('Loading data from Data_USEconModel.mat ...\n');
    load DATA_MOST_RECENT
end

% preprocessing and displaying the data
Recessions = [ datenum('15-May-1937'), datenum('15-Jun-1938');
    datenum('15-Feb-1945'), datenum('15-Oct-1945');
    datenum('15-Nov-1948'), datenum('15-Oct-1949');
    datenum('15-Jul-1953'), datenum('15-May-1954');
    datenum('15-Aug-1957'), datenum('15-Apr-1958');
    datenum('15-Apr-1960'), datenum('15-Feb-1961');
    datenum('15-Dec-1969'), datenum('15-Nov-1970');
    datenum('15-Nov-1973'), datenum('15-Mar-1975');
    datenum('15-Jan-1980'), datenum('15-Jul-1980');
    datenum('15-Jul-1981'), datenum('15-Nov-1982');
    datenum('15-Jul-1990'), datenum('15-Mar-1991');
    datenum('15-Mar-2001'), datenum('15-Nov-2001');
    datenum('15-Dec-2007'), datenum('15-Jul-2009') ];
Recessions = busdate(Recessions);
% Remove dates with NaN values
ii = any(isnan(Data),2);
dates(ii) = [];
Data(ii,:) = [];
Dataset(ii,:) = [];
% Log series
CONS = log(Dataset.PCEC);
CPI = log(Dataset.CPIAUCSL);
DEF = log(Dataset.GDPDEF);
GCE = log(Dataset.GCE);
GDP = log(Dataset.GDP);
HOURS = log(Dataset.HOANBS);
INV = log(Dataset.GPDI);
M1 = log(Dataset.M1SL);
M2 = log(Dataset.M2SL);
WAGES = log(Dataset.COE);
% Interest rates (annual)
rFED = 0.01*(Dataset.FEDFUNDS);
rG10 = 0.01*(Dataset.GS10);
rTB3 = 0.01*(Dataset.TB3MS);
% Integrated rates
FED = ret2tick(0.25*rFED);
FED = log(FED(2:end));
G10 = ret2tick(0.25*rG10);
G10 = log(G10(2:end));
TB3 = ret2tick(0.25*rTB3);
TB3 = log(TB3(2:end));
% Unemployment rate
rUNEMP = 0.01*(Dataset.UNRATE)
UNEMP = ret2tick(0.25*rUNEMP);
UNEMP = log(UNEMP(2:end));
% Annualized rates
rCONS = [ 4*mean(diff(CONS(1:5))); 4*diff(CONS) ];
rCPI = [ 4*mean(diff(CPI(1:5))); 4*diff(CPI) ];
rDEF = [ 4*mean(diff(DEF(1:5))); 4*diff(DEF) ];
rGCE = [ 4*mean(diff(GCE(1:5))); 4*diff(GCE) ];
rGDP = [ 4*mean(diff(GDP(1:5))); 4*diff(GDP) ];
rHOURS = [ 4*mean(diff(HOURS(1:5))); 4*diff(HOURS) ];
rINV = [ 4*mean(diff(INV(1:5))); 4*diff(INV) ];
rM1 = [ 4*mean(diff(M1(1:5))); 4*diff(M1) ];
rM2 = [ 4*mean(diff(M2(1:5))); 4*diff(M2) ];
rWAGES = [ 4*mean(diff(WAGES(1:5))); 4*diff(WAGES) ];

set(gcf,'CurrentAxes',handles.axes8);
plot(handles.axes8,dates, [rGDP, rINV]);
Example_RecessionPlot(dates, Recessions,handles.axes8);
dateaxis('x');
title(handles.axes8,'\bfInvestment and Output');
h=legend(handles.axes8,'GDP','INV','Location','Best');
set(h,'FontSize',7,'Box','off');
axis(handles.axes8,[dates(1) - 600, dates(end) + 600, 0, 1]);
axis(handles.axes8, 'auto y');

set(gcf,'CurrentAxes',handles.axes9);
plot(handles.axes9,dates, [rCPI, rDEF]);
Example_RecessionPlot(dates, Recessions, handles.axes9);
dateaxis('x');
title(handles.axes9,'\bfInflation and GDP Deflator');
h = legend(handles.axes9,'CPI','DEF','Location','Best');
set(h,'FontSize',7,'Box','off');
axis(handles.axes9,[dates(1) - 600, dates(end) + 600, 0, 1]);
axis(handles.axes9, 'auto y');


set(gcf,'CurrentAxes',handles.axes10);
plot(handles.axes10,dates, [rWAGES, rHOURS]);
Example_RecessionPlot(dates, Recessions, handles.axes10);
dateaxis('x');
title(handles.axes10,'\bfWages and Hours');
h = legend(handles.axes10,'WAGES','HOURS','Location','Best');
set(h,'FontSize',7,'Box','off');
axis(handles.axes10,[dates(1) - 600, dates(end) + 600, 0, 1]);
axis(handles.axes10, 'auto y');


set(gcf,'CurrentAxes',handles.axes12);
plot(handles.axes12,dates, [rCONS, rGCE]);
Example_RecessionPlot(dates, Recessions, handles.axes12);
dateaxis('x');
title(handles.axes12,'\bfConsumption');
h = legend(handles.axes12,'CONS','GCE','Location','Best');
set(h,'FontSize',7,'Box','off');
axis(handles.axes12,[dates(1) - 600, dates(end) + 600, 0, 1]);
axis(handles.axes12, 'auto y');


set(gcf,'CurrentAxes',handles.axes13);
plot(handles.axes13,dates, [rFED, rG10, rTB3]);
Example_RecessionPlot(dates, Recessions, handles.axes13);
dateaxis('x');
title(handles.axes13,'\bfInterest Rates');
h = legend(handles.axes13,'FED','G10','TB3','Location','Best');
set(h,'FontSize',7,'Box','off');
axis(handles.axes13,[dates(1) - 600, dates(end) + 600, 0, 1]);
axis(handles.axes13, 'auto y');

set(gcf,'CurrentAxes',handles.axes14);
plot(handles.axes14,dates, rUNEMP);
Example_RecessionPlot(dates, Recessions,handles.axes14);
dateaxis('x');
title(handles.axes14,'\bfUnemployment');
h = legend(handles.axes14,'UNEMP','Location','Best');
set(h,'FontSize',7,'Box','off');
axis(handles.axes14,[dates(1) - 600, dates(end) + 600, 0, 1]);
axis(handles.axes14, 'auto y');

% data definition
Y = [rGDP, rDEF, rWAGES, rHOURS, rTB3, rCONS, rINV, rUNEMP];
iY = [GDP, DEF, WAGES, HOURS, TB3, CONS, INV, UNEMP];
YSeries = {'Output (GDP)', 'Prices', 'Total Wages', 'Hours Worked', ...
    'Cash Rate', 'Consumption', 'Private Investment', 'Unemployment'};
YAbbrev = {'GDP', 'DEF', 'WAGES', 'HOURS', 'TB3', 'CONS', 'INV', 'UNEMP'};
YInfo = 'U.S. Macroeconomic Model';
n = numel(YSeries);

setappdata(0, 'integrated_multi_serie_Y', Y);
setappdata(0, 'integrated_multi_serie_iY', iY);
setappdata(0, 'integrated_multi_serie_YSeries', YSeries);
setappdata(0, 'integrated_multi_serie_YAbbrev', YAbbrev);
setappdata(0, 'integrated_multi_serie_YInfo', YInfo);
setappdata(0, 'integrated_multi_serie_n', n);
setappdata(0, 'integrated_multi_serie_dates', dates);
setappdata(0, 'integrated_multi_serie_recessions', Recessions);


% --- Executes on button press in current_year_button.
function current_year_button_Callback(hObject, eventdata, handles)
% hObject    handle to current_year_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Y= getappdata(0, 'integrated_multi_serie_Y');
iY= getappdata(0, 'integrated_multi_serie_iY');
YSeries = getappdata(0, 'integrated_multi_serie_YSeries');
YAbbrev= getappdata(0, 'integrated_multi_serie_YAbbrev');
YInfo= getappdata(0, 'integrated_multi_serie_YInfo');
n= getappdata(0, 'integrated_multi_serie_n');
dates = getappdata(0, 'integrated_multi_serie_dates');
Recessions = getappdata(0, 'integrated_multi_serie_recessions');
nAR = 2;
% Set up date range
StartDate = lbusdate(1959,3);
EndDate = dates(end);
if StartDate < dates(1)
    error('StartDate is before earliest available date %s in data.',datestr(dates(1),1));
end
if EndDate > dates(end)
    error('EndDate is after last available date %s in data.',datestr(dates(end),1));
end
% Locate indexes in data for specified date range
iStart = find(StartDate <= dates,1);
if iStart < 1
    iStart = 1;
end
iEnd = find(EndDate <= dates,1);
if iEnd > numel(dates)
    iEnd = numel(dates);
end
% Set up data for estimation
D1 = dates(iStart:iEnd,:);			% dates for specified date range
if iStart > 1
    Y0 = Y(1:iStart-1,:);			% presample data
else
    Y0 = [];
end
Y1 = Y(iStart:iEnd,:);				% estimation data
% Set up model and estimate coefficients
Spec = vgxset('n', n, 'Constant', true, 'nAR', nAR, 'Series', YSeries, 'Info', YInfo);
Spec = vgxvarx(Spec, Y1, [], Y0);
% Do forecasts
FT = 20;
FD = Example_QuarterlyDates(dates(iEnd), FT);
[FY, FYCov] = vgxpred(Spec, FT, [], Y1);
FYSigma = zeros(size(FY));
for t = 1:FT
    FYSigma(t,:) = sqrt(diag(FYCov{t}))';
end
Hw = 20;                                    % number of historical quarters to display
Fw = 20;                                    % number of forecast quarters to display
Ow = max(0,min(Fw,(size(Y,1) - iEnd)));     % overlap between historical and forecast data
for i = 1:n
    ha = getMatchingHandle(handles, i);
    set(gcf,'CurrentAxes',ha);
    plot(ha,D1(end-Hw+1:end),Y1(end-Hw+1:end,i));
    hold on
    scatter(ha,dates(iEnd-Hw+1:iEnd+Ow),Y(iEnd-Hw+1:iEnd+Ow,i),'.');
    plot(ha,[D1(end); FD],[Y1(end,i); FY(:,i)],'b');
    plot(ha,FD,[FY(:,i) - FYSigma(:,i), FY(:,i) + FYSigma(:,i)],':r');
    dateaxis('x',12);
    %if i == 1
    %	title(['\bfModel Calibration to ' sprintf('%s',datestr(dates(iEnd),1))]);
    %end
    h = legend(ha,YSeries{i},'Location','best');
    set(h,'FontSize',7,'Box','off');
    title(ha,['\bf' YSeries{i}])
    hold off
end

% --- Executes on button press in past_year_button.
function past_year_button_Callback(hObject, eventdata, handles)
% hObject    handle to past_year_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.year_popup,'String'));
eyy=str2double(contents{get(handles.year_popup,'Value')});

Y= getappdata(0, 'integrated_multi_serie_Y');
iY= getappdata(0, 'integrated_multi_serie_iY');
YSeries = getappdata(0, 'integrated_multi_serie_YSeries');
YAbbrev= getappdata(0, 'integrated_multi_serie_YAbbrev');
YInfo= getappdata(0, 'integrated_multi_serie_YInfo');
n= getappdata(0, 'integrated_multi_serie_n');
dates = getappdata(0, 'integrated_multi_serie_dates');
Recessions = getappdata(0, 'integrated_multi_serie_recessions');
nAR = 2;

% Set up date range

StartDate = lbusdate(1959,3);
EndDate = lbusdate(eyy,3);

if StartDate < dates(1)
    error('StartDate is before earliest available date %s in data.',datestr(dates(1),1));
end
if EndDate > dates(end)
    error('EndDate is after last available date %s in data.',datestr(dates(end),1));
end

% Locate indexes in data for specified date range

iStart = find(StartDate <= dates,1);
if iStart < 1
    iStart = 1;
end
iEnd = find(EndDate <= dates,1);
if iEnd > numel(dates)
    iEnd = numel(dates);
end

% Set up data for estimation

D1 = dates(iStart:iEnd,:);			% dates for specified date range
if iStart > 1
    Y0 = Y(1:iStart-1,:);			% presample data
else
    Y0 = [];
end
Y1 = Y(iStart:iEnd,:);				% estimation data

% Set up model and estimate coefficients

Spec = vgxset('n', n, 'Constant', true, 'nAR', nAR, 'Series', YSeries, 'Info', YInfo);
Spec = vgxvarx(Spec, Y1, [], Y0);

% Do forecasts

FT = 20;
FD = Example_QuarterlyDates(dates(iEnd), FT);

[FY, FYCov] = vgxpred(Spec, FT, [], Y1);
FYSigma = zeros(size(FY));
for t = 1:FT
    FYSigma(t,:) = sqrt(diag(FYCov{t}))';
end

Hw = 20;                                    % number of historical quarters to display
Fw = 20;                                    % number of forecast quarters to display
Ow = max(0,min(Fw,(size(Y,1) - iEnd)));     % overlap between historical and forecast data

for i = 1:n
    ha = getMatchingHandle(handles, i);
    set(gcf,'CurrentAxes',ha);
    plot(ha,D1(end-Hw+1:end),Y1(end-Hw+1:end,i));
    hold on
    scatter(ha,dates(iEnd-Hw+1:iEnd+Ow),Y(iEnd-Hw+1:iEnd+Ow,i),'.');
    plot(ha,[D1(end); FD],[Y1(end,i); FY(:,i)],'b');
    plot(ha,FD,[FY(:,i) - FYSigma(:,i), FY(:,i) + FYSigma(:,i)],':r');
    dateaxis('x',12);
    %if i == 1
    %	title(['\bfModel Calibration to ' sprintf('%s',datestr(dates(iEnd),1))]);
    %end
    h = legend(ha,YSeries{i},'Location','best');
    set(h,'FontSize',7,'Box','off');
    title(ha,['\bf' YSeries{i}])
    hold off
end

% --- Executes on button press in backtest_button.
function backtest_button_Callback(hObject, eventdata, handles)
% hObject    handle to backtest_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Backtest to Assess Forecast Accuracy of the Model
%
% The next step is to determine the forecast accuracy of our model. To do this, we perform a
% Monte-Carlo simulation with 500 sample paths for each year from 1975 to the most recent prior
% year. Given 500 sample paths for each year, we estimate the root mean-square error (RMSE) between
% subsequent realizations and forecasts over the time horizon. For this analysis, the forecast
% horizon is 1 year.
%
% The RMSE forecasts work with integrated simulated forecast data to compute forecast accuracy
% because integrated forecasts provides a better measure of where the model is going than to work
% with differenced data.
%
% The results appear in the following table. Each row contains results for the end date of the
% estimation period which is also the start date for the forecast period. Following the date, each
% row contains the forecast RMSE for each series over the forecast horizon.





Y= getappdata(0, 'integrated_multi_serie_Y');
iY= getappdata(0, 'integrated_multi_serie_iY');
YSeries = getappdata(0, 'integrated_multi_serie_YSeries');
YAbbrev= getappdata(0, 'integrated_multi_serie_YAbbrev');
YInfo= getappdata(0, 'integrated_multi_serie_YInfo');
n= getappdata(0, 'integrated_multi_serie_n');
dates = getappdata(0, 'integrated_multi_serie_dates');
Recessions = getappdata(0, 'integrated_multi_serie_recessions');

nAR = 2;

syy = 1975;                 % start year for backtest
eyy = 2010;                 % end year for backtest

Horizon = 4;                % number of quarters for forecast horizon

[T, n] = size(Y);

FError = NaN(eyy - syy + 1, n);
FDates = zeros(eyy - syy + 1, 1);

fprintf('RMSE of Actual vs Model Forecast (x 100) with Horizon of %d Quarters\n',Horizon);
fprintf('%12s','ForecastDate');

contents = cellstr(get(handles.log_listbox,'String'));
contents = {contents{:},['RMSE of Actual vs Model Forecast (x 100) with Horizon of ' num2str(Horizon) ' Quarters'] }; %#ok<AGROW>
set(handles.log_listbox,'String',contents);
set(handles.log_listbox,'Value',length(contents));
drawnow;

for i = 1:n
    fprintf('  %7s',YAbbrev{i});
end
fprintf('\n');

for yy = syy:eyy
    
    StartDate = lbusdate(1959,3);
    EndDate = lbusdate(yy,12);
    
    if StartDate < dates(1)
        error('StartDate is before earliest available date %s in data.',datestr(dates(1),1));
    end
    if EndDate > dates(end)
        error('EndDate is after last available date %s in data.',datestr(dates(end),1));
    end
    
    % Locate indexes in data for specified date range
    
    iStart = find(StartDate <= dates,1);
    if iStart < 1
        iStart = 1;
    end
    iEnd = find(EndDate <= dates,1);
    if iEnd > numel(dates)
        iEnd = numel(dates);
    end
    
    if iStart > 1
        Y0 = Y(1:iStart-1,:);
    else
        Y0 = [];
    end
    Y1 = Y(iStart:iEnd,:);
    iY1 = iY(iStart:iEnd,:);
    
    % Set up model and estimate coefficients
    
    Spec = vgxset('n', n, 'Constant', true, 'nAR', nAR, 'Series', YSeries, 'Info', YInfo);
    Spec = vgxvarx(Spec, Y1, [], Y0);
    
    % Do forecasts
    
    NumPaths = 500;
    iFY = vgxsim(Spec, Horizon, [], Y1, [], NumPaths);
    iFY = repmat(iY1(end,:),[Horizon,1,NumPaths]) + 0.25*cumsum(iFY);
    eFY = mean(iFY,3);
    
    % Assess Forecast Quality
    
    Ow = max(0,min(Horizon,(size(Y,1) - iEnd)));		% overlap between actual and forecast data
    
    if Ow >= Horizon
        h = Horizon;
    else
        h = [];
    end
    
    FDates(yy-syy+1) = lbusdate(yy,12);
    if ~isempty(h)
        Yerr = iY(iEnd+1:iEnd+Ow,:) - eFY(1:Ow,:);
        
        Ym2 = Yerr(1:h,:) .^ 2;
        Yrmse = sqrt(mean(Ym2,1));
        contents = cellstr(get(handles.log_listbox,'String'));
        contents = {contents{:},['Forecast date ' datestr(EndDate,1)] }; %#ok<AGROW>
        set(handles.log_listbox,'String',contents);
        set(handles.log_listbox,'Value',length(contents));
        drawnow;
        
        fprintf('%12s',datestr(EndDate,1));
        for i = 1:n
            fprintf('  %7.2f',100*Yrmse(i));
        end
        FError(yy-syy+1,:) = 100*Yrmse';
        fprintf('\n');
    end
end

% Assess Forecast Accuracy
%
% The forecast errors are visualized in the following plot. On each subplot, the blue line plots the
% average of the RMSE forecast errors associated with each date along with the sample mean (green
% line) and standard deviation (dotted red lines) of these errors over all dates. A value of 1 on
% the plot corresponds with a 1% forecast error.
%
% Note that the standard deviation of forecast errors is somewhat misleading since forecast errors
% are one-sided. Nonetheless, the standard deviation offers a qualitative guide to the variability
% of forecast errors.

mFError = NaN(size(FError));
sFError = NaN(size(FError));
for i = 1:n
    mFError(:,i) = nanmean(FError(:,i));
    sFError(:,i) = nanstd(FError(:,i));
end

for i = 1:n
    ha = getMatchingHandle(handles, i);
    set(gcf,'CurrentAxes',ha);
    plot(ha,FDates,FError(:,i));
    hold on
    plot(ha,FDates,mFError(:,i),'g');
    plot(ha,FDates,[mFError(:,i) - sFError(:,i),mFError(:,i) + sFError(:,i)],':r');
    Example_RecessionPlot(FDates, Recessions, ha);
    dateaxis('x',12);
    %if i == 1
    %title(['\bfForecast Accuracy for ' sprintf('%g',Horizon/4) '-Year Horizon']);
    %end
    title(['\bf' YSeries{i}]);
    h = legend(ha,YSeries{i},'Location','best');
    set(h,'FontSize',7,'Box','off');
    hold off
end


% --- Executes on button press in scenario_button.
function scenario_button_Callback(hObject, eventdata, handles) %#ok<*INUSL>
% hObject    handle to scenario_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Y= getappdata(0, 'integrated_multi_serie_Y');
iY= getappdata(0, 'integrated_multi_serie_iY');
YSeries = getappdata(0, 'integrated_multi_serie_YSeries');
YAbbrev= getappdata(0, 'integrated_multi_serie_YAbbrev');
YInfo= getappdata(0, 'integrated_multi_serie_YInfo');
n= getappdata(0, 'integrated_multi_serie_n');
dates = getappdata(0, 'integrated_multi_serie_dates');
Recessions = getappdata(0, 'integrated_multi_serie_recessions');


contents = cellstr(get(handles.scenario_popup,'String'));
toImpulse=contents{get(handles.scenario_popup,'Value')};

YAbbrev = {'GDP', 'DEF', 'WAGES', 'HOURS', 'TB3', 'CONS', 'INV', 'UNEMP'};

nAR = 2;

% Set up date range

StartDate = lbusdate(1959,3);
EndDate = dates(end);

if StartDate < dates(1)
    error('StartDate is before earliest available date %s in data.',datestr(dates(1),1));
end
if EndDate > dates(end)
    error('EndDate is after last available date %s in data.',datestr(dates(end),1));
end

% Locate indexes in data for specified date range

iStart = find(StartDate <= dates,1);
if iStart < 1
    iStart = 1;
end
iEnd = find(EndDate <= dates,1);
if iEnd > numel(dates)
    iEnd = numel(dates);
end

% Set up data for estimation

D1 = dates(iStart:iEnd,:);			% dates for specified date range
if iStart > 1
    Y0 = Y(1:iStart-1,:);			% presample data
else
    Y0 = [];
end
Y1 = Y(iStart:iEnd,:);				% estimation data

% Set up model and estimate coefficients

Spec = vgxset('n', n, 'Constant', true, 'nAR', nAR, 'Series', YSeries, 'Info', YInfo);
Spec = vgxvarx(Spec, Y1, [], Y0);

% Do forecasts

FT = 20;
FD = Example_QuarterlyDates(dates(iEnd), FT);

[FY, FYCov] = vgxpred(Spec, FT, [], Y1);
FYSigma = zeros(size(FY));
for t = 1:FT
    FYSigma(t,:) = sqrt(diag(FYCov{t}))';
end

Hw = 20;                                    % number of historical quarters to display
Fw = 20;                                    % number of forecast quarters to display
Ow = max(0,min(Fw,(size(Y,1) - iEnd)));     % overlap between historical and forecast data

Impulses = YAbbrev;
Responses = YAbbrev;

W0 = zeros(FT, n);


for i = 1:size(YAbbrev,2)
    if strncmp(YAbbrev{i},toImpulse,3)
        break;
    end
end




%for i = 1:n
WX = W0;
WX(1,i) = sqrt(Spec.Q(i,i));
% YX = 100*(vgxproc(Spec, WX, [], Y1) - vgxproc(Spec, W0, [], Y1));
% YX = 100*(vgxproc(Spec, WX, [], Y1));
YX =vgxproc(Spec, WX, [], Y1);


for j = 1:n
    ha = getMatchingHandle(handles, j);
    set(gcf,'CurrentAxes',ha);
    plot(ha,D1(end-Hw+1:end),Y1(end-Hw+1:end,j));
    hold on
    scatter(ha,dates(iEnd-Hw+1:iEnd+Ow),Y(iEnd-Hw+1:iEnd+Ow,j),'.');
    plot(ha,[D1(end); FD],[Y1(end,j); YX(:,j)],'b');
    plot(ha,FD,[YX(:,j) - FYSigma(:,j), YX(:,j) + FYSigma(:,j)],':r');
    dateaxis('x',12);
    % 	if j == 1
    % 		title(['\bf Impulse response to an increase in ' YAbbrev{i}]);
    % 	end
    h = legend(ha,YSeries{j},'Location','best');
    set(h,'FontSize',7,'Box','off');
    title(ha,['\bf' YSeries{i}])
    hold off
end

%end
% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in year_popup.
function year_popup_Callback(hObject, eventdata, handles)
% hObject    handle to year_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns year_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from year_popup
contents = cellstr(get(handles.year_popup,'String'));
eyy=str2double(contents{get(handles.year_popup,'Value')});

Y= getappdata(0, 'integrated_multi_serie_Y');
iY= getappdata(0, 'integrated_multi_serie_iY');
YSeries = getappdata(0, 'integrated_multi_serie_YSeries');
YAbbrev= getappdata(0, 'integrated_multi_serie_YAbbrev');
YInfo= getappdata(0, 'integrated_multi_serie_YInfo');
n= getappdata(0, 'integrated_multi_serie_n');
dates = getappdata(0, 'integrated_multi_serie_dates');
Recessions = getappdata(0, 'integrated_multi_serie_recessions');
nAR = 2;

% Set up date range

StartDate = lbusdate(1959,3);
EndDate = lbusdate(eyy,3);

if StartDate < dates(1)
    error('StartDate is before earliest available date %s in data.',datestr(dates(1),1));
end
if EndDate > dates(end)
    error('EndDate is after last available date %s in data.',datestr(dates(end),1));
end

% Locate indexes in data for specified date range

iStart = find(StartDate <= dates,1);
if iStart < 1
    iStart = 1;
end
iEnd = find(EndDate <= dates,1);
if iEnd > numel(dates)
    iEnd = numel(dates);
end

% Set up data for estimation

D1 = dates(iStart:iEnd,:);			% dates for specified date range
if iStart > 1
    Y0 = Y(1:iStart-1,:);			% presample data
else
    Y0 = [];
end
Y1 = Y(iStart:iEnd,:);				% estimation data

% Set up model and estimate coefficients

Spec = vgxset('n', n, 'Constant', true, 'nAR', nAR, 'Series', YSeries, 'Info', YInfo);
Spec = vgxvarx(Spec, Y1, [], Y0);

% Do forecasts

FT = 20;
FD = Example_QuarterlyDates(dates(iEnd), FT);

[FY, FYCov] = vgxpred(Spec, FT, [], Y1);
FYSigma = zeros(size(FY));
for t = 1:FT
    FYSigma(t,:) = sqrt(diag(FYCov{t}))';
end

Hw = 20;                                    % number of historical quarters to display
Fw = 20;                                    % number of forecast quarters to display
Ow = max(0,min(Fw,(size(Y,1) - iEnd)));     % overlap between historical and forecast data

for i = 1:n
    ha = getMatchingHandle(handles, i);
    set(gcf,'CurrentAxes',ha);
    plot(ha,D1(end-Hw+1:end),Y1(end-Hw+1:end,i));
    hold on
    scatter(ha,dates(iEnd-Hw+1:iEnd+Ow),Y(iEnd-Hw+1:iEnd+Ow,i),'.');
    plot(ha,[D1(end); FD],[Y1(end,i); FY(:,i)],'b');
    plot(ha,FD,[FY(:,i) - FYSigma(:,i), FY(:,i) + FYSigma(:,i)],':r');
    dateaxis('x',12);
    %if i == 1
    %	title(['\bfModel Calibration to ' sprintf('%s',datestr(dates(iEnd),1))]);
    %end
    h = legend(ha,YSeries{i},'Location','best');
    set(h,'FontSize',7,'Box','off');
    hold off
end


% --- Executes during object creation, after setting all properties.
function year_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to year_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in scenario_popup.
function scenario_popup_Callback(hObject, eventdata, handles)
% hObject    handle to scenario_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns scenario_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from scenario_popup


% --- Executes during object creation, after setting all properties.
function scenario_popup_CreateFcn(hObject, eventdata, handles) %#ok<*INUSD,*DEFNU>
% hObject    handle to scenario_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in monte_carlo_button.
function monte_carlo_button_Callback(hObject, eventdata, handles)
% hObject    handle to monte_carlo_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Y= getappdata(0, 'integrated_multi_serie_Y');
iY= getappdata(0, 'integrated_multi_serie_iY');
YSeries = getappdata(0, 'integrated_multi_serie_YSeries');
YAbbrev= getappdata(0, 'integrated_multi_serie_YAbbrev');
YInfo= getappdata(0, 'integrated_multi_serie_YInfo');
n= getappdata(0, 'integrated_multi_serie_n');
dates = getappdata(0, 'integrated_multi_serie_dates');
Recessions = getappdata(0, 'integrated_multi_serie_recessions');
nAR = 2;

contents = cellstr(get(handles.year_popup,'String'));
yy=str2double(contents{get(handles.year_popup,'Value')});
Horizon = 4;                % number of quarters for forecast horizon
[T, n] = size(Y);
NumPaths = 500;

fprintf('RMSE of Actual vs Model Forecast (x 100) with Horizon of %d Quarters\n',Horizon);
fprintf('%12s','ForecastDate');
for i = 1:n
    fprintf('  %7s',YAbbrev{i});
end
fprintf('\n');

StartDate = lbusdate(1959,3);
EndDate = lbusdate(yy,12);
if StartDate < dates(1)
    error('StartDate is before earliest available date %s in data.',datestr(dates(1),1));
end
if EndDate > dates(end)
    error('EndDate is after last available date %s in data.',datestr(dates(end),1));
end
% Locate indexes in data for specified date range
iStart = find(StartDate <= dates,1);
if iStart < 1
    iStart = 1;
end
iEnd = find(EndDate <= dates,1);
if iEnd > numel(dates)
    iEnd = numel(dates);
end

if iStart > 1
    Y0 = Y(1:iStart-1,:);
else
    Y0 = [];
end
Y1 = Y(iStart:iEnd,:);
iY1 = iY(iStart:iEnd,:);
% Set up model and estimate coefficients
Spec = vgxset('n', n, 'Constant', true, 'nAR', nAR, 'Series', YSeries, 'Info', YInfo);
Spec = vgxvarx(Spec, Y1, [], Y0);
% Do forecasts
iFY = vgxsim(Spec, Horizon, [], Y1, [], NumPaths);
% warning : the VARMAX process models the yields !
% warning : from yields we come back to the indices
% Monte Carlo pathes ploting for nice visualisation
% Visualize first 80 prices of 100 paths
%plot(data.Date(end-20:end), S(end-20:end), data.Date(end)+(0:79), Ssim(1:80,1:100));
%datetick; xlabel('Date'); ylabel('NG Spot Price');
figure;
for i = 1:n
    subplot(ceil(n/2),2,i,'align');
    FVizu = zeros(Horizon+1,NumPaths);
    FVizu(1,1:NumPaths) = Y(iEnd,i);
    FVizu(2:Horizon + 1,1:NumPaths)= iFY(1:Horizon,i,1:NumPaths);
    if i == 5 % cash rate index in Y columns
        rateMC_Values = zeros (iEnd-iStart+1+Horizon,NumPaths);
        rateMC_Values(iStart:iEnd,:) = repmat(squeeze(Y(iStart:iEnd,i)),1,NumPaths);
        rateMC_Values(iEnd:(iEnd+Horizon),:) = FVizu;
    end
    % ploting
    plot(dates(iStart:iEnd),Y(iStart:iEnd,i),  dates(iEnd+(0:Horizon)), FVizu(1:Horizon+1,1:NumPaths),dates(iEnd:end),Y(iEnd:end,i));
    Example_RecessionPlot(dates, Recessions);
    dateaxis('x',12);
    axis 'auto y'
    if i == 1
        title(['\bf VARMAX Monte Carlo Forecast Pathes for ' sprintf('%g',Horizon/4) '-Year Horizon']);
    end
    title(['\bf' YSeries{i}]);
    h = legend(YSeries{i},'Location','best');
    set(h,'FontSize',7,'Box','off');
    %%%%% end of plotting
end


% --- Executes on selection change in log_listbox.
function log_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to log_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns log_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from log_listbox


% --- Executes during object creation, after setting all properties.
function log_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to log_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
