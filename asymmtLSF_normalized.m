function [norm_corr] = asymmtLSF_normalized(y, lambda, p) 

% Estimate baseline with asymmetric least squares
m = length(y);
D = diff(speye(m), 2);
w = ones(m, 1);
for it = 1:20
    W = spdiags(w, 0, m, m);
    C = chol(W + lambda * D' * D);
    z = C \ (C' \ (w .* y));
    w = p * (y > z) + (1 - p) * (y < z);
end
figure(1);
hold on
plot(y);
plot(z);

q = y/z;
%fit the normalized values
n = length(q);
E = diff(speye(n), 2);
ww = ones(n, 1);
for itz = 1:20
    WW = spdiags(ww, 0, n, n);
    C = chol(WW + lambda * E' * E);
    z2 = C \ (C' \ (ww .* q));
    ww = p * (q > z2) + (1 - p) * (q < z2);
end
figure(2);
hold on
plot(z2(:,1));
plot(q(:,1));

%%fid diff between 1 and fit value
DD = 1 - z2;

norm_corr = q + DD;

figure(3);
plot (norm_corr(:,1));

disp('finished!');
end
