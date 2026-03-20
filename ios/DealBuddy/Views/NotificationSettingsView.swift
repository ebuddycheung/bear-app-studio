import SwiftUI

struct NotificationSettingsView: View {
    @EnvironmentObject var notificationManager: NotificationManager
    @Environment(\.dismiss) var dismiss
    
    @State private var isRequestingPermission = false
    @State private var showPermissionAlert = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Image(systemName: "bell.badge.fill")
                            .font(.title)
                            .foregroundColor(Color(hex: "FF6B35"))
                        
                        VStack(alignment: .leading) {
                            Text("Push Notifications")
                                .font(.headline)
                            Text(notificationManager.isAuthorized ? "Enabled" : "Disabled")
                                .font(.subheadline)
                                .foregroundColor(notificationManager.isAuthorized ? .green : .secondary)
                        }
                        
                        Spacer()
                        
                        if notificationManager.isAuthorized {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section(header: Text("Notification Types")) {
                    Toggle("New Deals", isOn: .constant(true))
                    Toggle("Messages", isOn: .constant(true))
                    Toggle("Friend Requests", isOn: .constant(true))
                    Toggle("Study Partner Matches", isOn: .constant(true))
                    Toggle("Promotions & Offers", isOn: .constant(false))
                }
                
                Section {
                    if !notificationManager.isAuthorized {
                        Button(action: {
                            Task {
                                isRequestingPermission = true
                                let granted = await notificationManager.requestAuthorization()
                                isRequestingPermission = false
                                if !granted {
                                    showPermissionAlert = true
                                }
                            }
                        }) {
                            HStack {
                                Spacer()
                                if isRequestingPermission {
                                    ProgressView()
                                        .padding(.trailing, 8)
                                }
                                Text("Enable Notifications")
                                    .fontWeight(.semibold)
                                Spacer()
                            }
                        }
                        .disabled(isRequestingPermission)
                    } else if let token = notificationManager.deviceToken {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Device Token")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(token)
                                .font(.system(size: 10, design: .monospaced))
                                .lineLimit(2)
                                .textSelection(.enabled)
                        }
                    }
                }
                
                Section(header: Text("About")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("How it works")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text("DealBuddy uses push notifications to keep you updated about new deals, messages, and friend requests. You can customize which notifications you receive at any time.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .alert("Notifications Disabled", isPresented: $showPermissionAlert) {
                Button("Open Settings") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("To enable notifications, please open Settings and allow DealBuddy to send notifications.")
            }
            .task {
                await notificationManager.checkAuthorizationStatus()
            }
        }
    }
}

#Preview {
    NotificationSettingsView()
        .environmentObject(NotificationManager.shared)
}
