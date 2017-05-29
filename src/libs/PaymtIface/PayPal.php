<?php

namespace Libs\PaymtIface;

use PayPal\Api\Amount;
use PayPal\Api\Details;
use PayPal\Api\Item;
use PayPal\Api\ItemList;
use PayPal\Api\Payer;
use PayPal\Api\Payment;
use PayPal\Api\RedirectUrls;
use PayPal\Api\Transaction;
use PayPal\Api\PaymentExecution;
use PayPal\Rest\ApiContext;
use PayPal\Auth\OAuthTokenCredential;
use Modele;
use DateTime;
use DateInterval;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

class PayPal implements PaymentInterface {

    private $tickets;
    private $total = 0;
    private $paymnt;

    private function getContext() {
        $conf = json_decode($this->paymnt->pay_method->pm_configuration);
        return new ApiContext(
                new OAuthTokenCredential(
                $conf->client_id, $conf->client_secret
                )
        );
    }

    public function setTickets($tickets) {
        $this->tickets = $tickets;
        $this->total = 0;
    }

    public function getTotalHT() {
        if ($this->total > 0) {
            return $this->total;
        }

        foreach ($this->tickets as $ticket) {
            $this->total += $ticket->t_type->ttype_price / 100;
        }

        return $this->total;
    }

    public function getFee() {
        $total = $this->getTotalHT();
        return round(0.25 + 0.034 * $total, 2, 2);
    }

    public function getTotalTTC() {
        return $this->getTotalHT() + $this->getFee();
    }

    public function Fetch(\Modele $pmt) {
        $this->total = 0;
        $this->tickets = array();
        $this->paymnt = $pmt;

        $tickets = new \Modele('paymentItems');
        $tickets->find(array(
            'pi_payment' => $pmt->getKey(),
        ));

        while ($tickets->next()) {
            $this->tickets[] = new \Modele($tickets->pi_ticket);
        }
    }

    public function Execute() {
        global $urlbase;

        $apiContext = $this->getContext();

        $apiContext->setConfig(array(
            'mode' => 'sandbox', //replace by live
        ));

        var_dump($this->getTotalHT(), $this->getFee(), $this->getTotalTTC());
        echo '<BR><BR><BR>';
        
        $payer = new Payer();
        $payer->setPaymentMethod("paypal"); //Credit Card

        $itemList = new ItemList();
        $total = 0;

        foreach ($this->tickets as $ticket) {
            $item = new Item();
            $item->setCurrency('EUR');
            $item->setName($ticket->t_type->ttype_event->event_title . ' - ' . $ticket->t_type->ttype_title);
            $item->setQuantity(1);
            $item->setPrice(sprintf("%.2F", $ticket->t_type->ttype_price / 100));
            $total += $ticket->t_type->ttype_price;
            $itemList->addItem($item);
        }

        // Payment details
        $details = new Details();
        $details->setTax(sprintf("%.2F", $this->getFee()));
        $details->setShipping(0);
        $details->setSubtotal(sprintf("%.2F", $this->getTotalHT()));

        // Set payment amount
        $amount = new Amount();
        $amount->setCurrency("EUR")
                ->setTotal(sprintf("%.2F", $this->getTotalTTC()));
        $amount->setDetails($details);

        // Set transaction object
        $transaction = new Transaction();
        $transaction->setAmount($amount)
                ->setDescription("Achat billets");
        $transaction->setItemList($itemList);

        $this->paymnt->pay_amount = $this->getTotalTTC();

        // Set redirect urls
        $redirect = $_SERVER['REQUEST_SCHEME'] . '://' . $_SERVER['HTTP_HOST'] . $urlbase . 'action=basket&page=';
        $redirectUrls = new RedirectUrls();
        $redirectUrls->setReturnUrl($redirect . 'approuve&payment=' . $this->paymnt->getKey())
                ->setCancelUrl($redirect . 'cancel&payment=' . $this->paymnt->getKey());

        // Create the full payment object
        $payment = new Payment();
        $payment->setIntent('sale')
                ->setPayer($payer)
                ->setRedirectUrls($redirectUrls)
                ->setTransactions(array($transaction));

        try {
            $payment->create($apiContext);
            $this->paymnt->pay_data = $payment->toJSON();
            $this->paymnt->pay_transaction = $payment->getId();

            $date = new DateTime();
            $date->add(new DateInterval('PT2H'));

            header('Location: ' . $payment->getApprovalLink());
            quit();
        } catch (\PayPal\Exception\PayPalConnectionException $ex) {
            echo "<br/><br/><strong>" . $ex->getMessage() . "</strong>";
        }
    }

    public function Cancel() {
        
    }

    public function Verify() {
        if ($this->paymnt->pay_transaction != $_GET['paymentId']) {
            return FALSE;
        }

        $apiContext = $this->getContext();

        $payment = Payment::get($this->paymnt->pay_transaction, $apiContext);

        $execute = new PaymentExecution();
        $execute->setPayerId($_GET['PayerID']);

        try {
            $payment->execute($execute, $apiContext);
            $this->paymnt->pay_data = $payment->toJSON();

            if ($payment->getState() != 'approved') {
                return FALSE;
            }

            return TRUE;
        } catch (PayPal\Exception\PayPalConnectionException $ex) {
            return FALSE;
        }
    }

}
