function varargout = LoadingModel(varargin)
% LOADINGMODEL MATLAB code for LoadingModel.fig THIS CODE ALLOWS THE USER
% TO INPUT THE LOADING MAGNITUDE AND LOADING FREQUENCY. BASED ON THESE TWO
% INPUTS AND A CUSTOM NON-LINEAR LAODING EQUATION, THE THRESHOLD A SENSOR
% MUCH REACH TO TURN ON WILL BE DETERMINED. USING A RANDOM NUMBER GENERATOR
% AND THE ON THRESHOLD, A SENSOR WILL BE TURNED ON OR OFF. ON SENSORS WILL
% HAVE TO GO THROUGH A REFRACTORY PERIOD, WHILE SENSORS THAT ARE OFF WILL
% HAVE ANOTHER CHANCE TO TURN ON AT THE NEXT LOADING CYCLE. SENSORS TURNED
% ON WILL BE ADDED TO A TOTAL ON COUNTER, WHICH IS COMPARED AT THE END WITH
% THE MAXIMAL POSSIBLE TOTAL ON AND EXPRESSED AS A PERCENTAGE. THIS LOADING
% MODEL IS RUN 100 TIMES, AND THE DISTRIBUTION PLOTTED AS A PERCENT OF MAX
% THRESHOLD TURNED ON.
%
% Inputs into the GUI: Load magnitude, load frequency
% Output: Screenshot of GUI with graph & Matrix of values used for subplot function.  
%
% KINE 6203 Final Project
% Brian Diefenbach
% December 2nd, 2018
%      LOADINGMODEL, by itself, creates a new LOADINGMODEL or raises the existing
%      singleton*.
%
%      H = LOADINGMODEL returns the handle to a new LOADINGMODEL or the handle to
%      the existing singleton*.
%
%      LOADINGMODEL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LOADINGMODEL.M with the given input arguments.
%
%      LOADINGMODEL('Property','Value',...) creates a new LOADINGMODEL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LoadingModel_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LoadingModel_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LoadingModel

% Last Modified by GUIDE v2.5 08-Nov-2018 17:27:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LoadingModel_OpeningFcn, ...
                   'gui_OutputFcn',  @LoadingModel_OutputFcn, ...
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


% --- Executes just before LoadingModel is made visible.
function LoadingModel_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LoadingModel (see VARARGIN)

%Preallocate before it runs
handles.loadmag=[];%Setting loadmag to nothing
handles.freq=[];%Setting freq to nothing
handles.n=100;%N equals number of sensors.
handles.TheoMax = handles.n*3;
handles.edges = [0 .05 .1 .15 .2 .25 .3 .35 .4 .45 .5 .55 .6 .65 .7 .75 .8 .85 .9 .95 1.0];

% Choose default command line output for LoadingModel
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LoadingModel wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LoadingModel_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function LoadMag_Input_Callback(hObject, eventdata, handles)
% hObject    handle to LoadMag_Input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.loadmag=str2double(get(hObject,'String'));
% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of LoadMag_Input as text
%        str2double(get(hObject,'String')) returns contents of LoadMag_Input as a double


% --- Executes during object creation, after setting all properties.
function LoadMag_Input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LoadMag_Input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function LoadFreq_Input_Callback(hObject, eventdata, handles)
% hObject    handle to LoadFreq_Input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.freq=str2double(get(hObject,'String'));
% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of LoadFreq_Input as text
%        str2double(get(hObject,'String')) returns contents of LoadFreq_Input as a double


% --- Executes during object creation, after setting all properties.
function LoadFreq_Input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LoadFreq_Input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in Run_PushButton.
function Run_PushButton_Callback(hObject, eventdata, handles)
% hObject    handle to Run_PushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Update handles structure

%Turning the Run Button Back On
set(handles.Run_PushButton,'Enable','off')

%Clearing Input Check Statement (handles.Please)
clear handles.Please

%Clearing Graph
clear handles.FinalGraph_Axes
handles.GraphMat = [];

loadmag=handles.loadmag;
[onthreshold]=LoadEq(loadmag);%Use LoadEq to determine on threshold
handles.SensorMatrix = zeros(1,handles.n); %Sensor Matrix is full of zeros until it starts
handles.RefracP=20*handles.freq; %20 seconds is the refrac period

%Duration, 60 seconds it will cycle through for. Duration is a product of
%the frequency and the 60 seconds
handles.duration=handles.freq*60;

for l=1:100 %Cycle through 100 times to get a distribution
    handles.TotalOn=0;%Resetting total on to zero. 
    
    %The Cycle
    for j=1:handles.duration %Number of times through the cycle
        for k=1:handles.n 
            %Refractory Period Check
            if handles.SensorMatrix(1,k)>1 %Its still in the refractory period and cant be turned on
                handles.SensorMatrix(1,k)=handles.SensorMatrix(1,k)-1; %Subtracting one cycle from the refrac period
            else %It has the potential to be turned on
                handles.SensorMatrix(1,k) = rand(1); %Assinging the random digit
            end
        end
        for i=1:handles.n %If its higher than the onthreshold and still less than 1
            if handles.SensorMatrix(1,i)>=onthreshold && handles.SensorMatrix(1,i)<1
                handles.OnMatrix(1,i) = 1; %Denotes it was turned on in the OnMatrix with a 1
                handles.SensorMatrix(1,i)= handles.RefracP + 1; %Since it was on, now its refractory
            else
                handles.OnMatrix(1,i) = 0;%else it is not turned on. 
            end
        end
        handles.TotalOn = handles.TotalOn + sum(handles.OnMatrix); %Keeping track of Total On by summing OnMatrix
        clear handles.OnMatrix
    end
    
    %Comparing to the Theoretical Max, which was determined algebraically 
    handles.PercentTheoMax = handles.TotalOn/handles.TheoMax;
    handles.GraphMat = [handles.GraphMat, handles.PercentTheoMax];
 
    clear TotalOn
end

%Input check if inputs are not positive or numeric
freq=handles.freq;
if isnan(loadmag)==1 ||isnan(freq)==1||loadmag<=0||freq<=0
    set(handles.Please,'String','YOU DID NOT INPUT A POSITIVE INTEGER!')
else
     set(handles.Please,'String','Please Input Positive Integers Only')
end

%Saving Matrix of data to use later for subplot
savetitle=['LM',num2str(handles.loadmag),'F',num2str(handles.freq)]; %Title for saved file
GraphMat=handles.GraphMat;
save([savetitle,'.mat'],'GraphMat')

%Plotting GraphMat, the vector of each time through the cycle percent of on
%score based on the theoertical max value.
histogram(handles.GraphMat,handles.edges)
title(['Load Magnitude:',num2str(handles.loadmag),' Frequency:',num2str(handles.freq)]); 
xlabel('Percent of MaxThreshold Turned On')
ylabel('Number of Sensors')

%Turning the Run Button Back On
set(handles.Run_PushButton,'Enable','on')

%Saving Screenshot of the GUI
saveas(handles.FinalGraph_Axes,savetitle)

guidata(hObject, handles);
