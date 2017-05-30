<!DOCTYPE html>
<html>
    <head>
        <!-- Css -->
        <link href="extmod/bootstrap/dist/css/bootstrap.css" rel="stylesheet">
        <link href="extmod/bootstrap/dist/css/bootstrap-theme.css" rel="stylesheet">
        <link href="css/custom.css" rel="stylesheet">
        <!-- /Css -->
        <!-- Scripts -->
        <script src="extmod/jquery/dist/jquery.js"></script>
        <script src="extmod/bootstrap/dist/js/bootstrap.js"></script>
        <!-- /Scripts -->

        <title>{block "title"}Billeterie LATEB{/block}</title>
        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <link rel="stylesheet" href="extmod/eonasdan-bootstrap-datetimepicker/build/css/bootstrap-datetimepicker.min.css" />
        <script type="text/javascript" src="extmod/moment/min/moment.min.js"></script>
        <script type="text/javascript" src="extmod/moment/min/locales.min.js"></script>
        <script type="text/javascript" src="extmod/eonasdan-bootstrap-datetimepicker/build/js/bootstrap-datetimepicker.min.js"></script>

    {block "head"}{/block}
</head>

<body>

    <div class="navbar navbar-default" role="navigation">
        <div class="container">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target=".navbar-collapse">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="{mkurl action="index"}">Billeterie LATEB</a>
            </div>


            <div class="collapse navbar-collapse" >
                <ul class="nav navbar-nav">
                    {mkmenu}
                {block "menu"}{/block}
            </ul>
            <ul class="nav navbar-nav navbar-right">
                {if isset($bascketCnt) and $bascketCnt gt 0}
                <li>
                    <a href="{mkurl action="basket"}">
                        <i class="glyphicon glyphicon-shopping-cart"></i>
                        <div class="badge">{$bascketCnt}</div>
                    </a>
                </li>
                {/if}
                {if $_user}
                    <li class="dropdown">
                        <a href="#" data-toggle="dropdown" role="menu" style="color:grey">
                            {$_user.infos.name|escape} <b class="caret"></b></a>
                        <ul class="dropdown-menu" role="menu" aria-labelledby="dLabel">
                            <li><a href="{mkurl action="index" page="logout"}">Carnet d'adresses</a></li>
                            <li><a href="{mkurl action="index" page="logout"}">Déconnexion</a></li>
                        </ul>
                    </li>
                {else}
                    <li>
                        <a href="{mkurl action="index" page="login"}" style="color:grey">
                            Connexion
                        </a>
                    </li>
                {/if}
            </ul>
        </div>
    </div>{* /container *}
</div>{* /navbar *}
<div class="container container-fluid">

    {if isset($hsuccess) or isset($smarty.get.hsuccess)}
        {if (isset($smarty.get.hsuccess) and $smarty.get.hsuccess==1) or (isset($hsuccess) and $hsuccess===true)}
            <div class="alert alert-success"><p>Opération effectué avec succès.</p></div>
        {elseif isset($hsuccess) and $hsuccess!==0 and $hsuccess!==false}
            <div class="alert alert-danger"><p>Une erreur a empêché l'opération : {$hsuccess}.</p></div>
        {else}
            <div class="alert alert-danger"><p>Une erreur a empêché l'opération.</p></div>
        {/if}
    {/if}

    <!-- Begin page content -->
{block "body"}{/block}

</div>


<footer class="footer">
    <div class="container">
        <p class="text-muted">&COPY; LATEB 2012 - 2017</p>
    </div>
</footer>


{* Pour le tracking visiteurs *}

</body>

</html>
