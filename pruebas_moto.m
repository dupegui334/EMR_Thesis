close all;
clc;
s = tf('s');

%% Constants
V_bat=79;%Battery voltage [V]
L_m = 0.000164243;%Phase inductance [H]
n = 23;%Poles of the BLDC
Radio = 0.2959;%Radio of the wheel [m]
Ke_m = 0.399;%Speed constante [V/rad/s]
Kit_m = 1.0;%Torque constant [Nm/A]
R_m = 0.04;%Phase resistance [ohm]
m = 285; %Weight of bike and user [Kg]
eff_bldc = 0.3149 % BLDC efficience
eff_inv = 0.99;% inverter efficience

%% Mass transfer function Speed/Force
Gs_1 = 1/(m*s);
%% Mass transfer function closed loop
figure
step(feedback(Gs_1,1))
title('Mass speed closed loop')
%% PI constants for the speed control
kp_1 = 992;
ki_1 = 979.7530;
%% PI applied to plant (mass)
pid_1 = ki_1/s+kp_1;
Gs_1_c = feedback(Gs_1*pid_1,1)
figure
step(Gs_1_c)
title('Mass speed control PI')


%% BLDC Transfer function Current/Voltage
Gs_2 = 1/(R_m + L_m*s);
%% BLDC transfer function closed loop
Gs_2_lc = feedback(Gs_2,1);
figure
step(Gs_2_lc)
title('BLDC Current closed loop');
%% PI constants for the current control
kp_2 = 3.6270364;
ki_2 = 30178.107;

%% PI applied to the plant
pid_2 = kp_2+1/(s*ki_2);
G2_c = feedback (Gs_2*pid_2,1);
figure
step(G2_c)
title('Control corriente motor');

%% ICE parameters using JORGE CORDOBA and LAURA MORENO Mapping EXCEL
ruta_ICE = 'BSFCBOXERCT.xlsx';
%ruta_ICE = 'D:\Users\Administrador\Desktop\Talleres EIA\8 semestre\STG\matlab\BSFCBOXERCT.xlsx';
Tqcom=xlsread(ruta_ICE,'SIMULINK','B5:B18','basic');
Tqcom=transpose(Tqcom);
Tqmax=xlsread(ruta_ICE,'SIMULINK','B18','basic');
Spcom=xlsread(ruta_ICE,'SIMULINK','C4:AA4','basic');
Torque=xlsread(ruta_ICE,'SIMULINK','C5:AA18','basic');
Aire=xlsread(ruta_ICE,'SIMULINK','C62:AA75','basic');
Comb=xlsread(ruta_ICE,'SIMULINK','C43:AA56','basic');
BSFC=xlsread(ruta_ICE,'SIMULINK','C24:AA37','basic');
Temp=xlsread(ruta_ICE,'SIMULINK','C81:AA94','basic');
Ceros=xlsread(ruta_ICE,'SIMULINK','C100:AA113','basic');

masa_cilindro = 1;                          %1kg
radio_cilindro = 1.27e-2;                   %1 pulgada de diametro
Jice = 0.5*masa_cilindro*radio_cilindro;    

disp('Now go to Simulink and execute only Gear calculator Area and run this code again') 
time_simulink = out.tout;
gear = out.gear;
gear_simulink = [time_simulink,gear];

% print('-sSimulink_images','-dtiff','Simulink_images.png')