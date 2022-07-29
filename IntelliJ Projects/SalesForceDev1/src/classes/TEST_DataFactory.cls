/**
 * Created by nnoman on 07.07.2022.
 */

@IsTest
public class TEST_DataFactory
{
    public static List<Account> createTestAccounts(Integer numAccounts, Boolean insertAccounts)
    {
        //Account[] accountsArr = new Account[numAccounts];
        List<Account> accounts = new List<Account>();
        for(Integer i=0;i<numAccounts;i++)
        {
            Account acc = new Account();//Name=);
            //accountsArr[i]=acc;
            accounts.add(acc);
        }
        return accounts;
    }
    public static Account createTestAccount()
    {
        Account acc = new Account(Name='TestAcc');
        insert acc;
        return acc;
    }
    public static Opportunity createTestRelatedOpportunity(Account acc)
    {
        Opportunity opp = new Opportunity(Name='TestOpp',AccountId=acc.Id,StageName='Prospecting',CloseDate=Date.today()+7);
        insert opp;
        return opp;
    }
    public static Opportunity createOpportunity()
    {
        Opportunity opp = new Opportunity(Name='TestOpp',StageName='Prospecting',CloseDate=Date.today()+7);
        return opp;
    }
}