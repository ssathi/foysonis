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
    %{--<link rel="stylesheet" href="http://ui-grid.info/release/ui-grid.css" type="text/css">--}%
    %{--<asset:stylesheet src="datagrid/ui-grid.css"/>--}%

    %{--Sign Up Form--}%
    <asset:stylesheet src="signup/style.css"/>
    <asset:stylesheet src="signup/animations.css"/>

  
<%-- *************************** CSS for Location Grid **************************** --%>
    <style>


ul[dnd-list] * { 
    pointer-events: none; 
}

ul[dnd-list], ul[dnd-list] > li { 
    pointer-events: auto;
    position: relative;
}



/**
 * The dnd-list should always have a min-height,
 * otherwise you can't drop to it once it's empty
 */
ul[dnd-list] {
    min-height: 42px;
    padding-left: 0px;
}

/**
 * The dndDraggingSource class will be applied to
 * the source element of a drag operation. It makes
 * sense to hide it to give the user the feeling
 * that he's actually moving it.
 */
ul[dnd-list] .dndDraggingSource {
    display: none;
}

/**
 * An element with .dndPlaceholder class will be
 * added to the dnd-list while the user is dragging
 * over it.
 */
ul[dnd-list] .dndPlaceholder {
    display: block;
    background-color: #ddd;
    min-height: 42px;
}

/**
 * The dnd-lists's child elements currently MUST have
 * position: relative. Otherwise we can not determine
 * whether the mouse pointer is in the upper or lower
 * half of the element we are dragging over. In other
 * browsers we can use event.offsetY for this.
 */
ul[dnd-list] li {
    background-color: #fff;
    border: 1px solid #ddd;
    border-top-right-radius: 4px;
    border-top-left-radius: 4px;
    display: block;
    padding: 10px 15px;
    margin-bottom: -1px;
    cursor: pointer;
}

/**
 * Show selected elements in green
 */
ul[dnd-list] li.selected {
    background-color: #dff0d8;
    color: #3c763d;
}



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
            width: 820px;
        }

        .grid-align {
            text-align: center;
        }

        .grid-action-align {
            padding-left: 60px;
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

        hr { 
            border-style: solid;
            border-width: 2px;
        }    

        .affix {
            top: 50px;
            z-index: 9999 !important;
            background: #ffffff;
            border: 1px solid #e3e3e3;  
            width: 270px;
        }

        nav.confNav {
            position: absolute;
            width: 270px;
            left: 0;
            padding: 0;
            top: -2px;
            background: #ffffff;
            border: 1px solid #e3e3e3;
            z-index: 2;            
        }  

        nav.confNav > ul > li {
            //padding-left: 20px;
            //border-bottom: 1px solid #e3e3e3;  
            margin: 0;
        }

        nav.confNav > ul > li > a{
            padding-left: 25px;
            border-bottom: 1px solid #e3e3e3;
            border-radius: 0;
        }

        nav.confNav > ul > li > a.active{
            background: #e9f3f5;
        }

        .conf-sideContent {
            //margin-top: -180px;
            padding-left: 360px;
        }

        .sortHeader {
            padding-bottom: 0;
        }

        .sortHeaderRow {
            background: #f7f7f7;
            height: 28px;
            border:1px solid #ddd;
            border-bottom: 0;
        }

        ul#ulListVal {
            padding-left: 55px;
        }

        ul#ulListVal > li > a {
            border-left: 4px solid #315d90;
        }

        ul#ulListVal > li > a.active {
            border-color: #15c98d;
        }

        li.ng-scope:nth-child(even) {
            background: #e9f3f5;
        }

        .gap-30 {
            clear: both;
            width: 100%;
            height: 30px;
        } 

        .gap-50 {
            clear: both;
            width: 100%;
            height: 50px;
        } 

        .sortBody {
            padding: 0;
        }             

        [ng\:cloak], [ng-cloak], [data-ng-cloak], [x-ng-cloak], .ng-cloak, .x-ng-cloak {
            display: none !important;
        }

    </style>

<%-- **************************** End of CSS **************************** --%>    

</head>

<body>

    <nav class="col-sm-3 confNav">
      <ul class="nav nav-pills nav-stacked listNav" data-spy="affix" data-offset-top="60">
        <li style="padding-top: 20px; padding-left: 20px; padding-bottom: 10px; border-bottom: 1px solid #e3e3e3;"><div style="display: inline;"><em class="fa  fa-fw mr-sm" ><img style="width: 40px; padding-bottom: 3px;" src="/foysonis2016/app/img/configuration_header.svg"></em>&emsp;&emsp;<span class="headerTitle" style="vertical-align: bottom;">Configuration
            </span></div></li>
        <li><a href="#putawayOrder">Putaway Ordering</a></li>
        <li><a href="#allocationOrder">Allocation Ordering</a></li>
        <li><a href="#listValuesTarget" data-toggle="collapse" data-target="#ulListVal">List Values</a>
            <ul id="ulListVal" class="listNav nav collapse" style="border-bottom: 1px solid #e3e3e3;">
                <li>
                    <a href="#AdjustmentReason" data-toggle="" class="no-submenu">
                        <span class="item-text" >Adjustment Reason</span>
                    </a>
                </li>

                <li>
                    <a href="#ItemCategory" data-toggle="" class="no-submenu">
                        <span class="item-text" >Item Category</span>
                    </a>
                </li>

                <li>
                    <a href="#RequestedShipSpeed" data-toggle="" class="no-submenu">
                        <span class="item-text" >Requested Ship Speed</span>
                    </a>
                </li>

                <li>
                    <a href="#StorageAttributes"  data-toggle="" class="no-submenu">
                        <span class="item-text" >Storage Attributes</span>
                    </a>
                </li>
                <li>
                    <a href="#CarrierCode" data-toggle="" class="no-submenu">
                        <span class="item-text" >Carrier Code</span>
                    </a>
                </li>
                <li>
                    <a href="#InventoryStatus" data-toggle="" class="no-submenu">
                        <span class="item-text" >Inventory Status</span>
                    </a>
                </li>
                <li>
                    <a href="#CancelPickReason" data-toggle="" class="no-submenu">
                        <span class="item-text" >Cancel Pick Reason</span>
                    </a>
                </li>

            </ul>            
        </li>
        <li><a href="#configurationDiv">Configuration</a></li>
      </ul>
    </nav>

    <div ng-cloak class="row" id="dvAdminListValue" ng-controller="listValueCtrl as ctrl">
        <!-- <div style="display: inline;"><em class="fa  fa-fw mr-sm" ><img style="width: 40px; padding-bottom: 3px;" src="/foysonis2016/app/img/configuration_header.svg"></em>&emsp;&emsp;<span class="headerTitle" style="vertical-align: bottom;">Configuration
            </span></div> -->
            <!-- <hr style="border:0.5px solid #d6d5d5;"> -->
        <div class="col-lg-12 conf-sideContent">

<%-- **************************** Putaway Ordering **************************** --%>   


            


            <div class="col-lg-12">
                <h3>Putaway Ordering</h3>
                <br style="clear: both;"/>
            <div class="panel panel-default panel-content" id="putawayOrder">
                <div class="panel-body" >
                    <!-- Nav tabs -->
                    <!-- <ul class="nav nav-tabs">
                        <li id="liPutaway" class="active"><a href="#putawayOrder" data-toggle="tab">Putaway Ordering</a></li>
                        <li id="liAllocation"><a href="#allocationOrder" data-toggle="tab">Allocation Ordering</a></li>
                    </ul> -->
                    <!-- Tab panes -->
                    <!-- <div class="tab-content"> -->
                        <!-- <div id="putawayOrder" class="tab-pane fade in active"> -->

                                <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showOrderedPrompt">
                                    <g:message code="putawayOrder.sort.message" />
                                </div>

                                <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showResetPrompt">
                                    <g:message code="putawayOrder.reset.message" />
                                </div> 


                                <div class="panel-heading sortHeader"> 
                                    <div class="row sortHeaderRow">                                       
                                        <div class="col-lg-2 sortRawContent"><b>Putaway Order</b></div>
                                        <div class="col-lg-6 sortRawContent"><b>Area Id</b></div>
                                    </div>
                                </div>

                                <div class="panel-body sortBody">
                                <ul dnd-list="areaList" class="areaList">
                                    <li
                                        ng-repeat="areas in areaList"
                                        dnd-draggable="areas"
                                        dnd-droppable-in=".areaList"
                                        dnd-effect-allowed="move"
                                        dnd-moved="areaList.splice($index, 1);ctrl.enableButton();"
                                        dnd-selected="areaList.selected = areas"
                                        ng-class="{'selected': areaList.selected === areas}"
                                        style="cursor:move;height: 38px;line-height: 1; border-radius: 0;">
                                        <div class="row">
                                            <div class="col-lg-2"><b>{{$index+1}}.</b></div>
                                            <div class="col-lg-6"><b>{{ areas.areaId }}</b></div>
                                        </div>
                                    </li>
                                </ul>
                                </div>

                                    <div class="panel-footer">
                                        <div style="width: 190px;">
                                           <div class="pull-left">
                                                <button class="btn btn-default" type="button" ng-click="ctrl.resetOrder()" ng-disabled="ctrl.disableReset">Reset</button>
                                            </div>
                                            <div class="pull-right">
                                                <button  class="btn btn-primary newFormCreateBtn"  type="button" ng-click="ctrl.saveOrder()" ng-disabled="ctrl.disableSave">Save</button>
                                            </div>    
                                        </div>
                                                                               
                                        <br style="clear: both;"/>
                                    </div> 


                       <!--  </div>   -->                                              
                   <!--  </div> -->
                </div>
                <!--/.panel-body -->
            </div>
            <!-- END panel-->
            <div class="gap-50"></div>
            <h3>Allocation Ordering</h3>
                <br style="clear: both;"/>

            <div class="panel panel-default panel-content" id="allocationOrder">
                <div class="panel-body" >
                    <!-- Nav tabs -->
                    <!-- <ul class="nav nav-tabs">
                        <li id="liPutaway" class="active"><a href="#putawayOrder" data-toggle="tab">Putaway Ordering</a></li>
                        <li id="liAllocation"><a href="#allocationOrder" data-toggle="tab">Allocation Ordering</a></li>
                    </ul> -->
                    <!-- Tab panes -->
                    <!-- <div class="tab-content"> -->
                        <!-- <div id="allocationOrder" class="tab-pane fade"> -->

                                <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showAllocationOrderedPrompt">
                                    <g:message code="putawayOrder.sort.message" />
                                </div>

                                <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showAllocationResetPrompt">
                                    <g:message code="allocationOrder.reset.message" />
                                </div> 


                                <div class="panel-heading sortHeader"> 
                                    <div class="row sortHeaderRow">                                       
                                        <div class="col-lg-2"><b>Allocation Order</b></div>
                                        <div class="col-lg-6"><b>Area Id</b></div>
                                    </div>
                                </div>

                                <div class="panel-body sortBody">
                                <ul dnd-list="areaPickableList" class="areaPickableList">
                                    <li
                                        ng-repeat="pickableAreas in areaPickableList"
                                        dnd-draggable="pickableAreas"
                                        dnd-droppable-in=".areaPickableList"
                                        dnd-effect-allowed="move"
                                        dnd-moved="areaPickableList.splice($index, 1);ctrl.enableAllocationSaveButton();"
                                        dnd-selected="areaPickableList.selected = pickableAreas"
                                        ng-class="{'selected': areaPickableList.selected === pickableAreas}"
                                        style="cursor:move;height: 38px;line-height: 1; border-radius: 0;">
                                        <div class="row">
                                            <div class="col-lg-2"><b>{{$index+1}}.</b></div>
                                            <div class="col-lg-6"><b>{{ pickableAreas.areaId }}</b></div>
                                        </div>
                                    </li>
                                </ul>
                                </div>

                                    <div class="panel-footer">
                                        <div style="width: 190px;">
                                            <div class="pull-left">
                                                <button class="btn btn-default" type="button" ng-click="ctrl.resetAllocationOrder()" ng-disabled="ctrl.disableAllocationReset">Reset</button>
                                            </div>
                                            <div class="pull-right">
                                                <button  class="btn btn-primary newFormCreateBtn" type="button" ng-click="ctrl.saveAllocationOrder()" ng-disabled="ctrl.disableAllocationSave">Save</button>
                                            </div>  
                                        </div>                                        
                                        <br style="clear: both;"/>
                                    </div> 


                        <!-- </div> -->

                                                
                   <!--  </div> -->
                </div>
                <!--/.panel-body -->
            </div>

        </div>







    <br style="clear: both;"/>
    <br style="clear: both;"/>

<%-- **************************** End of Putaway Ordering **************************** --%>   

    <h3 class="panel-content" id="listValuesTarget">List Values</h3>
            <div class="gap-30"></div>
            <h4>Adjustment Reason</h4>
            <!-- START panel-->
            <div class="panel panel-default panel-content" id="AdjustmentReason">
                <div class="panel-body" >


                        <%-- **************************** create ListValue form **************************** --%>
                            <a data-play="fadeInDown" data-target="#panel-anim-fadeInDown" data-toggle="play-animation" href="javascript:void(0);">

                                <button type="button" class="btn btn-primary newFormCreateBtn pull-right" ng-click="ShowHide('ADJREASON')">
                                    <em class="fa fa-plus-circle fa-fw mr-sm"></em>
                                    New Adjustment Reason
                                </button>
                            </a>

                            <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showSubmittedPrompt">
                                <g:message code="listValue.create.message" />
                            </div>
                            <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showDeletedPrompt">
                                <g:message code="listValue.delete.success.message" />
                            </div>
                            <div ng-init="ctrl.getAllListValues('ADJREASON')"></div>

                            <div ng-show="IsVisibleAdjReason" class="row">

                                <form name="ctrl.createListValueForm" ng-submit="ctrl.createListValue()" novalidate >

                                    <div class="panel panel-default" id="panel-anim-fadeInDown">
                                        <div class="panel-heading">                                         
                                            <div class="panel-title">Add List Value</div>
                                        </div>

                                        <div class="panel-body">
                                         <div class="col-md-12">
                                            <div class="col-md-6">

                                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('optionGroup')}">

                                                    <label for="optionGroup">Option Group</label>
                                                    <select  id="optionGroup" name="optionGroup" ng-model="ctrl.newListValue.optionGroup" class="form-control" required  disabled>     
                                                        <option ng-repeat="listValueData in  ctrl.listValueData" value="{{listValueData.optionGroup}}">{{listValueData.optionGroup}}
                                                        </option>
                                                    </select>


                                                    <div class="my-messages">
                                                        <div class="prompt message-animation" ng-if="ctrl.showOptionGroupPrompt">
                                                            Choose an Option Group.
                                                        </div>
                                                    </div>

                                                    <div class="my-messages"  ng-messages="ctrl.createListValueForm.optionGroup.$error"
                                                         ng-if="ctrl.createListValueForm.$error.optionGroupExists">
                                                        <div class="message-animation" >
                                                            <strong>Receipt Id exists already.</strong>
                                                        </div>
                                                    </div>

                                                    <div class="my-messages" ng-messages="ctrl.createListValueForm.optionGroup.$error" ng-if="ctrl.showMessages('optionGroup')">
                                                        <div class="message-animation" ng-message="required">
                                                            <strong>This field is required.</strong>
                                                        </div>
                                                    </div>
                                                </div>


                                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('description')}">
                                                    <label for="description">Description</label>
                                                    <input id="description" name="description" class="form-control" type="text" required
                                                           ng-model="ctrl.newListValue.description"
                                                           ng-focus="" ng-blur="ctrl.validateDescription(ctrl.newListValue.description);" tabindex="2" />


                                                    <div class="my-messages" ng-messages="ctrl.createListValueForm.description.$error" ng-if="ctrl.showMessages('description')">
                                                        <div class="message-animation" ng-message="required">
                                                            <strong>This field is required.</strong>
                                                        </div>
                                                    </div>
                                                </div>

                                               <div class="my-messages"  ng-messages="ctrl.createListValueForm.description.$error"
                                                     ng-if="ctrl.createListValueForm.$error.descriptionExists">
                                                    <div class="message-animation" >
                                                        <strong>value of description exists already.</strong>
                                                    </div>
                                                </div> 

                                            </div>

                                            <div class="col-md-6">


                                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('optionValue')}">
                                                    <label for="optionValue">Option Value</label>
                                                    <input id="optionValue" name="optionValue" class="form-control" type="text"
                                                           ng-model="ctrl.newListValue.optionValue"
                                                           ng-focus="" ng-blur="ctrl.validateOptionValue(ctrl.newListValue.optionValue);" ng-disabled = "ctrl.editListValueState" maxlength="15" tabindex="1" />


                                                    <div class="my-messages"  ng-messages="ctrl.createListValueForm.optionValue.$error"
                                                         ng-if="ctrl.createListValueForm.$error.optionValueExists">
                                                        <div class="message-animation" >
                                                            <strong>Option value exists already.</strong>
                                                        </div>
                                                    </div>                                                    

                                                </div>

                                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('displayOrder')}">
                                                    <label for="displayOrder">Display Order</label>
                                                    <input id="displayOrder" name="displayOrder" class="form-control" type="number"
                                                           ng-model="ctrl.newListValue.displayOrder"
                                                           ng-focus="" ng-blur="" tabindex="3" />

                                                </div>



                                            </div> 
                                      </div>
                                    </div>
                                        <div class="panel-footer">
                                            <div class="pull-left">
                                                <a data-play="fadeInDown" data-target="#panel-anim-fadeInDown" data-toggle="play-animation" href="javascript:void(0);">
                                                    <button class="btn btn-default" type="button" ng-click="ShowHide('ADJREASON')">Cancel</button>
                                                </a>

                                            </div>
                                            <div ng-hide="ctrl.editListValueState" class="pull-right">
                                                <button  class="btn btn-primary" type="submit">Save</button>
                                            </div>
                                            <div ng-show="ctrl.editListValueState" class="pull-right">
                                                <button class="btn btn-primary" type="button" ng-click="ctrl.editListValue()">Update</button>
                                            </div>                                            
                                            <br style="clear: both;"/>
                                        </div>                                  
                                  </div>  
                                </form>

                            </div>

                       <!-- </div>                       
            </div> -->



                    <!-- Nav tabs -->
                    <!-- <ul class="nav nav-tabs">
                        <li id="liAdjReason" class="active"><a href="#adjReason" data-toggle="tab" ng-click = "ctrl.getAllListValues('ADJREASON')">Adjustment Reason</a></li>
                        <li id="liItmcat"><a href="#itmcat" data-toggle="tab" ng-click = "ctrl.getAllListValues('ITEMCAT')">Item Category</a></li>
                        <li id="liRshsp"><a href="#rshsp" data-toggle="tab" ng-click = "ctrl.getAllListValues('RSHSP')">Requested Ship Speed</a></li>
                        <li id="liStrg"><a href="#strg" data-toggle="tab" ng-click = "ctrl.getAllListValues('STRG')">Storage Attributes</a></li>
                        <li id="liCrrcode"><a href="#crrcode" data-toggle="tab" ng-click = "ctrl.getAllListValues('CARRCODE')">Carrier Code</a></li>
                        <li id="liInvState"><a href="#invState" data-toggle="tab" ng-click = "ctrl.getAllListValues('INVSTATUS')">Inventory Status</a></li>
                        <li id="liInvState"><a href="#cancelPickReason" data-toggle="tab" ng-click = "ctrl.getAllListValues('CPR')">Cancel Pick Reason</a></li>                       
                    </ul> -->
                    <!-- Tab panes -->
                    <br style="clear: both;"/>
                    <br style="clear: both;"/>


                    <div id="grid1" ui-grid="gridAdjReasonListValue" ui-grid-exporter ui-grid-resize-columns  class="grid">
                        <div class="noItemMessage" ng-if="gridAdjReasonListValue.data.length == 0">No List values Found.</div>
                    </div>                     
                </div>
                <!--/.panel-body -->
            </div>
            <!-- END panel-->

            <div class="gap-50"></div>
            <h4>Item Category</h4>
            <!-- START panel-->
            <div class="panel panel-default panel-content"  id="ItemCategory">
                <div class="panel-body" >
                        <%-- **************************** create ListValue form **************************** --%>
                            <a data-play="fadeInDown" data-target="#panel-anim-fadeInDown" data-toggle="play-animation" href="javascript:void(0);">
                                <button type="button" class="btn btn-primary newFormCreateBtn pull-right" ng-click="ShowHide('ITEMCAT')">
                                    <em class="fa fa-plus-circle fa-fw mr-sm"></em>
                                    New Item Category
                                </button>
                            </a>
                            <br style="clear: both;"/>
                            <br style="clear: both;"/>

                            <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showSubmittedPrompt">
                                <g:message code="listValue.create.message" />
                            </div>
                            <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showDeletedPrompt">
                                <g:message code="item.delete.message" />
                            </div>
                            <div ng-init="ctrl.getAllListValues('ITEMCAT')"></div>
                            <div ng-show="IsVisibleItemCat" class="row">

                                <form name="ctrl.createListValueForm" ng-submit="ctrl.createListValue()" novalidate >

                                    <div class="panel panel-default" id="panel-anim-fadeInDown">
                                        <div class="panel-heading">                                         
                                            <div class="panel-title">Add Item Category</div>
                                        </div>

                                        <div class="panel-body">
                                         <div class="col-md-12">
                                            <div class="col-md-6">

                                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('optionGroup')}">

                                                    <label for="optionGroup">Option Group</label>
                                                    <select  id="optionGroup" name="optionGroup" ng-model="ctrl.newListValue.optionGroup" class="form-control" required  disabled>     
                                                        <option ng-repeat="listValueData in  ctrl.listValueData" value="{{listValueData.optionGroup}}">{{listValueData.optionGroup}}
                                                        </option>
                                                    </select>


                                                    <div class="my-messages">
                                                        <div class="prompt message-animation" ng-if="ctrl.showOptionGroupPrompt">
                                                            Choose an Option Group.
                                                        </div>
                                                    </div>

                                                    <div class="my-messages"  ng-messages="ctrl.createListValueForm.optionGroup.$error"
                                                         ng-if="ctrl.createListValueForm.$error.optionGroupExists">
                                                        <div class="message-animation" >
                                                            <strong>Receipt Id exists already.</strong>
                                                        </div>
                                                    </div>

                                                    <div class="my-messages" ng-messages="ctrl.createListValueForm.optionGroup.$error" ng-if="ctrl.showMessages('optionGroup')">
                                                        <div class="message-animation" ng-message="required">
                                                            <strong>This field is required.</strong>
                                                        </div>
                                                    </div>
                                                </div>


                                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('description')}">
                                                    <label for="description">Description</label>
                                                    <input id="description" name="description" class="form-control" type="text" required
                                                           ng-model="ctrl.newListValue.description"
                                                           ng-focus="" ng-blur="ctrl.validateDescription(ctrl.newListValue.description);" tabindex="2" />


                                                    <div class="my-messages" ng-messages="ctrl.createListValueForm.description.$error" ng-if="ctrl.showMessages('description')">
                                                        <div class="message-animation" ng-message="required">
                                                            <strong>This field is required.</strong>
                                                        </div>
                                                    </div>
                                                </div>

                                               <div class="my-messages"  ng-messages="ctrl.createListValueForm.description.$error"
                                                     ng-if="ctrl.createListValueForm.$error.descriptionExists">
                                                    <div class="message-animation" >
                                                        <strong>value of description exists already.</strong>
                                                    </div>
                                                </div> 

                                            </div>

                                            <div class="col-md-6">


                                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('optionValue')}">
                                                    <label for="optionValue">Option Value</label>
                                                    <input id="optionValue" name="optionValue" class="form-control" type="text"
                                                           ng-model="ctrl.newListValue.optionValue"
                                                           ng-focus="" ng-blur="ctrl.validateOptionValue(ctrl.newListValue.optionValue);" ng-disabled = "ctrl.editListValueState" maxlength="15" tabindex="1" />


                                                    <div class="my-messages"  ng-messages="ctrl.createListValueForm.optionValue.$error"
                                                         ng-if="ctrl.createListValueForm.$error.optionValueExists">
                                                        <div class="message-animation" >
                                                            <strong>Option value exists already.</strong>
                                                        </div>
                                                    </div>                                                    

                                                </div>

                                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('displayOrder')}">
                                                    <label for="displayOrder">Display Order</label>
                                                    <input id="displayOrder" name="displayOrder" class="form-control" type="number"
                                                           ng-model="ctrl.newListValue.displayOrder"
                                                           ng-focus="" ng-blur="" tabindex="3" />

                                                </div>



                                            </div> 
                                      </div>
                                    </div>
                                        <div class="panel-footer">
                                            <div class="pull-left">
                                                <a data-play="fadeInDown" data-target="#panel-anim-fadeInDown" data-toggle="play-animation" href="javascript:void(0);">
                                                    <button class="btn btn-default" type="button" ng-click="ShowHide('ITEMCAT')">Cancel</button>
                                                </a>

                                            </div>
                                            <div ng-hide="ctrl.editListValueState" class="pull-right">
                                                <button  class="btn btn-primary" type="submit">Save</button>
                                            </div>
                                            <div ng-show="ctrl.editListValueState" class="pull-right">
                                                <button class="btn btn-primary" type="button" ng-click="ctrl.editListValue()">Update</button>
                                            </div>                                            
                                            <br style="clear: both;"/>
                                        </div>                                  
                                  </div>  
                                </form>

                            </div>

                       <!-- </div>                       
            </div> -->
                    <div id="grid1" ui-grid="gridItemcatListValue" ui-grid-exporter ui-grid-resize-columns  class="grid">
                        <div class="noItemMessage" ng-if="gridItemcatListValue.data.length == 0">No List values Found.</div>
                    </div>                  
                </div>
                <!--/.panel-body -->
            </div>
            <!-- END panel-->

            <div class="gap-50"></div>
            <h4>Requested Ship Speed</h4>
            <!-- START panel-->
            <div class="panel panel-default panel-content" id="RequestedShipSpeed">
                <div class="panel-body" >
                        <%-- **************************** create ListValue form **************************** --%>
                            <a data-play="fadeInDown" data-target="#panel-anim-fadeInDown" data-toggle="play-animation" href="javascript:void(0);">
                                <button type="button" class="btn btn-primary newFormCreateBtn pull-right" ng-click="ShowHide('RSHSP')">
                                    <em class="fa fa-plus-circle fa-fw mr-sm"></em>
                                    New Requested Ship Speed
                                </button>
                            </a>
                            <br style="clear: both;"/>
                            <br style="clear: both;"/>

                            <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showSubmittedPrompt">
                                <g:message code="listValue.create.message" />
                            </div>
                            <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showDeletedPrompt">
                                <g:message code="item.delete.message" />
                            </div>
                            <div ng-init="ctrl.getAllListValues('RSHSP')"></div>

                            <div ng-show="IsVisibleRshsp" class="row">

                                <form name="ctrl.createListValueForm" ng-submit="ctrl.createListValue()" novalidate >

                                    <div class="panel panel-default" id="panel-anim-fadeInDown">
                                        <div class="panel-heading">                                         
                                            <div class="panel-title">Add Requested Ship Speed</div>
                                        </div>

                                        <div class="panel-body">
                                         <div class="col-md-12">
                                            <div class="col-md-6">

                                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('optionGroup')}">

                                                    <label for="optionGroup">Option Group</label>
                                                    <select  id="optionGroup" name="optionGroup" ng-model="ctrl.newListValue.optionGroup" class="form-control" required  disabled>     
                                                        <option ng-repeat="listValueData in  ctrl.listValueData" value="{{listValueData.optionGroup}}">{{listValueData.optionGroup}}
                                                        </option>
                                                    </select>


                                                    <div class="my-messages">
                                                        <div class="prompt message-animation" ng-if="ctrl.showOptionGroupPrompt">
                                                            Choose an Option Group.
                                                        </div>
                                                    </div>

                                                    <div class="my-messages"  ng-messages="ctrl.createListValueForm.optionGroup.$error"
                                                         ng-if="ctrl.createListValueForm.$error.optionGroupExists">
                                                        <div class="message-animation" >
                                                            <strong>Receipt Id exists already.</strong>
                                                        </div>
                                                    </div>

                                                    <div class="my-messages" ng-messages="ctrl.createListValueForm.optionGroup.$error" ng-if="ctrl.showMessages('optionGroup')">
                                                        <div class="message-animation" ng-message="required">
                                                            <strong>This field is required.</strong>
                                                        </div>
                                                    </div>
                                                </div>


                                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('description')}">
                                                    <label for="description">Description</label>
                                                    <input id="description" name="description" class="form-control" type="text" required
                                                           ng-model="ctrl.newListValue.description"
                                                           ng-focus="" ng-blur="ctrl.validateDescription(ctrl.newListValue.description);" tabindex="2" />


                                                    <div class="my-messages" ng-messages="ctrl.createListValueForm.description.$error" ng-if="ctrl.showMessages('description')">
                                                        <div class="message-animation" ng-message="required">
                                                            <strong>This field is required.</strong>
                                                        </div>
                                                    </div>
                                                </div>

                                               <div class="my-messages"  ng-messages="ctrl.createListValueForm.description.$error"
                                                     ng-if="ctrl.createListValueForm.$error.descriptionExists">
                                                    <div class="message-animation" >
                                                        <strong>value of description exists already.</strong>
                                                    </div>
                                                </div> 

                                            </div>

                                            <div class="col-md-6">


                                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('optionValue')}">
                                                    <label for="optionValue">Option Value</label>
                                                    <input id="optionValue" name="optionValue" class="form-control" type="text"
                                                           ng-model="ctrl.newListValue.optionValue"
                                                           ng-focus="" ng-blur="ctrl.validateOptionValue(ctrl.newListValue.optionValue);" ng-disabled = "ctrl.editListValueState" maxlength="15" tabindex="1" />


                                                    <div class="my-messages"  ng-messages="ctrl.createListValueForm.optionValue.$error"
                                                         ng-if="ctrl.createListValueForm.$error.optionValueExists">
                                                        <div class="message-animation" >
                                                            <strong>Option value exists already.</strong>
                                                        </div>
                                                    </div>                                                    

                                                </div>

                                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('displayOrder')}">
                                                    <label for="displayOrder">Display Order</label>
                                                    <input id="displayOrder" name="displayOrder" class="form-control" type="number"
                                                           ng-model="ctrl.newListValue.displayOrder"
                                                           ng-focus="" ng-blur="" tabindex="3" />

                                                </div>



                                            </div> 
                                      </div>
                                    </div>
                                        <div class="panel-footer">
                                            <div class="pull-left">
                                                <a data-play="fadeInDown" data-target="#panel-anim-fadeInDown" data-toggle="play-animation" href="javascript:void(0);">
                                                    <button class="btn btn-default" type="button" ng-click="ShowHide('RSHSP')">Cancel</button>
                                                </a>

                                            </div>
                                            <div ng-hide="ctrl.editListValueState" class="pull-right">
                                                <button  class="btn btn-primary" type="submit">Save</button>
                                            </div>
                                            <div ng-show="ctrl.editListValueState" class="pull-right">
                                                <button class="btn btn-primary" type="button" ng-click="ctrl.editListValue()">Update</button>
                                            </div>                                            
                                            <br style="clear: both;"/>
                                        </div>                                  
                                  </div>  
                                </form>

                            </div>

                       <!-- </div>                       
            </div> -->
                    <div id="grid1" ui-grid="gridRshspValue" ui-grid-exporter ui-grid-resize-columns  class="grid">
                        <div class="noItemMessage" ng-if="gridRshspValue.data.length == 0">No List values Found.</div>
                    </div>                  
                </div>
                <!--/.panel-body -->
            </div>
            <!-- END panel-->

            <div class="gap-50"></div>
            <h4>Storage Attributes</h4>
            <!-- START panel-->
            <div class="panel panel-default panel-content" id="StorageAttributes">
                <div class="panel-body" >
                        <%-- **************************** create ListValue form **************************** --%>
                            <a data-play="fadeInDown" data-target="#panel-anim-fadeInDown" data-toggle="play-animation" href="javascript:void(0);">
                                <button type="button" class="btn btn-primary newFormCreateBtn pull-right" ng-click="ShowHide('STRG')">
                                    <em class="fa fa-plus-circle fa-fw mr-sm"></em>
                                    New Storage Attributes
                                </button>
                            </a>
                            <br style="clear: both;"/>
                            <br style="clear: both;"/>

                            <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showSubmittedPrompt">
                                <g:message code="listValue.create.message" />
                            </div>
                            <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showDeletedPrompt">
                                <g:message code="item.delete.message" />
                            </div>
                            <div ng-init="ctrl.getAllListValues('STRG')"></div>

                            <div ng-show="IsVisibleStrg" class="row">

                                <form name="ctrl.createListValueForm" ng-submit="ctrl.createListValue()" novalidate >

                                    <div class="panel panel-default" id="panel-anim-fadeInDown">
                                        <div class="panel-heading">                                         
                                            <div class="panel-title">Add Storage Attributes</div>
                                        </div>

                                        <div class="panel-body">
                                         <div class="col-md-12">
                                            <div class="col-md-6">

                                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('optionGroup')}">

                                                    <label for="optionGroup">Option Group</label>
                                                    <select  id="optionGroup" name="optionGroup" ng-model="ctrl.newListValue.optionGroup" class="form-control" required  disabled>     
                                                        <option ng-repeat="listValueData in  ctrl.listValueData" value="{{listValueData.optionGroup}}">{{listValueData.optionGroup}}
                                                        </option>
                                                    </select>


                                                    <div class="my-messages">
                                                        <div class="prompt message-animation" ng-if="ctrl.showOptionGroupPrompt">
                                                            Choose an Option Group.
                                                        </div>
                                                    </div>

                                                    <div class="my-messages"  ng-messages="ctrl.createListValueForm.optionGroup.$error"
                                                         ng-if="ctrl.createListValueForm.$error.optionGroupExists">
                                                        <div class="message-animation" >
                                                            <strong>Receipt Id exists already.</strong>
                                                        </div>
                                                    </div>

                                                    <div class="my-messages" ng-messages="ctrl.createListValueForm.optionGroup.$error" ng-if="ctrl.showMessages('optionGroup')">
                                                        <div class="message-animation" ng-message="required">
                                                            <strong>This field is required.</strong>
                                                        </div>
                                                    </div>
                                                </div>


                                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('description')}">
                                                    <label for="description">Description</label>
                                                    <input id="description" name="description" class="form-control" type="text" required
                                                           ng-model="ctrl.newListValue.description"
                                                           ng-focus="" ng-blur="ctrl.validateDescription(ctrl.newListValue.description);" tabindex="2" />


                                                    <div class="my-messages" ng-messages="ctrl.createListValueForm.description.$error" ng-if="ctrl.showMessages('description')">
                                                        <div class="message-animation" ng-message="required">
                                                            <strong>This field is required.</strong>
                                                        </div>
                                                    </div>
                                                </div>

                                               <div class="my-messages"  ng-messages="ctrl.createListValueForm.description.$error"
                                                     ng-if="ctrl.createListValueForm.$error.descriptionExists">
                                                    <div class="message-animation" >
                                                        <strong>value of description exists already.</strong>
                                                    </div>
                                                </div> 

                                            </div>

                                            <div class="col-md-6">


                                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('optionValue')}">
                                                    <label for="optionValue">Option Value</label>
                                                    <input id="optionValue" name="optionValue" class="form-control" type="text"
                                                           ng-model="ctrl.newListValue.optionValue"
                                                           ng-focus="" ng-blur="ctrl.validateOptionValue(ctrl.newListValue.optionValue);" ng-disabled = "ctrl.editListValueState" maxlength="15" tabindex="1" />


                                                    <div class="my-messages"  ng-messages="ctrl.createListValueForm.optionValue.$error"
                                                         ng-if="ctrl.createListValueForm.$error.optionValueExists">
                                                        <div class="message-animation" >
                                                            <strong>Option value exists already.</strong>
                                                        </div>
                                                    </div>                                                    

                                                </div>

                                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('displayOrder')}">
                                                    <label for="displayOrder">Display Order</label>
                                                    <input id="displayOrder" name="displayOrder" class="form-control" type="number"
                                                           ng-model="ctrl.newListValue.displayOrder"
                                                           ng-focus="" ng-blur="" tabindex="3" />

                                                </div>



                                            </div> 
                                      </div>
                                    </div>
                                        <div class="panel-footer">
                                            <div class="pull-left">
                                                <a data-play="fadeInDown" data-target="#panel-anim-fadeInDown" data-toggle="play-animation" href="javascript:void(0);">
                                                    <button class="btn btn-default" type="button" ng-click="ShowHide('STRG')">Cancel</button>
                                                </a>

                                            </div>
                                            <div ng-hide="ctrl.editListValueState" class="pull-right">
                                                <button  class="btn btn-primary" type="submit">Save</button>
                                            </div>
                                            <div ng-show="ctrl.editListValueState" class="pull-right">
                                                <button class="btn btn-primary" type="button" ng-click="ctrl.editListValue()">Update</button>
                                            </div>                                            
                                            <br style="clear: both;"/>
                                        </div>                                  
                                  </div>  
                                </form>

                            </div>

                       <!-- </div>                       
            </div> -->
                    <div id="grid1" ui-grid="gridStrgValue" ui-grid-exporter ui-grid-resize-columns  class="grid">
                        <div class="noItemMessage" ng-if="gridStrgValue.data.length == 0">No List values Found.</div>
                    </div>                  
                </div>
                <!--/.panel-body -->
            </div>
            <!-- END panel-->


            <div class="gap-50"></div>
            <h4>Carrier Code</h4>
            <!-- START panel-->
            <div class="panel panel-default panel-content" id="CarrierCode" >
                <div class="panel-body" >
                        <%-- **************************** create ListValue form **************************** --%>
                            <a data-play="fadeInDown" data-target="#panel-anim-fadeInDown" data-toggle="play-animation" href="javascript:void(0);">
                                <button type="button" class="btn btn-primary newFormCreateBtn pull-right" ng-click="ShowHide('CARRCODE')">
                                    <em class="fa fa-plus-circle fa-fw mr-sm"></em>
                                    New Carrier Code
                                </button>
                            </a>
                            <br style="clear: both;"/>
                            <br style="clear: both;"/>

                            <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showSubmittedPrompt">
                                <g:message code="listValue.create.message" />
                            </div>
                            <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showDeletedPrompt">
                                <g:message code="item.delete.message" />
                            </div>
                            <div ng-init="ctrl.getAllListValues('CARRCODE')"></div>

                            <div ng-show="IsVisibleCarrCode" class="row">

                                <form name="ctrl.createListValueForm" ng-submit="ctrl.createListValue()" novalidate >

                                    <div class="panel panel-default" id="panel-anim-fadeInDown">
                                        <div class="panel-heading">                                         
                                            <div class="panel-title">Add Carrier Code</div>
                                        </div>

                                        <div class="panel-body">
                                         <div class="col-md-12">
                                            <div class="col-md-6">

                                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('optionGroup')}">

                                                    <label for="optionGroup">Option Group</label>
                                                    <select  id="optionGroup" name="optionGroup" ng-model="ctrl.newListValue.optionGroup" class="form-control" required  disabled>     
                                                        <option ng-repeat="listValueData in  ctrl.listValueData" value="{{listValueData.optionGroup}}">{{listValueData.optionGroup}}
                                                        </option>
                                                    </select>


                                                    <div class="my-messages">
                                                        <div class="prompt message-animation" ng-if="ctrl.showOptionGroupPrompt">
                                                            Choose an Option Group.
                                                        </div>
                                                    </div>

                                                    <div class="my-messages"  ng-messages="ctrl.createListValueForm.optionGroup.$error"
                                                         ng-if="ctrl.createListValueForm.$error.optionGroupExists">
                                                        <div class="message-animation" >
                                                            <strong>Receipt Id exists already.</strong>
                                                        </div>
                                                    </div>

                                                    <div class="my-messages" ng-messages="ctrl.createListValueForm.optionGroup.$error" ng-if="ctrl.showMessages('optionGroup')">
                                                        <div class="message-animation" ng-message="required">
                                                            <strong>This field is required.</strong>
                                                        </div>
                                                    </div>
                                                </div>


                                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('description')}">
                                                    <label for="description">Description</label>
                                                    <input id="description" name="description" class="form-control" type="text" required
                                                           ng-model="ctrl.newListValue.description"
                                                           ng-focus="" ng-blur="ctrl.validateDescription(ctrl.newListValue.description);" tabindex="2" />


                                                    <div class="my-messages" ng-messages="ctrl.createListValueForm.description.$error" ng-if="ctrl.showMessages('description')">
                                                        <div class="message-animation" ng-message="required">
                                                            <strong>This field is required.</strong>
                                                        </div>
                                                    </div>
                                                </div>

                                               <div class="my-messages"  ng-messages="ctrl.createListValueForm.description.$error"
                                                     ng-if="ctrl.createListValueForm.$error.descriptionExists">
                                                    <div class="message-animation" >
                                                        <strong>value of description exists already.</strong>
                                                    </div>
                                                </div> 

                                            </div>

                                            <div class="col-md-6">


                                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('optionValue')}">
                                                    <label for="optionValue">Option Value</label>
                                                    <input id="optionValue" name="optionValue" class="form-control" type="text"
                                                           ng-model="ctrl.newListValue.optionValue"
                                                           ng-focus="" ng-blur="ctrl.validateOptionValue(ctrl.newListValue.optionValue);" ng-disabled = "ctrl.editListValueState" maxlength="15" tabindex="1" />


                                                    <div class="my-messages"  ng-messages="ctrl.createListValueForm.optionValue.$error"
                                                         ng-if="ctrl.createListValueForm.$error.optionValueExists">
                                                        <div class="message-animation" >
                                                            <strong>Option value exists already.</strong>
                                                        </div>
                                                    </div>                                                    

                                                </div>

                                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('displayOrder')}">
                                                    <label for="displayOrder">Display Order</label>
                                                    <input id="displayOrder" name="displayOrder" class="form-control" type="number"
                                                           ng-model="ctrl.newListValue.displayOrder"
                                                           ng-focus="" ng-blur="" tabindex="3" />

                                                </div>



                                            </div> 
                                      </div>
                                    </div>
                                        <div class="panel-footer">
                                            <div class="pull-left">
                                                <a data-play="fadeInDown" data-target="#panel-anim-fadeInDown" data-toggle="play-animation" href="javascript:void(0);">
                                                    <button class="btn btn-default" type="button" ng-click="ShowHide('CARRCODE')">Cancel</button>
                                                </a>

                                            </div>
                                            <div ng-hide="ctrl.editListValueState" class="pull-right">
                                                <button  class="btn btn-primary" type="submit">Save</button>
                                            </div>
                                            <div ng-show="ctrl.editListValueState" class="pull-right">
                                                <button class="btn btn-primary" type="button" ng-click="ctrl.editListValue()">Update</button>
                                            </div>                                            
                                            <br style="clear: both;"/>
                                        </div>                                  
                                  </div>  
                                </form>

                            </div>

                       <!-- </div>                       
            </div> -->
                    <div id="grid1" ui-grid="gridCarrCodeValue" ui-grid-exporter ui-grid-resize-columns  class="grid">
                        <div class="noItemMessage" ng-if="gridCarrCodeValue.data.length == 0">No List values Found.</div>
                    </div>                  
                </div>
                <!--/.panel-body -->
            </div>
            <!-- END panel-->
            <div class="gap-50"></div>
            <h4>Inventory Status</h4>
            <!-- START panel-->
            <div class="panel panel-default panel-content" id="InventoryStatus" >
                <div class="panel-body" >
                        <%-- **************************** create ListValue form **************************** --%>
                            <a data-play="fadeInDown" data-target="#panel-anim-fadeInDown" data-toggle="play-animation" href="javascript:void(0);">
                                <button type="button" class="btn btn-primary newFormCreateBtn pull-right" ng-click="ShowHide('INVSTATUS')">
                                    <em class="fa fa-plus-circle fa-fw mr-sm"></em>
                                    New Inventory Status
                                </button>
                            </a>
                            <br style="clear: both;"/>
                            <br style="clear: both;"/>

                            <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showSubmittedPrompt">
                                <g:message code="listValue.create.message" />
                            </div>
                            <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showDeletedPrompt">
                                <g:message code="item.delete.message" />
                            </div>
                            <div ng-init="ctrl.getAllListValues('INVSTATUS')"></div>

                            <div ng-show="IsVisibleInvStatus" class="row">

                                <form name="ctrl.createListValueForm" ng-submit="ctrl.createListValue()" novalidate >

                                    <div class="panel panel-default" id="panel-anim-fadeInDown">
                                        <div class="panel-heading">                                         
                                            <div class="panel-title">Add Inventory Status</div>
                                        </div>

                                        <div class="panel-body">
                                         <div class="col-md-12">
                                            <div class="col-md-6">

                                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('optionGroup')}">

                                                    <label for="optionGroup">Option Group</label>
                                                    <select  id="optionGroup" name="optionGroup" ng-model="ctrl.newListValue.optionGroup" class="form-control" required  disabled>     
                                                        <option ng-repeat="listValueData in  ctrl.listValueData" value="{{listValueData.optionGroup}}">{{listValueData.optionGroup}}
                                                        </option>
                                                    </select>


                                                    <div class="my-messages">
                                                        <div class="prompt message-animation" ng-if="ctrl.showOptionGroupPrompt">
                                                            Choose an Option Group.
                                                        </div>
                                                    </div>

                                                    <div class="my-messages"  ng-messages="ctrl.createListValueForm.optionGroup.$error"
                                                         ng-if="ctrl.createListValueForm.$error.optionGroupExists">
                                                        <div class="message-animation" >
                                                            <strong>Receipt Id exists already.</strong>
                                                        </div>
                                                    </div>

                                                    <div class="my-messages" ng-messages="ctrl.createListValueForm.optionGroup.$error" ng-if="ctrl.showMessages('optionGroup')">
                                                        <div class="message-animation" ng-message="required">
                                                            <strong>This field is required.</strong>
                                                        </div>
                                                    </div>
                                                </div>


                                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('description')}">
                                                    <label for="description">Description</label>
                                                    <input id="description" name="description" class="form-control" type="text" required
                                                           ng-model="ctrl.newListValue.description"
                                                           ng-focus="" ng-blur="ctrl.validateDescription(ctrl.newListValue.description);" tabindex="2" />


                                                    <div class="my-messages" ng-messages="ctrl.createListValueForm.description.$error" ng-if="ctrl.showMessages('description')">
                                                        <div class="message-animation" ng-message="required">
                                                            <strong>This field is required.</strong>
                                                        </div>
                                                    </div>
                                                </div>

                                               <div class="my-messages"  ng-messages="ctrl.createListValueForm.description.$error"
                                                     ng-if="ctrl.createListValueForm.$error.descriptionExists">
                                                    <div class="message-animation" >
                                                        <strong>value of description exists already.</strong>
                                                    </div>
                                                </div> 

                                            </div>

                                            <div class="col-md-6">


                                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('optionValue')}">
                                                    <label for="optionValue">Option Value</label>
                                                    <input id="optionValue" name="optionValue" class="form-control" type="text"
                                                           ng-model="ctrl.newListValue.optionValue"
                                                           ng-focus="" ng-blur="ctrl.validateOptionValue(ctrl.newListValue.optionValue);" ng-disabled = "ctrl.editListValueState" maxlength="15" tabindex="1" />


                                                    <div class="my-messages"  ng-messages="ctrl.createListValueForm.optionValue.$error"
                                                         ng-if="ctrl.createListValueForm.$error.optionValueExists">
                                                        <div class="message-animation" >
                                                            <strong>Option value exists already.</strong>
                                                        </div>
                                                    </div>                                                    

                                                </div>

                                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('displayOrder')}">
                                                    <label for="displayOrder">Display Order</label>
                                                    <input id="displayOrder" name="displayOrder" class="form-control" type="number"
                                                           ng-model="ctrl.newListValue.displayOrder"
                                                           ng-focus="" ng-blur="" tabindex="3" />

                                                </div>



                                            </div> 
                                      </div>
                                    </div>
                                        <div class="panel-footer">
                                            <div class="pull-left">
                                                <a data-play="fadeInDown" data-target="#panel-anim-fadeInDown" data-toggle="play-animation" href="javascript:void(0);">
                                                    <button class="btn btn-default" type="button" ng-click="ShowHide('INVSTATUS')">Cancel</button>
                                                </a>

                                            </div>
                                            <div ng-hide="ctrl.editListValueState" class="pull-right">
                                                <button  class="btn btn-primary" type="submit">Save</button>
                                            </div>
                                            <div ng-show="ctrl.editListValueState" class="pull-right">
                                                <button class="btn btn-primary" type="button" ng-click="ctrl.editListValue()">Update</button>
                                            </div>                                            
                                            <br style="clear: both;"/>
                                        </div>                                  
                                  </div>  
                                </form>

                            </div>

                       <!-- </div>                       
            </div> -->
                    <div id="grid1" ui-grid="gridInvStatusValue" ui-grid-exporter ui-grid-resize-columns  class="grid">
                        <div class="noItemMessage" ng-if="gridInvStatusValue.data.length == 0">No List values Found.</div>
                    </div>                  
                </div>
                <!--/.panel-body -->
            </div>
            <!-- END panel-->
            <div class="gap-50"></div>
            <h4>Cancel Pick Reason</h4>
            <!-- START panel-->
            <div class="panel panel-default panel-content" id="CancelPickReason">
                <div class="panel-body" >
                        <%-- **************************** create ListValue form **************************** --%>
                            <a data-play="fadeInDown" data-target="#panel-anim-fadeInDown" data-toggle="play-animation" href="javascript:void(0);">
                                <button type="button" class="btn btn-primary newFormCreateBtn pull-right" ng-click="ShowHide('CPR')">
                                    <em class="fa fa-plus-circle fa-fw mr-sm"></em>
                                    New Cancel Pick Reason
                                </button>
                            </a>
                            <br style="clear: both;"/>
                            <br style="clear: both;"/>

                            <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showSubmittedPrompt">
                                <g:message code="listValue.create.message" />
                            </div>
                            <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showDeletedPrompt">
                                <g:message code="item.delete.message" />
                            </div>
                            <div ng-init="ctrl.getAllListValues('CPR')"></div>

                            <div ng-show="IsVisibleCpr" class="row">

                                <form name="ctrl.createListValueForm" ng-submit="ctrl.createListValue()" novalidate >

                                    <div class="panel panel-default" id="panel-anim-fadeInDown">
                                        <div class="panel-heading">                                         
                                            <div class="panel-title">Add Cancel Pick Reason</div>
                                        </div>

                                        <div class="panel-body">
                                         <div class="col-md-12">
                                            <div class="col-md-6">

                                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('optionGroup')}">

                                                    <label for="optionGroup">Option Group</label>
                                                    <select  id="optionGroup" name="optionGroup" ng-model="ctrl.newListValue.optionGroup" class="form-control" required  disabled>     
                                                        <option ng-repeat="listValueData in  ctrl.listValueData" value="{{listValueData.optionGroup}}">{{listValueData.optionGroup}}
                                                        </option>
                                                    </select>


                                                    <div class="my-messages">
                                                        <div class="prompt message-animation" ng-if="ctrl.showOptionGroupPrompt">
                                                            Choose an Option Group.
                                                        </div>
                                                    </div>

                                                    <div class="my-messages"  ng-messages="ctrl.createListValueForm.optionGroup.$error"
                                                         ng-if="ctrl.createListValueForm.$error.optionGroupExists">
                                                        <div class="message-animation" >
                                                            <strong>Receipt Id exists already.</strong>
                                                        </div>
                                                    </div>

                                                    <div class="my-messages" ng-messages="ctrl.createListValueForm.optionGroup.$error" ng-if="ctrl.showMessages('optionGroup')">
                                                        <div class="message-animation" ng-message="required">
                                                            <strong>This field is required.</strong>
                                                        </div>
                                                    </div>
                                                </div>


                                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('description')}">
                                                    <label for="description">Description</label>
                                                    <input id="description" name="description" class="form-control" type="text" required
                                                           ng-model="ctrl.newListValue.description"
                                                           ng-focus="" ng-blur="ctrl.validateDescription(ctrl.newListValue.description);" tabindex="2" />


                                                    <div class="my-messages" ng-messages="ctrl.createListValueForm.description.$error" ng-if="ctrl.showMessages('description')">
                                                        <div class="message-animation" ng-message="required">
                                                            <strong>This field is required.</strong>
                                                        </div>
                                                    </div>
                                                </div>

                                               <div class="my-messages"  ng-messages="ctrl.createListValueForm.description.$error"
                                                     ng-if="ctrl.createListValueForm.$error.descriptionExists">
                                                    <div class="message-animation" >
                                                        <strong>value of description exists already.</strong>
                                                    </div>
                                                </div> 

                                            </div>

                                            <div class="col-md-6">


                                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('optionValue')}">
                                                    <label for="optionValue">Option Value</label>
                                                    <input id="optionValue" name="optionValue" class="form-control" type="text"
                                                           ng-model="ctrl.newListValue.optionValue"
                                                           ng-focus="" ng-blur="ctrl.validateOptionValue(ctrl.newListValue.optionValue);" ng-disabled = "ctrl.editListValueState" maxlength="15" tabindex="1" />


                                                    <div class="my-messages"  ng-messages="ctrl.createListValueForm.optionValue.$error"
                                                         ng-if="ctrl.createListValueForm.$error.optionValueExists">
                                                        <div class="message-animation" >
                                                            <strong>Option value exists already.</strong>
                                                        </div>
                                                    </div>                                                    

                                                </div>

                                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('displayOrder')}">
                                                    <label for="displayOrder">Display Order</label>
                                                    <input id="displayOrder" name="displayOrder" class="form-control" type="number"
                                                           ng-model="ctrl.newListValue.displayOrder"
                                                           ng-focus="" ng-blur="" tabindex="3" />

                                                </div>



                                            </div> 
                                      </div>
                                    </div>
                                        <div class="panel-footer">
                                            <div class="pull-left">
                                                <a data-play="fadeInDown" data-target="#panel-anim-fadeInDown" data-toggle="play-animation" href="javascript:void(0);">
                                                    <button class="btn btn-default" type="button" ng-click="ShowHide('CPR')">Cancel</button>
                                                </a>

                                            </div>
                                            <div ng-hide="ctrl.editListValueState" class="pull-right">
                                                <button  class="btn btn-primary" type="submit">Save</button>
                                            </div>
                                            <div ng-show="ctrl.editListValueState" class="pull-right">
                                                <button class="btn btn-primary" type="button" ng-click="ctrl.editListValue()">Update</button>
                                            </div>                                            
                                            <br style="clear: both;"/>
                                        </div>                                  
                                  </div>  
                                </form>

                            </div>

                       <!-- </div>                       
            </div> -->
                    <div id="grid1" ui-grid="gridCprValue" ui-grid-exporter ui-grid-resize-columns  class="grid">
                        <div class="noItemMessage" ng-if="gridCprValue.data.length == 0">No List values Found.</div>
                    </div>                  
                </div>
                <!--/.panel-body -->
            </div>
            <!-- END panel-->

            <div class="gap-50"></div>
    <h3 class="panel-content" id="configurationDiv">Configuration</h3>

            <!-- START panel-->
                       
                        <%-- **************************** update company easy post form **************************** --%>

                            <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showConfUpdatedPrompt">
                                configuration has been successfully updated.
                            </div>

                                <form name="ctrl.updateWarehouseConfigForm" ng-submit="ctrl.updateWarehouseConfig()" novalidate >

                                    <div class="panel panel-default" id="panel-anim-fadeInDown">
                                        <!-- <div class="panel-heading">                                         
                                            <div class="panel-title">
                                                <button class="btn btn-warning compEdit-Btn pull-right" type="button" ng-click="ctrl.editCompany()" ng-if="!ctrl.profileEditable">
                                                <em class="fa fa-edit fa-fw mr-sm"></em>Edit</button>
                                                </div>
                                        </div> -->
                                        <div class="panel-body">
                                          <div class="col-md-12">
                                                <div class="col-md-6" style="width: 350px;">
                                                    <div class="form-group">
                                                            <label for="autoLoadPalletId">Auto Load Pallet Id For Receiving</label>&emsp;&emsp;&emsp;
                                                            <div class="checkbox c-checkbox" style="display: inline;">
                                                                <label>
                                                                    <input id="autoLoadPalletId" name="autoLoadPalletId" type="checkbox" ng-model="ctrl.autoLoadPalletId">
                                                                    <span class="fa fa-check"></span>
                                                                </label>
                                                            </div>

                                                        </div>
                                                </div> 
                                                <!-- <div class="col-md-4">
                                                    <button style="width:100px; height: 37px" class="btn btn-primary" type="button" ng-click="ctrl.updateAutoLoadPallet()">Update</button>
                                                </div>  -->                                           
                                                <div class="col-md-6" style="width: 350px;">
                                                    <div class="form-group">
                                                            <label for="autoLoadContainerForPackout">Auto Load Container Id For Packout</label>&emsp;&emsp;&emsp;
                                                            <div class="checkbox c-checkbox" style="display: inline;">
                                                                <label>
                                                                    <input id="autoLoadContainerForPackout" name="autoLoadPalletId" type="checkbox" ng-model="ctrl.autoLoadContainerForPackout">
                                                                    <span class="fa fa-check"></span>
                                                                </label>
                                                            </div>

                                                        </div>
                                                </div>
                                            </div> 
                                                <!-- <div class="col-md-4">
                                                    <button style="width:100px; height: 37px" class="btn btn-primary" type="button" ng-click="ctrl.updateAutoContainerForPackout()">Update</button>
                                                </div> --> 
                                            <div class="col-md-12">                                           
                                                <!-- <div class="col-md-6" style="width: 350px;">
                                                    <div class="form-group">
                                                            <label for="autoLoadPalletId">Log Enabled</label>&emsp;&emsp;&emsp;
                                                            <div class="checkbox c-checkbox" style="display: inline;">
                                                                <label>
                                                                    <input id="autoLoadPalletId" name="autoLoadPalletId" type="checkbox" ng-model="ctrl.isLogEnabledConf">
                                                                    <span class="fa fa-check"></span>
                                                                </label>
                                                            </div>

                                                        </div>
                                                </div>  -->
                                                <!-- <div class="col-md-4">
                                                    <button style="width:100px; height: 37px" class="btn btn-primary" type="button" ng-click="ctrl.updateLogging()">Update</button>
                                                </div> -->                                            
                                                <div class="col-md-6" style="width: 145px;"><label for="bolType" style="line-height: 2.5;">Bill Of Lading type</label></div>
                                                    <div class="col-md-3 form-group" style="width: 205px;">
                                                                <select  id="bolType" name="bolType" ng-model="ctrl.companyBolType" class="form-control">

                                                                    <option value="standardBol" >Standard BOL</option>
                                                                    <option value="tempControlledBol">Temperature Controlled Shipment BOL</option>
                                                                </select>
                                                    </div>                                           
                                          </div>
                                        </div>                              
                                        <div class="panel-footer">
                                            <div class="col-md-4">
                                                <button style="width:100px; height: 37px" class="btn btn-primary newFormCreateBtn" type="submit">Update</button>
                                            </div> 
                                            <div class="col-md-12"> 
                                            </div>   
                                            <!-- <div class="pull-left" ng-show="ctrl.profileEditable">
                                                <button style="width:100px; height: 37px; " class="btn btn-default" type="button" ng-click="ctrl.cancelUpdateCompany()">Cancel</button> &emsp;&emsp;
                                            </div> -->                                        
                                            <br style="clear: both;"/>
                                        </div>                                  
                                  </div>  
                                </form>
<%-- **************************** End of company easy post form **************************** --%>


        </div>

<!-- Modal for Adding new item category-->
<div id="AddNewItemCategory" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Add new item category</h4>
            </div>          
            <div class="modal-body">          
                <label>Item Category :</label>         
                <input id="addItemCategory" name="addItemCategory" class="form-control" type="text" ng-model="ctrl.addItemCategory" placeholder = "Enter item Category"/>

            </div>
            <div class="modal-footer">
                <button type="button"  id = "itemCategorycancelSave" class="btn btn-default" data-dismiss="modal">Cancel</button>
                <button type="button" id = "itemCategorySave" class="btn btn-primary">Add</button>
            </div>
        </div>
    </div>
</div>




</div><!-- End of listValueCtrl -->


<!-- bootstrap modal confirmation dialog-->

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


    <asset:javascript src="datagrid/admin-list-value.js"/>

    <script type="text/javascript">
        var dvAdminListValue = document.getElementById('dvAdminListValue');
        angular.element(document).ready(function() {
            angular.bootstrap(dvAdminListValue, ['adminListValue']);
        });
    </script>

</body>
</html>
