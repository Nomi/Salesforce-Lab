/**
 * Created by nnoman on 23.07.2022.
 */

public with sharing class WholesalersMapController
{
    @AuraEnabled(Cacheable=true)
    public static List<Account> fetchRelatedWholesalers(Id productId)
    {
        List<AggregateResult> aggregatedOrderItems = [
                SELECT
                        COUNT(OrderId) ProductTypeCount, Order.Account.Id, Order.Account.Name,
                        Order.Account.BillingStreet, Order.Account.BillingCity, Order.Account.BillingState,
                        Order.Account.BillingPostalCode, Order.Account.BillingCountry
                FROM
                        OrderItem
                WHERE
                        OrderItem.Product2Id = :productId
                        AND
                        Order.Account.Type__c = 'Book Wholesaler'
                GROUP BY
                        Order.Account.Id, Order.Account.Name, Order.Account.BillingStreet,
                        Order.Account.BillingCity, Order.Account.BillingState, Order.Account.BillingPostalCode,
                        Order.Account.BillingCountry
        ];
//        System.debug(aggregatedOrderItems);

        List<Account> accounts=new List<Account>();
        for(AggregateResult oi: aggregatedOrderItems)
        {
            Account acc = new Account();
            acc.Id=(String)oi.get('Id');
            acc.Name=(String)oi.get('Name');
            acc.BillingStreet=(String)oi.get('BillingStreet');
            acc.BillingCity=(String)oi.get('BillingCity');
            acc.BillingState=(String)oi.get('BillingState');
            acc.BillingPostalCode=(String)oi.get('BillingPostalCode');
            acc.BillingCountry=(String)oi.get('BillingCountry');
            accounts.add(acc);
//            system.debug(acc);
        }
//        System.debug(accounts);

        return accounts;
    }
}