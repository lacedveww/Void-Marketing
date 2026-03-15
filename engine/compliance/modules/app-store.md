# Compliance Module: App Store Marketing Guidelines
# Scope: Loads for companies marketing apps on Apple App Store or Google Play Store.
# Usage: Extends `base-rules.md`. Covers marketing guidelines for mobile app promotion.
# Load when: {COMPANY_PRODUCTS} includes a mobile app distributed via Apple or Google

## 1. Apple App Store Guidelines

### 1.1 Marketing Claims

- All marketing claims about app functionality must be accurate and demonstrable
- Screenshots and preview videos must reflect the actual app experience
- Do not show features that are not available in the current app version
- Do not use placeholder or mockup data that exaggerates app capabilities
- If the app requires in-app purchases to access features shown in marketing, disclose this

### 1.2 Screenshot Requirements

- Screenshots must be taken from the actual app running on a real device or simulator
- Do not digitally alter screenshots to add features, remove UI elements, or change performance metrics
- Screenshots should represent the typical user experience, not edge cases
- If showing user-generated content in screenshots, obtain permission or use clearly fake/sample data

### 1.3 Ratings and Reviews

- Do NOT manipulate app store reviews. This includes:
  - Paying for positive reviews
  - Offering incentives (discounts, features, currency) for reviews
  - Using review farms or bots
  - Asking users to leave a specific star rating
  - Timing review prompts to target satisfied users exclusively
- You MAY ask users to leave a review using Apple's SKStoreReviewController (iOS) or Google's In-App Review API
- Do NOT redirect users to the App Store review page outside of these official APIs

### 1.4 Pricing and In-App Purchase Marketing

- Clearly communicate pricing model: free, freemium, paid, subscription
- If the app is "free" but requires in-app purchases for core functionality, marketing must not overstate the "free" nature
- Subscription terms must be clearly communicated before the user subscribes
- Auto-renewal terms must be disclosed

### 1.5 Kids Safety (if applicable)

If the app is marketed to or could be used by children (under 13 in US, under 16 in EU):
- Comply with COPPA (US), GDPR age requirements (EU), and platform-specific kids policies
- No behavioral advertising
- No data collection beyond what is necessary for app functionality
- Parental consent mechanisms required
- Apple "Kids" category has additional restrictions

## 2. Google Play Store Guidelines

### 2.1 Marketing Claims

- Same accuracy requirements as Apple: marketing must reflect actual app experience
- Google's Deceptive Behavior policy prohibits apps and marketing that "deceive, mislead, or confuse users"
- Do not make health, financial, or safety claims without appropriate disclaimers and substantiation

### 2.2 Store Listing Content

- App title, description, and icon must accurately represent the app
- Do not use keywords or metadata that are misleading or unrelated to the app
- Do not use competitor names in app title or description for the purpose of misdirection
- Promotional text must be factual and up-to-date

### 2.3 User Data Transparency

- Google requires a Data Safety section in the Play Store listing
- Marketing should be consistent with the data practices disclosed in the Data Safety section
- If marketing emphasizes privacy, the app must actually deliver on those claims

### 2.4 Ads in Marketing

- If running Google Ads for app promotion (Universal App Campaigns, etc.), ads must comply with Google's advertising policies
- Do not use misleading ad formats that mimic system notifications, error messages, or rewards
- Ad content must match the landing page / store listing experience

## 3. Cross-Platform Marketing Rules

### 3.1 Consistency

- Marketing claims must be consistent across all platforms (social media, website, app store listing)
- If a feature is available only on one platform (iOS but not Android, or vice versa), marketing must clearly indicate this

### 3.2 Beta/TestFlight Marketing

- If promoting a beta version, clearly label it as beta
- Do not use beta feedback or reviews as marketing testimonials without disclosure
- Do not market beta features as available in the production app

### 3.3 Influencer App Reviews

- All paid app reviews must be disclosed per FTC guidelines (see base-rules.md)
- Influencers must disclose if they received free access, premium features, or payment
- App review content should note if the reviewer used a different version than what is publicly available

## 4. Enforcement and Consequences

### Apple
- App removal from the App Store
- Developer account suspension or termination
- Rejection of future app submissions
- Legal action for trademark or intellectual property violations

### Google
- App removal from Google Play
- Developer account suspension
- Policy strike system: repeated violations lead to escalating consequences
- Legal action for deceptive practices

## 5. Implementation Checklist

For any app marketing content:
- [ ] All screenshots/videos reflect the actual current app?
- [ ] No exaggerated claims about functionality or performance?
- [ ] Pricing model clearly communicated?
- [ ] In-app purchase requirements disclosed?
- [ ] No review manipulation in any form?
- [ ] Consistent with app store listing content?
- [ ] Kids safety requirements met (if applicable)?
- [ ] Data practices consistent with Data Safety / Privacy Nutrition Label?
