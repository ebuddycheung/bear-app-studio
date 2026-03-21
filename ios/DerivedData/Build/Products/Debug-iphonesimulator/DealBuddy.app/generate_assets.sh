#!/bin/bash

# Generate DealBuddy iOS Assets
# This script renders SwiftUI views to PNG images

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ASSETS_DIR="$SCRIPT_DIR/Assets.xcassets"
OUTPUT_DIR="$SCRIPT_DIR/generated_assets"

echo "Creating output directory..."
mkdir -p "$OUTPUT_DIR"

# Use xcrun simctl to render SwiftUI views
# Since we can't directly render SwiftUI to PNG, we'll use a workaround

# Create a temporary Swift file that renders each view and saves as PNG
RENDER_SCRIPT='import SwiftUI
import AppKit

@main
struct AssetRenderer {
    static func main() {
        // App Icon - 1024x1024
        let appIcon = NSHostingView(rootView: AppIconView())
        appIcon.frame = NSRect(x: 0, y: 0, width: 1024, height: 1024)
        if let bitmap = NSImage(size: appIcon.frame.size) {
            bitmap.lockFocus()
            if let context = NSGraphicsContext.current?.cgContext {
                appIcon.layer?.render(in: context)
            }
            bitmap.unlockFocus()
            if let tiffData = bitmap.tiffRepresentation,
               let bitmapRep = NSBitmapImageRep(data: tiffData),
               let pngData = bitmapRep.representation(using: .png, properties: [:]) {
                try? pngData.write(to: URL(fileURLWithPath: CommandLine.arguments[1]))
            }
        }
    }
}
'

# Alternative approach: Use UIKit/SwiftUI snapshot testing approach
# Let's create a simple macOS app that can render these

cat > "$SCRIPT_DIR/AssetRendererApp.swift" << 'SWIFTEOF'
import SwiftUI
import AppKit

// Color extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - App Icon (1024x1024)
struct AppIconView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "FF8C42"), Color(hex: "FF6B35")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.9))
                    .frame(width: 80, height: 30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.3), lineWidth: 2)
                    )
                    .offset(y: 15)
                
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .frame(width: 140, height: 120)
                    .overlay(
                        VStack(spacing: 8) {
                            Image(systemName: "tag.fill")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(Color(hex: "FF8C42"))
                            
                            Text("50%")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(Color(hex: "4ECDC4"))
                        }
                    )
            }
            
            Image(systemName: "star.fill")
                .font(.system(size: 20))
                .foregroundColor(.white.opacity(0.8))
                .offset(x: -60, y: -60)
            
            Image(systemName: "sparkle")
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.6))
                .offset(x: 70, y: -40)
        }
        .frame(width: 1024, height: 1024)
    }
}

// MARK: - Empty Deals (400x400)
struct EmptyDealsView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "FFF5F0"), Color(hex: "FFE8E0")],
                startPoint: .top,
                endPoint: .bottom
            )
            
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 180, height: 180)
                        .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
                    
                    Image(systemName: "bag")
                        .font(.system(size: 60, weight: .light))
                        .foregroundColor(Color(hex: "B0AEA5"))
                    
                    Image(systemName: "questionmark")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(Color(hex: "FF8C42"))
                        .offset(x: 40, y: -40)
                }
                
                VStack(spacing: 8) {
                    Text("No Deals Yet")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(Color(hex: "141413"))
                    
                    Text("Start saving by adding\nyour first deal!")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "6B6B6B"))
                        .multilineTextAlignment(.center)
                }
            }
            
            Image(systemName: "tag.fill")
                .font(.system(size: 20))
                .foregroundColor(Color(hex: "FF8C42").opacity(0.3))
                .position(x: 80, y: 80)
            
            Image(systemName: "star.fill")
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "FF8C42").opacity(0.25))
                .position(x: 320, y: 100)
        }
        .frame(width: 400, height: 400)
    }
}

// MARK: - Empty Friends (400x400)
struct EmptyFriendsView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "F0F9FF"), Color(hex: "E0F2FE")],
                startPoint: .top,
                endPoint: .bottom
            )
            
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 180, height: 180)
                        .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
                    
                    Image(systemName: "person.2")
                        .font(.system(size: 50, weight: .light))
                        .foregroundColor(Color(hex: "6A9BCC"))
                    
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 36))
                        .foregroundColor(Color(hex: "4ECDC4"))
                        .offset(x: 50, y: 50)
                }
                
                VStack(spacing: 8) {
                    Text("No Friends Yet")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(Color(hex: "141413"))
                    
                    Text("Invite friends to share\ndeals together!")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "6B6B6B"))
                        .multilineTextAlignment(.center)
                }
            }
            
            Image(systemName: "person.fill")
                .font(.system(size: 20))
                .foregroundColor(Color(hex: "6A9BCC").opacity(0.3))
                .position(x: 80, y: 80)
            
            Image(systemName: "heart.fill")
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "6A9BCC").opacity(0.25))
                .position(x: 320, y: 100)
        }
        .frame(width: 400, height: 400)
    }
}

// MARK: - Deal Placeholder (400x400)
struct DealPlaceholderView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "F5F5F5"), Color(hex: "EEEEEE")],
                startPoint: .top,
                endPoint: .bottom
            )
            
            VStack(spacing: 16) {
                Image(systemName: "photo")
                    .font(.system(size: 48))
                    .foregroundColor(Color(hex: "B0AEA5"))
                
                Text("No Photo")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "8A8A8A"))
            }
        }
        .frame(width: 400, height: 400)
    }
}

// MARK: - Premium Badge (200x200)
struct PremiumBadgeView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "FFD700"), Color(hex: "FFA500")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            Image(systemName: "crown.fill")
                .font(.system(size: 80))
                .foregroundColor(.white)
            
            Image(systemName: "sparkle")
                .font(.system(size: 20))
                .foregroundColor(.white)
                .offset(x: -50, y: -50)
            
            Image(systemName: "star.fill")
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.8))
                .offset(x: 50, y: 50)
        }
        .frame(width: 200, height: 200)
    }
}

// MARK: - Onboarding 1 (400x400)
struct Onboarding1View: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "FFF8F0"), Color(hex: "FFE4D6")],
                startPoint: .top,
                endPoint: .bottom
            )
            
            VStack(spacing: 30) {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 200, height: 200)
                        .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
                    
                    Image(systemName: "tag.fill")
                        .font(.system(size: 70))
                        .foregroundColor(Color(hex: "FF8C42"))
                    
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(Color(hex: "4ECDC4"))
                        .offset(x: 50, y: -50)
                }
                
                VStack(spacing: 8) {
                    Text("Find Amazing Deals")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(hex: "141413"))
                    
                    Text("Discover the best discounts\nfrom your favorite stores")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "6B6B6B"))
                        .multilineTextAlignment(.center)
                }
            }
        }
        .frame(width: 400, height: 400)
    }
}

// MARK: - Onboarding 2 (400x400)
struct Onboarding2View: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "F0F9FF"), Color(hex: "E0F2FE")],
                startPoint: .top,
                endPoint: .bottom
            )
            
            VStack(spacing: 30) {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 200, height: 200)
                        .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
                    
                    HStack(spacing: -20) {
                        Image(systemName: "person.fill")
                            .font(.system(size: 45))
                            .foregroundColor(Color(hex: "6A9BCC"))
                            .offset(x: -20)
                        
                        Image(systemName: "person.fill")
                            .font(.system(size: 50))
                            .foregroundColor(Color(hex: "4ECDC4"))
                        
                        Image(systemName: "person.fill")
                            .font(.system(size: 45))
                            .foregroundColor(Color(hex: "FF8C42"))
                            .offset(x: 20)
                    }
                    
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Circle().fill(Color(hex: "788C5D")))
                        .offset(x: 60, y: 60)
                }
                
                VStack(spacing: 8) {
                    Text("Share with Friends")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(hex: "141413"))
                    
                    Text("Spread the word and\nsave together!")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "6B6B6B"))
                        .multilineTextAlignment(.center)
                }
            }
        }
        .frame(width: 400, height: 400)
    }
}

// MARK: - Onboarding 3 (400x400)
struct Onboarding3View: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "F0FFF4"), Color(hex: "DCFCE7")],
                startPoint: .top,
                endPoint: .bottom
            )
            
            VStack(spacing: 30) {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 200, height: 200)
                        .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
                    
                    Image(systemName: "banknote.fill")
                        .font(.system(size: 70))
                        .foregroundColor(Color(hex: "788C5D"))
                    
                    Image(systemName: "dollarsign.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(Color(hex: "FFD700"))
                        .offset(x: 60, y: -30)
                }
                
                VStack(spacing: 8) {
                    Text("Save Money")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(hex: "141413"))
                    
                    Text("Track your savings and\nwatch your wallet grow")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "6B6B6B"))
                        .multilineTextAlignment(.center)
                }
            }
        }
        .frame(width: 400, height: 400)
    }
}

// MARK: - Rendering Functions
func renderViewToPNG<Content: View>(_ view: Content, size: CGSize, outputPath: String) {
    let renderer = ImageRenderer(content: view)
    renderer.proposedSize = ProposedViewSize(size)
    renderer.scale = 1.0
    
    if let cgImage = renderer.cgImage {
        let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
        if let pngData = bitmapRep.representation(using: .png, properties: [:]) {
            try? pngData.write(to: URL(fileURLWithPath: outputPath))
            print("Generated: \(outputPath)")
        }
    }
}

@main
struct GenerateAssets {
    static func main() {
        let outputDir = "generated_assets"
        try? FileManager.default.createDirectory(atPath: outputDir, withIntermediateDirectories: true)
        
        // Generate all assets
        renderViewToPNG(AppIconView(), size: CGSize(width: 1024, height: 1024), outputPath: "\(outputDir)/AppIcon.png")
        renderViewToPNG(EmptyDealsView(), size: CGSize(width: 400, height: 400), outputPath: "\(outputDir)/EmptyDeals.png")
        renderViewToPNG(EmptyFriendsView(), size: CGSize(width: 400, height: 400), outputPath: "\(outputDir)/EmptyFriends.png")
        renderViewToPNG(DealPlaceholderView(), size: CGSize(width: 400, height: 400), outputPath: "\(outputDir)/DealPlaceholder.png")
        renderViewToPNG(PremiumBadgeView(), size: CGSize(width: 200, height: 200), outputPath: "\(outputDir)/PremiumBadge.png")
        renderViewToPNG(Onboarding1View(), size: CGSize(width: 400, height: 400), outputPath: "\(outputDir)/Onboarding1.png")
        renderViewToPNG(Onboarding2View(), size: CGSize(width: 400, height: 400), outputPath: "\(outputDir)/Onboarding2.png")
        renderViewToPNG(Onboarding3View(), size: CGSize(width: 400, height: 400), outputPath: "\(outputDir)/Onboarding3.png")
        
        print("All assets generated successfully!")
    }
}
SWIFTEOF

echo "Asset renderer script created. Now let's create the assets using a different approach..."

# Use a simpler approach - create PNGs programmatically with Python/numpy or use sips
# Let's use Swift in another way - create playgrounds-like output

# First, let's just verify the existing images work and then create new ones using a simpler method
echo ""
echo "Checking current assets..."
ls -la "$ASSETS_DIR"/*.imageset/
