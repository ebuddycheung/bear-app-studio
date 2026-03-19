import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    
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
                                    name: conversation.participantName,
                                    message: conversation.lastMessage,
                                    initial: conversation.participantInitial,
                                    time: conversation.timeAgo,
                                    unreadCount: conversation.unreadCount
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
        }
    }
}

struct ChatRow: View {
    let name: String
    let message: String
    let initial: String
    let time: String
    let unreadCount: Int
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack(alignment: .topTrailing) {
                Circle()
                    .fill(Color(hex: "E8F4FD"))
                    .frame(width: 48, height: 48)
                    .overlay(Text(initial).font(.title3))
                
                if unreadCount > 0 {
                    Circle()
                        .fill(Color(hex: "FF6B35"))
                        .frame(width: 18, height: 18)
                        .overlay(
                            Text("\(unreadCount)")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        )
                        .offset(x: 4, y: -4)
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(name)
                        .font(.headline)
                    
                    Spacer()
                    
                    Text(time)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

#Preview {
    ChatView()
}
