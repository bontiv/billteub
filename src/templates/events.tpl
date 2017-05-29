{extends "default.tpl"}

{block "body"}
    <div class="row marging">
        <ul class="nav nav-pills">
            <li role="presentation"{if $smarty.request.page=="index"} class="active"{/if}><a href="{mkurl action="events"}">Évents à venir</a></li>
            <li role="presentation"{if $smarty.request.page=="old"} class="active"{/if}><a href="#">Évents passés</a></li>
            <li role="presentation"{if $smarty.request.page=="create"} class="active"{/if}><a href="{mkurl action="events" page="create"}">Nouveau évent</a></li>
        </ul>
    </div>
    
{/block}