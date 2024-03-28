load voltage25.mat 
load data.mat

plot(t_tot, v_tot ,'LineWidth',2)

    xlabel('Time [s]')
    ylabel('Cell Voltage [V]')
    hold on 
plot (t(1:2200), u(1:2200), 'LineWidth',2)