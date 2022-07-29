/**
 * Created by nnoman on 22.07.2022.
 */

public with sharing class BatchOrdersProcessor implements Database.Batchable<sObject>
{
    public void execute(Database.BatchableContext bc, List<SObject> cases)
    {
    }

    public void finish(Database.BatchableContext bc)
    {
    }

    public Iterable<sObject> start(Database.BatchableContext bc)
    {
            return null;
//        return Database.getQueryLocator([
//                SELECT
//                        Id
//                        (
//                                SELECT
//                                        PricebookEntry.Product2Id,
//                                        PricebookEntry.Product2.Name,
//                                        PricebookEntry.Product2.Name,
//
//                                FROM
//                                        OrderItems
//                        )
//                FROM
//                        Order
//                WHERE
//                        AccountId=:accountId
//                        AND
//                        Id IN
//                        (SELECT OrderId FROM OrderItem WHERE PricebookEntry.Product2.Name LIKE :searchStr)
//        ]);
    }
}