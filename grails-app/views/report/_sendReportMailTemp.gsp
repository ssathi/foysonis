<div id="sendMailToModal" class="modal fade" role="dialog" data-backdrop="static">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Send Email</h4>
                </div>
                <form name="ctrl.mailToForm" ng-submit="sendFileViaMail()" novalidate >
                <div class="modal-body">
                    <label>Email To</label>
                    <input id="mailToAddress" name="mailToAddress" class="form-control" type="email" ng-model="ctrl.mailToAddress" placeholder = "Enter an Eamil address" required/>
                        <div class="my-messages" ng-messages="ctrl.mailToForm.mailToAddress.$error" ng-if="ctrl.mailToForm.mailToAddress.$touched || ctrl.mailToForm.$submitted">
                            <div class="message-animation" ng-message="required">
                                <strong><g:message code="required.error.message" /></strong>
                            </div>
                        </div>
                        <div class="my-messages" ng-messages="ctrl.mailToForm.mailToAddress.$error" ng-if="ctrl.mailToForm.mailToAddress.$error.email">
                            <div class="message-animation">
                                <strong>Please enter a valid email address</strong>
                            </div>
                        </div>
                    <br style="clear: both;"/>
                    <label>Subject</label>
                    <input id="mailSubject" name="mailSubject" class="form-control" type="text" ng-model="ctrl.mailSubject" placeholder = "Enter a subject"/>
                    <br style="clear: both;"/>
                    <label>Message</label>
                    <textarea class="form-control"  id="mailTextBody" name="mailTextBody" cols="3" ng-model="ctrl.mailTextBody" placeholder="This is the text body of the mail"></textarea>


                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                    <button type="submit" class="btn btn-primary">Send</button>
                </div>
                </form>
            </div>
        </div>
    </div>