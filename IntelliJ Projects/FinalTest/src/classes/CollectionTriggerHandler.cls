/**
 * Created by nnoman on 22.07.2022.
 */

public with sharing class CollectionTriggerHandler
{
    public static void handleAfterInsert(List<Collection__c> changedCollections){
        changeProductStatus(changedCollections);
    }
    public static void handleBeforeUpdate(List<Collection__c> changedCollections){
        changeProductStatus(changedCollections);
    }

    /**
     * Currently, only deactivates products for Withdrawn Collections.
     * (Achieved by unchecking isActive checkbox).
     * @param collections the collections whose products' status should change appropriately.
     */
    private static void changeProductStatus(List<Collection__c> collections)
    {
        Map<Id, Collection__c> withdrawnCollectionsMap = new Map<Id, Collection__c>();
        for(Collection__c col : collections)
        {
            if(col.Status__c == 'Withdrawn')
            {
                withdrawnCollectionsMap.put(col.Id,col);
            }
        }

        List<Product2> productsToDeactivate = [
                SELECT Id, IsActive
                FROM Product2
                WHERE Collection__c IN :withdrawnCollectionsMap.keySet()
        ];
        for(Product2 prod : productsToDeactivate)
        {
            prod.IsActive = false;
        }

        update productsToDeactivate;
    }
}