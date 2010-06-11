function [mask2d] = KymoThreshold(imIn);
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
    g = imIn>=T;
    Tnext = 0.5*(mean(imIn(g))+mean(imIn(~g)));
    done = abs(T-Tnext)<1e-3;
    T = Tnext;
  end
  %mask2d = double(data2d(y+1:y+height,x+1:x+width)).*double(data2d(y+1:y+height,x+1:x+width) > T);
  mask2d = imIn >= T;
end
