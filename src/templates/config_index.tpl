{extends "default.tpl"}

{block "body"}

<h2>Configuration</h2>

<p>Ci-dessous la liste des configurations:</p>
<ul>
  {foreach from=$configs item="config"}
      <li><a href="{mkurl action="config" page="edit" scope=$config.name}">{$config.label}</a></li>
      {/foreach}
</ul>

{/block}
