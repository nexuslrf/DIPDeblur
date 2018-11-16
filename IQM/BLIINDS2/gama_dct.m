function gamma_gauss = gama_dct(I)
    img = I.data(2:end)';
    gamma_gauss = gama_gen_gauss(img);
    return
    mean_gauss = mean(img);
    var_gauss = var(img);
    mean_abs = mean(abs(img - mean_gauss))^2;
    rho = var_gauss / (mean_abs+0.0000001);

    g = 0.03:0.001:10;
    r = gamma(1./g).*gamma(3./g)./(gamma(2./g).^2);

%% shuold use binary search
    for i = 1:numel(g)-1
        if rho <= r(i) && rho > r(i+1)
            gamma_gauss = g(i);
            return
        end
    end
    gamma_gauss = 11;
end
