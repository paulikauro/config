# firefoks settings

from urllib.request import urlopen
from pathlib import Path
import json
import re

settings_file = Path.home() / "config/firefoks/settings.json"

write_settings = lambda x: settings_file.write_text(json.dumps(x, sort_keys=True, indent=2))
read_settings = lambda: json.loads(settings_file.read_text())

# TODO: parse comments too
make_pattern = lambda fn: re.compile(fr'^\s*{fn}\s*\(\s*"(?P<key>.+)"\s*,\s*(?P<val>.+)\s*\)\s*\;\s*(\/\/.*)?$', re.MULTILINE)
USER_PREF = make_pattern("user_pref")
config_to_dict = lambda s: {m["key"]: m["val"] for m in USER_PREF.finditer(s)}
read_config = lambda f: config_to_dict(f.read_text())


def fetch(url):
    with urlopen(url) as f:
        return f.read().decode()


userjs_sources = {
    "bfsec": "https://gist.githubusercontent.com/brainfucksec/68e79da1c965aeaa4782914afd8f7fa2/raw/ecb5ba67b093dcfc1e759059d1f421011495277b/user.js",
    "arkenfox": "https://raw.githubusercontent.com/arkenfox/user.js/master/user.js",
    "12bytes": "https://codeberg.org/12bytes.org/firefox-user.js-supplement/raw/branch/master/user-overrides.js",
}

fetch_userjses = lambda: {
    key: config_to_dict(fetch(url))
    for key, url in userjs_sources.items()
}

def fetch_de956():
    text = fetch("https://raw.githubusercontent.com/de956/browser-privacy/main/README.md")
    pairs = re.findall(r'^\<code\>(.*)\<\/code\> \| \<code\>(.*)\<\/code\>$', text, re.MULTILINE)
    replacements = {
        " empty value ": '""',
        "**false**": "false",
        "empty value": '""',
        " -1 ": "-1",
    }
    if diff := {v for _, v in pairs} ^ replacements.keys():
        print(f"fetch_de956: key set difference {diff}")
        exit(1)
    return {k: replacements[v] for k, v in pairs}

fetch_all = lambda: {**fetch_userjses(), "de956": fetch_de956()}

all_keys = lambda x: set().union(*map(dict.keys, x.values()))

def stuff():
    pass

