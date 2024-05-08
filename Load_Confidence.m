function  confidence = Load_Confidence(name)
    confidence = cell(10,8);
    
    for i=1:10
    folderPath = "Result/"+name+"/Trial_"+i+".mat";
    data = load(folderPath);
    
    % Confidence
    % Animal
    confidence{i,1} = get_confidence('face',1,data);
    confidence{i,2} = get_confidence('body',1,data);
    confidence{i,3} = get_confidence('medium',1,data);
    confidence{i,4} = get_confidence('far',1,data);
    
    % Non Animal
    confidence{i,5} = get_confidence('face',0,data);
    confidence{i,6} = get_confidence('body',0,data);
    confidence{i,7} = get_confidence('medium',0,data);
    confidence{i,8} = get_confidence('far',0,data);
    end
    
    function conf = get_confidence(type,animal, data)
        type_indices = find(strcmp(string(data.type), type));
        if animal == 1
            animal_indices = find((cell2mat(data.animal) == 1));
        else
            animal_indices = find((cell2mat(data.animal) == 0));
        end
        animal_type_indices = type_indices(ismember(type_indices,animal_indices));
        conf =  mean(cell2mat(data.Confidences(animal_type_indices)));
    end

end