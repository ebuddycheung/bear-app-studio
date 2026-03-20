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
                    
                    // Premium Photo Gallery (US-017)
                    if viewModel.profile?.isPremium == true, let photos = viewModel.profile?.photos, !photos.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("📸 Photos")
                                    .font(.headline)
                                Spacer()
                                NavigationLink(destination: ManagePhotosView(photos: photos, viewModel: viewModel)) {
                                    Text("Manage")
                                        .font(.subheadline)
                                        .foregroundColor(Color(hex: "FF6B35"))
                                }
                            }
                            .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(photos) { photo in
                                        AsyncImage(url: URL(string: photo.photoUrl)) { image in
                                            image
                                                .resizable()
                                                .scaledToFill()
                                        } placeholder: {
                                            Color(hex: "E8F4FD")
                                                .overlay(
                                                    Image(systemName: "photo")
                                                        .foregroundColor(.gray)
                                                )
                                        }
                                        .frame(width: 80, height: 80)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    } else if viewModel.profile?.isPremium == true {
                        // Show add photos button for premium users with no photos
                        VStack(alignment: .leading, spacing: 12) {
                            Text("📸 Photos")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            NavigationLink(destination: ManagePhotosView(photos: [], viewModel: viewModel)) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(Color(hex: "FF6B35"))
                                    Text("Add Photos (Premium)")
                                        .foregroundColor(Color(hex: "FF6B35"))
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(12)
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Premium Custom Links (US-018)
                    if viewModel.profile?.isPremium == true, let links = viewModel.profile?.links, !links.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("🔗 Links")
                                    .font(.headline)
                                Spacer()
                                NavigationLink(destination: ManageLinksView(links: links, viewModel: viewModel)) {
                                    Text("Manage")
                                        .font(.subheadline)
                                        .foregroundColor(Color(hex: "FF6B35"))
                                }
                            }
                            .padding(.horizontal)
                            
                            VStack(spacing: 8) {
                                ForEach(links) { link in
                                    HStack {
                                        Text(link.platform.icon)
                                        Text(link.platform.displayName)
                                            .font(.subheadline)
                                        Spacer()
                                        if let url = URL(string: link.url) {
                                            Link(destination: url) {
                                                Text(link.url)
                                                    .font(.caption)
                                                    .foregroundColor(Color(hex: "004E89"))
                                                    .lineLimit(1)
                                            }
                                        }
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(8)
                                }
                            }
                            .padding(.horizontal)
                        }
                    } else if viewModel.profile?.isPremium == true {
                        // Show add links button for premium users with no links
                        VStack(alignment: .leading, spacing: 12) {
                            Text("🔗 Links")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            NavigationLink(destination: ManageLinksView(links: [], viewModel: viewModel)) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(Color(hex: "FF6B35"))
                                    Text("Add Links (Premium)")
                                        .foregroundColor(Color(hex: "FF6B35"))
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(12)
                            }
                            .padding(.horizontal)
                        }
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
    @StateObject private var iapService = IAPService.shared
    @EnvironmentObject var notificationManager: NotificationManager
    @State private var locationEnabled = true
    @State private var darkModeEnabled = false
    
    var body: some View {
        List {
            // Premium Section
            Section {
                if iapService.isPremium {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(Color(hex: "FFD700"))
                        Text("Premium Active")
                            .fontWeight(.medium)
                        Spacer()
                        Text("✅")
                    }
                } else {
                    NavigationLink(destination: PremiumUpgradeView()) {
                        HStack {
                            Image(systemName: "crown.fill")
                                .foregroundColor(Color(hex: "FFD700"))
                            Text("Upgrade to Premium")
                                .fontWeight(.medium)
                            Spacer()
                            Text("🅿️")
                        }
                    }
                }
            } header: {
                Text("Subscription")
            }
            
            Section("Notifications") {
                NavigationLink(destination: NotificationSettingsView()) {
                    HStack {
                        Image(systemName: "bell.fill")
                            .foregroundColor(Color(hex: "FF6B35"))
                        Text("Push Notifications")
                        Spacer()
                        Text(notificationManager.isAuthorized ? "Enabled" : "Disabled")
                            .foregroundColor(notificationManager.isAuthorized ? .green : .secondary)
                    }
                }
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
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var showSourcePicker = false
    @State private var isSaving = false
    @State private var saveError: String?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            // Profile Photo Section
            Section {
                VStack(spacing: 16) {
                    ZStack(alignment: .bottomTrailing) {
                        Group {
                            if let image = selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                            } else {
                                Circle()
                                    .fill(Color(hex: "E8F4FD"))
                                    .overlay(
                                        Image(systemName: "person.fill")
                                            .font(.largeTitle)
                                            .foregroundColor(Color(hex: "004E89"))
                                    )
                            }
                        }
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        
                        Button(action: { showSourcePicker = true }) {
                            Image(systemName: "camera.fill")
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(6)
                                .background(Color(hex: "FF6B35"))
                                .clipShape(Circle())
                        }
                    }
                    
                    Button("Change Photo") {
                        showSourcePicker = true
                    }
                    .font(.subheadline)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
            
            Section("Basic Info") {
                TextField("Name", text: $name)
                TextField("University", text: $university)
            }
            
            Section("Bio") {
                TextEditor(text: $bio)
                    .frame(minHeight: 100)
            }
            
            Section {
                Button(action: saveChanges) {
                    if isSaving {
                        HStack {
                            ProgressView()
                            Text("Saving...")
                        }
                        .frame(maxWidth: .infinity)
                    } else {
                        Text("Save Changes")
                            .frame(maxWidth: .infinity)
                    }
                }
                .disabled(isSaving)
                
                if let error = saveError {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
        }
        .navigationTitle("Edit Profile")
        .onAppear {
            name = profile?.name ?? ""
            university = profile?.university ?? ""
            bio = profile?.bio ?? ""
        }
        .confirmationDialog("Select Photo", isPresented: $showSourcePicker) {
            Button("Take Photo") {
                showImagePicker = true
            }
            Button("Choose from Library") {
                showImagePicker = true
            }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage, sourceType: .photoLibrary)
        }
    }
    
    private func saveChanges() {
        isSaving = true
        saveError = nil
        
        Task {
            do {
                // Get user ID from profile or generate a placeholder
                let userId = profile?.id ?? UUID()
                
                // Update profile in Supabase
                try await ProfileRepository.shared.updateProfile(
                    userId: userId,
                    name: name.isEmpty ? nil : name,
                    university: university.isEmpty ? nil : university,
                    bio: bio.isEmpty ? nil : bio
                )
                
                // Upload new avatar if selected
                if let image = selectedImage, let imageData = image.jpegData(compressionQuality: 0.8) {
                    _ = try await ProfileRepository.shared.uploadAvatar(userId: userId, imageData: imageData)
                }
                
                await MainActor.run {
                    isSaving = false
                    dismiss()
                }
            } catch {
                await MainActor.run {
                    saveError = error.localizedDescription
                    isSaving = false
                    // For demo, still dismiss
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    ProfileView(isLoggedIn: .constant(true))
}

// MARK: - Manage Photos View (Premium - US-017)
struct ManagePhotosView: View {
    let photos: [ProfilePhoto]
    @ObservedObject var viewModel: ProfileViewModel
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var isUploading = false
    @Environment(\.dismiss) private var dismiss
    
    private let maxPhotos = 5
    
    var body: some View {
        List {
            Section {
                VStack(spacing: 16) {
                    Text("Add up to \(maxPhotos) photos to your profile")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    
                    if photos.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "photo.on.rectangle.angled")
                                .font(.largeTitle)
                                .foregroundColor(Color(hex: "004E89"))
                            Text("No photos yet")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                    } else {
                        // Existing photos
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            ForEach(photos) { photo in
                                ZStack(alignment: .topTrailing) {
                                    AsyncImage(url: URL(string: photo.photoUrl)) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } placeholder: {
                                        Color(hex: "E8F4FD")
                                    }
                                    .frame(height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    
                                    Button(action: {
                                        Task {
                                            try? await viewModel.deletePhoto(photo.id)
                                        }
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.red)
                                            .background(Color.white)
                                            .clipShape(Circle())
                                    }
                                    .offset(x: 4, y: -4)
                                }
                            }
                            
                            // Add more button
                            if photos.count < maxPhotos {
                                Button(action: { showImagePicker = true }) {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(hex: "E8F4FD"))
                                        .frame(height: 100)
                                        .overlay(
                                            VStack {
                                                Image(systemName: "plus")
                                                    .font(.title2)
                                                    .foregroundColor(Color(hex: "004E89"))
                                                Text("Add")
                                                    .font(.caption)
                                                    .foregroundColor(Color(hex: "004E89"))
                                            }
                                        )
                                }
                            }
                        }
                    }
                }
                .padding(.vertical, 8)
            } header: {
                Text("Your Photos")
            }
            
            Section {
                if isUploading {
                    HStack {
                        Spacer()
                        ProgressView("Uploading...")
                        Spacer()
                    }
                } else {
                    Button("Add Photo") {
                        showImagePicker = true
                    }
                    .disabled(photos.count >= maxPhotos)
                }
            }
        }
        .navigationTitle("Manage Photos")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog("Select Photo", isPresented: $showImagePicker) {
            Button("Take Photo") {
                // Would need camera source type
            }
            Button("Choose from Library") {
                // Image picker handles this
            }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage, sourceType: .photoLibrary)
        }
        .onChange(of: selectedImage) { newImage in
            guard let image = newImage,
                  let imageData = image.jpegData(compressionQuality: 0.8) else { return }
            
            isUploading = true
            Task {
                do {
                    _ = try await viewModel.uploadPhoto(imageData, sortOrder: photos.count)
                } catch {
                    print("Error uploading photo: \(error)")
                }
                isUploading = false
                selectedImage = nil
            }
        }
    }
}

// MARK: - Manage Links View (Premium - US-018)
struct ManageLinksView: View {
    let links: [ProfileLink]
    @ObservedObject var viewModel: ProfileViewModel
    @State private var newLinks: [EditableLink] = []
    @State private var isSaving = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List {
            Section {
                VStack(spacing: 16) {
                    Text("Add your social media and portfolio links")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, 8)
            }
            
            Section("Your Links") {
                ForEach(newLinks.indices, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 8) {
                        Picker("Platform", selection: $newLinks[index].platform) {
                            ForEach(LinkPlatform.allCases, id: \.self) { platform in
                                Text("\(platform.icon) \(platform.displayName)")
                                    .tag(platform)
                            }
                        }
                        
                        TextField("URL (e.g., https://instagram.com/username)", text: $newLinks[index].url)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.URL)
                            .autocorrectionDisabled()
                    }
                    .padding(.vertical, 4)
                }
                .onDelete { indexSet in
                    newLinks.remove(atOffsets: indexSet)
                }
                
                Button(action: {
                    newLinks.append(EditableLink(platform: .instagram, url: ""))
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(Color(hex: "FF6B35"))
                        Text("Add Link")
                            .foregroundColor(Color(hex: "FF6B35"))
                    }
                }
            }
            
            Section {
                if isSaving {
                    HStack {
                        Spacer()
                        ProgressView("Saving...")
                        Spacer()
                    }
                } else {
                    Button("Save Changes") {
                        isSaving = true
                        Task {
                            do {
                                try await viewModel.saveLinks(newLinks)
                            } catch {
                                print("Error saving links: \(error)")
                            }
                            isSaving = false
                            dismiss()
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .navigationTitle("Manage Links")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // Convert existing links to editable links
            newLinks = links.map { EditableLink(platform: $0.platform, url: $0.url) }
        }
    }
}

// MARK: - Editable Link (for form)
struct EditableLink: Identifiable {
    let id = UUID()
    var platform: LinkPlatform
    var url: String
}
