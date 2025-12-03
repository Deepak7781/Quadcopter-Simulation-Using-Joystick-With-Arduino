
% Derivation of 6DOF Equations of motion

% By Newton's Law of motion We know that d(mv)/dt = F

% External Forces, F = Gravitational Forces + Body Forces

% Define gravitational force vector

syms T  m g theta psi phi  Ix Iy Iz p q r L M N u v w


FgI = m*[0; 0; g]; % Assuming downward gravity in the z-direction

Fb = [0;0;-T]; % Body forces 

Vb = [u;v;w];


% We are trying to derive the translational equations of motion in Body
% Frame, So we need to rotate Fg to body frame.

R_psi = [cos(psi) sin(psi) 0; -sin(psi) cos(psi) 0; 0 0 1];
R_theta = [cos(theta) 0 -sin(theta); 0 1 0; sin(theta) 0 cos(theta)];
R_phi = [1 0 0; 0 cos(phi) sin(phi); 0 -sin(phi) cos(phi)];

R_E_B = R_phi*R_theta*R_psi; % Rotation matrix for Rotation from Earth (Inertial) Frame to Body Frame

R_B_E = transpose(R_psi)*transpose(R_theta)*transpose(R_phi); % Rotation matrix for Rotation from Body Frame to Earth (Inertial) Frame

Fb_total = (R_E_B*FgI) + Fb;

Vb_dot = Fb_total/m; % Translational Equations of Motion in Body frame



% Similarly for Rotational Equations of motion we use 
% d(Lb)/dt + (omega_b x Lb) = tau_b
% Lb = Ib*omega_b
% Ib*d(omega_b)/dt + (omega_b x Ib*omega_b) = tau_b

omega_b = [p;q;r];
tau_b = [L;M;N];

Ib = [Ix 0 0; 0 Iy 0; 0 0 Iz];

omegab_dot = Ib\(tau_b - cross(omega_b,Ib*omega_b)); % Rotational Equations of Motion in Body frame



eulerdot = [1 sin(phi)*tan(theta) cos(phi)*tan(theta); 0 cos(phi) -sin(phi); 0 sin(phi)*sec(theta) cos(phi)*sec(theta)]*omega_b;

posdot = R_B_E*Vb;

disp("Translational Equations of Motion in Body frame"); 
fprintf("udot = %s\n", Vb_dot(1));
fprintf("vdot = %s\n", Vb_dot(2));
fprintf("wdot = %s\n\n", Vb_dot(3));

disp("Rotational Equations of Motion in Body frame");
fprintf("pdot = %s\n", omegab_dot(1));
fprintf("qdot = %s\n", omegab_dot(2));
fprintf("rdot = %s\n\n", omegab_dot(3));


disp("Change in Euler Angles");
fprintf("phidot = %s\n", eulerdot(1));
fprintf("thetadot = %s\n", eulerdot(2));
fprintf("psidot = %s\n\n", eulerdot(3));


disp("Change in Position in Inertial Position");
fprintf("xdot = %s\n", posdot(1));
fprintf("ydot = %s\n", posdot(2));
fprintf("zdot = %s\n", posdot(3));