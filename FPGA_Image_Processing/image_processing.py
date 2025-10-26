from PIL import Image

# Load the BMP image
img = Image.open("input.bmp")  # Make sure this is your BMP filename
img = img.convert("RGB")       # Ensure it is 24-bit RGB

width, height = img.size
pixels = list(img.getdata())

hex_data = []

# BMP images are written from last row to first row
for i in range(height-1, -1, -1):
    for j in range(width):
        r, g, b = pixels[i*width + j]
        hex_data.extend([r, g, b])

# Write the HEX file
with open("input.hex", "w") as f:
    for val in hex_data:
        f.write(f"{val:x}\n")  # write in hexadecimal

print("HEX file created successfully: input.hex")
