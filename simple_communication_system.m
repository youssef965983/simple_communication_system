clear;
% fS SAMPLE FREQUANCY

% Read input sound file
[file, path] = uigetfile('*.wav;*.mpeg;*.mp3;*.ogg', 'Select an audio file');
[x, Fs] = audioread(fullfile(path, file));
x = x(:,1)';
% Play sound file
sound(x, Fs);
pause(length(x)/Fs); 

% Plot sound file in time domain
t = linspace(0, length(x)/Fs, length(x)); 
figure;
subplot(2,1,1);
plot(t, x);
xlabel('Time (s)');
ylabel('Amplitude');
title('pure signal');

% Plot sound file in frequency domain
X = fftshift(fft(x));
f = linspace(-Fs/2, Fs/2 , length(X));
subplot(2,1,2);
plot(f, abs(X));
xlabel('Frequency (Hz)');
ylabel('Magnitude');

% Choose impulse response for channel
fprintf(' Enter the impulse response for channel \n1. Delta function\n2. Exponential function with W=5000\n3. Exponential function with W=1000\n4. Custom impulse response\n ');
type=input('');

switch type
    case 1
        impulse_response = 1;
    
    case 2
        impulse_response = exp(-2*pi*5000*t);
        
    case 3
        impulse_response = exp(-2*pi*1000*t);
        
    case 4
        impulse_response = [2 zeros(1, Fs-2) 0.5];
        
end

% impulse_response = 1; % Delta function
% impulse_response = exp(-2*pi*5000*t); % Exponential function
% impulse_response = exp(-2*pi*1000*t); % Exponential function
% impulse_response = [2 zeros(1, Fs-2) 0.5]; % Custom impulse response

% Pass sound signal over channel
y = conv(x, impulse_response);


% Plot sound file in time domain
figure;
subplot(2,1,1);
t = linspace(0, length(y)/Fs, length(y));
plot(t, y);
xlabel('Time (s)');
ylabel('Amplitude');
title('signal after the channel');

% Plot sound file in frequency domain
Y = fftshift(fft(y));
f = linspace(-Fs/2, Fs/2, length(Y));
subplot(2,1,2);
plot(f, abs(Y));
xlabel('Frequency (Hz)');
ylabel('Magnitude');

% Play sound file
sound(y, Fs);
pause(length(y)/Fs);

%----------------------------------------------------------------------%

% Add noise to output of channel
sigma = input("Enter value of sigma: "); % Set value of sigma
z = sigma * randn(1,length(y)); % Generate noise signal
y_noisy = y + z; % Add noise to output of channel

% Play sound file
sound(y_noisy, Fs);
pause(length(y_noisy)/Fs);

% Plot sound file in time domain
figure;
subplot(2,1,1);
t = linspace(0, length(y_noisy)/Fs, length(y_noisy));
plot(t, y_noisy);
xlabel('Time (s)');
ylabel('Amplitude');
title('signal after adding the noise');

% Plot sound file in frequency domain
Y_noisy = fftshift(fft(y_noisy));
f = linspace(-Fs/2, Fs/2, length(Y_noisy));
subplot(2,1,2);
plot(f, abs(Y_noisy));
xlabel('Frequency (Hz)');
ylabel('Magnitude');

% make a filter
cutoff_frequency = 3400;
f = linspace(-Fs/2, Fs/2, length(Y_noisy));
filter = (f <= cutoff_frequency) & (f >= -cutoff_frequency);
Y_filtered=Y_noisy .* filter;
% Plot sound file in frequency domain
figure;
subplot(2,1,2);
plot(f, abs(Y_filtered));
xlabel('Frequency (Hz)');
ylabel('Magnitude');



% Plot sound file in time domain
y_filtered = real(ifft(ifftshift(Y_filtered)));
subplot(2,1,1);
plot(t, y_filtered);
xlabel('Time (s)');
ylabel('Amplitude');
title('signal after the filter');

% Play sound file
sound(y_filtered, Fs);
pause(length(y_filtered)/Fs);





