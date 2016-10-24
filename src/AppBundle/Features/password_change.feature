Feature: Handle password changing via the RESTful API

  In order to provide a more secure system
  As a client software developer
  I need to be able to let users change their current API password


  Background:
    Given there are Users with the following details:
      | id | username | email          | password | confirmation_token |
      | 1  | peter    | peter@test.com | testpass |                    |
      | 2  | john     | john@test.org  | johnpass | some-token-string  |
     And I set header "Content-Type" with value "application/json"


  Scenario: Cannot hit the change password endpoint if not logged in (missing token)
    When I send a "POST" request to "/password/1/change" with body:
      """
      {
        "current_password": "testpass",
        "plainPassword": {
          "first": "new password",
          "second": "new password"
        }
      }
      """
    Then the response code should be 401

  Scenario: Cannot change the password for a different user
    When I am successfully logged in with username: "peter", and password: "testpass"
     And I send a "POST" request to "/password/2/change" with body:
      """
      {
        "current_password": "testpass",
        "plainPassword": {
          "first": "new password",
          "second": "new password"
        }
      }
      """
    Then the response code should be 403

  Scenario: Can change password with valid credentials
    When I am successfully logged in with username: "peter", and password: "testpass"
     And I send a "POST" request to "/password/1/change" with body:
      """
      {
        "current_password": "testpass",
        "plainPassword": {
          "first": "new password",
          "second": "new password"
        }
      }
      """
    Then the response code should be 200
     And the response should contain "The password has been changed"

  Scenario: Cannot change password with bad current password
    When I am successfully logged in with username: "peter", and password: "testpass"
     And I send a "POST" request to "/password/1/change" with body:
      """
      {
        "current_password": "wrong",
        "plainPassword": {
          "first": "new password",
          "second": "new password"
        }
      }
      """
    Then the response code should be 400
     And the response should contain "This value should be your current password."

  Scenario: Cannot change password with mismatched new password
    When I am successfully logged in with username: "peter", and password: "testpass"
     And I send a "POST" request to "/password/1/change" with body:
      """
      {
        "current_password": "testpass",
        "plainPassword": {
          "first": "new password 11",
          "second": "new password 22"
        }
      }
      """
    Then the response code should be 400
     And the response should contain "The entered passwords don't match"

  Scenario: Cannot change password with missing new password field
    When I am successfully logged in with username: "peter", and password: "testpass"
     And I send a "POST" request to "/password/1/change" with body:
      """
      {
        "current_password": "testpass",
        "plainPassword": {
          "second": "missing first"
        }
      }
      """
    Then the response code should be 400
     And the response should contain "The entered passwords don't match"