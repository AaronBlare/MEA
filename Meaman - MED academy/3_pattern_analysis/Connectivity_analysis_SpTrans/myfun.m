

function F = myfun(x,xdata)

% fittype( 'M/(1+((x-T)/w).^2)+O')
F = x(1)/exp(x(2)*xdata);