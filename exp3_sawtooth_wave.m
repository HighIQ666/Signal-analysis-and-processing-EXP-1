% exp3_sawtooth_wave.m
% 周期锯齿波信号的分解与合成
% f(t) = 0.5*mod(t,4) - 1，周期 T=4

clear; clc; close all;

T = 4;                          % 周期
omega0 = 2*pi/T;                % 基波角频率
t = linspace(0, 2*T, 1000);     % 时间向量（两个周期）

% 原始锯齿波
f_original = 0.5 * mod(t, T) - 1;

% 不同谐波次数合成
harmonics = [1, 3, 5, 7, 11, 21];

figure;
for idx = 1:length(harmonics)
    N_harmonic = harmonics(idx);
    
    % 计算傅里叶系数 bn（数值积分）
    dt_int = T/10000;  % 积分步长
    bn = zeros(1, N_harmonic);
    for n = 1:N_harmonic
        t_int = 0:dt_int:T;
        f_int = 0.5 * mod(t_int, T) - 1;
        integrand = f_int .* sin(n * omega0 * t_int);
        bn(n) = (2/T) * trapz(t_int, integrand);
    end
    
    % 合成信号
    f_synth = zeros(size(t));
    for n = 1:N_harmonic
        f_synth = f_synth + bn(n) * sin(n * omega0 * t);
    end
    
    % 绘图
    subplot(2,3,idx);
    plot(t, f_original, 'b-', 'LineWidth', 1.2); hold on;
    plot(t, f_synth, 'r--', 'LineWidth', 1);
    xlabel('t (s)'); ylabel('f(t)');
    title(['合成谐波次数 ≤ ', num2str(N_harmonic)]);
    legend('原始锯齿波', '合成波形', 'Location', 'best');
    grid on;
    ylim([-1.5, 1.5]);
end

sgtitle('周期锯齿波的分解与合成');