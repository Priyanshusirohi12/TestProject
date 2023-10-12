import { LightningElement } from 'lwc';

export default class Particse extends LightningElement {
    previousHandler() {
        if (this.page > 1) {
            this.page = this.page - 1;
        }
    }

    nextHandler() {
        this.page = this.page + 1;
    }
}