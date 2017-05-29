{extends "events.tpl"}

{block "head"}
    <link href="css/events.css" rel="stylesheet">
{/block}

{block "body" append}

    <div class="row">
        {if isset($events)}
            <div class="[ col-xs-12 col-sm-offset-2 col-sm-8 ]">
                <ul class="event-list">

                    {foreach $events as $event}
                        <li>
                            <time datetime="{$event->event_start}">
                                <span class="day">{$event->event_start|date_format:"%e"}</span>
                                <span class="month">{$event->event_start|date_format:"%b"}</span>
                                <span class="year">{$event->event_start|date_format:"%Y"}</span>
                                <span class="time">{$event->event_start|date_format:"%R"}</span>
                            </time>
                            <div class="info">
                                <h2 class="title"><a href="{mkurl action="events" page="details" event=$event->event_id}">{$event->event_title}</a></h2>
                                <p class="desc">{$event->event_desc}</p>
                            </div>
                            <div class="social">
                                <ul>
                                    <li class="facebook" style="width:33%;"><a href="#facebook"><span class="fa fa-facebook"></span></a></li>
                                    <li class="twitter" style="width:34%;"><a href="#twitter"><span class="fa fa-twitter"></span></a></li>
                                    <li class="google-plus" style="width:33%;"><a href="#google-plus"><span class="fa fa-google-plus"></span></a></li>
                                </ul>
                            </div>
                        </li>
                    {/foreach}
                </ul>
            </div>
        {else}
            <div class="alert alert-info">
                Aucun événement à afficher ...
            </div>
        {/if}
    </div>
{/block}