<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function events_index() {
    $evts = new Modele('events');
    $evts->find();
    $evts->appendTemplate('events');

    display();
}

function events_details() {
    global $tpl, $pdo;

    $evts = new Modele('events');
    $evts->fetch($_REQUEST['event']);
    $evts->assignTemplate('event');

    $ttyp = new Modele('ticketTypes');
    $ttyp->find(array(
        'ttype_event' => $evts->getKey(),
    ));

    while ($ttyp->next()) {
        $line = $ttyp->toArray();
        $sqlc = $pdo->prepare('SELECT COUNT(*) FROM tickets WHERE t_type = ?');
        $sqlc->bindValue(1, $ttyp->getKey());
        $sqlc->execute();
        $line['COUNT'] = $sqlc->fetchColumn(0);
        $tpl->append('types', $line);
    }

    display();
}

function events_create() {
    global $tpl;

    $evnt = new Modele('events');

    if (isset($_POST['event_title'])) {
        $add = $evnt->addFrom($_POST);
        redirect('events', 'index', array('hsuccess' => $add ? 1 : 0));
    }

    $tpl->assign('form', $evnt->edit());

    display();
}

function events_delete() {
    $evts = new Modele('events');
    $evts->fetch($_REQUEST['event']);
    $del = $evts->delete();
    redirect('events', 'index', array('hsuccess' => $del ? 1 : 0));
}

