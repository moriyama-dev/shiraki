"""Copy a .vsix and add one file to it.

usage: python3 -I add_file_to_vsix.py <in.vsix> <out.vsix> <file> <path-inside-vsix>

The entries of the input are copied as-is and the new file gets a fixed
timestamp, so the output is reproducible for a given input.
"""
import sys
import zipfile

src, dst, file_path, arcname = sys.argv[1:5]

with zipfile.ZipFile(src) as zin, zipfile.ZipFile(dst, 'w', zipfile.ZIP_DEFLATED) as zout:
	if arcname in zin.namelist():
		sys.exit(f'{arcname} already exists in {src}')
	for info in zin.infolist():
		zout.writestr(info, zin.read(info.filename))
	new = zipfile.ZipInfo(arcname, date_time=(2026, 1, 1, 0, 0, 0))
	new.compress_type = zipfile.ZIP_DEFLATED
	new.external_attr = 0o100644 << 16  # regular file, rw-r--r--
	with open(file_path, 'rb') as f:
		zout.writestr(new, f.read())
