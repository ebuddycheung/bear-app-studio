import SwiftUI

struct CreateDealView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = CreateDealViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Deal Information") {
                    TextField("Deal Title", text: $viewModel.title)
                    
                    TextField("Description", text: $viewModel.description, axis: .vertical)
                        .lineLimit(3...6)
                    
                    Picker("Category", selection: $viewModel.category) {
                        ForEach(DealCategory.allCases, id: \.self) { category in
                            Text("\(category.icon) \(category.displayName)").tag(category)
                        }
                    }
                }
                
                Section("Pricing") {
                    HStack {
                        Text("Original Price")
                        Spacer()
                        TextField("0.00", text: $viewModel.originalPrice)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Discounted Price")
                        Spacer()
                        TextField("0.00", text: $viewModel.discountedPrice)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    if let discount = viewModel.discountPercentage {
                        Text("Discount: \(discount)%")
                            .foregroundColor(.green)
                            .font(.subheadline)
                    }
                }
                
                Section("Location") {
                    TextField("Location Name", text: $viewModel.locationName)
                    
                    TextField("Address", text: $viewModel.locationAddress)
                    
                    Toggle("Use Current Location", isOn: $viewModel.useCurrentLocation)
                }
                
                Section("Validity") {
                    DatePicker("Expires At", selection: $viewModel.expiresAt, in: Date()..., displayedComponents: .date)
                    
                    Toggle("Promote this deal ($)", isOn: $viewModel.isPromoted)
                }
                
                Section {
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("Create Deal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Post") {
                        Task {
                            await viewModel.createDeal()
                            if viewModel.isSuccess {
                                dismiss()
                            }
                        }
                    }
                    .disabled(!viewModel.isValid || viewModel.isLoading)
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.2))
                }
            }
        }
    }
}

// MARK: - Create Deal ViewModel
@MainActor
final class CreateDealViewModel: ObservableObject {
    @Published var title = ""
    @Published var description = ""
    @Published var category: DealCategory = .food
    @Published var originalPrice = ""
    @Published var discountedPrice = ""
    @Published var locationName = ""
    @Published var locationAddress = ""
    @Published var useCurrentLocation = false
    @Published var expiresAt = Date().addingTimeInterval(7 * 24 * 60 * 60) // 7 days
    @Published var isPromoted = false
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isSuccess = false
    
    var isValid: Bool {
        !title.isEmpty && !discountedPrice.isEmpty
    }
    
    var discountPercentage: Int? {
        guard let original = Double(originalPrice), let discounted = Double(discountedPrice), original > 0 else {
            return nil
        }
        return Int(((original - discounted) / original) * 100)
    }
    
    func createDeal() async {
        guard isValid else {
            errorMessage = "Please fill in required fields"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            guard let userId = SupabaseService.shared.currentUser?.id else {
                throw NSError(domain: "CreateDeal", code: 401, userInfo: [NSLocalizedDescriptionKey: "Not authenticated"])
            }
            
            var latitude: Double?
            var longitude: Double?
            
            // Get current location if enabled
            if useCurrentLocation {
                let locationManager = LocationManager.shared
                if let location = locationManager.currentLocation {
                    latitude = location.coordinate.latitude
                    longitude = location.coordinate.longitude
                }
            }
            
            // Create Deal object directly
            let deal = Deal(
                id: UUID(),
                title: title,
                description: description.isEmpty ? nil : description,
                originalPrice: Double(originalPrice),
                discountedPrice: Double(discountedPrice) ?? 0,
                category: category,
                locationName: locationName.isEmpty ? nil : locationName,
                locationAddress: locationAddress.isEmpty ? nil : locationAddress,
                latitude: latitude,
                longitude: longitude,
                expiresAt: expiresAt,
                isPromoted: isPromoted,
                createdBy: userId,
                createdAt: Date()
            )
            
            try await SupabaseService.shared.client.from("deals").insert(deal).execute()
            
            isSuccess = true
        } catch {
            errorMessage = "Failed to create deal: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}

#Preview {
    CreateDealView()
}
