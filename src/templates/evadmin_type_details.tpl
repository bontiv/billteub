{extends "evadmin.tpl"}

{block "content"}
    <div class="content">

        <dl>
            <dt>Nom</dt>
            <dd>{$type->ttype_title}</dd>
        </dl>
        <dl>
            <dt>Description</dt>
            <dd>{$type->ttype_desc}</dd>
        </dl>
        <dl>
            <dt>Maximum</dt>
            <dd>{$type->ttype_maxTickets}</dd>
        </dl>
        <dl>
            <dt>Tarif</dt>
            <dd>{$type->ttype_price}</dd>
        </dl>
        <dl>
            <dt>Configuration de paiement</dt>
            <dd>{$type->ttype_payconf->pc_title}</dd>
        </dl>
        <dl>
            <dt>Temps de validation Admin</dt>
            <dd>{$type->ttype_moderate}</dd>
        </dl>
        <dl>
            <dt>Paiement de comission</dt>
            <dd>{$type->ttype_commission}</dd>
        </dl>
        <dl>
            <dt>Temps dans le panier</dt>
            <dd>{$type->ttype_duration}</dd>
        </dl>
        <dl>
            <dt>Achat tiers</dt>
            <dd>{$type->ttype_delegation}</dd>
        </dl>
        <dl>
            <dt>Niveau d'accès</dt>
            <dd>{$type->ttype_access}</dd>
        </dl>
    </div>
    <div class="content">
        <a href="{mkurl action="evadmin" page="type_edit" type=$type->ttype_id}" class="btn btn-warning">Modifier</a>
        <a href="{mkurl action="evadmin" page="type_delete" type=$type->ttype_id}" class="btn btn-danger">Supprimer</a>
        <a href="{mkurl action="evadmin" page="tickets" ttype_id=$type->ttype_id event=$type->ttype_event->event_id}" class="btn btn-info">Tickets</a>
        <a href="{mkurl action="evadmin" page="types" event=$type->ttype_event->event_id}" class="btn btn-default">Retour</a>
    </div>
{/block}