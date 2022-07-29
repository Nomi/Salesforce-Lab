/**
 * Created by nnoman on 08.07.2022.
 */

({
    /************************************************
        Function called on component initialization.
        See <aura:handler/> in .cmp
        ************************************************/
        doInit : function(component, event, helper) {
            const actions = [
                {label: 'Approve', name: 'approveWebinar'},
                {'label' : 'Reject', 'name' : 'rejectWebinar'}
            ];
            component.set("v.columns", [
                {'label' : 'Name', 'fieldName': 'Name', 'type' : 'text'},
                {label: 'Description', fieldName: 'Description__c', type: 'text'},
                {label: 'Cost', fieldName: 'Cost__c', type: 'currency'},
                {label: 'Status', fieldName: 'Status__c', type: 'text'},
                {label: 'Approval Status', fieldName: 'Approval_Status__c', type: 'text'},
                {type: 'action', typeAttributes: {rowActions: actions}}
            ]);
            // helper function called
            helper.doInit(component, helper);
        },
        onRowActions : function(component, event, helper) {
                var action = event.getParam('action');
                var row = event.getParam('row');
//                let didConfirm=confirm(`Do you really want ${e.action.replace('Webinar','')} the webinar?`);
                switch (action.name) {
                    case 'approveWebinar':
                        helper.changeAppStat(component, helper, row.Id,'Approved');
                        break;
                    case 'rejectWebinar':
                        helper.changeAppStat(component, helper, row.Id,'Rejected');
                        break;
                }
            },
        handleWebinarCreatedEvent: function(component, event, helper)
        {
            helper.doInit(component, helper);
        }
});