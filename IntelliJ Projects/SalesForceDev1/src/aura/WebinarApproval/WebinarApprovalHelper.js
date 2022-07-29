/**
 * Created by nnoman on 08.07.2022.
 */

({
    doInit : function(component, helper) {
            // Apex function usage
            const getWebinars = component.get("c.getPendingWebinars");
            getWebinars.setParams({
                'queryLimit': component.get("v.webinarLimit")
            });
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
    changeAppStat : function(component, helper,wid, status)
        {
//            var modalBody;
//            $A.createComponent("c:modalContent", {},
//                function(content, status) {
//                    if (status === "SUCCESS") {
//                        modalBody = content;
//                        component.find('overlayLib').showCustomModal({
//                            header: "Notice",
//                            body: modalBody,
//                            showCloseButton: true,
//                            closeCallback: function() {
////                                alert('You closed the alert!');
//                            }
//                        })
//                    }
//                });
            if(confirm(`Do you really want to change webinar approval status to ${status}?`))
            {
                let rejectionReason = undefined;
                let isRejected=false;
                if(status=='Rejected')
                {
                    rejectionReason=prompt('For rejected webinars you must provide a reason for rejection')
                    isRejected=true;
                }
                if(rejectionReason || !isRejected)
                {
                     const updateWebinars = component.get("c.changeWebinarStatus");
                     updateWebinars.setParams({
                         'webinarId':wid,
                         'status': status
                     });
                     updateWebinars.setCallback(this, function(response) {
                             if (response.getState() === 'SUCCESS') {
                                 component.find("notifLibrary").showToast({
                                                             title: `Webinar approval status changed:`,
                                                             message: `Webinar ${status}!`
                                                         });
                                helper.doInit(component, helper);
                             }
                             else {
                                 component.find("notifLibrary").showToast({
                                     title: 'Something went wrong',
                                     message: response.getError()[0].message,
                                     variant: 'error'
                                 });
                             }
                         });
                    $A.enqueueAction(updateWebinars);
                }
                else
                {
                    //console log?
                }

            }
        }
});