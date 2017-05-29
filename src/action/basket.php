<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function basket_buy() {
    global $tpl, $pdo;

    $mdl = new Modele('ticketTypes');
    $mdl->fetch($_REQUEST['type']);
    $mdl->assignTemplate('type');

    if (isset($_REQUEST['ctx'])) {
        $ctx = new Modele('contacts');
        $ctx->fetch($_REQUEST['ctx']);

        $tfd = new Modele('tickets');
        $tfd->find(array(
            't_type' => $mdl->getKey(),
            't_ctx' => $ctx->getKey(),
            't_status' => array(
                'TMP',
                'VALID',
                'PAID',
            )
        ));

        //Ticket existant
        if ($tfd->count() > 0) {
            $tpl->assign('hsuccess', 'Vous avez déjà acheté ce ticket');
            display();
        }

        $scout = $pdo->prepare('SELECT COUNT(*) FROM tickets WHERE t_type = ?');
        $scout->bindValue(1, $mdl->getKey());
        $scout->execute();
        $nbtickets = $scout->fetchColumn(0);

        //Plus aucun ticket du type
        if ($nbtickets >= $mdl->ttype_maxTickets) {
            $tpl->assign('hsuccess', 'Il n\'y a plus aucun ticket disponible');
            display();
        }

        //Ticket sur l'événement
        $sevent = $pdo->prepare('SELECT COUNT(*) FROM tickets LEFT JOIN ticketTypes ON t_type = ttype_id WHERE ttype_event = ? AND (t_status = "TMP" OR t_status = "VALID" OR t_status = "PAID")');
        $sevent->bindValue(1, $mdl->raw_ttype_event);
        $sevent->execute();
        $nbEventTickets = $sevent->fetchColumn(0);

        if ($nbEventTickets > 0) {
            $tpl->assign('hsuccess', 'Vous avez déjà un ticket sur cet événement');
            display();
        }

        $date = new DateTime();
        $date->add(new DateInterval('PT2H'));

        $tfd->addFrom(array(
            't_type' => $mdl->getKey(),
            't_ctx' => $ctx->getKey(),
            't_user' => $_SESSION['user']['user_id'],
            't_endlife' => $date->format('Y-m-d H:i:s'),
        ));

        redirect('basket');
    }

    display();
}

function basket_index() {
    $mdl = new Modele('tickets');
    $mdl->find(array(
        't_user' => $_SESSION['user']['user_id'],
        't_status' => 'TMP'
    ));
    $mdl->appendTemplate('tickets');

    display();
}

function basket_remove() {
    $mdl = new Modele('tickets');
    $mdl->fetch($_REQUEST['ticket']);
    $mdl->delete();

    redirect('basket', 'index', array('hsuccess' => 1));
}

function _basket_getconf() {
    $allTickets = new Modele('tickets');
    $allTickets->find(array(
        't_user' => $_SESSION['user']['user_id'],
        't_status' => 'TMP',
    ));

    if (!$allTickets->next()) {
        $tpl->assign('hsuccess', 'Le panier est vide');
    }

    $payconf = $allTickets->t_type->ttype_payconf;


    // BREAK

    $buyTickets = array(new Modele($allTickets));
    while ($allTickets->next()) {
        if ($allTickets->t_type->raw_ttype_payconf == $payconf->pc_id) {
            $buyTickets[] = new Modele($allTickets);
        }
    }

    return $buyTickets;
}

function basket_payconf() {
    global $tpl;

    $tickets = _basket_getconf();

    $payconf = $tickets[0]->t_type->ttype_payconf;
    $payconf->assignTemplate('config');

    if (isset($_POST['config'])) {
        $conf = new Modele('paymentMethods');
        $conf->fetch($_POST['config']);

        $drvStr = 'Libs\\PaymtIface\\' . $conf->pm_class;
        $drv = new $drvStr();

        $pmt = new Modele('payments');
        $pmt->addFrom(array(
            'pay_amount' => 0,
            'pay_date' => date('Y-m-d H:i:s'),
            'pay_user' => $_SESSION['user']['user_id'],
            'pay_method' => $conf->getKey(),
        ));
        foreach ($tickets as $ticket) {
            $payItem = new Modele('paymentItems');
            $payItem->addFrom(array(
                'pi_ticket' => $ticket->getKey(),
                'pi_payment' => $pmt->getKey(),
            ));
            //$ticket->t_status = 'WAIT';
        }
        $drv->Fetch($pmt);
        $drv->Execute();
    }

    $mdl = new Modele('paymentMethods');
    $mdl->find(array(
        'pm_config' => $payconf->getKey(),
    ));

    while ($mdl->next()) {

        $drvStr = 'Libs\\PaymtIface\\' . $mdl->pm_class;
        $drv = new $drvStr();
        $drv->setTickets($tickets);

        $line = array(
            'obj' => new Modele($mdl),
            'fee' => $drv->getFee(),
            'total' => $drv->getTotalTTC(),
        );
        $tpl->append('configs', $line);
    }

    display();
}

function basket_checkout() {
    global $tpl, $urlbase;

    $buyTickets = _basket_getTickets();
}

function basket_cancel() {
    $payconf = new Modele('payments');
    $payconf->fetch($_REQUEST['payment']);

    $payconf->pay_state = 'CANCELED';

    $tickets = new Modele('paymentItems');
    $tickets->find(array(
        'pi_payment' => $payconf->getKey(),
    ));

    // http://localhost/billets/htdocs/index.php?action=basket&page=cancel&payment=21&token=EC-6G349576MP842340K
    while ($tickets->next()) {
        $tickets->pi_ticket->t_status = 'TMP';
    }

    //Get Driver and cancel payment
    $drvStr = '\\Libs\\PaymtIface\\' . $payconf->pay_method->pm_class;
    $drv = new $drvStr();
    $drv->Fetch($payconf);
    $drv->Cancel();

    redirect('basket', 'index', array('hsuccess' => 0));
}

function basket_approuve() {
    global $tpl;

    $myPay = new Modele('payments');
    $myPay->fetch($_REQUEST['payment']);

    //Get Driver and cancel payment
    $drvStr = '\\Libs\\PaymtIface\\' . $myPay->pay_method->pm_class;
    $drv = new $drvStr();
    $drv->Fetch($myPay);

    if (!$drv->Verify()) {
        redirect('basket', 'index', array('hsuccess' => 0));
    }

    $myPay->pay_state = 'ACCEPT';

    $tks = new Modele('paymentItems');
    $tks->find(array(
        'pi_payment' => $myPay->getKey(),
    ));

    while ($tks->next()) {
        $tks->pi_ticket->t_status = 'PAID';
    }


    redirect('tickets', 'index', array('hsuccess' => 1));
}
