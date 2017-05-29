{extends "events.tpl"}

{block "body" append}
    <form method="POST" action="{mkurl action="events" page="create"}">
        <fieldset class="form-horizontal">
            {$form}
        </fieldset>

        <fieldset>
            <div class="form-group">
                <div class="col-md-6 col-md-offset-4">
                    <button type="submit" class="btn btn-primary">Valider</button>

                </div>
            </div>
        </fieldset>
    </form>
{/block}