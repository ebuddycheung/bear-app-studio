# DealBuddy Architecture

This document describes the high-level architecture of the DealBuddy iOS app.

---

## 📐 Architecture Pattern

DealBuddy follows **MVVM (Model-View-ViewModel)** with SwiftUI's modern `@Observable` macro.

```
┌─────────────────────────────────────────────────────────────┐
│                         Views (SwiftUI)                      │
│  HomeView, DiscoverView, ChatView, ProfileView, etc.        │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      ViewModels (@Observable)                │
│  HomeViewModel, ChatViewModel, ProfileViewModel, etc.      │
│  - Business logic                                           │
│  - State management                                          │
│  - Data transformation                                       │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                        Services                              │
│  SupabaseService, IAPService, LocationManager,              │
│  NotificationManager, DeepLinkManager                      │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    Repositories (CRUD)                       │
│  ProfilesRepository, DealsRepository, MessagesRepository    │
│  - Data access abstraction                                  │
│  - Error handling                                           │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                         Supabase                             │
│  PostgreSQL Database, Auth, Storage, Realtime               │
└─────────────────────────────────────────────────────────────┘
```

---

## 📂 Project Structure

```
ios/DealBuddy/
├── DealBuddyApp.swift          # App entry, deep link handling
├── Extensions/                  # Utilities & constants
│   ├── AppConstants.swift      # Colors, strings, config
│   └── Color+Hex.swift         # Hex color support
├── Models/                      # Data models
│   ├── Deal.swift              # Deal with categories
│   ├── Message.swift           # Chat messages
│   ├── Profile.swift          # User profile
│   ├── StudyPartner.swift     # Study buddy
│   └── StudyRequest.swift     # Study requests
├── Services/                    # External integrations
│   ├── SupabaseService.swift   # Supabase client
│   ├── IAPService.swift        # StoreKit 2 subscriptions
│   ├── LocationManager.swift  # CoreLocation wrapper
│   ├── NotificationManager.swift # Push notifications
│   ├── DeepLinkManager.swift   # URL handling
│   └── Repositories.swift      # Data layer
├── ViewModels/                  # Business logic
│   ├── AuthViewModel.swift     # Authentication
│   ├── HomeViewModel.swift    # Home feed
│   ├── DiscoverViewModel.swift # Categories
│   ├── ChatViewModel.swift    # Messaging
│   ├── FriendsViewModel.swift # Social
│   ├── LeaderboardViewModel.swift # Gamification
│   └── ProfileViewModel.swift # User profile
└── Views/                       # SwiftUI UI
    ├── ContentView.swift       # Main router
    ├── LoginView.swift         # Auth UI
    ├── HomeView.swift          # Deal feed
    ├── DiscoverView.swift      # Browse categories
    ├── ChatView.swift          # Conversations
    ├── ChatDetailView.swift    # Message thread
    ├── ProfileView.swift       # User profile
    ├── FriendsView.swift       # Social
    ├── LeaderboardView.swift   # Rankings
    ├── DealDetailView.swift    # Deal + map
    ├── CreateDealView.swift    # New deal form
    ├── PremiumUpgradeView.swift # IAP UI
    └── ...                     # Supporting views
```

---

## 🔑 Key Components

### SupabaseService
- Singleton client for Supabase operations
- Handles auth, database, and storage
- Configured with project URL and anon key

### Repositories
Abstraction layer for CRUD operations:
- **ProfilesRepository**: User profile CRUD
- **DealsRepository**: Deal creation, listing, claiming
- **MessagesRepository**: Chat messages
- **FriendsRepository**: Friend management
- **StudyPartnersRepository**: Study buddy matching

### IAPService
- StoreKit 2 implementation
- Product IDs: `com.dealbuddy.premium.monthly`, `com.dealbuddy.premium.yearly`
- Handles purchase, validation, and restore

### DeepLinkManager
- Scheme: `dealbuddy://`
- Routes:
  - `dealbuddy://deal/{dealId}` → DealDetailView
  - `dealbuddy://profile/{userId}` → ProfileView
  - `dealbuddy://friends` → FriendsView
  - `dealbuddy://leaderboard` → LeaderboardView

---

## 🗄️ Database Schema

See [`supabase/schema.sql`](../../supabase/schema.sql) for full schema.

### Key Tables

| Table | Purpose |
|-------|---------|
| `profiles` | User data (name, university, bio, premium status) |
| `deals` | Local deals with location |
| `deal_claims` | Track claimed deals |
| `friends` | Friend relationships |
| `messages` | Chat messages |
| `study_partners` | Study buddy profiles |
| `study_spots` | Study locations |
| `profile_links` | Social links (premium) |
| `profile_photos` | Extra photos (premium) |

---

## 🔐 Security

### Row Level Security (RLS)
All tables have RLS enabled with policies:
- Users can read public data
- Users can only update their own data
- Premium features restricted by `is_premium` flag

### Authentication
- Supabase Auth (email/password)
- Apple Sign In (OAuth)
- Session tokens stored securely

### Storage
- Profile photos in dedicated bucket
- Policies restrict access appropriately

---

## 🎯 Premium Features

| Feature | Free | Premium |
|---------|------|---------|
| Profile with 1 photo | ✅ | ✅ |
| Browse deals | ✅ | ✅ |
| Claim deals | ✅ | ✅ |
| Multiple photos (up to 5) | ❌ | ✅ |
| Custom social links | ❌ | ✅ |
| Premium badge 🅿️ | ❌ | ✅ |
| Early access to promoted deals | ❌ | ✅ |

---

## 📱 Platform Requirements

- **iOS**: 17.0+
- **Swift**: 5.9+
- **Xcode**: 16.0+

---

## 🔄 Data Flow

### 1. User Opens App
```
DealBuddyApp → ContentView
    ↓
Check SupabaseService.session
    ↓
Authenticated? → HomeView : LoginView
```

### 2. Browse Deals
```
HomeView → HomeViewModel
    ↓
DealsRepository.fetchDeals()
    ↓
SupabaseService.query("deals")
    ↓
Update @Observable → View refreshes
```

### 3. Claim Deal
```
DealDetailView → DealDetailViewModel.claimDeal()
    ↓
DealsRepository.claimDeal(dealId, userId)
    ↓
SupabaseService.insert("deal_claims", ...)
    ↓
Update UI, show success toast
```

### 4. Premium Upgrade
```
PremiumUpgradeView → IAPService.purchase(product)
    ↓
StoreKit 2 transaction
    ↓
Validate receipt → Update profile.is_premium
    ↓
Enable premium features
```

---

## 🧪 Testing Strategy

See [`TEST_CASES.md`](TEST_CASES.md) for comprehensive test cases.

---

## 🚀 Deployment

1. **Development**: Debug build, test Supabase project
2. **TestFlight**: Release build, production Supabase
3. **App Store**: Release build, production everything

---

*Last updated: 2026-03-20*
