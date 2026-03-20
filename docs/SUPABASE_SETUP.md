# Supabase Setup Guide

This guide walks you through setting up Supabase backend for DealBuddy.

---

## 📋 Prerequisites

- Supabase account (free tier works): https://supabase.com
- Your Supabase project URL and keys

---

## 🚀 Step 1: Create Supabase Project

1. Go to [supabase.com](https://supabase.com) and sign in
2. Click **"New Project"**
3. Fill in details:
   - **Name**: `dealbuddy` (or your preferred name)
   - **Database Password**: Create a strong password (save this!)
   - **Region**: Select closest to your users (e.g., `Northeast Asia (Tokyo)`)
4. Click **"Create new project"**
5. Wait 1-2 minutes for setup to complete

---

## 🔑 Step 2: Get Your Credentials

Once your project is ready:

1. Go to **Settings** (⚙️ icon) → **API**
2. Copy the following:
   - **Project URL**: `https://xxxxx.supabase.co`
   - **anon public key**: `eyJxxxxx...` (long string)

You'll need these for:
- iOS app: `ios/DealBuddy/Services/SupabaseService.swift`

---

## 🗄️ Step 3: Create Database Schema

1. In Supabase dashboard, click **SQL Editor** in sidebar
2. Click **"New query"**
3. Copy the contents of `supabase/schema.sql`
4. Paste into the SQL Editor
5. Click **"Run"** (or press Cmd+Enter)

### Expected Result
You should see messages like:
```
CREATE TABLE
 NOTICE: CREATE TABLE will create implicit "profiles" for ROW SECURITY
 ALTER TABLE
```

---

## 🪣 Step 4: Set Up Storage (for Profile Photos)

1. Go to **Storage** in the sidebar
2. Click **"New bucket"**
3. Fill in:
   - **Name**: `profile-photos`
   - **Public bucket**: ✅ Toggle ON
4. Click **"Create bucket"**

### Add Storage Policies

1. Click on the new `profile-photos` bucket
2. Go to **Policies** tab
3. Add policies:

```sql
-- Allow public read access
CREATE POLICY "Public Access" 
ON storage.objects FOR SELECT 
USING ( bucket_id = 'profile-photos' );

-- Allow authenticated users to upload
CREATE POLICY "Auth Upload" 
ON storage.objects FOR INSERT 
WITH CHECK ( bucket_id = 'profile-photos' AND auth.role() = 'authenticated' );

-- Allow users to delete their own files
CREATE POLICY "Owner Delete" 
ON storage.objects FOR DELETE 
USING ( bucket_id = 'profile-photos' AND auth.uid()::text = (storage.foldername(name))[1] );
```

---

## 🔐 Step 5: Configure Authentication

### Enable Email Auth

1. Go to **Authentication** → **Providers**
2. Ensure **Email** is enabled (it is by default)

### Enable Apple Sign In

1. Go to **Authentication** → **Providers**
2. Click **Apple**
3. Toggle **Enable Apple**
4. You'll need:
   - **Services ID**: From Apple Developer Portal
   - **Team ID**: Your Apple Developer Team ID
   - **Key ID**: Generated key ID
   - **Private Key**: Downloaded .p8 file

*(See APPSTORE_SETUP.md for Apple Developer setup)*

### Configure Redirect URLs

1. Go to **Authentication** → **URL Configuration**
2. Add your redirect URL:
   ```
   dealbuddy://oauth-callback
   ```

---

## 📱 Step 6: Update iOS App

Open `ios/DealBuddy/Services/SupabaseService.swift` and update:

```swift
struct SupabaseCredentials {
    static let projectUrl = "https://YOUR_PROJECT.supabase.co"
    static let anonKey = "YOUR_ANON_KEY"
}
```

---

## ✅ Step 7: Verify Setup

### Test Database Connection

1. Open iOS app in Xcode
2. Build and run on simulator
3. Try creating a test account
4. Check Supabase **Table Editor** → `profiles` table
5. You should see your new user!

### Test Storage

1. Upload a profile photo in the app
2. Go to Supabase **Storage** → `profile-photos` bucket
3. You should see the uploaded file!

---

## 🔧 Troubleshooting

### "Invalid API key" error
- Check your anon key is correct in `SupabaseService.swift`
- Make sure there are no extra spaces

### "Row Level Security" errors
- Go to your table in Supabase
- Check **Policies** tab
- Ensure RLS policies allow your operation

### "Bucket not found" error
- Verify storage bucket name matches code
- Check bucket is marked as public

### Can't sign up / sign in
- Check **Authentication** → **Providers** → **Email** is enabled
- Check redirect URL is configured

---

## 📊 What's Created

| Table | Purpose |
|-------|---------|
| `profiles` | User profiles (name, university, bio, premium status) |
| `deals` | Local deals and discounts |
| `deal_claims` | Track which users claimed which deals |
| `study_partners` | Study buddy matching |
| `study_spots` | Study location recommendations |
| `friends` | Friend relationships |
| `messages` | Chat messages |
| `profile_links` | Social links (premium feature) |
| `profile_photos` | Additional photos (premium feature) |

---

## 🔄 Updating Schema Later

To modify the database:
1. Go to **SQL Editor**
2. Write your ALTER TABLE or UPDATE statements
3. Run them
4. Changes apply immediately

---

## 📞 Need Help?

- Supabase Docs: https://supabase.com/docs
- Community: https://github.com/supabase/supabase/discussions

---

*Last updated: 2026-03-20*
