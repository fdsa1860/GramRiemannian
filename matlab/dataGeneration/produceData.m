% Produce the synthetic data of contour trajectories
% including straight lines, circles, ellipses and sinusoids.
%
% Input:  
%    produce_step: the step for the data produced by MATLAB
%    sample_step: the step for resampling the original data
%    mode: resample the data (== 1)
%               not resample the data (== 0)
% Output:
%    X: the cell array containing the data to be processed


function X = produceData(produce_step, sample_step, mode)


%%%%%%%%%%%%%%%%%%%%%%%
% lines
x1 = 5:produce_step:15;
y1 = 10 * ones(1, numel(x1));

x2 = 10 - 5/sqrt(2):produce_step:10 + 5/sqrt(2);
y2 = -x2 + 20;

y3 = 5:produce_step:15;
x3 = 10 * ones(1, numel(y3));

x4 = 10 - 5/sqrt(2):produce_step:10 + 5/sqrt(2);
y4 = x4;

x5 = 7:produce_step:17;
y5 = 25 * ones(1, numel(x5));

x6 = 12 - 5/sqrt(2):produce_step:12 + 5/sqrt(2);
y6 = -x6 + 37;

y7 = 20:produce_step:30;
x7 = 12 * ones(1, numel(y7));

x8 = 12 - 5/sqrt(2):produce_step:12 + 5/sqrt(2);
y8 = x8 + 13;

x9 = 5:produce_step:15;
y9 = 40 * ones(1, numel(x9));

x10 = 10 - 5/sqrt(2):produce_step:10 + 5/sqrt(2);
y10 = -x10 + 50;

y11 = 35:produce_step:45;
x11 = 10 * ones(1, numel(y11));

x12 = 10 - 5/sqrt(2):produce_step:10 + 5/sqrt(2);
y12 = x12 + 30;

x13 = 7:produce_step:17;
y13 = 55 * ones(1, numel(x13));

x14 = 12 - 5/sqrt(2):produce_step:12 + 5/sqrt(2);
y14 = -x14 + 67;

y15 = 50:produce_step:60;
x15 = 12 * ones(1, numel(y15));

x16 = 12 - 5/sqrt(2):produce_step:12 + 5/sqrt(2);
y16 = x16 + 43;
%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%
% circles
theta1 = 0:produce_step:2*pi;
x17 = 30 + 10.*cos(theta1);
y17 = 13 + 10.*sin(theta1);

x18 = 30 + 7.*cos(theta1);
y18 = 35 + 7.*sin(theta1);

x19 = 30 + 4.*cos(theta1);
y19 = 50 + 4.*sin(theta1);

x20 = 30 + 2.*cos(theta1);
y20 = 60 + 2.*sin(theta1);
%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%
% thin ellipses
x21 = 52 + 10.*cos(theta1);
y21 = 63 + 3.*sin(theta1);

phi = pi/4;
R = [cos(phi) sin(phi);
      -sin(phi) cos(phi)];
 
xy22 = R * [x21-52; y21-63];
x22 = xy22(1, :) + 52;
y22 = xy22(2, :) + 50;

phi = pi/2;
R = [cos(phi) sin(phi);
      -sin(phi) cos(phi)];
  
xy23 = R * [x21-52; y21-63];
x23 = xy23(1, :) + 52;
y23 = xy23(2, :) + 30;

phi = 3*pi/4;
R = [cos(phi) sin(phi);
      -sin(phi) cos(phi)];
  
xy24 = R * [x21-52; y21-63];
x24 = xy24(1, :) + 52;
y24 = xy24(2, :) + 10;

% smaller thin ellipses
x25 = 72 + 5.*cos(theta1);
y25 = 63 + 1.5.*sin(theta1);

phi = pi/4;
R = [cos(phi) sin(phi);
      -sin(phi) cos(phi)];
 
xy26 = R * [x25-72; y25-63];
x26 = xy26(1, :) + 72;
y26 = xy26(2, :) + 50;

phi = pi/2;
R = [cos(phi) sin(phi);
      -sin(phi) cos(phi)];
  
xy27 = R * [x25-72; y25-63];
x27 = xy27(1, :) + 72;
y27 = xy27(2, :) + 30;

phi = 3*pi/4;
R = [cos(phi) sin(phi);
      -sin(phi) cos(phi)];
  
xy28 = R * [x25-72; y25-63];
x28 = xy28(1, :) + 72;
y28 = xy28(2, :) + 10;

% fat ellipses
x29 = 92 + 10.*cos(theta1);
y29 = 63 + 5.*sin(theta1);

phi = pi/4;
R = [cos(phi) sin(phi);
      -sin(phi) cos(phi)];
 
xy30 = R * [x29-92; y29-63];
x30 = xy30(1, :) + 92;
y30 = xy30(2, :) + 49;

phi = pi/2;
R = [cos(phi) sin(phi);
      -sin(phi) cos(phi)];
  
xy31 = R * [x29-92; y29-63];
x31 = xy31(1, :) + 92;
y31 = xy31(2, :) + 30;

phi = 3*pi/4;
R = [cos(phi) sin(phi);
      -sin(phi) cos(phi)];
  
xy32 = R * [x29-92; y29-63];
x32 = xy32(1, :) + 92;
y32 = xy32(2, :) + 10;
%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%
% sinusoids
x33 = 107:produce_step:130;
y33 = 63 + 4 .* sin((2*pi/20) * (x33-107));

x34 = 107:produce_step:130;
y34 = 52 + 3 .* cos((2*pi/10) * (x34-107));

x35 = 107:produce_step:130;
y35 = 40 + 3 .* cos((2*pi/4) * (x35-107));

x36 = 107:produce_step:130;
y36 = 27 + 3 .* cos((2*pi/8) * (x36-107)) + 1.5 .* sin((2*pi/2) * (x36-107)) ;

% cubic
x37 = 105:produce_step:130;
y37 = 0.3 .* (x37 - 105) .* sin(((2*pi/40) * (x37-105)).^2) + 13;
%%%%%%%%%%%%%%%%%%%%%%%


% store these synthetic data in a cell array
X = cell(1, 37);
n = numel(X);
for i = 1:n
    x = eval(['x', num2str(i)])';
    y = eval(['y', num2str(i)])';
    
    if mode == 1
        X{i} = resample([x y], 2, 100);
    elseif mode == 0
        X{i} = [x y];
    elseif mode == 2
        X{i} = resample([x y], 1, .1);
    end

end

% show the synthetic data of contour trajectories 
% hFig = figure;
% set(hFig, 'Position', [100 100 1250 650]);
% 
% hold on;
% for i = 1:n
%     plot(X{i}(:, 1), X{i}(:, 2), 'b', 'LineWidth', 1.5);
% end
% hold off;
% 
% axis equal;
% axis([0 140 0 70]);
% xlabel('x', 'FontSize', 14);
% ylabel('y', 'FontSize', 14);
% title('Original data',  'FontSize', 12);

end