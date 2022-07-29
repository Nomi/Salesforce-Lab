/**
 * Created by nnoman on 23.07.2022.
 */

import { LightningElement, api, wire, track } from 'lwc';
import fetchRelatedWholesalers from '@salesforce/apex/WholesalersMapController.fetchRelatedWholesalers';


export default class WholesalersMap extends LightningElement {
    @api recordId
    @track error;
    @track mapMarkers = [];
    @track markersTitle = 'Wholesalers';
    @track zoomLevel = 4;


    /* Load address from Controller */
    @wire(fetchRelatedWholesalers, {productId: '$recordId'})
    wireAccount({ error, data }) {
        if (data) {
            console.error(JSON.stringify(data));
            data.forEach(dataItem => {
                this.mapMarkers = [...this.mapMarkers,
                {
                    location: {
                        Street: dataItem.BillingStreet,
                        City: dataItem.BillingCity,
                        State: dataItem.BillingState,
                        PostalCode: dataItem.PostalCode,
                        Country: dataItem.BillingCountry,
                    },
                    icon: 'standard:address',
                    title: dataItem.Name,
                }
                ];
            });
            this.error = undefined;
        } else if (error) {
            this.error = error;
            console.error(JSON.stringify(error));
        }
    }
}