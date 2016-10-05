<?php

namespace AppBundle\Controller;

use FOS\RestBundle\Controller\Annotations\Post;
use FOS\RestBundle\Controller\Annotations\Prefix;
use FOS\RestBundle\Controller\Annotations\RouteResource;
use FOS\RestBundle\Controller\FOSRestController;
use FOS\RestBundle\Routing\ClassResourceInterface;
use FOS\UserBundle\Event\FilterUserResponseEvent;
use FOS\UserBundle\Event\FormEvent;
use FOS\UserBundle\Event\GetResponseUserEvent;
use FOS\UserBundle\FOSUserEvents;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\ParamConverter;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpKernel\Exception\AccessDeniedHttpException;
use Symfony\Component\Security\Core\User\UserInterface;

/**
 * Class RestPasswordManagementController
 * @package AppBundle\Controller
 *
 * @Prefix("password")
 * @RouteResource("password", pluralize=false)
 */
class RestPasswordManagementController extends FOSRestController implements ClassResourceInterface
{
    /**
     * @Post("/{user}/change")
     *
     * @ParamConverter("user", class="AppBundle:User")
     */
    public function changeAction(Request $request, UserInterface $user)
    {
        if ($user !== $this->getUser()) {
            throw new AccessDeniedHttpException();
        }

        /** @var $dispatcher \Symfony\Component\EventDispatcher\EventDispatcherInterface */
        $dispatcher = $this->get('event_dispatcher');

        $event = new GetResponseUserEvent($user, $request);
        $dispatcher->dispatch(FOSUserEvents::CHANGE_PASSWORD_INITIALIZE, $event);

        if (null !== $event->getResponse()) {
            return $event->getResponse();
        }

        /** @var $formFactory \FOS\UserBundle\Form\Factory\FactoryInterface */
        $formFactory = $this->get('fos_user.change_password.form.factory');

        $form = $formFactory->createForm(['csrf_protection' => false]);
        $form->setData($user);

        $form->submit($request->request->all());

        if ( ! $form->isValid()) {
            return $form;
        }

        /** @var $userManager \FOS\UserBundle\Model\UserManagerInterface */
        $userManager = $this->get('fos_user.user_manager');

        $event = new FormEvent($form, $request);
        $dispatcher->dispatch(FOSUserEvents::CHANGE_PASSWORD_SUCCESS, $event);

        $userManager->updateUser($user);

        if (null === $response = $event->getResponse()) {
            return new JsonResponse(
                $this->get('translator')->trans('change_password.flash.success', [], 'FOSUserBundle'),
                JsonResponse::HTTP_OK
            );
        }

        $dispatcher->dispatch(
            FOSUserEvents::CHANGE_PASSWORD_COMPLETED,
            new FilterUserResponseEvent($user, $request, $response)
        );

        return new JsonResponse(
            $this->get('translator')->trans('change_password.flash.success', [], 'FOSUserBundle'),
            JsonResponse::HTTP_OK
        );
    }
}