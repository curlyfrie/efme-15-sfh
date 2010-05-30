function[] =  abgabe3_bsp1_1(pw1)

disp(['----- P(w1)= ',num2str(pw1),' -----']);
% the given propabilitys
%pw1 = 0.9;
pw2 = 1 - pw1;
scale = -5:0.01:10; 

% calculate propabilitys
pxw1  = calc_pxw(pw1,scale,1.5,1);
pxw2  = calc_pxw(pw2,scale,3,1);
px =    calc_marginaldistribution(pxw1,pxw2);
post1 = calc_posterior(pxw1,px);
post2 = calc_posterior(pxw2,px);


% calculate the errorrate for boundary 4
errorrate = calc_errorrate(pw1,4)
% bayes Error
bayes = calc_bayeserrorrate(pw1)


figure('name',num2str(pw1))
subplot(5,1,1);
plot(scale,pxw1,'blue')
hold on
plot(scale,pxw2,'green')
title('p(x|w)')

subplot(5,1,2)
plot(scale,px,'black')
title('evidence')

subplot(5,1,3)
plot(scale,post1,'blue')
hold on
plot(scale,post2,'green')
title('posteriors')

subplot(5,1,4)
plot(scale,plot_conditionalerror(post1,post2,px,4),'red');
title('conditional error rate')

subplot(5,1,5)
plot(scale,plot_bayeserror(post1,post2,px),'red');
title('bayes error rate')

end

% calculate p(x | w_i) 
function pxw = calc_pxw(pw,scale,mean,sigma)
    pxw = normpdf(scale,mean,sigma).*pw ;
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
function errorrate = calc_errorrate(pw1,boundary)
%     sum = 0;
%     step=0.01;
%     steps=1;
%     x=-5.0;
%     while(x<10-step)   
%         errorx = calc_conderrorat(x,pw1,boundary);
%         sum = sum+errorx;
%         steps=steps+1; 
%         x=x+step;
%     end
%     errorrate = sum/steps/0.5;
    
    errorrate = quad(@(x)calc_conderrorate(x,pw1,boundary),-5,10);
end

function errorrate = calc_bayeserrorrate(pw1)
    
%     sum=0;
%     step=0.01;
%     steps=1;
%     x=-5.0;
%     while(x<10-step)  
%         pxw1 = calc_pxw(0.5,x, 1.5, 1);
%         pxw2 = calc_pxw(0.5,x, 3, 1);
%         px=calc_marginaldistribution(pxw1,pxw2);
%         post1=calc_posterior(pxw1,px).*px';
%         post2=calc_posterior(pxw2,px).*px';
%        %calc_conditionalerrorate(x,pxw1,pxw2) 
%        errorx = min(post1,post2);
%        sum = sum+errorx;
%        x=x+step;
%        steps=steps+1; 
%     end
%     errorrate = sum/steps;
    errorrate = quad(@(x)calc_bayeserrorate(x,pw1),-5,10);
end


function errorx = calc_bayeserrorate(x,pw1) 
   pxw1=calc_pxw(pw1,x,1.5,1); 
   pxw2=calc_pxw(1-pw1,x,3,1);
   px=calc_marginaldistribution(pxw1,pxw2);
 
   errorx = min( calc_posterior(pxw2,px)*px,calc_posterior(pxw1,px)*px);
end

function errorx = calc_conderrorate(x,pw1,boundary) 
   pxw1=calc_pxw(pw1,x,1.5,1); 
   pxw2=calc_pxw(1-pw1,x,3,1);
   px=calc_marginaldistribution(pxw1,pxw2);
   
   if (x>boundary) 
       errorx = calc_posterior(pxw2,px)*px;
   else
       errorx = calc_posterior(pxw1,px)*px;
   end   
end

function errorrate = plot_bayeserror(post1,post2,px)
    for i=1:length(post1)
        errorrate(i)=min([post1(i),post2(i)]).*px(i);
    end
end

function errorrate = plot_conditionalerror(post1,post2,px,boundary)
    x=-5;
    step=0.01;
    for i=1:length(post1)
        errorrate(i) = [post1(x<boundary) post2(x>=boundary)]*px(i);
        x=x+step;
    end
end
    



