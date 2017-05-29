{extends "evadmin.tpl"}

{block "content"}
    <div class="row">
        
    </div>
    <div class="row">
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Nom</th>
                    <th>Prénom</th>
                    <th>Date</th>
                    <th>Methode</th>
                    <th>Statut</th>
                </tr>
            </thead>
            <tbody>
                {foreach $customers as $usr}
                    <tr>
                        <td>{$usr.ctx_lastname}</td>
                        <td>{$usr.ctx_firstname}</td>
                        <td>{$usr.pay_date|date_format:"%d/%m/%Y %H:%M:%S"}</td>
                        <td>{$usr.pm_title}</td>
                        <td>
                            {if $usr.pay_state eq "WAIT"}
                                <div class="label label-warning">En cours</div>
                            {elseif $usr.pay_state eq "CANCELED"}
                                <div class="label label-danger">Annulé</div>
                            {elseif $usr.pay_state eq "ACCEPT"}
                                <div class="label label-success">Payé</div>
                            {elseif $usr.pay_state eq "MANUAL"}
                                <div class="label label-primary">Manuel</div>
                            {elseif $usr.pay_state eq "DENIED"}
                                <div class="label label-danger">Rejeté</div>
                            {else}
                                {$usr.pay_state}
                            {/if}
                        </td>
                    </tr>
                {/foreach}
            </tbody>
        </table>
    </div>
{debug}
{/block}
