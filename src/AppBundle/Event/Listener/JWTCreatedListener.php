<?php

namespace AppBundle\Event\Listener;

use AppBundle\Entity\User;
use Lexik\Bundle\JWTAuthenticationBundle\Event\JWTCreatedEvent;
use Symfony\Component\Security\Core\Authentication\Token\Storage\TokenStorageInterface;

class JWTCreatedListener
{
    /**
     * @var TokenStorageInterface
     */
    private $tokenStorage;

    public function __construct(TokenStorageInterface $tokenStorage)
    {
        $this->tokenStorage = $tokenStorage;
    }

    public function onJWTCreated(JWTCreatedEvent $event)
    {
        /** @var $user User */
        $user = $event->getUser();

        $payload['userId'] = $user->getId();
        $payload['username'] = $user->getUsernameCanonical();

        $event->setData($payload);
    }
}
