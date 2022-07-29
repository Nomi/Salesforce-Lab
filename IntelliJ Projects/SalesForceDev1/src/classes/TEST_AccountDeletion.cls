/**
 * Created by nnoman on 07.07.2022.
 */
/**
 * Tests for deletion of accounts.
 */
@IsTest
private class TEST_AccountDeletion
{
    @TestSetup
    private static void makeData()
    {
//        Account acc =TEST_DataFactory.createTestAccount();
////        acc = [SELECT Id FROM Account WHERE Name = :acc.Name];
//        Opportunity opp = TEST_DataFactory.createTestRelatedOpportunity(acc);
    }

    @IsTest
    private static void deletingAccountWithoutRelatedOpportunitySucceeds()
    {
        Account acc= TEST_DataFactory.createTestAccount();

        DmlException thrownException;
        Database.DeleteResult result=null;

        Test.startTest();
        try
        {
            result = Database.delete(acc.Id);
        } catch (DmlException e)
        {
            thrownException=e;
        }
        Test.stopTest();

        System.assert(result.isSuccess(),'Should succeed.');
        System.assert(result.getErrors().size()==0,'No account failed.');
     }

    @IsTest
    private static void deletingAccountWithoutRelatedOpportunityFails()
    {
        Account acc= TEST_DataFactory.createTestAccount();
        Opportunity opp = TEST_DataFactory.createTestRelatedOpportunity(acc);

        DmlException thrownException;
        Database.DeleteResult result=null;

        Test.startTest();
        try
        {
            result = Database.delete(acc.Id);
        } catch (DmlException e)
        {
            thrownException=e;
        }
        Test.stopTest();

        System.assertEquals(null,result,'Delete statement shouldn\'t get result for invalid operations.');
        System.assertEquals('System.DmlException',thrownException.getTypeName(),'Should throw the correct exception for invalid operations');
    }

}