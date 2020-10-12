function varargout = anno(varargin)
% ANNO MATLAB code for anno.fig
%      ANNO, by itself, creates a new ANNO or raises the existing
%      singleton*.
%
%      H = ANNO returns the handle to a new ANNO or the handle to
%      the existing singleton*.
%
%      ANNO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANNO.M with the given input arguments.
%
%      ANNO('Property','Value',...) creates a new ANNO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before anno_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to anno_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help anno

% Last Modified by GUIDE v2.5 30-Jun-2020 09:42:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @anno_OpeningFcn, ...
                   'gui_OutputFcn',  @anno_OutputFcn, ...
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


% --- Executes just before anno is made visible.
function anno_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to anno (see VARARGIN)

% Choose default command line output for anno
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes anno wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = anno_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function ResetData()
global RESULT
global choose
global left
global IMGS;
global EYEX;
global EYEY;

left = 0;
imgs = RESULT{1,1};
[newimgs ind] = sort(imgs);
RESULT{1,1} = RESULT{1,1}(ind,:);
RESULT{1,2} = RESULT{1,2}(ind,:);
RESULT{1,3} = RESULT{1,3}(ind,:);
imgs = RESULT{1,1};
n = size(RESULT{1,1});
firstmeet = 0;
previd = 'none';
choose = [];
for i=1:n(1)
    imgpath = imgs{i,1};
    S = regexp(imgpath, '/', 'split');
    imgname = S(end);
    [vid, index] = regexp(imgname, '-', 'split');
    vid = vid{1,1}{1,1};
    if strcmp(vid,previd)
        choose(i) = 0;
    else
        previd = vid;
        choose(i) = 1;
        left = left + 1;
    end
end

IMGS_ = cell(left,1);
EYEX_ = ones(left,1);
EYEY_ = ones(left,1);

index = 1;
for i=1:n(1)
    if(choose(i)==1)
        IMGS_{index,1} = IMGS{i,1};
        EYEX_(index,1) = EYEX(i,1);
        EYEY_(index,1) = EYEY(i,1);
        index = index+1;
    end
end
IMGS = IMGS_;
EYEX = EYEX_;
EYEY = EYEY_;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IMGPATH;
global IMGS;
global EYEX;
global EYEY;
global INDEX;
global RESULT;
global left;
INDEX = 1;
IMGPATH = uigetdir;
EyePosPath = [IMGPATH, '/eye.txt'];
[IMGS, EYEX, EYEY] = textread(EyePosPath,'%s%n%n');
RESULT = {IMGS,EYEX,EYEY};
ResetData();
RESULT = {IMGS,EYEX,EYEY};
set(handles.text6,'String', num2str(left));
set(gcf,'WindowButtonDownFcn',@ButttonDownFcn);
show_images(hObject, eventdata);


function show_images(hObject, eventdata)
global IMGS;
global IMGPATH;
global EYEX;
global EYEY;
global INDEX;
imgname = IMGS(INDEX);
imgname = imgname{1,1};
imgname = regexp(imgname, '/', 'split');
path = [IMGPATH, '/', imgname{1,end}];
INDEX
% axes(handles.axes1);
image = imread(path);
imshow(image);

x = EYEX(INDEX);
y = EYEY(INDEX);

hold on
plot(x,y,'.','Color','g','MarkerSize',16);




function ButttonDownFcn(hObject, eventdata)
global EYEX;
global EYEY;
global INDEX;
global RESULT;
show_images(hObject, eventdata);
pt = get(gca,'CurrentPoint');
x = pt(1,1);
y = pt(1,2);
if x>0 & y>0 & x<224 & y <224
     plot(x,y,'.','Color','g','MarkerSize',16);
     plot([x EYEX(INDEX)],[y EYEY(INDEX)],'Color','y');
     RESULT{1,2}(INDEX) = x;
     RESULT{1,3}(INDEX) = y;
    %set(handles.text4,'String', num2str(x));
    %set(handles.text5,'String', num2str(y));
end



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global INDEX
global EYEX
global RESULT
global choose
global left

INDEX = INDEX + 1;
set(handles.text6, 'String', num2str(left)); 
left = left - 1 ;
show_images(hObject, eventdata);


if left == 1
    fileID = fopen('res.txt','w');
    imgnames = RESULT{1,1}(1:466-left);
    xs = RESULT{1,2}(1:466-left);
    ys = RESULT{1,3}(1:466-left);
    for pos = 1:size(xs)
        fprintf(fileID,'%s %d %d\n',imgnames{pos,1}, round(xs(pos)), round(ys(pos)));
    end
    fprintf(fileID,'end\n');
    fclose(fileID);
end
