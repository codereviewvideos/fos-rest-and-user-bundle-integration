<?php

namespace AppBundle\Event\Listener;

use AppBundle\Entity\User;
use Lexik\Bundle\JWTAuthenticationBundle\Event\JWTCreatedEvent;

class JWTCreatedListener
{
    public function onJWTCreated(JWTCreatedEvent $event)
    {
        /**
         * @var $user User
         */
        $user = $event->getUser();

        $payload = [
            'id' => $user->getId(),
            'username' => $user->getUsernameCanonical(),
        ];


        $event->setData($payload);
    }
}