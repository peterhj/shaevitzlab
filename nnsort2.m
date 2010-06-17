%  Copyright (c) 2010, Peter Jin
%  All rights reserved.

%  Redistribution and use in source and binary forms, with or without 
%  modification, are permitted provided that the following conditions are 
%  met:

%      * Redistributions of source code must retain the above copyright 
%        notice, this list of conditions and the following disclaimer.
%      * Redistributions in binary form must reproduce the above copyright 
%        notice, this list of conditions and the following disclaimer in 
%        the documentation and/or other materials provided with the distribution
%        
%  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
%  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
%  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
%  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
%  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
%  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
%  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
%  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
%  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
%  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
%  POSSIBILITY OF SUCH DAMAGE.

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
