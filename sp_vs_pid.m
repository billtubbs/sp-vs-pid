% Evaluation of Smith Predictor analysis by IPCOS
% See this blog article, published
%  - https://blog.ipcos.com/blog/advanced-process-control-pid-tuning-is-the-fiout.rst-step-3
%     Published: published on July 28 2022
%     Accessed: July 3 2023
%

clear all

% Name of Simulink model file
sim_model = "sp_sim";

% Actual process
Kp = 5;
theta = 10;
T1 = 5;
s = tf('s');
Gp = Kp * exp(-theta*s) / (T1*s + 1);

% Process model
Km = Kp;
theta_m = theta;
T1m = T1;

% Standard PI design rules
% Kc = 1/Km * T1m/(T1m + theta_m);

% Design PI controller - SIMC Tuning Rule
PI = struct;
PI.Kc = 0.083;
PI.Ti = 8.3;

% Design PID controller - SIMC Tuning Rule
PID = struct;
PID.Kc = 0.067;
PID.Ti = 5;
PID.Td = 3.33;
PID.Tf = 0;

% Design Smith predictor
SP = struct;
SP.Kc = 0.25;
SP.Ti = 376/60;
SP.Td = 0;
SP.Tf = 0;

% Run simulation
Ts = 1;
t_stop = 100;
out = sim(sim_model, 'StopTime', string(t_stop));


%% Plots

figure(1)

subplot(411);
plot(out.y1.time,out.y1.data,out.y2.time,out.y2.data, ...
    out.y3.time,out.y3.data,'LineWidth',2)
hold on; plot(out.r.time,out.r.data,'k--'); hold off
ylim([-0.2 2.2])
set(gca, 'TickLabelInterpreter','latex')
title('Responses with PID and Smith Predictor','Interpreter','latex');
ylabel('$r(t),y(t)$','Interpreter','latex');
xlabel('Time (s)','Interpreter','latex');
legend('$y_1$','$y_2$','$y_3$','$r$','Interpreter','latex');
grid on

subplot(412);
plot(out.u1.time,out.u1.data,out.u2.time,out.u2.data, ...
    out.u2.time,out.u2.data,'LineWidth',2)
set(gca, 'TickLabelInterpreter','latex')
ylim([-0.5 1]);
ylabel('$u(t)$','Interpreter','latex');
xlabel('Time (s)','Interpreter','latex');
legend('$u_1$','$u_2$','$u_3$','Interpreter','latex');
grid on

subplot(413);
plot(out.e1.time,out.e1.data,out.e2.time,out.e2.data,out.em.time, ...
    out.em.data,'LineWidth',2)
set(gca, 'TickLabelInterpreter','latex')
ylim([-1 2]);
ylabel('$u(t)$','Interpreter','latex');
xlabel('Ttime (s)','Interpreter','latex');
legend('$e_1$','$e_2$','$e_3$','$e_m$','Interpreter','latex');
grid on

subplot(414);
plot(out.yms.time,out.yms.data,'LineWidth',2)
hold on; plot(out.rs.time,out.rs.data,'k--'); hold off
set(gca, 'TickLabelInterpreter','latex')
ylim([-1 2]);
ylabel('$u(t)$','Interpreter','latex');
xlabel('Time (s)','Interpreter','latex');
legend('$y_{ms}$','$r_s$','Interpreter','latex');
grid on

set(gcf,'Position',[100 100 500 700])
saveas(gcf,'sp_sim_respplots.png')
