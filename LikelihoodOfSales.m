function LikelihoodOfSales(File)
%LIKELIHOODOFSALES  Requires a data set file input of customer sales and 
%                  finds the likelihood a customer will purchase another 
%                  item after retuning an item previously.
data=readtable(File);

%Vector of all Customer id's that have returned one or more items.
ReturnedIds = data(ismember(data.Return,{'Y'}),:).Customer_ID;
ReturnedIds = unique(ReturnedIds); %Removes duplicate id's.
Counter = 0;
for i = 1:length(ReturnedIds)
    %All transaction data and returned dates vector for a Customer ID i in
    %ReturnedIds vector.
    Ai = data(ismember(data.Customer_ID,ReturnedIds(i)),:);  
    ReturnedDates = Ai(ismember(Ai.Return,{'Y'}),:).Date; 
    
    % Total Value spent. 
    AllKeptItems =sum(Ai(ismember(Ai.Return,{'N'}),:).Product_Value);
    
    %All transaction data for Customer ID i after customers first return.
    PurchasesAfterReturn = Ai(Ai.Date>ReturnedDates(1),:); 
    
    %Total Value Spent after first return.
    KeptItemsAfterReturn = sum(PurchasesAfterReturn(ismember(PurchasesAfterReturn.Return,{'N'}),:).Product_Value); 
    
    %Combined likelihoods for all Customer id's as a decimal.
    Counter = Counter + KeptItemsAfterReturn/AllKeptItems; 
end
Likelihood=(Counter/length(ReturnedIds))*100



