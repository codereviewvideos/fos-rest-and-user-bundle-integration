<?php

namespace AppBundle\Controller;

use FOS\RestBundle\View\View;
use FOS\RestBundle\Controller\FOSRestController;
use FOS\RestBundle\Routing\ClassResourceInterface;
use FOS\RestBundle\Controller\Annotations\RouteResource;

/**
 * @RouteResource("healthcheck", pluralize=false)
 */
class HealthcheckController extends FOSRestController implements ClassResourceInterface
{
    /**
     * @return View
     */
    public function getAction()
    {
        return new View('hello');
    }
}