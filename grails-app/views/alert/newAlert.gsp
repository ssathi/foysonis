<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="foysonis2016"/>
</head>

<body>
<h3>New Alert</h3>
<!-- new test commit success  -->

<!-- START wrapper-->
<div class="row row-table page-wrapper"  id="dvNewAlert" ng-controller="MyCtrl">
    <div class="col-lg-3 col-md-6 col-sm-8 col-xs-12 align-middle">

        <g:if test="${flash.success}">
            <div class="alert alert-success alert-dismissable">
                <button type="button" data-dismiss="alert" aria-hidden="true" class="close">×</button>${flash.success}
            </div>
        </g:if>

        <g:form name="alertForm" controller="alert" action="send" method="post" ng-submit="submitForm()" novalidate="">

            <!-- START panel-->
            <div data-toggle="play-animation" data-play="fadeIn" data-offset="0" class="panel panel-dark panel-flat">
                <div class="panel panel-primary">
                    <div class="panel-heading">Create Alert</div>
                </div>



                <div class="panel-body">
                    <div class="form-group has-feedback">
                        <label class="control-label">To</label>

                        <g:if test="${session.user.adminActiveStatus == true }">
                                <div auto-complete-multi
                                     placeholder="Enter Username"
                                     xxxx-list-formatter="customListFormatter"
                                     prefill-func="prefillFunc('prefill2.json?ids='+foo_ids)"
                                     source="source3"
                                     value-changed="callback(value)">
                                    <select username='sp' ng-disabled="disabled" ng-model="foo"></select>
                                    <input type="hidden" name="username" ng-model="foo_ids" value="{{ foo_ids }}" required class="form-control" required>
                                </div>
                        </g:if>

                        <g:else>
                                <div auto-complete-multi
                                     placeholder="Enter Username"
                                     xxxx-list-formatter="customListFormatter"
                                     prefill-func="prefillFunc('prefill2.json?ids='+foo_ids)"
                                     source="source2"
                                     value-changed="callback(value)">
                                    <select username='sp' ng-disabled="disabled" ng-model="foo"></select>
                                    <input type="hidden" name="username" ng-model="foo_ids" value="{{ foo_ids }}" required class="form-control" required>
                                </div>
                         </g:else>

                    </div>

                    <div class="form-group has-feedback">
                        <label class="control-label">Message</label>
                        <textarea name="message" required class="form-control" required></textarea>

                    </div>
                </div>

                <div class="panel-footer">
                    <div class="clearfix">
                        <div class="pull-right">
                            <button type="submit" class="btn btn-block btn-primary" ng-disabled="alertForm.$invalid" >Send</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- END panel-->
        </g:form>

    <!--<br/>$scope.foo:  <b>{{ foo }}</b>-->
       <!-- <br/>$scope.foo_ids:  <b>{{ foo_ids }}</b>-->
        <!--<br/>$scope.source: {{ source2 }}-->

    </div>
</div>
<!-- END wrapper-->
<!-- push -->

<asset:javascript src="autocomplete/angular-auto.js"/>
<asset:javascript src="autocomplete/angular-sanitize.js"/>
<asset:javascript src="autocomplete/auto-complete.js"/>
<asset:javascript src="autocomplete/auto-complete-multi.js"/>
<asset:javascript src="autocomplete/auto-complete-div.js"/>
<asset:javascript src="autocomplete/auto-complete-textbox.js"/>
<asset:javascript src="autocomplete/angularjs-autocomplete.js"/>

<asset:javascript src="angular.js"/>


<script type="text/javascript">
    var dvNewAlert = document.getElementById('dvNewAlert');
    angular.element(document).ready(function() {
        angular.bootstrap(dvNewAlert, ['autoCompleteApp']);
    });
</script>



</body>
</html>
