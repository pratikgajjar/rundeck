
<div class="row">
<div class="col-sm-12 ">
<g:form controller="scheduledExecution" method="post" action="runJobNow" class="form-horizontal" role="form">
<div class="panel panel-default panel-tab-content">
<g:if test="${!hideHead}">
    <div class="panel-heading">
        <div>
            <h4>
                Run Job
            </h4>
        </div>
    </div>
</g:if>
    <div class="list-group list-group-tab-content">
<g:if test="${!hideHead}">
            <div class="list-group-item">

                <tmpl:showHead scheduledExecution="${scheduledExecution}" iconName="icon-job"
                               subtitle="Choose Execution Options" runPage="true"/>
            </div>
</g:if>
<div class="list-group-item">
    <g:render template="editOptions" model="${[scheduledExecution:scheduledExecution, selectedoptsmap:selectedoptsmap, selectedargstring:selectedargstring,authorized:authorized,jobexecOptionErrors:jobexecOptionErrors, optiondependencies: optiondependencies, dependentoptions: dependentoptions, optionordering: optionordering]}"/>
    <div class="form-group">
    <div class="col-sm-2 control-label text-form-label">
        Nodes
    </div>
    <div class="col-sm-10">
        <g:if test="${nodesetvariables }">
            <div class="alert alert-info">
                <g:message code="scheduledExecution.nodeset.variable.warning" default="Note: The Node filters specified for this Job contain variable references, and the runtime nodeset cannot be determined."/>
            </div>
        </g:if>
        <g:elseif test="${nodesetempty }">
            <div class="alert alert-warning">
                <g:message code="scheduledExecution.nodeset.empty.warning"/>
            </div>
        </g:elseif>
        <g:elseif test="${!nodes}">
            <p class="form-control-static text-info">
                Will run on local node
            </p>
        </g:elseif>
        <g:elseif test="${nodes}">
            <g:set var="COLS" value="${6}"/>
            <div class="container">
            <div class="row">
                <div class="col-sm-12 checkbox">
                <input name="extra._replaceNodeFilters" value="true" type="checkbox"
                              id="doReplaceFilters"/> <label for="doReplaceFilters">Change the Target Nodes</label>
                </div>
            </div>
            </div>
            <div class=" matchednodes embed jobmatchednodes group_section">
                <%--
                 split node names into groups, in several patterns
                  .*\D(\d+)
                  (\d+)\D.*
                --%>
                <g:if test="${namegroups}">
                    <div class=" group_select_control" style="display:none">
                        Select:
                        <span class="textbtn textbtn-default selectall">All</span>
                        <span class="textbtn textbtn-default selectnone">None</span>
                        <g:if test="${tagsummary}">
                            <g:render template="/framework/tagsummary"
                                      model="${[tagsummary:tagsummary,action:[classnames:'tag tagselected textbtn obs_tag_group',onclick:'']]}"/>
                        </g:if>
                    </div>
                    <g:each in="${namegroups.keySet().sort()}" var="group">
                        <div class="panel panel-default">
                      <div class="panel-heading">
                          <g:set var="expkey" value="${g.rkey()}"/>
                            <g:expander key="${expkey}">
                                <g:if test="${group!='other'}">
                                    <span class="prompt">
                                    ${namegroups[group][0].encodeAsHTML()}</span>
                                    to
                                    <span class="prompt">
                                ${namegroups[group][-1].encodeAsHTML()}
                                    </span>
                                </g:if>
                                <g:else>
                                    <span class="prompt">${namegroups.size()>1?'Other ':''}Matched Nodes</span>
                                </g:else>
                                (${namegroups[group].size()})
                            </g:expander>
                        </div>
                        <div id="${expkey}" style="display:none;" class="group_section panel-body">
                                <g:if test="${namegroups.size()>1}">
                                <div class="group_select_control" style="display:none">
                                    Select:
                                    <span class="textbtn textbtn-default selectall" >All</span>
                                    <span class="textbtn textbtn-default selectnone" >None</span>
                                    <g:if test="${grouptags && grouptags[group]}">
                                        <g:render template="/framework/tagsummary" model="${[tagsummary:grouptags[group],action:[classnames:'tag tagselected textbtn  obs_tag_group',onclick:'']]}"/>
                                    </g:if>
                                </div>
                                </g:if>
                                <table>
                                    <g:each var="node" in="${nodemap.subMap(namegroups[group]).values()}" status="index">
                                        <g:if test="${index % COLS == 0}">
                                            <tr>
                                        </g:if>
                                        <td>
                                            <label for="${node.nodename}"
                                                   class=" ${localNodeName && localNodeName == node.nodename ? 'server' : ''} node_ident obs_tooltip"
                                                   id="${node.nodename}_key">
                                                <input id="${node.nodename}" type="checkbox" name="extra.nodeIncludeName"
                                                       value="${node.nodename}"
                                                    disabled="true"
                                                    tag="${node.tags?.join(' ').encodeAsHTML()}"
                                                       checked="true"/> ${node.nodename.encodeAsHTML()}</label>

                                            <g:render template="/framework/nodeTooltipView"
                                                      model="[node:node,key:node.nodename+'_key',islocal:localNodeName && localNodeName==node.nodename]"/>

                                        </td>
                                        <g:if test="${(index % COLS == (COLS-1)) || (index+1 == namegroups[group].size())}">
                                            </tr>
                                        </g:if>
                                    </g:each>
                                </table>
                            </div>
                        </div>
                    </g:each>
                </g:if>
                <g:else>
                <table>
                <g:each var="node" in="${nodes}" status="index">
                    <g:if test="${index % COLS == 0}">
                        <tr>
                    </g:if>
                    <td>
                        <label for="${node.nodename}" class=" ${localNodeName&& localNodeName==node.nodename? 'server' : ''} node_ident obs_tooltip"
                               id="${node.nodename}_key">
                            <input id="${node.nodename}" type="checkbox" name="extra.nodeIncludeName"
                                   value="${node.nodename}" disabled="true" checked="true"/> ${node.nodename.encodeAsHTML()}</label>

                        <g:render template="/framework/nodeTooltipView"
                                  model="[node:node,key:node.nodename+'_key',islocal:localNodeName && localNodeName==node.nodename]"/>

                    </td>
                    <g:if test="${(index % COLS == (COLS-1)) || (index+1 == nodes.size())}">
                        </tr>
                    </g:if>
                </g:each>
                </table>
                </g:else>
            </div>
            <g:javascript>
                if (typeof(initTooltipForElements) == 'function') {
                    initTooltipForElements('.obs_tooltip');
                }
                $$('div.jobmatchednodes span.textbtn.selectall').each(function(e) {
                    Event.observe(e, 'click', function(evt) {
                        $(e).up('.group_section').select('input').each(function(el) {
                            if (el.type == 'checkbox') {
                                el.checked = true;
                            }
                        });
                        $(e).up('.group_section').select('span.textbtn.obs_tag_group').each(function(e) {
                            $(e).setAttribute('tagselected', 'true');
                            $(e).addClassName('tagselected');
                        });
                    });
                });
                $$('div.jobmatchednodes span.textbtn.selectnone').each(function(e) {
                    Event.observe(e, 'click', function(evt) {
                        $(e).up('.group_section').select('input').each(function(el) {
                            if (el.type == 'checkbox') {
                                el.checked = false;
                            }
                        });
                        $(e).up('.group_section').select('span.textbtn.obs_tag_group').each(function(e) {
                            $(e).setAttribute('tagselected', 'false');
                            $(e).removeClassName('tagselected');
                        });
                    });
                });
                $$('div.jobmatchednodes span.textbtn.obs_tag_group').each(function(e) {
                    Event.observe(e, 'click', function(evt) {
                        var ischecked = e.getAttribute('tagselected') != 'false';
                        e.setAttribute('tagselected', ischecked ? 'false' : 'true');
                        if (!ischecked) {
                            $(e).addClassName('tagselected');
                        } else {
                            $(e).removeClassName('tagselected');
                        }
                        $(e).up('.group_section').select('input[tag~="' + e.getAttribute('tag') + '"]').each(function(
                        el) {
                            if (el.type == 'checkbox') {
                                el.checked = !ischecked;
                            }
                        });
                        $(e).up('.group_section').select('span.textbtn.obs_tag_group[tag="' + e.getAttribute('tag') + '"]').each(function(
                        el) {
                            el.setAttribute('tagselected', ischecked ? 'false' : 'true');
                            if (!ischecked) {
                                $(el).addClassName('tagselected');
                            } else {
                                $(el).removeClassName('tagselected');
                            }
                        });
                    });
                });

                Event.observe($('doReplaceFilters'), 'change', function (evt) {
                    var e = evt.element();
                    $$('div.jobmatchednodes input').each(function (cb) {
                        if (cb.type == 'checkbox') {
                            [cb].each(e.checked ? Field.enable : Field.disable);
                            if (!e.checked) {
                                $$('.group_select_control').each(Element.hide);
                                cb.checked = true;
                            } else {
                                $$('.group_select_control').each(Element.show);
                            }
                        }
                    });

                });


                /** reset focus on click, so that IE triggers onchange event*/
                Event.observe($('doReplaceFilters'),'click',function (evt) {
                    this.blur();
                    this.focus();
                });

            </g:javascript>
        </g:elseif>
    </div>
    </div>

    <div class="error note" id="formerror" style="display:none">

    </div>
</div>
</div>
<div class="panel-footer">
    <div class="" id="formbuttons">
        <div class="col-sm-12">
            <g:if test="${!hideCancel}">
                <g:actionSubmit id="execFormCancelButton" value="Cancel" class="btn btn-default"/>
            </g:if>
            <button type="submit"
                    title="${g.message(code: 'domain.ScheduledExecution.title')} Now" id="execFormRunButton"
                    class=" btn btn-success">
                <b class="glyphicon glyphicon-play"></b> Run Job Now
            </button>
            <label class="checkbox-inline">
                <g:checkBox id="followoutputcheck" name="follow" checked="${defaultFollow || params.follow == 'true'}"
                            value="true"/>
                <g:message code="job.run.watch.output"/>
            </label>
        </div>
    </div>
</div>
</div>%{--/.panel--}%
</g:form>
</div> %{--/.col--}%
</div> %{--/.row--}%
