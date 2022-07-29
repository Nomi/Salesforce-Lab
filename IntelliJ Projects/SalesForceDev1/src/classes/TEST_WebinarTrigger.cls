/**
 * Created by nnoman on 07.07.2022.
 */

@IsTest
private class TEST_WebinarTrigger
{
    @IsTest
    private static void isAutomaticallyApprovedForCostBelow100()
    {
        Webinar__c webinar = new Webinar__c(Cost__c = 20);

        Test.startTest();
        Database.SaveResult result = Database.insert(webinar);
        Test.stopTest();

        webinar = [SELECT Id, Approval_Status__c FROM Webinar__c WHERE Id = :result.getId()];

//        System.assert(result.success);
        System.assertEquals('Approved', webinar.Approval_Status__c, 'Approval status should be Approved');
    }

    @IsTest
    private static void isNotAutomaticallyApprovedForCostAbove100()
    {
        Webinar__c webinar = new Webinar__c(Cost__c = 130);

        Test.startTest();
        Database.SaveResult result = Database.insert(webinar);
        Test.stopTest();

        webinar = [SELECT Id, Approval_Status__c FROM Webinar__c WHERE Id = :result.getId()];

//        System.assert(result.success);
        System.assertNotEquals('Approved', webinar.Approval_Status__c, 'Approval status should not be Approved');
    }

    @IsTest
    private static void checkIfStatusNotAllowedChangedFromNewToAnythingOtherThanCancelledWhileOnPending()
    {
        Webinar__c webinar = new Webinar__c(Status__c = 'New', Approval_Status__c = 'Pending');
        insert webinar;
        webinar.Status__c = 'Completed';
        DmlException de = null;
        try
        {
            Test.startTest();
            update webinar;
            Test.stopTest();
        } catch (DmlException e)
        {
            de = e;
        }

        System.assertNotEquals(null, de, 'An exception should be caught while updating.');
    }

    @IsTest
    private static void checkIfStatusAllowedToChangeFromNewToCancelledWhileOnPending()
    {
        Webinar__c webinar = new Webinar__c(Status__c = 'New', Approval_Status__c = 'Pending');
        insert webinar;
        webinar.Status__c = 'Cancelled';
        DmlException de = null;
        try
        {
            Test.startTest();
            update webinar;
            Test.stopTest();
        } catch (DmlException e)
        {
            de = e;
        }

        System.assertEquals(null, de, 'No exception should be caught.');
        System.assertEquals('Cancelled', webinar.Status__c, 'The approval status should be changed to cancelled.');
    }

    @IsTest
    private static void rejectedWebinarsGetCancelledStatus()
    {
        Webinar__c webinar = new Webinar__c();
        insert webinar;
        webinar.Approval_Status__c = 'Rejected';
        Test.startTest();
        update webinar;
        Test.stopTest();
        webinar = [SELECT Id, Status__c FROM Webinar__c WHERE Id = :webinar.Id];
        System.assertEquals('Cancelled', webinar.Status__c);
    }

    @IsTest
    private static void numParticipantsNotMoreThanSeats()
    {
        Webinar__c webinar = new Webinar__c(Total_Number_of_Seats__c = 1);
        DmlException de = null;
        Test.startTest();
        try
        {
            insert webinar;
            Webinar_Team_Member__c wtm = new Webinar_Team_Member__c(Related_Webinar__c=webinar.Id);
            insert wtm;
            webinar.Total_Number_of_Seats__c=0;
            update webinar;
        } catch (DmlException e)
        {
            de=e;
        }
        Test.stopTest();
        System.debug([SELECT Id, Number_of_Participants__c, Total_Number_of_Seats__c FROM Webinar__c WHERE Id = :webinar.Id]);
        System.assertNotEquals(null, de, 'DML exception should be thrown.');
    }
}