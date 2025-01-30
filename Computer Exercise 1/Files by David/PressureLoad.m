function [f1x,f1y,f2x,f2y]= PressureLoad(x1,y1,x2,y2,h,p)

vec = [x2-x1;y2-y1];

length = sqrt(vec(1)^2+vec(2)^2);

vec = vec/length;

pressureVec = [-vec(2);vec(1)];

force = pressureVec*p*length*h;

f1x = force(1)/2;
f2x = force(1)/2;

f1y = force(2)/2;
f2y = force(2)/2;

% Old function
% fx = - (y2-y1)*h*p;
% f1x = fx/2;
% f2x = fx/2;
% 
% test = atan((y2-y1)/(x2-x1));
% 
% if test<0
%     fy = -(x2-x1)*h*p;
% else
%     fy = (x2-x1)*h*p;
% end
% 
% f1y = fy/2;
% f2y = fy/2;

end