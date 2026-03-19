import SwiftUI

// MARK: - App Constants
enum AppConstants {
    // App Info
    static let appName = "DealBuddy"
    static let appVersion = "1.0.0"
    
    // Supabase Configuration (replace with actual values)
    enum Supabase {
        static let projectURL = "https://your-project.supabase.co"
        static let anonKey = "your-anon-key"
    }
    
    // API Endpoints
    enum API {
        static let defaultRadiusKm: Double = 5.0
        static let maxSearchRadiusKm: Double = 20.0
        static let pageSize = 20
    }
    
    // Animation Durations
    enum Animation {
        static let short: Double = 0.2
        static let medium: Double = 0.3
        static let long: Double = 0.5
    }
}

// MARK: - App Colors
extension Color {
    static let appPrimary = Color(hex: "FF6B35")      // Orange
    static let appSecondary = Color(hex: "004E89")    // Dark Blue
    static let appAccent = Color(hex: "FFD700")      // Gold
    static let appBackground = Color(hex: "F7F7F7")   // Light Gray
    static let appSuccess = Color.green
    static let appError = Color.red
}

// MARK: - App Typography
extension Font {
    static let appTitle = Font.largeTitle.weight(.bold)
    static let appHeadline = Font.headline
    static let appBody = Font.body
    static let appCaption = Font.caption
}

// MARK: - App Spacing
enum Spacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
}

// MARK: - App Corner Radius
enum CornerRadius {
    static let small: CGFloat = 8
    static let medium: CGFloat = 12
    static let large: CGFloat = 16
    static let pill: CGFloat = 20
}
