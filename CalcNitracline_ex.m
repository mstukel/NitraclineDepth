function [NCD] = CalcNitracline_ex(z,NO3,thresh,slope,method)

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

z_dummy = 0:0.01:500;
nit_dummy = interp1(z2,nit,z_dummy,interpmethod,'extrap');

NCD = z_dummy(min(find(nit_dummy>=thresh)));

if NCD==0
    if min(nit)<=thresh
        ind = find(nit<=thresh);
        NCD = max(z2(ind));
    else

        extrap = NaN;
        for i=2:length(z2)
            % b = regress(nit(1:i),[z2(1:i),ones(size(z2(1:i)))]);
            % %extrap(i) = (thresh - b(2))/b(1);  %This calculates the nitracline depth based on a linear interpolation of nitrate measurements over the first i number of data points
            % slope = b(1);
            intercept = nit(1)-(slope*z2(1));
            extrap(i) = (thresh-intercept)/slope;  %This approach calculates the slope from a linear interpolation of nitrate measurements over the first i number of data points, but then calculates the nitracline depth based on the slope and always the shallowest nitrate measurement
        end
        extrap(find(extrap>0))=NaN;
        NCD = max(extrap);  %The reported nitracline depth is then chosen as the shallowest of these possible nitracline depths
    end
end
