<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

namespace Libs\PaymtIface;

use Modele;

/**
 *
 * @author bontiv
 */
interface PaymentInterface {
    public function Verify();
    public function Cancel();
    public function Execute();
    public function Fetch(Modele $payment);
    public function getTotalTTC();
    public function getTotalHT();
    public function getFee();
    public function setTickets($tickets);
    
    
}
