# App Store Setup Guide

This guide covers the Apple-specific configurations needed for DealBuddy: Apple Sign In, In-App Purchases, and Push Notifications.

---

## 📋 Prerequisites

- Apple Developer Account ($99/year): https://developer.apple.com
- App Store Connect access: https://appstoreconnect.apple.com

---

## 🍎 Step 1: Apple Sign In Setup

### 1.1 Create App ID

1. Go to [Apple Developer Portal](https://developer.apple.com)
2. Go to **Certificates, Identifiers & Profiles**
3. **Identifiers** → **+** button
4. Select **App IDs** → **App**
5. Fill in:
   - **Description**: DealBuddy
   - **Bundle ID**: `com.dealbuddy.app` (must match Xcode)
6. Under **Capabilities**, enable:
   - ✅ **Sign In with Apple**
7. Click **Continue** → **Register**

### 1.2 Configure in App Store Connect

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Select your app (or create new)
3. Go to **App Information** → **Sign In with Apple**
4. Select **Enable** for Sign In with Apple

### 1.3 Get Apple Credentials for Supabase

1. Go to [Apple Developer Portal](https://developer.apple.com) → **Certificates, Identifiers & Profiles**
2. **Keys** → **+** button
3. Configure:
   - **Key Name**: DealBuddy Sign In
   - **Sign In with Apple**: ✅ Check
4. Click **Continue** → **Register**
5. **Download** the key (save securely!)
6. Copy the **Key ID** (e.g., `XXXXXXXXXX`)

### 1.4 Add to Supabase

1. Go to Supabase → **Authentication** → **Providers** → **Apple**
2. Enable Apple Sign In
3. Fill in:
   - **Client ID (Service ID)**: Your Services ID from Apple Developer
   - **Team ID**: Your Apple Team ID
   - **Key ID**: The key ID from step 1.3
   - **Private Key**: The contents of the downloaded .p8 file (including `-----BEGIN PRIVATE KEY-----`)
4. Click **Save**

---

## 💰 Step 2: In-App Purchase Setup

### 2.1 Create Products in App Store Connect

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Select your app
3. Go to **In-App Purchases**
4. Click **+** to create new

#### Product 1: Monthly Subscription
- **Type**: Auto-Renewable Subscription
- **Reference Name**: Premium Monthly
- **Product ID**: `com.dealbuddy.premium.monthly`
- **Pricing**: Select $2.99
- **Subscription Group**: Create new group "Premium"
- **Review Information**: Screenshot + description

#### Product 2: Yearly Subscription
- **Type**: Auto-Renewable Subscription
- **Reference Name**: Premium Yearly
- **Product ID**: `com.dealbuddy.premium.yearly`
- **Pricing**: Select $19.99
- **Same Subscription Group**: "Premium"

### 2.2 Configure Subscription Group

1. In App Store Connect, go to **Subscriptions**
2. Create group "Premium" if not exists
3. Add both products to the group
4. Set up **Introductory Offer** (optional): 7-day free trial

### 2.3 Add Sandbox Tester

1. App Store Connect → **Users and Access**
2. **Sandbox** → **Testers**
3. Add test email (must be a new Apple ID)

### 2.4 Verify in Xcode

The product IDs in code must match:
```swift
// In IAPService.swift
enum ProductIdentifier: String, CaseIterable {
    case monthly = "com.dealbuddy.premium.monthly"
    case yearly = "com.dealbuddy.premium.yearly"
}
```

---

## 🔔 Step 3: Push Notifications Setup

### 3.1 Create APNs Key

1. Apple Developer Portal → **Certificates, Identifiers & Profiles**
2. **Keys** → **+** button
3. Configure:
   - **Key Name**: DealBuddy Push
   - **Apple Push Notifications service (APNs)**: ✅ Check
4. Click **Continue** → **Register**
5. **Download** the key (save! You'll need this only once)
6. Note the **Key ID**

### 3.2 Create APNs Certificate (Alternative)

If you prefer certificates instead of keys:

1. **Certificates** → **+**
2. **Apple Push Notification service SSL (Sandbox & Production)**
3. Follow instructions to create CSR
4. Download certificate
5. Convert to .p12 in Keychain Access

### 3.3 Configure in App Store Connect

1. App Store Connect → Your App → **Features**
2. **Push Notifications**
3. Upload your APNs Auth Key (.p8 file) OR certificate (.p12)
4. Select appropriate environment:
   - **Sandbox**: For testing
   - **Production**: For App Store

### 3.4 Enable in Xcode

1. Open `ios/DealBuddy.xcodeproj`
2. Select project → **Signing & Capabilities**
3. Click **+ Capability**
4. Add **Push Notifications**

### 3.5 Configure in Info.plist

Ensure `Info.plist` has:
```xml
<key>UIBackgroundModes</key>
<array>
    <string>remote-notification</string>
</array>
```

---

## 📱 Step 4: App Store Connect App Setup

### 4.1 Create App

1. [App Store Connect](https://appstoreconnect.apple.com)
2. **Apps** → **+** → **New App**
3. Fill in:
   - **Platform**: iOS
   - **Name**: DealBuddy
   - **Bundle ID**: `com.dealbuddy.app`
   - **SKU**: `com.dealbuddy.app`
   - **User Access**: Full Access

### 4.2 App Information

- **Category**: Lifestyle
- **Subcategory**: Food & Drink
- **Content Rights**: Not specified (if no copyrighted content)
- **Age Rating**: 12+ (set appropriate)

### 4.3 Prepare for Submission

1. **App Information** - Fill all required fields
2. **Pricing and Availability** - Set price tier or Free
3. **App Privacy** - Answer privacy questions
4. **Build** - Upload build from Xcode

---

## 🧪 Step 5: Testing

### Test Apple Sign In (Sandbox)

1. On device/simulator, go to **Settings** → **App Store**
2. Under **Sandbox Account**, sign in with your test Apple ID
3. In DealBuddy, tap "Sign in with Apple"
4. Use sandbox test account

### Test In-App Purchase (Sandbox)

1. Same sandbox account setup as above
2. In DealBuddy, tap "Upgrade to Premium"
3. Complete purchase
4. Should NOT charge (sandbox = free)

### Test Push Notifications (Sandbox)

1. Run app on device (not simulator)
2. Allow push permissions
3. Check console for device token
4. Use a tool like Pusher to test send

---

## 📋 Checklist

| Item | Location | Status |
|------|----------|--------|
| Bundle ID | Xcode + Developer Portal | ⬜ |
| Apple Sign In | Developer Portal + App Store Connect | ⬜ |
| Apple Sign In in Supabase | Supabase Dashboard | ⬜ |
| Monthly IAP Product | App Store Connect | ⬜ |
| Yearly IAP Product | App Store Connect | ⬜ |
| APNs Key/Certificate | Developer Portal + App Store Connect | ⬜ |
| Push Notifications Capability | Xcode | ⬜ |
| App in App Store Connect | App Store Connect | ⬜ |
| App Privacy | App Store Connect | ⬜ |

---

## 🔧 Troubleshooting

### Apple Sign In not working
- Check Bundle ID matches exactly
- Ensure Sign In with Apple capability is enabled
- Verify Supabase credentials are correct

### IAP products not showing
- Wait 10-30 minutes after creating in App Store Connect
- Check product IDs match exactly
- Ensure subscription is "Ready to Submit"

### Push notifications not receiving
- Check device token is being registered
- Verify APNs is configured correctly
- Ensure app is running on physical device (not simulator for APNs)

---

## 📎 Links

- Apple Developer Portal: https://developer.apple.com
- App Store Connect: https://appstoreconnect.apple.com
- WWDC Videos: Search "In-App Purchase" and "Sign in with Apple"

---

*Last updated: 2026-03-20*
