function S = logreg(a,r,p)  %a(1) is Alpha and a(2) is Beta.
S = 0;
for k = 1:length(r) 
    S = S + (p(k)-1/(1+exp(-a(1)*r(k)-a(2))))^2;
end