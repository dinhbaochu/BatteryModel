load data.mat

newi= ones(2199,1);
newu= ones(2199,1);
newt=ones(2199,1);
for counter = 2:2200
    newi(counter-1)=i(counter);
    newu(counter-1)=u(counter);
    newt(counter-1)=[t(counter+1)-t(counter)]/2+[t(counter)-t(counter-1)]/2;
end 
save new.mat newi newu newt