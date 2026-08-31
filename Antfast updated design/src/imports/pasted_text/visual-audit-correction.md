IMPORTANT:
Perform a COMPLETE VISUAL AUDIT AND UI CORRECTION of the ENTIRE ANTFAST mobile application.

The attached/reference PDF:
"32ec3c2a-9be1-4d62-8682-0b6fa81da93a.pdf"

is the SINGLE SOURCE OF TRUTH for the visual design.

I want the EXISTING Figma Make application to visually match the PDF as closely as possible.

DO NOT redesign the app from scratch.
DO NOT create a new design system.
DO NOT remove existing screens.
DO NOT remove existing functionality.
DO NOT change navigation/business logic unless required to make the existing screen behave like the reference.
DO NOT replace working functionality with static mockups.

This is primarily a FULL-APP VISUAL REFERENCE MATCH.

========================================================
1. FIRST — AUDIT THE ENTIRE EXISTING APPLICATION
========================================================

Before changing anything:

Inspect ALL existing screens/components/assets/routes.

The project already contains screens including:

- Onboarding
- Login
- Account Type
- Create Individual Account
- Create Business Account
- OTP
- Verify Business
- Home
- Orders
- Projects
- Saved Locations
- Create Project
- Add Location
- Project Details
- Mix Code
- Quantity
- Schedule
- Services
- Site Access
- Review Order
- Order Tracking
- Price Breakdown
- Payment Method
- Payment Confirmed
- Upload Payment Proof
- Split Wallet
- Wallet
- Terms & Conditions
- Confirmation Needed
- Delivery Scheduled
- Order Details
- Loading Completed
- Under Delivery / Live Delivery
- Site Checkpoint
- Pouring
- Assigned Resources
- Delivery Completed
- Rate Your Delivery

Keep the existing route architecture and screen functionality.

========================================================
2. PDF MUST BE THE VISUAL SOURCE OF TRUTH
========================================================

For EVERY screen:

Compare the existing implementation against the corresponding screen in the PDF.

Check:

- exact layout hierarchy
- spacing
- margins
- padding
- typography
- font weights
- font sizes
- logo size
- header positioning
- illustration size
- image positioning
- card dimensions
- card radius
- borders
- shadows
- colors
- icon sizes
- icon positioning
- button height
- button radius
- bottom navigation
- progress indicators
- chips/badges
- dividers
- form fields
- maps
- timeline components
- status indicators
- empty states
- success states
- payment states
- tracking states

Do NOT make generic improvements that are not present in the PDF.

The goal is REFERENCE MATCH, not creative redesign.

========================================================
3. GLOBAL ANTFAST VISUAL LANGUAGE
========================================================

All screens must feel like the same application.

Use the visual language from the PDF:

BACKGROUND:
- extremely light cool lavender/off-white
- almost white
- subtle blue/lavender tint

PRIMARY:
- ANTFAST blue-violet / electric purple
- use the same purple family consistently

TEXT:
- dark navy for primary text
- muted lavender/blue-gray for secondary text

CARDS:
- white / near-white
- very subtle lavender border
- soft shadow
- approximately 16–20px radius

BUTTONS:
- strong ANTFAST purple
- white text
- rounded corners
- approximately 56–60px height for major CTA buttons
- right-arrow where shown in reference

Do not introduce unrelated colors.

========================================================
4. LOGO
========================================================

Use the EXISTING ANTFAST logo asset.

DO NOT recreate the logo with text.

DO NOT replace it with another logo.

Preserve the existing logo asset and aspect ratio.

However, correct its:
- size
- position
- top spacing
- alignment

to match the PDF.

The logo should generally be centered in the mobile header unless the reference screen shows otherwise.

========================================================
5. ILLUSTRATIONS / IMAGE ASSETS
========================================================

The project already contains the reference illustration assets.

Reuse the existing assets.

Do NOT generate random replacement illustrations.

The asset library includes the onboarding truck, location, payment, login, OTP, individual/business, KYC, project, concrete, loading, delivery, payment and completed-delivery artwork.

Use the correct illustration for the correct screen.

Important:

The PDF relies heavily on large premium illustrations.

Do not make illustrations tiny.

Do not put illustrations inside unnecessary cards.

Match:
- width
- aspect ratio
- crop
- position
- fade/mask
- surrounding whitespace

from the PDF.

========================================================
6. ONBOARDING
========================================================

Match the three onboarding screens in the PDF.

SCREEN 1:
"Busy like ants.
Fast like ANTFAST."

with ready-mix truck illustration.

SCREEN 2:
"Location-Based Delivery"

with location/pin illustration.

SCREEN 3:
"Secure Payments"

with payment illustration.

Match:
- logo
- illustration scale
- heading placement
- description
- pagination/progress
- CTA
- bottom spacing

exactly to the reference style.

========================================================
7. LOGIN / ACCOUNT CREATION
========================================================

Match the PDF Login screens.

Include:
- ANTFAST logo
- appropriate login illustration
- mobile/phone field
- password/credential area if present
- primary Login button
- forgot-password/action links where shown
- Create Account CTA
- social/alternative actions only if present in reference

Account Type screen:

Match:
"How will you use ANTFAST?"

with:
- Business
- Individual

selection cards.

Create Individual Account:
Match the exact form hierarchy and illustration.

Create Business Account:
Match the exact business form hierarchy and illustration.

Do NOT merge these screens.

========================================================
8. OTP
========================================================

Match the OTP screen from PDF.

Include:
- logo
- title
- OTP input boxes
- resend timer/action
- verification illustration
- Verify CTA

Match spacing and proportions exactly.

========================================================
9. VERIFY BUSINESS
========================================================

This screen has already been identified as requiring correction.

Match the PDF/reference exactly:

- back button
- centered ANTFAST logo
- "Verify Your Business"
- "Secure company verification"
- large KYC/business verification illustration
- "1 of 3"
- progress bar
- Upload Documents
- Trade License
- VAT Certificate
- Authorized Person ID
- Company Details
- security message
- Continue
- Save and finish later

Use the existing verification artwork.

Do not shrink the illustration.

========================================================
10. HOME
========================================================

Match all Home states shown in the PDF.

The Home screen should include:

- ANTFAST header/logo
- greeting
- profile/notification actions
- primary delivery/order CTA
- large ready-mix truck artwork
- active/recent orders
- recent projects
- bottom navigation

Match the exact card hierarchy and visual density.

Do not create a generic dashboard.

========================================================
11. PROJECTS
========================================================

Match:

Projects list
Saved Locations
Create New Project
Project Details

Use the same:
- project cards
- construction images
- status badges
- location information
- progress indicators
- action buttons
- bottom navigation

The Create Project flow must visually follow the PDF sequence.

========================================================
12. LOCATION
========================================================

Match Add Location.

Use:
- large map visual
- location marker
- address card
- location fields
- Save Location CTA

Map styling should match the pale lavender/blue map treatment shown in the PDF.

========================================================
13. MIX CODE
========================================================

Match:

"Select Mix Code"

Use the exact card/list structure from the PDF.

Show:
- mix code
- concrete type
- strength/grade
- selection state
- continue CTA

Do not redesign this into a dropdown unless the PDF uses one.

========================================================
14. QUANTITY
========================================================

Match:

"Enter Quantity"

with:

- concrete cube/quantity illustration
- large quantity value
- +/- controls
- unit
- Continue button

The quantity selector must visually resemble the PDF.

========================================================
15. SCHEDULE
========================================================

Match:

"Choose Schedule"

Use the PDF's:

- date selector
- time selector
- available delivery windows
- selected state
- Continue CTA

Preserve the existing interaction.

========================================================
16. SERVICES
========================================================

Match:

"Choose Services"

including service selection cards/options.

Use the PDF's visual hierarchy and selected/unselected states.

========================================================
17. SITE ACCESS
========================================================

Match:

"Site Access Requirements"

Include:
- access requirement cards
- selected/unselected states
- notes/details where shown
- Continue CTA

========================================================
18. REVIEW ORDER
========================================================

Match the PDF Review Order screen.

Include:

- project/location
- concrete/mix information
- quantity
- schedule
- services
- site access
- price/summary
- edit actions
- final CTA

Cards must use the PDF's exact visual language.

========================================================
19. PAYMENT FLOW
========================================================

Match ALL payment-related screens:

- Price Breakdown
- Choose Payment Method
- Upload Payment Proof
- Split Wallet
- Wallet
- Payment Confirmed
- Terms & Conditions

Do not simplify these screens.

Match:
- payment cards
- wallet balance
- amount hierarchy
- selected payment method
- transaction information
- success artwork
- confirmation states

========================================================
20. ORDER SAVED / CONFIRMATION / SCHEDULING
========================================================

Match:

Order Saved
Confirmation Needed
Delivery Scheduled
Order Details

Use the PDF's success/confirmation hierarchy.

Important:

These are NOT generic success screens.

The PDF uses:
- large delivery artwork
- status badges
- order information
- schedule information
- primary actions

Match them.

========================================================
21. LIVE DELIVERY / TRACKING
========================================================

This is one of the MOST IMPORTANT areas.

Match the PDF tracking screens exactly.

Screens include:

- Loading Completed
- Under Delivery
- Site Checkpoint
- Pouring
- Assigned Resources
- Delivery Completed

The tracking screens must visually communicate real-time delivery.

Use:

- large map area
- pale map background
- construction site location
- truck markers
- route lines
- ETA badges
- resource status
- timeline/progress
- truck cards
- pump status
- checkpoint status
- bottom navigation

DO NOT replace the map with a generic blank placeholder.

Use the existing map/visual assets where available.

========================================================
22. SITE CHECKPOINT
========================================================

Match the PDF Site Checkpoint screen.

Include:

- project/order identifier
- map
- site marker
- pump
- trucks
- ETA
- checkpoint status
- truck progress
- CTA

The lower sheet/card should match the PDF's rounded bottom-sheet appearance.

========================================================
23. POURING
========================================================

Match the PDF Pouring screens.

There are multiple visual states.

Show:

- "Pouring"
- delivery in progress
- project identifier
- map
- trucks
- route
- pump
- resource status
- expected pour window
- resource sequence CTA

Use different statuses exactly as represented in the PDF.

========================================================
24. ASSIGNED RESOURCES
========================================================

Match both Assigned Resources variants.

Include:

- Pump
- active trucks
- completed trucks
- map
- Active / History tabs
- truck status cards
- timing
- Open Live Map CTA

The PDF's resource cards are compact and information-dense.

Do not make them oversized.

========================================================
25. DELIVERY COMPLETED
========================================================

Match the PDF Delivery Completed screen.

Include:

- completed status badge
- large completed-delivery illustration
- order/project identifier
- delivery summary
- concrete grade
- quantity
- pump/technician
- delivery date
- completion checklist
- documents
- Download Invoice
- Download Receipt
- Rate Delivery
- View Order Summary
- Back to Home

This should feel like a premium completion/success screen.

========================================================
26. RATE YOUR DELIVERY
========================================================

Match the final rating screen.

Include:

- back button
- notification icon
- order/project identifier
- large delivery image
- Overall Experience
- five-star rating
- individual rating categories
- optional feedback textarea
- Add photos/documents
- privacy/security helper text
- Submit Rating
- Not now

Use the PDF's exact spacing and card structure.

========================================================
27. BOTTOM NAVIGATION
========================================================

Where the PDF shows bottom navigation, use a consistent reusable component.

Match:

- icon style
- labels
- selected state
- purple active icon
- muted inactive icons
- spacing
- height
- top border/shadow

Do not create different navigation styles on different screens.

========================================================
28. HEADER SYSTEM
========================================================

Create/reuse a consistent ANTFAST header.

Depending on reference screen:

- back arrow
- centered logo
- notification icon
- page title
- project/order identifier

Do not blindly use the same header everywhere.

Follow the PDF screen by screen.

========================================================
29. RESPONSIVE MOBILE FRAME
========================================================

The target is a mobile application.

Design around approximately:

390 × 844 iPhone viewport.

Maintain safe areas:

- status bar
- bottom home indicator
- bottom navigation
- CTA spacing

Do not allow:
- buttons to touch the home indicator
- content to clip
- headers to overlap
- cards to overflow
- text to wrap unexpectedly

The application should still work on slightly smaller/larger mobile widths.

========================================================
30. TYPOGRAPHY
========================================================

Use the existing typography system.

Approximate hierarchy from PDF:

Large screen title:
28–30px bold

Section title:
18–21px semibold/bold

Card title:
15–17px semibold

Body:
13–15px

Helper text:
11–13px

Buttons:
15–16px semibold

Avoid excessive font weights.

The PDF has a clean premium fintech/construction-tech aesthetic.

========================================================
31. SPACING
========================================================

Use consistent horizontal page padding:

approximately 20–24px.

Cards:
approximately 14–20px radius.

Major vertical sections:
approximately 16–28px spacing.

Do not overcrowd the screen.

Do not introduce huge empty spaces.

The PDF uses a carefully balanced high-density mobile layout.

========================================================
32. ICONS
========================================================

Use the existing icon system/components.

Do not replace icons with emoji.

Do not randomly mix icon styles.

Icons should have consistent:
- stroke weight
- size
- purple/gray treatment

========================================================
33. EXISTING ASSETS
========================================================

The project already includes the artwork used by the reference design.

Use those assets.

The existing asset mapping includes artwork for:

- onboarding truck
- location
- payment
- login
- OTP
- individual account
- business account
- KYC
- project
- concrete
- loading
- delivery
- payment
- approved/completed states

Do not download random external stock images.

Do not generate replacement artwork unless an asset genuinely does not exist.

========================================================
34. DO NOT BREAK FUNCTIONALITY
========================================================

Preserve:

- existing navigation
- existing screen transitions
- existing state
- existing form inputs
- existing buttons
- existing interactions
- existing route IDs
- existing components where reusable

Only change implementation when required for visual parity.

If a screen is currently functional but visually wrong:
KEEP THE FUNCTIONALITY and correct the UI.

========================================================
35. COMPONENT REUSE
========================================================

Before creating new components, inspect existing reusable components.

Reuse:

- AntfastLogo
- PrimaryButton
- Illustration
- PhoneFrame
- existing navigation components
- existing icons
- existing cards
- existing form components

Create reusable components only where repeated patterns genuinely exist.

Do not duplicate the same UI implementation across screens.

========================================================
36. PRIORITY ORDER
========================================================

Prioritize corrections in this order:

1. Overall layout
2. Correct illustration/image
3. Header/logo
4. Typography
5. Cards
6. Spacing
7. Buttons
8. Icons
9. Status/badges
10. Bottom navigation
11. Minor visual polish

========================================================
37. FINAL QA
========================================================

After implementing the corrections:

Review EVERY screen against the PDF.

Do not stop after fixing Verify Business.

Check the complete flow:

Onboarding
→ Login
→ Account Type
→ Account Creation
→ OTP
→ Verify Business
→ Home
→ Projects
→ Create Project
→ Location
→ Mix Code
→ Quantity
→ Schedule
→ Services
→ Site Access
→ Review Order
→ Payment
→ Confirmation
→ Delivery Tracking
→ Site Checkpoint
→ Pouring
→ Assigned Resources
→ Delivery Completed
→ Rate Delivery

For every screen ask:

"Does this visually look like the corresponding PDF screen?"

If not, correct it.

IMPORTANT:
The PDF is the reference.
Existing functionality is the implementation baseline.
Do NOT creatively redesign.
Do NOT simplify.
Do NOT remove screens.
Do NOT replace the ANTFAST visual identity.

Make the entire application look like ONE cohesive production-ready ANTFAST app matching the supplied PDF.