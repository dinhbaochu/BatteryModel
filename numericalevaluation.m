load voltage.mat 
load data.mat

plot(t_tot, v_tot ,'LineWidth',2)

    xlabel('Time [s]')
    ylabel('Cell Voltage [V]')
    hold on 
plot (t(1:2200), u(1:2200), 'LineWidth',2)

u1=ones(1,1000);
u2=ones(1,1000);

for i=1:1000
    for a = 1:2200
        if t(a)<=i*100, t(a+1)>i*100
            
            u1(i)=u(a);
           
        end 
    end 
    for b = 1:2200
        if t_tot(b)<=i*100, t_tot(b+1)>i*100
            
            u2(i)=v_tot(b);
        end 
    end 
end
u3=u1-u2;
rms=0;
for c=1:1000
    rms=rms+u3(c).^2; 
end 
rms = (rms/1000).^(1/2)

    
