function [t, ax,ay,az, gyrox, gyroy, gyroz] = plotTelemetry(filename, NFFT, start_time, end_time);
    accel_offset = 50e3;

    table = readtable(filename);

    t = table.Var1;

    ax = table.Var9;
    ay = table.Var10;
    az = table.Var11;

    gyrox = table.Var12;
    gyroy = table.Var13;
    gyroz = table.Var14;

    if (end_time < 0)
        end_time = max(t)/1000;
    end
    if (start_time > 0 || end_time*1000 < max(t))
        t_ = zeros(size(t));
        ax_ = zeros(size(ax));
        ay_ = zeros(size(ay));
        az_ = zeros(size(az));
        gyrox_ = zeros(size(gyrox));
        gyroy_ = zeros(size(gyroy));
        gyroz_ = zeros(size(gyroz));
        n = 1;
        for i = 1:length(t);
            if (t(i) >= start_time*1000 && t(i) <= end_time*1000)
                t_(n) = t(i);
                ax_(n) = ax(i);
                ay_(n) = ay(i);
                az_(n) = az(i);
                gyrox_(n) = gyrox(i);
                gyroy_(n) = gyroy(i);
                gyroz_(n) = gyroz(i);
                n = n + 1;
            end
        end
        % Trim tailing zeros
        t = t_(1:find(t_,1,'last'));
        ax = ax_(1:find(ax_,1,'last'));
        ay = ay_(1:find(ay_,1,'last'));
        az = az_(1:find(az_,1,'last'));
        gyrox = gyrox_(1:find(gyrox_,1,'last'));
        gyroy = gyroy_(1:find(gyroy_,1,'last'));
        gyroz = gyroz_(1:find(gyroz_,1,'last'));
        % Shift start time to zero
        t = t - t(1);
    end

    t_sec = t./1000;


    % Add offset to data
    ax = ax + accel_offset;
    ay = ay + accel_offset;
    az = az + accel_offset;

    %ax_filt = medfilt1(ax, 7);
    %ay_filt = medfilt1(ay, 7);
    %az_filt = medfilt1(az, 7);


    % Calculate Delta T
    N = length(t) - 1;
    dt_raw = zeros(1, N-1);
    dt = zeros(1, N-1);
    for i = 1:N-1
        dt_raw(i) = t(i+1) - t(i);
        dt(i) = min(dt_raw(i), 50);
    end
    Fs = round( 1 / (mean(dt)/1000) );



    % Maybe try something like this
    % interp1(t, ax, t_uniform)




    % Plot Raw Accel Data
    figure();
    subplot(211)
    plot(t_sec,ax, t_sec,ay, t_sec,az, "LineWidth",2); %hold on;
    %plot( t_sec, ax_filt, t_sec,ay_filt, t_sec,az_filt, "LineWidth",2) hold off;
    title("Raw Accelerometer Data", filename, 'Interpreter', 'none');
    xlabel("Time [sec]");
    ylabel("Raw Accel. Output");
    grid on;
    legend("Accel. X", "Accel. Y", "Accel. Z", "Location", "SouthEast");


    % Plot Ray Gyro Data
    subplot(212);
    plot(t_sec,gyrox, t_sec,gyroy, t_sec,gyroz, "LineWidth",2);
    title("Raw Gyroscope Data", filename, 'Interpreter', 'none');
    xlabel("Time [sec]");
    ylabel("Ray Gyro Output");
    grid on;
    legend("Gyro X", "Gyro Y", "Gyro Z", "Location", "SouthEast");


    % Plot Delta T
    figure();
    plot(1:length(dt_raw), dt_raw);
    title("Delta T", filename, 'Interpreter', 'none');
    xlabel("Sample Index");
    ylabel("Delta T [ms]");
    ylim([10 50]);
    grid on;




    % Plot Accel. X Data Freq. Content
    figure();
    subplot(211);
    [H,F] = freqz(ax, 2^14, Fs);
    plot(F, 20*log10( abs(real(H)) ), "LineWidth", 2);
    title("Accel. Data X Freq. Content", filename, 'Interpreter', 'none');
    xlabel("Frequency [Hz]");
    ylabel("Magnitude [dB]");
    grid on;
    

    % Plot Accel Spectrogram X
    subplot(212);
    [S,F,T] = spectrogram(ax, hamming(NFFT), round(0.9*NFFT), NFFT, Fs);
    imagesc(T,F,20*log10(abs(S)),[0 120]);
    colorbar;
    set(gca,'YDir','normal');
    title("Spectrogram of Accel. X Data", filename, 'Interpreter', 'none');
    xlabel("Time [sec]");
    ylabel("Frequency [Hz]");




    % Plot Accel. Y Data Freq. Content
    figure();
    subplot(211);
    [H,F] = freqz(ay, 2^14, Fs);
    plot(F, 20*log10( abs(real(H)) ), "LineWidth", 2);
    title("Accel. Data Y Freq. Content", filename, 'Interpreter', 'none');
    xlabel("Frequency [Hz]");
    ylabel("Magnitude [dB]");
    grid on;


    % Plot Accel Spectrogram Y
    subplot(212);
    [S,F,T] = spectrogram(ay, hamming(NFFT), round(0.9*NFFT), NFFT, Fs);
    imagesc(T,F,20*log10(abs(S)),[0 120]);
    colorbar;
    set(gca,'YDir','normal');
    title("Spectrogram of Accel. Y Data", filename, 'Interpreter', 'none');
    xlabel("Time [sec]");
    ylabel("Frequency [Hz]");


    % Plot Accel. Z Data Freq. Content
    figure();
    subplot(211);
    [H,F] = freqz(az, 2^14, Fs);
    plot(F, 20*log10( abs(real(H)) ), "LineWidth", 2);
    title("Accel. Data Z Freq. Content", filename, 'Interpreter', 'none');
    xlabel("Frequency [Hz]");
    ylabel("Magnitude [dB]");
    grid on;


    % Plot Accel Spectrogram Z
    subplot(212);
    [S,F,T] = spectrogram(az, hamming(NFFT), round(0.9*NFFT), NFFT, Fs);
    imagesc(T,F,20*log10(abs(S)),[0 120]);
    colorbar;
    set(gca,'YDir','normal');
    title("Spectrogram of Accel. Z Data", filename, 'Interpreter', 'none');
    xlabel("Time [sec]");
    ylabel("Frequency [Hz]");


end
