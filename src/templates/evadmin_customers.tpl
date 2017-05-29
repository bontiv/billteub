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
                    <th>Email</th>
                    <th>Téléphone</th>
                    <th>Tickets</th>
                </tr>
            </thead>
            <tbody>
                {foreach $customers as $usr}
                    <tr>
                        <td>{$usr.ctx_lastname}</td>
                        <td>{$usr.ctx_firstname}</td>
                        <td><a href="mailto:{$usr.ctx_email}">{$usr.ctx_email}</a></td>
                        <td><a href="tel:{$usr.ctx_phone}">{$usr.ctx_phone}</a></td>
                        <td>{$usr.total}</td>
                    </tr>
                {/foreach}
            </tbody>
        </table>
    </div>
{/block}
