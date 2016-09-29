# FOS User Bundle with FOS REST Bundle integration

Full course available at : https://codereviewvideos.com/course/fosuser-fosrest-lexikjwt-user-login-registration-api

In this course we are going to create ourselves a RESTful user Registration and Login system using a combination of:

* FOSUserBundle
* FOSRESTBundle
* LexikJWTBundle

We will combine all three together to expose the numerous features provided by FOSUserBundle via a RESTful API. This will include user registration, user login, managing and maintaining user profiles, and updating and resetting user passwords.

As we are going to make use of FOSUserBundle, we will keep all the features that make this bundle so attractive - from user management via Symfony console commands, through to well thought out email notifications, and a full range of translations.

Certain parts will need tweaking, and for this we will need to override some of the functionality provided out-of-the-box by FOSUserBundle, to make it work in the way we expect.

Speaking of this, we will need to ensure our RESTful user login and registration system is well tested. For this we will make use of Behat, writing a full suite of tests to cover the various flows:

* Login
* Password Management
* Profile Updates
* Registration

We will also need to override part of the mail flow, so for this we will add in our own mailer service.

Along the way we will enhance the output given to us by default from LexikJWTBundle. We will add in additional data to the JWT it creates for us, allowing us to customise the created token as our system requires.

Whilst this system isn't the most visually appealing - it is a RESTful API after all - the functionality it provides will enable us to do some really interesting things.

Immediately following this course will be a subsequent course on how to implement a React & Redux powered login / registration front-end, making full use of the code found in this course.

Speaking of which, the code is immediately available. You can pull this code today and start playing with it. You can customise it, tweak it, change it to better meet your needs, or simply use it as a reference. Pull requests are always welcome, should you feel the code can be improved.

Lastly, before we start, I want to make you fully aware of one thing:

This is a suggested / example implementation. I am not for one moment suggesting this is the way to be approaching this problem. This code works for me and my needs. It may not work for you and yours. Please use your own careful judgement.

With that said, let's start by seeing the 'finished' application in action, and then learn how it is all put together.

P.s. - I say 'finished' as this is work in progress. There will very likely be extensions / bonus modules to this course which enhance the functionality. An example of this may be to add in billing with third party services, such as Stripe.
