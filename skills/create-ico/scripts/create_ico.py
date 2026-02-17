"""Convert an image (PNG, JPG, SVG, etc.) to a multi-size ICO file."""

import argparse
import sys
from pathlib import Path

try:
    from PIL import Image
except ImportError:
    print("Pillow is required: pip install Pillow", file=sys.stderr)
    sys.exit(1)

DEFAULT_SIZES = [16, 32, 48, 64, 128, 256]


def create_ico(source: str, output: str | None, sizes: list[int]) -> None:
    src = Path(source)
    if not src.exists():
        print(f"Source file not found: {src}", file=sys.stderr)
        sys.exit(1)

    out = Path(output) if output else src.with_suffix(".ico")
    img = Image.open(src)

    if img.mode != "RGBA":
        img = img.convert("RGBA")

    ico_sizes = [(s, s) for s in sizes]
    img.save(str(out), format="ICO", sizes=ico_sizes)
    print(f"Created {out} with sizes: {', '.join(f'{s}x{s}' for s in sizes)}")


def main() -> None:
    parser = argparse.ArgumentParser(description="Convert image to ICO")
    parser.add_argument("source", help="Source image file (PNG, JPG, etc.)")
    parser.add_argument("-o", "--output", help="Output ICO path (default: same name with .ico)")
    parser.add_argument(
        "-s", "--sizes",
        help=f"Comma-separated icon sizes (default: {','.join(map(str, DEFAULT_SIZES))})",
    )
    args = parser.parse_args()

    sizes = [int(s) for s in args.sizes.split(",")] if args.sizes else DEFAULT_SIZES
    create_ico(args.source, args.output, sizes)


if __name__ == "__main__":
    main()
