function [onthreshold]=LoadEq(loadmag);
%This equation is used to deteremine the on threshold based on the given
%load magnitude. A higher load magnitude will mean a lower on threshold, or
%a higher change a sensor turns on. This was done using a custom written
%sinsodial formula, which can be edited and graphed using the commented
%section at the bottom. 
%Inputs: Loadmagnitude
%Ouput: the on threshold. 

%X axis of the graph is the load magnitude
%Number after output= is the max percent for load threshold. Value of 20
%means max onthreshold .80, so 20% chance for gene to turn on

%Limit to the load magnitude. Set at 60MPA becasue this is the yield point
if loadmag>60
    loadmag=60;
end

%Load magnitude/onthreshold equation
k=.20; 
b=30;
output=20./(1+exp(-1*(k*(loadmag-b))));
onthreshold=1-(output./100);
end
% 
% % % %Can Graph the equation with this below
% x=(1:60);
% k=.20; %Changes the Steepness of the Curve
% b=30 %Moves the Sigmoid Point. Set at 30 because 50% of yield point is 30 MPA. 
% for i=1:60
% y(1,i)=20./(1+exp(-1*(k*(i-b))));
% end
% plot(x,y)