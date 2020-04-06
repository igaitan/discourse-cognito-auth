# Cognito Authentication Plugin

This plugin adds support for logging in to a Discourse site via Cognito.

## Installation

1. Follow the directions at [Install a Plugin](https://meta.discourse.org/t/install-a-plugin/19157) using https://github.com/igaitan/discourse-cognito-auth as the repository URL.
2. Rebuild the app using `./launcher rebuild app`
3. Create a new User pool (or use existing one) from aws console.
4. Go to the pool settings and note the app client id, Secure key and pool id.
5. In your Discourse instance, go to Site Settings, filter by "Cognito" and enter the values.
6. Check the "cognito auth enabled" checkbox, and you're done!

## Own Fixes done

1. gem 'omniauth-cognito-idp' version is not 1.5.0 so remove version to get updated current version of gemfile.
2. server.en.yml fixed double double quote
