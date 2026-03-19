# User Stories

## 1. Authentication

### US-001: Sign Up
**As a** new user  
**I want to** create an account with my email  
**So that** I can access the app

**Acceptance Criteria:**
- [ ] User can enter email and password
- [ ] Password must be at least 6 characters
- [ ] User receives confirmation on successful signup
- [ ] User is directed to profile setup

### US-002: Sign In
**As a** registered user  
**I want to** log in with email and password  
**So that** I can access my account

**Acceptance Criteria:**
- [ ] User can enter email and password
- [ ] Invalid credentials show error message
- [ ] Successful login redirects to home

---

## 2. Profile

### US-003: Create Profile
**As a** new user  
**I want to** set up my profile with name, university, and photo  
**So that** others can identify me

**Acceptance Criteria:**
- [ ] User can enter name (required)
- [ ] User can enter university/school (optional)
- [ ] User can upload 1 profile photo
- [ ] Profile is saved on completion

### US-004: View Own Profile
**As a** user  
**I want to** view my profile  
**So that** I can see how others see me

**Acceptance Criteria:**
- [ ] Profile shows name, university, bio
- [ ] Shows profile photo
- [ ] Shows premium badge if subscribed

### US-005: Edit Profile
**As a** user  
**I want to** edit my profile information  
**So that** I can keep it updated

**Acceptance Criteria:**
- [ ] User can change name
- [ ] User can change university
- [ ] User can change bio
- [ ] User can change profile photo

### US-006: Upgrade to Premium
**As a** free user  
**I want to** subscribe to premium  
**So that** I can add multiple photos and links

**Acceptance Criteria:**
- [ ] User can see premium features in settings
- [ ] User can initiate subscription via Apple IAP
- [ ] Payment is processed
- [ ] Premium badge appears on profile

---

## 3. Deals Module

### US-007: Browse Deals
**As a** user  
**I want to** see a list of nearby deals  
**So that** I can find discounts

**Acceptance Criteria:**
- [ ] Deals are shown in a scrollable list
- [ ] Each deal shows: title, original price, discounted price, category
- [ ] Deals are sorted by distance (nearest first)

### US-008: View Deal Details
**As a** user  
**I want to** see full details of a deal  
**So that** I can decide if I want to claim it

**Acceptance Criteria:**
- [ ] Shows full description
- [ ] Shows expiry date/time
- [ ] Shows location (address)
- [ ] "Open in Maps" button links to Google Maps

### US-009: Claim a Deal
**As a** user  
**I want to** mark a deal as claimed  
**So that** my friends can see I'm using it

**Acceptance Criteria:**
- [ ] User can tap "Claim" button
- [ ] Deal is saved to "My Claims"
- [ ] Claim appears in friends' activity feed

### US-010: Filter Deals
**As a** user  
**I want to** filter deals by category  
**So that** I can find relevant deals faster

**Acceptance Criteria:**
- [ ] Filter options: All, Food, Drinks, Entertainment
- [ ] Selecting a filter updates the list

---

## 4. Study Buddy Module

### US-011: Find Study Partners
**As a** user  
**I want to** browse users looking for study partners  
**So that** I can find someone to study with

**Acceptance Criteria:**
- [ ] List shows users with: name, university, subject
- [ ] Shows if user is available now
- [ ] Can tap to view full profile

### US-012: Request Study Connection
**As a** user  
**I want to** send a study request to another user  
**So that** we can potentially study together

**Acceptance Criteria:**
- [ ] User can tap "Request to Study"
- [ ] Request is sent to target user
- [ ] Target user receives notification (or sees in app)

### US-013: View Study Spots
**As a** user  
**I want to** see a list of study-friendly locations  
**So that** I can find a place to study

**Acceptance Criteria:**
- [ ] List shows: name, address, WiFi info
- [ ] "Open in Maps" button links to Google Maps

---

## 5. Social Features

### US-014: Add Friend
**As a** user  
**I want to** add another user as a friend  
**So that** I can see their activity

**Acceptance Criteria:**
- [ ] User can search for friends by name
- [ ] User can send friend request
- [ ] Friend request appears for recipient
- [ ] Once accepted, both see each other's activity

### US-015: View Activity Feed
**As a** user  
**I want to** see what my friends are doing  
**So that** I stay connected

**Feed shows:**
- [ ] Friends' claimed deals
- [ ] Friends' study sessions

### US-016: View Leaderboard
**As a** user  
**I want to** see top users  
**So that** I can compete with friends

**Acceptance Criteria:**
- [ ] Shows top deal hunters (most claims)
- [ ] Shows top study streaks

---

## 6. Premium Features

### US-017: Add Multiple Photos (Premium)
**As a** premium user  
**I want to** upload more than one photo to my profile  
**So that** I can showcase more of myself

**Acceptance Criteria:**
- [ ] Can add up to 5 photos
- [ ] Photos display in profile gallery

### US-018: Add Custom Links (Premium)
**As a** premium user  
**I want to** add custom links to my profile  
**So that** others can find my social media

**Acceptance Criteria:**
- [ ] Can add links: Instagram, Twitter, Portfolio, etc.
- [ ] Links appear clickable on profile

---

## 7. Settings

### US-019: Settings
**As a** user  
**I want to** access app settings  
**So that** I can manage my account

**Acceptance Criteria:**
- [ ] View/Edit Profile
- [ ] Subscription Status
- [ ] Sign Out
- [ ] Delete Account (optional v1)

---

*Document Version: 1.0*
*Last Updated: 2026-03-19*
