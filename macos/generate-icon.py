#!/usr/bin/env python3
import os
from PIL import Image, ImageDraw, ImageFont
import math

def create_icon():
    """Create a simple PromptForge icon"""
    
    # Icon sizes needed for macOS
    sizes = [16, 32, 64, 128, 256, 512, 1024]
    
    for size in sizes:
        # Create image with transparency
        img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
        draw = ImageDraw.Draw(img)
        
        # Color scheme - modern blue gradient
        color1 = (66, 133, 244)  # Blue
        color2 = (147, 90, 255)  # Purple
        
        # Draw rounded square background (squircle effect)
        padding = size * 0.05
        corner_radius = size * 0.23  # iOS-style rounded corners
        
        # Draw gradient background
        for y in range(int(padding), int(size - padding)):
            ratio = (y - padding) / (size - 2 * padding)
            r = int(color1[0] * (1 - ratio) + color2[0] * ratio)
            g = int(color1[1] * (1 - ratio) + color2[1] * ratio)
            b = int(color1[2] * (1 - ratio) + color2[2] * ratio)
            draw.rectangle(
                [padding, y, size - padding, y + 1],
                fill=(r, g, b, 255)
            )
        
        # Draw document/prompt icon in white
        icon_padding = size * 0.25
        doc_width = size - (icon_padding * 2)
        doc_height = doc_width * 1.2
        doc_x = icon_padding
        doc_y = (size - doc_height) / 2
        
        # Draw document shape
        draw.rounded_rectangle(
            [doc_x, doc_y, doc_x + doc_width, doc_y + doc_height],
            radius=size * 0.08,
            fill=(255, 255, 255, 230)
        )
        
        # Draw lines to represent text
        line_spacing = doc_height / 6
        line_y = doc_y + line_spacing
        line_left = doc_x + doc_width * 0.15
        line_right = doc_x + doc_width * 0.85
        line_width = max(2, int(size * 0.04))
        
        for i in range(3):
            draw.rounded_rectangle(
                [line_left, line_y, line_right, line_y + line_width],
                radius=line_width/2,
                fill=(66, 133, 244, 200)
            )
            line_y += line_spacing
        
        # Save with appropriate naming
        if size <= 32:
            img.save(f'icon_{size}x{size}.png')
        else:
            img.save(f'icon_{size}x{size}@2x.png')
    
    print("✅ Icon files created successfully!")
    print("Icons created: 16x16, 32x32, 64x64, 128x128, 256x256, 512x512, 1024x1024")

if __name__ == "__main__":
    create_icon()
