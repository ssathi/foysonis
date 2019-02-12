<html>
<head>
    <meta name="layout" content="foysonis2016"/>

    %{--Signup form--}%
    %{--<asset:javascript src="signup/angular.min.js"/>--}%
    <asset:javascript src="signup/angular-aria.min.js"/>
    <asset:javascript src="signup/angular-messages.min.js"/>
    <asset:javascript src="signup/angular-animate.min.js"/>

    %{--<asset:javascript src="datagrid/angular.js"/>--}%
    <asset:javascript src="datagrid/angular-touch.js"/>
    <asset:javascript src="datagrid/angular-animate.js"/>
    <asset:javascript src="datagrid/csv.js"/>
    <asset:javascript src="datagrid/pdfmake.js"/>
    <asset:javascript src="datagrid/vfs_fonts.js"/>
    <asset:javascript src="datagrid/ui-grid.js"/>
    <asset:javascript src="dragAndDrop/angular-drag-and-drop-lists"/>
    <asset:javascript src="ng-img-crop.js"/>
    %{--<link rel="stylesheet" href="http://ui-grid.info/release/ui-grid.css" type="text/css">--}%
    %{--<asset:stylesheet src="datagrid/ui-grid.css"/>--}%

    %{--Sign Up Form--}%
    <asset:stylesheet src="signup/style.css"/>
    <asset:stylesheet src="signup/animations.css"/>
    <asset:stylesheet src="ng-img-crop.css"/>

  
<%-- *************************** CSS for Location Grid **************************** --%>
    <style>

    td.selected-class-name {
        color: white;
        font-weight: bold;
        background-color: #006dba;
        text-decoration: none;

    }
    td.selected-class-name a:focus {
        color: white;
        font-weight: bold;
        background-color: #006dba;
        text-decoration: none;
    }
    td.selected-class-name a {
        color: white;
        font-weight: bold;
        background-color: #006dba;
        text-decoration: none;
    }

    .grid {
        height:420px;
        width: 950px;
    }

    .grid-align {
        text-align: center;
    }

    .noItemMessage {
        position: absolute;
        top : 30%;
        opacity: 0.4;
        font-size: 40px;
        width: 100%;
        text-align: center;
        z-index: auto;
    }

    hr { 
        border-style: solid;
        border-width: 2px;
    }

    .labelLook{         
        font-size: 15px;
        font-weight: normal;
    }

    .cropArea {
      background: #333333;
      overflow: hidden;
      width:500px;
      height:350px;
    }

    .compLogo {
        width:150px; 
        height:150px; 
        border: 2.5px solid #315d90;
        background: #eaeae1;
        //box-shadow: 9px 8px 21px -9px rgba(0,0,0,0.75);
    }

    .comInfo {
        //border-left: 4px solid #315d90;
        //box-shadow: -13px 2px 16px -13px rgba(0,0,0,0.5);
    }

    .btn-upload {
        color: #000000;
        background-color: #ffffff;
        border: 1px solid #000000 !important;
        border-radius: 0px;
        width: 150px;
    }
     .fileinput-button {
        position: relative;
        overflow: hidden;
    }
     .fileinput-button input {
        position: absolute;
        top: 0;
        right: 0;
        margin: 0;
        opacity: 0;
        -ms-filter:'alpha(opacity=0)';
        font-size: 200px;
        direction: ltr;
        cursor: pointer;
    }

    .compEdit-Btn{
        background-color: #22a49c !important;
        height: 37px;
        line-height: 1;
        border: 0px;
    }

    .customer-modal-dialog {
      width: 100%;
      height: 100%;
      margin: 0;
      padding: 0;
    }

    .customer-modal-content {
      height: auto;
      min-height: 100%;
      border-radius: 0;
    }


    .customer-modal-header {
      background: #547CA2;
      height: 70px;
    }

    .customer-panel-title {
        margin-top: -30px;
        color: #ffffff;
    }

    .customer-modal-body {
      position: fixed;
      top: 70px;
      bottom: 70px;
      width: 100%;
      overflow: scroll;
    }

    .customer-modal-footer {
      position: fixed;
      right: 0;
      bottom: 0;
      left: 0;
      border-top: 2px solid #547CA2;
      height: 70px;
    }

    .customer-close {
        color: #FFFFFF;
        opacity: 1;
    }


    [ng\:cloak], [ng-cloak], [data-ng-cloak], [x-ng-cloak], .ng-cloak, .x-ng-cloak {
        display: none !important;
    }

    </style>

<%-- **************************** End of CSS **************************** --%>

</head>

<body>


    <div ng-cloak class="row" id="dvAdminCompanyProfile" ng-controller="companyProfileCtrl as ctrl">
    <div style="display: inline;"><em class="fa  fa-fw mr-sm" ><img style="width: 30px; padding-bottom: 3px;" src="/foysonis2016/app/img/companyProfile_header.svg"></em>&emsp;&nbsp;<span class="headerTitle" style="vertical-align: bottom;">Company Profile
            </span></div>
            <hr style="border:0.5px solid #d6d5d5;">
        <div class="col-lg-12">


    <h3>Profile Info</h3>

            <!-- START panel-->

                        <%-- **************************** update company form **************************** --%>

                            <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showUpdatedPrompt">
                                <g:message code="companyProfile.updated.message" />
                            </div>
                            <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showAddressUpdatedPrompt">
                                Company address has been successfully updated.
                            </div>

                                <form name="ctrl.updateCompanyInfoForm" ng-submit="ctrl.updateCompany()" novalidate >

                                    <div class="panel panel-default" id="panel-anim-fadeInDown">
                                        <div class="panel-heading">
                                            <div class="panel-title">
                                                <button class="btn btn-warning compEdit-Btn pull-right" type="button" ng-click="ctrl.editCompany()" ng-if="!ctrl.profileEditable">
                                                <em class="fa fa-edit fa-fw mr-sm"></em>Edit</button>
                                                </div>
                                        </div>
                                        <div class="panel-body" ng-show="ctrl.profileEditable">
                                            <div class="col-md-12">
                                                <div class="col-md-3">
                                                   <label>Select a company logo image : </label>
                                                   <div style="padding-bottom: 3px;">
                                                        <span class="btn btn-default btn-upload fileinput-button">
                                                            <span>Choose File</span>
                                                            <input type="file" id="fileInput"/>
                                                        </span>
                                                   </div>
                                                   <div class='compLogo'><img src="{{myCroppedImage}}" /></div>
                                                   <br style="clear:both;" />
                                                   <p ng-if='invalidFileSize' style="color:#F51B1B; font-weight:bold; font-size: 13px;">The file is bigger than 1MB.</p>
                                                   <p ng-if='invalidFileType' style="color:#F51B1B; font-weight:bold; font-size: 13px;">This is an invalid file type, Please upload a file in JPEG or PNG formats </p>
                                                </div>
                                                <div class="col-md-4" style="padding-top: 80px;
">

                                                    <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('companyId')}">

                                                        <label for="companyId">Company Id</label>
                                                        <input id="companyId" name="companyId" class="form-control" type="text"    ng-model="ctrl.companyInfo.companyId" disabled />
                                                    </div>

                                                    <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('gsiCompPrefix')}">
                                                        <label for="gsiCompPrefix">GS1 Company Prefix</label>
                                                        <input id="gsiCompPrefix" name="gsiCompPrefix" class="form-control" type="test" ng-model="ctrl.companyInfo.gsiCompPrefix" ng-pattern="/^$|^[0-9X]{7}$/" placeholder="This will be used on Bill Of Lading" />

                                                        <div class="my-messages" ng-messages="ctrl.updateCompanyInfoForm.gsiCompPrefix.$error" ng-if="!ctrl.updateCompanyInfoForm.gsiCompPrefix.$valid">
                                                            <div class="message-animation">
                                                                <strong>This GS1 code is not valid.</strong>
                                                            </div>
                                                        </div>

                                                    </div>

                                                </div>
                                                <div class="col-md-4" style="padding-top: 80px;
">
                                                    <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('companyName')}">
                                                        <label for="companyName">Company Name</label>
                                                        <input id="companyName" name="companyName" class="form-control" type="text"    ng-model="ctrl.companyInfo.companyName" required />


                                                        <div class="my-messages" ng-messages="ctrl.updateCompanyInfoForm.companyName.$error" ng-if="ctrl.showMessages('companyName')">
                                                            <div class="message-animation" ng-message="required">
                                                                <strong>This field is required.</strong>
                                                            </div>
                                                        </div>

                                                    </div>

                                                    <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('noOfUsers')}">
                                                        <label for="noOfUsers">No. Of Licenced Users</label>
                                                        <input id="noOfUsers" name="noOfUsers" class="form-control" type="number"  nim=1  ng-model="ctrl.companyInfo.noOfUsers" ng-model-options="{ updateOn : 'blur' }" disabled />
                                                    </div>
                                                </div>


                                            </div>
                                             <!-- <div class="col-md-12">


                                                <div class="col-md-6">

                                                    <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('companyBillAddrs')}">
                                                        <label for="companyBillAddrs">Company Billing Address</label>
                                                        <textarea id="companyBillAddrs" name="companyBillAddrs" rows = '5' class="form-control" type="text" ng-model="ctrl.companyInfo.companyBillAddrs" ng-model-options="{ updateOn : 'blur' }" /></textarea>
                                                    </div>  

                                                </div>    

                                                <div class="col-md-6">

                                                    <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('companyShipAddrs')}">
                                                        <label for="companyShipAddrs">Company Shipping Address</label>
                                                        <textarea id="companyShipAddrs" name="companyShipAddrs" rows='5' class="form-control" ng-model="ctrl.companyInfo.companyShipAddrs" ng-model-options="{ updateOn : 'blur' }" /></textarea>
                                                    </div>  

                                                </div> 
                                          </div> -->
                                    </div>
                                        <div class="panel-body" ng-hide="ctrl.profileEditable">
                                            <div class="col-md-12">
                                                <div class="col-md-3">
                                                    <label>Company Logo</label>
                                                       <!-- <div class="cropArea">
                                                        <img-crop image="myImage" area-type="square" result-image-size="200" result-image="myCroppedImage"></img-crop>
                                                        </div> -->
                                                        <div class='compLogo'><img src="{{myCroppedImage}}" /></div>
                                                        <br style="clear:both;" />
                                                </div>
                                                 <div class="col-md-9 comInfo">

                                                        <label class="labelLook">Company Id&emsp;:&emsp;{{ctrl.companyInfo.companyId}}</label>
                                                        <br style="clear:both;" />
                                                        <br style="clear:both;" />

                                                        <label class="labelLook">GS1 Company Prefix&emsp;:&emsp;{{ctrl.companyInfo.gsiCompPrefix}}</label>
                                                        <br style="clear:both;" />
                                                        <br style="clear:both;" />

                                                        <label class="labelLook">Company Name&emsp;:&emsp;{{ctrl.companyInfo.companyName}}</label>
                                                        <br style="clear:both;" />
                                                        <br style="clear:both;" />

                                                        <label class="labelLook">No. Of Licenced Users&emsp;:&emsp;{{ctrl.companyInfo.noOfUsers}}</label>
                                                        <br style="clear:both;" />
                                                        <br style="clear:both;" />

                                                        <label class="labelLook">Company Shipping Address&emsp;:</label>
                                                        <label class="labelLook">{{ctrl.companyDisplayAddress.billingStreetAddress}}&nbsp;
                                                        {{ctrl.companyDisplayAddress.billingCity}}&nbsp;
                                                        {{ctrl.companyDisplayAddress.billingState}}&nbsp;{{ctrl.companyDisplayAddress.billingPostCode}}&nbsp;{{ctrl.companyDisplayAddress.billingCountry}}</label>
                                                        <br style="clear:both;" />
                                                        <br style="clear:both;" />

                                                        <label class="labelLook">Company Billing Address&emsp;:</label>
                                                        <label class="labelLook">{{ctrl.companyDisplayAddress.shippingStreetAddress}}&nbsp;
                                                        {{ctrl.companyDisplayAddress.shippingCity}}&nbsp;
                                                        {{ctrl.companyDisplayAddress.shippingState}}&nbsp;{{ctrl.companyDisplayAddress.shippingPostCode}}&nbsp;{{ctrl.companyDisplayAddress.shippingCountry}}</label>
                                                        <br style="clear:both;" />
                                                        <button class="btn btn-warning compEdit-Btn" type="button" ng-click="ctrl.showCompanyAddressEditForm()" ng-if="!ctrl.profileEditable">
                                                <em class="fa fa-edit fa-fw mr-sm"></em>Edit Company Address</button>
                                                        

                                              </div>
                                          </div>
                                    </div>                                    
                                        <div class="panel-footer">   
                                            <div class="pull-left" ng-show="ctrl.profileEditable">
                                                <button style="width:100px; height: 37px; " class="btn btn-default" type="button" ng-click="ctrl.cancelUpdateCompany()">Cancel</button> &emsp;&emsp;
                                            </div>
                                            <div class="pull-left" ng-show="ctrl.profileEditable">
                                                <button style="width:100px; height: 37px" class="btn btn-primary" type="submit">Update</button>
                                            </div>                                         
                                            <br style="clear: both;"/>
                                        </div>                                  
                                  </div>  
                                </form>
<%-- **************************** End of company form **************************** --%>

        </div>
        <br style="clear: both;"/>


        <div class="col-lg-12">


    <h3>Integration configurations</h3>

            <!-- START panel-->
                        <%-- **************************** update company easy post form **************************** --%>

                            <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showApiUpdatedPrompt">
                                <g:message code="companyProfile.easyPost.updated.message" />
                            </div>

                                <form name="ctrl.updateCompanyApiForm" ng-submit="ctrl.validateKeys()" novalidate >

                                    <div class="panel panel-default" id="panel-anim-fadeInDown">
                                        <!-- <div class="panel-heading">
                                            <div class="panel-title">
                                                <button class="btn btn-warning compEdit-Btn pull-right" type="button" ng-click="ctrl.editCompany()" ng-if="!ctrl.profileEditable">
                                                <em class="fa fa-edit fa-fw mr-sm"></em>Edit</button>
                                                </div>
                                        </div> -->
                                        <div class="panel-body">
                                             <div class="col-md-12">
                                                 <h4>Easypost Configurations</h4>

                                                 <div class="col-md-12">
                                                     <div class="form-group">
                                                         <label for="isEasyPostEnabled">is Easy Post Enabled ?</label>
                                                         <div class="checkbox c-checkbox">
                                                             <label>
                                                                 <input id="isEasyPostEnabled" name="isEasyPostEnabled" type="checkbox" ng-model="ctrl.companyInfoApi.isEasyPostEnabled" ng-change="ctrl.switchEasyPostBtn($event)">
                                                                 <span class="fa fa-check"></span>
                                                             </label>
                                                         </div>

                                                     </div>
                                                 </div>

                                                <div class="col-md-6">

                                                    <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('prodApiKey')}">
                                                        <label for="prodApiKey"> EasyPost Production API Key</label>
                                                        <input id="prodApiKey" name="prodApiKey" class="form-control" type="text"  nim=1  ng-model="ctrl.companyInfoApi.easyPostProdApiKey" ng-model-options="{ updateOn : 'blur' }" />

                                                        <div class="my-messages"  ng-messages="ctrl.updateCompanyApiForm.prodApiKey.$error"
                                                             ng-if="ctrl.prodApiKeyInvalid">
                                                            <div class="message-animation" >
                                                                <strong>Production API Key is not valid</strong>
                                                            </div>
                                                        </div>

                                                    </div>

                                                </div>

                                          </div>
                                    </div>
                                        <div class="panel-footer">
                                            <!-- <div class="pull-left" ng-show="ctrl.profileEditable">
                                                <button style="width:100px; height: 37px; " class="btn btn-default" type="button" ng-click="ctrl.cancelUpdateCompany()">Cancel</button> &emsp;&emsp;
                                            </div> -->
                                            <div class="pull-left">
                                                <button style="width:100px; height: 37px" class="btn btn-primary" type="submit" ng-disabled="ctrl.disableApiBtn">{{ctrl.updateApiBtnText}}</button>
                                            </div>
                                            <br style="clear: both;"/>
                                        </div>
                                  </div>
                                </form>
<%-- **************************** End of company easy post form **************************** --%>

            %{--Start of quickbooks integration--}%

            <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showQuickBooksUpdatedPrompt">
            The Quickbooks configuration has been updated successfully.
            </div>

            <form name="ctrl.updateQuickbooksForm" ng-submit="ctrl.updateQuickBooksConfiguration()" novalidate >

                <div class="panel panel-default" id="panel-anim-fadeInDown">

                    <div class="panel-body">
                        <div class="col-md-12">
                            <h4>Quickbooks Configurations</h4>

                            <div class="col-md-12">
                                <div class="form-group">
                                    <label for="isQuickbooksEnabled">is Quickbooks Enabled ?</label>
                                    <div class="checkbox c-checkbox">
                                        <label>
                                            <input id="isQuickbooksEnabled" name="isQuickbooksEnabled" type="checkbox" ng-model="ctrl.companyInfo.isQuickbooksEnabled" ng-change="ctrl.switchIsQuickbooksEnabled($event)">
                                            <span class="fa fa-check"></span>
                                        </label>
                                    </div>

                                </div>
                            </div>

                            <div class="col-md-6" ng-if="ctrl.companyInfo.isQuickbooksEnabled">

                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('quickbooksUsername')}">
                                    <label for="quickbooksUsername">Quickbooks web connector username</label>
                                    <input id="quickbooksUsername" name="quickbooksUsername" class="form-control" type="text"  nim=1  ng-model="ctrl.companyInfo.companyId" disabled="disabled" ng-model-options="{ updateOn : 'blur' }" />
                                </div>

                            </div>

                            <div class="col-md-6" ng-if="ctrl.companyInfo.isQuickbooksEnabled">

                                <div class="form-group" ng-class="{'has-error':ctrl.updateQuickbooksForm.quickbooksPassword.$touched && ctrl.updateQuickbooksForm.quickbooksPassword.$invalid}">
                                    <label for="quickbooksPassword">Quickbooks web connector password</label>
                                    <input id="quickbooksPassword" name="quickbooksPassword" class="form-control" type="text"  nim=1  ng-model="ctrl.companyQuickbooksInfo.password" required />

                                    <div class="my-messages" ng-messages="ctrl.updateQuickbooksForm.quickbooksPassword.$error" ng-if="ctrl.updateQuickbooksForm.quickbooksPassword.$touched || ctrl.updateQuickbooksForm.$submitted">
                                        <div class="message-animation" ng-message="required">
                                            <strong><g:message code="required.error.message" /></strong>
                                        </div>
                                    </div>


                                </div>

                            </div>

                            <div class="col-md-6 form-group" ng-if="ctrl.companyInfo.isQuickbooksEnabled">
                                <label for="inventoryStatus"><g:message code="form.field.inventoryStatus.label" /></label>
                                <select ng-options="option.description for option in ctrl.inventoryStatusOptions track by option.optionValue" id="inventoryStatus" name="inventoryStatus" ng-model="ctrl.companyQuickbooksInfo.inventoryStatus" class="form-control" tabindex="9" required>
                                    <!-- <option ng-repeat="option in ctrl.inventoryStatusOptions" ng-value="option.optionValue">{{option.description}}</option> -->
                                </select>

                                <div class="my-messages" ng-messages="ctrl.updateQuickbooksForm.inventoryStatus.$error" ng-if="ctrl.updateQuickbooksForm.inventoryStatus.$touched || ctrl.updateQuickbooksForm.$submitted">
                                    <div class="message-animation" ng-message="required">
                                        <strong><g:message code="required.error.message" /></strong>
                                    </div>
                                </div>

                            </div>                                                        

                            <div class="col-md-12">
                                <div class="form-group" ng-show="ctrl.showQuickbooksQWCLink && ctrl.companyInfo.isQuickbooksEnabled">
                                    <g:link action="downloadQWCFile">Download QWC File</g:link>
                                </div>
                            </div>

                        </div>
                    </div>
                    <div class="panel-footer">
                        <div class="pull-left">
                            <button style="width:100px; height: 37px" class="btn btn-primary" type="submit" ng-disabled="ctrl.disableApiBtn">{{ctrl.updateApiBtnText}}</button>
                        </div>
                        <br style="clear: both;"/>
                    </div>
                </div>
            </form>

            %{--3PL Configuration--}%

            <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showQuickBooksUpdatedPrompt">
            The 3PL configuration has been updated successfully.
            </div>

            <form name="ctrl.update3plForm" ng-submit="ctrl.update3plConfiguration()" novalidate >

                <div class="panel panel-default" id="panel-anim-fadeInDown">

                    <div class="panel-body">
                        <div class="col-md-12">
                            <h4>3PL Configurations</h4>

                            <div class="col-md-12">
                                <div class="form-group">
                                    <label for="is3plEnabled">is 3PL Enabled ?</label>
                                    <div class="checkbox c-checkbox">
                                        <label>
                                            <input id="is3plEnabled" name="is3plEnabled" type="checkbox" ng-model="ctrl.companyInfo.is3plEnabled">
                                            <span class="fa fa-check"></span>
                                        </label>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="panel-footer">
                        <div class="pull-left">
                            <button style="width:100px; height: 37px" class="btn btn-primary" type="submit" ng-disabled="">Update</button>
                        </div>
                        <br style="clear: both;"/>
                    </div>
                </div>
            </form>

        </div>



        </div>


<!-- -----------------start company Address modal--------------------- -->

                    <div id="companyAddress" class="modal fade" role="dialog">
                        <div class="customer-modal-dialog modal-dialog" >
                            <div class="customer-modal-content modal-content">

                                <div class="customer-modal-header modal-header">
                                    <button type="button" class="customer-close close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                        <br style="clear: both;"/>

                                    <div class="panel-heading">
                                        <div class="customer-panel-title panel-title"><h4>Edit Company Address</h4></div>
                                    </div>

                                </div>

                                <div class="customer-modal-body modal-body">

                                    <form name="ctrl.companyAddressForm" ng-submit="ctrl.updateCompanyAddress()"  novalidate >

                                        <div class="panel-body">

                                            <h4><g:message code="form.field.billing.label" /> <g:message code="form.field.details.label" />:</h4>

                                            <div class="col-md-6">
                                                <div class="form-group" style="margin-bottom: 0px; margin-top: 0px;">
                                                    <label for="billingStreetAddress"><g:message code="form.field.billing.label" /> <g:message code="form.field.street.label" /></label>
                                                        <div class="controls">
                                                            <textarea id="billingStreetAddress" name="billingStreetAddress" class="form-control" ng-model="ctrl.companyAddress.companyBillingStreetAddress" ng-model-options="{ updateOn : 'default blur' }" placeholder="Street Address" required ></textarea>

                                                            <div class="my-messages" ng-messages="ctrl.companyAddressForm.billingStreetAddress.$error" ng-if="ctrl.companyAddressForm.billingStreetAddress.$touched || ctrl.companyAddressForm.$submitted">
                                                                <div class="message-animation" ng-message="required">
                                                                    <strong><g:message code="required.error.message" /></strong>
                                                                </div>
                                                            </div>

                                                        </div>
                                                </div>
                                            </div>


                                            <div class="col-md-6" >

                                                    <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('billingCity')}" >
                                                        <label for="billingCity"><g:message code="form.field.billing.label" /> <g:message code="form.field.city.label" /></label>
                                                        <div class="controls">
                                                            <input id="billingCity" name="billingCity" class="form-control" type="text"
                                                                   ng-model="ctrl.companyAddress.companyBillingCity" ng-model-options="{ updateOn : 'default blur' }"
                                                                   placeholder="City/Town" required />

                                                            <div class="my-messages" ng-messages="ctrl.companyAddressForm.billingCity.$error" ng-if="ctrl.companyAddressForm.billingCity.$touched || ctrl.companyAddressForm.$submitted">
                                                                <div class="message-animation" ng-message="required">
                                                                    <strong><g:message code="required.error.message" /></strong>
                                                                </div>
                                                            </div>
                                                        </div>

                                                    </div>
                                            </div>
                                            <br style="clear: both;"/>

                                            <div class="col-md-6">

                                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('billingState')}" style="margin-bottom: 10px; margin-top: 17px;">
                                                    <label for="billingState"><g:message code="form.field.billing.label" /> <g:message code="form.field.state.label" /></label>
                                                    <div class="controls">
                                                        <input id="billingState" name="billingState" class="form-control" type="text"
                                                               ng-model="ctrl.companyAddress.companyBillingState" ng-model-options="{ updateOn : 'default blur' }"
                                                               placeholder="State/Province" required />


                                                        <div class="my-messages" ng-messages="ctrl.companyAddressForm.billingState.$error" ng-if="ctrl.companyAddressForm.billingState.$touched || ctrl.companyAddressForm.$submitted">
                                                            <div class="message-animation" ng-message="required">
                                                                <strong><g:message code="required.error.message" /></strong>
                                                            </div>
                                                        </div>
                                                    </div>

                                                </div>
                                            </div>


                                            <div class="col-md-6">

                                            <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('billingPostCode')}" style="margin-bottom: 10px; margin-top: 17px;">
                                                <label for="billingPostCode"><g:message code="form.field.billing.label" /> <g:message code="form.field.postCode.label" /></label>
                                            <div class="controls">
                                                <input id="billingPostCode" name="billingPostCode" class="form-control" type="text"
                                                       ng-model="ctrl.companyAddress.companyBillingPostCode" ng-model-options="{ updateOn : 'default blur' }"
                                                       placeholder="ZIP/Post Code" required/>
                                                <div class="my-messages" ng-messages="ctrl.companyAddressForm.billingPostCode.$error" ng-if="ctrl.companyAddressForm.billingPostCode.$touched || ctrl.companyAddressForm.$submitted">
                                                    <div class="message-animation" ng-message="required">
                                                        <strong><g:message code="required.error.message" /></strong>
                                                    </div>
                                                </div>
                                            </div>
                                            </div>
                                            </div>

                                            <br style="clear: both;"/>

                                             <div class="col-md-6">

                                                    <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('billingCountry')}">
                                                        <label for="billingCountry"><g:message code="form.field.billing.label" /> <g:message code="form.field.country.label" /></label>
                                                        <select  id="billingCountry" name="billingCountry" ng-model="ctrl.companyAddress.companyBillingCountry" class="form-control" required >
                                                            <option selected disabled value="">Select Country</option>
                                                            <option ng-repeat="country in  countryList" value="{{country}}">{{country}}</option>
                                                        </select>

                                                        <div class="my-messages" ng-messages="ctrl.companyAddressForm.billingCountry.$error" ng-if="ctrl.companyAddressForm.billingCountry.$touched || ctrl.companyAddressForm.$submitted">
                                                            <div class="message-animation" ng-message="required">
                                                                <strong><g:message code="required.error.message" /></strong>
                                                            </div>
                                                        </div>
                                                    </div>

                                             </div>

                                            <br style="clear: both;"/>
                                            <br style="clear: both;"/>

                                             <h4><g:message code="form.field.shipping.label" /> <g:message code="form.field.details.label" />:</h4>

                                            <div class="col-md-6">

                                                <div class="form-group">
                                                <div class="checkbox c-checkbox">
                                                    <label>
                                                        <input type="checkbox" value="" ng-click="ctrl.checkShippingAddressCopy()" ng-model="ctrl.companyAddress.billingAddressCopy">
                                                        <span class="fa fa-check"></span><g:message code="form.field.sameAs.label" /></label>
                                                </div>

                                                    <label for="shippingStreetAddress"><g:message code="form.field.shipping.label" /> <g:message code="form.field.street.label" /></label>

                                                    <div class="controls">
                                                        <textarea id="shippingStreetAddress" name="shippingStreetAddress" class="form-control"
                                                                  ng-model="ctrl.companyAddress.companyShippingStreetAddress" ng-model-options="{ updateOn : 'default blur' }"
                                                                  placeholder="Street Address" ng-disabled="ctrl.companyAddress.billingAddressCopy" ng-required="!ctrl.companyAddress.billingAddressCopy" ></textarea>

                                                        <div class="my-messages" ng-messages="ctrl.companyAddressForm.shippingStreetAddress.$error" ng-if="(ctrl.companyAddressForm.shippingStreetAddress.$touched || ctrl.companyAddressForm.$submitted) && !ctrl.companyAddress.billingAddressCopy" >
                                                            <div class="message-animation" ng-message="required">
                                                                <strong><g:message code="required.error.message" /></strong>
                                                            </div>
                                                        </div>
                                                    </div>

                                                </div>
                                            </div>

                                            <div class="col-md-6">

                                            <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('shippingCity')}" style="margin-bottom: 0px; margin-top: 38px;">
                                                <label for="shippingCity"><g:message code="form.field.shipping.label" /> <g:message code="form.field.city.label" /></label>
                                                <div class="controls">
                                                    <input id="shippingCity" name="shippingCity" class="form-control" type="text"
                                                           ng-model="ctrl.companyAddress.companyShippingCity" ng-model-options="{ updateOn : 'default blur' }"
                                                           placeholder="City/Town" ng-disabled="ctrl.companyAddress.billingAddressCopy" ng-required="!ctrl.companyAddress.billingAddressCopy" />

                                                    <div class="my-messages" ng-messages="ctrl.companyAddressForm.shippingCity.$error" ng-if="(ctrl.companyAddressForm.shippingCity.$touched || ctrl.companyAddressForm.$submitted) && !ctrl.companyAddress.billingAddressCopy" >
                                                        <div class="message-animation" ng-message="required">
                                                            <strong><g:message code="required.error.message" /></strong>
                                                        </div>
                                                    </div>
                                                </div>

                                            </div>
                                            </div>
                                            <br style="clear: both;"/>


                                            <div class="col-md-6">
                                                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('shippingState')}">
                                                            <label for="shippingState"><g:message code="form.field.shipping.label" /> <g:message code="form.field.state.label" /></label>
                                                            <div class="controls">
                                                                <input id="shippingState" name="shippingState" class="form-control" type="text"
                                                                       ng-model="ctrl.companyAddress.companyShippingState" ng-model-options="{ updateOn : 'default blur' }"
                                                                       placeholder="State/Province" ng-disabled="ctrl.companyAddress.billingAddressCopy" ng-required="!ctrl.companyAddress.billingAddressCopy" />
                                                                <div class="my-messages" ng-messages="ctrl.companyAddressForm.shippingState.$error" ng-if="(ctrl.companyAddressForm.shippingState.$touched || ctrl.companyAddressForm.$submitted) && !ctrl.companyAddress.billingAddressCopy" >
                                                                    <div class="message-animation" ng-message="required">
                                                                        <strong><g:message code="required.error.message" /></strong>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                            </div>

                                            <div class="col-md-6">

                                                    <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('shippingPostCode')}">
                                                        <label for="shippingPostCode"><g:message code="form.field.shipping.label" /> <g:message code="form.field.postCode.label" /></label>
                                                        <div class="controls">
                                                            <input id="shippingPostCode" name="shippingPostCode" class="form-control" type="text"
                                                                   ng-model="ctrl.companyAddress.companyShippingPostCode" ng-model-options="{ updateOn : 'default blur' }"
                                                                   placeholder="ZIP/Post Code" ng-disabled="ctrl.companyAddress.billingAddressCopy" ng-required="!ctrl.companyAddress.billingAddressCopy"/>
                                                            <div class="my-messages" ng-messages="ctrl.companyAddressForm.shippingPostCode.$error" ng-if="(ctrl.companyAddressForm.shippingPostCode.$touched || ctrl.companyAddressForm.$submitted) && !ctrl.companyAddress.billingAddressCopy" >
                                                                <div class="message-animation" ng-message="required">
                                                                    <strong><g:message code="required.error.message" /></strong>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                            </div>

                                             <br style="clear: both;"/>

                                            <div class="col-md-6">
                                                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('shippingCountry')}">
                                                            <label for="shippingCountry"><g:message code="form.field.shipping.label" /> <g:message code="form.field.country.label" /></label>
                                                            <select  id="shippingCountry" name="shippingCountry" ng-model="ctrl.companyAddress.companyShippingCountry" class="form-control" ng-disabled="ctrl.companyAddress.billingAddressCopy" ng-required="!ctrl.companyAddress.billingAddressCopy" >
                                                                <option selected disabled value="">Select Country</option>
                                                                <option ng-repeat="country in  countryList" value="{{country}}">{{country}}</option>
                                                            </select>

                                                            <div class="my-messages" ng-messages="ctrl.companyAddressForm.shippingCountry.$error" ng-if="(ctrl.companyAddressForm.shippingCountry.$touched || ctrl.companyAddressForm.$submitted) && !ctrl.companyAddress.billingAddressCopy" >
                                                                <div class="message-animation" ng-message="required">
                                                                    <strong><g:message code="required.error.message" /></strong>
                                                                </div>
                                                            </div>
                                                        </div>
                                            </div>

                                        </div>

                                    </div>
                                            <div class="customer-modal-footer modal-footer">
                                                %{--<button class="btn btn-default" type="button" data-dismiss="modal" style="margin-left: 0px; margin-right: 433px;"><g:message code="default.button.cancel.label" /></button>--}%
                                                %{--<button class="btn btn-primary" type="submit" style="margin-left: 100px; margin-right: 10px;" ><g:message code="default.button.save.label" /></button>--}%

                                                <button class="btn btn-default pull-left" type="button" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                                                <button class="btn btn-primary" type="submit" style="margin-left: 100px; margin-right: 10px;" ><g:message code="default.button.save.label" /></button>

                                            <br style="clear: both;"/>
                                            <br style="clear: both;"/>

                                            </div>

                                        </form>

                        </div>
                    </div>

<!-- -----------------end company Address modal--------------------- -->


<div id="cropImageModel" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Crop Image</h4>
            </div>
            <div class="modal-body">
                <div class="cropArea">
                    <img-crop image="myImage" area-type="square" result-image-size="148"  result-image="myCroppedImage"></img-crop>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">OK</button>
                <!-- <button type="button" id = "orderResetButton" class="btn btn-primary">Reset</button> -->
            </div>
        </div>
    </div>
</div>

</div><!-- End of listValueCtrl -->


<!-- bootstrap modal confirmation dialog-->

<div id="easyPostDisable" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Confirmation</h4>
            </div>
            <div class="modal-body">
                <p><g:message code="companyProfile.easyPost.warning.message" /></p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" id = "easyPostDisableCancel" data-dismiss="modal">Cancel</button>
                <button type="button" id = "easyPostDisableBtn" class="btn btn-primary">OK</button>
            </div>
        </div>
    </div>
</div>

<div id="putawayOrderReset" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Confirmation</h4>
            </div>
            <div class="modal-body">
                <p><g:message code="putawayOrder.reset.confirmation" /></p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                <button type="button" id = "orderResetButton" class="btn btn-primary">Reset</button>
            </div>
        </div>
    </div>
</div>


<div id="allocationOrderReset" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Confirmation</h4>
            </div>
            <div class="modal-body">
                <p><g:message code="allocationOrder.reset.confirmation" /></p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                <button type="button" id = "allocationOrderResetButton" class="btn btn-primary">Reset</button>
            </div>
        </div>
    </div>
</div>

<div id="listValueDelete" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Confirmation</h4>
            </div>
            <div class="modal-body">
                <p><g:message code="listValue.delete.message" /></p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                <button type="button" id = "deleteListValueButton" class="btn btn-primary">Delete</button>
            </div>
        </div>
    </div>
</div>
<div id="listValueDeleteWarning" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Confirmation</h4>
            </div>
            <div class="modal-body">
                <p><g:message code="listValue.delete.warning" /></p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">OK</button>
            </div>
        </div>
    </div>
</div>


    <asset:javascript src="datagrid/admin-company-profile.js"/>

    <script type="text/javascript">
        var dvAdminCompanyProfile = document.getElementById('dvAdminCompanyProfile');
        angular.element(document).ready(function() {
            angular.bootstrap(dvAdminCompanyProfile, ['adminCompanyProfile']);
        });
    </script>

</body>
</html>