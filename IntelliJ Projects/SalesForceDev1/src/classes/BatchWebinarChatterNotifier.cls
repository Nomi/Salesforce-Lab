/**
 * Created by nnoman on 14.07.2022.
 */

/*
//How to set the scheduler (WebinarEmailNotificationScheduler) up according to the user story US-112 (using anonymous apex)//
WebinarEmailNotificationScheduler scheduledEmail = new WebinarEmailNotificationScheduler();
String sch = '0 0 9 * * ?';
String jobID = system.schedule('Batch Webinar Email Notification Job', sch, scheduledEmail);

//To get the scheduled jobs use the following two SOQL queries:
SELECT FIELDS(ALL) FROM CronJobDetail LIMIT 200;
SELECT FIELDS(ALL) FROM CronTrigger LIMIT 200;

//To delete scheduled jobs, you have to delete them from the Salesforce UI.
 */

//To use the following in anonymous apex just copy paste the start method first then the execute method.
public with sharing class BatchWebinarChatterNotifier implements Database.Batchable<sObject>
{

    public void execute(Database.BatchableContext bc, List<Webinar_Team_Member__c> webTms)
    {
        List<FeedItem> feedItems= new List<FeedItem>();
        for(Webinar_Team_Member__c wtm : webTms)
        {
            FeedItem post = new FeedItem();
//            Datetime dt = new Datetime()
//            Datetime.newInstance((long)wtm.Related_Webinar__r.Start_Time__c).format()
            post.Body =
                    'EVENT COMING UP!\n' + wtm.Related_Webinar__r.Name + ' starts ' +
                            wtm.Related_Webinar__r.Start_Date__c.format()+ ' at time: '
                            +wtm.Related_Webinar__r.Start_Time__c+ '! Don\'t miss out.\n'
                            + '[Your Webinar Team Member name: '+wtm.Name+' ]' ;
            post.ParentId = wtm.Related_User__c;
            post.Title = 'REMINDER';
            feedItems.add(post);
        }
        insert feedItems;
    }

    public void finish(Database.BatchableContext bc)
    {
    }

    public Database.QueryLocator start(Database.BatchableContext bc)
    {
        Datetime nowDateTime= System.Datetime.now(); //make this stateful??


        return Database.getQueryLocator([
                SELECT Name, Related_User__c, Related_Webinar__c,
                        Related_Webinar__r.Start_Date__c, Related_Webinar__r.Name,
                        Related_Webinar__r.Start_Time__c
                FROM Webinar_Team_Member__c
                WHERE
                        Related_Webinar__c != NULL AND Related_Webinar__r.Start_Date__c != NULL AND
                        Related_User__c != NULL AND Related_Webinar__r.Start_Time__c != NULL AND
                        Related_Webinar__r.Start_Time__c >= :nowDateTime.Time().addHours(-2) AND
                        Related_Webinar__r.Start_Time__c < :nowDateTime.Time().addHours(-1)
                ORDER BY Related_Webinar__r.Start_Date__c
        ]); //Deprecated: Related_Webinar__r.Start_Date__c = :(nowDateTime.date() + 1) AND

    }
}