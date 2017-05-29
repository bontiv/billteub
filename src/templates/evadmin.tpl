{extends "default.tpl"}

{block "body"}
    <h1>Gestion événement</h1>
    <h2><small>{$event->event_title}</small></h2>
    <div class="row">
        <div class="col-md-3">
            <ul class="nav nav-pills nav-stacked">
                <li role="presentation"{if $smarty.request.page=="index"} class="active"{/if}>
                    <a href="{mkurl action="evadmin" event=$event->event_id}">Informations</a>
                </li>
                <li role="presentation"{if $smarty.request.page=="types"} class="active"{/if}>
                    <a href="{mkurl action="evadmin" page="types" event=$event->event_id}">Types de tickets</a>
                </li>
                <li role="presentation"{if $smarty.request.page=="tickets"} class="active"{/if}>
                    <a href="{mkurl action="evadmin" page="tickets" event=$event->event_id}">Liste des billets</a>
                </li>
                <li role="presentation"{if $smarty.request.page=="customers"} class="active"{/if}>
                    <a href="{mkurl action="evadmin" page="customers" event=$event->event_id}">Liste des clients</a>
                </li>
                <li role="presentation"{if $smarty.request.page=="access"} class="active"{/if}>
                    <a href="{mkurl action="evadmin" page="access" event=$event->event_id}">Droits d'accès</a>
                </li>
                <li role="presentation"{if $smarty.request.page=="payments"} class="active"{/if}>
                    <a href="{mkurl action="evadmin" page="payments" event=$event->event_id}">Paiements</a>
                </li>
            </ul>
        </div>
        <div class="col-md-9">
            {block "content"}{/block}
        </div>
    </div>
{/block}
