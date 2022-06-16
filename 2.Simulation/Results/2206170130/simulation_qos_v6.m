%% Quality of Service (QoS) Simulator %%

clear all;
clc ; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T_sample_size = 10000;      % Simulation Duration in Seconds
T_in_step_per_sec = 4;      % Simulation time step is 250 ms
T_time = 0;                 % Simulation time
T_out = 3 ;                 % Output Data Period 5 Seconds
T_in_mean = 2;              % Input Data Mean Period 3 Seconds
T_in_jitter = 4;          % Input Data Jitter ±3 Seconds 

Wl=[0.743655	0.544386	0.455639	0.147393]/20;      % Latency Weight Constant  
Wr=[0.171065	0.319829	0.590425	0.927282];              % Reliability Weight Constant
k = 0 ;                      % Drop penalty
% X = Wl.*t+Wr.*(f.^2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

counter = 0;


buffer_fullness=[0 0 0 0];  % buffer init

read_count=[0 0 0 0];

X=[0 0 0 0];             % output order array

f=[0 0 0 0];             % doluluk array
t=[0 0 0 0];            % latency array
d=[0 0 0 0];             % drop count
T=[0 0 0 0];             % Total latency

% all_data=[0 0 0 0 ;
%           0 0 0 0 ;
%           0 0 0 0 ;
%           0 0 0 0 ;
%           0 0 0 0 ;
%           0 0 0 0 ;];

all_data = zeros(6,4);
latency = [0 0 0 0];

T_time_array=linspace(0.25,T_sample_size,T_sample_size*T_in_step_per_sec);

% Period Randomization
for i=1:T_sample_size*T_in_step_per_sec/2
    s(i)=round((T_in_jitter*T_in_step_per_sec)*(sin(i/10))+(T_in_mean*T_in_step_per_sec));
    r(i)=round((T_in_jitter*T_in_step_per_sec)*(randi([-1,1]))+(T_in_mean*T_in_step_per_sec));
    %r(i)=round((T_in_mean*T_in_step_per_sec-T_in_jitter*T_in_step_per_sec+T_in_mean*T_in_step_per_sec)*randi([0,1])+(T_in_mean*T_in_step_per_sec-T_in_jitter*T_in_step_per_sec));
end

% figure;
% plot(s);
% figure;
% plot(r);
% mean(r);
% mean(s);
   
T_input_array=zeros(1,800);

% timewise data input
for i=1:T_sample_size*T_in_step_per_sec/4
    counter = counter+(s(i));
    T_input_array(counter)=randi([1,4]);  
end
counter=0;

% Array limit
T_input_array = T_input_array(1:T_sample_size*T_in_step_per_sec);

% Stem plot of timewise data input
% stem(T_time_array,T_input_array,'.')
 
for i=1:length(T_time_array)
    t=sum(all_data);
    switch T_input_array(i)
        case 1
            if buffer_fullness(1)==6
                d(1) = d(1)+1;  
                f(1)=buffer_fullness(1);
                T(1)=T(1)+k*max(all_data(:,1)); 
                all_data(find(all_data(:,1)==max(all_data(:,1)),1,"first"),1)=1; % remove the oldest data
            else
                buffer_fullness(1) = buffer_fullness(1)+1;
                f(1)=buffer_fullness(1);
                all_data(find(all_data(:,1)==min(all_data(:,1)),1,"first"),1)=1; % add new to empty slot
                %if fullness increased start counter
            end
        case 2
            if buffer_fullness(2)==6
                d(2) = d(2)+1; 
                f(2)=buffer_fullness(2);
                T(2)=T(2)+k*max(all_data(:,2)); 
                all_data(find(all_data(:,2)==max(all_data(:,2)),1,"first"),2)=1; % remove the oldest data

                % do nothing
            else
                buffer_fullness(2) = buffer_fullness(2)+1;
                f(2)=buffer_fullness(2);
                all_data(find(all_data(:,2)==min(all_data(:,2)),1,"first"),2)=1; % add new to empty slot
                %if fullness increased start counter
            end
        case 3 
            if buffer_fullness(3)==6
                d(3) = d(3)+1; 
                f(3)=buffer_fullness(3);
                T(3)=T(3)+k*max(all_data(:,3)); 
                all_data(find(all_data(:,3)==max(all_data(:,3)),1,"first"),3)=1; % remove the oldest data
                % do nothing
            else
                buffer_fullness(3) = buffer_fullness(3)+1;
                f(3)=buffer_fullness(3);
                all_data(find(all_data(:,3)==min(all_data(:,3)),1,"first"),3)=1; % add new to empty slot

                %if fullness increased start counter
            end
        case 4 
            if buffer_fullness(4)==6
                d(4) = d(4)+1; 
                f(4)=buffer_fullness(4);
                T(4)=T(4)+k*max(all_data(:,4)); 
                all_data(find(all_data(:,4)==max(all_data(:,4)),1,"first"),4)=1; % remove the oldest data
                % do nothing
            else
                buffer_fullness(4) = buffer_fullness(4)+1;
                f(4)=buffer_fullness(4);
                all_data(find(all_data(:,4)==min(all_data(:,4)),1,"first"),4)=1; % add new to empty slot
                %if fullness increased start counter
            end
        otherwise
    end
    X=Wl.*t+Wr.*(f.^2); % Evaluate buffer priority
    if mod(i,T_out*T_in_step_per_sec)==0  % its time to get the output
        switch find(X==(max(X)),1,"last")             % burada iki ya da daha fazla aynı değerde max varsa ilkini alıyoruz ama bence sonuncusunu almalıyız
            case 1
                if buffer_fullness(1)==0
                    f(1)=buffer_fullness(1);
                    % do nothing
                else
                    buffer_fullness(1) = buffer_fullness(1) -1;
                    f(1)=buffer_fullness(1);
                    read_count(1) = read_count(1)+1; 
                    T(1)=T(1)+max(all_data(:,1));                               % export the oldest data and save it to sum
                    all_data(find(all_data(:,1)==max(all_data(:,1)),1,"first"),1)=0; % remove that data 

                end
            case 2
                if buffer_fullness(2)==0
                    f(2)=buffer_fullness(2);
                    % do nothing
                else
                    buffer_fullness(2) = buffer_fullness(2) - 1;
                    f(2)=buffer_fullness(2);
                    read_count(2) = read_count(2)+1;
                    T(2)=T(2)+max(all_data(:,2));                               % export the oldest data and save it to sum
                    all_data(find(all_data(:,2)==max(all_data(:,2)),1,"first"),2)=0; % remove that data 

                end
            case 3
                if buffer_fullness(3)==0
                    f(3)=buffer_fullness(3);
                    % do nothing
                else
                    buffer_fullness(3) = buffer_fullness(3) - 1;
                    f(3)=buffer_fullness(3);
                    read_count(3) = read_count(3)+1;
                    T(3)=T(3)+max(all_data(:,3));                               % export the oldest data and save it to sum
                    all_data(find(all_data(:,3)==max(all_data(:,3)),1,"first"),3)=0; % remove that data 

                end
            case 4
              if buffer_fullness(4)==0
                    f(4)=buffer_fullness(4);
                    % do nothing
                else
                    buffer_fullness(4) = buffer_fullness(4) - 1;
                    f(4)=buffer_fullness(4);
                    read_count(4) = read_count(4)+1;
                    T(4)=T(4)+max(all_data(:,4));                               % export the oldest data and save it to sum
                    all_data(find(all_data(:,4)==max(all_data(:,4)),1,"first"),4)=0; % remove that data 
   
              end
        end
      d;
      f;
      t;

    end
      buffer_fullness;
      all_data;
      X;
      f;
s_all_data = size(all_data);
all_data=all_data+ones(s_all_data(1),s_all_data(2)).*fillmissing((all_data./all_data), 'constant', 0); %% add 1 to nonempty indices
all_data;
end

d_pi=d./(read_count+d);  % drop per input
a=T./(read_count+d);     % average latency per output

% 4.62536598665238	2.64147390882448	2.27016506027572	1.66617193587623	2.81002645322608	-1.82470119865187	2.69544383651092	2.54335164446693

