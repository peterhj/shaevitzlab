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

function [closed] = localclose(mask, pt, b)
  closed = mask;
  [v u] = find(closed > 0);
  u_ab = find(u >= pt(1)-b);
  u_be = find(u <= pt(1)+b);
  v_ab = find(v >= pt(2)-b);
  v_be = find(v <= pt(2)+b);
  t = intersect(intersect(u_ab, u_be), intersect(v_ab, v_be));
  for i = 1:length(t)
    [x1 x2 x3 vv uu] = bresenham(closed, [pt(1) pt(2); u(t(i)) v(t(i))], 0);
    for j = 1:length(uu)
      closed(vv(j),uu(j)) = 1;
    end
  end
end
