/**
 * Created by nnoman on 08.07.2022.
 */

public with sharing class WebinarListController
{
    @AuraEnabled
    public static Webinar__c[] getPendingWebinars(String queryLimit)
    {
        return [
                SELECT Name,Description__c,Cost__c,Status__c,Approval_Status__c
                FROM Webinar__c
                WHERE Approval_Status__c = 'Pending'
                LIMIT :Integer.valueOf(queryLimit)
        ];
    }
    @AuraEnabled
    public static Webinar__c changeWebinarStatus(Id webinarId,String status)
    {
        Webinar__c wb = [SELECT Id FROM Webinar__c WHERE Id=:webinarId];
        wb.Approval_Status__c=status;
        update wb;
        return wb;
    }
    @AuraEnabled
    public static Webinar__c[] getAllWebinars()
    {
        return [
                SELECT Name,Description__c,Cost__c,Status__c,Approval_Status__c,Type__c
                FROM Webinar__c
        ];
    }

    @AuraEnabled
    public static Webinar__c[] getFilteredWebinars(Map<String,String> filterMap)
    {
        String filterPart='';

        if(filterMap.size()>0)
            filterPart += ' WHERE ';

        List<String> filterList=new List<String>();
        for(String key : filterMap.keySet())
        {
            filterList.add(key + ' LIKE \'%' + String.escapeSingleQuotes(filterMap.get(key))  + '%\'');
        }
        String finalString = String.join(filterList,' AND ');
        System.debug(finalString);
        return
                Database.query(
                        'SELECT Name,Description__c,Cost__c,Status__c,Approval_Status__c,Type__c ' +
                        'FROM Webinar__c'+
                         finalString
                )
        ;
    }

}