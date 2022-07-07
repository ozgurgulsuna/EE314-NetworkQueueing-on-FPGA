clc
clear

load('D:\2021-22\Okul\Dersler\EE314\TermProject\2.Simulation\Results\2206201600\obj.mat')
figure;

set(gcf,'Position',[0 0 1000 650]);

for i=1:length(obj(:,1))
    plot3(obj(i,1),obj(i,2),obj(i,3),"ko",'MarkerFaceColor','k','MarkerSize',4)
    hold on
%     xlim([0 200])
    set(gca,'xscale','log')
%     ylim([0 200])
    set(gca,'yscale','log')
    zlim([min(obj(:,3)) max(obj(:,3))])
    grid on
end
hold on
[Xs,Ys] = meshgrid(1:0.2:10,1:0.2:10);
Zs= 0.0006629.*(Xs-5.693).^2+0.0002484.*(Ys-9.689).^2+0.9492;
Xs=exp(Xs);
Ys=exp(Ys);
surf(Xs,Ys,Zs,'EdgeColor','interp','FaceAlpha',0.9)

xlim([0 10^3])
ylim([0 10^4])
zlim([0.946 0.982])


set(0,'defaulttextinterpreter','latex')
set(gca, 'YGrid', 'on', 'XGrid', 'on')
xlabel("Latency Requirement",'FontSize',22);
ylabel("Reliability Requirement",'FontSize',22);
zlabel("Minimal Drop Requirement",'FontSize',22);
title("\bf{Pareto Front}",'FontSize',24);

%%

%%
for i=1:length(obj(:,1))
    x(i,1)=log(obj(i,1));
    y(i,1)=log(obj(i,2));
    z(i,1)=(obj(i,3));
end
% 
% unlog=cat(2,x,y);
% unlog=cat(2,unlog,z);
% 
% obj_s=unlog;

% H = [1 2 1; 1 1 1; -1 -2 -1];
% Y = filter2(H,unlog,'full');
% mesh(Y)

% 
% obj_s=filter2(unlog,'gaussian');

% for i=1:length(obj_s(:,1))
%     x(i,1)=obj_s(i,1);
%     y(i,1)=obj_s(i,2);
%     z(i,1)=obj_s(i,3);
% end

xlin = linspace(min(x),max(x),100);
ylin = linspace(min(y),max(y),100);

[X,Y] = meshgrid(xlin,ylin);

f = scatteredInterpolant(x,y,z);
Z = griddata(x,y,z,X,Y,'v4');
Z = f(X,Y);


figure
mesh(X,Y,Z) %interpolated

axis tight; hold on
plot3(x,y,z,'.','MarkerSize',15) %nonuniform
grid on

%%

x = 15*rand(150,1); 
y = sin(x) + 0.5*(rand(size(x))-0.5);
y(ceil(length(x)*rand(2,1))) = 3;

yy1 = smooth(x,y,0.1,'loess');
yy2 = smooth(x,y,0.1,'rloess');


%%

figure
colormap hsv
surf(X,Y,Z,'FaceColor','interp',...
   'EdgeColor','none',...
   'FaceLighting','gouraud')
daspect([5 5 1])
axis tight
view(-50,30)
camlight left

%%
data_s(1,i)=x(i)
data_s(2,i)=y(i)
data_s(3,i)=z(i)