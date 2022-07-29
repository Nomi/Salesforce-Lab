/**
 * Created by nnoman on 22.07.2022.
 */

public with sharing class ProductTriggerHandler
{
    public static void handleAfterUpdate(Map<Id,Product2> oldProductsMap)
    {
        //useful link: https://salesforce.stackexchange.com/questions/49192/after-triggers-soql-will-query-fetch-current-value-of-the-inserted-updated
        List<OrderItem> orderItemsJobQueue = [
                SELECT
                        PricebookEntry.Product2Id,
                        PricebookEntry.Product2.Release_Date__c,
                        PricebookEntry.Product2.Name,
                        OrderId
                FROM
                        OrderItem
                WHERE
                        PricebookEntry.Product2Id IN :oldProductsMap.keySet()
                AND
                        PricebookEntry.Product2.Release_Date__c != NULL
                AND
                        Order.Status IN ('Pending', 'Confirmed')

        ];

        CaseCreator caseCreatorJob = new CaseCreator(orderItemsJobQueue,oldProductsMap);
        Id jobID = System.enqueueJob(caseCreatorJob);
    }
}