import SwiftUI

struct OnboardingView: View {
    @Binding var isOnboardingComplete: Bool
    @State private var currentPage = 0
    
    let pages: [(image: String, title: String, subtitle: String, color: Color)] = [
        ("Onboarding1", "Find Amazing Deals", "Discover the best student discounts near you", Color(hex: "FF6B35")),
        ("Onboarding2", "Share with Friends", "Invite friends and earn rewards together", Color(hex: "4ECDC4")),
        ("Onboarding3", "Save Money", "Track your savings and budget smarter", Color(hex: "6A9BCC"))
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    VStack(spacing: 24) {
                        Spacer()
                        
                        Image(pages[index].image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 300, maxHeight: 300)
                            .cornerRadius(20)
                            .shadow(color: pages[index].color.opacity(0.3), radius: 15, x: 0, y: 10)
                        
                        Text(pages[index].title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(pages[index].color)
                        
                        Text(pages[index].subtitle)
                            .font(.body)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        Spacer()
                        Spacer()
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            // Page Indicators
            HStack(spacing: 8) {
                ForEach(0..<pages.count, id: \.self) { index in
                    Circle()
                        .fill(currentPage == index ? pages[index].color : Color.gray.opacity(0.3))
                        .frame(width: 10, height: 10)
                }
            }
            .padding(.bottom, 24)
            
            // Buttons
            VStack(spacing: 12) {
                if currentPage == pages.count - 1 {
                    // Get Started Button
                    Button(action: {
                        completeOnboarding()
                    }) {
                        Text("Get Started")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "FF6B35"))
                            .cornerRadius(12)
                    }
                } else {
                    // Next Button
                    Button(action: {
                        withAnimation {
                            currentPage += 1
                        }
                    }) {
                        Text("Next")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(pages[currentPage].color)
                            .cornerRadius(12)
                    }
                }
                
                // Skip Button
                Button(action: {
                    completeOnboarding()
                }) {
                    Text("Skip")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .background(Color(.systemBackground))
    }
    
    private func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        isOnboardingComplete = true
    }
}

#Preview {
    OnboardingView(isOnboardingComplete: .constant(false))
}
