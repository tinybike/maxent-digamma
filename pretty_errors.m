function [u_sig,u_paren] = pretty_errors(u,u_err)
% Convert a number and its error to a more readable version:
% Ex:
% u = 1.234567, u_err = 0.012345 -> u_sig = '1.23', u_paren = '1'
% (for use with notation u = 1.23(1))

n = -1;
u_paren = 0;

while ~u_paren
    n = n + 1;
    u_paren = round(u_err*10^n);
end

u_paren = num2str(u_paren);
u_sig = num2str(round(u*10^n)/10^n);