#!/usr/bin/env python3
"""Generate DealBuddy iOS app assets"""

from PIL import Image, ImageDraw, ImageFont
import os

# Output directory
ASSETS_DIR = "/Users/ebuddycheung/.openclaw/workspace/bear-app-studio/ios/DealBuddy/Assets.xcassets"

def create_gradient_background(width, height, color1, color2, direction="vertical"):
    """Create a gradient background"""
    base = Image.new('RGB', (width, height), color1)
    top = Image.new('RGB', (width, height), color2)
    mask = Image.new('L', (width, height))
    mask_data = []
    for y in range(height):
        for x in range(width):
            if direction == "vertical":
                ratio = y / height
            else:
                ratio = x / width
            mask_data.append(int(255 * ratio))
    mask.putdata(mask_data)
    base.paste(top, (0, 0), mask)
    return base

def create_app_icon():
    """Create app icon with deal/bargain theme"""
    size = 1024
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Background - gradient from purple to blue
    for y in range(size):
        r = int(120 + (60 - 120) * y / size)
        g = int(80 + (140 - 80) * y / size)
        b = int(200 + (220 - 200) * y / size)
        draw.line([(0, y), (size, y)], fill=(r, g, b, 255))
    
    # Draw shopping tag shape (rounded rectangle with hole)
    tag_color = (255, 255, 255, 255)
    margin = 200
    tag_rect = [margin, margin + 100, size - margin, size - margin - 100]
    draw.rounded_rectangle(tag_rect, radius=80, fill=tag_color)
    
    # Draw tag hole
    hole_size = 100
    hole_pos = [(size - hole_size) // 2, margin + 50]
    draw.ellipse([hole_pos[0], hole_pos[1], hole_pos[0] + hole_size, hole_pos[1] + hole_size], fill=(120, 80, 200, 255))
    
    # Draw discount symbol
    discount_color = (200, 50, 100, 255)
    # Draw % sign in center
    center = size // 2
    draw.ellipse([center - 180, center - 180, center + 180, center + 180], fill=discount_color)
    draw.text((center - 100, center - 150), "%", fill=(255, 255, 255, 255), anchor="mm")
    draw.text((center, center), "%", fill=(255, 255, 255, 255), anchor="mm")
    
    output_path = os.path.join(ASSETS_DIR, "AppIcon.appiconset", "AppIcon.png")
    img.save(output_path, "PNG")
    print(f"Created: {output_path}")

def create_empty_deals_image():
    """Create empty deals state image"""
    size = 400
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Background circle
    draw.ellipse([50, 50, 350, 350], fill=(240, 240, 250, 255))
    
    # Draw shopping bag outline
    bag_color = (150, 150, 170, 255)
    bag_left, bag_top = 120, 150
    bag_right, bag_bottom = 280, 300
    draw.rounded_rectangle([bag_left, bag_top, bag_right, bag_bottom], radius=20, outline=bag_color, width=8)
    
    # Bag handles
    draw.arc([bag_left + 40, bag_top - 40, bag_right - 40, bag_top + 20], start=0, end=180, fill=bag_color, width=8)
    
    # Draw question marks (no deals)
    draw.text((200, 200), "?", fill=(180, 180, 200, 255), anchor="mm")
    draw.text((200, 240), "?", fill=(180, 180, 200, 255), anchor="mm")
    
    output_path = os.path.join(ASSETS_DIR, "EmptyDeals.imageset", "EmptyDeals.png")
    img.save(output_path, "PNG")
    print(f"Created: {output_path}")

def create_empty_friends_image():
    """Create empty friends state image"""
    size = 400
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Background circle
    draw.ellipse([50, 50, 350, 350], fill=(240, 248, 255, 255))
    
    # Draw user silhouettes
    # Person 1 (left)
    draw.ellipse([120, 120, 170, 170], fill=(100, 150, 200, 255))  # head
    draw.ellipse([100, 160, 190, 240], fill=(100, 150, 200, 255))  # body
    
    # Person 2 (right)
    draw.ellipse([230, 120, 280, 170], fill=(150, 100, 180, 255))  # head
    draw.ellipse([210, 160, 300, 240], fill=(150, 100, 180, 255))  # body
    
    # Plus sign between them
    plus_color = (80, 180, 120, 255)
    draw.line([185, 200, 215, 200], fill=plus_color, width=6)
    draw.line([200, 185, 200, 215], fill=plus_color, width=6)
    
    output_path = os.path.join(ASSETS_DIR, "EmptyFriends.imageset", "EmptyFriends.png")
    img.save(output_path, "PNG")
    print(f"Created: {output_path}")

def create_onboarding_image(number, title, subtitle):
    """Create onboarding illustration"""
    size = 400
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    colors = [
        ((100, 150, 255), (200, 100, 150)),  # Blue to pink
        ((100, 200, 150), (50, 150, 200)),   # Green to blue
        ((250, 200, 100), (200, 100, 200)),  # Yellow to purple
    ]
    
    # Gradient background
    color1, color2 = colors[number - 1]
    for y in range(size):
        ratio = y / size
        r = int(color1[0] + (color2[0] - color1[0]) * ratio)
        g = int(color1[1] + (color2[1] - color1[1]) * ratio)
        b = int(color1[2] + (color2[2] - color1[2]) * ratio)
        draw.line([(0, y), (size, y)], fill=(r, g, b, 255))
    
    # Draw illustration based on number
    if number == 1:
        # Discover deals - magnifying glass
        draw.ellipse([120, 120, 280, 280], fill=(255, 255, 255, 200), outline=(255, 255, 255, 255), width=6)
        draw.line([250, 250, 320, 320], fill=(255, 255, 255, 255), width=12)
        draw.text((200, 200), "🔍", anchor="mm")
    elif number == 2:
        # Share with friends - sharing icon
        draw.ellipse([100, 80, 300, 180], fill=(255, 255, 255, 200))  # person 1
        draw.ellipse([180, 150, 320, 280], fill=(255, 255, 255, 200))  # person 2
        draw.line([250, 130, 250, 200], fill=(255, 255, 255, 255), width=4)
        draw.text((250, 170), "→", fill=(255, 255, 255, 255), anchor="mm")
    elif number == 3:
        # Save money - piggy bank
        draw.ellipse([120, 150, 280, 280], fill=(255, 255, 255, 200))
        draw.ellipse([100, 130, 180, 180], fill=(255, 255, 255, 200))  # nose
        draw.ellipse([200, 100, 240, 140], fill=(255, 255, 255, 200))  # ear
        draw.text((200, 200), "💰", anchor="mm")
    
    output_path = os.path.join(ASSETS_DIR, f"Onboarding{number}.imageset", f"Onboarding{number}.png")
    img.save(output_path, "PNG")
    print(f"Created: {output_path}")

def create_premium_badge():
    """Create premium badge icon"""
    size = 200
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Gold gradient circle
    for y in range(size):
        ratio = y / size
        r = int(255)
        g = int(200 - 50 * ratio)
        b = int(50)
        draw.line([(0, y), (size, y)], fill=(r, g, b, 255))
    
    # Star in center
    star_color = (255, 255, 255, 255)
    center = size // 2
    # Draw star shape
    points = []
    for i in range(10):
        angle = i * 36 - 90
        import math
        r = 50 if i % 2 == 0 else 25
        x = center + r * math.cos(math.radians(angle))
        y = center + r * math.sin(math.radians(angle))
        points.append((x, y))
    draw.polygon(points, fill=star_color)
    
    # Crown on top
    draw.polygon([(70, 60), (100, 30), (130, 60), (130, 90), (100, 70), (70, 90)], fill=star_color)
    
    output_path = os.path.join(ASSETS_DIR, "PremiumBadge.imageset", "PremiumBadge.png")
    img.save(output_path, "PNG")
    print(f"Created: {output_path}")

def create_deal_placeholder():
    """Create deal placeholder image"""
    size = 400
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Light gray background
    draw.rectangle([0, 0, size, size], fill=(245, 245, 250, 255))
    
    # Dashed border
    border_color = (200, 200, 210, 255)
    draw.rounded_rectangle([20, 20, 380, 380], radius=20, outline=border_color, width=4)
    
    # Image icon
    draw.rectangle([120, 140, 280, 220], fill=(180, 180, 200, 255))
    draw.polygon([(150, 180), (200, 130), (250, 180)], fill=(220, 220, 230, 255))
    draw.ellipse([220, 190, 250, 220], fill=(180, 180, 200, 255))
    
    output_path = os.path.join(ASSETS_DIR, "DealPlaceholder.imageset", "DealPlaceholder.png")
    img.save(output_path, "PNG")
    print(f"Created: {output_path}")

if __name__ == "__main__":
    print("Generating DealBuddy iOS assets...")
    
    create_app_icon()
    create_empty_deals_image()
    create_empty_friends_image()
    create_onboarding_image(1, "Discover Deals", "Find the best bargains")
    create_onboarding_image(2, "Share with Friends", "Invite friends to save together")
    create_onboarding_image(3, "Save Money", "Get exclusive premium deals")
    create_premium_badge()
    create_deal_placeholder()
    
    print("\nAll assets generated successfully!")
