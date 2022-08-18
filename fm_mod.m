function [msg_tx] = fm_mod(msg,fc2,fs,kf2)

msg_int = cumsum(msg)/fs; 

t = linspace (0,length(msg)/fs,length(msg)+1);
t(end)= []; 

Ac = 1;


msg_tx = Ac*cos(2*pi*fc2*t+2*pi*kf2*msg_int);

end