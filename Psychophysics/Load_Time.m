

function time = Load_Time(name)
   

    time =  cell(10,8);
    
    for i=1:10
    folderPath = "Result/"+name+"/Trial_"+i+".mat";
    data = load(folderPath);
    
    % Reaction Time
    % Animal
    time{i,1} = get_time('face',1,data);
    time{i,2} = get_time('body',1,data);
    time{i,3} = get_time('medium',1,data);
    time{i,4} = get_time('far',1,data);
    
    % Non Animal
    time{i,5} = get_time('face',0,data);
    time{i,6} = get_time('body',0,data);
    time{i,7} = get_time('medium',0,data);
    time{i,8} = get_time('far',0,data);
    end
    
    function Reaction = get_time(type,animal, data)
        type_indices = find(strcmp(string(data.type), type));
        if animal == 1
            animal_indices = find((cell2mat(data.animal) == 1));
        else
            animal_indices = find((cell2mat(data.animal) == 0));
        end
        animal_type_indices = type_indices(ismember(type_indices,animal_indices));
        Reaction = mean(cell2mat(data.Reaction_time(animal_type_indices)));
    end
end
