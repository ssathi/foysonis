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
    %{--<link rel="stylesheet" href="http://ui-grid.info/release/ui-grid.css" type="text/css">--}%
    %{--<asset:stylesheet src="datagrid/ui-grid.css"/>--}%

    %{--Sign Up Form--}%
    <asset:stylesheet src="signup/style.css"/>
    <asset:stylesheet src="signup/animations.css"/>

  
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
        }

        .csvGrid {
            height:380px;
            width: 1300px;
        }

        .grid-align {
            text-align: center;
        }

        .grid-action-align {
            padding-left: 70px;
        }

        .dropdown-menu {
            min-width: 90px;
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

        [ng\:cloak], [ng-cloak], [data-ng-cloak], [x-ng-cloak], .ng-cloak, .x-ng-cloak {
            display: none !important;
        }

        .gridCheckbox {
            position: relative;
            display: block;
            margin-top: 5px;
            margin-bottom: 10px;
        }

        .receipt-modal-dialog {
            width: 100%;
            height: 100%;
            margin: 0;
            padding: 0;
        }

        .receipt-modal-content {
            height: auto;
            min-height: 100%;
            border-radius: 0;
        }


        .receipt-modal-header {
            background: #547CA2;
            height: 70px;
        }

        .receipt-panel-title {
            margin-top: -30px;
            color: #ffffff;
        }

        .receipt-modal-body {
            position: fixed;
            top: 70px;
            bottom: 70px;
            width: 100%;
            overflow: scroll;
            padding: 15px
        }

        .receipt-modal-footer {
            position: fixed;
            right: 0;
            bottom: 0;
            left: 0;
            border-top: 2px solid #547CA2;
            height: 70px;
        }

        .receipt-close {
            color: #FFFFFF;
            opacity: 1;
        }

        .ui-grid-header-viewport {
            /*width: 0px;*/
            /*width: 1300px;*/
        }

        .csvImportBtn {
            background-color: #22a49c !important;
            height: 37px;
            line-height: 1;
            border: 0px;
        } 
            
        /*.ui-grid-top-panel {*/
        /*/!* overflow: hidden; *!/*/
        /*}*/

    </style>

<%-- **************************** End of CSS **************************** --%>    

</head>

<body>


    <div ng-cloak class="row" id="dvAdminPrinter" ng-controller="PrinterCtrl as ctrl">

        <div class="col-lg-12">
            <!-- START panel-->
            <!-- <div class="panel panel-default">
                <div class="panel-body" style="overflow:hidden;"> -->
                        
                        <%-- **************************** createItem form **************************** --%>
                            <div style="display: inline;"><!-- <em class="fa  fa-fw mr-sm" ><img style="width: 35px;" src="/foysonis2016/app/img/item-header.svg"></em>&emsp;&nbsp; --><span class="headerTitle">Printers</span></div>
                                
                            <a data-play="fadeInDown" data-target="#panel-anim-fadeInDown" data-toggle="play-animation" href="javascript:void(0);">

                                <button type="button" class="btn btn-primary newFormCreateBtn pull-right" ng-click="ShowHide()">
                                    <em class="fa fa-plus-circle fa-fw mr-sm"></em>
                                    <g:message code="default.button.createPrinter.label" />
                                </button>
                            </a>
                            <br style="clear: both;"/>
                            <br style="clear: both;"/>

                            <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showSubmittedPrompt">
                                <g:message code="printer.create.message" />
                            </div>
                            <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showDeletedPrompt">
                                <g:message code="printer.delete.message" />
                            </div>


                            <div class="alert alert-success message-animation" role="alert" ng-show="ctrl.showImportItemSubmittedPrompt">
                                <g:message code="item.import.message" />
                            </div>

                            <div ng-show="IsVisible" class="row">

                                <form name="ctrl.createPrinterForm" ng-submit="ctrl.createNewPrinter()" novalidate >

                                    <div class="panel panel-default" id="panel-anim-fadeInDown">
                                        <div class="panel-heading">                                         
                                            <div class="panel-title"><g:message code="default.printer.add.label" /></div>
                                        </div>

                                        <div class="panel-body">

                                            <div class="col-md-12">

                                                <div class="col-md-6">

                                                    <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('printerDisplayName')}">

                                                        <label for="printerDisplayName"><g:message code="form.field.printerDisplayName.label" /></label>
                                                        <input id="printerDisplayName" name="printerDisplayName" class="form-control" type="text" maxlength="32" capitalize required
                                                               ng-model="ctrl.newPrinter.displayName"
                                                               ng-focus="ctrl.toggleItemIdPrompt(true)" ng-blur="ctrl.toggleItemIdPrompt(false);"/>

                                                        <div class="my-messages" ng-messages="ctrl.createPrinterForm.printerDisplayName.$error" ng-if="ctrl.showMessages('printerDisplayName')">
                                                            <div class="message-animation" ng-message="required">
                                                                <strong><g:message code="required.error.message" /></strong>
                                                            </div>
                                                        </div>
                                                    </div>

                                                </div>

                                                <div class="col-md-6">
                                                    <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('printerType')}">
                                                        <label for="printerType"><g:message code="form.field.printerType.label" /></label>
                                                        <select  id="printerType" name="printerType" ng-model="ctrl.newPrinter.printerType" class="form-control" required>
                                                            <option value="${com.foysonis.printer.PrinterType.LABEL}">${com.foysonis.printer.PrinterType.LABEL}</option>
                                                            <option value="${com.foysonis.printer.PrinterType.REGULAR}">${com.foysonis.printer.PrinterType.REGULAR}</option>
                                                            <option value="${com.foysonis.printer.PrinterType.OTHER}">${com.foysonis.printer.PrinterType.OTHER}</option>
                                                        </select>

                                                        <div class="my-messages" ng-messages="ctrl.createPrinterForm.printerType.$error" ng-if="ctrl.showMessages('printerType')">
                                                            <div class="message-animation" ng-message="required">
                                                                <strong><g:message code="required.error.message" /></strong>
                                                            </div>
                                                        </div>

                                                    </div>
                                                </div>
                                            </div>

                                            <div class="col-md-12">
                                                <div class="col-md-6">


                                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('lowestUom')}">
                                                    <label for="printerDpiSize"><g:message code="form.field.printerDpiSize.label" /></label>
                                                    <select  id="printerDpiSize" name="printerDpiSize" ng-model="ctrl.newPrinter.dpiSize" class="form-control">
                                                        <option value="203">203</option>
                                                    </select>
                                                </div>
                                            </div>

                                            <div class="col-md-6">

                                                    <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('printerAddress')}">

                                                        <label for="printerAddress"><g:message code="form.field.printerAddress.label" /></label>
                                                        <input id="printerAddress" name="printerAddress" class="form-control" type="text" maxlength="32" capitalize required
                                                               ng-model="ctrl.newPrinter.printerAddress"
                                                               ng-focus="ctrl.toggleItemIdPrompt(true)" ng-blur="ctrl.toggleItemIdPrompt(false);"/>
                                                    </div>

                                                </div>

                                            </div>

                                            <div class="col-md-12">

                                                <div class="col-md-6">

                                                    <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('printerLabelSize')}">
                                                        <label for="printerLabelSize"><g:message code="form.field.printerLabelSize.label" /></label>
                                                        <select  id="printerLabelSize" name="printerLabelSize" ng-model="ctrl.newPrinter.labelSize" class="form-control" >
                                                            <option value="4x6">4x6</option>
                                                        </select>

                                                    </div>
                                                </div>

                                                <div class="col-md-6"> 
                                                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('printerConnectionType')}">
                                                            <label for="printerConnectionType"><g:message code="form.field.printerConnectionType.label" /></label>
                                                            <select  id="printerConnectionType" name="printerConnectionType" ng-model="ctrl.newPrinter.connectionType" class="form-control">
                                                                <option value="${com.foysonis.printer.PrinterConnectionType.LOCAL}">${com.foysonis.printer.PrinterConnectionType.LOCAL}</option>
                                                                <option value="${com.foysonis.printer.PrinterConnectionType.NETWORK}">${com.foysonis.printer.PrinterConnectionType.NETWORK}</option>
                                                                <option value="${com.foysonis.printer.PrinterConnectionType.PRINT_QUEUE}">${com.foysonis.printer.PrinterConnectionType.PRINT_QUEUE}</option>
                                                            </select>
                                                        </div>
                                                    </div>

                                                </div>
                                        </div>

                                        <div class="panel-footer">
                                            <div class="pull-left">
                                                <a data-play="fadeInDown" data-target="#panel-anim-fadeInDown" data-toggle="play-animation" href="javascript:void(0);">
                                                    <button class="btn btn-default" type="button" ng-click="ShowHide()"><g:message code="default.button.cancel.label" /></button>
                                                </a>

                                            </div>
                                            <div class="pull-right">
                                                <button class="btn btn-primary" type="submit" ng-disabled="ctrl.disableItemSave"><!-- <g:message code="default.button.save.label" /> -->{{ctrl.itemSaveBtnText}}</button>
                                            </div>
                                            <br style="clear: both;"/>
                                        </div>


                                    
                                  </div>  
                                </form>

                            </div>
<%-- **************************** End of createItem form **************************** --%>



<%-- **************************** Edit Item form **************************** --%>

                            <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showUpdatedPrompt">
                                <g:message code="printer.edit.message" />
                            </div>

                            <div ng-show="ctrl.editPrinterState" class="row">

                                <form name="ctrl.editPrinterForm" ng-submit="ctrl.updatePrinter()" novalidate >

                                    <div class="panel panel-default" id="panel-anim-fadeInDown">
                                        <div class="panel-heading">                                         
                                            <div class="panel-title"><g:message code="default.item.edit.label" /></div>
                                        </div>

                                        <div class="panel-body">
                                            <div class="col-md-12">

                                                <div class="col-md-6">

                                                    <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('printerDisplayName')}">

                                                        <label for="printerDisplayName"><g:message code="form.field.printerDisplayName.label" /></label>
                                                        <input id="printerDisplayName" name="printerDisplayName" class="form-control" type="text" maxlength="32" capitalize required
                                                               ng-model="ctrl.editPrinter.displayName"
                                                               ng-focus="ctrl.toggleItemIdPrompt(true)" ng-blur="ctrl.toggleItemIdPrompt(false);" disabled />

                                                        <div class="my-messages" ng-messages="ctrl.editPrinterForm.printerDisplayName.$error" ng-if="ctrl.showMessages('printerDisplayName')">
                                                            <div class="message-animation" ng-message="required">
                                                                <strong><g:message code="required.error.message" /></strong>
                                                            </div>
                                                        </div>
                                                    </div>

                                                </div>

                                                <div class="col-md-6">
                                                    <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('printerType')}">
                                                        <label for="printerType"><g:message code="form.field.printerType.label" /></label>
                                                        <select  id="printerType" name="printerType" ng-model="ctrl.editPrinter.printerType" class="form-control" required>
                                                            <option value="${com.foysonis.printer.PrinterType.LABEL}">${com.foysonis.printer.PrinterType.LABEL}</option>
                                                            <option value="${com.foysonis.printer.PrinterType.REGULAR}">${com.foysonis.printer.PrinterType.REGULAR}</option>
                                                            <option value="${com.foysonis.printer.PrinterType.OTHER}">${com.foysonis.printer.PrinterType.OTHER}</option>
                                                        </select>

                                                        <div class="my-messages" ng-messages="ctrl.editPrinterForm.printerType.$error" ng-if="ctrl.showMessages('printerType')">
                                                            <div class="message-animation" ng-message="required">
                                                                <strong><g:message code="required.error.message" /></strong>
                                                            </div>
                                                        </div>

                                                    </div>
                                                </div>
                                            </div>

                                            <div class="col-md-12">
                                                <div class="col-md-6">


                                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('lowestUom')}">
                                                    <label for="printerDpiSize"><g:message code="form.field.printerDpiSize.label" /></label>
                                                    <select  id="printerDpiSize" name="printerDpiSize" ng-model="ctrl.editPrinter.dpiSize" class="form-control">
                                                        <option value="203">203</option>
                                                    </select>
                                                </div>
                                            </div>

                                            <div class="col-md-6">

                                                    <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('printerAddress')}">

                                                        <label for="printerAddress"><g:message code="form.field.printerAddress.label" /></label>
                                                        <input id="printerAddress" name="printerAddress" class="form-control" type="text" maxlength="32" capitalize required
                                                               ng-model="ctrl.editPrinter.printerAddress"
                                                               ng-focus="ctrl.toggleItemIdPrompt(true)" ng-blur="ctrl.toggleItemIdPrompt(false);"/>
                                                    </div>

                                                </div>

                                            </div>

                                            <div class="col-md-12">

                                                <div class="col-md-6">

                                                    <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('printerLabelSize')}">
                                                        <label for="printerLabelSize"><g:message code="form.field.printerLabelSize.label" /></label>
                                                        <select  id="printerLabelSize" name="printerLabelSize" ng-model="ctrl.editPrinter.labelSize" class="form-control" >
                                                            <option value="4x6">4x6</option>
                                                        </select>

                                                    </div>
                                                </div>

                                                <div class="col-md-6"> 
                                                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('printerConnectionType')}">
                                                            <label for="printerConnectionType"><g:message code="form.field.printerConnectionType.label" /></label>
                                                            <select  id="printerConnectionType" name="printerConnectionType" ng-model="ctrl.editPrinter.connectionType" class="form-control">
                                                                <option value="${com.foysonis.printer.PrinterConnectionType.LOCAL}">${com.foysonis.printer.PrinterConnectionType.LOCAL}</option>
                                                                <option value="${com.foysonis.printer.PrinterConnectionType.NETWORK}">${com.foysonis.printer.PrinterConnectionType.NETWORK}</option>
                                                                <option value="${com.foysonis.printer.PrinterConnectionType.PRINT_QUEUE}">${com.foysonis.printer.PrinterConnectionType.PRINT_QUEUE}</option>
                                                            </select>
                                                        </div>
                                                    </div>

                                                </div>

                                        </div>    
                                        <div class="panel-footer">
                                            <div class="pull-left">
                                                <a data-play="fadeInDown" data-target="#panel-anim-fadeInDown" data-toggle="play-animation" href="javascript:void(0);">
                                                    <button class="btn btn-default" type="button" ng-click="HideEditForm()"><g:message code="default.button.cancel.label" /></button>
                                                </a>

                                            </div>
                                            <div class="pull-right">
                                                <button class="btn btn-primary" type="submit" ng-disabled="ctrl.disableItemEdit">{{ctrl.itemEditBtnText}}<!-- <g:message code="default.button.update.label" /> --></button>  
                                            </div>
                                            <br style="clear: both;"/>
                                        </div>
                                        
                                    
                                  </div>  
                                </form>

                            </div>
<%-- **************************** End of Edit Item form **************************** --%>
                       <!-- </div>

                        
            </div> -->
            <!-- END panel-->

            <!-- start Item Grid-->
            <p>
            <div id="grid1" ui-grid="gridPrinters" ui-grid-exporter  ui-grid-pagination ui-grid-pinning ui-grid-resize-columns class="grid" >
                <div class="noItemMessage" ng-if="gridPrinters.data.length == 0"><g:message code="item.grid.noData.message" /></div>
            </div>
             </p>
            <!-- end OF Item Grid-->
        </div>


    <div id="printerDelete" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Confirmation</h4>
                </div>
                <div class="modal-body">
                    <p>Are you sure want to delete Printer : {{ctrl.deleteItemForMessage}} ?</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                    <button type="button" id = "deletePrinterButton" class="btn btn-primary"><g:message code="default.button.delete.label" /></button>
                </div>
            </div>
        </div>
    </div>

    <asset:javascript src="datagrid/admin-printer.js"/>

    <script type="text/javascript">
        var dvAdminItem = document.getElementById('dvAdminItem');
        angular.element(document).ready(function() {
            angular.bootstrap(dvAdminPrinter, ['adminPrinter']);
        });
    </script>

</body>
</html>
