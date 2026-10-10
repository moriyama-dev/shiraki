"""Generate Shiraki placeholder icons (plain wood-tone rounded square) with stdlib only."""
import struct
import sys
import zlib
from pathlib import Path

FILL = (0xE9, 0xD8, 0xB4)    # shiraki (plain wood)
BORDER = (0xC9, 0xAE, 0x7E)  # slightly darker wood edge
MARGIN = 0.06                # fraction of size left transparent around the square
RADIUS = 0.18                # corner radius, fraction of size
BORDER_W = 0.025             # border width, fraction of size
SS = 4                       # supersampling for anti-aliasing


def inside_rrect(x, y, x0, y0, x1, y1, r):
	if x < x0 or x > x1 or y < y0 or y > y1:
		return False
	cx = min(max(x, x0 + r), x1 - r)
	cy = min(max(y, y0 + r), y1 - r)
	return (x - cx) ** 2 + (y - cy) ** 2 <= r * r


def render(size):
	m, r, b = MARGIN * size, RADIUS * size, BORDER_W * size
	outer = (m, m, size - m, size - m, r)
	inner = (m + b, m + b, size - m - b, size - m - b, max(r - b, 0))
	rows = []
	for py in range(size):
		row = bytearray()
		for px in range(size):
			n_out = n_in = 0
			for sy in range(SS):
				for sx in range(SS):
					x = px + (sx + 0.5) / SS
					y = py + (sy + 0.5) / SS
					if inside_rrect(x, y, *outer):
						n_out += 1
						if inside_rrect(x, y, *inner):
							n_in += 1
			if n_out == 0:
				row += bytes((0, 0, 0, 0))
				continue
			t = n_in / n_out
			rgb = tuple(round(BORDER[i] * (1 - t) + FILL[i] * t) for i in range(3))
			row += bytes((*rgb, round(255 * n_out / (SS * SS))))
		rows.append(bytes(row))
	return rows


def png_bytes(rows, size):
	def chunk(tag, data):
		c = tag + data
		return struct.pack(">I", len(data)) + c + struct.pack(">I", zlib.crc32(c) & 0xFFFFFFFF)
	raw = b"".join(b"\x00" + r for r in rows)
	return (b"\x89PNG\r\n\x1a\n"
		+ chunk(b"IHDR", struct.pack(">IIBBBBB", size, size, 8, 6, 0, 0, 0))
		+ chunk(b"IDAT", zlib.compress(raw, 9))
		+ chunk(b"IEND", b""))


def ico_bytes(images):
	header = struct.pack("<HHH", 0, 1, len(images))
	offset = 6 + 16 * len(images)
	entries, blobs = b"", b""
	for size, data in images:
		dim = 0 if size >= 256 else size
		entries += struct.pack("<BBBBHHII", dim, dim, 0, 0, 1, 32, len(data), offset)
		offset += len(data)
		blobs += data
	return header + entries + blobs


def xpm_text(rows, size, name="code"):
	palette, pixels = {}, []
	for r in rows:
		line = []
		for i in range(0, len(r), 4):
			px = r[i:i + 4]
			key = "None" if px[3] < 128 else "#%02X%02X%02X" % tuple(px[:3])
			if key not in palette:
				palette[key] = len(palette)
			line.append(palette[key])
		pixels.append(line)
	chars = "".join(chr(c) for c in range(35, 127) if chr(c) not in '"\\')
	def code(i):
		return chars[i // len(chars)] + chars[i % len(chars)]
	out = ["/* XPM */", f"static char *{name}[] = {{", "/* columns rows colors chars-per-pixel */",
		f'"{size} {size} {len(palette)} 2 ",']
	for key, i in palette.items():
		out.append(f'"{code(i)} c {key}",')
	out.append("/* pixels */")
	for j, line in enumerate(pixels):
		end = "" if j == len(pixels) - 1 else ","
		out.append('"' + "".join(code(i) for i in line) + '"' + end)
	out.append("};")
	return "\n".join(out) + "\n"


def svg_icon(px):
	m, s, r, b = MARGIN * 100, 100 - 2 * MARGIN * 100, RADIUS * 100, BORDER_W * 100
	return f'''<?xml version="1.0" encoding="UTF-8"?>
<svg version="1.1" xmlns="http://www.w3.org/2000/svg" width="{px}" height="{px}" viewBox="0 0 100 100">
  <rect x="{m + b / 2:g}" y="{m + b / 2:g}" width="{s - b:g}" height="{s - b:g}" rx="{r - b / 2:g}" fill="#E9D8B4" stroke="#C9AE7E" stroke-width="{b:g}"/>
</svg>
'''


def svg_letterpress(fill, opacity):
	op = f' fill-opacity="{opacity}"' if opacity else ""
	return f'''<?xml version="1.0" encoding="UTF-8"?>
<svg version="1.1" xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 40 40">
  <rect x="4" y="4" width="32" height="32" rx="7" fill="{fill}"{op}/>
</svg>
'''


def main(root):
	root = Path(root)
	res = root / "resources"
	media = root / "src/vs/workbench/browser"
	cache = {}
	def png(size):
		if size not in cache:
			rows = render(size)
			cache[size] = (rows, png_bytes(rows, size))
		return cache[size]

	(res / "linux/code.png").write_bytes(png(1024)[1])
	(res / "server/code-192.png").write_bytes(png(192)[1])
	(res / "server/code-512.png").write_bytes(png(512)[1])
	(res / "server/favicon.ico").write_bytes(ico_bytes([(s, png(s)[1]) for s in (16, 24, 32, 48, 64, 128, 256)]))
	(res / "linux/rpm/code.xpm").write_text(xpm_text(png(256)[0], 256))
	(res / "linux/code.svg").write_text(svg_icon(1024))
	(media / "media/code-icon.svg").write_text(svg_icon(1024))
	lp = media / "parts/editor/media"
	(lp / "letterpress-dark.svg").write_text(svg_letterpress("#B2B2B2", "0.3"))
	(lp / "letterpress-light.svg").write_text(svg_letterpress("#B2B2B2", "0.1"))
	(lp / "letterpress-hcDark.svg").write_text(svg_letterpress("#3C3C3C", None))
	(lp / "letterpress-hcLight.svg").write_text(svg_letterpress("#B2B2B2", None))
	print("done")


if __name__ == "__main__":
	main(sys.argv[1])
