% Parameters given in the paper

wavelength0 = 1070.0e-9;  % Laser wavelength (m)
NA_objective = 1.3;  % Objective NA
n_medium = 1.33;   % Liquid refractive index
polarisation = [1, 0];   % Linearly polarised in X direction
truncation_angle = asin(NA_objective/n_medium);

% The paper says the beam is overfilling the objective, but I don't know
% exactly how much, so lets just guess its about the same as the NA
NA_beam = 1.3;

% Diameters of purchased particles (m)
SId = 2.32e-6;   % Silica
PMMAd = 1.68e-6; % Poly(methyl methacrylate)
PSd = 2.09e-6;   % Polystyrene

% Diameters of synSI particles (m)
synSId = [4.93e-6, 5.16e-6, 5.65e-6];

% Measured refractive indices of particles
SIn = 1.450;
PSn = 1.582;
PMMAn = 1.476;

% Measured stiffness in experiment
SIk = 0.181;
PSk = 0.361;
PMMAk = 0.507;
