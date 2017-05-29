{extends "evadmin.tpl"}

{block "content"}
    <div class="row">
        <form class="form-inline">
            <div class="form-group">
                <input type="text" name="search" placeholder="Recherche" class="form-control" />
            </div>
            <div class="form-group">
                <label for="status">Statut</label>
                <select name="status" id="status" class="form-control">
                    <option value="">Tous les statuts</option>
                    <option value="PAID">Payé</option>
                    <option value="TMP">En panier</option>
                    <option value="RSV">Réservé</option>
                    <option value="VALID">Validé</option>
                    <option value="CANCEL">Annulé</option>
                    <option value="WAIT">En attente</option>
                </select>
            </div>
            <button type="submit">Go</button>
        </form>
    </div>
    <div class="row">
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>
                        Participant
                    </th>
                    <th>
                        Client
                    </th>
                    <th>Type</th>
                    <th>Statut</th>
                </tr>
            </thead>
            <tbody>
                {foreach $tickets as $tik}
                    <tr>
                        <td>{$tik.ctx_lastname} {$tik.ctx_firstname}</td>
                        <td>{$tik.cus_lastname} {$tik.cus_firstname}</td>
                        <td><a href="{mkurl action="evadmin" page="type_details" type=$tik.ttype_id}">{$tik.ttype_title}</a></td>
                        <td>
                            {if $tik.t_status eq "TMP"}
                                <span class="label label-default">Panier</span>
                            {elseif $tik.t_status eq "WAIT"}
                                <span class="label label-primary">Attente validation</span>
                            {elseif $tik.t_status eq "RSV"}
                                <span class="label label-default">Réservé</span>
                            {elseif $tik.t_status eq "PAID"}
                                <span class="label label-success">Payé</span>
                            {elseif $tik.t_status eq "VALID"}
                                <span class="label label-info">Validé</span>
                            {elseif $tik.t_status eq "CANCEL"}
                                <span class="label label-danger">Annulé</span>
                            {else}
                                Type non implémenté : {$tik.t_status}
                            {/if}
                        </td>
                    </tr>
                {/foreach}
            </tbody>
        </table>
    </div>
{/block}
