/**
 * Created by nnoman on 22.07.2022.
 */

public without sharing class CaseCreator implements Queueable {
    private List<OrderItem> orderItems;
    Map<Id,Product2> oldProducts;
    public CaseCreator(List<OrderItem> orderItems,Map<Id,Product2> oldProducts) {
        this.orderItems = orderItems;
        this.oldProducts = oldProducts;
    }
    public void execute(QueueableContext context)
    {
        List<Case> newCases = new List<Case>();
        for(OrderItem oi: this.orderItems)
        {
            if(oldProducts.get(oi.PricebookEntry.Product2Id)==null)//don't need to check for oi.Product2 because SQL query contains != null
            {
                continue;
            }
            if(oi.PricebookEntry.Product2.Release_Date__c<=oldProducts.get(oi.PricebookEntry.Product2Id).Release_Date__c)
            {
                continue;
            }
            Case c = new Case();
            c.Type = 'Release delay';
            c.Description = 'Product causing delay: ' + oi.PricebookEntry.Product2.Name;
            c.Order__c = oi.OrderId;
            newCases.add(c);
        }
        insert newCases;
    }
}