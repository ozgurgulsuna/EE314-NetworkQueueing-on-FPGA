%% Quality of Service (QoS) Simulator
% TO DO list 
    % pack loss say
    % paket süresi tut

%%
clear
clc


counter = 0;

T_sample_size = 2000 ;  % 200 Seconds of Simulation
T_in_step_per_sec = 4; % Simulation time step is 250 ms
T_time = 0;            % Simulation time
T_out =3;             % Output Data Period 3 Seconds
T_in_mean = 3;         % Input Data Mean Period 3 Seconds
T_in_jitter = 2.7 ;      % Input Data Jitter ±2 Seconds
%t=[0 0 0 0];  

% constants
Wl=[0.1 0.16 0.22 0.3];          % Latency Constant
Wr=[1 1 1 1];          % Reliability Constant

buffer_fullness=[0 0 0 0];  % buffer init

X=[0 0 0 0];             % output order array

f=[0 0 0 0];             % doluluk array
t=[0 0 0 0];            % latency array
d=[0 0 0 0];             % drop count

T_time_array=linspace(0.25,T_sample_size,T_sample_size*T_in_step_per_sec);

for i=1:T_sample_size*T_in_step_per_sec/2
    s(i)=round((T_in_mean*T_in_step_per_sec-T_in_jitter*T_in_step_per_sec+T_in_mean*T_in_step_per_sec)*(sin(i/10)+1)/2+(T_in_mean*T_in_step_per_sec-T_in_jitter*T_in_step_per_sec));
    r(i)=round((T_in_mean*T_in_step_per_sec-T_in_jitter*T_in_step_per_sec+T_in_mean*T_in_step_per_sec)*randi([0,1])+(T_in_mean*T_in_step_per_sec-T_in_jitter*T_in_step_per_sec));

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
stem(T_time_array,T_input_array,'.')
 
for i=1:length(T_time_array)
    switch T_input_array(i)
        case 1
            if buffer_fullness(1)==6
                d(1) = d(1)+1;  
                f(1)=buffer_fullness(1);
                % do nothing
            else
                buffer_fullness(1) = buffer_fullness(1)+1;
                f(1)=buffer_fullness(1);
                %if fullness increased start counter
            end
        case 2 
            if buffer_fullness(2)==6
                d(2) = d(2)+1; 
                f(2)=buffer_fullness(2);
                % do nothing
            else
                buffer_fullness(2) = buffer_fullness(2)+1;
                f(2)=buffer_fullness(2);
                %if fullness increased start counter
            end
        case 3 
            if buffer_fullness(3)==6
                d(3) = d(3)+1; 
                f(3)=buffer_fullness(3);
                % do nothing
            else
                buffer_fullness(3) = buffer_fullness(3)+1;
                f(3)=buffer_fullness(3);
                %if fullness increased start counter
            end
        case 4 
            if buffer_fullness(4)==6
                d(4) = d(4)+1; 
                f(4)=buffer_fullness(4);
                % do nothing
            else
                buffer_fullness(4) = buffer_fullness(4)+1;
                f(4)=buffer_fullness(4);
                %if fullness increased start counter
            end
        otherwise

    end
    X=Wl.*t.*f+Wr.*f; % Evaluate buffer priority

    if mod(i,T_out*T_in_step_per_sec)==0  % its time to get the output
        switch find(X==(max(X)),1,"last")             % burada iki ya da daha fazla aynı değerde max varsa ilkini alıyoruz ama bence sonuncusunu almalıyız
            case 1
                if buffer_fullness(1)==0
                    f(1)=buffer_fullness(1);
                    t(1)=0;
                    % do nothing
                else
                    buffer_fullness(1) = buffer_fullness(1) -1;
                    f(1)=buffer_fullness(1);
                    t(1) = t(1)+1;
                end
            case 2
                if buffer_fullness(2)==0
                    f(2)=buffer_fullness(2);
                    t(2)=0;
                    % do nothing
                else
                    buffer_fullness(2) = buffer_fullness(2) - 1;
                    f(2)=buffer_fullness(2);
                    t(2) = t(2)+1;
                end
            case 3
                if buffer_fullness(3)==0
                    f(3)=buffer_fullness(3);
                    t(3)=0;
                    % do nothing
                else
                    buffer_fullness(3) = buffer_fullness(3) - 1;
                    f(3)=buffer_fullness(3);
                    t(3) = t(3)+1;

                end
            case 4
                if buffer_fullness(4)==0
                    f(4)=buffer_fullness(4);
                    t(4)=0;
                    % do nothing
                else
                    buffer_fullness(4) = buffer_fullness(4) - 1;
                    f(4)=buffer_fullness(4);
                    t(4) = t(4)+1;
                end
        end
%     d;
%     f;
    end


    % after decision has made if decided out buffer is zero then no out.
 
end

