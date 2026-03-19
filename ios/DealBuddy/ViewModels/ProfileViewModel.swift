import Foundation
import Supabase

// MARK: - Profile ViewModel
@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var profile: Profile?
    @Published var stats: UserStats = UserStats(deals: 0, sessions: 0, friends: 0)
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isLoggedIn = false
    
    init() {
        Task {
            await checkAuthStatus()
        }
    }
    
    func checkAuthStatus() async {
        if let user = SupabaseService.shared.currentUser {
            isLoggedIn = true
            await loadProfile(userId: user.id)
        } else {
            loadMockData()
        }
    }
    
    func loadProfile(userId: UUID? = nil) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let targetId = userId ?? SupabaseService.shared.currentUser?.id
            
            if let uid = targetId {
                let response = try await SupabaseService.shared.client.from("profiles")
                    .select()
                    .eq("user_id", value: uid.uuidString)
                    .single()
                    .execute()
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                var fetchedProfile = try decoder.decode(Profile.self, from: response.data)
                
                // Fetch profile photos
                let photosResponse = try await SupabaseService.shared.client.from("profile_photos")
                    .select()
                    .eq("user_id", value: uid.uuidString)
                    .order("sort_order")
                    .execute()
                
                let photos = try decoder.decode([ProfilePhoto].self, from: photosResponse.data)
                fetchedProfile.photos = photos
                
                // Fetch profile links
                let linksResponse = try await SupabaseService.shared.client.from("profile_links")
                    .select()
                    .eq("user_id", value: uid.uuidString)
                    .execute()
                
                let links = try decoder.decode([ProfileLink].self, from: linksResponse.data)
                fetchedProfile.links = links
                
                profile = fetchedProfile
                isLoggedIn = true
            } else {
                loadMockData()
            }
        } catch {
            print("Error loading profile: \(error)")
            loadMockData()
        }
        
        isLoading = false
    }
    
    func updateProfile(name: String?, university: String?, bio: String?) async throws {
        guard let userId = SupabaseService.shared.currentUser?.id else {
            throw NSError(domain: "Profile", code: 401, userInfo: [NSLocalizedDescriptionKey: "Not logged in"])
        }
        
        var updates = ProfileUpdate()
        updates.name = name
        updates.university = university
        updates.bio = bio
        
        try await SupabaseService.shared.client.from("profiles")
            .update(updates)
            .eq("user_id", value: userId.uuidString)
            .execute()
        
        await loadProfile()
    }
    
    func logout() async {
        do {
            try await SupabaseService.shared.signOut()
            isLoggedIn = false
            profile = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Photo Management
    
    func uploadPhoto(_ imageData: Data, sortOrder: Int) async throws -> ProfilePhoto {
        guard let userId = SupabaseService.shared.currentUser?.id else {
            throw NSError(domain: "Profile", code: 401, userInfo: [NSLocalizedDescriptionKey: "Not logged in"])
        }
        
        let fileName = "\(userId.uuidString)/\(UUID().uuidString).jpg"
        
        // Upload to Supabase Storage
        let _ = try await SupabaseService.shared.client.storage
            .from("profile-photos")
            .upload(fileName, data: imageData, options: FileOptions(contentType: "image/jpeg"))
        
        // Get public URL
        let publicUrl = try SupabaseService.shared.client.storage
            .from("profile-photos")
            .getPublicURL(path: fileName)
        
        // Save to database
        let photoInsert = PhotoUpload(
            userId: userId.uuidString,
            photoUrl: publicUrl.absoluteString,
            sortOrder: sortOrder
        )
        
        let response = try await SupabaseService.shared.client.from("profile_photos")
            .insert(photoInsert)
            .select()
            .single()
            .execute()
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let photo = try decoder.decode(ProfilePhoto.self, from: response.data)
        
        // Refresh profile
        await loadProfile()
        
        return photo
    }
    
    func deletePhoto(_ photoId: UUID) async throws {
        guard SupabaseService.shared.currentUser?.id != nil else {
            throw NSError(domain: "Profile", code: 401, userInfo: [NSLocalizedDescriptionKey: "Not logged in"])
        }
        
        // Delete from database
        try await SupabaseService.shared.client.from("profile_photos")
            .delete()
            .eq("id", value: photoId.uuidString)
            .execute()
        
        // Refresh profile
        await loadProfile()
    }
    
    // MARK: - Link Management
    
    func saveLinks(_ links: [EditableLink]) async throws {
        guard let userId = SupabaseService.shared.currentUser?.id else {
            throw NSError(domain: "Profile", code: 401, userInfo: [NSLocalizedDescriptionKey: "Not logged in"])
        }
        
        // Delete existing links
        try await SupabaseService.shared.client.from("profile_links")
            .delete()
            .eq("user_id", value: userId.uuidString)
            .execute()
        
        // Insert new links
        let linkInserts = links.filter { !$0.url.isEmpty }.map { link in
            LinkInsert(
                userId: userId.uuidString,
                platform: link.platform.rawValue,
                url: link.url
            )
        }
        
        if !linkInserts.isEmpty {
            try await SupabaseService.shared.client.from("profile_links")
                .insert(linkInserts)
                .execute()
        }
        
        // Refresh profile
        await loadProfile()
    }
    
    private func loadMockData() {
        profile = Profile(
            id: UUID(),
            userId: UUID(),
            email: "john.doe@example.com",
            name: "John Doe",
            university: "Hong Kong University",
            bio: "Student | Deal Hunter | Study Enthusiast",
            avatarUrl: nil,
            isPremium: true,
            createdAt: Date()
        )
        
        stats = UserStats(deals: 12, sessions: 5, friends: 8)
    }
}

// MARK: - User Stats
struct UserStats {
    var deals: Int
    var sessions: Int
    var friends: Int
}

// MARK: - Profile Update (for partial updates)
struct ProfileUpdate: Codable {
    var name: String?
    var university: String?
    var bio: String?
}

// MARK: - Photo Upload
struct PhotoUpload: Codable {
    let userId: String
    let photoUrl: String
    let sortOrder: Int
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case photoUrl = "photo_url"
        case sortOrder = "sort_order"
    }
}

// MARK: - Link Insert
struct LinkInsert: Codable {
    let userId: String
    let platform: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case platform
        case url
    }
}
