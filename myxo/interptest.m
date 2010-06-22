function interptest()
  
  theta = sort(rand(15,1))*2*pi;
  theta(end+1) = theta(1);
  px = cos(theta);
  py = sin(theta);
  pt = interparc(100,px,py,'spline');
  figure
  plot(pt(:,1),pt(:,2),'.');
  axis equal
  
end
