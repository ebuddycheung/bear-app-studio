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

---

## 🚀 Tech Stack

| Layer | Technology |
|-------|------------|
| **Frontend** | SwiftUI (iOS 17+) |
| **Backend** | Supabase (PostgreSQL, Auth, Storage) |
| **Maps** | MapKit |
| **Payments** | Apple In-App Purchase (StoreKit 2) |
| **Build** | XcodeGen |
| **State** | SwiftUI @Observable |

---

## 📂 Project Structure

```
ios/DealBuddy/
├── DealBuddyApp.swift          # App entry point, deep links
├── Extensions/
│   ├── AppConstants.swift      # App-wide constants & colors
│   └── Color+Hex.swift         # Color extension for hex colors
├── Models/
│   ├── Deal.swift              # Deal model with categories
│   ├── Message.swift           # Chat messages
│   ├── Profile.swift           # User profile
│   ├── StudyPartner.swift      # Study partners & spots
│   └── StudyRequest.swift      # Study buddy requests
├── Services/
│   ├── DeepLinkManager.swift   # Deep link handling (dealbuddy://)
│   ├── IAPService.swift        # Apple IAP (StoreKit 2)
│   ├── LocationManager.swift   # Location services
│   ├── NotificationManager.swift # Push notifications
│   ├── Repositories.swift      # Data repositories (CRUD)
│   └── SupabaseService.swift   # Supabase client
├── ViewModels/
│   ├── AuthViewModel.swift     # Authentication state
│   ├── ChatViewModel.swift     # Chat conversations
│   ├── DiscoverViewModel.swift # Discover tab data
│   ├── FriendsViewModel.swift  # Friends management
│   ├── HomeViewModel.swift     # Home feed data
│   ├── LeaderboardViewModel.swift # Leaderboard data
│   └── ProfileViewModel.swift  # Profile data
└── Views/
    ├── ChatView.swift          # Chat list
    ├── ChatDetailView.swift    # Chat conversation detail
    ├── ContentView.swift       # Main content router
    ├── CreateDealView.swift    # Create new deal form
    ├── DealDetailView.swift    # Deal detail page with map
    ├── DiscoverView.swift      # Discover tab (categories)
    ├── FriendsView.swift       # Friends management
    ├── HomeView.swift          # Home feed
    ├── ImagePickerView.swift   # Photo picker
    ├── LeaderboardView.swift   # Leaderboards
    ├── LoginView.swift         # Login/Signup with Apple Sign In
    ├── NotificationSettingsView.swift # Push settings
    ├── PremiumUpgradeView.swift # IAP subscription UI
    ├── ProfileView.swift       # User profile (premium features)
    └── StudyPartnerRequestView.swift # Study buddy requests
```

---

## 🛠️ Setup Instructions

### Prerequisites
- Xcode 16.0+ (for Swift 5.9+ and iOS 17+)
- XcodeGen installed: `brew install xcodegen`
- Supabase account (free tier works)

### Quick Start

```bash
# 1. Navigate to project
cd /Users/ebuddycheung/.openclaw/workspace/bear-app-studio/ios

# 2. Generate Xcode project (if needed)
xcodegen

# 3. Open in Xcode
open DealBuddy.xcodeproj

# 4. Build and run on simulator
# Select iPhone simulator → Cmd+R
```

### Backend Setup

1. Create a Supabase project at [supabase.com](https://supabase.com)
2. Run `docs/SUPABASE_SETUP.md` instructions in Supabase SQL Editor
3. Update credentials in `Services/SupabaseService.swift` if needed

### App Store Setup

See `docs/APPSTORE_SETUP.md` for:
- Apple Sign In configuration
- In-App Purchase setup
- Push Notifications certificates
- App Store Connect configuration

---

## 📊 Development Status

### ✅ Completed Features

**Core**
- [x] Project structure with XcodeGen
- [x] SwiftUI views (Home, Discover, Chat, Profile, Friends, Leaderboard)
- [x] Data models matching Supabase schema
- [x] Supabase client integration (configured)
- [x] ViewModels for all screens
- [x] Repositories for data operations
- [x] Location services (MapKit)
- [x] Deal detail view with map
- [x] Settings and Edit Profile views

**Authentication**
- [x] Email/password signup & login
- [x] Apple Sign In (OAuth)
- [x] Session management
- [x] Protected routes

**Social**
- [x] Friends management (add/remove/accept)
- [x] Friends list and pending requests
- [x] Leaderboard (top deal claimers)
- [x] Home feed with deals

**Premium (IAP)**
- [x] Premium subscription (monthly $2.99, yearly $19.99)
- [x] StoreKit 2 implementation
- [x] Restore purchases
- [x] Multiple profile photos (up to 5) - PREMIUM
- [x] Custom social links - PREMIUM
- [x] Premium badge display
- [x] Early access to promoted deals

**Deals**
- [x] Browse deals by category
- [x] Deal detail with map
- [x] Create deal form
- [x] Claim deals
- [x] Share deals (deep links)

**Chat**
- [x] Chat list view
- [x] Chat detail with message bubbles
- [x] Real-time message display

**Deep Linking**
- [x] `dealbuddy://deal/{dealId}` - Open deal detail
- [x] `dealbuddy://profile/{userId}` - Open user profile
- [x] `dealbuddy://friends` - Open friends tab
- [x] `dealbuddy://leaderboard` - Open leaderboard

**Push Notifications**
- [x] Device token registration
- [x] Notification settings UI

### 🔄 In Progress
- None currently

### 📋 Planned
- [ ] Study buddy matching algorithm
- [ ] Real-time messaging (Supabase Realtime)
- [ ] Deal notifications
- [ ] Analytics (Firebase/Supabase)
- [ ] TestFlight beta testing

---

## 🔗 Key URLs

| Resource | URL |
|----------|-----|
| Supabase Dashboard | https://supabase.com/dashboard |
| App Store Connect | https://appstoreconnect.apple.com |
| Apple Developer Portal | https://developer.apple.com |

---

## 📊 Business Plan (Draft)

### Target Audience
- University/college students (18-25)
- Young professionals (21-28)

### Revenue Model
- Monthly subscription: $2.99/mo
- Yearly subscription: $19.99/yr (save 44%)
- Apple takes 30% (15% for small business)

### Success Metrics
- 1,000 downloads in Month 1
- 20% DAU
- 2-5% conversion to premium

---

*Last updated: 2026-03-20*
