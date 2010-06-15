function [contour retract ends] = KymoRetract(the_image)
  
  % Get morphological objects
  contour = edge(the_image);
  retract = bwmorph(the_image, 'thin', Inf);
  endpoints = bwmorph(retract, 'endpoints');
  [end_r end_c] = find(endpoints>0);
  num_endpoints = size(end_r);
  num_endpoints = num_endpoints(1);
  assert(num_endpoints == 2);
  
%  grid_dim = size(the_image);
%  [row col] = find(retract > 0);
%  x = min(col):max(col);
%  y = min(row):max(row);
  
%  pole_coords = zeros(2,2);
%  good_pole_coords = zeros(2,2);
  
  % Method 1: Find nearest poles on the contour from each endpoint.
%  norms = zeros(grid_dim(1), grid_dim(2));
%  for i = 1:2
%    g_norm = Inf;
%    for j = 1:grid_dim(1)
%      for k = 1:grid_dim(2)
%        if contour(j,k) > 0
%          norms(j,k) = norm([j,k]-[end_r(i) end_c(i)]);
%          if norms(j,k) < g_norm
%            g_norm = norms(j,k);
%            pole_coords(i,:) = [k,j];
%          end
%        end
%      end
%    end
%  end
  
  % Method 2: Find points on the contour outside of the extended bounding box 
  % of the retract, then isolate the connected components of the contour.
%  for i = 1:2
%    num_d = [0 0 0 0];
%    contour_p = find(contour>0);
%    % TODO also bound the unconstrained coord by +/-10?
%    [p1r p1c] = find(contour(1:end_r(i)-2,:));
%    [p2r p2c] = find(contour(end_r(i)+2:grid_dim(1),:));
%    p2r = p2r + end_r(i)+1;
%    [p3r p3c] = find(contour(:,1:end_c(i)-2));
%    [p4r p4c] = find(contour(:,end_c(i)+2:grid_dim(2)));
%    p4c = p4c + end_c(i)+1;
%    pr = {p1r,p2r,p3r,p4r};
%    pc = {p1c,p2c,p3c,p4c};
%    num_d(1) = length(find(contour(1:end_r(i)-2,:)));
%    num_d(2) = length(find(contour(end_r(i)+2:grid_dim(1),:)));
%    num_d(3) = length(find(contour(:,1:end_c(i)-2)));
%    num_d(4) = length(find(contour(:,end_c(i)+2:grid_dim(2))));
%    num_least = min(num_d);
%    d = find(num_d == num_least);
%    
%    p_rows = cell2mat(pr(d));
%    p_cols = cell2mat(pc(d));
%    
%    d_norm = 0;
%    for j = 1:num_d(d)
%      this_norm = norm([p_rows(j) p_cols(j)]-[end_r(i) end_c(i)]);
%      if this_norm > d_norm
%        d_norm = this_norm;
%        good_pole_coords(i,:) = [p_cols(j) p_rows(j)];
%      end
%    end
%  end
  
  % extend retract to poles
%  a = [end_c(1) end_r(1)];
%  b = good_pole_coords(1,:);
%  [myline mycoords outmat X1 Y1] = bresenham(the_image, [a;b], 0);
%  a = [end_c(2) end_r(2)];
%  b = good_pole_coords(2,:);
%  [myline mycoords outmat X2 Y2] = bresenham(the_image, [a;b], 0);
%  [retract_r retract_c] = find(retract>0);
%  retract_color = retract(retract_r(1),retract_c(1));
%  for i = 1:length(X1)
%    retract(X1(i),Y1(i)) = retract_color;
%  end
%  for i = 1:length(X2)
%    retract(X2(i),Y2(i)) = retract_color;
%  end
%  retract = bwmorph(retract, 'close');
%  retract = bwmorph(retract, 'thin', Inf);
  
  % interpolation last
%  [xi yi] = meshgrid(0.5:0.5:grid_dim(2), 0.5:0.5:grid_dim(1));
%  fine_retract = interp2(x, y, retract(y,x), xi, yi, 'linear');
%  fine_contour = interp2(contour, xi, yi, 'linear');
  
  ends = [end_c end_r];
  
end
