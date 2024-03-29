clear;
rng(1); % For reproducibility
r = sqrt(rand(10,1)); % Radius
t = 2*pi*rand(10,1);  % Angle
data1 = [r.*cos(t), r.*sin(t), ones(10,1)]; % Points

r2 = sqrt(3*rand(10,1)+1); % Radius
t2 = 2*pi*rand(10,1);      % Angle
data2 = [r2.*cos(t2), r2.*sin(t2),ones(10,1)*2]; % points

data3 = [data1;data2];
theclass = ones(20,1);
theclass(1:10) = -1;

%Train the SVM Classifier
cl = fitcsvm(data3,theclass,'KernelFunction','rbf',...
    'BoxConstraint',Inf,'ClassNames',[-1,1]);

% Predict scores over the grid
d = 0.02;
[x1Grid,x2Grid,x3Grid] = meshgrid(min(data3(:,1)):d:max(data3(:,1)),...
    min(data3(:,2)):d:max(data3(:,2)));
xGrid = [x1Grid(:),x2Grid(:)];
[~,scores] = predict(cl,xGrid);

% Plot the data and the decision boundary
figure(1);
h(1:2) = gscatter(data3(:,1),data3(:,2),theclass,'rb','.');
hold on
ezpolar(@(x)1);
h(3) = plot(data3(cl.IsSupportVector,1),data3(cl.IsSupportVector,2),'ko');
contour(x1Grid,x2Grid,reshape(scores(:,2),size(x1Grid)),[0 0],'k');
legend(h,{'-1','+1','Support Vectors'});
axis equal
hold off