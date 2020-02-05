function d = Bhattacharya(H1, H2)
    deno = sqrt(sum(H1) * sum(H2));
    nume = sum(sqrt(H1.*H2));
    d = sqrt(1-nume/deno);
end