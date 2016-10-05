Feature: Handle password changing via the RESTful API

  In order to provide a more secure system
  As a client software developer
  I need to be able to let users change their current API password

  Background:
    Given there are Users with the following details:
      | id | username | email          | password |
      | 1  | peter    | peter@test.com | testpass |
      | 2  | john     | john@test.org  | johnpass |
    And I set header "Content-type" with value "application/json"


    Scenario: User must be logged in to hit the change password endpoint
    When I send a "POST" request to "/password/1/change" with body:
      """
      {
        "current_password": "testpass",
        "plainPassword": {
          "first": "newpass123",
          "second": "newpass123"
        }
      }
      """
    Then the response code should be 401


    Scenario: Can change password with valid credentials
      When I am successfully logged in with username: "peter", and password: "testpass"
      And I send a "POST" request to "/password/1/change" with body:
        """
        {
          "current_password": "testpass",
          "plainPassword": {
            "first": "newpass123",
            "second": "newpass123"
          }
        }
        """
      Then the response code should be 200
      And the response should contain "The password has been changed"


    Scenario: Cannot change password of another user
      When I am successfully logged in with username: "peter", and password: "testpass"
      And I send a "POST" request to "/password/2/change" with body:
        """
        {
          "current_password": "testpass",
          "plainPassword": {
            "first": "newpass123",
            "second": "newpass123"
          }
        }
        """
      Then the response code should be 403


   Scenario: Cannot change own password if current_password is incorrect
     When I am successfully logged in with username: "peter", and password: "testpass"
     And I send a "POST" request to "/password/1/change" with body:
        """
        {
          "current_password": "some-bad-password",
          "plainPassword": {
            "first": "newpass123",
            "second": "newpass123"
          }
        }
        """
     Then the response code should be 400
     And the response should contain "This value should be the user's current password."


  Scenario: Cannot change own password if new passwords do not match
    When I am successfully logged in with username: "peter", and password: "testpass"
    And I send a "POST" request to "/password/1/change" with body:
        """
        {
          "current_password": "testpass",
          "plainPassword": {
            "first": "123",
            "second": "456"
          }
        }
        """
    Then the response code should be 400
    And the response should contain "The entered passwords don't match"


  Scenario: Cannot change own password if missing one of the plainPassword fields
    When I am successfully logged in with username: "peter", and password: "testpass"
    And I send a "POST" request to "/password/1/change" with body:
        """
        {
          "current_password": "testpass",
          "plainPassword": {
            "second": "456"
          }
        }
        """
    Then the response code should be 400
    And the response should contain "The entered passwords don't match"