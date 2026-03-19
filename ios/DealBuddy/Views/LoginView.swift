import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoggedIn = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()
                
                // Logo
                VStack(spacing: 8) {
                    Text("🐻")
                        .font(.system(size: 64))
                    
                    Text("DealBuddy")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Save money, find study buddies")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Input Fields
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.gray)
                        TextField("Email", text: $email)
                            .textContentType(.emailAddress)
                            .autocapitalization(.none)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    
                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(.gray)
                        SecureField("Password", text: $password)
                            .textContentType(.password)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                
                // Sign In Button
                Button(action: {
                    isLoggedIn = true
                }) {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "FF6B35"))
                        .cornerRadius(10)
                }
                
                // Sign Up Link
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.gray)
                    
                    Button(action: {}) {
                        Text("Sign Up")
                            .fontWeight(.medium)
                            .foregroundColor(Color(hex: "FF6B35"))
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationDestination(isPresented: $isLoggedIn) {
                ContentView()
            }
        }
    }
}

#Preview {
    LoginView()
}
