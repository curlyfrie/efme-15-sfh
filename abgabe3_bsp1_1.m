function[] =  abgabe3_bsp1_1()


% the given propabilitys
pw1 = 0.5;
pw2 = 1 - pw1;
scale = -5:0.1:10;

y11 = normcdf(scale,1.5,1);
y22 = normcdf(scale,3,1);
py11 = pw1 * y11;
py22 = pw2 * y22;

% calculate propabilitys
pxw1  = calc_pxw(pw1,scale,1.5,1);
pxw2  = calc_pxw(pw2,scale,3,1);
px =    calc_marginaldistribution(pxw1,pxw2);
post1 = calc_posterior(pxw1,px);
post2 = calc_posterior(pxw2,px);

% get error rates

% Conditional Error
cond = calc_conditionalerror(post1,post2);

errorrate1 = calc_errorrate(post1,px);


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
plot(scale,errorrate1);
%plot(scale,pw1-py11(:)+py22(:),'red--')
hold on
plot(scale,cond,'red')

plot(scale,py11,'blue--')
hold on
plot(scale,py22,'green--')
hold on

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

function errorrate = calc_errorrate(post,px)
    errorrate = post.*px;
end

function errorrate = bayeserrorrate()
    
end

% calculates the conditional error rate
function errorrate = calc_conditionalerror(post1,post2)
    for i=1:length(post1)
        errorrate(i)=min([post1(i),post2(i)]);
    end
end





