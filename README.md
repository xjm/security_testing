# security_testing
Improved script for generating build.yml files for the private DrupalCI test runner.

This script is used to trigger automated tests for private Drupal security issues for Drupal 8 and higher. 
For Drupal 7 testing, use the [kick_drupalCI project](https://www.drupal.org/project/kick_drupalci) on
[Drupal.org](https://www.drupal.org/).

## Installation

1. Clone this repository.
2. Put the email address you wish to use to receive test results in a file called `.email` 
   in the root of the cloned repository:
   ```
   ~/security_testing $ echo "you@example.com" > .email
   ```
3. Contact a Security Team member for the secret job token. Place it in a secure `.token` file
   in the root of the cloned repository:
   ```
   ~/security_testing $ echo "SECRET_TOKEN_HERE" > .token
   ~/security_testing $ chmod 600 .token
   ```
4. Contact a Security Team member for the secret API token. Place it in a secure `.api_token`
   file in the root of the cloned repositiory:
   ```
   ~/security_testing $ echo "SECRET_API_TOKEN_HERE" > .api_token
   ~/security_testing $ chmod 600 .api_token
   ```

## Running tests

The script allows you to queue test runs against multiple branches and tags for a single issue.

From within the repository, run the `generate.sh` script:
```
~/security_testing $ sh generate.sh
```

Follow the prompts. Use the one-time download links you wish to test.
