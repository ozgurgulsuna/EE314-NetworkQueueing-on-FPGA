%*************************************************************************
% Test Problem : 'QOS'
% Description:
%   (1)unconstrained  (2)nonconvex  (3)disconnected
%
% rence : [1] Deb K, Pratap A, Agarwal S, et al. A fast and elitist 
%   multiobjective genetic algorithm NSGA-II[J]. Evolutionary Computation. 
%   2002, 6(2): 182-197.
%*************************************************************************
clc
clear all
options = nsgaopt();                    % create default options structure
options.popsize = 20;                   % populaion size
options.maxGen  = 20;                   % max generation

options.numObj = 2;                     % number of objectives
options.numVar = 8;                     % number of design variables
options.numCons = 6;                    % number of constraints
options.lb = [ 0 0 0 0 0 0 0 0 ];                % lower bound of x
options.ub = [1 1 1 1 1 1 1 1 ];                  % upper bound of x

options.objfun = @TP_QOS_objfun_siraveloss;        % objective function handle


options.plotInterval = 1;              % large interval for efficiency
% options.outputInterval = 10;

% options.refPoints = [0.5 0.5 0.5 0.5 0.5; 0.2 0.2 0.2 0.2 0.8;];
% options.refEpsilon = 0.002;

options.useParallel = 'no';             % parallel computation is non-essential here
options.poolsize = 2;                   % (not use) number of worker processes

result = nsga2(options);                % begin the optimization!


