{extends "default.tpl"}

{block "title" prepend}{$event->event_title} - {/block}

{block "head"}
    <meta name="description" content="{$event->event_desc}" />
{/block}

{block "body"}
    <div class="panel panel-default">
        <div class="panel-heading">
            <h1>{$event->event_title}</h1>
        </div>
        <div class="panel-body">
            <div class="container">
                <div class="row">
                    <div class="col-md-3 text-right">
                        <strong>Début</strong>
                    </div>
                    <div class="col-md-3">
                        {$event->event_start|date_format:"%A %d %B %Y, %H:%m"}
                    </div>
                    <div class="col-md-3 text-right">
                        <strong>Fin</strong>
                    </div>
                    <div class="col-md-3">
                        {$event->event_end|date_format:"%A %d %B %Y, %H:%m"}
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3 text-right">
                        <strong>Visibilité</strong>
                    </div>
                    <div class="col-md-3">
                        {$event->event_visibility}
                    </div>
                </div>
            </div>
        </div>
        <div class="panel-body">
            <strong>Description: </strong> {$event->event_desc}
        </div>
        <table class="table table-hover">
            <thead>
                <tr>
                    <th>Ticket</th>
                    <th style="width:110px">Type</th>
                    <th style="width:80px">Prix</th>
                    <th style="width:110px">Places dispo</th>
                    <th style="width:auto"></th>
                </tr>
            </thead>
            <tbody>
                {if isset($types)}
                    {foreach $types as $type}
                        <tr>
                            <td>
                                <strong>{$type.ttype_title}</strong>
                                <br />
                                <div class="text-muted">
                                    {$type.ttype_desc}
                                </div>
                            </td>
                            <td>
                                {if $type.ttype_delegation == "NONE"}
                                    <abbr title="Vous ne pouvez pas acheter cette place pour un autre">Invitation impossible</abbr>
                                {elseif $type.ttype_delegation == "GUIDE"}
                                    <abbr title="Vous pouvez avoir des accompagnants dont vous prenez la responsabilité sur place">Accompagnant possible</abbr>
                                {else}
                                    <abbr title="Vous pouvez acheter cette place pour vous ou vos invités">Invitation possible</abbr>
                                {/if}
                            </td>
                            <td>
                                {($type.ttype_price/100)|string_format:"%.2f"} €
                            </td>
                            <td>
                                {if $type.ttype_maxTickets == 0}
                                    <span class="text-success">Illimité</span>
                                {else}
                                    {$type.ttype_maxTickets-$type.COUNT}
                                    /
                                    {$type.ttype_maxTickets}
                                {/if}
                            </td>
                            <td>
                                <div class="btn-group">
                                    <a href="{mkurl action="basket" page="buy" type=$type.ttype_id}" class="btn btn-primary" title="Acheter"><i class="glyphicon glyphicon-euro"></i> Achat</a>
                                </div>
                            </td>
                        </tr>
                    {/foreach}
                {else}
                    <tr class="danger">
                        <td colspan="3">
                            Aucun ticket disponible
                        </td>
                    </tr>
                {/if}
            </tbody>
        </table>
        <div class="panel-footer">
            <a href="{mkurl action="evadmin" event=$event->event_id}" class="btn btn-info">Administration</a>

        </div>
    </div>
{/block}