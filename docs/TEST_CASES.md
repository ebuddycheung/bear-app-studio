# DealBuddy Test Cases

This document outlines comprehensive test scenarios for the DealBuddy iOS app.

---

## 📋 Test Environment

| Item | Value |
|------|-------|
| **Device** | iPhone 15 Pro Simulator |
| **iOS Version** | iOS 17.0+ |
| **Build** | Debug configuration |
| **Backend** | Supabase (staging) |

---

## 1. Authentication Tests

### 1.1 Email/Password Signup

| Test ID | Scenario | Steps | Expected Result |
|---------|----------|-------|-----------------|
| AUTH-001 | New user signup | 1. Launch app → Login tab<br>2. Enter email: `test@example.com`<br>3. Enter password: `Test123!`<br>4. Tap "Sign Up" | User created, navigate to main app |
| AUTH-002 | Invalid email format | 1. Enter invalid email `notanemail`<br>2. Tap "Sign Up" | Error: "Invalid email format" |
| AUTH-003 | Weak password | 1. Enter password `123`<br>2. Tap "Sign Up" | Error: "Password too weak" |
| AUTH-004 | Duplicate email | 1. Sign up with existing email<br>2. Tap "Sign Up" | Error: "Email already registered" |

### 1.2 Email/Password Login

| Test ID | Scenario | Steps | Expected Result |
|---------|----------|-------|-----------------|
| AUTH-101 | Valid login | 1. Enter valid credentials<br>2. Tap "Sign In" | Navigate to main app, session saved |
| AUTH-102 | Invalid password | 1. Enter wrong password<br>2. Tap "Sign In" | Error: "Invalid credentials" |
| AUTH-103 | Non-existent user | 1. Enter unregistered email<br>2. Tap "Sign In" | Error: "User not found" |
| AUTH-104 | Remember me | 1. Login successfully<br>2. Kill and relaunch app | Auto-logged in |

### 1.3 Apple Sign In

| Test ID | Scenario | Steps | Expected Result |
|---------|----------|-------|-----------------|
| AUTH-201 | New Apple user | 1. Tap "Sign in with Apple"<br>2. Complete Apple auth<br>3. Grant name/email | New account created, navigate to app |
| AUTH-202 | Existing Apple user | 1. Tap "Sign in with Apple"<br>2. Use existing Apple ID | Logged in, navigate to app |
| AUTH-203 | Apple Sign In cancel | 1. Tap "Sign in with Apple"<br>2. Cancel authentication | Stay on login screen |
| AUTH-204 | Apple name sharing | 1. Sign in with Apple<br>2. Check profile name | Name pre-filled from Apple |

---

## 2. Profile Tests

### 2.1 Profile Viewing

| Test ID | Scenario | Steps | Expected Result |
|---------|----------|-------|-----------------|
| PROFILE-001 | View own profile | 1. Log in → Profile tab | Shows avatar, name, university, bio |
| PROFILE-002 | View premium badge | 1. Login as premium user<br>2. Go to Profile | Premium badge (🅿️) displayed |
| PROFILE-003 | View free profile | 1. Login as free user<br>2. Go to Profile | No premium badge |

### 2.2 Profile Editing

| Test ID | Scenario | Steps | Expected Result |
|---------|----------|-------|-----------------|
| PROFILE-101 | Edit name | 1. Profile → Edit → Change name → Save | Name updated in profile |
| PROFILE-102 | Edit university | 1. Profile → Edit → Change university → Save | University updated |
| PROFILE-103 | Edit bio | 1. Profile → Edit → Change bio → Save | Bio updated (max 160 chars) |
| PROFILE-104 | Change avatar | 1. Profile → Edit → Tap avatar → Choose photo | Avatar updated |

### 2.3 Premium Profile Features

| Test ID | Scenario | Steps | Expected Result |
|---------|----------|-------|-----------------|
| PROFILE-201 | Add multiple photos (Premium) | 1. Premium user → Edit → Add Photos<br>2. Select up to 5 photos | Photos displayed in profile carousel |
| PROFILE-202 | Add multiple photos (Free) | 1. Free user → Edit → Add Photos | Alert: "Upgrade to Premium" |
| PROFILE-203 | Add social links (Premium) | 1. Premium → Edit → Add Link<br>2. Select platform, enter URL | Links shown on profile |
| PROFILE-204 | Add social links (Free) | 1. Free user → Edit → Add Link | Alert: "Upgrade to Premium" |
| PROFILE-205 | Reorder photos (Premium) | 1. Premium → Edit → Reorder photos | Order persists after save |

---

## 3. Deals Tests

### 3.1 Browse Deals

| Test ID | Scenario | Steps | Expected Result |
|---------|----------|-------|-----------------|
| DEAL-001 | View all deals | 1. Home tab | List of deals loaded from Supabase |
| DEAL-002 | Filter by category | 1. Discover tab → Food category | Only food deals shown |
| DEAL-003 | View deal detail | 1. Tap deal card | Navigate to DealDetailView with map |
| DEAL-004 | Deal with location | 1. Tap deal with location | Map shows deal location |

### 3.2 Create Deal

| Test ID | Scenario | Steps | Expected Result |
|---------|----------|-------|-----------------|
| DEAL-101 | Create valid deal | 1. Home → + button<br>2. Fill all required fields<br>3. Save | Deal appears in feed |
| DEAL-102 | Missing required field | 1. Create deal without title<br>2. Save | Error: "Title required" |
| DEAL-103 | Invalid price | 1. Enter negative price<br>2. Save | Error: "Invalid price" |
| DEAL-104 | Add deal location | 1. Create deal → Add location<br>2. Search/select location | Location saved |

### 3.3 Claim Deal

| Test ID | Scenario | Steps | Expected Result |
|---------|----------|-------|-----------------|
| DEAL-201 | Claim deal | 1. Deal detail → "Claim Deal" | Success toast, deal marked as claimed |
| DEAL-202 | Claim already claimed | 1. Try to claim claimed deal | Alert: "Already claimed" |
| DEAL-203 | Share deal | 1. Deal detail → Share<br>2. Choose app | Deep link copied/shared |

---

## 4. Friends Tests

### 4.1 Add Friends

| Test ID | Scenario | Steps | Expected Result |
|---------|----------|-------|-----------------|
| FRIEND-001 | Send friend request | 1. View user's profile → Add Friend | Friend request sent, button shows "Pending" |
| FRIEND-002 | Accept request | 1. Notifications → Accept request | Friend added, both can see each other |
| FRIEND-003 | Decline request | 1. Notifications → Decline | Request removed |
| FRIEND-004 | View friends list | 1. Friends tab | List of accepted friends shown |

### 4.2 Remove Friends

| Test ID | Scenario | Steps | Expected Result |
|---------|----------|-------|-----------------|
| FRIEND-101 | Remove friend | 1. Friends → Swipe to delete | Friend removed from list |
| FRIEND-102 | Unfriend removes chat | 1. Remove friend → Yes | Chat history also removed |

---

## 5. Chat Tests

### 5.1 Chat List

| Test ID | Scenario | Steps | Expected Result |
|---------|----------|-------|-----------------|
| CHAT-001 | View chat list | 1. Chat tab | Shows conversations with friends |
| CHAT-002 | Empty chat list | 1. New user with no chats | Shows "No conversations yet" |
| CHAT-003 | Unread indicator | 1. Receive message | Blue dot on chat |

### 5.2 Chat Detail

| Test ID | Scenario | Steps | Expected Result |
|---------|----------|-------|-----------------|
| CHAT-101 | Send message | 1. Open chat → Type message → Send | Message appears in chat |
| CHAT-102 | Receive message | 1. Other user sends message | Message appears in real-time |
| CHAT-103 | Message bubbles | 1. Send/receive messages | Sent: right (blue), Received: left (gray) |
| CHAT-104 | Long message | 1. Send long text | Text wraps properly |
| CHAT-105 | Empty message | 1. Try to send empty message | Send button disabled |

---

## 6. Premium Subscription Tests

### 6.1 Subscription Purchase

| Test ID | Scenario | Steps | Expected Result |
|---------|----------|-------|-----------------|
| PREMIUM-001 | View subscription options | 1. Profile → Upgrade to Premium | Shows monthly ($2.99) and yearly ($19.99) |
| PREMIUM-002 | Purchase monthly | 1. Select monthly → Confirm purchase | Apple Pay/purchase sheet → Premium activated |
| PREMIUM-003 | Purchase yearly | 1. Select yearly → Confirm purchase | Premium activated, shows savings |
| PREMIUM-004 | Purchase cancelled | 1. Start purchase → Cancel | Stay on premium screen, no charge |

### 6.2 Restore Purchases

| Test ID | Scenario | Steps | Expected Result |
|---------|----------|-------|-----------------|
| PREMIUM-101 | Restore on new device | 1. Settings → Restore Purchases | Previous purchase detected, premium restored |
| PREMIUM-102 | No purchases to restore | 1. New user → Restore | Alert: "No purchases found" |

### 6.3 Premium Features After Purchase

| Test ID | Scenario | Steps | Expected Result |
|---------|----------|-------|-----------------|
| PREMIUM-201 | Premium badge appears | 1. Purchase premium → Profile | 🅿️ badge shown |
| PREMIUM-202 | Photo upload unlocks | 1. Premium → Edit Profile | "Add Photos" option available |
| PREMIUM-203 | Links unlocks | 1. Premium → Edit Profile | "Add Link" option available |

---

## 7. Location Tests

| Test ID | Scenario | Steps | Expected Result |
|---------|----------|-------|-----------------|
| LOC-001 | Location permission denied | 1. Deny location → Open app | Show deals without location filtering |
| LOC-002 | Location permission granted | 1. Allow location → Open app | Show nearby deals |
| LOC-003 | Update location | 1. Move to new location | Deals refresh with new nearby items |

---

## 8. Deep Link Tests

| Test ID | Scenario | Steps | Expected Result |
|---------|----------|-------|-----------------|
| DL-001 | Open deal via URL | 1. Open `dealbuddy://deal/{dealId}` | Navigate to deal detail |
| DL-002 | Open profile via URL | 1. Open `dealbuddy://profile/{userId}` | Navigate to user profile |
| DL-003 | Open friends tab | 1. Open `dealbuddy://friends` | Navigate to friends tab |
| DL-004 | Open leaderboard | 1. Open `dealbuddy://leaderboard` | Navigate to leaderboard |

---

## 9. Push Notifications Tests

| Test ID | Scenario | Steps | Expected Result |
|---------|----------|-------|-----------------|
| NOTIF-001 | Notification permission | 1. First launch → Allow | Token registered with backend |
| NOTIF-002 | Notification settings | 1. Settings → Notifications | Toggle on/off |
| NOTIF-003 | Receive deal notification | 1. New deal nearby | Push notification received |

---

## 10. Leaderboard Tests

| Test ID | Scenario | Steps | Expected Result |
|---------|----------|-------|-----------------|
| LB-001 | View leaderboard | 1. Leaderboard tab | Top users by deals claimed |
| LB-001 | Your rank | 1. Scroll to bottom | Shows current user's rank |

---

## 🧪 Running Tests

### Unit Tests
```bash
# Run unit tests in Xcode
Cmd+U
```

### UI Tests (Manual)
1. Open Xcode → DealBuddy scheme
2. Select iPhone simulator
3. Follow test case steps manually

---

## 📝 Bug Reporting

When a test fails:
1. Capture screenshot
2. Note exact steps
3. Note device/iOS version
4. Note app version (in Settings)
5. Note any error messages

---

*Last updated: 2026-03-20*
