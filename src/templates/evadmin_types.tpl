{extends "evadmin.tpl"}

{block "content"}
    <div class="content">
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>Titre</th>
                    <th>Nombre</th>
                    <th>Prix</th>
                    <th>Config Paiement</th>
                    <th>Délégation</th>
                    <th>Access</th>
                </tr>
            </thead>
            <tbody>
                {if isset($types)}
                    {foreach $types as $type}
                        <tr>
                            <td><a href="{mkurl action="evadmin" page="type_details" type=$type->ttype_id}">{$type->ttype_title}</a></td>
                            <td>{$type->reverse('tickets')->count()} / {$type->ttype_maxTickets}</td>
                            <td>{($type->ttype_price/100)|string_format:"%.2f"} €</td>
                            <td>{$type->ttype_payconf->pc_title}</td>
                            <td>{$type->ttype_delegation}</td>
                            <td>{$type->ttype_access}</td>
                        </tr>
                    {/foreach}
                {else}
                    <tr>
                        <td class="warning" colspan="6">Aucun type de ticket</td>
                    </tr>
                {/if}
            </tbody>
        </table>
        <a href="{mkurl action="evadmin" page="type_add" event=$event->event_id}" class="btn btn-success">Ajouter</a>
    </div>
{/block}