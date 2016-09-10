Feature: Handle password changing via the RESTful API

  In order to allow a user to update their current API credentials
  As a client software developer
  I need to be able to let users change their password


  Background:
    Given there are Users with the following details:
      | id | username | email          | password |
      | 1  | peter    | peter@test.com | testpass |
      | 2  | john     | john@test.org  | johnpass |
    And I set header "Content-Type" with value "application/json"


  Scenario: Cannot request a password reset for an invalid username
    When I send a "POST" request to "/password/reset/request" with body:
      """
      { "username": "davey" }
      """
    Then the response code should be 403
     And the response should contain "Invalid username"

#  @this
#  Scenario: Cannot request another password reset for an account already requesting but not yet actioning the reset request
#    When I send a "POST" request to "/password/reset" with body:
#      """
#      { "username": "davey" }
#      """
#    Then the response code should be 403
#    And the response should contain "Invalid username"

  @this
  Scenario: Can request a password reset for a valid username
    When I send a "POST" request to "/password/reset/request" with body:
      """
      { "username": "peter" }
      """
    Then the response code should be 200

