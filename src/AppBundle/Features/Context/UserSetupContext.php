<?php

namespace AppBundle\Features\Context;

use Behat\Behat\Context\Context;
use Behat\Behat\Context\SnippetAcceptingContext;
use Behat\Gherkin\Node\TableNode;
use Doctrine\ORM\EntityManagerInterface;
use FOS\UserBundle\Model\UserManagerInterface;

class UserSetupContext implements Context, SnippetAcceptingContext
{
    /**
     * @var UserManagerInterface
     */
    private $userManager;
    /**
     * @var EntityManagerInterface
     */
    private $em;

    /**
     * UserSetupContext constructor.
     *
     * @param UserManagerInterface   $userManager
     * @param EntityManagerInterface $em
     */
    public function __construct(UserManagerInterface $userManager, EntityManagerInterface $em)
    {
        $this->userManager = $userManager;
        $this->em = $em;
    }

    /**
     * @Given there are Users with the following details:
     */
    public function thereAreUsersWithTheFollowingDetails(TableNode $users)
    {
        foreach ($users->getColumnsHash() as $key => $val) {

            $confirmationToken = isset($val['confirmation_token']) && $val['confirmation_token'] != ''
                ? $val['confirmation_token']
                : null;

            $user = $this->userManager->createUser();

            $user->setEnabled(true);
            $user->setUsername($val['username']);
            $user->setEmail($val['email']);
            $user->setPlainPassword($val['password']);
            $user->setConfirmationToken($confirmationToken);

            if ( ! empty($confirmationToken)) {
                $user->setPasswordRequestedAt(new \DateTime('now'));
            }

            $this->userManager->updateUser($user);
        }
    }
}