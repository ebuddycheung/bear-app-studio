import SwiftUI

// MARK: - App Icon
struct AppIconView: View {
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color(hex: "FF8C42"), Color(hex: "FF6B35")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Shopping bag shape
            VStack(spacing: 0) {
                // Bag handle
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.9))
                    .frame(width: 80, height: 30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.3), lineWidth: 2)
                    )
                    .offset(y: 15)
                
                // Bag body
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .frame(width: 140, height: 120)
                    .overlay(
                        VStack(spacing: 8) {
                            // Tag icon
                            Image(systemName: "tag.fill")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(Color(hex: "FF8C42"))
                            
                            // Percentage
                            Text("50%")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(Color(hex: "4ECDC4"))
                        }
                    )
            }
            
            // Star sparkles
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

// MARK: - Empty State: No Deals
struct EmptyDealsView: View {
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color(hex: "FFF5F0"), Color(hex: "FFE8E0")],
                startPoint: .top,
                endPoint: .bottom
            )
            
            VStack(spacing: 20) {
                // Shopping bag with question mark
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
            
            // Floating elements
            ForEach(0..<5) { i in
                Image(systemName: i % 2 == 0 ? "tag.fill" : "star.fill")
                    .font(.system(size: CGFloat.random(in: 12...24)))
                    .foregroundColor(Color(hex: "FF8C42").opacity(Double.random(in: 0.2...0.4)))
                    .position(
                        x: CGFloat.random(in: 50...350),
                        y: CGFloat.random(in: 50...350)
                    )
            }
        }
        .frame(width: 400, height: 400)
    }
}

// MARK: - Empty State: No Friends
struct EmptyFriendsView: View {
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color(hex: "F0F9FF"), Color(hex: "E0F2FE")],
                startPoint: .top,
                endPoint: .bottom
            )
            
            VStack(spacing: 20) {
                // User silhouette with plus
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
            
            // Floating elements
            ForEach(0..<5) { i in
                Image(systemName: i % 2 == 0 ? "person.fill" : "heart.fill")
                    .font(.system(size: CGFloat.random(in: 12...24)))
                    .foregroundColor(Color(hex: "6A9BCC").opacity(Double.random(in: 0.2...0.4)))
                    .position(
                        x: CGFloat.random(in: 50...350),
                        y: CGFloat.random(in: 50...350)
                    )
            }
        }
        .frame(width: 400, height: 400)
    }
}

// MARK: - Deal Placeholder
struct DealPlaceholderView: View {
    var body: some View {
        ZStack {
            // Background
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

// MARK: - Premium Badge
struct PremiumBadgeView: View {
    var body: some View {
        ZStack {
            // Gold gradient background
            LinearGradient(
                colors: [Color(hex: "FFD700"), Color(hex: "FFA500")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Crown icon
            Image(systemName: "crown.fill")
                .font(.system(size: 80))
                .foregroundColor(.white)
            
            // Sparkles
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

// MARK: - Onboarding 1: Find Deals
struct Onboarding1View: View {
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color(hex: "FFF8F0"), Color(hex: "FFE4D6")],
                startPoint: .top,
                endPoint: .bottom
            )
            
            VStack(spacing: 30) {
                // Magnifying glass over tag
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 200, height: 200)
                        .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
                    
                    Image(systemName: "tag.fill")
                        .font(.system(size: 70))
                        .foregroundColor(Color(hex: "FF8C42"))
                    
                    // Magnifying glass overlay
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

// MARK: - Onboarding 2: Share with Friends
struct Onboarding2View: View {
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color(hex: "F0F9FF"), Color(hex: "E0F2FE")],
                startPoint: .top,
                endPoint: .bottom
            )
            
            VStack(spacing: 30) {
                // Group of people sharing
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
                    
                    // Share icon
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

// MARK: - Onboarding 3: Save Money
struct Onboarding3View: View {
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color(hex: "F0FFF4"), Color(hex: "DCFCE7")],
                startPoint: .top,
                endPoint: .bottom
            )
            
            VStack(spacing: 30) {
                // Piggy bank / savings
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 200, height: 200)
                        .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
                    
                    Image(systemName: "banknote.fill")
                        .font(.system(size: 70))
                        .foregroundColor(Color(hex: "788C5D"))
                    
                    // Coin stack
                    VStack(spacing: -8) {
                        Image(systemName: "dollarsign.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(Color(hex: "FFD700"))
                    }
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

// Preview providers
struct AppIconView_Previews: PreviewProvider {
    static var previews: some View { AppIconView() }
}

struct EmptyDealsView_Previews: PreviewProvider {
    static var previews: some View { EmptyDealsView() }
}

struct EmptyFriendsView_Previews: PreviewProvider {
    static var previews: some View { EmptyFriendsView() }
}

struct DealPlaceholderView_Previews: PreviewProvider {
    static var previews: some View { DealPlaceholderView() }
}

struct PremiumBadgeView_Previews: PreviewProvider {
    static var previews: some View { PremiumBadgeView() }
}

struct Onboarding1View_Previews: PreviewProvider {
    static var previews: some View { Onboarding1View() }
}

struct Onboarding2View_Previews: PreviewProvider {
    static var previews: some View { Onboarding2View() }
}

struct Onboarding3View_Previews: PreviewProvider {
    static var previews: some View { Onboarding3View() }
}
