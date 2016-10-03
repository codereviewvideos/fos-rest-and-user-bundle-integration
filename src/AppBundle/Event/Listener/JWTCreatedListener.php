<?php

namespace AppBundle\Event\Listener;

use Symfony\Component\Security\Core\Authentication\Token\Storage\TokenStorageInterface;
use Lexik\Bundle\JWTAuthenticationBundle\Event\JWTCreatedEvent;

class JWTCreatedListener
{
    /**
     * @var TokenStorageInterface
     */
    private $tokenStorage;

    /**
     * @param TokenStorageInterface $tokenStorage
     */
    public function __construct( TokenStorageInterface $tokenStorage)
    {
        $this->tokenStorage = $tokenStorage;
    }

    /**
     * Adds additional data to the generated JWT
     *
     * @param JWTCreatedEvent $event
     *
     * @return void
     */
    public function onJWTCreated(JWTCreatedEvent $event)
    {
        /** @var $user \AppBundle\Entity\User */
        $user = $event->getUser();

        // add new data
        $payload['userId'] = $user->getId();
        $payload['username'] = $user->getUsername();

        $event->setData($payload);
    }
}