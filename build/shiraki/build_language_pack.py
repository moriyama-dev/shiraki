"""Rebrand the translations of a language pack .vsix and add its license.

usage: python3 -I build_language_pack.py <in.vsix> <out.vsix> <product-name> <keep.json> <license-file>

- "VS Code", "VSCode" and "Visual Studio Code" in the translations are replaced
  with <product-name>, except for the entries listed in <keep.json> (they refer
  to VS Code compatibility, the extension ecosystem or external services)
- <license-file> is added as extension/LICENSE.md
- Entries are written with fixed timestamps, so the output is reproducible
"""
import json
import re
import sys
import zipfile

src, dst, product_name, keep_path, license_path = sys.argv[1:6]

PATTERN = re.compile(r'Visual Studio Code|VS ?Code')
FIXED_DATE = (2026, 1, 1, 0, 0, 0)

with open(keep_path, encoding='utf-8') as f:
	keep = {(k['file'], k['module'], k['key']) for k in json.load(f)['keep']}

replaced = 0
kept = 0


def rebrand(file_name, data):
	global replaced, kept
	for module, entries in data.get('contents', {}).items():
		for key, value in entries.items():
			if not isinstance(value, str) or not PATTERN.search(value):
				continue
			if (file_name, module, key) in keep:
				kept += 1
				continue
			entries[key] = PATTERN.sub(product_name, value)
			replaced += 1
	return data


def entry(name, date_time=FIXED_DATE):
	info = zipfile.ZipInfo(name, date_time=date_time)
	info.compress_type = zipfile.ZIP_DEFLATED
	info.external_attr = 0o100644 << 16  # regular file, rw-r--r--
	return info


with zipfile.ZipFile(src) as zin, zipfile.ZipFile(dst, 'w', zipfile.ZIP_DEFLATED) as zout:
	names = zin.namelist()
	if 'extension/LICENSE.md' in names:
		sys.exit(f'extension/LICENSE.md already exists in {src}')
	for info in zin.infolist():
		content = zin.read(info.filename)
		if info.filename.startswith('extension/translations/') and info.filename.endswith('.json'):
			file_name = info.filename.rsplit('/', 1)[-1]
			data = rebrand(file_name, json.loads(content.decode('utf-8-sig')))
			content = json.dumps(data, ensure_ascii=False, indent='\t').encode('utf-8')
			zout.writestr(entry(info.filename, info.date_time), content)
		else:
			zout.writestr(info, content)
	with open(license_path, 'rb') as f:
		zout.writestr(entry('extension/LICENSE.md'), f.read())

if kept != len(keep):
	sys.exit(f'expected to keep {len(keep)} translations but kept {kept}; update {keep_path}')

print(f'language pack: replaced {replaced} translations, kept {kept}')
