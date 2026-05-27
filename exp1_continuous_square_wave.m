% exp1_continuous_square_wave.m
% 连续周期方波信号的分解与合成

clear; clc; close all;

% 参数设置
T = 4;                  % 周期
t = linspace(0, 2*T, 1000);  % 时间向量

% 生成原始方波
f_original = double(mod(t, T) < T/2) * (-1) + double(mod(t, T) >= T/2) * 1;

% 不同谐波次数合成
harmonics = [1 3 5 7 11 21];

figure;
for idx = 1:length(harmonics)
    N = harmonics(idx);
    
    % 计算合成信号
    omega0 = 2*pi/T;
    f_synth = zeros(size(t));
    for n = 1:2:N  % 仅奇次谐波
        bn = -4/(n*pi);
        f_synth = f_synth + bn * sin(n*omega0*t);
    end
    
    % 绘图
    subplot(2,3,idx);
    plot(t, f_original, 'b-', 'LineWidth', 1.2); hold on;
    plot(t, f_synth, 'r--', 'LineWidth', 1);
    xlabel('t (s)'); ylabel('f(t)');
    title(['合成谐波次数 ≤ ', num2str(N)]);
    legend('原始方波', '合成波形', 'Location', 'best');
    grid on;
    ylim([-1.5, 1.5]);
end

sgtitle('连续周期方波信号的分解与合成');