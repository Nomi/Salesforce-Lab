/**
 * Created by nnoman on 06.07.2022.
 */

public with sharing class WebinarTriggerHandler
{
    public static void handleBeforeInsertOrUpdate(List<Webinar__c> webinars)
    {
        calculateNumParticipants(webinars); //temporarily commented out
        checkFreeSpaces(webinars);
        calculatePricePerParticipant(webinars);
        approveCheapWebinarsAutomatically(webinars);
    }

    public static void handleBeforeUpdate(List<Webinar__c> webinars)
    {
        cancelRejectedWebinars(webinars);
    }

    public static void handleAfterInsert(List<Webinar__c> webinars)
    {
        List<WebinarEvent__e> webinarEvents = new List<WebinarEvent__e>();
        for(Webinar__c wb: webinars)
        {
            WebinarEvent__e webinarEvent = new WebinarEvent__e();
            webinarEvent.Webinar_s_Salesforce_ID__c = wb.Id;
            webinarEvents.add(webinarEvent);
        }
        //insert webinarEvents;
        //Database.insert(webinarEvents,true);
        List<Database.SaveResult> saveResults =  EventBus.publish(webinarEvents);
//        List<Id> eventIds = new List<Id>();
        for(Database.SaveResult sr : saveResults)
        {
            System.debug('Was event publishing a success? :' + sr.isSuccess());
            /*
//            if(sr.isSuccess())
//            {
//                eventIds.add(sr.getId());
//            }
*/
        }
        /*
//        List<WebinarEvent__e> listWebinarEvents = [SELECT Webinar_s_Salesforce_ID__c FROM WebinarEvent__e WHERE Id IN :eventIds LIMIT 100];
//        for(WebinarEvent__e we : listWebinarEvents)
//        {
//            System.debug(we);
//        }
*/
    }


    public static void handleBeforeUpdateWithOldMap(List<Webinar__c> webinars, Map<Id, Webinar__c>webinarMap)
    {
        for (Webinar__c wb : webinars)
        {
            Webinar__c prevWb = webinarMap.get(wb.Id);
            if (prevWb.Status__c == 'New'
                    && wb.Status__c != 'New'
                    && wb.Status__c != 'Cancelled'
                    && wb.Approval_Status__c == 'Pending')
            {
                wb.addError('Status cannot change status from New to anything except Cancelled with a Pending approval status.');
            }
        }
    }

    private static void checkFreeSpaces(List<Webinar__c> webinars)
    {
        for (Webinar__c wb : webinars)
        {
            if (wb.Number_of_Participants__c > wb.Total_Number_of_Seats__c)
            {
                wb.addError('Number of participants cannot exceed total number of seats.');
            }
        }
    }
    private static void calculateNumParticipants(List<Webinar__c> webinars)
    {
        Map<Id, Webinar__c> webinarMap = new Map<Id, Webinar__c>([SELECT Id, (SELECT Id FROM Webinar_Team_Members__r) FROM Webinar__c WHERE Id IN :webinars]);
        Boolean zeroParticipants = false;
        if (webinarMap.size() == 0)
        {
            zeroParticipants = true;
        }
        for (Webinar__c wb : webinars)
        {
            if (zeroParticipants)
            {
                wb.Number_of_Participants__c = 0;
            }
            else
            {
                Integer numTeamMembers = webinarMap.get(wb.Id).Webinar_Team_Members__r.size();
                wb.Number_of_Participants__c = numTeamMembers;
                if (numTeamMembers > wb.Total_Number_of_Seats__c)
                {
                    wb.addError('Number of team members exceeds the number of available seats.');
                }
            }
        }
    }

    private static void approveCheapWebinarsAutomatically(List<Webinar__c> webinarsToCheck)
    {
        for (Webinar__c wb : webinarsToCheck)
        {
            if (wb.Cost__c < 100 && (wb?.Approval_Status__c == 'Pending')) //what about currency though?
            {
                wb.Approval_Status__c = 'Approved';
            }
        }
    }

    private static void cancelRejectedWebinars(List<Webinar__c> webinarsToCheck)
    {
        for (Webinar__c wb : webinarsToCheck)
        {
            if (wb.Approval_Status__c == 'Rejected')
            {
                wb.Status__c = 'Cancelled';
            }
        }
    }

    private static void calculatePricePerParticipant(List<Webinar__c> webinars)
    {
        for (Webinar__c wb : webinars)
        {
            if (wb.Number_of_Participants__c != 0)
            {
                wb.Price_per_Currency__c = wb.Cost__c / wb.Number_of_Participants__c;
            }
        }
    }
}