<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function evadmin_index() {
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

function evadmin_edit() {
    global $tpl;

    $evts = new Modele('events');
    $evts->fetch($_REQUEST['event']);

    if (isset($_POST['event_title'])) {
        $evts->modFrom($_POST);
        redirect('evadmin', 'index', array('event' => $evts->getKey()));
    }

    $evts->assignTemplate('event');

    $tpl->assign('form', $evts->edit());

    display();
}

function evadmin_types() {
    $evts = new Modele('events');
    $evts->fetch($_REQUEST['event']);
    $evts->assignTemplate('event');

    $ttyp = new Modele('ticketTypes');
    $ttyp->find(array(
        'ttype_event' => $evts->getKey(),
    ));
    $ttyp->appendTemplate('types');

    display();
}

function evadmin_type_delete() {
    $mdl = new Modele('ticketTypes');
    $mdl->fetch($_REQUEST['type']);

    redirect('evadmin', 'types', array('event' => $mdl->raw_ttype_event, 'hsuccess' => $mdl->delete() ? 1 : 1));
}

function evadmin_type_edit() {
    global $tpl;

    $mdl = new Modele('ticketTypes');
    $mdl->fetch($_REQUEST['type']);

    $tpl->assign('form', $mdl->edit(array(
                'ttype_title',
                'ttype_desc',
                'ttype_maxTickets',
                'ttype_price',
                'ttype_payconf',
                'ttype_access',
    )));

    if (isset($_POST['ttype_title'])) {
        $add = $mdl->modFrom(array_merge($_POST, array(
            'ttype_event' => $mdl->raw_ttype_event,
        )));
        if ($add) {
            redirect('evadmin', 'index', array('event' => $mdl->raw_ttype_event));
        } else {
            $tpl->assign('hsuccess', false);
        }
    }

    $mdl->assignTemplate('type');
    display();
}

function evadmin_type_add() {
    global $tpl;

    $evts = new Modele('events');
    $evts->fetch($_REQUEST['event']);
    $evts->assignTemplate('event');

    $ttyp = new Modele('ticketTypes');
    $tpl->assign('form', $ttyp->edit(array(
                'ttype_title',
                'ttype_desc',
                'ttype_maxTickets',
                'ttype_price',
                'ttype_payconf',
                'ttype_access',
    )));

    if (isset($_POST['ttype_title'])) {
        $add = $ttyp->addFrom(array_merge($_POST, array(
            'ttype_event' => $evts->getKey(),
        )));
        if ($add) {
            redirect('evadmin', 'types', array('event' => $evts->getKey()));
        } else {
            $tpl->assign('hsuccess', false);
        }
    }

    display();
}

function evadmin_tickets() {
    global $tpl, $pdo;

    $evts = new Modele('events');
    $evts->fetch($_REQUEST['event']);
    $evts->assignTemplate('event');

    $sql = $pdo->prepare(
            'SELECT contacts.*, tickets.*, ticketTypes.*, customer.ctx_lastname as cus_lastname, customer.ctx_firstname as cus_firstname FROM tickets '
            . 'LEFT JOIN ticketTypes ON t_type = ttype_id '
            . 'LEFT JOIN contacts ON contacts.ctx_id = t_ctx '
            . 'LEFT JOIN users ON user_id = t_user '
            . 'LEFT JOIN contacts as customer ON user_ctx = customer.ctx_id '
            . 'WHERE ttype_event = ?'
    );
    $sql->bindValue(1, $evts->getKey());
    $sql->execute();

    while ($line = $sql->fetch()) {
        $tpl->append('tickets', $line);
    }

    display();
}

function evadmin_customers() {
    global $tpl, $pdo;

    $evts = new Modele('events');
    $evts->fetch($_REQUEST['event']);
    $evts->assignTemplate('event');

    $sql = $pdo->prepare(
            'SELECT DISTINCT contacts.*, COUNT(*) AS total '
            . 'FROM tickets '
            . 'LEFT JOIN ticketTypes ON t_type = ttype_id '
            . 'LEFT JOIN users ON t_user = user_id '
            . 'LEFT JOIN contacts ON ctx_id = user_ctx '
            . 'WHERE ttype_event = ? '
            . 'ORDER BY ctx_lastname, ctx_firstname'
    );
    $sql->bindValue(1, $evts->getKey());
    $sql->execute();

    while ($line = $sql->fetch()) {
        $tpl->append('customers', $line);
    }

    display();
}

function evadmin_payments() {
    global $tpl, $pdo;

    $evts = new Modele('events');
    $evts->fetch($_REQUEST['event']);
    $evts->assignTemplate('event');

    $sql = $pdo->prepare('SELECT DISTINCT payments.*, users.*, contacts.*, paymentMethods.* FROM paymentItems LEFT JOIN tickets ON t_id = pi_ticket LEFT JOIN ticketTypes ON t_type = ttype_id LEFT JOIN payments ON pay_id = pi_payment LEFT JOIN paymentMethods ON pm_key = pay_method LEFT JOIN users ON pay_user = user_id LEFT JOIN contacts ON ctx_id = user_ctx WHERE ttype_event = ? ORDER BY ctx_lastname, ctx_firstname');
    $sql->bindValue(1, $evts->getKey());
    $sql->execute();

    while ($line = $sql->fetch()) {
        $tpl->append('customers', $line);
    }

    display();
}

function evadmin_type_details() {
    $mdl = new Modele('ticketTypes');
    $mdl->fetch($_REQUEST['type']);
    $mdl->ttype_event->assignTemplate('event');
    $mdl->assignTemplate('type');

    display();
}
