# SentryRoblox
A module to facilitate error logging to Sentry from Roblox.

## Sentry Setup
To use the module, you'll first need to set up an account at [Sentry](https://sentry.io). A free plan is available providing an allowance up to 5K errors.

Create a project, and if asked select "Other platform". You might find yourself stuck in the onboarding process - ignore it, go to Sentry again and log in to see your dashboard. Your project should be there.

Once created, you'll need the DSN URL, found in the project settings (cog next to the project name) under Client Keys (DSN) on the white sidebar.

The DSN will look something like the URL below:
`https://sentryapikeyhere@o123456.ingest.sentry.io/1234567`

The part before the @ is your API key, `sentryapikey` in this case.
The part after the @ is your API URL, `https://o123456.ingest.sentry.io/1234567` in this case.

## Module Installation
It's up to you whether you want to include the module as a Script that runs itself, or as a module that you must `require()` for it to run. Either way once the code has run it's set up and ready to go.

Before publishing, be sure to swap out the API URL, API key and project name with your specifics.

You can tweak how the script determines whether or not to log an error to the staging or production environment, and whether warnings are recorded or not. Instructions for these are in the module itself.
