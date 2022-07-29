declare module "@salesforce/apex/WebinarListController.getPendingWebinars" {
  export default function getPendingWebinars(param: {queryLimit: any}): Promise<any>;
}
declare module "@salesforce/apex/WebinarListController.changeWebinarStatus" {
  export default function changeWebinarStatus(param: {webinarId: any, status: any}): Promise<any>;
}
declare module "@salesforce/apex/WebinarListController.getAllWebinars" {
  export default function getAllWebinars(): Promise<any>;
}
declare module "@salesforce/apex/WebinarListController.getFilteredWebinars" {
  export default function getFilteredWebinars(param: {filterMap: any}): Promise<any>;
}
