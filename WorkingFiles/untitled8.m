test1 = {'test','test','test'}; 
test2 = {'test1','test1','test1','test1'};

test = test1; 
test = {test;test2}; 

temp = test(1,:);

temp1 = test{1};

disp(temp)
disp(temp1)