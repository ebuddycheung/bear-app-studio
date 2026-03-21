#!/usr/bin/env python3
"""
DealBuddy iOS Asset Generator
Generates PNG assets for the iOS app using PIL
"""

import os
import math
from PIL import Image, ImageDraw, ImageFont

# Colors (as hex)
COLORS = {
    'orange': '#FF8C42',
    'orange_dark': '#FF6B35',
    'teal': '#4ECDC4',
    'blue': '#6A9BCC',
    'green': '#788C5D',
    'gold': '#FFD700',
    'gold_dark': '#FFA500',
    'warm_soft': '#FFE5D9',
    'warm_light': '#FFF5F0',
    'warm_medium': '#FFE8E0',
    'blue_light': '#F0F9FF',
    'blue_medium': '#E0F2FE',
    'green_light': '#F0FFF4',
    'green_medium': '#DCFCE7',
    'gray_light': '#F5F5F5',
    'gray_medium': '#EEEEEE',
    'gray_dark': '#B0AEA5',
    'gray_text': '#8A8A8A',
    'text_dark': '#141413',
    'text_medium': '#6B6B6B',
    'white': '#FFFFFF',
}

def hex_to_rgb(hex_color):
    hex_color = hex_color.lstrip('#')
    return tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))

def create_gradient_background(draw, size, color1, color2, direction='linear'):
    """Create a gradient background"""
    width, height = size
    r1, g1, b1 = hex_to_rgb(color1)
    r2, g2, b2 = hex_to_rgb(color2)
    
    for y in range(height):
        ratio = y / height
        r = int(r1 + (r2 - r1) * ratio)
        g = int(g1 + (g2 - g1) * ratio)
        b = int(b1 + (b2 - b1) * ratio)
        draw.line([(0, y), (width, y)], fill=(r, g, b))

def draw_circle_with_shadow(draw, center, radius, fill_color, shadow_offset=(0, 10)):
    """Draw a circle with a soft shadow"""
    cx, cy = center
    
    # Shadow
    shadow_color = (0, 0, 0, 25)
    draw.ellipse([cx - radius + shadow_offset[0], cy - radius + shadow_offset[1],
                  cx + radius + shadow_offset[0], cy + radius + shadow_offset[1]],
                 fill=shadow_color)
    
    # Circle
    draw.ellipse([cx - radius, cy - radius, cx + radius, cy + radius], fill=fill_color)

def draw_rounded_rect(draw, bbox, radius, fill_color):
    """Draw a rounded rectangle"""
    x1, y1, x2, y2 = bbox
    draw.rounded_rectangle([bbox], radius=radius, fill=fill_color)

def draw_text_centered(draw, text, center, font, fill_color):
    """Draw text centered at a point"""
    bbox = draw.textbbox((0, 0), text, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]
    x = center[0] - text_width // 2
    y = center[1] - text_height // 2
    draw.text((x, y), text, font=font, fill=fill_color)

# ============ APP ICON (1024x1024) ============
def create_app_icon():
    size = (1024, 1024)
    img = Image.new('RGBA', size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Gradient background
    width, height = size
    for y in range(height):
        ratio = y / height
        r = int(255 + (255 - 255) * ratio)
        g = int(140 + (107 - 140) * ratio)
        b = int(66 + (53 - 66) * ratio)
        draw.line([(0, y), (width, y)], fill=(r, g, b))
    
    # Bag handle
    handle_bbox = [472, 200, 552, 260]
    draw.rounded_rectangle(handle_bbox, radius=30, fill=(255, 255, 255, 230))
    draw.rounded_rectangle(handle_bbox, radius=30, outline=(255, 255, 255, 76), width=3)
    
    # Bag body
    bag_bbox = [442, 260, 582, 440]
    draw.rounded_rectangle(bag_bbox, radius=25, fill=COLORS['white'])
    
    # Tag icon
    tag_color = hex_to_rgb(COLORS['orange'])
    # Draw tag shape (simplified as circle with tag)
    draw.ellipse([487, 320, 537, 370], fill=tag_color)
    
    # Percentage text
    try:
        font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 80)
    except:
        font = ImageFont.load_default()
    
    draw.text((440, 340), "50%", fill=hex_to_rgb(COLORS['teal']))
    
    # Star sparkle
    star_color = (255, 255, 255, 204)
    draw.ellipse([80, 80, 120, 120], fill=star_color)
    
    return img

# ============ EMPTY DEALS (400x400) ============
def create_empty_deals():
    size = (400, 400)
    img = Image.new('RGBA', size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Background gradient
    create_gradient_background(draw, size, COLORS['warm_light'], COLORS['warm_medium'])
    
    # Circle with shadow
    draw_circle_with_shadow(draw, (200, 150), 90, COLORS['white'])
    
    # Shopping bag icon (simple representation)
    bag_color = hex_to_rgb(COLORS['gray_dark'])
    draw.rounded_rectangle([170, 120, 230, 200], radius=15, fill=bag_color)
    
    # Question mark
    q_color = hex_to_rgb(COLORS['orange'])
    try:
        font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 50)
    except:
        font = ImageFont.load_default()
    draw.text((240, 110), "?", font=font, fill=q_color)
    
    # Title
    try:
        title_font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 32)
        body_font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 18)
    except:
        title_font = ImageFont.load_default()
        body_font = ImageFont.load_default()
    
    draw.text((100, 260), "No Deals Yet", font=title_font, fill=hex_to_rgb(COLORS['text_dark']))
    draw.text((110, 310), "Start saving by adding", font=body_font, fill=hex_to_rgb(COLORS['text_medium']))
    draw.text((130, 330), "your first deal!", font=body_font, fill=hex_to_rgb(COLORS['text_medium']))
    
    # Decorative elements
    draw.ellipse([50, 50, 80, 80], fill=hex_to_rgb(COLORS['orange']) + (76,))
    draw.ellipse([320, 80, 360, 120], fill=hex_to_rgb(COLORS['orange']) + (51,))
    
    return img

# ============ EMPTY FRIENDS (400x400) ============
def create_empty_friends():
    size = (400, 400)
    img = Image.new('RGBA', size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Background gradient
    create_gradient_background(draw, size, COLORS['blue_light'], COLORS['blue_medium'])
    
    # Circle with shadow
    draw_circle_with_shadow(draw, (200, 150), 90, COLORS['white'])
    
    # Person icons (simple circles)
    person_color = hex_to_rgb(COLORS['blue'])
    draw.ellipse([160, 130, 190, 170], fill=person_color)  # Left person
    draw.ellipse([185, 125, 225, 175], fill=hex_to_rgb(COLORS['teal']))  # Middle person
    draw.ellipse([215, 130, 245, 170], fill=hex_to_rgb(COLORS['orange']))  # Right person
    
    # Plus circle
    plus_color = hex_to_rgb(COLORS['teal'])
    draw.ellipse([230, 170, 270, 210], fill=plus_color)
    draw.text((243, 178), "+", fill=COLORS['white'])
    
    # Title
    try:
        title_font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 32)
        body_font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 18)
    except:
        title_font = ImageFont.load_default()
        body_font = ImageFont.load_default()
    
    draw.text((100, 260), "No Friends Yet", font=title_font, fill=hex_to_rgb(COLORS['text_dark']))
    draw.text((110, 310), "Invite friends to share", font=body_font, fill=hex_to_rgb(COLORS['text_medium']))
    draw.text((140, 330), "deals together!", font=body_font, fill=hex_to_rgb(COLORS['text_medium']))
    
    # Decorative elements
    draw.ellipse([50, 50, 80, 80], fill=hex_to_rgb(COLORS['blue']) + (76,))
    draw.ellipse([320, 80, 360, 120], fill=hex_to_rgb(COLORS['blue']) + (51,))
    
    return img

# ============ DEAL PLACEHOLDER (400x400) ============
def create_deal_placeholder():
    size = (400, 400)
    img = Image.new('RGBA', size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Background gradient
    create_gradient_background(draw, size, COLORS['gray_light'], COLORS['gray_medium'])
    
    # Photo icon
    icon_color = hex_to_rgb(COLORS['gray_dark'])
    try:
        icon_font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 60)
        text_font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 18)
    except:
        icon_font = ImageFont.load_default()
        text_font = ImageFont.load_default()
    
    # Mountain/photo icon representation
    draw.polygon([(120, 280), (200, 180), (280, 280)], fill=icon_color)
    draw.ellipse([220, 200, 260, 240], fill=(255, 255, 255, 200))
    
    # Text
    draw.text((145, 310), "No Photo", font=text_font, fill=hex_to_rgb(COLORS['gray_text']))
    
    return img

# ============ PREMIUM BADGE (200x200) ============
def create_premium_badge():
    size = (200, 200)
    img = Image.new('RGBA', size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Gold gradient background
    width, height = size
    for y in range(height):
        ratio = y / height
        r = int(255 + (255 - 255) * ratio)
        g = int(215 + (165 - 215) * ratio)
        b = int(0 + (0 - 0) * ratio)
        draw.line([(0, y), (width, y)], fill=(r, g, b))
    
    # Crown icon (simplified)
    crown_color = COLORS['white']
    # Crown base
    draw.polygon([(50, 130), (150, 130), (150, 100), (125, 110), (100, 80), (75, 110), (50, 100)], fill=crown_color)
    
    # Sparkles
    draw.ellipse([30, 30, 50, 50], fill=(255, 255, 255, 230))
    draw.ellipse([150, 150, 180, 180], fill=(255, 255, 255, 200))
    
    return img

# ============ ONBOARDING 1: Find Deals (400x400) ============
def create_onboarding1():
    size = (400, 400)
    img = Image.new('RGBA', size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Background gradient
    create_gradient_background(draw, size, '#FFF8F0', '#FFE4D6')
    
    # Circle with shadow
    draw_circle_with_shadow(draw, (200, 150), 100, COLORS['white'])
    
    # Tag icon
    tag_color = hex_to_rgb(COLORS['orange'])
    draw.ellipse([165, 120, 235, 190], fill=tag_color)
    
    # Magnifying glass
    mag_color = hex_to_rgb(COLORS['teal'])
    draw.ellipse([220, 90, 270, 140], outline=mag_color, width=8)
    draw.line([260, 130, 290, 160], fill=mag_color, width=8)
    
    # Title
    try:
        title_font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 28)
        body_font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 16)
    except:
        title_font = ImageFont.load_default()
        body_font = ImageFont.load_default()
    
    draw.text((60, 265), "Find Amazing Deals", font=title_font, fill=hex_to_rgb(COLORS['text_dark']))
    draw.text((65, 310), "Discover the best discounts", font=body_font, fill=hex_to_rgb(COLORS['text_medium']))
    draw.text((95, 330), "from your favorite stores", font=body_font, fill=hex_to_rgb(COLORS['text_medium']))
    
    return img

# ============ ONBOARDING 2: Share with Friends (400x400) ============
def create_onboarding2():
    size = (400, 400)
    img = Image.new('RGBA', size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Background gradient
    create_gradient_background(draw, size, COLORS['blue_light'], COLORS['blue_medium'])
    
    # Circle with shadow
    draw_circle_with_shadow(draw, (200, 150), 100, COLORS['white'])
    
    # Three person icons
    draw.ellipse([145, 120, 175, 160], fill=hex_to_rgb(COLORS['blue']))  # Left
    draw.ellipse([170, 115, 210, 165], fill=hex_to_rgb(COLORS['teal']))  # Middle
    draw.ellipse([195, 120, 225, 160], fill=hex_to_rgb(COLORS['orange']))  # Right
    
    # Share icon
    share_color = hex_to_rgb(COLORS['green'])
    draw.ellipse([235, 165, 275, 205], fill=share_color)
    draw.text((247, 175), "^", fill=COLORS['white'])
    
    # Title
    try:
        title_font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 28)
        body_font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 16)
    except:
        title_font = ImageFont.load_default()
        body_font = ImageFont.load_default()
    
    draw.text((80, 265), "Share with Friends", font=title_font, fill=hex_to_rgb(COLORS['text_dark']))
    draw.text((120, 310), "Spread the word and", font=body_font, fill=hex_to_rgb(COLORS['text_medium']))
    draw.text((130, 330), "save together!", font=body_font, fill=hex_to_rgb(COLORS['text_medium']))
    
    return img

# ============ ONBOARDING 3: Save Money (400x400) ============
def create_onboarding3():
    size = (400, 400)
    img = Image.new('RGBA', size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Background gradient
    create_gradient_background(draw, size, COLORS['green_light'], COLORS['green_medium'])
    
    # Circle with shadow
    draw_circle_with_shadow(draw, (200, 150), 100, COLORS['white'])
    
    # Banknote icon
    bank_color = hex_to_rgb(COLORS['green'])
    draw.rounded_rectangle([155, 120, 245, 190], radius=10, fill=bank_color)
    draw.ellipse([185, 145, 215, 175], fill=COLORS['gold'])
    
    # Title
    try:
        title_font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 28)
        body_font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 16)
    except:
        title_font = ImageFont.load_default()
        body_font = ImageFont.load_default()
    
    draw.text((115, 265), "Save Money", font=title_font, fill=hex_to_rgb(COLORS['text_dark']))
    draw.text((75, 310), "Track your savings and", font=body_font, fill=hex_to_rgb(COLORS['text_medium']))
    draw.text((90, 330), "watch your wallet grow", font=body_font, fill=hex_to_rgb(COLORS['text_medium']))
    
    return img

# ============ MAIN ============
def main():
    # Output directory
    output_dir = "generated_assets"
    os.makedirs(output_dir, exist_ok=True)
    
    # Generate all assets
    print("Generating DealBuddy iOS Assets...")
    
    assets = [
        ("AppIcon.png", create_app_icon, 1024),
        ("EmptyDeals.png", create_empty_deals, 400),
        ("EmptyFriends.png", create_empty_friends, 400),
        ("DealPlaceholder.png", create_deal_placeholder, 400),
        ("PremiumBadge.png", create_premium_badge, 200),
        ("Onboarding1.png", create_onboarding1, 400),
        ("Onboarding2.png", create_onboarding2, 400),
        ("Onboarding3.png", create_onboarding3, 400),
    ]
    
    for filename, creator_func, expected_size in assets:
        img = creator_func()
        output_path = os.path.join(output_dir, filename)
        img.save(output_path, "PNG")
        print(f"✓ Generated {filename} ({img.size[0]}x{img.size[1]})")
    
    print("\nAll assets generated successfully!")
    print(f"Output directory: {os.path.abspath(output_dir)}")

if __name__ == "__main__":
    main()
