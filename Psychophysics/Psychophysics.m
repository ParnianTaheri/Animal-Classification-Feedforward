clc
clear 
sca;

name = "D"; 
trial = 1;
%%
Screen('Preference', 'SkipSyncTests', 1);
[screenPointer,rect] = Screen('OpenWindow',max(Screen('Screens')),0);
xc = rect(3)/2;
yc = rect(4)/2; 
%% Write a Text on Screen

%KbName('UnifyKeyNames');
a = 'After Seeing each image choose whether its an animal!';
b = 'Press Right Arrow for animal and Left Arrow for non-animal'; 
c = ['Press Enter to continue'];
Screen('TextFont',screenPointer,'Helvetica');
Screen('TextSize',screenPointer,50); 
DrawFormattedText(screenPointer,a,'center',yc-100,[255 255 255]);
Screen('TextSize',screenPointer,30);
DrawFormattedText(screenPointer,b,'center',yc+50,[255 255 255]);
Screen('TextSize',screenPointer,20);
DrawFormattedText(screenPointer,c,'center',yc+200,[255 255 255]);
Screen('Flip', screenPointer);


ku = 0;
while ku == 0
        [secs, keyCode, deltaSecs]  = KbWait([], 2);
        ku1 = KbName(find(keyCode));
            if ku1 == "space"
                ku = 1;
            elseif ku1 == "ESCAPE"
                ku = 3;
            else
                ku = 0;
            end
end
       
%% Load Images   
folderPath = "AnimalDB/"+trial+"/";
[cI , fileNames] = readAllImages(folderPath);

%% Load FIle
directory = "Result/"+name;

% Check if the directory exists
if ~exist(directory, 'dir')
    % Create the directory if it doesn't exist
    mkdir(directory);
    disp('Directory "'+directory+ '" created.');
else
    disp('Directory "'+directory+ '" already exists.');
end

file = "Trial_"+trial+".txt";
% Open the file for writing
fileID = fopen(fullfile(directory, file), 'w');

% Check if the file was opened successfully
if fileID == -1
    error('Unable to open file for writing.');
end

% Write the name and trial to the file
fprintf(fileID, 'Name: %s \nTrial: %d\n', name, trial);

 
%% Loop
t = 0.08; 
Reaction_time = cell(length(cI),1);
animal = cell(length(cI),1);
animal_trial = cell(length(cI),1);
Confidences = cell(length(cI),1);
type = cell(length(cI),1);

true_answer = 0; false_answer = 0;
TPface = 0; TPfar = 0; TPmedium = 0; TPbody = 0;
TNface = 0; TNfar = 0; TNmedium = 0; TNbody = 0;
FPface = 0; FPfar = 0; FPmedium = 0; FPbody = 0;
FNface = 0; FNfar = 0; FNmedium = 0; FNbody = 0;
FalseNegative = 0; FalsePositive = 0; TruePositive = 0; TrueNegative = 0;

Ctrue_answer = 0; Cfalse_answer = 0;
CTPface = 0; CTPfar = 0; CTPmedium = 0; CTPbody = 0;
CTNface = 0; CTNfar = 0; CTNmedium = 0; CTNbody = 0;
CFPface = 0; CFPfar = 0; CFPmedium = 0; CFPbody = 0;
CFNface = 0; CFNfar = 0; CFNmedium = 0; CFNbody = 0;
CFalseNegative = 0; CFalsePositive = 0; CTruePositive = 0; CTrueNegative = 0;

for i = 1:length(cI)
    confidence = -1;

    %% Check files name
    if fileNames{i} == "." || fileNames{i} == ".." || fileNames{i} == ".DS_Store" 
        continue
    elseif contains(fileNames{i}, "dn_") || contains(fileNames{i}, "da_")
        animal{i} = 0;
        if startsWith(fileNames{i}, "B")
            type{i} = "body";
        elseif startsWith(fileNames{i}, "F")
            type{i} = "far";
        elseif startsWith(fileNames{i}, "M")
            type{i} = "medium";
        elseif startsWith(fileNames{i}, "H")
            type{i} = "face";
        end
    else
        animal{i} = 1;
        if startsWith(fileNames{i}, "B")
            type{i} = "body";
        elseif startsWith(fileNames{i}, "F")
            type{i} = "far";
        elseif startsWith(fileNames{i}, "M")
            type{i} = "medium";
        elseif startsWith(fileNames{i}, "H")
            type{i} = "face";
        end
    end

    %% Draw a Cross in screen
    crossLength = rect(4)*0.0278; 
    crossColor = 255;
    crossWidth = rect(4)*0.0037;
    
    crossLines = [-crossLength, 0; crossLength, 0; 0, -crossLength; 1, crossLength];
    crossLines = crossLines';
    
    Screen('DrawLines', screenPointer, crossLines, crossWidth, crossColor, [xc, yc]);
    Screen('Flip', screenPointer);
    
    WaitSecs(0.5);
    Screen('Flip', screenPointer);
    
     %% Draw a Picture in Screen
    img = cI{i};
    imre1 = [xc-200,yc-200,xc+200,yc+200];
    faceTexture = Screen('MakeTexture',screenPointer,img);
    Screen('DrawTexture',screenPointer,faceTexture, [], imre1);
    Screen('Flip', screenPointer);
    WaitSecs(0.02); 
    Screen('Flip', screenPointer);
    WaitSecs(0.03);
    
    %% Draw a Noise
    img = cI{i};
    [row, col] = size(img);
    reshaped_img  = reshape(img, 1,[]);
    shuffled_reshaped_img = Shuffle(reshaped_img);
    shuffled_img = reshape(shuffled_reshaped_img,col,row);
    imre1 = [xc-200,yc-200,xc+200,yc+200];
    faceTexture = Screen('MakeTexture',screenPointer,shuffled_img);
    Screen('DrawTexture',screenPointer,faceTexture, [], imre1);
    Screen('Flip', screenPointer);
    WaitSecs(0.08); 
    Screen('Flip', screenPointer);

    %% Getting Answer from Person
    t_start = GetSecs;
    ku = 0;
    while ku == 0 
        [secs, keyCode, deltaSecs]  = KbWait([], 2);
        ku1 = KbName(find(keyCode));
            if ku1 == "LeftArrow"
                ku = 1;
                animal_trial{i} = 0;
            elseif ku1 == "RightArrow"
                ku = 2;
                animal_trial{i} = 1;
            elseif ku1 == "ESCAPE"
                ku = 3;
            else
                ku = 0;
            end
    end
    
    if ku == 3
        break
    end
    t_end = GetSecs;
    Reaction_time{i} = round(t_end - t_start,2); 
    %% Confidence Bar
   
    
    KbName('UnifyKeyNames');
   
    x_w = rect(3);
    h5 = rect(4) * 0.6;
    
    h1 = h5 / 5;
    h2 = 2 * (h5 / 5);
    h3 = 3 * (h5 / 5);
    h4 = 4 * (h5 / 5);
    
    
    
    y1c = ((rect(4) * 0.9) - h5/5);
    
    
    
    
    
    mtr5 = [(9.5 * x_w/11) - x_w/22, (y1c + (h1 - h5)/2) - h5/2, ...
        (9.5 * x_w/11) + x_w/22,(y1c + (h1 - h5)/2) + h5/2] ;
    
    
    
    
    mtr4 = [(7.5 * x_w/11) - x_w/22, (y1c + (h1 - h4)/2) - h4/2, ...
        (7.5 * x_w/11) + x_w/22, (y1c + (h1 - h4)/2) + h4/2] ;
    
    
    
    
    mtr3 = [(5.5 * x_w/11) - x_w/22, (y1c + (h1 - h3)/2) - h3/2, ...
        (5.5 * x_w/11) + x_w/22, (y1c + (h1 - h3)/2) + h3/2] ;
    
    
    
    
    mtr2 = [(3.5 * x_w/11) - x_w/22, (y1c + (h1 - h2)/2) - h2/2, ...
        (3.5 * x_w/11) + x_w/22, (y1c + (h1 - h2)/2) + h2/2] ;
    
    
    
    
    mtr1 = [(1.5 * x_w/11) - x_w/22, y1c - h1/2, ...
        (1.5 * x_w/11) + x_w/22,y1c  + h1/2] ;
    
    
    

    answer = 0;
    count_mou_conf = 1;
    
    while answer == 0
        
       [xm,ym,buttons,~,~,~] = GetMouse(screenPointer);
        Mouse_Position_Conf(count_mou_conf,:) = [xm,ym];
        
        count_mou_conf = count_mou_conf + 1; 
        % Draw Box 
        Screen('TextFont',screenPointer,'Helvetica');
        Screen('TextSize',screenPointer,54);
        DrawFormattedText(screenPointer,'Your Confidence','center',rect(4) * 0.2,255);
    
        Screen('FillRect',screenPointer,[115 115 115],mtr1)
        Screen('FillRect',screenPointer,[115 115 115],mtr2)
        Screen('FillRect',screenPointer,[115 115 115],mtr3)
        Screen('FillRect',screenPointer,[115 115 115],mtr4)
        Screen('FillRect',screenPointer,[115 115 115],mtr5)
    
        
        Screen('TextFont',screenPointer,'Helvetica');
        Screen('TextSize',screenPointer,24);
        Screen('DrawText',screenPointer,'Very Low',(1.5 * x_w/11) - x_w/15 + rect(3) * 0.0175, ...
            y1c  + h1/2 + rect(4) * 0.025,[255,255,255]);
    
        Screen('TextFont',screenPointer,'Helvetica');
        Screen('TextSize',screenPointer,24);
        Screen('DrawText',screenPointer,'Low',(3.5 * x_w/11) - x_w/17 + rect(3) * 0.035, ...
            y1c  + h1/2 + rect(4) * 0.025,[255,255,255]);
    
        Screen('TextFont',screenPointer,'Helvetica');
        Screen('TextSize',screenPointer,24);
        Screen('DrawText',screenPointer,'Medium',(5.5 * x_w/11) - x_w/15 + rect(3) * 0.0225, ...
            y1c  + h1/2 + rect(4) * 0.025,[255,255,255]);
    
        Screen('TextFont',screenPointer,'Helvetica');
        Screen('TextSize',screenPointer,24);
        Screen('DrawText',screenPointer,'High',(7.5 * x_w/11) - x_w/17 + rect(3) * 0.033, ...
            y1c  + h1/2 + rect(4) * 0.025,[255,255,255]);
    
        Screen('TextFont',screenPointer,'Helvetica');
        Screen('TextSize',screenPointer,24);
        Screen('DrawText',screenPointer,'Very High',(9.5 * x_w/11) - x_w/15 + rect(3) * 0.0165, ...
            y1c  + h1/2 + rect(4) * 0.025,[255,255,255]);
    
        
        
        % Change Color
        if xm>= mtr1(1) && xm<= mtr1(3)
            if ym >= mtr1(2) && ym<= mtr1(4)
                Screen('FillRect',screenPointer,[255 102 0],mtr1)
            end
        end
    
        if xm>= mtr2(1) && xm<= mtr2(3)
            if ym >= mtr2(2) && ym<= mtr2(4)
                Screen('FillRect',screenPointer,[255 102 0],mtr2)
            end
        end
    
    
        if xm>= mtr3(1) && xm<= mtr3(3)
            if ym >= mtr3(2) && ym<= mtr3(4)
                Screen('FillRect',screenPointer,[255 102 0],mtr3)
            end
        end
        
        if xm>= mtr4(1) && xm<= mtr4(3)
            if ym >= mtr4(2) && ym<= mtr4(4)
                Screen('FillRect',screenPointer,[255 102 0],mtr4)
            end
        end
    
        if xm>= mtr5(1) && xm<= mtr5(3)
            if ym >= mtr5(2) && ym<= mtr5(4)
                Screen('FillRect',screenPointer,[255 102 0],mtr5)
            end
        end
        
        Screen('Flip',screenPointer);
  
        % Check box selection
        if buttons(1) == 1 
            if xm>= mtr1(1) && xm<= mtr1(3)
                if ym >= mtr1(2) && ym<= mtr1(4)
                    confidence = 1;
                    answer = 1;
                end
            end
    
            if xm>= mtr2(1) && xm<= mtr2(3)
                if ym >= mtr2(2) && ym<= mtr2(4)
                    confidence = 2;
                    answer = 1;
                end
            end
            if xm>= mtr3(1) && xm<= mtr3(3)
                if ym >= mtr3(2) && ym<= mtr3(4)
                    confidence = 3;
                    answer = 1;
                end
            end
            if xm>= mtr4(1) && xm<= mtr4(3)
                if ym >= mtr4(2) && ym<= mtr4(4)
                    confidence = 4;
                    answer = 1;
                end
            end
            if xm>= mtr5(1) && xm <= mtr5(3)
                if ym >= mtr5(2) && ym<= mtr5(4)
                    confidence = 5; 
                    answer = 1;
                end
            end
        end
%        
%         [secs, keyCode, deltaSecs]  = KbWait([], 2);
%         ku1 = KbName(find(keyCode));
%             if ku1 == "1!"
%                 answer = 1;
%                 confidence = 1;
%             elseif ku1 == "2@"
%                 answer = 1;
%                 confidence = 2;
%             elseif ku1 == "3#"
%                 answer = 1;
%                 confidence = 3;
%             elseif ku1 == "4$"
%                 answer = 1;
%                 confidence = 4;
%             elseif ku1 == "5%"
%                 answer = 1;
%                 confidence = 5;
%             else
%                 answer = 0;
%             end
    end 
    Confidences{i} = confidence;

    Screen('Flip',screenPointer); 
     
     
    %KbReleaseWait(1);
     %% Check if it's true
    if animal_trial{i} == animal{i}
        true_answer = true_answer + 1;
        Ctrue_answer = Ctrue_answer + confidence;
        if animal{i} == 1
            TruePositive = TruePositive + 1;
            CTruePositive = CTruePositive + confidence;
            if type{i} == "face"
                TPface = TPface + 1;
                CTPface = CTPface + confidence;
            elseif type{i} == "far"
                TPfar = TPfar + 1;
                CTPfar = CTPfar + confidence;
            elseif type{i} == "medium"
                TPmedium = TPmedium + 1;
                CTPmedium = CTPmedium + confidence;
            elseif type{i} == "body"
                TPbody = TPbody + 1;
                CTPbody = CTPbody + confidence;
           end
        elseif animal{i} == 0
            TrueNegative = TrueNegative + 1;
            CTrueNegative = CTrueNegative + confidence;
            if type{i} == "face"
                TNface = TNface + 1;
                CTNface = CTNface + confidence;
            elseif type{i} == "far"
                TNfar = TNfar + 1;
                CTNfar = CTNfar + confidence;
            elseif type{i} == "medium"
                TNmedium = TNmedium + 1;
                CTNmedium = CTNmedium + confidence;
            elseif type{i} == "body"
                TNbody = TNbody + 1;
                CTNbody = CTNbody + confidence;
            end
        end

    else
        false_answer = false_answer + 1;
        Cfalse_answer = Cfalse_answer + confidence;
        if animal{i} == 1
            FalseNegative = FalseNegative + 1;
            CFalseNegative = CFalseNegative + confidence;
            if type{i} == "face"
                FNface = FNface + 1;
                CFNface = CFNface + confidence;
            elseif type{i} == "far"
                FNfar = FNfar + 1;
                cFNfar = CFNfar + confidence;
            elseif type{i} == "medium"
                FNmedium = FNmedium + 1;
                CFNmedium = CFNmedium + confidence;
            elseif type{i} == "body"
                FNbody = FNbody + 1;
                CFNbody = CFNbody + confidence;
           end
        elseif animal{i} == 0
            FalsePositive = FalsePositive + 1;
            CFalsePositive = CFalsePositive + confidence;
            if type{i} == "face"
                FPface = FPface + 1;
                CFPface = CFPface + confidence;
            elseif type{i} == "far"
                FPfar = FPfar + 1;
                CFPfar = CFPfar + confidence;
            elseif type{i} == "medium"
                FPmedium = FPmedium + 1;
                CFPmedium = CFPmedium + confidence;
            elseif type{i} == "body"
                FPbody = FPbody + 1;
                CFPbody = CFPbody + confidence;
            end
        end
    end
end
%% Close  .txt file
fprintf(fileID, '\nWith Confidence Information:\n');
Caccuracy = round(Ctrue_answer/(length(cI)*5)*100,2);
fprintf(fileID, 'Accuracy:  %.2f \n', Caccuracy);

fprintf(fileID, 'Numbers of True Answers: %d / 600 \n ', Ctrue_answer);
fprintf(fileID, 'True Positive: %d / 300\n  Face: %d \n  Close Body: %d \n  Medium Body: %d \n  Far Body: %d\n ', CTruePositive, CTPface, CTPbody, CTPmedium, CTPfar);
fprintf(fileID, 'True Negative: %d / 300 \n  Face: %d \n  Close Body: %d \n  Medium Body: %d \n  Far Body: %d\n\n', CTrueNegative, CTNface, CTNbody, CTNmedium, CTNfar);

fprintf(fileID, 'Numbers of False Answers: %d\n ', Cfalse_answer);
fprintf(fileID, 'False Positive: %d\n  Face: %d \n  Close Body: %d \n  Medium Body: %d \n  Far Body: %d\n ', CFalsePositive, CFPface, CFPbody, CFPmedium, CFPfar);
fprintf(fileID, 'False Negative: %d\n  Face: %d \n  Close Body: %d \n  Medium Body: %d \n  Far Body: %d\n\n', CFalseNegative, CFNface, CFNbody, CFNmedium, CFNfar);

fprintf(fileID, '\n\nWithout Confidence Information:\n');
accuracy = round(true_answer/(length(cI))*100,2);
fprintf(fileID, 'Accuracy:  %.2f \n', accuracy);

fprintf(fileID, 'Numbers of True Answers: %d / 120 \n ', true_answer);
fprintf(fileID, 'True Positive: %d / 60\n  Face: %d \n  Close Body: %d \n  Medium Body: %d \n  Far Body: %d\n ', TruePositive, TPface, TPbody, TPmedium, TPfar);
fprintf(fileID, 'True Negative: %d / 60 \n  Face: %d \n  Close Body: %d \n  Medium Body: %d \n  Far Body: %d\n\n', TrueNegative, TNface, TNbody, TNmedium, TNfar);

fprintf(fileID, 'Numbers of False Answers: %d\n ', false_answer);
fprintf(fileID, 'False Positive: %d\n  Face: %d \n  Close Body: %d \n  Medium Body: %d \n  Far Body: %d\n ', FalsePositive, FPface, FPbody, FPmedium, FPfar);
fprintf(fileID, 'False Negative: %d\n  Face: %d \n  Close Body: %d \n  Medium Body: %d \n  Far Body: %d\n\n', FalseNegative, FNface, FNbody, FNmedium, FNfar);

 

% Convert cell array to numerical array and Compute the average
numeric_Reaction_time = cell2mat(Reaction_time);
Average_Reaction_time = mean(numeric_Reaction_time);
fprintf(fileID, 'Average Reaction Time: %.2f\n', Average_Reaction_time);

fclose(fileID); 
%% Save .mat file  
% Specify the file name of the .mat file
matFileName = "Trial_"+trial+".mat";

% Save the cells into a .mat file
save(fullfile(directory, matFileName), 'animal', 'animal_trial', 'fileNames', 'type', 'Reaction_time', 'Confidences');

%%
Screen('CloseAll');
clear Screen   

%%
% 
 