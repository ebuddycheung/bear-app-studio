import SwiftUI

struct EmptyStateView: View {
    enum EmptyStateType {
        case deals
        case friends
        case chat
    }
    
    let type: EmptyStateType
    var onAction: (() -> Void)?
    
    var imageName: String {
        switch type {
        case .deals: return "EmptyDeals"
        case .friends: return "EmptyFriends"
        case .chat: return "EmptyFriends"
        }
    }
    
    var title: String {
        switch type {
        case .deals: return "No Deals Yet"
        case .friends: return "No Friends Yet"
        case .chat: return "No Messages"
        }
    }
    
    var subtitle: String {
        switch type {
        case .deals: return "Be the first to share a deal!"
        case .friends: return "Add friends to see them here"
        case .chat: return "Start a conversation"
        }
    }
    
    var actionTitle: String? {
        switch type {
        case .deals: return "Create Deal"
        case .friends: return "Find Friends"
        case .chat: return nil
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 200, maxHeight: 200)
                .opacity(0.8)
            
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text(subtitle)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            if let actionTitle = actionTitle, let onAction = onAction {
                Button(action: onAction) {
                    Text(actionTitle)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(Color(hex: "FF6B35"))
                        .cornerRadius(10)
                }
                .padding(.top, 8)
            }
        }
        .padding(40)
    }
}

#Preview("Deals") {
    EmptyStateView(type: .deals)
}

#Preview("Friends") {
    EmptyStateView(type: .friends)
}
