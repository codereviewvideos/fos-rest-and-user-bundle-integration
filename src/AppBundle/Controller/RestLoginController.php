<?php

namespace AppBundle\Controller;

use FOS\RestBundle\Controller\Annotations\RouteResource;
use FOS\RestBundle\Controller\FOSRestController;
use FOS\RestBundle\Routing\ClassResourceInterface;

/**
 * Class RestLoginController
 * @package AppBundle\Controller
 *
 * @RouteResource("login", pluralize=false)
 */
class RestLoginController extends FOSRestController implements ClassResourceInterface
{
    public function postAction()
    {
        // should never get here, should be handled by Lexik JWT
        throw new \DomainException('Should never see this error');
    }
}