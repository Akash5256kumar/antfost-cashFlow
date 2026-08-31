from PIL import Image

img = Image.open('flutter_02.png')
pixels = img.load()
width, height = img.size

left_x = 120
right_x = 350

cubes = []
in_cube = False
start_y = 0

for y in range(height):
    is_non_white_row = False
    for x in range(left_x, right_x):
        r, g, b = pixels[x, y][:3]
        if r < 240 or g < 240 or b < 240:
            is_non_white_row = True
            break
            
    if is_non_white_row and not in_cube:
        in_cube = True
        start_y = y
    elif not is_non_white_row and in_cube:
        in_cube = False
        if y - start_y > 100:
            cubes.append( (left_x, start_y, right_x, y) )

import os
os.makedirs('assets/images', exist_ok=True)
saved = []
for i, (x1, y1, x2, y2) in enumerate(cubes[:3]):
    pad = 30
    crop = img.crop((max(0, x1-pad), max(0, y1-pad), min(width, x2+pad), min(height, y2+pad)))
    filename = f'assets/images/figma_mix_crop_{i}.png'
    crop.save(filename)
    saved.append(filename)

print("Saved:", saved)
