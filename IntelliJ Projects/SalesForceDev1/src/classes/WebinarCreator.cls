/**
 * Created by nnoman on 13.07.2022.
 */

public with sharing class WebinarCreator
{
    @AuraEnabled(Cacheable=false)
    public static Id createWebinar(String name, String type, Decimal cost, Decimal price)
    {
        Webinar__c webinar = new Webinar__c();

        webinar.Name=name;
        webinar.Type__c=type;
        webinar.Cost__c=cost;
        webinar.Price_per_Currency__c=price;

        insert webinar;

        return webinar.Id;
    }
}