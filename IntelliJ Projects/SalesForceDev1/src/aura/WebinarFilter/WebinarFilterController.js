/**
 * Created by nnoman on 11.07.2022.
 */

({
    doInit : function(component, event, helper) {
                component.set("v.columns", [
                    {'label' : 'Name', 'fieldName': 'Name', 'type' : 'text'},
                    {label: 'Description', fieldName: 'Description__c', type: 'text'},
                    {label: 'Cost', fieldName: 'Cost__c', type: 'currency'},
                    {label: 'Status', fieldName: 'Status__c', type: 'text'},
                    {label: 'Approval Status', fieldName: 'Approval_Status__c', type: 'text'}
                ]);
                // helper function called
                helper.doInit(component, helper);
            },
    onClickFilter : function(component, event, helper)
    {
        helper.getFilteredWebinars(component, helper);
    }
});