/**
 * Created by nnoman on 07.07.2022.
 */

@IsTest
private class TEST_WebinarTeamMemberTrigger
{
    @IsTest
    private static void contactCannotBeAssignedToInternalWebinar()
    {
        Webinar__c webinar = new Webinar__c(Type__c='Internal');
        insert webinar;
        Contact con = new Contact(LastName='lolNOTDUPlol',MailingCountry='Poland', MailingCity='lol');
        insert con;
        Webinar_Team_Member__c wtm = new Webinar_Team_Member__c(Related_Webinar__c=webinar.Id, Contact__c=con.Id);

        DmlException de=null;
        Test.startTest();
        try
        {
//            Database.SaveResult res = Database.insert(wtm,false);
            insert wtm;
        } catch(DmlException e)
        {
            de=e;
        }
        Test.stopTest();

        System.assertNotEquals(null,de,'A DML exception should be thrown.');
//        System.assertEquals()
//        for()

    }
}