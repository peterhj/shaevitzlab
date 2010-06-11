function [normals extend] = KymoNormals(retract, ends, mask, sgh, b)
  
  normals = {};
  
  % Quick and dirty, canonical (u,v) coordinates
%  [ry rx] = find(retract > 0);
%  [unused freq] = mode(ry);
%  if max(freq) > 1
%    u = rx;
%    v = ry;
%    x = 1;
%    y = 2;
%  else
%    u = ry;
%    v = rx;
%    x = 2;
%    y = 1;
%  end
  
  x = 1; y = 2;
  [v u] = find(retract > 0);
  num_pixels = length(u);
  
  % 2-pass path interpolation
  % 1. Sort points by nearest neighbor and interpolate
  % 2. Linearly extend the endpoints and interpolate
  
  % 1. Nearest-neighbor sort, starting at an endpoint
  end_u = find(u == ends(1,1));
  end_v = find(v == ends(1,2));
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
  
  % 2. Extrapolate from the ends to the poles and find the total pixel count
  head_pt = uf(1,:);
  tail_pt = uf(end,:);
  head_df = uf(1,:)-uf(2,:);
  tail_df = uf(end,:)-uf(end-1,:);
  h_scale = 1/norm(head_df);%1/(1+(head_df(2)/head_df(1))^2);
  t_scale = 1/norm(tail_df);%1/(1+(tail_df(2)/tail_df(1))^2);
  
  head_pts = [];
  tail_pts = [];
  head_pt = round(head_pt);
  tail_pt = round(tail_pt);
  last_head_pt = head_pt;
  last_tail_pt = tail_pt;
  [v_bound u_bound] = size(mask);
  
  for i = 1:20
    pt = round(head_pt+i*h_scale*head_df);
    if pt(2) < 1 || pt(1) < 1
      unused = 0;
    elseif pt(2) > v_bound || pt(1) > u_bound
      unused = 0;
    elseif mask(pt(2),pt(1)) > 0
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
    pt = round(tail_pt+i*t_scale*tail_df);
    if pt(2) < 1 || pt(1) < 1
      unused = 0;
    elseif pt(2) > v_bound || pt(1) > u_bound
      unused = 0;
    elseif mask(pt(2),pt(1)) > 0
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
  
  uf = interparc(ceil(num_pixels/15), u, v, 'linear');
  uf = interparc(num_pixels, uf(:,1), uf(:,2), 'spline');
  df = diff(uf(:,2))./diff(uf(:,1));
  df = [df; df(end)];
  nm = -1./df;
  
  figure
  hold on
  plot(u, v);
  plot(uf(:,1), uf(:,2));
  hold off
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
  
  for t = 1:num_pixels
    step = sqrt(1/(1+nm(t)^2));
%    pt0 = [u(t) v(t)];
    pt0 = uf(t,:);
    pts = round([pt0(x) pt0(y)]);
    for j = 1:ceil(1.5*b)
      pt(1) = pt0(1)-j*step;
      pt(2) = pt0(2)-j*nm(t)*step;
      pt = round(pt);
      if pt(2) < 1 || pt(1) < 1
        unused = 0;
      elseif pt(2) > max(v) || pt(1) > max(u)
        unused = 0;
      elseif mask(pt(y),pt(x)) > 0
        pts = [pts; [pt(x) pt(y)]]; % 2 cols, N rows
      end
      pt(1) = pt0(1)+j*step;
      pt(2) = pt0(2)+j*nm(t)*step;
      pt = round(pt);
      if pt(2) < 1 || pt(1) < 1
        unused = 0;
      elseif pt(2) > max(v) || pt(1) > max(u)
        unused = 0;
      elseif mask(pt(y),pt(x)) > 0
        pts = [pts; [pt(x) pt(y)]]; % 2 cols, N rows
      end
    end
    normals = [normals pts];
  end
  
  extend = retract;
  
end
