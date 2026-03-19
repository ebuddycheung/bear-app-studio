import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @State private var selectedConversation: Conversation?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if viewModel.conversations.isEmpty {
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "message")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                        Text("No messages yet")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("Start connecting with friends!")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(viewModel.conversations) { conversation in
                                ChatRow(
                                    conversation: conversation,
                                    onTap: {
                                        selectedConversation = conversation
                                    }
                                )
                                Divider()
                                    .padding(.leading, 72)
                            }
                        }
                    }
                }
            }
            .background(Color.white)
            .navigationTitle("Chat")
            .refreshable {
                await viewModel.loadData()
            }
            .navigationDestination(isPresented: .constant(selectedConversation != nil)) {
                if let conversation = selectedConversation {
                    ChatDetailView(conversation: conversation)
                }
            }
        }
    }
}

struct ChatRow: View {
    let conversation: Conversation
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                ZStack(alignment: .topTrailing) {
                    Circle()
                        .fill(Color(hex: "E8F4FD"))
                        .frame(width: 48, height: 48)
                        .overlay(Text(conversation.participantInitial).font(.title3))
                    
                    if conversation.unreadCount > 0 {
                        Circle()
                            .fill(Color(hex: "FF6B35"))
                            .frame(width: 18, height: 18)
                            .overlay(
                                Text("\(conversation.unreadCount)")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            )
                            .offset(x: 4, y: -4)
                    }
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(conversation.participantName)
                            .font(.headline)
                        
                        Spacer()
                        
                        Text(conversation.timeAgo)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Text(conversation.lastMessage)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    ChatView()
}
