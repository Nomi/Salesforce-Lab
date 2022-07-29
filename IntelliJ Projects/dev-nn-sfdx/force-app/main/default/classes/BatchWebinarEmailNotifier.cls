/**
 * Created by nnoman on 14.07.2022.
 */

/*
//How to set the scheduler (WebinarChatterNotificationScheduler) up according to the user story US-112 (using anonymous apex)//
WebinarChatterNotificationScheduler scheduledChattr = new WebinarChatterNotificationScheduler();
String sch = '0 0 * * * ?';
String jobID = system.schedule('BestJob', sch, scheduledChattr);

//To get the scheduled jobs use the following two SOQL queries:
SELECT FIELDS(ALL) FROM CronJobDetail LIMIT 200;
SELECT FIELDS(ALL) FROM CronTrigger LIMIT 200;

//To delete scheduled jobs, you have to delete them from the Salesforce UI.
 */

//To use the following in anonymous apex just copy paste the start method first then the execute method.
public with sharing class BatchWebinarEmailNotifier implements Database.Batchable<sObject>
{
    public void execute(Database.BatchableContext bc, List<Webinar_Team_Member__c> webTms)
    {
        List<Messaging.SingleEmailMessage> emailMessages= new List<Messaging.SingleEmailMessage>();
        for(Webinar_Team_Member__c wtm : webTms)
        {
            String emailBody = 'Hey ' + wtm.Contact__r.Name+',\n' + 'The event '
                            + wtm.Related_Webinar__r.Name +' starts tomorrow ('
                            + wtm.Related_Webinar__r.Start_Date__c.format()+').\n'
                            + '[Your Webinar Team Member name: '+wtm.Name+' ]';
            //add/attach actual record using recordId to email??
            Messaging.SingleEmailMessage sem = new Messaging.SingleEmailMessage();
            sem.setToAddresses(new String[]{wtm.Contact__r.Email});
            sem.setSubject('Event coming up!');
            sem.setPlainTextBody(emailBody);
            emailMessages.add(sem);
        }
        List<Messaging.SendEmailResult> result =  Messaging.sendEmail(emailMessages);
    }

    public void finish(Database.BatchableContext bc)
    {
    }

    public Database.QueryLocator start(Database.BatchableContext bc)
    {
//        Date dt = Date.today();
        return Database.getQueryLocator([
                SELECT Name, Contact__r.Name, Contact__r.Email,
                        Related_Webinar__r.Start_Date__c, Related_Webinar__r.Name
                FROM Webinar_Team_Member__c
                WHERE
                        Related_Webinar__c != NULL AND Related_Webinar__r.Start_Date__c != NULL AND
                        Contact__c != NULL AND
                        Related_Webinar__r.Start_Date__c = TOMORROW
        ]);

    }
}