# firefox

## what is in the profile directory
Source: <https://support.mozilla.org/en-US/kb/profiles-where-firefox-stores-user-data>

... and reading files in the profile directory.

Not everything is included in the list

Tip for viewing jsonlz4 files:
```sh
dejsonlz4 file.jsonlz4 | jq -C | less
```

- **places.sqlite**: bookmarks, downloads, history
- **permissions.sqlite**: site permissions
- **content-prefs.sqlite**: site preferences
- **cookies.sqlite**: cookies (duh)
- **webappsstore.sqlite**: DOM storage for non-about pages (ie actual websites)
- **cert9.db**: imported certificates and settings
- **handlers.json**: download actions
- **sessionstore.jsonlz4**: currently open tabs and windows
- **xulstore.json**: toolbar and window settings

