function [name,file] = findfile(str,varargin)

% FINDFILE  Find File or Method, if exist
%
% [Name,File] = FINDFILE( String , 'Class' , '.Ext' )
%
% [Name,File] = FINDFILE( String , '@Class' , '.Ext' )
%
%   Search for Methods only
%

Nin  = nargin;
Nout = nargout;

name = '';
file = '';

if Nin < 1
   error('Not enough InputArguments.')
end

if ~chkstr(str,1)
   error('First Inputs must be a nonempty String.');
end

fs = filesep;
ns = '.';
cs = '@';

%*********************************************************
% Get Class and Extension

cls  = '';
ext  = 'm';   % Default: M-Files

for ii = 1 : Nin - 1
    v = varargin{ii};
    if chkstr(v,1)
       if strcmp(v(1),ns)
          ext = v(2:end);
       else
          cls = v;
       end
    else
       error('Following Inputs must be nonempty Strings.');
    end
end

%*********************************************************
% Check for Class only

chk = ~isempty(cls);
if chk
   chk = strcmp(cls(1),cs);
   if chk
      cls = cls(2:end);
      chk = ~isempty(cls);
   end
end

if ~isempty(ext)
    ext = cat(2,ns,ext);
end

%*********************************************************
% Check for File

ok = 0;

if ~isempty(cls)
    ff = cat(2,cls,fs,str,ext);
    ok = ( exist(ff,'file') == 2 );
end

if ~( ok | chk )
    ff = cat(2,str,ext);
    ok = ( exist(ff,'file') == 2 );
end

if ok
   name = ff;
   if Nout > 1
      file = which(name);
   end
end

%*********************************************************
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

function ok = chkstr(str,opt)


% CHKSTR  Checks Input for String
%
%  ok = chkstr(str,Option)
%
%  Option ~= 0 ==> only true for nonempty Strings
%
%   default:   Option == 0  (true for empty Strings)
%

 
if nargin < 2
   opt = 0;
end

ok = ( strcmp( class(str) , 'char' )      & ...
       ( prod(size(str)) == size(str,2) ) & ...
       ( isequal(opt,0) | ~isempty(str) )         );

