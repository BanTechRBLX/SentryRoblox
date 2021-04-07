# SentryRoblox
A module to facilitate error logging to Sentry from Roblox.

## Usage
To use the module, you'll first need to set up an account at [https://sentry.io](Sentry). A free plan is available providing an allowance up to 5K errors.

Create a project, and if asked select "Other platform". You might find yourself stuck in the onboarding process - ignore it, go to Sentry again and log in to see your dashboard. Your project should be there.

Once created, you'll need the DSN URL, found in the project settings (cog next to the project name) under Client Keys (DSN) on the white sidebar.

The DSN will look something like the URL below:
`https://sentryapikeyhere@o123456.ingest.sentry.io/1234567`

The part before the @ is your API key, `sentryapikey` in this case.
The part after the @ is your API URL, `https://o123456.ingest.sentry.io/1234567` in this case.
