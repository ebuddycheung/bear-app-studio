import SwiftUI
import AppKit

// App Icon - Deal Buddy themed with tag/discount icon
struct AppIconView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "FF6B35"), Color(hex: "F7931E")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 4) {
                Image(systemName: "tag.fill")
                    .font(.system(size: 120, weight: .bold))
                    .foregroundColor(.white)
                
                Text("DB")
                    .font(.system(size: 48, weight: .heavy))
                    .foregroundColor(.white)
            }
        }
    }
}

// Empty Deals State
struct EmptyDealsView: View {
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 200, height: 200)
                
                Image(systemName: "tag.slash")
                    .font(.system(size: 80))
                    .foregroundColor(Color(hex: "FF6B35").opacity(0.6))
            }
            
            Text("No Deals Yet")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.primary)
            
            Text("Start exploring to find amazing deals nearby!")
                .font(.system(size: 16))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(width: 400, height: 400)
    }
}

// Empty Friends State
struct EmptyFriendsView: View {
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 200, height: 200)
                
                Image(systemName: "person.2.slash")
                    .font(.system(size: 80))
                    .foregroundColor(Color(hex: "FF6B35").opacity(0.6))
            }
            
            Text("No Friends Yet")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.primary)
            
            Text("Add friends to share deals and save together!")
                .font(.system(size: 16))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(width: 400, height: 400)
    }
}

// Onboarding 1 - Discover Deals
struct Onboarding1View: View {
    var body: some View {
        VStack(spacing: 30) {
            ZStack {
                RoundedRectangle(cornerRadius: 40)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color(hex: "FF6B35"), Color(hex: "F7931E")]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 180, height: 180)
                    .shadow(color: Color(hex: "FF6B35").opacity(0.4), radius: 20, x: 0, y: 10)
                
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 80, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 12) {
                Text("Discover Deals")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("Find the best deals and discounts from your favorite stores nearby.")
                    .font(.system(size: 18))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
        }
        .frame(width: 400, height: 500)
    }
}

// Onboarding 2 - Share with Friends
struct Onboarding2View: View {
    var body: some View {
        VStack(spacing: 30) {
            ZStack {
                RoundedRectangle(cornerRadius: 40)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color(hex: "4ECDC4"), Color(hex: "44A08D")]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 180, height: 180)
                    .shadow(color: Color(hex: "4ECDC4").opacity(0.4), radius: 20, x: 0, y: 10)
                
                Image(systemName: "person.2.fill")
                    .font(.system(size: 80, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 12) {
                Text("Share with Friends")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("Invite friends to join and share deals to maximize your savings together.")
                    .font(.system(size: 18))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
        }
        .frame(width: 400, height: 500)
    }
}

// Onboarding 3 - Save Money
struct Onboarding3View: View {
    var body: some View {
        VStack(spacing: 30) {
            ZStack {
                RoundedRectangle(cornerRadius: 40)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color(hex: "667EEA"), Color(hex: "764BA2")]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 180, height: 180)
                    .shadow(color: Color(hex: "667EEA").opacity(0.4), radius: 20, x: 0, y: 10)
                
                Image(systemName: "dollarsign.circle.fill")
                    .font(.system(size: 80, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 12) {
                Text("Save Money")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("Track your savings and watch your wallet grow with every deal you use.")
                    .font(.system(size: 18))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
        }
        .frame(width: 400, height: 500)
    }
}

// Premium Badge
struct PremiumBadgeView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "FFD700"), Color(hex: "FFA500")]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .frame(width: 80, height: 80)
                .shadow(color: Color(hex: "FFD700").opacity(0.5), radius: 10, x: 0, y: 5)
            
            Image(systemName: "star.fill")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(width: 120, height: 120)
    }
}

// Deal Placeholder
struct DealPlaceholderView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.gray.opacity(0.2), Color.gray.opacity(0.1)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            VStack(spacing: 12) {
                Image(systemName: "photo")
                    .font(.system(size: 40))
                    .foregroundColor(.gray.opacity(0.5))
                
                Text("No Image")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray.opacity(0.7))
            }
        }
    }
}

// Color extension for hex colors
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

// Helper to save views as PNG
@MainActor
func saveImage<T: View>(_ view: T, filename: String, size: CGSize) {
    let renderer = ImageRenderer(content: view.frame(width: size.width, height: size.height))
    renderer.scale = 2.0
    
    if let cgImage = renderer.cgImage {
        let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
        if let pngData = bitmapRep.representation(using: .png, properties: [:]) {
            let url = URL(fileURLWithPath: filename)
            try? pngData.write(to: url)
            print("Saved: \(filename)")
        }
    }
}

// Generate all assets
@MainActor
func generateAssets() {
    let basePath = "/Users/ebuddycheung/.openclaw/workspace/bear-app-studio/ios/DealBuddy/Assets.xcassets/"
    
    // App Icon
    saveImage(AppIconView(), filename: basePath + "AppIcon.appiconset/AppIcon.png", size: CGSize(width: 1024, height: 1024))
    
    // Empty States
    saveImage(EmptyDealsView(), filename: basePath + "EmptyDeals.imageset/EmptyDeals.png", size: CGSize(width: 400, height: 400))
    saveImage(EmptyFriendsView(), filename: basePath + "EmptyFriends.imageset/EmptyFriends.png", size: CGSize(width: 400, height: 400))
    
    // Onboarding
    saveImage(Onboarding1View(), filename: basePath + "Onboarding1.imageset/Onboarding1.png", size: CGSize(width: 400, height: 500))
    saveImage(Onboarding2View(), filename: basePath + "Onboarding2.imageset/Onboarding2.png", size: CGSize(width: 400, height: 500))
    saveImage(Onboarding3View(), filename: basePath + "Onboarding3.imageset/Onboarding3.png", size: CGSize(width: 400, height: 500))
    
    // Premium Badge
    saveImage(PremiumBadgeView(), filename: basePath + "PremiumBadge.imageset/PremiumBadge.png", size: CGSize(width: 120, height: 120))
    
    // Deal Placeholder
    saveImage(DealPlaceholderView(), filename: basePath + "DealPlaceholder.imageset/DealPlaceholder.png", size: CGSize(width: 300, height: 200))
}

Task { @MainActor in
    generateAssets()
}
