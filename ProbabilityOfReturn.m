function ProbOfReturn
%PROBOFRETURN  Takes a data set of customer sales to find alpha and 
%                     beta for following function using regression analysis.
%
%                     P(r)=1/1+e^(-alpha*r-beta) 
%
%                     P(r) is probability that product is likely to be 
%                     returned for a given r. 

data=readtable('purchasing_order.csv'); %Varible data assigned table with all information contained in document
AllowedRatings= [1,2,3,4,5]; %As 0 means the customer didn't leave a rating

A = data(ismember(data.Return,{'Y'}),:).Customer_ID; %All customers ID's of those who returned a product 
B = data(ismember(data.Customer_ID,A),:);%All product purchase data of those who have returned at least one item

RefinedB =B(ismember(B.Rating,AllowedRatings),:);%ALl product purchase in table B that have left a rating

r=RefinedB.Rating; %All ratings for each product sold
p=ismember(RefinedB.Return,{'N'});% Info for if or not product was returned
%'N' is given value 1 and 'Y' is given value 0

lr_par = fminsearch(@(a)logreg2(a,r,p),[0 0]) %Finds alpha and beta using regression function

