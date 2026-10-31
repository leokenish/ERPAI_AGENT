"""Build a local calculation copy; never writes exports or SAP objects.

The executable report prefix is maintained in ZRPTH411_COMPARE.abap.
Only the region after the generated marker is replaced. Source statements
for the current (execution date >= 2022-04-01) B/C paths are retained;
input/attendance/rate reads become supplied snapshots. No original FM call.
"""
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[3]
OUT = Path(__file__).resolve().parents[1]
BASE = ROOT / 'exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3'
MARKER = '* === GENERATED SNAPSHOT CALCULATION; SEE tools/build_core.py ==='


def clean(text):
    result = []
    for line in text.splitlines():
        if line.lstrip().startswith('*'):
            continue
        # ABAP inline comments, respecting quoted literals / escaped quotes.
        in_string = False
        i = 0
        while i < len(line):
            if line[i] == "'":
                if in_string and i + 1 < len(line) and line[i + 1] == "'":
                    i += 2
                    continue
                in_string = not in_string
            if line[i] == '"' and not in_string:
                line = line[:i]
                break
            i += 1
        line = line.rstrip().replace('\t', ' ')
        if line.strip():
            result.append(line)
    return '\n'.join(result) + '\n'


def replace_if(text, start_pattern, keep_else):
    lines = text.splitlines()
    while True:
        start = next((i for i, s in enumerate(lines)
                      if re.match(start_pattern, s.strip(), re.I)), None)
        if start is None:
            return '\n'.join(lines) + '\n'
        level, alt, end = 0, None, None
        for i in range(start, len(lines)):
            s = lines[i].strip().upper()
            if re.match(r'^IF\b', s):
                level += 1
            elif re.match(r'^ENDIF\b', s):
                level -= 1
                if level == 0:
                    end = i
                    break
            elif re.match(r'^ELSE\.', s) and level == 1:
                alt = i
        assert end is not None
        kept = lines[alt + 1:end] if keep_else and alt is not None else []
        lines[start:end + 1] = kept


def build(check=False):
    path = BASE / 'Function Module/ZHR_52TM_CW_CAL_AND_DAEH/Source code/ZHR_52TM_CW_CAL_AND_DAEH.abap'
    s = clean(path.read_text())
    s = s[s.index('  DATA:'):]
    # Explicitly retain only the current algorithm, not sy-datum-dependent replay.
    s = replace_if(s, r"IF sy-datum < '20220401'\.", True)
    s = re.sub(r'  CLEAR: lt_zthr0113\[\].*?  ENDCASE\.',
               '  CLEAR: lt_zthr0113[], lt_daeh[], lt_save[].', s,
               count=1, flags=re.S)
    start = s.index("      WHEN 'D'.")
    end = s.rindex('    ENDCASE.')
    s = s[:start] + s[end:]
    s = replace_if(s, r"IF i_case = 'A'\.", False)
    s = replace_if(s, r"IF i_case = 'D'\.", False)
    s, count = re.subn(r'    SELECT \*\s+INTO CORRESPONDING FIELDS OF TABLE lt_zthr0112\s+FROM zthr0112.*?AND state IN gr_state\.',
                      '    lt_zthr0112[] = it_work[].', s, flags=re.S)
    assert count == 1
    # Both whole-period AWART calls use the same loaded input.
    s, count = re.subn(r"CALL FUNCTION 'ZHR_52TM_AWART_LIST'\s+EXPORTING\s+i_pernr\s*= lt_zthr0132-pernr.*?t_data\s*= lt_zshr0111\.",
                      'lt_zshr0111[] = it_awart[].', s, flags=re.S | re.I)
    assert count == 2
    s, count = re.subn(r"CALL FUNCTION 'ZHR_52TM_AWART_LIST'\s+EXPORTING\s+I_PERNR\s*=\s*lt_zthr0112-pernr.*?T_DATA\s*=\s*lt_data\.",
                      '''CLEAR lt_data[].
                LOOP AT it_awart WHERE datum = lt_zthr0112-datum.
                  APPEND it_awart TO lt_data.
                ENDLOOP.''', s, flags=re.S | re.I)
    assert count == 1
    s, count = re.subn(r'PERFORM g_cw_get_data USING lt_zthr0132-pernr\s+ls_zshr0141\s+CHANGING ls_zshr0143\s+ls_return\.',
                      'ls_zshr0143 = is_rate.', s, flags=re.S | re.I)
    assert count == 1
    s = s.replace("WHEN 'A' OR 'B'.", "WHEN 'B'.")
    s = s.replace('ENDFUNCTION.', 'ENDFORM.')
    s = s.replace('wa_zthrbs05 TYPE zthrbs05,\n        wa_zthrcost TYPE zthrcost.',
                  'lv_unused TYPE c.')
    header = '''FORM rc_calculate
  TABLES lt_zthr0132 STRUCTURE zthr0132
         it_work STRUCTURE zshr0145
         it_awart STRUCTURE zshr0111
         lt_zthr0113 STRUCTURE zthr0113
         lt_daeh STRUCTURE zshr0146
         lt_save STRUCTURE zshr0145
  USING i_case TYPE c
        is_rate TYPE zshr0143.
* Work and AWART input are read-only snapshots. Calls below are calculation
* helpers; calendar/time configuration still comes from the local SAP system.
'''
    helpers = clean((BASE / 'Include/LZHR008_3F04.abap').read_text())
    helpers = helpers[helpers.index('FORM make_daeh_data'):]
    helpers = helpers[:helpers.index('ENDFORM.') + len('ENDFORM.')]
    # Remove two duplicated statement terminators in the exported source copy.
    helpers = re.sub(r'\.\.(\s|$)', r'.\1', helpers)
    conversions = clean((BASE / 'Include/LZHR008_3F02.abap').read_text())
    conversions = conversions[conversions.index('FORM convert_time_to_min'):conversions.index('FORM d_cw_get_data')]
    generated = header + s + '\n' + helpers + '\n' + conversions
    assert not re.search(r'\bFROM\s+zthr0112\b|ZHR_52TM_AWART_LIST|g_cw_get_data|IF\s+sy-datum', generated, re.I)
    assert not re.search(r"CALL FUNCTION 'ZHR_52TM_CW_CAL_AND_DAEH'", generated, re.I)
    report = OUT / 'ZRPTH411_COMPARE.abap'
    prefix = report.read_text().split(MARKER)[0]
    expected = prefix.rstrip() + '\n\n' + MARKER + '\n' + generated
    if check:
        assert report.read_text() == expected, 'Generated core differs; review before rebuilding'
    else:
        report.write_text(expected)
    print('Generated calculation lines:', len(generated.splitlines()))


if __name__ == '__main__':
    build(check='--check' in sys.argv)
