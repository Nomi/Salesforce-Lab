/**
 * Created by nnoman on 11.07.2022.
 */

({
    doInit : function(component, helper) {
            // Apex function usage
            const getWebinars = component.get("c.getAllWebinars");
            getWebinars.setCallback(this, function(response) {
                if (response.getState() === 'SUCCESS') {
                    component.set("v.webinars", response.getReturnValue());
                }
                else {
                    console.log('Something went wrong');
                }
            });
            $A.enqueueAction(getWebinars);
            // End of apex function call
        },
    getFilteredWebinars : function(component, helper) {
        let filterFieldStringMap = {
            Type__c: component.get("v.typeString"),
            Status__c: component.get("v.statusString")
        }

        // Apex function usage
        const getFilteredWebinars = component.get("c.getFilteredWebinars");
        getFilteredWebinars.setParams(
            {
                filterMap : filterFieldStringMap
            }
        )
        console.error('filterMap')
        console.error(filterMap)
        getWebinars.setCallback(this, function(response) {
            if (response.getState() === 'SUCCESS') {
                component.set("v.webinars", response.getReturnValue());
            }
            else {
                console.log('Something went wrong');
            }
        });
                console.error('filterMap')
        $A.enqueueAction(getFilteredWebinars);
        // End of apex function call
    }
});