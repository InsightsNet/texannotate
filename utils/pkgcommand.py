import dataclasses
import json
from pathlib import Path
import subprocess

if not Path('utils/pyintel').exists():
    download('https://github.com/James-Yu/LaTeX-Workshop/tree/master/dev/pyintel', flatten=True, output_dir= './utils/pyintel')

from utils.gitdir import download
from utils.pyintel import CwlIntel

FILES_TO_IGNORE = ['diagxy.cwl', 'calculator.cwl', 'calculus.cwl', 'expl3.cwl']
FILES_TO_REMOVE_SPACES_IN = ['chemformula.cwl', 'context-document.cwl', 'class-beamer.cwl', 'csquotes.cwl', 'datatool.cwl', 'newclude.cwl', 'pgfplots.cwl', 'tabu.cwl', 'tikz.cwl']

CWD = Path(__file__).expanduser().resolve().parent
UNIMATHSYMBOLS = CWD.joinpath('../data/unimathsymbols.txt').resolve()
COMMANDS_FILE = CWD.joinpath('../data/commands.json').resolve()
ENVS_FILE = CWD.joinpath('../data/environments.json').resolve()
if not COMMANDS_FILE.exists():
    download('https://github.com/James-Yu/LaTeX-Workshop/tree/master/data', output_dir='./')

INFILES = Path('data/texstudio/completion')
if not INFILES.exists():
    subprocess.run(['sh', 'utils/get_cwl.sh'])
OUT_DIR = Path('data/packages').expanduser().resolve()
OUT_DIR.mkdir(exist_ok=True)

def dump_dict(dictionnary, out_json):
    if dictionnary != {}:
        json.dump(dictionnary, open(out_json, 'w', encoding='utf8'), indent=2, ensure_ascii=False)

def parse_cwl_files(cwl_files):
    cwlIntel = CwlIntel(COMMANDS_FILE, ENVS_FILE, UNIMATHSYMBOLS)
    for cwl_file in cwl_files:
        # Skip some files
        print(cwl_file)
        if cwl_file.name in FILES_TO_IGNORE:
            continue
        remove_spaces = False
        if cwl_file.name in FILES_TO_REMOVE_SPACES_IN:
            remove_spaces = True
        pkg = cwlIntel.parse_cwl_file(cwl_file, remove_spaces)
        json.dump(dataclasses.asdict(pkg, dict_factory=lambda x: {k: v for (k, v) in x if v is not None}),
                  open(OUT_DIR.joinpath(change_json_name(cwl_file.stem) + '.json'), 'w', encoding='utf8'), indent=2, ensure_ascii=False)

def change_json_name(file_stem):
    if (file_stem in ['yathesis']):
        return 'class-' + file_stem
    return file_stem

def run():
    cwl_files = list(INFILES.glob("*.cwl"))
    parse_cwl_files(cwl_files)