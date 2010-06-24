% Copyright (C) 2010, Mingzhai Sun <mingzhai@gmail.com>
% 
% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details. 
% 
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307,
% USA.

function [mask2d] = iterthresh(imIn);
%  bound = 1e-6; % choose some mimimum bound
%  mask2d = data2d(y+1:y+height,x+1:x+width);
%  % Get initial average
%  T_old = Inf;
%  T = mean2(data2d(y+1:y+height,x+1:x+width));
%  i = 0;
%  % Loop until within bound
%  while abs(T-T_old) > bound
%    i = i+1;
%    T_old = T;
%    below = double(data2d(y+1:y+height,x+1:x+width)).*double(data2d(y+1:y+height,x+1:x+width) <= T);
%    above = double(data2d(y+1:y+height,x+1:x+width)).*double(data2d(y+1:y+height,x+1:x+width) > T);
%    T_below = mean2(below);
%    T_above = mean2(above);
%    T = (T_above+T_below)/2;
%    [T_above,T_below,T]
%  end
  %imIn = data2d(y:y+height-1,x:x+width-1);
  T = 0.5*(double(min(imIn(:)))+double(max(imIn(:))));
  done = 0;
  while ~done
    g = imIn >= T;
    Tnext = 0.5*(mean(imIn(g))+mean(imIn(~g)));
    done = abs(T-Tnext) < T*1e-3;
    T = Tnext;
  end
  %mask2d = double(data2d(y+1:y+height,x+1:x+width)).*double(data2d(y+1:y+height,x+1:x+width) > T);
  mask2d = imIn >= T;
end
