from PIL import Image
import sys
import os


def img_to_hex(filename):
    im = Image.open(filename)
    w, h = im.size
    pix = im.load()

    output = ""

    for y in range(h):
        for x in range(w):
            r, g, b, a = pix[x, y]  # Get RGBA values
            color = ((r >> 3) << 11) | ((g >> 2) << 5) | (b >> 3)
            output += "0x{:04x}, ".format(color)
        output += "\n"

    return output


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python imgtohex.py <filename>")
        sys.exit(1)

    filename = sys.argv[1]
    output = img_to_hex(filename)

    base = os.path.splitext(filename)[0]
    with open(base + ".txt", "w") as f:
        f.write(output)
