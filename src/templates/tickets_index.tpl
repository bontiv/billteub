{extends "default.tpl"}

{block "head"}
    <link href="css/events.css" rel="stylesheet">
{/block}

{block "body"}
    <h1>Vos billets</h1>
        {if isset($tickets)}
            <div class="alert alert-info">
                <p>
                    Cliquer sur les icones à gauche du ticket pour imprimer le titre
                    ou bien l'envoyer par email.
                </p>
            </div>
            <div class="[ col-xs-12 col-sm-offset-2 col-sm-8 ]">
                <ul class="event-list">

                    {foreach $tickets as $ticket}
                        <li>
                            <time datetime="{$ticket->t_type->ttype_event->event_start}">
                                <span class="day">{$ticket->t_type->ttype_event->event_start|date_format:"%e"}</span>
                                <span class="month">{$ticket->t_type->ttype_event->event_start|date_format:"%b"}</span>
                                <span class="year">{$ticket->t_type->ttype_event->event_start|date_format:"%Y"}</span>
                                <span class="time">{$ticket->t_type->ttype_event->event_start|date_format:"%R"}</span>
                            </time>
                            <div class="info">
                                <h2 class="title">
                                    <a href="{mkurl action="events" page="details" event=$ticket->t_type->ttype_event->event_id}">
                                        {$ticket->t_type->ttype_event->event_title}
                                    </a>
                                </h2>
                                <p class="desc">
                                    <strong>{$ticket->t_ctx->ctx_firstname} {$ticket->t_ctx->ctx_lastname}</strong> <small>({$ticket->t_type->ttype_title})</small><br/>
                                    <i>Courriel: </i> {$ticket->t_ctx->ctx_email}<br/>
                                    <i>Tél: </i> {$ticket->t_ctx->ctx_phone}
                                </p>
                            </div>
                            <div class="social">
                                <ul>
                                    <li class="command" style="width:33%;"><a href="{mkurl action="tickets" page="print" ticket=$ticket->t_id}" title="Imprimer le titre"><span class="glyphicon glyphicon-print"></span></a></li>
                                    <li class="command" style="width:34%;"><a href="#twitter" title="Envoyer par email"><span class="glyphicon glyphicon-send"></span></a></li>
                                </ul>
                            </div>
                        </li>
                    {/foreach}
                </ul>
            </div>
        {else}
            <div class="alert alert-warning">
                Vous ne possédez aucun billet valide.
            </div>
        {/if}    
{/block}
