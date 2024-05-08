clc
clear

names = ["R","P","H"];
len = length(names);
accuracy = cell(len,1); Tcategory = cell(len,1); Fcategory = cell(len,1);
TP = cell(len,1); TN = cell(len,1); FP = cell(len,1); FN = cell(len,1);
Avg_Reaction_time = cell(len,1); conf = cell(len,1); time = cell(len,1);

for i = 1:numel(names)
    name = names(i);
    [accuracy{i}, Tcategory{i}, Fcategory{i}, TP{i}, TN{i}, FP{i}, FN{i}, Avg_Reaction_time{i}] = LoadData(name);
    conf{i} = Load_Confidence(name);
    time{i} = Load_Time(name);
end
%% Average

avg_rt = 0; avg_acc = 0; avg_Tcategory = 0;
cat_avg_rt = 0; cat_avg_conf = 0;
avg_TP = 0; avg_TN = 0; avg_FP = 0; avg_FN = 0;
for i=1:size(accuracy,1)
    avg_acc = avg_acc + cell2mat(accuracy{i});
    avg_rt = avg_rt + cell2mat(Avg_Reaction_time{i});
    cat_avg_rt = cat_avg_rt + cell2mat(time{i});
    cat_avg_conf = cat_avg_conf + cell2mat(conf{i});
    avg_Tcategory = avg_Tcategory + cell2mat(Tcategory{i});
    avg_TP = avg_TP + cell2mat(TP{i});
    avg_TN = avg_TN + cell2mat(TN{i});
    avg_FP = avg_FP + cell2mat(FP{i});
    avg_FN = avg_FN + cell2mat(FN{i});
end
avg_rt = avg_rt/len; avg_acc = avg_acc/len;
cat_avg_rt = cat_avg_rt/len; cat_avg_conf = cat_avg_conf/len;
avg_Tcategory = avg_Tcategory/len; 
avg_Tcategory = reshape(mean(avg_Tcategory,1),[4, 4]);
avg_TP = avg_TP/len; avg_TN = avg_TN/len; avg_FP = avg_FP/len; avg_FN = avg_FN/len;

%%
temp = mean(avg_TP,1);
cat_avg_TP = temp(1);
avg_TP = temp(2);

temp = mean(avg_TN,1);
cat_avg_TN = temp(1);
avg_TN = temp(2);

temp = mean(avg_FP,1);
cat_avg_FP = temp(1);
avg_FP = temp(2);

temp = mean(avg_FN,1);
cat_avg_FN = temp(1);
avg_FN = temp(2);

%% Average Acc & Time
avg_rt = mean(avg_rt,1);
temp = mean(avg_acc,1);
cat_avg_acc = temp(1);
avg_acc = temp(2);

%% Confidence & Time for Each Category
mean_cat_avg_rt = mean(cat_avg_rt,1);
mean_cat_avg_conf = mean(cat_avg_conf,1);

x = ["Head","Close Body", "Medium Body","Far Body"];

% Reaction time
figure
% Plot the bar chart
y1 = mean_cat_avg_rt(1:4);
y2 = mean_cat_avg_rt(5:8);
bar(y2);
for i = 1:numel(y1)
    text(i, y1(i), num2str(y1(i)), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end
hold on

bar(y1);
for i = 1:numel(y2)
    text(i, y2(i), num2str(y2(i)), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end

hold off
legend("non-animal","animal")
set(gca, 'XTickLabel', x);
xlabel('Categories');
ylabel('Reaction Time');
title('Reaction Time for Animal vs non-Animal');
% Add grid lines
grid on;

% Confidence
figure
% Plot the bar chart
y1 = mean_cat_avg_conf(1:4);
y2 = mean_cat_avg_conf(5:8);
bar(y2);
for i = 1:numel(y1)
    text(i, y1(i), num2str(y1(i)), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end
hold on

bar(y1);
for i = 1:numel(y2)
    text(i, y2(i), num2str(y2(i)), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end

hold off
legend("non-animal","animal")
set(gca, 'XTickLabel', x);
xlabel('Categories');
ylabel('Confidence');
title('Confidence Rate for Animal vs non-Animal');
% Add grid lines
grid on;
%% Accuracy for animal vs non-animal
y = (avg_Tcategory(1,:))/75*100;
conf_y_animal = reshape(y,[1,4]);

y = (avg_Tcategory(2,:))/75*100;
conf_y_nonAnimal = reshape(y,[1,4]);
x = ["Head","Close Body", "Medium Body","Far Body"];

figure
% Plot the bar chart
bar(conf_y_nonAnimal);
for i = 1:numel(conf_y_nonAnimal)
    text(i, conf_y_nonAnimal(i), num2str(conf_y_nonAnimal(i)), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end
hold on

bar(conf_y_animal);
for i = 1:numel(conf_y_animal)
    text(i, conf_y_animal(i), num2str(conf_y_animal(i)), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end

hold off
legend("non-animal","animal")
set(gca, 'XTickLabel', x);
xlabel('Categories');
ylabel('Accuracy');
title('Accuracy for Animal vs non-Animal with confidence');
% Add grid lines
grid on;

% without confidence
y = (avg_Tcategory(3,:))/75*100;
y_animal = reshape(y,[1,4]);

y = (avg_Tcategory(4,:))/75*100;
y_nonAnimal = reshape(y,[1,4]);
x = ["Head","Close Body", "Medium Body","Far Body"];

figure
% Plot the bar chart
bar(y_nonAnimal);
for i = 1:numel(y_nonAnimal)
    text(i, y_nonAnimal(i), num2str(y_nonAnimal(i)), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end
hold on

bar(y_animal);
for i = 1:numel(y_animal)
    text(i, y_animal(i), num2str(y_animal(i)), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end

hold off
legend("non-animal","animal")
set(gca, 'XTickLabel', x);
xlabel('Categories');
ylabel('Accuracy');
title('Accuracy for Animal vs non-Animal without confidence');
% Add grid lines
grid on;


%% Check the accuracy for each category
y = (avg_Tcategory(1,:)+avg_Tcategory(2,:))/150*100;
y = reshape(y,[1,4]);

x = ["Head","Close Body", "Medium Body","Far Body"];

figure
% Plot the bar chart
bar(y);
set(gca, 'XTickLabel', x);
xlabel('Categories');
ylabel('Accuracy');
title('Accuracy for Each Category Including Confidence');
% Add grid lines
grid on;
for i = 1:numel(y)
    text(i, y(i), num2str(y(i)), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end

y = (avg_Tcategory(3,:)+avg_Tcategory(4,:))/30*100;
y = reshape(y,[1,4]);
figure
% Plot the bar chart
bar(y);
set(gca, 'XTickLabel', x);
xlabel('Categories');
ylabel('Accuracy');
title('Accuracy for Each Category');
% Add grid lines
grid on;

for i = 1:numel(y)
    text(i, y(i), num2str(y(i)), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end
