function CustomerCoupons(File)
%CUSTOMERCOUPONS  Requires a data set file input of customer sales to find
%                 top customers of certain category to give coupons. 
%                 This function ranks the top customers by normalising all 
%                 average ratings and all average product values per
%                 relevant customer transaction.
Table=readtable(File);
Category = 'C' ;       % Category which customers will be selected from.
NumberOfCoupons = 100; % Number of customer id's wanted to be outputted.

%All transaction data for chosen product category and transaction data that 
%were not returned, respectively. 
Data = Table(ismember(Table.Product_Category,Category),:); 
Purchases = Data(ismember(Data.Return,{'N'}),:) ;

%All Customer ID's that bought items in chosen category.
PurchasesIDS =Purchases.Customer_ID; 
Ids= unique(PurchasesIDS);  %Removes duplicate id's

CombinedAverages=table(); %New empty table that will have averages in.

for i = 1:length(Ids) %Loop for all customer id's in 'Ids'.
   
    %Following finds, amount of transactions(returns and non-returns) and 
    %amount of purchase transactions(non-returns) for a particular ID.
    AmountOfTransactions = sum(ismember(Data.Customer_ID,Ids(i))); 
    AmountOfPurchases = sum(ismember(Purchases.Customer_ID,Ids(i)));
    
    %Sums product values of all purchases for particular ID and sums all 
    %rating's left by a particular ID.
    TotalPurchasesValue = sum(Purchases(ismember(Purchases.Customer_ID,Ids(i)),:).Product_Value);
    TotalRating = sum(Data(ismember(Data.Customer_ID,Ids(i)),:).Rating);
   
    %Find's average rating and average product value for each customer.
    AveragePurchase = TotalPurchasesValue/AmountOfPurchases;
    AverageRating = TotalRating/AmountOfTransactions;
    
    %Following adds new row for each ID to the CombinedAverages table.
    CombinedAverages=[CombinedAverages; table(Ids(i), AveragePurchase, AverageRating)]; 
end

%Biggest average purchase and biggest average rating for all customers. 
MaxPrice = max(CombinedAverages.AveragePurchase);
MaxRating = max(CombinedAverages.AverageRating); 

%Following normalises average product value and average rating data by
%dividing by the MaxPriceand MaxRating respectively.
CombinedAverages.AveragePurchase =CombinedAverages.AveragePurchase/MaxPrice; 
CombinedAverages.AverageRating = CombinedAverages.AverageRating/MaxRating;

%Squares each customers normalised average rating and average product value,
%then uses addition to get a value for each customer referred to their rank.
Ranks =((CombinedAverages.AveragePurchase).^2 + (CombinedAverages.AverageRating).^2)/2;

%Adds each customer id and respective rank to a new table.
UnsortedRankTable= table(Ids,Ranks);

%Sorts the new table from biggest to smallest rank.
RankTable = sortrows(UnsortedRankTable, 'Ranks', 'descend');

RankTable.Ids(1:NumberOfCoupons) %Outputs the customer Ids that get coupons.


