<?php

namespace AppBundle\DependencyInjection\Compiler;

use AppBundle\Event\Listener\EmailConfirmationListener;
use Symfony\Component\DependencyInjection\Compiler\CompilerPassInterface;
use Symfony\Component\DependencyInjection\ContainerBuilder;

class OverrideFOSUserBundleEmailConfirmationListenerPass implements CompilerPassInterface
{
    public function process(ContainerBuilder $container)
    {
        $definition = $container->getDefinition('fos_user.listener.email_confirmation');
        $definition->setClass(EmailConfirmationListener::class);
    }
}