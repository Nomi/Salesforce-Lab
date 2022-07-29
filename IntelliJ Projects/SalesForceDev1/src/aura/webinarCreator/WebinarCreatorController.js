/**
 * Created by nnoman on 08.07.2022.
 */

({
    onSuccessfulSubmit: function(component, event)
    {
        let webinarCreatedEv = $A.get("e.c:WebinarCreated");
        webinarCreatedEv.fire();
    }
});