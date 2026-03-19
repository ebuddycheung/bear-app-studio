# 🐻 Bear App Studio

> iOS Apps with Subscription Model - Teddy & Ching's Business

## 📱 Our First App: DealBuddy

A social app for young people to discover local deals and find study partners.

### Problem
- Young users want to save money but don't know where to find deals
- Finding study partners is hard and time-consuming
- Existing solutions are fragmented

### Solution
- **Deals Module**: Browse local discounts, claim deals, share with friends
- **Study Buddy**: Find study partners, discover study spots
- **Social**: Friends activity, leaderboards

### Monetization
- **Free**: Basic profile (1 photo)
- **Premium ($2.99-4.99/mo)**: Multiple photos, custom links, premium badge 🅿️

### Tech Stack
- **Frontend**: SwiftUI (iOS)
- **Backend**: Supabase (PostgreSQL, Auth, Storage)
- **Maps**: MapKit integration
- **Payments**: Apple In-App Purchase

---

## 📂 Project Structure

```
ios/DealBuddy/
├── DealBuddyApp.swift          # App entry point
├── Extensions/
│   ├── AppConstants.swift      # App-wide constants & colors
│   └── Color+Hex.swift         # Color extension for hex colors
├── Models/
│   ├── Deal.swift              # Deal model with categories
│   ├── Message.swift           # Chat messages
│   ├── Profile.swift           # User profile
│   └── StudyPartner.swift      # Study partners & spots
├── Services/
│   ├── LocationManager.swift   # Location services
│   ├── Repositories.swift      # Data repositories
│   └── SupabaseService.swift   # Supabase client (configured)
├── ViewModels/
│   ├── AuthViewModel.swift     # Authentication state
│   ├── ChatViewModel.swift     # Chat conversations
│   ├── DiscoverViewModel.swift # Discover tab data
│   ├── HomeViewModel.swift     # Home feed data
│   ├── LeaderboardViewModel.swift # Leaderboard data
│   └── ProfileViewModel.swift  # Profile data
└── Views/
    ├── ChatView.swift          # Chat list
    ├── ChatDetailView.swift    # Chat conversation detail
    ├── ContentView.swift       # Main content router
    ├── CreateDealView.swift    # Create new deal form
    ├── DealDetailView.swift    # Deal detail page
    ├── DiscoverView.swift      # Discover tab
    ├── FriendsView.swift       # Friends management
    ├── HomeView.swift          # Home feed
    ├── LeaderboardView.swift   # Leaderboards
    ├── LoginView.swift         # Login/Signup
    └── ProfileView.swift       # User profile
```

---

## 🚀 Getting Started

### Prerequisites
- Xcode 16.0+
- XcodeGen installed (`brew install xcodegen`)
- Supabase account (for backend)

### Setup
1. Clone the repository
2. Run `xcodegen` in the `ios` directory
3. Open `DealBuddy.xcodeproj`
4. Configure Supabase credentials in `Services/SupabaseService.swift`
5. Run on simulator or device

### Database Setup
Run the SQL in `supabase/schema.sql` in your Supabase SQL editor.

---

## 📊 Development Status

### Completed ✅
- [x] Project structure setup with XcodeGen
- [x] SwiftUI views (Home, Discover, Chat, Profile)
- [x] Data models matching Supabase schema
- [x] Supabase client integration (with actual API keys)
- [x] ViewModels for all screens
- [x] Repositories for data operations
- [x] Location services integration
- [x] Deal detail view with map
- [x] Settings and Edit Profile views
- [x] Authentication flow (Supabase)
- [x] Friends management UI
- [x] Leaderboard view
- [x] **NEW** Create Deal view with form
- [x] **NEW** Real Supabase data fetching in Home/Discover views
- [x] **NEW** App builds successfully on iOS Simulator
- [x] **NEW** Apple Sign In integration
- [x] **NEW** Premium subscription (IAP) with StoreKit 2
- [x] **NEW** Chat detail view with message bubbles

### In Progress 🔄
- [ ] Connect to Supabase (need credentials)
- [ ] Push notifications
- [ ] Deep linking for shared deals
- [ ] Image upload for profiles

### Planned 📋
- [ ] Deep linking for shared deals

---

## 📊 Business Plan (Draft)

### Target Audience
- University/college students (18-25)
- Young professionals (21-28)

### Revenue Model
- Monthly subscription (Apple IAP)
- 70% Apple / 30% us

### Success Metrics
- 1,000 downloads in Month 1
- 20% DAU
- 2-5% conversion to premium

---

*Last updated: 2026-03-19*
