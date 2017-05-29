{extends "default.tpl"}

{block "body"}
    <form method="POST" action="{mkurl action="evadmin" page="type_edit" type=$type->ttype_id}">
        <fieldset class="form-horizontal">
            {$form}
        </fieldset>

        <fieldset>
            <div class="form-group">
                <div class="col-md-6 col-md-offset-4">
                    <button type="submit" class="btn btn-primary">Valider</button>
                    <a href="{mkurl action="evadmin" page="types" event=$type->raw_ttype_event}" class="btn btn-default">Annuler</a>

                </div>
            </div>
        </fieldset>
    </form>
{/block}