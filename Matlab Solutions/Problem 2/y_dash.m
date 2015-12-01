function [T, X] = y_dash( t, theta )

xdot = @(t, x, p) (- p(1) .* x ./ (p(2) + x));

[T, X] = ode45(xdot, t, 10, [], theta);

end

