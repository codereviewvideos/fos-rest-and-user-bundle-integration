<?php

namespace AppBundle\Controller;

use FOS\RestBundle\Controller\Annotations\Get;
use FOS\RestBundle\Controller\Annotations\RouteResource;
use FOS\RestBundle\Controller\FOSRestController;
use FOS\RestBundle\Routing\ClassResourceInterface;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\ParamConverter;
use Symfony\Component\HttpKernel\Exception\AccessDeniedHttpException;
use Symfony\Component\Security\Core\User\UserInterface;

/**
 * Class RestProfileController
 * @package AppBundle\Controller
 *
 * @RouteResource("profile", pluralize=false)
 */
class RestProfileController extends FOSRestController implements ClassResourceInterface
{

    /**
     * @Get("/profile/{user}")
     *
     * @ParamConverter("user", class="AppBundle:User")
     *
     * @return mixed
     */
    public function getAction(UserInterface $user)
    {
        if ($user !== $this->getUser()) {
            throw new AccessDeniedHttpException();
        }

        return $user;
    }

}