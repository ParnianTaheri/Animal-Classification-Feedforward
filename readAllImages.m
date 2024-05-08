function [cI,name] = readAllImages(path, maximagesperdir)
if nargin<3
  maximagesperdir = inf;
end

fprintf('Reading images...');    
c = dir(path);
if length(c)>0
    if c(1).name == '.'
      c = c(4:end);
    end
c = Shuffle(c);
end
if length(c)>maximagesperdir
    c = c(1:maximagesperdir);
end
cI = cell(length(c),1);

name = cell(length(c),1);

for j = 1:length(c)
    cI{j} = (rgb2gray(imread([path + c(j).name])));
    name{j} = c(j).name;
end
fprintf('done.\n');
