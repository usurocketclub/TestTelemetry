

files = [
    "2022-02-05_telemetry01_C6-5.CSV", ...
    "static_telemetry.CSV",
];
NFFT = [2^8, 2^8];
start_time = [168 -1];
end_time = [-1 -1];

for i = 1:length(files)
    close all;
    fprintf("Analyzing %s\n", files(i));
    fprintf("  plotting figures...\n");
    [t, ax,ay,az, gyrox, gyroy, gyroz] = plotTelemetry(files(i), NFFT(i), start_time(i), end_time(i));
    fprintf("Press enter to continue to next file.\n");
    if (i ~= length(files))
        input("");
    end
end

