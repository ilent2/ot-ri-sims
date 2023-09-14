% Attempt to reproduce figure 1 (bottom)

%addpath('../ott');  % Add OTT to the path
systemParameters();   % Load the system parameters

n_relative = linspace(1.01, 1.36, 30);   % Relative refractive index
radii = [2.25, 2.3, 2.35, 2.4, 2.45, 2.5]*wavelength0;  % Radii (m)

% For this simulation, we don't find the peak radial force but rather
% just some force in the radial direction.  Not sure what the paper did.
% So, lets just guess a step here
x0 = 1*wavelength0;

%% Generate data for figure

% Simulate beam for system
beam = ott.BscPmGauss('NA', NA_beam, 'index_medium', n_medium, ...
    'wavelength0', wavelength0, 'truncation_angle', truncation_angle, ...
    'polarisation', polarisation);

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
    
            % Use a slightly odd definition of trap efficiency...
            % Could be motivated by computer speed in 2006
            fxyz = ott.forcetorque(beam, tmatrix, 'position', [x0;0;z0]);
            trapEfficiency(ii, jj) = abs(fxyz(1)) / beam.power;

        catch
            % No equilibrium, so omit it from the graph
            trapEfficiency(ii, jj) = nan;
        end
        
    end
end

%% Generate figure

figure();
plot(n_relative, trapEfficiency);
xticks(1:0.1:1.3);
xlim([1.0, 1.36]);
yticks(0:0.05:0.25);
ylim([0, 0.25]);
xlabel('Relative index');
ylabel('Trap efficiency');
legend(cellfun(@num2str, num2cell(radii/wavelength0), ...
    'UniformOutput', false), 'Location', 'northwest');
