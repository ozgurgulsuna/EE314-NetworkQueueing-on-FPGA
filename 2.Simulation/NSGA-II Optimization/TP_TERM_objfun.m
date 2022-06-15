function [y, cons] = TP_TERM_objfun(x)
% Objective function : Test problem 'ALTUN'.
%*************************************************************************

y = [0,0];
cons = [];

y(1)=x(1).^2;
y(2)=cos(x(1));



