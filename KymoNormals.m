% Copyright (C) 2010, Peter Jin and Mingzhai Sun
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
% 
% Authors: 
% Peter Jin 
% peterhaijin@gmail.com
% 
% Mingzhai Sun
% mingzhai@gmail.com
% 
% v1.0 16-June-2010

function [normals extend poles] = KymoNormals(retract, ends, mask, b, c, d)
% KymoNormals returns [...]
%
% [normals extend poles] = KymoNormals(retract, ends, mask, b, exd, n)
%
% Inputs: retract - binary image with all centerline pixel values of 1 and
%           all others zeros. 
%         ends - two ends of the centerline. 
%         mask - image mask
%         b - normal half window (?)
%
% Outputs: normals - contour of the input image
%          extend - the center line of the image 
% 
% Algorithm: [...]
  
  normals = {};
  
  % 2-pass path interpolation
  % 1. Sort points by nearest neighbor and interpolate
  % 2. Linearly extend the endpoints and interpolate
  
  x = 1; y = 2;
  [v u] = find(retract > 0);
  num_pixels = length(u);
  
  % 1. Nearest-neighbor sort, starting at an endpoint
  [u v] = nnsort2(u, v, ends(1,:));
  uf = interparc(ceil(num_pixels/15), u, v, 'linear');
  uf = interparc(num_pixels, uf(:,1), uf(:,2), 'spline');
  
%  figure % compare (sorted) original with interpolated curve
%  hold on
%  plot(u, v);
%  plot(uf(:,1), uf(:,2));
%  hold off
%  figure
%  plot(1:num_pixels, df);
%  figure
%  plot(1:num_pixels, nm);
  
  % 2. Extrapolate from the ends to the poles and find the total pixel count
  head_pt = uf(1,:);
  tail_pt = uf(end,:);
  head_df = uf(1,:)-uf(2,:);
  tail_df = uf(end,:)-uf(end-1,:);
  head_step = head_df/norm(head_df);%1/(1+(head_df(2)/head_df(1))^2);
  tail_step = tail_df/norm(tail_df);%1/(1+(tail_df(2)/tail_df(1))^2);
  
  head_pts = [];
  tail_pts = [];
  head_pt = round(head_pt);
  tail_pt = round(tail_pt);
  last_head_pt = head_pt;
  last_tail_pt = tail_pt;
  [v_bound u_bound] = size(mask);
  
  % linear increment past the ends of the retract, and check if the nearest 
  % pixels are still in the threshold mask
  for i = 1:2*b+c
    pt = round(head_pt+i*head_step);
    if pt(2) < 1 || pt(1) < 1
      unused = 0;
    elseif pt(2) > v_bound || pt(1) > u_bound
      unused = 0;
    elseif mask(pt(2),pt(1)) > 0 || i <= c
      if pt == head_pt
        unused = 0;
      elseif pt == last_head_pt
        unused = 0;
      else
        head_pts = [pt; head_pts];
        last_head_pt = pt;
        retract(pt(2),pt(1)) = 1;
      end
    end
    pt = round(tail_pt+i*tail_step);
    if pt(2) < 1 || pt(1) < 1
      unused = 0;
    elseif pt(2) > v_bound || pt(1) > u_bound
      unused = 0;
    elseif mask(pt(2),pt(1)) > 0 || i <= c
      if pt == tail_pt
        unused = 0;
      elseif pt == last_tail_pt
        unused = 0;
      else
        tail_pts = [tail_pts; pt];
        last_tail_pt = pt;
        retract(pt(2),pt(1)) = 1;
      end
    end
  end
  
  u = [head_pts(:,1); u; tail_pts(:,1)];
  v = [head_pts(:,2); v; tail_pts(:,2)];
  num_pixels = length(u);
  
%  if n == 0
%    num_pixels = length(u);
%  else
%    num_pixels = n;
%  end
  
  poles = [u(1) v(1); u(end) v(end)];
  
  uf = interparc(ceil(num_pixels/15), u, v, 'linear');
  uf = interparc(num_pixels, uf(:,1), uf(:,2), 'spline');
  df = diff(uf(:,2))./diff(uf(:,1));
  df = [df; df(end)];
  nm = -1./df;
  
%  figure
%  hold on
%  plot(u, v);
%  plot(uf(:,1), uf(:,2));
%  hold off
%  figure
%  plot(1:num_pixels, df);
%  figure
%  plot(1:num_pixels, nm);
  
  % Try to extend (uu,vv) to (min(u),v) and (max(u),v)
%  du = 0.1;
%  uu = min(u)-sgh*du:du:max(u)+sgh*du;  sgh is the sgolay half-window
%  pp = splinefit(u, v, 32);
%  vv = ppval(pp, uu);
%  vv_floor = find(vv <= min(v));
%  if isempty(vv_floor) == 0
%    if vv(vv_floor(end)) > vv(vv_floor(1))
%      the_vv_floor = max(vv_floor);
%    else
%      the_vv_floor = min(vv_floor);
%    end
%    uu_min = min(u)+du*(the_vv_floor-1-sgh);
%  else
%    uu_min = min(u);
%  end
%  vv_ceil = find(vv >= max(v));
%  if isempty(vv_ceil) == 0
%    if vv(vv_ceil(end)) > vv(vv_ceil(1))
%      the_vv_ceil = min(vv_ceil);
%    else
%      the_vv_ceil = max(vv_ceil);
%    end
%    uu_max = min(u)+du*(the_vv_ceil-1-sgh);
%  else
%    uu_max = max(u);
%  end
%  if uu_min > min(u)
%    uu_min = min(u);
%  end
%  if uu_max < max(u)
%    uu_max = max(u);
%  end
%  ss = uu_min:du:uu_max;
%  vv_ss = ppval(pp, ss);
%  uu2 = uu_min-sgh*du:du:uu_max+sgh*du;
%  vv2 = ppval(pp, uu2);
%  
%  figure
%  hold on
%  plot(u, v);
%  plot(uu, vv);
%  plot(ss, vv_ss, '.');
%  hold off
  
  % Compute sgolay filtered curves
%  [unused g] = sgolay(6, 1+2*sgh);
%  s0 = vv2(1+sgh:length(uu2)-sgh);
%  s1 = zeros(1, length(ss));
%  for i = 1+sgh:length(uu2)-sgh
%    s1(i-sgh) = dot(g(:,2), vv2(i-sgh:i+sgh))/du;
%  end
  
  % Uniformly spaced points along retract
%  uf = interparc(num_pixels, ss, s0, 'spline');
%  nm_u = round(10*uf(:,1))/10;
%  nm_indices = round((nm_u-uu_min)/du)+1;
%  nm = [nm_u s1(nm_indices)'];
%  nm = -1./nm(:,2);
  
  % for each pixel along the extended retract, linear extend in the directions 
  % normal to it and find the nearest-rounded pixels until we reach the edge 
  % of the threshold mask
  for t = 1:num_pixels
    step = sqrt(1/(1+nm(t)^2));
%    pt0 = [u(t) v(t)];
    pt0 = uf(t,:);
    pts = round([pt0(x) pt0(y)]);
    for j = 1:2*b %ceil(1.5*b)
      pt(1) = pt0(1)-j*step;
      pt(2) = pt0(2)-j*nm(t)*step;
      pt = round(pt);
      if pt(2) < 1 || pt(1) < 1
        unused = 0;
      elseif pt(2) > max(v) || pt(1) > max(u)
        unused = 0;
      elseif mask(pt(y),pt(x)) > 0 || j <= d
        pts = [pts; [pt(x) pt(y)]]; % 2 cols, N rows
      end
      pt(1) = pt0(1)+j*step;
      pt(2) = pt0(2)+j*nm(t)*step;
      pt = round(pt);
      if pt(2) < 1 || pt(1) < 1
        unused = 0;
      elseif pt(2) > max(v) || pt(1) > max(u)
        unused = 0;
      elseif mask(pt(y),pt(x)) > 0 || j <= d
        pts = [pts; [pt(x) pt(y)]]; % 2 cols, N rows
      end
    end
    normals = [normals pts];
  end
  
  extend = retract;
  
end
