% Attempt to reproduce figure 1 (bottom)

%addpath('../ott');  % Add OTT to the path
systemParameters();   % Load the system parameters

n_relative = linspace(1.01, 1.36, 30);   % Relative refractive index
radii = [2.25, 2.3, 2.35, 2.4, 2.45, 2.5]*wavelength0;  % Radii (m)

%% Generate data for figure

% Simulate beam for system
beam = ott.BscPmGauss('NA', NA_beam, 'index_medium', n_medium, ...
    'wavelength0', wavelength0, 'truncation_angle', truncation_angle, ...
    'polarisation', polarisation);

x = linspace(1, 4, 25).*wavelength0;  % Peak is typically in this range

% Turn off anoying warning
warning('off', 'ott:axialEquilibrium:move');

% Calculate radial trap efficiency
trapEfficiency = zeros(numel(n_relative), numel(radii));
for ii = 1:numel(n_relative)
    disp(['Progress... ', num2str(ii) '/' num2str(numel(n_relative))]);
    for jj = 1:numel(radii)

        % Generate T-matrix for praticle
        tmatrix = ott.TmatrixMie(radii(jj), ...
            'index_relative', n_relative(ii), 'wavelength0', wavelength0, ...
            'index_medium', n_medium);

        % Find the axial equilibrium
        try
            % Find axial trap position
            z0 = ott.axial_equilibrium(tmatrix, beam);
    
            fxyz = ott.forcetorque(beam, tmatrix, 'position', [1;0;0].*x + [0;0;z0]);
            trapEfficiency(ii, jj) = max(abs(fxyz(1, :))) / beam.power;

        catch
            % No equilibrium, so just continue
            trapEfficiency(ii, jj) = 0;
        end
        
    end
end

%% Generate figure

figure();
plot(n_relative, trapEfficiency./2);
xticks(1:0.1:1.3);
xlim([1.0, 1.36]);
yticks(0:0.05:0.25);
xlabel('Relative index');
ylabel('Trap efficiency');
legend(cellfun(@num2str, num2cell(radii/wavelength0), ...
    'UniformOutput', false), 'Location', 'northwest');
