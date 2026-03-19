import SwiftUI

struct ChatView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Text("💬 Messages")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                ChatRow(
                    name: "Alex T.",
                    message: "Hey, want to study together?",
                    initial: "A",
                    time: "2m"
                )
                
                ChatRow(
                    name: "Sarah L.",
                    message: "Thanks for the deal tip!",
                    initial: "S",
                    time: "1h"
                )
                
                ChatRow(
                    name: "Mike C.",
                    message: "See you at the library!",
                    initial: "M",
                    time: "3h"
                )
                
                Spacer()
            }
            .background(Color.white)
            .navigationTitle("Chat")
        }
    }
}

struct ChatRow: View {
    let name: String
    let message: String
    let initial: String
    let time: String
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color(hex: "E8F4FD"))
                .frame(width: 48, height: 48)
                .overlay(Text(initial).font(.title3))
            
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
