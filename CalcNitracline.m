function [NCD] = CalcNitracline(z,NO3,thresh,method)

if strcmp(method,'exact')  %No Monte Carlo Uncertainty Analysis, Calculate the exact nitracline depth using a linear interpolation
    z2 = z;
    nit = NO3;
    [uniquez i j] = unique(z,'first');
    indexToDupes = find(not(ismember(1:numel(z),i)));
    z2(indexToDupes) = [];
    nit(indexToDupes) = [];
    interpmethod = 'linear';
elseif strcmp(method,'uncertainty')   %Used for Monte Carlo Uncertainty Analysis


    %First adding in 1/2 meter uncertainty in depth (note that this step also
    %alleviates issues when using interp in Matlab if you have identical
    %datapoints)
    z2 = z + rand(size(z)) - 0.5;

    %Next adding in 5% uncertainty in nitrate concentration
    unc = 0.05;
    nit = NO3 + randn(size(NO3))*unc.*NO3;

    %Randomly selecting either a linear interpolation or a spline
    %interpolation
    if rand>0.5
        interpmethod = 'linear';
    else
        interpmethod = 'spline';
    end
end

z_dummy = 0:0.01:600;
nit_dummy = interp1(z2,nit,z_dummy,interpmethod,'extrap');

NCD = z_dummy(min(find(nit_dummy>=thresh)));