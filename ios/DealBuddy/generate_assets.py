#!/usr/bin/env python3
from PIL import Image, ImageDraw
import os
import json
import math

# Base path for assets
base_path = "/Users/ebuddycheung/.openclaw/workspace/bear-app-studio/ios/DealBuddy/Assets.xcassets/"

def ensure_imageset(name):
    """Ensure imageset directory exists"""
    path = base_path + name
    if not os.path.exists(path):
        os.makedirs(path)
    return path

def create_contents_json(imageset_name, filename):
    """Create Contents.json for an imageset"""
    contents = {
        "images": [
            {
                "filename": filename,
                "idiom": "universal"
            }
        ],
        "info": {
            "author": "xcode",
            "version": 1
        }
    }
    
    with open(base_path + imageset_name + "/Contents.json", 'w') as f:
        json.dump(contents, f, indent=2)

def create_app_icon():
    """Create app icon - 1024x1024 with tag icon"""
    ensure_imageset("AppIcon.appiconset")
    size = 1024
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Gradient background (orange)
    for y in range(size):
        ratio = y / size
        r = int(255 * (1 - ratio) + 247 * ratio)
        g = int(107 * (1 - ratio) + 147 * ratio)
        b = int(53 * (1 - ratio) + 30 * ratio)
        draw.line([(0, y), (size, y)], fill=(r, g, b))
    
    # Draw tag shape (white)
    center_x, center_y = size // 2, size // 2
    tag_width, tag_height = 500, 500
    
    # Tag polygon
    tag_points = [
        (center_x - tag_width//2, center_y - tag_height//2 + 80),
        (center_x + tag_width//2 - 80, center_y - tag_height//2),
        (center_x + tag_width//2, center_y),
        (center_x + tag_width//2, center_y + tag_height//2 - 80),
        (center_x + tag_width//2 - 80, center_y + tag_height//2),
        (center_x - tag_width//2, center_y + tag_height//2),
    ]
    draw.polygon(tag_points, fill=(255, 255, 255, 255))
    
    # Tag hole
    hole_radius = 60
    draw.ellipse([
        center_x - tag_width//2 + 40 - hole_radius,
        center_y - tag_height//2 + 40 - hole_radius,
        center_x - tag_width//2 + 40 + hole_radius,
        center_y - tag_height//2 + 40 + hole_radius
    ], fill=(255, 107, 53))
    
    # Save
    img.save(base_path + "AppIcon.appiconset/AppIcon.png")
    create_contents_json("AppIcon.appiconset", "AppIcon.png")
    print("✅ Created AppIcon.png")

def create_empty_state_image(imageset_name, filename, icon_type):
    """Create empty state image"""
    ensure_imageset(imageset_name)
    width, height = 400, 400
    img = Image.new('RGBA', (width, height), (255, 255, 255, 255))
    draw = ImageDraw.Draw(img)
    
    # Background circle
    circle_radius = 100
    draw.ellipse([
        width//2 - circle_radius,
        height//2 - 80 - circle_radius,
        width//2 + circle_radius,
        height//2 - 80 + circle_radius
    ], fill=(240, 240, 240, 255))
    
    # Draw icon
    cx, cy = width//2, height//2 - 80
    
    if icon_type == "tag":
        # Draw tag shape
        tag_w, tag_h = 80, 80
        points = [
            (cx - tag_w//2, cy - tag_h//2 + 15),
            (cx + tag_w//2 - 15, cy - tag_h//2),
            (cx + tag_w//2, cy),
            (cx + tag_w//2, cy + tag_h//2 - 15),
            (cx + tag_w//2 - 15, cy + tag_h//2),
            (cx - tag_w//2, cy + tag_h//2),
        ]
        draw.polygon(points, fill=(180, 180, 180, 255))
    elif icon_type == "person":
        # Draw person shape
        head_radius = 20
        draw.ellipse([cx - head_radius, cy - 35 - head_radius, cx + head_radius, cy - 35 + head_radius], fill=(180, 180, 180, 255))
        draw.ellipse([cx - 35, cy, cx + 35, cy + 40], fill=(180, 180, 180, 255))
    
    img.save(base_path + imageset_name + "/" + filename)
    create_contents_json(imageset_name, filename)
    print(f"✅ Created {filename}")

def create_onboarding_image(imageset_name, filename, icon_type, color1, color2):
    """Create onboarding illustration"""
    ensure_imageset(imageset_name)
    width, height = 400, 500
    img = Image.new('RGBA', (width, height), (255, 255, 255, 255))
    draw = ImageDraw.Draw(img)
    
    # Gradient rounded rect
    rect_size = 180
    x1 = width//2 - rect_size//2
    y1 = 80
    x2 = width//2 + rect_size//2
    y2 = y1 + rect_size
    
    for i in range(rect_size):
        ratio = i / rect_size
        r = int(color1[0] * (1 - ratio) + color2[0] * ratio)
        g = int(color1[1] * (1 - ratio) + color2[1] * ratio)
        b = int(color1[2] * (1 - ratio) + color2[2] * ratio)
        y = y1 + i
        draw.line([(x1, y), (x2, y)], fill=(r, g, b))
    
    # Icon circle
    circle_r = 60
    cx, cy = width//2, y1 + rect_size//2
    draw.ellipse([cx - circle_r, cy - circle_r, cx + circle_r, cy + circle_r], fill=(255, 255, 255, 255))
    
    # Draw specific icon
    if icon_type == "magnifying":
        draw.ellipse([cx - 25, cy - 25, cx + 25, cy + 25], outline=(color1[0], color1[1], color1[2]), width=6)
        draw.line([(cx + 18, cy + 18), (cx + 35, cy + 35)], fill=(color1[0], color1[1], color1[2]), width=6)
    elif icon_type == "person":
        draw.ellipse([cx - 40 - 15, cy - 20, cx - 40 + 15, cy + 10], fill=(color1[0], color1[1], color1[2]))
        draw.ellipse([cx + 40 - 15, cy - 20, cx + 40 + 15, cy + 10], fill=(color1[0], color1[1], color1[2]))
        draw.ellipse([cx - 40 - 20, cy + 15, cx - 40 + 20, cy + 45], fill=(color1[0], color1[1], color1[2]))
        draw.ellipse([cx + 40 - 20, cy + 15, cx + 40 + 20, cy + 45], fill=(color1[0], color1[1], color1[2]))
    elif icon_type == "dollar":
        draw.ellipse([cx - 20, cy - 30, cx + 20, cy + 30], outline=(color1[0], color1[1], color1[2]), width=5)
        draw.line([(cx, cy - 35), (cx, cy + 35)], fill=(color1[0], color1[1], color1[2]), width=5)
    
    img.save(base_path + imageset_name + "/" + filename)
    create_contents_json(imageset_name, filename)
    print(f"✅ Created {filename}")

def create_premium_badge():
    """Create premium badge - golden star"""
    ensure_imageset("PremiumBadge.imageset")
    size = 120
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Gold gradient circle
    cx, cy = size//2, size//2
    radius = 50
    
    for i in range(radius):
        ratio = i / radius
        r = int(255)
        g = int(215 * (1 - ratio) + 165 * ratio)
        b = 0
        draw.ellipse([
            cx - radius + i,
            cy - radius + i,
            cx + radius - i,
            cy + radius - i
        ], fill=(r, g, b))
    
    # Star shape
    star_points = []
    for i in range(5):
        angle = i * 72 - 90
        rad = math.radians(angle)
        x = cx + 30 * math.cos(rad)
        y = cy + 30 * math.sin(rad)
        star_points.append((x, y))
        
        angle2 = i * 72 - 90 + 36
        rad2 = math.radians(angle2)
        x2 = cx + 12 * math.cos(rad2)
        y2 = cy + 12 * math.sin(rad2)
        star_points.append((x2, y2))
    
    draw.polygon(star_points, fill=(255, 255, 255, 255))
    
    img.save(base_path + "PremiumBadge.imageset/PremiumBadge.png")
    create_contents_json("PremiumBadge.imageset", "PremiumBadge.png")
    print("✅ Created PremiumBadge.png")

def create_deal_placeholder():
    """Create deal placeholder image"""
    ensure_imageset("DealPlaceholder.imageset")
    width, height = 300, 200
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Gray gradient background
    for i in range(height):
        gray = int(220 * (1 - i/height) + 200 * (i/height))
        draw.line([(0, i), (width, i)], fill=(gray, gray, gray))
    
    # Rounded corners mask
    corner_radius = 16
    mask = Image.new('L', (width, height), 0)
    mask_draw = ImageDraw.Draw(mask)
    mask_draw.rounded_rectangle([0, 0, width, height], radius=corner_radius, fill=255)
    img.putalpha(mask)
    
    # Photo icon
    cx, cy = width//2, height//2 - 10
    draw.ellipse([cx - 25, cy - 20, cx + 25, cy + 20], outline=(150, 150, 150), width=3)
    draw.line([(cx - 18, cy + 8), (cx - 8, cy - 5)], fill=(150, 150, 150), width=2)
    draw.line([(cx + 18, cy + 8), (cx + 8, cy - 5)], fill=(150, 150, 150), width=2)
    
    # Three dots for "No Image"
    for i in range(3):
        x = cx - 12 + i * 12
        y = cy + 30
        draw.ellipse([x, y, x+3, y+3], fill=(180, 180, 180))
    
    img.save(base_path + "DealPlaceholder.imageset/DealPlaceholder.png")
    create_contents_json("DealPlaceholder.imageset", "DealPlaceholder.png")
    print("✅ Created DealPlaceholder.png")

# Generate all assets
print("🎨 Generating DealBuddy image assets...\n")

create_app_icon()

# Empty States
create_empty_state_image("EmptyDeals.imageset", "EmptyDeals.png", "tag")
create_empty_state_image("EmptyFriends.imageset", "EmptyFriends.png", "person")

# Onboarding
create_onboarding_image("Onboarding1.imageset", "Onboarding1.png", "magnifying", (255, 107, 53), (247, 147, 30))
create_onboarding_image("Onboarding2.imageset", "Onboarding2.png", "person", (78, 205, 196), (68, 160, 141))
create_onboarding_image("Onboarding3.imageset", "Onboarding3.png", "dollar", (102, 126, 234), (118, 75, 162))

# Premium & Placeholder
create_premium_badge()
create_deal_placeholder()

print("\n✨ All image assets generated successfully!")
