{extends "default.tpl"}

{block "body"}
    <h1>Votre panier<br/><small>Billets en attente de paiement</small></h1>

    <div class="content">

        {if isset($tickets)}
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th>Événement</th>
                        <th>Billet</th>
                        <th>Prix</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    {assign var="total" value=0}
                    {foreach $tickets as $ticket}
                        <tr>
                            <td>{$ticket->t_type->ttype_event->event_title}</td>
                            <td>{$ticket->t_type->ttype_title}</td>
                            <td>{($ticket->t_type->ttype_price/100)|string_format:"%.2f"} €</td>
                            <td>
                                <a href="{mkurl action="basket" page="remove" ticket=$ticket->t_id}" class="btn btn-danger" title="Supprimer">
                                    <i class="glyphicon glyphicon-trash"></i>
                                </a>
                            </td>
                        </tr>
                        {assign var="total" value=$total+$ticket->t_type->ttype_price}
                    {/foreach}
                </tbody>
                <tfoot>
                    <tr class="info">
                        <td colspan="2">TOTAL</td>
                        <td>{($total/100)|string_format:"%.2f"} €</td>
                        <td>
                        </td>
                    </tr>
                </tfoot>
            </table>

            <div class="content">
                <a href="{mkurl action="basket" page="payconf"}" class="btn btn-primary">
                    <i class="glyphicon glyphicon-eur"></i>
                    Payer
                </a>

            </div>
        {else}
            <div class="alert alert-warning">
                <p>Vous n'avez aucun ticket en attente de paiement.</p>
            </div>
        {/if}
    </div>
{/block}