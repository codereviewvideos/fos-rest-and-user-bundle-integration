Feature: Handle user login via a RESTful API

  In order to allow secure access to the system
  As a client software developer
  I need to be able to let users log in and out


  Background:
    Given there are Users with the following details:
      | id | username | email          | password |
      | 1  | peter    | peter@test.com | testpass |
      | 2  | john     | john@test.org  | johnpass |


  Scenario: User can login with good credentials
    When I send a "POST" request to "/login" with body:
      """
      { "username": "peter", "password": "testpass" }
      """
    Then the response code should be 200
    And the response should contain "token"