% Clear the workspace
clear
load new.mat
for epoch = 1:1
    areacoef = 25;
    % Define the parameters structure.
    param{1} = Parameters_init(95);
    % Change the CVs number in each battery section
    
    % Positive Current Collector
    param{1}.Nal   = 10;
    % Positive Electrode
    param{1}.Np    = 30;
    % Separator
    param{1}.Ns    = 30;
    % Negative Electrode
    param{1}.Nn    = 30;
    % Negative Current Collector
    param{1}.Ncu   = 10;
    
    % Define the applied current densities.
    input_power_densities = areacoef*newi;
   
    
    % Define the duration of each applied current step.
    timings = newt;

    % Note that length(timings)==length(input_currents) !!
    
    % Initialize the states and their time derivatives
    initialState.Y      = [];
    initialState.YP     = [];
    % Set the initial integration time
    t0 	= 0;
    tf  = 0;
    % Initialize the array where results will be stored
    ce_tot 			= [];
    Phis_tot 		= [];
    t_tot 			= [];
    Temperature_tot = [];
    SOC_tot         = [];
    
    param{1}.OperatingMode=2;
    
    run_n = 1;
    for i=1:length(timings)
        % Set the final integration time
        tf 			= tf + timings(i);
        % Start the simulations
        results 	= startSimulation(t0,tf,initialState,input_power_densities(i),param);
        % Concatenate the results
        if(run_n==1)
            ce_tot 						= [ce_tot;results.ce{1}];
            SOC_tot         			= [SOC_tot;results.SOC{1}];
            Phis_tot 					= [Phis_tot;results.Phis{1}];
            Temperature_tot 			= [Temperature_tot;results.Temperature{1}];
            t_tot           			= [t_tot;results.time{1}];
            param{1}.JacobianFunction 	= results.JacobianFun;
            run_n = 2;
        else
            ce_tot 			= [ce_tot;results.ce{1}(2:end,:)];
            SOC_tot         = [SOC_tot;results.SOC{1}(2:end,:)];
            Phis_tot 		= [Phis_tot;results.Phis{1}(2:end,:)];
            Temperature_tot = [Temperature_tot;results.Temperature{1}(2:end,:)];
            t_tot           = [t_tot;results.time{1}(2:end)];
        end
        % Update the initial states.
        initialState = results.initialState;
        % Update the starting integration time instant.
        t0 		= results.time{1}(end);
    
        if(results.exit_reason~=0)
            break
        end
    end
  simu = Phis_tot(:,1)-Phis_tot(:,end);

    
    %% Voltage plot
    plot(t_tot, Phis_tot(:,1)-Phis_tot(:,end) ,'LineWidth',2)
    hold on
    box on
    grid on
    xlim([0 sum(timings)])
    xlabel('Time [s]')
    ylabel('Cell Voltage [V]')
    
    %% Input profile plots
    figure
    hold on
    t0 = 0;
    tf = 0;
    prev_current = input_power_densities(1);
    cur_current = input_power_densities(2);
    
    for i=1:length(timings)
        if(i<length(timings))
            cur_current = input_power_densities(i+1);
        end
        tf = tf + timings(i);
        % cur_current = input_currents(i);
        line([t0 tf],[input_power_densities(i) input_power_densities(i)],'LineWidth',2)
        line([tf tf],[prev_current cur_current],'LineWidth',6)
        t0 = t0+timings(i);
        prev_current = cur_current;
    end
    box on
    grid on
    xlim([0 sum(timings)])
    ylim([min(input_power_densities)/1.1 max(input_power_densities)*1.1])
    xlabel('Time [s]')
    ylabel('Applied Current Density [A/m^2]')

    %% Temperature plot
    figure
    plot(t_tot,Temperature_tot(:,end),'LineWidth',2)
    box on
    grid on
    xlim([0 sum(timings)])
    xlabel('Time [s]')
    ylabel('Temperature [K]')
    
    %% SOC plot
    figure
    plot(t_tot,SOC_tot,'LineWidth',2)
    box on
    grid on
    xlim([0 sum(timings)])
    xlabel('Time [s]')
    ylabel('SOC [%]')
end
v_tot=Phis_tot(:,1)-Phis_tot(:,end);
save ('voltage.mat', "t_tot", 'v_tot')