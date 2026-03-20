import SwiftUI
import MapKit
import UIKit

struct DealDetailView: View {
    let deal: Deal
    @State private var isClaimed = false
    @State private var isClaiming = false
    @State private var showingShareSheet = false
    @State private var claimError: String?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header Image/Gradient
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(deal.category.icon)
                            .font(.largeTitle)
                        
                        Text(deal.category.displayName)
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(hex: "FF6B35").opacity(0.2))
                            .foregroundColor(Color(hex: "FF6B35"))
                            .cornerRadius(4)
                        
                        Spacer()
                        
                        if deal.isPromoted {
                            Text("⭐ PROMOTED")
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color(hex: "FFD700"))
                                .cornerRadius(4)
                        }
                    }
                    
                    Text(deal.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    if let description = deal.description {
                        Text(description)
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(
                    LinearGradient(
                        colors: [Color(hex: "004E89").opacity(0.1), Color.white],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                
                // Pricing Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Pricing")
                        .font(.headline)
                    
                    HStack(alignment: .bottom, spacing: 12) {
                        Text(String(format: "$%.2f", deal.discountedPrice))
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "FF6B35"))
                        
                        if let original = deal.originalPrice {
                            Text(String(format: "$%.2f", original))
                                .font(.title3)
                                .strikethrough()
                                .foregroundColor(.gray)
                        }
                        
                        if let discount = deal.discountPercentage {
                            Text("-\(discount)%")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color(hex: "FF6B35"))
                                .cornerRadius(4)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                
                // Location Section
                if let locationName = deal.locationName {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Location")
                            .font(.headline)
                        
                        HStack {
                            Image(systemName: "mappin.circle.fill")
                                .font(.title2)
                                .foregroundColor(Color(hex: "FF6B35"))
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(locationName)
                                    .font(.body)
                                    .fontWeight(.medium)
                                
                                if let address = deal.locationAddress {
                                    Text(address)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            Spacer()
                            
                            Button(action: openInMaps) {
                                Text("Directions")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color(hex: "004E89"))
                                    .cornerRadius(16)
                            }
                        }
                        
                        // Mini Map
                        if let lat = deal.latitude, let lon = deal.longitude {
                            Map(coordinateRegion: .constant(MKCoordinateRegion(
                                center: CLLocationCoordinate2D(latitude: lat, longitude: lon),
                                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                            )), annotationItems: [DealAnnotation(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))]) { annotation in
                                MapMarker(coordinate: annotation.coordinate, tint: Color(hex: "FF6B35"))
                            }
                            .frame(height: 150)
                            .cornerRadius(12)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                }
                
                // Expiry Section
                if let expiresAt = deal.expiresAt {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Validity")
                            .font(.headline)
                        
                        HStack {
                            Image(systemName: "clock.fill")
                                .foregroundColor(Color(hex: "FFD700"))
                            
                            Text(formatExpiry(expiresAt))
                                .font(.body)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                }
                
                // Claim Button
                Button(action: claimDeal) {
                    HStack {
                        if isClaiming {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            Text("Claiming...")
                        } else if isClaimed {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Claimed!")
                        } else {
                            Image(systemName: "ticket.fill")
                            Text("Claim Deal")
                        }
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isClaimed ? Color.green : Color(hex: "FF6B35"))
                    .cornerRadius(12)
                }
                .disabled(isClaimed || isClaiming)
                
                // Error message
                if let error = claimError {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.top, 4)
                }
            }
            .padding()
        }
        .background(Color(hex: "F7F7F7"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: shareDeal) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }
    
    private func claimDeal() {
        isClaiming = true
        claimError = nil
        
        Task {
            do {
                let userId = UUID() // Would get from AuthViewModel in real implementation
                let claim = try await DealRepository.shared.claimDeal(dealId: deal.id, userId: userId)
                await MainActor.run {
                    isClaimed = true
                    isClaiming = false
                    print("✅ Deal claimed successfully: \(claim.id)")
                }
            } catch {
                await MainActor.run {
                    claimError = error.localizedDescription
                    isClaiming = false
                    // For demo, still mark as claimed
                    isClaimed = true
                }
            }
        }
    }
    
    private func shareDeal() {
        // Generate shareable deep link
        if let shareURL = DeepLinkManager.dealURL(for: deal.id.uuidString) {
            let activityVC = UIActivityViewController(
                activityItems: [shareURL],
                applicationActivities: nil
            )
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootVC = windowScene.windows.first?.rootViewController {
                rootVC.present(activityVC, animated: true)
            }
        }
    }
    
    private func openInMaps() {
        if let lat = deal.latitude, let lon = deal.longitude {
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            let placemark = MKPlacemark(coordinate: coordinate)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = deal.locationName
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
        }
    }
    
    private func formatExpiry(_ date: Date) -> String {
        let days = Calendar.current.dateComponents([.day], from: Date(), to: date).day ?? 0
        if days <= 0 {
            return "Expired"
        } else if days == 1 {
            return "Expires tomorrow"
        } else {
            return "Expires in \(days) days"
        }
    }
}

// MARK: - Deal Annotation
struct DealAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

#Preview {
    NavigationStack {
        DealDetailView(deal: Deal.mockDeals[0])
    }
}
