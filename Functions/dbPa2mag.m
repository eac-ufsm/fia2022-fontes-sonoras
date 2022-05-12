function out = dbPa2mag(input)
    out = sqrt((10.^(input./10)).*((2e-5)^2));
end

