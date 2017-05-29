{extends "default.tpl"}

{block "body"}
    <h1>{$type->ttype_event->event_title}</h1>
    <h2>Achat d'une place : {$type->ttype_title}</h2>

    <div class="alert alert-info">
        Place pour l'événement {$type->ttype_event->event_title} du
        <strong>{$type->ttype_event->event_start|date_format:"%A %d %B %Y, %H:%m"}</strong> au 
        <strong>{$type->ttype_event->event_end|date_format:"%A %d %B %Y, %H:%m"}</strong>.
    </div>

    <div class="panel panel-default">
        <div class="panel-heading">
            <h3 class="panel-title">Vous achetez la place pour vous ?</h3>
        </div>
        <div class="panel-body">
            <div class="col-md-8">
                <p>{$smarty.session.user.ctx.ctx_firstname} {$smarty.session.user.ctx.ctx_lastname}</p>
                <p>{$smarty.session.user.ctx.ctx_email} - {$smarty.session.user.ctx.ctx_email}</p>
            </div>
            <div class="col-md-4 text-left">
                <a href="{mkurl action="basket" page="buy" type=$type->ttype_id ctx=$smarty.session.user.ctx.ctx_id}" class="btn btn-primary">Prendre</a>
            </div>
        </div>
    </div>


    <div class="panel panel-warning">
        <div class="panel-heading">
            <h3 class="panel-title">Vous achetez la place pour offrir ?</h3>
        </div>
        <div class="panel-body">
            <p>Cette place ne peut pas être offerte...</p>
        </div>
    </div>
{/block}