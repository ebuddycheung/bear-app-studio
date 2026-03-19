import SwiftUI

struct StudyPartnerRequestView: View {
    let partner: StudyPartner
    @Environment(\.dismiss) private var dismiss
    @State private var selectedSubject: String = ""
    @State private var message: String = ""
    @State private var isSending = false
    @State private var showSuccessAlert = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Partner Card
                    HStack(spacing: 16) {
                        Circle()
                            .fill(Color(hex: "004E89"))
                            .frame(width: 60, height: 60)
                            .overlay(
                                Text(partner.name.prefix(1).uppercased())
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(partner.name)
                                .font(.headline)
                            Text(partner.university)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            if partner.isAvailable {
                                HStack(spacing: 4) {
                                    Circle()
                                        .fill(Color.green)
                                        .frame(width: 8, height: 8)
                                    Text("Available now")
                                        .font(.caption)
                                        .foregroundColor(.green)
                                }
                            }
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    
                    // Subject Selection
                    VStack(alignment: .leading, spacing: 12) {
                        Text("What would you like to study?")
                            .font(.headline)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(partner.subjects, id: \.self) { subject in
                                    SubjectChip(subject: subject, isSelected: selectedSubject == subject) {
                                        selectedSubject = subject
                                    }
                                }
                            }
                        }
                    }
                    
                    // Message
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Add a message (optional)")
                            .font(.headline)
                        
                        TextEditor(text: $message)
                            .frame(height: 100)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                    
                    // Send Button
                    Button(action: sendRequest) {
                        HStack {
                            if isSending {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Image(systemName: "paperplane.fill")
                                Text("Send Request")
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedSubject.isEmpty ? Color.gray : Color(hex: "FF6B35"))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(selectedSubject.isEmpty || isSending)
                }
                .padding()
            }
            .background(Color(hex: "F7F7F7"))
            .navigationTitle("Study Request")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Request Sent!", isPresented: $showSuccessAlert) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Your study request has been sent to \(partner.name)")
            }
        }
    }
    
    private func sendRequest() {
        isSending = true
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isSending = false
            showSuccessAlert = true
        }
    }
}

struct SubjectChip: View {
    let subject: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(subject)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color(hex: "FF6B35") : Color.white)
                .foregroundColor(isSelected ? .white : Color(hex: "004E89"))
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(hex: "FF6B35"), lineWidth: isSelected ? 0 : 1)
                )
        }
    }
}

#Preview {
    StudyPartnerRequestView(partner: StudyPartner(
        id: UUID(),
        userId: UUID(),
        name: "Alex Chen",
        university: "HKU",
        subjects: ["Math", "Physics", "Computer Science"],
        availability: "Weekdays",
        isAvailable: true
    ))
}
