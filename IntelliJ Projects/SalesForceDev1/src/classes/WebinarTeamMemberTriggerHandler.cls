public with sharing class WebinarTeamMemberTriggerHandler
{
    public static void handleBeforeUpdateOrInsert(List<Webinar_Team_Member__c> webinarTeamMembers)
    {
        ///Get related webinars for the given team members
        Map<Id, Webinar__c> webinarMap = getRelatedWebinarMap(webinarTeamMembers);  //made a map for efficiently finding
        //webinars by ID
        checkIfHasBothUserAndContact(webinarTeamMembers);
        checkContactsField(webinarTeamMembers, webinarMap);
        checkIfWebMemStatusIsRejectedAndCommentFilled(webinarTeamMembers);
    }
    public static void handleBeforeInsert(List<Webinar_Team_Member__c> webinarTeamMembers)
    {
        checkForDuplicates(webinarTeamMembers);
    }

    //Private helper classes:
    private static void checkContactsField(List<Webinar_Team_Member__c> webinarTeamMembers, Map<Id, Webinar__c> webinarMap)
    {
        ///Loop through the given team members to use the checking logic.
        for (Webinar_Team_Member__c wtm : webinarTeamMembers)
        {
            if (webinarMap.get(wtm.Related_Webinar__c).Type__c != 'External')
            {
                Boolean hasContact = wtm.getPopulatedFieldsAsMap().containsKey('Contact__c');
                if (hasContact)
                {
                    wtm.addError('Only External Webinar Team Member can have Contact.');
                }
            }
        }
    }

    private static Map<Id, Webinar__c> getRelatedWebinarMap(List<Webinar_Team_Member__c> webinarTeamMembers)
    {
        Set<Id> webinarIds = new Set<Id>(); //set to only get unique ids
        for (Webinar_Team_Member__c wtm : webinarTeamMembers)
        {
            webinarIds.add(wtm.Related_Webinar__c);
        }
        List<Webinar__c> webinars = Database.query('SELECT Id, Type__c,Total_Number_of_Seats__c, Number_of_Participants__c FROM Webinar__c WHERE Id IN :webinarIds');
        Map<Id, Webinar__c> webinarMap = new Map<Id, Webinar__c>(webinars);
        return webinarMap;
    }

    private static void checkIfHasBothUserAndContact(List<Webinar_Team_Member__c> webinarTeamMembers)
    {
        for (Webinar_Team_Member__c wtm : webinarTeamMembers)
        {
            Map<String, Object> popFieldMap = wtm.getPopulatedFieldsAsMap();
            Boolean hasRelatedUser = popFieldMap.containsKey('Related_User__c'); //could have just checked !=null (I thought I couldn't because of something that happened yesterday but that was in a different context/situation but I got confused and took the saf way out.
            Boolean hasRelatedContact = popFieldMap.containsKey('Contact__c');
            if (hasRelatedUser && hasRelatedContact)
            {
                wtm.addError('Cannot have both related User and Contact.');
            }
        }
    }

    private static void checkIfWebMemStatusIsRejectedAndCommentFilled(List<Webinar_Team_Member__c> webinarTeamMembers)
    {
        for (Webinar_Team_Member__c wtm : webinarTeamMembers)
        {
            if (wtm.Status__c != 'Rejected')
            {
                continue;
            }

            Boolean hasField = wtm.getPopulatedFieldsAsMap().containsKey('Comment__c');
            if (hasField && wtm.Comment__c.length() != 0)
            {
                if (wtm.Comment__c.length() != 0)
                {
                    continue;
                }
            }

            wtm.addError('Comment should be filled for Rejected members.');
        }
    }

    private static void checkForDuplicates(List<Webinar_Team_Member__c> webinarTeamMembers)
    {
        List<Id> wtmIds = new List<Id>();
        for (Webinar_Team_Member__c wtm : webinarTeamMembers)
        {
            wtmIds.add(wtm.Id);
        }
        List<Webinar_Team_Member__c> allOldWebinarTeamMembers = [SELECT Contact__c, Related_User__c FROM Webinar_Team_Member__c WHERE Id NOT IN :wtmIds];
        Set<Id> allContactOrUserID = new Set<Id>();
        for (Webinar_Team_Member__c wtm : allOldWebinarTeamMembers)
        {
            if (wtm.Contact__c != null)
            {
                allContactOrUserID.add(wtm.Contact__c);
            }
            //else?
            if (wtm.Related_User__c != null)
            {
                allContactOrUserID.add(wtm.Related_User__c);
            }
        }

//        Map<Id,WebinarTeamMemberTriggerHandler> mp = new Map<Id, WebinarTeamMemberTriggerHandler>(webinarTeamMembers);

        for (Webinar_Team_Member__c wtm : webinarTeamMembers)
        {
            if (wtm.Contact__c != null)
            {
                if (allContactOrUserID.contains(wtm.Contact__c))
                {
                    wtm.addError('Duplicate Contact!');
                }
                else
                {
                    allContactOrUserID.add(wtm.Contact__c);
                }
            }
            if (wtm.Related_User__c != null)
            {
                if (allContactOrUserID.contains(wtm.Related_User__c))
                {
                    wtm.addError('Duplicate Related User!');
                }
                else
                {
                    allContactOrUserID.add(wtm.Related_User__c);
                }
            }
        }
    }
}