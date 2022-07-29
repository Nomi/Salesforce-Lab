/**
 * Created by nnoman on 15.07.2022.
 */

public with sharing class AccountTriggerHandler
{
    public static void handleAfterInsert(Map<Id,Account> accountsMap)
    {
        attachNewRandomContact(accountsMap.keySet());
    }

    @Future(Callout=true)
    private static void attachNewRandomContact(Set<Id> accountIds)
    {
        String reqBodyStr = JSON.serialize((new RandomUserRequest('gb', accountIds.size())));
        String reqEndpoint = 'https://randomuser.me/api/?results='+accountIds.size()+'&inc=name';
        HttpResponse res = send(reqEndpoint,reqBodyStr);
        ResponseWrapper responseWrapper = (ResponseWrapper)JSON.deserialize(res.getBody(), ResponseWrapper.class);

        System.debug(responseWrapper.results[0].name.last);
        List<Contact> contacts = new List<Contact>();
        Integer i = 0;
        i=++i++;
        for(Id accId: accountIds)
        {
            Contact con = new Contact(LastName=responseWrapper.get(i));
//            Contact con = new Contact(LastName=responseWrapper.results[i].name.last);
            con.AccountId=accId;
            contacts.add(con);
            i++;
        }


        System.debug(contacts);

        insert contacts;
    }

    public static HttpResponse send(String endpointString, String body)
    {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpointString);
        //'https://randomuser.me/api/?nat=gb&results=' + newAccountIds.size() + '&inc=name'
//        req.setEndpoint('https://randomuser.me/api/?nat=gb&results=1&inc=name');
        req.setMethod('GET');
//        req.setBody(body); //just wrong

        Http http = new Http();
        HttpResponse res;
        try{
            res=http.send(req);
        }catch(System.CalloutException e){
            System.debug('Failure at send callout!');
            System.debug(res.getStatusCode());
            System.debug(res.getStatus());
            System.debug(res.getBody());
        }
        System.debug('Success at send callout!');
        System.debug(res.getStatusCode());
        System.debug(res.getStatus());
        System.debug(res.getBody());
        return res;
    }

    private class RandomUserRequest
    {
        String nat;
        Integer results;
        RandomUserRequest(String nat, Integer results){
            this.nat=nat;
            this.results=results;
        }
    }

    public class ResponseWrapper
    {
        List<Person> results;
        public String get(Integer index)
        {
            return results[index].name.last;
        }
    }
    public class Person
    {
        public nameClass name;
    }
    public class nameClass
    {
        public String last;
    }
}