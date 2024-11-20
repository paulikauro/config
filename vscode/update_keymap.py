import urllib.request, json
from pathlib import Path

def download(url):
    with urllib.request.urlopen(url) as response:
        return response.read().decode()

def get_agda_map():
    s = download("https://github.com/banacorn/agda-mode-vscode/raw/refs/heads/master/asset/keymap.js")
    return json.loads(s[25:])

def untrie(x, pfx="", allow_conflicts=False):
    for k, v in x.items():
        if k == ">>":
            if allow_conflicts:
                for y in v:
                    yield (pfx, y)
            else:
                if len(v) == 1:
                    yield (pfx, v[0])
                else:
                    for i, y in enumerate(v):
                        yield (pfx + str(i), y)
        else:
            yield from untrie(v, pfx + k)

def get_latex_input_map():
    return json.loads(download("https://github.com/YellPika/vscode-latex-input/raw/refs/heads/master/default-mappings.json"))

def merge():
    agda_map = get_agda_map()
    latex_map = get_latex_input_map()
    result = latex_map.copy()
    for k, v in untrie(agda_map, allow_conflicts=False):
        if k in result and v != result[k]:
            new_k = f"{k}'"
            print(f"Conflict: {k} -> {v} vs {result[k]} (aliasing former to {new_k})")
            result[new_k] = result[k]
        result[k] = v
    return result

def write_merged():
    with open("custom-latex-input.json", "w") as f:
        json.dump(merge(), f, indent=2)

def analyse_agda_map():
    from itertools import groupby
    fst = lambda x: x[0]
    snd = lambda x: x[1]
    d = list(untrie(get_agda_map(), allow_conflicts=True))
    rev = dict(groupby(d, snd))
    print("synonyms:")
    for sym, names in rev.items():
        names = list(names)
        if len(names) > 1:
            print(f"{sym}: {list(map(fst, names))}")
    got = set()
    conflict = set()
    for k, v in d:
        if k in got:
            conflict.add(k)
            print(f"conflict: {k}")
        got.add(k)
        print(f"got: {k} -> {v}")
    fine = got - conflict
    fine_map = {k: v for k, v in d if k in fine}
    all_vals = {v for k, v in d}
    fine_vals = {v for k, v in fine_map.items()}
    conflicted_vals  = all_vals - fine_vals
    print(f"conflicted values: {conflicted_vals}")
    return fine_map
