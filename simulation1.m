% Attempt to reproduce figure 1 (top)

%addpath('../ott');  % Add OTT to the path
systemParameters();  % Load experiment parameters

n_relative = linspace(1.0, 2.0, 100);  % Relative refractive index
radius = 2.09e-6;   % Particle radius (m)

%% Generate data for plot

% Simulate beam for system
beam = ott.BscPmGauss('NA', NA_beam, 'index_medium', n_medium, ...
    'wavelength0', wavelength0, 'truncation_angle', truncation_angle, ...
    'polarisation', polarisation);

x = linspace(0, 6*wavelength0, 50);

% Turn off anoying warning
warning('off', 'ott:axialEquilibrium:move');

trapEfficiency = zeros(size(n_relative));
for ii = 1:numel(n_relative)
    % Calculate particle T-matrix
    tmatrix = ott.TmatrixMie(radius, ...
        'index_relative', n_relative(ii), 'index_medium', n_medium, ...
        'wavelength0', wavelength0);

    try
        % Find axial trap position
        z0 = ott.axial_equilibrium(tmatrix, beam);

        % Calculate trapping efficiency
        Q = ott.forcetorque(beam, tmatrix, 'position', z0 + [1;0;0].*x);
        trapEfficiency(ii) = max(abs(Q(1, :))) ./ beam.power;

    catch
        % No equilibrium, so just continue
        trapEfficiency(ii) = 0;
    end
end

%% Generate plot

figure();
plot(n_relative, trapEfficiency);
xticks(1.0:0.2:2.0);
xlim([1, 2]);
yticks(0:0.1:0.5);
ylim([0, 0.59]);
xlabel('Relative refractive index');
ylabel('Trapping efficiency');
