<?php

/**
 * Controleur par défaut
 * Ce controleur permet d'afficher la page d'accueil du site, mais aussi aux
 * utilisateurs de se connecter. L'accès à ce module est forcé en mode publique
 * par le framework.
 * @package Epicenote
 */

/**
 * Petite page de présentation du projet
 * @global type $tpl
 */
function index_index() {
    global $tpl, $pdo;
    $tpl->display('index.tpl');
    quit();
}

/**
 * Permet de connecter un utilisateur
 * @global type $tpl
 * @global type $pdo
 */
function index_login() {
    global $tpl, $urlbase, $config;

    $oAuth = new OpenIDConnectClient($config['oAuth']['client_url'], $config['oAuth']['client_id'], $config['oAuth']['client_secret']);
    $redirect = $_SERVER['REQUEST_SCHEME'] . '://' . $_SERVER['HTTP_HOST'] . $urlbase . 'action=index&page=login';
    $oAuth->setRedirectURL($redirect);
    $oAuth->addScope('openid');
    $oAuth->authenticate();
    
    $user = new Modele('users');
    $user->find(array(
        'user_intra' => $oAuth->requestUserInfo('sub'),
    ));
    
    if (!$user->next()) {
        $user->addFrom(array(
            'user_intra' => $oAuth->requestUserInfo('sub'),
            'user_data' => json_encode($oAuth->requestUserInfo()),
        ));
    }
    
    $ctx = new Modele('contacts');
    if ($user->raw_user_ctx == NULL) {
        $ctx->addFrom(array(
            'ctx_user' => $user->getKey(),
        ));
        $user->user_ctx = $ctx->getKey();
    } else {
        $ctx->fetch($user->raw_user_ctx);
    }
    
    $ctx->modFrom(array(
        'ctx_firstname' => $oAuth->requestUserInfo('given_name'),
        'ctx_lastname' => $oAuth->requestUserInfo('family_name'),
        'ctx_email' => $oAuth->requestUserInfo('email'),
        'ctx_phone' => $oAuth->requestUserInfo('phone_number'),
    ));
    
    $_SESSION['user'] = $user->toArray();
    $_SESSION['user']['ctx'] = $ctx->toArray();
    $_SESSION['user']['infos'] = (array) $oAuth->requestUserInfo();
    
    $role = $user->raw_user_acl == 'INTRA' ? $oAuth->requestUserInfo('acl') : $user->raw_user_acl;
    $_SESSION['user']['role'] = aclFromText($role);
    
    redirect('index');
}

/**
 * Ferme une session utilisateur
 * @global type $tpl
 */
function index_logout() {
    global $tpl;

    $_SESSION['user'] = false;
    unset($_SESSION['user']);
    $_SESSION = array();
    redirect('index');
}


function index_error403() {
    header("HTTP/1.1 403 Unauthorized");

    display();
}
