{extends "evadmin.tpl"}

{block "content"}
    <div class="content">
        <dl>
            <dt>Titre</dt>
            <dd>{$event->event_title}</dd>
        </dl>
        <dl>
            <dt>Description</dt>
            <dd>{$event->event_desc}</dd>
        </dl>
        <dl>
            <dt>Début</dt>
            <dd>{$event->event_start|date_format:"%d/%m/%Y %H:%M:%S"}</dd>
        </dl>
        <dl>
            <dt>Fin</dt>
            <dd>{$event->event_end|date_format:"%d/%m/%Y %H:%M:%S"}</dd>
        </dl>
        <dl>
            <dt>Nombre de places</dt>
            <dd>
                {if $event->event_maxtickets gt 0}
                    {$event->event_maxtickets}
                {else}
                    <span class="text-success">Illimité</span>
                {/if}
            </dd>
        </dl>
        <dl>
            <dt>Visibilité</dt>
            <dd>{$event->event_visibility}</dd>
        </dl>
        <a href="{mkurl action="evadmin" page="edit" event=$event->event_id}" class="btn btn-warning">Editer</a>
    </div>
{/block}