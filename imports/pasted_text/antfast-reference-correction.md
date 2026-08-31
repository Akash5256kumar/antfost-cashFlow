# ANTFAST — Pixel-Accurate Reference Correction Prompt

Use the supplied ANTFAST reference PDF as the **single and absolute source of truth** for the entire application.

Do NOT redesign the application.

Do NOT modernize it.

Do NOT invent a new visual language.

Do NOT simplify the screens.

Do NOT replace the supplied illustrations, maps, vehicle imagery, logos, icons, text hierarchy, or layouts unless the reference itself requires it.

Your task is to **correct the existing Figma Make implementation so that every screen matches the supplied reference PDF as closely as possible.**

## 1. PRIMARY TARGET

The target is a real mobile application viewport:

* 390 × 844 px
* iPhone-style screen
* edge-to-edge mobile composition
* safe-area aware
* no desktop-style scaling
* no excessive empty canvas surrounding the phone
* UI should visually fill the 390 × 844 viewport
* preserve the iOS status bar and bottom home indicator treatment shown in the reference

The current implementation must NOT make the actual application content appear like a tiny phone floating inside a large empty lavender canvas.

The mobile UI itself must occupy the complete target viewport.

## 2. REFERENCE DESIGN SYSTEM

Match the reference exactly:

Background:

* very light lavender
* approximately #F5F4FA

Primary:

* strong purple
* approximately #5B4BE0

Typography:

* dark navy/black primary text
* muted gray-purple secondary text
* strong bold headings
* compact labels
* consistent hierarchy

Components:

* white cards
* subtle borders
* soft shadows
* rounded cards
* rounded input fields
* rounded purple primary buttons
* thin purple outlines for secondary buttons
* minimal line icons
* small status badges
* compact spacing
* iOS-style visual rhythm

Do not introduce:

* gradients that don't exist in the reference
* glassmorphism
* excessive shadows
* excessive rounded containers
* oversized typography
* generic SaaS dashboard styling
* unrelated colors
* generic stock imagery

## 3. FIX THE MOBILE SCALE FIRST

This is the highest-priority correction.

The current preview makes the mobile UI visually too small relative to the available canvas.

Correct the application shell so:

* the application renders as a true 390 × 844 mobile viewport
* every screen uses the full available mobile height
* horizontal padding matches the reference
* content is not artificially scaled down
* no transform/zoom is applied to the entire application
* no unnecessary outer wrapper shrinks the mobile application
* scrolling happens INSIDE the mobile screen where required
* bottom navigation remains inside the mobile viewport
* CTA buttons remain positioned according to the reference

The Figma Make preview/editor canvas may contain surrounding workspace, but the actual application viewport must remain exactly 390 × 844.

## 4. ONBOARDING

Match the reference onboarding screens exactly.

Use the supplied ANTFAST logo and supplied illustrations.

Each onboarding screen should contain:

* iOS status bar
* ANTFAST logo
* reference illustration
* exact headline hierarchy
* exact supporting text
* pagination indicator
* primary CTA
* bottom safe-area/home indicator

The illustration should have the same visual size and vertical position as the reference.

Do not shrink the complete onboarding composition.

## 5. LOGIN

Recreate both login states shown in the reference:

Business selected:

* ANTFAST logo
* depot/construction illustration
* Login heading
* supporting text
* Business / Individual segmented selector
* Business Username field
* Password field
* Forgot Password
* purple Login button
* OR divider
* Create Account outline button
* Try Our Demo outline button

Individual selected:

* same structure
* Mobile Number or Username field
* Individual selected state

Match:

* field heights
* border radius
* icon placement
* text sizes
* spacing
* button heights
* selector proportions
* illustration scale

## 6. ACCOUNT TYPE

Match the reference Create Account screen:

Header:

* back icon
* Create Account
* Step 1 of 3

Heading:

* How will you use ANTFAST?

Cards:

* Business
* Individual

Selected card:

* purple border
* selected radio/check state
* correct icon
* correct description

Unselected card:

* white card
* subtle border
* neutral radio

Bottom:

* full-width purple Continue button

## 7. REGISTRATION

Create Individual Account and Create Business Account must match the supplied screens.

Individual:

* reference house/construction illustration
* Full Name
* Mobile Number
* Username
* Password
* Confirm Password
* account terms checkbox
* Create Account CTA

Business:

* reference business/depot illustration
* Company Name
* Business Username
* Registered Mobile
* Password
* Confirm Password
* Create Account CTA

Preserve the reference vertical hierarchy and compact spacing.

## 8. OTP

Match the OTP Verification reference:

* back button
* ANTFAST branding
* OTP Verification title
* explanatory text
* phone number card
* six OTP cells
* countdown
* resend state
* reference envelope/security illustration
* Verify OTP button

Do not use a generic OTP design.

## 9. PROJECTS / HOME / SAVED LOCATIONS

Match the reference dashboard and project-management screens.

Use the supplied project photographs and illustrations.

Project cards must preserve:

* image ratio
* title
* location
* order count
* location count
* status
* progress indicator
* chevron

Bottom navigation must match:

* Home
* Orders
* Projects
* Wallet
* Profile

Selected tab:

* purple icon
* purple label

Unselected:

* muted icon/label

## 10. CREATE NEW PROJECT

Match:

* App header
* ANTFAST logo
* project illustration
* Project Details section
* Project Name
* Project Type
* Residential
* Commercial
* Industrial
* Infrastructure
* Locations section
* Add Location CTA
* bottom navigation

Do not redesign the project-type selector.

## 11. ORDER CREATION FLOW

Preserve the exact step structure shown in the reference:

Project
→ Mix Code
→ Quantity
→ Schedule
→ Services
→ Site Access
→ Review

The progress rail must remain visually consistent across all order screens.

### Mix Code

Match:

* C30/37
* C40/50
* C25/30
* descriptions
* aggregate size
* slump
* concrete illustration
* selection state

### Quantity

Match:

* Enter Quantity
* concrete illustration
* quantity control
* m³ unit
* increment/decrement controls
* CTA positioning

### Schedule

Match:

* date selector
* delivery window cards
* time ranges
* selected state
* illustration
* CTA

## 12. SERVICES

The reference Services screen is information-dense.

Do NOT simplify it.

Preserve:

* Slab / Raft / Pile / Column choices
* Concrete Pump
* pump size selection
* Technician
* Cube Mould Quantity
* Laboratory Testing
* Other Approved Services
* expandable sections
* checkboxes
* radio buttons
* service cards
* reference imagery
* Continue to Site Access CTA

## 13. SITE ACCESS

Match all reference sections:

* Narrow Access
* Road Permit Required
* Boom Reach Restriction
* Night Delivery Access

Each section should have:

* icon
* heading
* supporting description
* Yes / No controls
* expanded content where shown

Preserve the PDF's exact information density.

## 14. REVIEW

Match the Review Order screen:

* progress rail
* project & location
* mix & quantity
* schedule
* services
* site access
* attachments
* edit icons
* checkbox
* Continue button

Do not convert this into a generic checkout screen.

## 15. KYC STATE

Support both flows shown in the reference.

### KYC under review

Show:

* Order Saved
* Verification in review
* order summary
* KYC status
* View Saved Order
* Back to Home

### Approved KYC

Continue from Review Order to:

* Choose Payment Method
* Complete Payment
* Price Breakdown
* Terms & Conditions
* Payment Confirmed

These must be visually consistent with the supplied reference.

## 16. PAYMENT

Match payment screens exactly.

Payment methods:

* Wallet
* Card / Payment Link
* Bank Transfer
* Cash in Advance

Selected state:

* purple border
* purple radio
* correct card appearance

Complete Payment:

* amount
* card illustration
* card number
* expiry
* CVV
* secure payment indication
* Pay button

Price Breakdown:

* Concrete
* Concrete Pump
* Technician & Cube Mould
* Payment Method Charge
* Subtotal
* VAT
* Total

## 17. TERMS & CONDITIONS

Match the reference:

* Terms & Conditions heading
* expandable sections
* Order Request & Pricing
* Payment
* Site Readiness
* Delivery & Delays
* Cancellation & Refunds
* agreement checkbox
* disabled/enabled Continue state

Do not replace this with generic legal text layout.

## 18. PAYMENT CONFIRMED

Match:

* Payment Confirmed
* success state
* ANTFAST illustration
* total amount
* order information
* payment method
* reference number
* View Order Status
* Download Receipt
* Back to Home

## 19. DELIVERY STATES

Implement the reference delivery states accurately:

### Confirmation Needed

* confirmation badge
* order summary
* requested vs ANTFAST proposal
* delivery time
* price information
* Accept Proposal
* Request Change

### Delivery Scheduled

* scheduled badge
* delivery image
* scheduled time
* quantity
* mix
* interval
* pump + technician
* estimated supply window
* notification option
* View Order Details

### Order Details

* loading state
* quantity
* delivery timeline
* pump + trucks
* View Order Status

## 20. LIVE DELIVERY

Match the supplied live delivery screens.

Preserve:

* map
* truck markers
* route
* project/location marker
* truck list
* truck status
* ETA
* bottom navigation
* View Site Progress

Do not substitute a generic Google Maps layout.

The supplied visual language must remain intact.

## 21. SITE CHECKPOINT / POURING

Recreate:

* Site Checkpoint
* Pouring
* assigned truck progress
* map
* truck list
* current status
* progress timeline
* expected pour window
* View All Trucks
* View Site Progress

These screens should feel like the same application, not separate dashboard pages.

## 22. ASSIGNED RESOURCES

Match:

* Pump + Active Trucks
* map
* active/history tabs
* pump information
* truck list
* truck status
* Open Live Map

## 23. DELIVERY COMPLETED

Final screen must match the reference:

* Delivery Completed
* Completed badge
* project image
* order summary
* quantity
* pump
* truck/driver information
* delivery timeline
* documents
* Download Invoice
* Delivery Receipt
* Rate Delivery
* View Order Summary
* Back to Home

## 24. IMAGE RULE

Use the supplied reference assets already available in the project.

Do not replace them with:

* Unsplash
* random stock images
* generated generic construction photos
* unrelated illustrations

The existing asset mapping should be preserved where it matches the reference.

## 25. COMPONENT CONSISTENCY

Create/reuse shared components for:

* AppHeader
* BottomNav
* PrimaryButton
* Input fields
* Cards
* Status badges
* Radio controls
* Checkbox controls
* Step progress rail
* Section headers
* Map containers
* Order cards
* Project cards

But shared components must reproduce the reference appearance rather than forcing every screen into an identical generic component.

## 26. RESPONSIVE BEHAVIOR

Primary target:

390 × 844

Also ensure the design behaves correctly around:

* 375 × 812
* 393 × 852
* 430 × 932

Do not allow text, buttons, images or cards to overflow.

## 27. IMPORTANT CURRENT-PROJECT CORRECTION

The current implementation already contains the major application screens and reusable components.

Do NOT throw away the existing project.

Modify the existing implementation incrementally.

Preserve:

* existing navigation
* existing screen structure
* existing supplied assets
* existing reusable components

Focus on visual correction and reference fidelity.

## 28. FINAL VALIDATION

Before considering the work complete, compare every screen against the supplied PDF.

Check:

1. Overall mobile scale
2. Header position
3. Logo size
4. Illustration size
5. Heading position
6. Typography
7. Card dimensions
8. Input dimensions
9. Button dimensions
10. Spacing
11. Border radius
12. Shadows
13. Icon placement
14. Bottom navigation
15. Safe-area spacing
16. Scroll behavior
17. Selected/unselected states
18. Progress indicators
19. Map composition
20. Information density

The goal is **reference fidelity, not creative interpretation**.

Do not stop after correcting only the onboarding/login screens.

Apply the corrections across the complete application flow represented in the supplied reference PDF.
