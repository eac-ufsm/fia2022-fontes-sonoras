function out = mag2dbPa(input)
    out = 10.*log10((input.^2)./((2e-5)^2));
end

