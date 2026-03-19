import SwiftUI

struct ChatDetailView: View {
    let conversation: Conversation
    @State private var messageText = ""
    @State private var messages: [ChatMessage] = []
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Messages list
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(messages) { message in
                        ChatBubble(message: message)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
            
            Divider()
            
            // Message input
            HStack(spacing: 12) {
                TextField("Type a message...", text: $messageText)
                    .textFieldStyle(.plain)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color(hex: "F5F5F5"))
                    .cornerRadius(20)
                
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 18))
                        .foregroundColor(messageText.isEmpty ? .gray : Color(hex: "FF6B35"))
                }
                .disabled(messageText.isEmpty)
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(Color.white)
        }
        .navigationTitle(conversation.participantName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {}) {
                    Image(systemName: "info.circle")
                        .foregroundColor(Color(hex: "FF6B35"))
                }
            }
        }
        .onAppear {
            loadMockMessages()
        }
    }
    
    private func sendMessage() {
        guard !messageText.isEmpty else { return }
        
        let newMessage = ChatMessage(
            id: UUID(),
            content: messageText,
            isFromCurrentUser: true,
            time: "Now",
            status: .sent
        )
        
        messages.append(newMessage)
        messageText = ""
    }
    
    private func loadMockMessages() {
        messages = [
            ChatMessage(
                id: UUID(),
                content: "Hey! Want to grab lunch at the new cafe?",
                isFromCurrentUser: false,
                time: "2:30 PM",
                status: .read
            ),
            ChatMessage(
                id: UUID(),
                content: "Sure! Is it the one near campus?",
                isFromCurrentUser: true,
                time: "2:32 PM",
                status: .read
            ),
            ChatMessage(
                id: UUID(),
                content: "Yeah! They have great student discounts 🎉",
                isFromCurrentUser: false,
                time: "2:33 PM",
                status: .read
            )
        ]
    }
}

// MARK: - Chat Message
struct ChatMessage: Identifiable {
    let id: UUID
    let content: String
    let isFromCurrentUser: Bool
    let time: String
    let status: MessageStatus
}

enum MessageStatus {
    case sending
    case sent
    case read
    case delivered
}

// MARK: - Chat Bubble
struct ChatBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isFromCurrentUser {
                Spacer(minLength: 60)
            }
            
            VStack(alignment: message.isFromCurrentUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .font(.body)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        message.isFromCurrentUser 
                            ? Color(hex: "FF6B35") 
                            : Color(hex: "F0F0F0")
                    )
                    .foregroundColor(
                        message.isFromCurrentUser ? .white : .black
                    )
                    .cornerRadius(18)
                
                HStack(spacing: 4) {
                    Text(message.time)
                        .font(.caption2)
                        .foregroundColor(.gray)
                    
                    if message.isFromCurrentUser {
                        Image(systemName: message.status == .read ? "checkmark.circle.fill" : "checkmark.circle")
                            .font(.caption2)
                            .foregroundColor(message.status == .read ? Color(hex: "4CAF50") : .gray)
                    }
                }
            }
            
            if !message.isFromCurrentUser {
                Spacer(minLength: 60)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ChatDetailView(
            conversation: Conversation(
                id: UUID(),
                participantName: "Alex T.",
                participantInitial: "A",
                lastMessage: "Hey!",
                timeAgo: "2m",
                unreadCount: 1
            )
        )
    }
}
