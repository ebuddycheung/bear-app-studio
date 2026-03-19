import SwiftUI

struct ProfileView: View {
    @Binding var isLoggedIn: Bool
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showLogoutAlert = false
    
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
                            
                            if viewModel.profile?.isPremium == true {
                                Circle()
                                    .fill(Color(hex: "FFD700"))
                                    .frame(width: 24, height: 24)
                                    .overlay(Text("P").font(.caption2).fontWeight(.bold).foregroundColor(.black))
                                    .offset(x: 4, y: 4)
                            }
                        }
                        
                        Text(viewModel.profile?.name ?? "User")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        if let university = viewModel.profile?.university {
                            Text("🎓 \(university)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        if let bio = viewModel.profile?.bio {
                            Text(bio)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.top, 24)
                    
                    // Stats
                    HStack(spacing: 40) {
                        StatItem(value: "\(viewModel.stats.deals)", label: "Deals")
                        StatItem(value: "\(viewModel.stats.sessions)", label: "Sessions")
                        StatItem(value: "\(viewModel.stats.friends)", label: "Friends")
                    }
                    
                    // Premium Badge
                    if viewModel.profile?.isPremium == true {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(Color(hex: "FFD700"))
                            Text("Premium Member")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(Color(hex: "FFD700"))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color(hex: "004E89").opacity(0.1))
                        .cornerRadius(20)
                    }
                    
                    // Settings & Logout
                    VStack(spacing: 12) {
                        NavigationLink(destination: SettingsView()) {
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
                        
                        NavigationLink(destination: EditProfileView(profile: viewModel.profile)) {
                            HStack {
                                Text("✏️ Edit Profile")
                                    .font(.headline)
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .foregroundColor(Color(hex: "FF6B35"))
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                        }
                        
                        Button(action: {
                            showLogoutAlert = true
                        }) {
                            HStack {
                                Text("🚪 Logout")
                                    .font(.headline)
                                Spacer()
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                            }
                            .foregroundColor(.red)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color(hex: "F7F7F7"))
            .navigationTitle("Profile")
            .alert("Logout", isPresented: $showLogoutAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Logout", role: .destructive) {
                    Task {
                        await viewModel.logout()
                        isLoggedIn = false
                    }
                }
            } message: {
                Text("Are you sure you want to logout?")
            }
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

// MARK: - Settings View
struct SettingsView: View {
    @State private var notificationsEnabled = true
    @State private var locationEnabled = true
    @State private var darkModeEnabled = false
    
    var body: some View {
        List {
            Section("Notifications") {
                Toggle("Push Notifications", isOn: $notificationsEnabled)
                Toggle("Location Services", isOn: $locationEnabled)
            }
            
            Section("Appearance") {
                Toggle("Dark Mode", isOn: $darkModeEnabled)
            }
            
            Section("About") {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.gray)
                }
                
                NavigationLink("Privacy Policy", destination: Text("Privacy Policy"))
                NavigationLink("Terms of Service", destination: Text("Terms of Service"))
            }
        }
        .navigationTitle("Settings")
    }
}

// MARK: - Edit Profile View
struct EditProfileView: View {
    let profile: Profile?
    @State private var name: String = ""
    @State private var university: String = ""
    @State private var bio: String = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            Section("Basic Info") {
                TextField("Name", text: $name)
                TextField("University", text: $university)
            }
            
            Section("Bio") {
                TextEditor(text: $bio)
                    .frame(minHeight: 100)
            }
            
            Section {
                Button("Save Changes") {
                    // TODO: Save changes
                    dismiss()
                }
            }
        }
        .navigationTitle("Edit Profile")
        .onAppear {
            name = profile?.name ?? ""
            university = profile?.university ?? ""
            bio = profile?.bio ?? ""
        }
    }
}

#Preview {
    ProfileView(isLoggedIn: .constant(true))
}
