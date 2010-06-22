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

function [U V] = nnsort2(u, v, p)
% nnsort2  Nearest-neighbor sort on a 2D binary path.
  
  num_pixels = length(u);
  assert(num_pixels == length(v));
  
  end_u = find(u == p(1));
  end_v = find(v == p(2));
  end_t = intersect(end_u, end_v);
  
  ui = u(1);
  vi = v(1);
  u(1) = u(end_t);
  v(1) = v(end_t);
  u(end_t) = ui;
  v(end_t) = vi;
  
  for i = 2:num_pixels
    % Find nearest point not already counted with 8-connectivity
    ut_above = find(u >= u(i-1)-1);
    ut_below = find(u <= u(i-1)+1);
    vt_above = find(v >= v(i-1)-1);
    vt_below = find(v <= v(i-1)+1);
    ut = intersect(ut_above, ut_below);
    vt = intersect(vt_above, vt_below);
    ti = intersect(ut, vt);
    t = ti(length(ti));
    ui = u(i);
    vi = v(i);
    u(i) = u(t);
    v(i) = v(t);
    u(t) = ui;
    v(t) = vi;
  end
  
  U = u;
  V = v;
  
end
