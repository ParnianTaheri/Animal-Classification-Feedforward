function [accuracy, Tcategory, Fcategory, TP, TN, FP, FN, Avg_Reaction_time] = LoadData(name)

% تغیرات زمان با افزایش ترایال
% تفاوت ری اکشن تایم برای هر دسته
% اکیورسی برای هر دسته


% In the first column confidence is included
accuracy = cell(10,2);
%Head CB MB FB
Tcategory = cell(10,4,4);
Fcategory = cell(10,4,4);
TP = cell(10,2);
TN = cell(10,2);
FP = cell(10,2);
FN = cell(10,2);
Avg_Reaction_time = cell(10,1);

numberPattern = '-?\d+\.?\d*';

for i=1:10
    m = 0;
    folderPath = "Result/"+name+"/Trial_"+i+".txt";
    fid = fopen(folderPath, 'r');

    line = fgets(fid);
    j = 1;
    while ischar(line)
        if contains(line,"Without Confidence Information:")
            j = j + 1;
            m = m - 1;
        elseif contains(line,"Accuracy")
             temp = regexp(line, numberPattern, 'match');
             accuracy{i,j} = str2double(temp{1});
             
        elseif contains(line,"Numbers of True Answers:")
             for k = 1:10
                nextLine = fgets(fid);
                if k == 1
                    temp =  regexp(nextLine, numberPattern, 'match');
                    TP{i,j} = str2double(temp{1});

                elseif k == 6
                    temp =  regexp(nextLine, numberPattern, 'match');
                    TN{i,j} = str2double(temp{1});
                    m = m + 1;
                    
                else
                    temp = regexp(nextLine, numberPattern, 'match');
                    if j == 1
                        Tcategory{i,j+m,mod((k-2-m),4)+1} = str2double(temp{1});
                    else
                        Tcategory{i,j+m,mod((k-1-m),4)+1} = str2double(temp{1});
                    end
                   
                end
             end

        elseif contains(line,"Numbers of False Answers:")
             for k = 1:10
                nextLine = fgets(fid);
                if k == 1
                    temp =  regexp(nextLine, numberPattern, 'match');
                    FP{i,j} = str2double(temp{1});

                elseif k == 6
                    temp =  regexp(nextLine, numberPattern, 'match');
                    FN{i,j} = str2double(temp{1});
                    m = m + 1;
                    
                else
                    temp = regexp(nextLine, numberPattern, 'match');
                    if j == 1
                        Fcategory{i,j+m-1,mod((k-1-m),4)+1} = str2double(temp{1});
                    else
                        Fcategory{i,j+m-1,mod((k-m),4)+1} = str2double(temp{1});
                    end
                    
                end
            end
        
        elseif contains(line,"Average Reaction Time:")
            temp =  regexp(line, numberPattern, 'match');
            Avg_Reaction_time{i} = str2double(temp{1});
        end
        line = fgets(fid);

    end
end

fclose(fid);

end