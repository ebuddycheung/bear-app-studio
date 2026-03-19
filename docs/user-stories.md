# User Stories

## 1. Authentication

### US-001: Sign Up
**As a** new user  
**I want to** create an account with my email  
**So that** I can access the app

**Acceptance Criteria:**
- [x] User can enter email and password
- [x] Password must be at least 6 characters
- [x] User receives confirmation on successful signup
- [x] User is directed to profile setup

### US-002: Sign In
**As a** registered user  
**I want to** log in with email and password  
**So that** I can access my account

**Acceptance Criteria:**
- [x] User can enter email and password
- [x] Invalid credentials show error message
- [x] Successful login redirects to home

---

## 2. Profile

### US-003: Create Profile
**As a** new user  
**I want to** set up my profile with name, university, and photo  
**So that** others can identify me

**Acceptance Criteria:**
- [x] User can enter name (required)
- [x] User can enter university/school (optional)
- [x] User can upload 1 profile photo
- [x] Profile is saved on completion

### US-004: View Own Profile
**As a** user  
**I want to** view my profile  
**So that** I can see how others see me

**Acceptance Criteria:**
- [x] Profile shows name, university, bio
- [x] Shows profile photo
- [x] Shows premium badge if subscribed

### US-005: Edit Profile
**As a** user  
**I want to** edit my profile information  
**So that** I can keep it updated

**Acceptance Criteria:**
- [x] User can change name
- [x] User can change university
- [x] User can change bio
- [x] User can change profile photo

### US-006: Upgrade to Premium
**As a** free user  
**I want to** subscribe to premium  
**So that** I can add multiple photos and links

**Acceptance Criteria:**
- [x] User can see premium features in settings
- [x] User can initiate subscription via Apple IAP
- [x] Payment is processed
- [x] Premium badge appears on profile

---

## 3. Deals Module

### US-007: Browse Deals
**As a** user  
**I want to** see a list of nearby deals  
**So that** I can find discounts

**Acceptance Criteria:**
- [x] Deals are shown in a scrollable list
- [x] Each deal shows: title, original price, discounted price, category
- [x] Deals are sorted by distance (nearest first)

### US-008: View Deal Details
**As a** user  
**I want to** see full details of a deal  
**So that** I can decide if I want to claim it

**Acceptance Criteria:**
- [x] Shows full description
- [x] Shows expiry date/time
- [x] Shows location (address)
- [x] "Open in Maps" button links to Google Maps

### US-009: Claim a Deal
**As a** user  
**I want to** mark a deal as claimed  
**So that** my friends can see I'm using it

**Acceptance Criteria:**
- [x] User can tap "Claim" button
- [x] Deal is saved to "My Claims"
- [x] Claim appears in friends' activity feed

### US-010: Filter Deals
**As a** user  
**I want to** filter deals by category  
**So that** I can find relevant deals faster

**Acceptance Criteria:**
- [x] Filter options: All, Food, Drinks, Entertainment
- [x] Selecting a filter updates the list

---

## 4. Study Buddy Module

### US-011: Find Study Partners
**As a** user  
**I want to** browse users looking for study partners  
**So that** I can find someone to study with

**Acceptance Criteria:**
- [x] List shows users with: name, university, subject
- [x] Shows if user is available now
- [x] Can tap to view full profile

### US-012: Request Study Connection
**As a** user  
**I want to** send a study request to another user  
**So that** we can potentially study together

**Acceptance Criteria:**
- [x] User can tap "Request to Study"
- [x] Request is sent to target user
- [x] Target user receives notification (or sees in app)

### US-013: View Study Spots
**As a** user  
**I want to** see a list of study-friendly locations  
**So that** I can find a place to study

**Acceptance Criteria:**
- [x] List shows: name, address, WiFi info
- [x] "Open in Maps" button links to Google Maps

---

## 5. Social Features

### US-014: Add Friend
**As a** user  
**I want to** add another user as a friend  
**So that** I can see their activity

**Acceptance Criteria:**
- [x] User can search for friends by name
- [x] User can send friend request
- [x] Friend request appears for recipient
- [x] Once accepted, both see each other's activity

### US-015: View Activity Feed
**As a** user  
**I want to** see what my friends are doing  
**So that** I stay connected

**Feed shows:**
- [x] Friends' claimed deals
- [x] Friends' study sessions

### US-016: View Leaderboard
**As a** user  
**I want to** see top users  
**So that** I can compete with friends

**Acceptance Criteria:**
- [x] Shows top deal hunters (most claims)
- [x] Shows top study streaks

---

## 6. Premium Features

### US-017: Add Multiple Photos (Premium)
**As a** premium user  
**I want to** upload more than one photo to my profile  
**So that** I can showcase more of myself

**Acceptance Criteria:**
- [x] Can add up to 5 photos
- [x] Photos display in profile gallery
- [x] Can delete photos

### US-018: Add Custom Links (Premium)
**As a** premium user  
**I want to** add custom links to my profile  
**So that** others can find my social media

**Acceptance Criteria:**
- [x] Can add links: Instagram, Twitter, Portfolio, etc.
- [x] Links appear clickable on profile

---

## 7. Settings

### US-019: Settings
**As a** user  
**I want to** access app settings  
**So that** I can manage my account

**Acceptance Criteria:**
- [x] View/Edit Profile
- [x] Subscription Status
- [x] Sign Out
- [ ] Delete Account (optional v1)

---

*Document Version: 1.0*
*Last Updated: 2026-03-19*
