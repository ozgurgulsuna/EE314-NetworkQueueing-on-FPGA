function [y, cons] = TP_ALTUN_objfun(x)
% Objective function : Test problem 'ALTUN'.
%*************************************************************************

y = [0,0];
cons = [];

y(1)=x(1).^2;
y(2)=cos(x(1));
% for i=1:2
%     y(1) = y(1) - 10 * exp(-0.2*sqrt(x(i)^2 + x(i+1)^2) );
% end
% for i=1:3
%     y(2) = y(2) + abs(x(i))^0.8 + 5* sin(x(i)^3);
% end

