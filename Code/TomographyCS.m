% [+] Un-Hardcode radonDCT
% [+] Vary operation of radonDCT according to size of x
% [+] Add parameters to the main code and polish

clc;clear;close all;
rng(42);

% SELECT THE EXECUTION TYPE FOR WHICH YOU WANT THE RESULTS
EXECUTION_TYPE = "fbp";
% Other options are "plaincs", "coupledcs2", "coupledcs3"

UNIFORMLY_SPACED_ANGLES = true;
% If set to ``true` we use uniformly spaced angles between 0,180
% If set to `false` we randomly sample angles using randperm

NUM_ANGLES = 18;
% Change this to chnage the number of angles used in tomographic
% projections

% Read Images and pad it with zeros to make it a square matrix of
% 217x217 dimension
P1 = imread("slice_50.png");
P1 = im2double(P1);
padImg1 = zeros(217);
padImg1(18:217-18-1,1:end) = P1;

P2 = imread("slice_51.png");
P2 = im2double(P2);
padImg2 = zeros(217);
padImg2(18:217-18-1,1:end) = P2;

P3 = imread("slice_52.png");
P3 = im2double(P3);
padImg3 = zeros(217);
padImg3(18:217-18-1,1:end) = P3;

% Number of bins to be used for radon transform
BINS = 309;
% Size of the reconstructed images
SIZE = 217;
if EXECUTION_TYPE == "fbp"
    if UNIFORMLY_SPACED_ANGLES == false
        % Gets 18 random angles from 0 to 180
        theta = randperm(180,NUM_ANGLES)-1;
    else
        % Gets 18 uniformly spaced angles
        theta = 0:(180/NUM_ANGLES):(180-180/NUM_ANGLES);
    end   
    
    % Do radon transform on those 18 angles
    [R1,~] = radon(padImg1,theta,BINS);
    % Reconstruct using the radon transform obtained
    I1 = iradon(R1,theta,'linear','Ram-Lak',SIZE);
    
    figure;imshow(I1);
    title('FBP reconstruction from PBP');
    figure;imshow(padImg1);
    title('Original Image');
    
elseif EXECUTION_TYPE == "plaincs"
    if UNIFORMLY_SPACED_ANGLES == false
        % Gets 18 random angles from 0 to 180
        theta = randperm(180,NUM_ANGLES)-1;
    else
        % Gets 18 uniformly spaced angles
        theta = 0:(180/NUM_ANGLES):(180-180/NUM_ANGLES);
    end   
    
    % Do radon transform on those 18 angles
    [R1,~] = radon(padImg1,theta,BINS);
    
    % A is a function handle with overloaded * operator
    A = radonDCT(theta,SIZE,BINS,NUM_ANGLES);
    At = A';
    m = NUM_ANGLES*BINS;
    n = SIZE*SIZE;
    
    % y is the stacked radon tranforms
    y = reshape(R1,[BINS*NUM_ANGLES 1]);
    lambda = 0.01;
    rel_tol = 0.01;
    [x,~]=l1_ls(A,At,m,n,y,lambda,rel_tol);
    
    % Finally we get the reconstructed signal, we do "Ub" to get the image
    % from the dct coefficients
    I1 = idct2(reshape(x,[SIZE SIZE]));
    
    figure;imshow(I1);
    title('Single Slice CS reconstruction');
    figure;imshow(iradon(R1,theta,'linear','Ram-Lak',SIZE));
    title('FBP reconstruction');
    figure;imshow(padImg1);
    title('Original Image');
    
elseif EXECUTION_TYPE == "coupledcs2"
    if UNIFORMLY_SPACED_ANGLES == false
        % Gets 18 random angles from 0 to 180
        thetas = randperm(180,2*NUM_ANGLES)-1;
    else
        % Gets 18 uniformly spaced angles
        thetas = [0:(180/NUM_ANGLES):(180-180/NUM_ANGLES) ...
            5:(180/NUM_ANGLES):(5+180-180/NUM_ANGLES)];
    end
    
    % Construct the radon and DCT forward model
    A = radonDCT2(thetas(1:end/2),thetas(end/2+1:end),SIZE,BINS,NUM_ANGLES);
    At = A';
    
    % Do radon transform on those 36 angles
    [R1,~] = radon(padImg1,thetas(1:end/2),BINS); 
    [R2,~] = radon(padImg2,thetas(end/2+1:end),BINS);
    
    % Create the target signal
    y1 = reshape(R1,[BINS*NUM_ANGLES 1]);
    y2 = reshape(R2,[BINS*NUM_ANGLES 1]);
    y = [y1; y2];
    
    m = NUM_ANGLES*BINS*2;
    n = SIZE*SIZE*2;    
    lambda = 0.01;
    rel_tol = 0.001;    
    [x,~]=l1_ls(A,At,m,n,y,lambda,rel_tol);
    
    % Get image from the DCT coefficients
    I1 = idct2(reshape(x(1:end/2),[SIZE SIZE]));
    I2 = idct2(reshape(x(1:end/2),[SIZE SIZE]) + ...
        reshape(x(end/2+1:end),[SIZE SIZE]));
    
    figure;imshow(I1);
    title('Coupled CS(2 slices) 1st slice reconstruction');
    figure;imshow(I2);
    title('Coupled CS(2 slices) 2nd slice reconstruction');
    figure;imshow(iradon(R1,thetas(1:end/2),'linear','Ram-Lak',SIZE));
    title('FBP reconstruction');
    figure;imshow(padImg1);
    title('Original Image');
    
elseif EXECUTION_TYPE == "coupledcs3"
    if UNIFORMLY_SPACED_ANGLES == false
        % Gets 18 random angles from 0 to 180
        thetas = randperm(180,3*NUM_ANGLES)-1;
    else
        % Gets 18 uniformly spaced angles
        thetas = [0:(180/NUM_ANGLES):(180-180/NUM_ANGLES) ...
            4:(180/NUM_ANGLES):(4+180-180/NUM_ANGLES) ...
            8:(180/NUM_ANGLES):(8+180-180/NUM_ANGLES)];
    end
    % Construct the radon and DCT forward model
    A = radonDCT3(thetas(1:end/3),thetas(end/3+1:2*end/3),thetas(2*end/3+1:end),SIZE,BINS,NUM_ANGLES);
    At = A';
    
    % Do radon transform on those 54 angles
    [R1,~] = radon(padImg1,thetas(1:end/3),BINS); 
    [R2,~] = radon(padImg2,thetas(end/3+1:2*end/3),BINS);
    [R3,~] = radon(padImg3,thetas(2*end/3+1:end),BINS);
    
    % Create the target signal
    y1 = reshape(R1,[BINS*NUM_ANGLES 1]);
    y2 = reshape(R2,[BINS*NUM_ANGLES 1]);
    y3 = reshape(R3,[BINS*NUM_ANGLES 1]);
    y = [y1; y2; y3];
    
    m = BINS*NUM_ANGLES*3;
    n = SIZE*SIZE*3;    
    lambda = 0.01;
    rel_tol = 0.1;    
    [x,~]=l1_ls(A,At,m,n,y,lambda,rel_tol);
    
    % Get image from the DCT coefficients
    I1 = idct2(reshape(x(1:SIZE*SIZE),[SIZE SIZE]));
    
    I2 = idct2(reshape(x(1:end/3),[SIZE SIZE]) + ...
        reshape(x(end/3+1:2*end/3),[SIZE SIZE]));
    
    I3 = idct2(reshape(x(1:end/3),[SIZE SIZE]) + ...
        reshape(x(end/3+1:2*end/3),[SIZE SIZE]) + ...
        reshape(x(2*end/3+1:end),[SIZE SIZE]));
    
    figure;imshow(I1);
    title('Coupled CS(3 slices) 1st slice reconstruction');
    figure;imshow(I2);
    title('Coupled CS(3 slices) 2nd slice reconstruction');
    figure;imshow(I3);
    title('Coupled CS(3 slices) 3rd slice reconstruction');
    figure;imshow(iradon(R1,thetas(1:end/3),'linear','Ram-Lak',SIZE));
    title('FBP reconstruction');
    figure;imshow(padImg1);
    title('Original Image');
end