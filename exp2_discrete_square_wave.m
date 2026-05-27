% exp2_discrete_square_wave.m
% 离散方波信号的DFS分解与合成
% 对连续方波以 T/60 和 T/120 采样，分析30次、60次谐波合成效果

clear; clc; close all;

T = 4;                      % 连续方波周期
N1 = 60;                    % 采样点数1
N2 = 120;                   % 采样点数2

% 生成离散时间序列（不包含终点）
t1 = linspace(0, T, N1+1); t1 = t1(1:end-1);
t2 = linspace(0, T, N2+1); t2 = t2(1:end-1);

% 生成离散方波信号（幅值 -1 和 1）
x1 = double(mod(t1, T) >= T/2) - double(mod(t1, T) < T/2);
x2 = double(mod(t2, T) >= T/2) - double(mod(t2, T) < T/2);

% ========== DFS计算（采样间隔 T/60） ==========
N = N1;
x = x1;
% 前向DFS
X1 = zeros(1, N);
for k = 0:N-1
    sum_val = 0;
    for n = 0:N-1
        sum_val = sum_val + x(n+1) * exp(-1j * 2*pi * k * n / N);
    end
    X1(k+1) = sum_val / N;
end
mag1 = abs(X1);

% IDFS合成（30次谐波）
M = 30;
X_partial = zeros(1, N);
M = min(M, N);
X_partial(1:M) = X1(1:M);
x1_30 = zeros(1, N);
for n = 0:N-1
    sum_val = 0;
    for k = 0:N-1
        sum_val = sum_val + X_partial(k+1) * exp(1j * 2*pi * k * n / N);
    end
    x1_30(n+1) = real(sum_val);
end

% IDFS合成（60次谐波）
M = 60;
X_partial = zeros(1, N);
M = min(M, N);
X_partial(1:M) = X1(1:M);
x1_60 = zeros(1, N);
for n = 0:N-1
    sum_val = 0;
    for k = 0:N-1
        sum_val = sum_val + X_partial(k+1) * exp(1j * 2*pi * k * n / N);
    end
    x1_60(n+1) = real(sum_val);
end

% 包络线计算（理论连续方波傅里叶系数幅度）
k_axis = 0:N-1;
envelope1 = zeros(1, N);
for idx = 1:N
    n = k_axis(idx);
    if n == 0
        envelope1(idx) = 0;
    elseif mod(n,2) == 1
        envelope1(idx) = 4/(pi * n);
    else
        envelope1(idx) = 0;
    end
end

% ========== DFS计算（采样间隔 T/120） ==========
N = N2;
x = x2;
% 前向DFS
X2 = zeros(1, N);
for k = 0:N-1
    sum_val = 0;
    for n = 0:N-1
        sum_val = sum_val + x(n+1) * exp(-1j * 2*pi * k * n / N);
    end
    X2(k+1) = sum_val / N;
end
mag2 = abs(X2);

% IDFS合成（30次谐波）
M = 30;
X_partial = zeros(1, N);
M = min(M, N);
X_partial(1:M) = X2(1:M);
x2_30 = zeros(1, N);
for n = 0:N-1
    sum_val = 0;
    for k = 0:N-1
        sum_val = sum_val + X_partial(k+1) * exp(1j * 2*pi * k * n / N);
    end
    x2_30(n+1) = real(sum_val);
end

% IDFS合成（60次谐波）
M = 60;
X_partial = zeros(1, N);
M = min(M, N);
X_partial(1:M) = X2(1:M);
x2_60 = zeros(1, N);
for n = 0:N-1
    sum_val = 0;
    for k = 0:N-1
        sum_val = sum_val + X_partial(k+1) * exp(1j * 2*pi * k * n / N);
    end
    x2_60(n+1) = real(sum_val);
end

% 包络线计算
k_axis2 = 0:N-1;
envelope2 = zeros(1, N);
for idx = 1:N
    n = k_axis2(idx);
    if n == 0
        envelope2(idx) = 0;
    elseif mod(n,2) == 1
        envelope2(idx) = 4/(pi * n);
    else
        envelope2(idx) = 0;
    end
end

% ========== 绘图（采样间隔 T/60） ==========
figure;
subplot(2,2,1);
stem(t1, x1, 'filled'); 
xlabel('时间 (s)'); ylabel('x(n)');
title('离散方波 (采样间隔 T/60)'); 
grid on;

subplot(2,2,2);
stem(k_axis, mag1, 'b'); hold on;
plot(k_axis, envelope1, 'r-', 'LineWidth', 1.5);
xlabel('谐波次数 k'); ylabel('|X(k)|'); 
title('幅度谱与包络线');
legend('DFS幅度', '理论包络'); 
grid on;

subplot(2,2,3);
stem(t1, x1_30, 'filled'); 
xlabel('时间 (s)'); ylabel('x_{30}(n)');
title('30次谐波合成信号'); 
grid on;

subplot(2,2,4);
stem(t1, x1_60, 'filled'); 
xlabel('时间 (s)'); ylabel('x_{60}(n)');
title('60次谐波合成信号'); 
grid on;

sgtitle('采样间隔 T/60 (N=60)');

% ========== 绘图（采样间隔 T/120） ==========
figure;
subplot(2,2,1);
stem(t2, x2, 'filled'); 
xlabel('时间 (s)'); ylabel('x(n)');
title('离散方波 (采样间隔 T/120)'); 
grid on;

subplot(2,2,2);
stem(k_axis2, mag2, 'b'); hold on;
plot(k_axis2, envelope2, 'r-', 'LineWidth', 1.5);
xlabel('谐波次数 k'); ylabel('|X(k)|'); 
title('幅度谱与包络线');
legend('DFS幅度', '理论包络'); 
grid on;

subplot(2,2,3);
stem(t2, x2_30, 'filled'); 
xlabel('时间 (s)'); ylabel('x_{30}(n)');
title('30次谐波合成信号'); 
grid on;

subplot(2,2,4);
stem(t2, x2_60, 'filled'); 
xlabel('时间 (s)'); ylabel('x_{60}(n)');
title('60次谐波合成信号'); 
grid on;

sgtitle('采样间隔 T/120 (N=120)');