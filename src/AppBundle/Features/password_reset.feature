Feature: Handle password changing via the RESTful API

  In order to help users quickly regain access to their account
  As a client software developer
  I need to be able to let users request a password reset


  Background:
    Given there are Users with the following details:
      | id | username | email          | password | confirmation_token |
      | 1  | peter    | peter@test.com | testpass |                    |
      | 2  | john     | john@test.org  | johnpass | some-token-string  |
    And I set header "Content-type" with value "application/json"



  ##### REQUESTING ###### @f @this
  Scenario: Cannot request a password for an invalid username
    When I send a "POST" request to "/password/reset/request" with body:
      """
      { "username": "made up" }
      """
    Then the response code should be 403
    And the response should contain "User not recognised"

 @f
  Scenario: User can request a password reset given a valid username
    When I send a "POST" request to "/password/reset/request" with body:
      """
      { "username": "peter" }
      """
    Then the response code should be 200
    And the response should contain "An email has been sent. It contains a link you must click to reset your password."


  Scenario: Cannot request another password reset for an account already requesting, but not yet confirmed
    When I send a "POST" request to "/password/reset/request" with body:
      """
      { "username": "john" }
      """
    Then the response code should be 403
    And the response should contain "The password for this user has already been requested within the last 24 hours."



  ##### CONFIRMATION #####
  Scenario: Cannot confirm a password reset without a valid token
    When I send a "POST" request to "/password/reset/confirm" with body:
      """
      {
        "bad": "data"
      }
      """
    Then the response code should be 400
    And the response should contain "You must submit a token"


  Scenario: Cannot confirm a password reset with an invalid token
    When I send a "POST" request to "/password/reset/confirm" with body:
      """
      {
        "token": "some bad token"
      }
      """
    Then the response code should be 400


  Scenario: Can confirm a password reset with a valid new password
    When I send a "POST" request to "/password/reset/confirm" with body:
      """
      {
        "token": "some-token-string",
        "plainPassword": {
          "first": "new password",
          "second": "new password"
        }
      }
      """
    Then the response code should be 200
    And the response should contain "The password has been reset successfully"
    And I send a "POST" request to "/login" with body:
      """
      { "username": "john", "password": "new password" }
      """
    Then the response code should be 200
    And the response should contain "token"


  Scenario: Cannot confirm a password reset without a new password
    When I send a "POST" request to "/password/reset/confirm" with body:
      """
      {
        "token": "some-token-string"
      }
      """
    Then the response code should be 400
    And the response should contain "Please enter a password"


  Scenario: Cannot confirm a password reset with a mismatched new password
    When I send a "POST" request to "/password/reset/confirm" with body:
      """
      {
        "token": "some-token-string",
        "plainPassword": {
          "first": "abc",
          "second": "def"
        }
      }
      """
    Then the response code should be 400
    And the response should contain "The entered passwords don't match"


  Scenario: Cannot confirm a password reset with a missing password field
    When I send a "POST" request to "/password/reset/confirm" with body:
      """
      {
        "token": "some-token-string",
        "plainPassword": {
          "second": "def"
        }
      }
      """
    Then the response code should be 400
    And the response should contain "The entered passwords don't match"