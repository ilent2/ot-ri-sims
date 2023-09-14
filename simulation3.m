% Attempt to reproduce figure 3

%addpath('../ott');  % Add OTT to the path
systemParameters();   % Load the system parameters

n_particle = linspace(1.4, 1.6, 30);
radii = [PMMAd, PSd, SId]./2.0;

% For stiffness calculation, use a step size related to the diffusion
% coefficient since the local trap stiffness can sometimes be much
% less than the average trap stiffness the particle would see
kx_step = 0.1*sqrt(300*1.38e-23/(6*pi*1e-3*radii(1)));

% Turn off anoying warning
warning('off', 'ott:axialEquilibrium:move');

%% Generate data for graph

% Simulate beam for system
beam = ott.BscPmGauss('NA', NA_beam, 'index_medium', n_medium, ...
    'wavelength0', wavelength0, 'truncation_angle', truncation_angle, ...
    'polarisation', polarisation);

kx = zeros(numel(n_particle), numel(radii));
for ii = 1:numel(n_particle)
    for jj = 1:numel(radii)
        % Calculate T-matrix for particle
        tmatrix = ott.TmatrixMie(radii(jj), 'index_medium', n_medium, ...
            'index_particle', n_particle(ii), 'wavelength0', wavelength0);

        % Find axial trap position
        z0 = ott.axial_equilibrium(tmatrix, beam);

        % Calculate radial stiffness
        [k, ~, ~] = ott.trap_stiffness(beam, tmatrix, ...
            'position', [0;0;z0], 'step', [kx_step, 1e-3]);
        kx(ii, jj) = -k(1);
    end
end

%% Determine calibration factor (for power/trap stiffness)
% This converts from toolbox units (Q) to pN/nm and uses a similar
% approach used in the paper for calibrating to experimental results
tmatrix = ott.TmatrixMie(radii(jj), 'index_medium', n_medium, ...
    'index_particle', SIn, 'wavelength0', wavelength0);
z0 = ott.axial_equilibrium(tmatrix, beam);
[k, ~, ~] = ott.trap_stiffness(beam, tmatrix, ...
            'position', [0;0;z0], 'step', [kx_step, 1e-3]);
Cunits = -SIk ./ k(1);   % pN/nm/Q

%% Generate plot

figure();
plot(n_particle, kx*Cunits);
hold on;

% For reference, add the measurement from the paper
plot(SIn, SIk, '*');
plot(PSn, PSk, '*');
plot(PMMAn, PMMAk, '*');

hold off;
xticks(1.4:0.05:1.6);
yticks(0:0.1:0.7);
ylim([0, 0.71]);
xlim([1.4, 1.6]);
xlabel('Refractive index');
ylabel('Trap stiffness [pN/nm]');
legend(cellfun(@(x) ['d=', num2str(2*x) '\mum'], num2cell(radii), ...
    'UniformOutput', false), 'Location', 'northwest');
