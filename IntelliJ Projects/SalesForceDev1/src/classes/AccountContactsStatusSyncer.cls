/**
 * Created by nnoman on 05.07.2022.
 */

public with sharing class AccountContactsStatusSyncer
{
    public void syncActiveStatus(List<Account> accountList)
    {
        //Get deactivated accounts in a set(not list because no duplicates).
        //Fetch contacts instead of relying on being given contacts in the the parameter list of account
        //or maps so you can get description later??
        List<Contact> modifiedContacts = new List<Contact>();
        for(Account acc: accountList)
        {
            if(acc.IsActive__c==true)
            {
                break;
            }
            for(Contact con: acc.Contacts)
            {
//                con.put('Is_Active__c',false);
                con.Is_Active__c=false;
                con.Title=acc.Description.substring(0,127);
                modifiedContacts.add(con);
            }
        }
        update modifiedContacts;
    }
}


//////Anonymous Function for Testing
//List<Account> dwnacc = new List<Account>();
//dwnacc = [SELECT Id,IsActive__c from Account];
//AccountContactsStatusSyncer cm = new AccountContactsStatusSyncer();
//cm.syncActiveStatus(dwnacc);

////OR????

//SELECT Description, IsActive__c, (SELECT Is_Active__c, Title FROM Contacts) FROM Account WHERE IsActive__c=FALSE

////OR????