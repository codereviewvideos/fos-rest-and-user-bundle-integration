<?php

namespace AppBundle\Controller;

use FOS\RestBundle\Controller\Annotations\Get;
use FOS\RestBundle\Controller\Annotations\Patch;
use FOS\RestBundle\Controller\Annotations\Put;
use FOS\RestBundle\Controller\Annotations\RouteResource;
use FOS\RestBundle\Controller\FOSRestController;
use FOS\RestBundle\Routing\ClassResourceInterface;
use FOS\UserBundle\Event\FilterUserResponseEvent;
use FOS\UserBundle\Event\FormEvent;
use FOS\UserBundle\Event\GetResponseUserEvent;
use FOS\UserBundle\FOSUserEvents;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\ParamConverter;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
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


    /**
     * @param Request $request
     *
     * @Put("/profile/{user}")
     *
     * @ParamConverter("user", class="AppBundle:User")
     */
    public function putAction(Request $request, UserInterface $user)
    {
        return $this->updateProfile($request, $user, true);
    }

    /**
     * @param Request $request
     *
     * @Patch("/profile/{user}")
     *
     * @ParamConverter("user", class="AppBundle:User")
     */
    public function patchAction(Request $request, UserInterface $user)
    {
        return $this->updateProfile($request, $user, false);
    }


    private function updateProfile(Request $request, UserInterface $user, $clearMissing = true)
    {
        $user = $this->getAction($user);

        /** @var $dispatcher \Symfony\Component\EventDispatcher\EventDispatcherInterface */
        $dispatcher = $this->get('event_dispatcher');

        $event = new GetResponseUserEvent($user, $request);
        $dispatcher->dispatch(FOSUserEvents::PROFILE_EDIT_INITIALIZE, $event);

        if (null !== $event->getResponse()) {
            return $event->getResponse();
        }

        /** @var $formFactory \FOS\UserBundle\Form\Factory\FactoryInterface */
        $formFactory = $this->get('fos_user.profile.form.factory');

        $form = $formFactory->createForm(['csrf_protection' => false]);
        $form->setData($user);

        $form->submit($request->request->all(), $clearMissing);

        if ( ! $form->isValid()) {
            // return the form with any errors if invalid
            return $form;
        }

        /** @var $userManager \FOS\UserBundle\Model\UserManagerInterface */
        $userManager = $this->get('fos_user.user_manager');

        $event = new FormEvent($form, $request);
        $dispatcher->dispatch(FOSUserEvents::PROFILE_EDIT_SUCCESS, $event);

        $userManager->updateUser($user);

        if (null === $response = $event->getResponse()) {
            return $this->routeRedirectView(
                'get_profile',
                [ 'user' => $user->getId() ],
                Response::HTTP_NO_CONTENT
            );
        }

        $dispatcher->dispatch(
            FOSUserEvents::PROFILE_EDIT_COMPLETED,
            new FilterUserResponseEvent($user, $request, $response)
        );

        return $this->routeRedirectView(
            'get_profile',
            [ 'user' => $user->getId() ],
            Response::HTTP_NO_CONTENT
        );
    }
}