# Product Requirements Document (PRD)

## 1. Overview

### Product Name
**DealBuddy** (Working Title)

### Type
iOS Mobile Application

### Core Functionality
A social app for young people to discover local deals/discounts and find study partners, with a simple premium subscription model for profile customization.

### Target Audience
- University/college students (18-25)
- Young professionals (21-28)
- Budget-conscious, socially active
- Value time-saving and money-saving tools

---

## 2. Problem Statement

Young users want to:
- Find nearby discounts and deals but don't know where to look
- Find study partners or co-working spots but have no easy way to connect
- Connect with friends socially but existing apps are too scattered

---

## 3. Product Vision

A one-stop app that helps young people save money on local deals and find study companions, with a simple premium model for users who want to stand out with enhanced profiles.

---

## 4. Functional Requirements

### 4.1 Authentication
- **Sign Up**: Email or phone number
- **Sign In**: Email/phone + password
- **Profile Creation**: Name, university/school, interests, profile photo

### 4.2 Deals Module
| Feature | Description |
|---------|-------------|
| Browse Deals | List of local deals sorted by distance |
| Categories | Food, Drinks, Entertainment |
| Deal Details | Title, description, original price, discounted price, expiry, location |
| Google Maps Link | Tap to open location in Google Maps |
| Claim Deal | Mark as "claimed" (social signal to friends) |
| Filter | By category, distance, expiry |

### 4.3 Study Buddy Module
| Feature | Description |
|---------|-------------|
| Find Partners | Browse users looking for study partners |
| Filter | By subject, university, availability |
| Request to Connect | Send study request |
| Study Spots | List of cafes/libraries with Google Maps link |
| Chat | In-app messaging for coordinating |

### 4.4 Social Features
| Feature | Description |
|---------|-------------|
| Friends | Add/remove friends |
| Activity Feed | See friends' claimed deals, study sessions |
| Leaderboard | Top deal hunters, study streak leaders |

### 4.5 User Profile
| Feature | Description |
|---------|-------------|
| View Profile | Name, university, bio, photo(s) |
| Edit Profile | Update info |
| My Claims | History of claimed deals |
| My Study Sessions | Past/upcoming study matches |

### 4.6 Premium Subscription
| Feature | Free | Premium |
|---------|------|---------|
| Profile Photos | 1 | Unlimited |
| Custom Links | ❌ | Instagram, Twitter, Portfolio, etc. |
| Premium Badge | ❌ | 🅿️ next to avatar |

---

## 5. Non-Functional Requirements

- **Performance**: App loads in < 2 seconds
- **Offline**: Basic caching for deals list
- **Security**: User data encrypted, secure auth
- **Analytics**: Track user behavior (optional v2)

---

## 6. Out of Scope (v1)

- Custom map integration (use Google Maps links)
- In-app payments (use Apple IAP)
- Push notifications (optional v2)
- Social posts/timeline
- Advanced matching algorithms

---

## 7. Success Metrics

- **Downloads**: Target 1,000 in first month
- **DAU**: 20% of downloads
- **Retention**: 40% Day 7, 20% Day 30
- **Premium Conversion**: 2-5% of DAU

---

## 8. Risks & Dependencies

- **Data Source**: Need source for local deals (manual entry, API, or crowdsourced)
- **User Content**: Study spots need moderation
- **Apple Review**: Ensure subscription complies with App Store guidelines

---

*Document Version: 1.0*
*Last Updated: 2026-03-19*
