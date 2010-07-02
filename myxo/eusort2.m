% Copyright (C) 2010, Peter Jin <peterhaijin@gmail.com>
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

% --- 
% Performs a 2D euclidean sort on [u v], starting at p = [u0 v0].
function [U V] = eusort2(u, v, p)
  
  num_pixels = length(u);
  assert(num_pixels == length(v));
  
  end_u = find(u == p(1));
  end_v = find(v == p(2));
  end_t = intersect(end_u, end_v);
  num_t = length(end_t);
  assert(num_t == 1);
  
  U = zeros(num_pixels, 1);
  V = zeros(num_pixels, 1);
  U(1) = u(end_t);
  V(1) = v(end_t);
  
%  if end_t == 1
%    u = u(2:end);
%    v = v(2:end);
%  elseif end_t == num_t
%    u = u(1:end-1);
%    v = v(1:end-1);
%  else
%    u = [u(1:end_t-1);u(end_t+1:end)];
%    v = [v(1:end_t-1);v(end_t+1:end)];
%  end
  
  u(end_t) = [];
  v(end_t) = [];
  
  for i = 1:num_pixels-1
    norms = (U(i)-u).^2+(V(i)-v).^2;
    norms(norms == 0) = Inf;
    t = find(norms == min(norms));
    U(i+1) = u(t);
    V(i+1) = v(t);
    u(t) = [];
    v(t) = [];
  end
  
end
