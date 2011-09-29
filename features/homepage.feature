Feature:

  Scenario: User should see tonight's top show picks
    Given a featured show exists
    When I go to the home page
    Then I should see the show

  Scenario: Users should see latest video on homepage
    Given a video exists
    When I go to the home page
    Then I should see a thumbnail for the video

  Scenario: User sees top news on homepage
    Given the following homepage exists:
      | exciting_news                    |
      | This is some damn exciting news! |
    When I go to the home page
    Then I should see "This is some damn exciting news!"
