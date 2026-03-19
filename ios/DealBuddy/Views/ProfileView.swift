import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header
                    VStack(spacing: 12) {
                        ZStack(alignment: .bottomTrailing) {
                            Circle()
                                .fill(Color(hex: "E8F4FD"))
                                .frame(width: 80, height: 80)
                                .overlay(Text("🧑").font(.largeTitle))
                            
                            Circle()
                                .fill(Color(hex: "FFD700"))
                                .frame(width: 24, height: 24)
                                .overlay(Text("P").font(.caption2).fontWeight(.bold).foregroundColor(.black))
                                .offset(x: 4, y: 4)
                        }
                        
                        Text("John Doe")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("🎓 Hong Kong University")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 24)
                    
                    // Stats
                    HStack(spacing: 40) {
                        StatItem(value: "12", label: "Deals")
                        StatItem(value: "5", label: "Sessions")
                        StatItem(value: "8", label: "Friends")
                    }
                    
                    // Links (Premium)
                    HStack(spacing: 16) {
                        LinkButton(icon: "📸", text: "@johndoe")
                        LinkButton(icon: "🐦", text: "@johndt")
                        LinkButton(icon: "💼", text: "portfolio.com")
                    }
                    
                    // Settings
                    Button(action: {}) {
                        HStack {
                            Text("⚙️ Settings")
                                .font(.headline)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(Color(hex: "FF6B35"))
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color(hex: "F7F7F7"))
            .navigationTitle("Profile")
        }
    }
}

struct StatItem: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "FF6B35"))
            
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

struct LinkButton: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 4) {
            Text(icon)
            Text(text)
                .font(.caption)
        }
        .foregroundColor(Color(hex: "004E89"))
    }
}

#Preview {
    ProfileView()
}
