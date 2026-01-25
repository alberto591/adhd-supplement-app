# App Privacy Questionnaire - Daily Stack

## Complete Guide for App Store Connect

This document provides detailed answers for the App Privacy section in App Store Connect.

---

## Data Collection Summary

### ✅ Data Types We Collect

1. **Contact Info**
   - Email Address
   
2. **Health & Fitness**
   - Health data (supplement tracking, symptom logs)
   
3. **Identifiers**
   - User ID
   
4. **Usage Data**
   - Product Interaction
   - Crash Data
   
5. **Purchases**
   - Purchase History

---

## Detailed Questionnaire Answers

### 1. Contact Info

#### Email Address
- **Do you collect?** YES
- **How is it used?**
  - ✅ App Functionality (authentication, account management)
  - ✅ Analytics (optional, can be disabled)
- **Is it linked to the user's identity?** YES
- **Do you track?** NO
- **Is collection required or optional?** REQUIRED (for account creation)

---

### 2. Health & Fitness

#### Health
- **Do you collect?** YES
- **What specifically?**
  - Supplement intake logs
  - Dosage information
  - Timing of supplement consumption
  - ADHD diagnosis type (optional)
  - Symptom check-ins (mood, focus ratings)
  
- **How is it used?**
  - ✅ App Functionality (core tracking features)
  - ✅ Analytics (usage patterns, optional)
  
- **Is it linked to the user's identity?** YES
- **Do you track?** NO
- **Is collection required or optional?** REQUIRED (core app functionality)

---

### 3. Identifiers

#### User ID
- **Do you collect?** YES
- **How is it used?**
  - ✅ App Functionality (data synchronization)
  - ✅ Analytics (optional)
  
- **Is it linked to the user's identity?** YES
- **Do you track?** NO
- **Is collection required or optional?** REQUIRED

---

### 4. Usage Data

#### Product Interaction
- **Do you collect?** YES
- **What specifically?**
  - Screens visited
  - Features used
  - Button taps
  - Time spent in app
  
- **How is it used?**
  - ✅ Analytics (improve app experience)
  - ✅ App Functionality (personalization)
  
- **Is it linked to the user's identity?** YES
- **Do you track?** NO
- **Is collection required or optional?** OPTIONAL (can disable in Settings)

#### Crash Data
- **Do you collect?** YES
- **What specifically?**
  - Crash logs
  - Device information
  - App version
  - Stack traces
  
- **How is it used?**
  - ✅ App Functionality (bug fixes, stability)
  
- **Is it linked to the user's identity?** NO (anonymized)
- **Do you track?** NO
- **Is collection required or optional?** OPTIONAL (can disable in Settings)

---

### 5. Purchases

#### Purchase History
- **Do you collect?** YES
- **What specifically?**
  - Subscription status (active/inactive)
  - Subscription tier
  - Purchase dates
  
- **How is it used?**
  - ✅ App Functionality (unlock premium features)
  
- **Is it linked to the user's identity?** YES
- **Do you track?** NO
- **Is collection required or optional?** REQUIRED (for subscription features)

---

## Data NOT Collected

We **DO NOT** collect:
- ❌ Precise Location
- ❌ Coarse Location
- ❌ Physical Address
- ❌ Phone Number
- ❌ Name (only optional display name)
- ❌ Photos or Videos
- ❌ Audio Data
- ❌ Contacts
- ❌ Browsing History
- ❌ Search History
- ❌ Financial Info (handled by Apple/Google)
- ❌ Sensitive Info (racial/ethnic data, sexual orientation, etc.)

---

## Third-Party Data Sharing

### Do you share data with third parties?

**YES** - We share with:

1. **Firebase (Google)**
   - Purpose: Authentication, database, analytics, crash reporting
   - Data: Email, User ID, Usage Data, Crash Data
   - Link: https://firebase.google.com/support/privacy

2. **RevenueCat**
   - Purpose: Subscription management
   - Data: User ID, Purchase History
   - Link: https://www.revenuecat.com/privacy

3. **Apple/Google**
   - Purpose: In-app purchases
   - Data: Purchase History (handled by platform)

### Do you sell data?
**NO** - We do not sell any user data.

---

## Privacy Practices Summary

### User Control
- ✅ Users can delete their account and all data
- ✅ Users can export their data
- ✅ Users can disable analytics
- ✅ Users can disable crash reporting

### Data Protection
- ✅ Data encrypted in transit (SSL/TLS)
- ✅ Secure authentication (Firebase Auth)
- ✅ Data stored securely (Firebase/Google Cloud)
- ✅ Regular security updates

### Transparency
- ✅ Privacy Policy available in-app
- ✅ Clear data collection disclosures
- ✅ User consent required
- ✅ Medical disclaimer provided

---

## App Store Connect Settings

### Privacy Policy URL
**Required**: Yes, provide URL to PRIVACY_POLICY.md (host on GitHub Gist, Notion, or your website)

Example GitHub Gist URL format:
```
https://gist.github.com/[username]/[gist-id]
```

### Age Rating
**Recommended**: 12+ (due to health tracking features)

### Medical Disclaimer
**Required**: Yes (already included in app and privacy policy)

---

## Quick Checklist for Submission

- [ ] Privacy Policy URL added to App Store Connect
- [ ] All data types accurately disclosed
- [ ] Third-party SDKs listed (Firebase, RevenueCat)
- [ ] User control features verified (delete account, export data)
- [ ] Medical disclaimer visible in app
- [ ] Age rating set to 12+
- [ ] Screenshots show clean status bar (no low battery, etc.)

---

**Last Updated:** January 25, 2026  
**App Version:** 2.4.1
