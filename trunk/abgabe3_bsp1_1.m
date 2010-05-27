function[] =  abgabe3_bsp1_1()

clc;
% the given propabilitys
pw1 = 0.5;
pw2 = 1 - pw1;
scale = -5:0.01:10;

%y11 = normcdf(scale,1.5,1);
%y22 = normcdf(scale,3,1);
%py11 = pw1 * y11;
%py22 = pw2 * y22;

% calculate propabilitys
pxw1  = calc_pxw(pw1,scale,1.5,1);
pxw2  = calc_pxw(pw2,scale,3,1);
px =    calc_marginaldistribution(pxw1,pxw2);
post1 = calc_posterior(pxw1,px);
post2 = calc_posterior(pxw2,px);

% Conditional Error
cond = calc_conditionalerror(post1,post2,px);

% calculate the errorrate for boundary 4
errorrate = calc_errorrate(pxw1,pxw2,4)
% bayes Error
bayes = calc_bayeserrorrate(pxw1,pxw2)


plot(scale,pxw1,'blue')
hold on
plot(scale,pxw2,'green')
hold on
plot(scale,px,'black')
hold on
plot(scale,post1,'blue:')
hold on
plot(scale,post2,'green:')
hold on
%plot(scale,errorrate,'red--');
%plot(scale,pw1-py11(:)+py22(:),'red--')
hold on
plot(scale,cond,'red')


end

% calculate p(x | w_i) 
function pxw = calc_pxw(pw,scale,mean,sigma)
    pxw = normpdf(scale,mean,sigma) * pw;
end

% calculate marginal distribution p(x)
function marg = calc_marginaldistribution(pxw1,pxw2) 
    marg = pxw1+pxw2;
end

% calculates the posterior
function post = calc_posterior(pxw,px)
    post = pxw(:) ./ px(:);
end


%this function calculates the errorrate to a specific boundary
function errorrate = calc_errorrate(pxw1,pxw2,boundary)
    sum = 0;
    step=0.01;
    steps=1;
    x=-5.0;
    while(x<10-step)   
       %calc_conditionalerrorate(x,pxw1,pxw2)
       px=calc_marginaldistribution(pxw1,pxw2);
       post1=calc_posterior(pxw1,px).*px';
       post2=calc_posterior(pxw2,px).*px';
       if (x<boundary) 
           errorx = post2(steps);
       else
           errorx = post1(steps);
       end
       sum = sum+errorx;
       x=x+step;
       steps=steps+1; 
    end
    errorrate = sum/steps;
end

function errorrate = calc_bayeserrorrate(pxw1,pxw2)
    %this function calculates the errorrate to a specific boundary
    sum = 0;
    step=0.01;
    steps=1;
    x=-5.0;
    while(x<10-step)   
       %calc_conditionalerrorate(x,pxw1,pxw2)
       px=calc_marginaldistribution(pxw1,pxw2);
       post1=calc_posterior(pxw1,px).*px';
       post2=calc_posterior(pxw2,px).*px';
       errorx = min([post1(steps),post2(steps)]).*px(steps);
       sum = sum+errorx;
       x=x+step;
       steps=steps+1; 
    end
    errorrate = sum/steps;
end

    
% calculates the conditional error rate
function errorrate = calc_conditionalerror(post1,post2,px)
    for i=1:length(post1)
        errorrate(i)=min([post1(i),post2(i)]).*px(i);
    end
end





