<?php

use ticketgen\TicketGen;

/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function tickets_index() {
    $mdl = new Modele('tickets');
    
    $mdl->find(array(
        't_user' => $_SESSION['user']['user_id'],
        't_status' => 'PAID',
    ));
    
    $mdl->appendTemplate('tickets');
    display();
}

function tickets_print() {
    global $tpl;

    $tk = new Modele('tickets');
    $tk->fetch($_REQUEST['ticket']);
    $tk->assignTemplate('ticket');
    
    $gen = new TicketGen();
    $gen->setConfig(array(
        'default' => array(
            'txt_object' => 'Votre billet pour ' . $tk->t_type->ttype_event->event_title,
            'txt_main' => $tpl->fetch("ticket_main.tpl"),
        )
    ));
    $gen->mkticket($tk);
    $gen->mkpdf();
}