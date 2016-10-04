Feature: Manage User profile data via the RESTful API

  In order to allow a user to keep their profile information up to date
  As a client software developer
  I need to be able to let users read and update their profile


  Background:
    Given there are Users with the following details:
      | id | username | email          | password |
      | 1  | peter    | peter@test.com | testpass |
      | 2  | john     | john@test.org  | johnpass |
    And I set header "Content-type" with value "application/json"
    And I am successfully logged in with username: "peter", and password: "testpass"


    Scenario: Cannot view a profile with a bad JWT
      When I set header "Authorization" with value "Bearer some-bad-token"
      And I send a "GET" request to "/profile/1"
      Then the response code should be 401
      And the response should not contain "invalid JWT token"


    Scenario: Can view own profile
      When I send a "GET" request to "/profile/1"
      Then the response code should be 200
      And the response should contain json:
        """
        {
          "id": 1,
          "username": "peter",
          "email": "peter@test.com"
        }
        """


    Scenario: Cannot view another user's profile
      When I send a "GET" request to "/profile/2"
      Then the response code should be 403


    Scenario: User must supply a valid current password when updating their Profile
      When I send a "PUT" request to "/profile/1" with body:
          """
          {
            "username": "peter",
            "email": "new_email@test.com"
          }
          """
      Then the response code should be 400


    Scenario: User can update their profile by using PUT (replace)
      When I send a "PUT" request to "/profile/1" with body:
        """
        {
          "username": "peter",
          "email": "new_email@test.com",
          "current_password": "testpass"
        }
        """
      Then the response code should be 204
      And I send a "GET" request to "/profile/1"
      And the response should contain json:
        """
        {
          "id": 1,
          "username": "peter",
          "email": "new_email@test.com"
        }
        """

    Scenario: User cannot update another User's profile
      When I send a "PUT" request to "/profile/2" with body:
          """
          {
            "username": "peter",
            "email": "new_email@test.com",
            "current_password": "testpass"
          }
          """
      Then the response code should be 403


    Scenario: User can partially update their profile by using PATCH
      When I send a "PATCH" request to "/profile/1" with body:
          """
          {
            "email": "other_email@test.com",
            "current_password": "testpass"
          }
          """
      Then the response code should be 204
      And I send a "GET" request to "/profile/1"
      And the response should contain json:
          """
          {
            "id": 1,
            "username": "peter",
            "email": "other_email@test.com"
          }
          """


    Scenario: User cannot update another User's profile
      When I send a "PATCH" request to "/profile/2" with body:
            """
            {
              "email": "new_email@test.com",
              "current_password": "testpass"
            }
            """
      Then the response code should be 403