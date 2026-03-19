-- DealBuddy Database Schema
-- Run this in Supabase SQL Editor

-- 1. Profiles Table
CREATE TABLE IF NOT EXISTS profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL UNIQUE,
  email TEXT,
  name TEXT,
  university TEXT,
  bio TEXT,
  avatar_url TEXT,
  is_premium BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 2. Deals Table
CREATE TABLE IF NOT EXISTS deals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT,
  original_price DECIMAL(10,2),
  discounted_price DECIMAL(10,2) NOT NULL,
  category TEXT CHECK (category IN ('food', 'drinks', 'entertainment')),
  location_name TEXT,
  location_address TEXT,
  latitude DECIMAL(10,8),
  longitude DECIMAL(11,8),
  expires_at TIMESTAMPTZ,
  is_promoted BOOLEAN DEFAULT false,
  created_by UUID,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 3. Deal Claims Table
CREATE TABLE IF NOT EXISTS deal_claims (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  deal_id UUID REFERENCES deals(id) ON DELETE CASCADE,
  user_id UUID REFERENCES profiles(user_id) ON DELETE CASCADE,
  claimed_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(deal_id, user_id)
);

-- 4. Study Partners Table
CREATE TABLE IF NOT EXISTS study_partners (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(user_id) ON DELETE CASCADE,
  subjects TEXT[], -- Array of subjects
  availability TEXT, -- e.g., "weekdays", "weekends", "anytime"
  is_available BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 5. Study Spots Table
CREATE TABLE IF NOT EXISTS study_spots (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  address TEXT,
  latitude DECIMAL(10,8),
  longitude DECIMAL(11,8),
  wifi BOOLEAN DEFAULT true,
  power_outlets BOOLEAN DEFAULT true,
  noise_level TEXT CHECK (noise_level IN ('quiet', 'moderate', 'loud')),
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 6. Friends Table
CREATE TABLE IF NOT EXISTS friends (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(user_id) ON DELETE CASCADE,
  friend_id UUID REFERENCES profiles(user_id) ON DELETE CASCADE,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'accepted')),
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(user_id, friend_id)
);

-- 7. Messages Table
CREATE TABLE IF NOT EXISTS messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  sender_id UUID REFERENCES profiles(user_id) ON DELETE CASCADE,
  receiver_id UUID REFERENCES profiles(user_id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 8. Premium Links Table (for premium users)
CREATE TABLE IF NOT EXISTS profile_links (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(user_id) ON DELETE CASCADE,
  platform TEXT NOT NULL, -- instagram, twitter, portfolio, etc.
  url TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 9. Profile Photos Table (for premium users - up to 5 photos)
CREATE TABLE IF NOT EXISTS profile_photos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(user_id) ON DELETE CASCADE,
  photo_url TEXT NOT NULL,
  sort_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE deals ENABLE ROW LEVEL SECURITY;
ALTER TABLE deal_claims ENABLE ROW LEVEL SECURITY;
ALTER TABLE study_partners ENABLE ROW LEVEL SECURITY;
ALTER TABLE study_spots ENABLE ROW LEVEL SECURITY;
ALTER TABLE friends ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE profile_links ENABLE ROW LEVEL SECURITY;
ALTER TABLE profile_photos ENABLE ROW LEVEL SECURITY;

-- RLS Policies (basic)
-- Profiles: Users can read all, update own
CREATE POLICY "Public profiles are viewable by everyone" ON profiles FOR SELECT USING (true);
CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE USING (auth.uid() = user_id);

-- Deals: Everyone can read
CREATE POLICY "Deals are viewable by everyone" ON deals FOR SELECT USING (true);

-- Profile Links: Everyone can read, users can update own
CREATE POLICY "Public profile links are viewable by everyone" ON profile_links FOR SELECT USING (true);
CREATE POLICY "Users can update own profile links" ON profile_links FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own profile links" ON profile_links FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can delete own profile links" ON profile_links FOR DELETE USING (auth.uid() = user_id);

-- Profile Photos: Everyone can read, users can update own
CREATE POLICY "Public profile photos are viewable by everyone" ON profile_photos FOR SELECT USING (true);
CREATE POLICY "Users can update own profile photos" ON profile_photos FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own profile photos" ON profile_photos FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can delete own profile photos" ON profile_photos FOR DELETE USING (auth.uid() = user_id);

-- Add your own policies as needed
