{extends "default.tpl"}

{block "body"}
    <h1>Options de paiement</h1>
    <form method="POST" action="{mkurl action="basket" page="payconf"}">
        <table class="table">
            <thead>
                <tr>
                    <td></td>
                    <td>Méthode de paiement</td>
                    <td>Frais de dossier</td>
                    <td>Total</td>
                </tr>
            </thead>
            <tbody>
                {foreach $configs as $conf}
                    <tr>
                        <td>
                            <input type="radio" name="config" value="{$conf.obj->pm_key}" {if $conf@first} checked{/if} />
                        </td>
                        <td>
                            {$conf.obj->pm_title}
                        </td>
                        <td>
                            {$conf.fee|string_format:"%.2f"} €
                        </td>
                        <td>
                            <strong>
                                {$conf.total|string_format:"%.2f"} €
                            </strong>
                        </td>
                    </tr>
                {/foreach}
            </tbody>
        </table>
        <div class="container">

            <button type="submit" class="btn btn-primary">Continuer</button>
        </div>
    </form>
{/block}