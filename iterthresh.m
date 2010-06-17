%  Copyright (c) 2010, Mingzhai Sun
%  All rights reserved.
%  
%  Redistribution and use in source and binary forms, with or without 
%  modification, are permitted provided that the following conditions are 
%  met:
%  
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
    done = abs(T-Tnext) < 1e-3;
    T = Tnext;
  end
  %mask2d = double(data2d(y+1:y+height,x+1:x+width)).*double(data2d(y+1:y+height,x+1:x+width) > T);
  mask2d = imIn >= T;
end
