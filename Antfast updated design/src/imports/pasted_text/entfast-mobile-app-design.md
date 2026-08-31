# Figma AI Master Prompt — EntFast Mobile App

Design and recreate the mobile application shown in the supplied reference screens and flow document.

The reference document is the SINGLE SOURCE OF TRUTH for the UI design.

Do NOT create a new visual style.
Do NOT modernize the design.
Do NOT replace the supplied imagery.
Do NOT invent different layouts.
Do NOT use generic stock images.
Do NOT change the brand identity.

The objective is to recreate the supplied application screens as accurately as possible in Figma while converting the UI into a professional, reusable component system.

## 1. DESIGN TARGET

Create a polished iOS-style mobile application using the exact visual language of the supplied reference screens.

Use:

* Mobile frame: 390 × 844 px
* iPhone-style viewport
* Safe-area aware layouts
* Rounded cards
* Soft lavender/very-light background
* White content cards
* Strong purple primary CTA
* Dark navy/black typography
* Subtle gray secondary text
* Light borders
* Soft shadows
* Rounded input fields
* Rounded buttons
* Minimal line icons
* Clean logistics/delivery imagery
* Maps and vehicle tracking UI
* Fixed bottom navigation

The final result must visually feel like the SAME application shown in the reference document.

## 2. BRAND

Use the supplied EntFast logo exactly as shown in the references.

Do not redraw or reinterpret the logo.

Maintain the same:

* Logo proportions
* Logo placement
* Logo colors
* Typography relationship
* Icon relationship
* Header spacing

The logo should normally appear centered in onboarding/authentication screens and in the appropriate header position on application screens.

## 3. COLOR SYSTEM

Create Figma color styles/tokens.

Primary:

* Brand Purple: use the exact purple sampled from the reference UI
* Dark Navy: use the exact dark text color from the references
* White: #FFFFFF
* Background: very light lavender/gray matching the references

Supporting colors:

* Success green
* Warning/orange
* Error/red
* Muted gray
* Border gray
* Map/light geographic gray

IMPORTANT:

Do not arbitrarily select a new purple.

Sample the primary purple directly from the supplied screenshots.

The same applies to the background, text, borders and status colors.

## 4. TYPOGRAPHY

Use a modern clean sans-serif font matching the reference.

Create reusable text styles:

* Display / onboarding heading
* Screen title
* Section heading
* Card title
* Body
* Secondary body
* Caption
* Label
* Button
* Navigation label
* Price/amount
* Status text

Use typography hierarchy similar to the references.

Headings should be bold/semi-bold.

Body text should be regular.

Do not overuse bold typography.

Maintain the same compact mobile typography and spacing visible in the supplied screens.

## 5. SPACING SYSTEM

Create an 8px-based spacing system.

Use approximately:

4px
8px
12px
16px
20px
24px
32px
40px

Maintain consistent horizontal screen padding.

Most screens should use approximately 20–24px horizontal margins, matching the reference screenshots.

## 6. CORNER RADIUS

Create reusable radius tokens.

Use:

* Small controls: 8–10px
* Inputs: 10–12px
* Cards: 12–16px
* Primary buttons: approximately 10–14px
* Large illustration containers: 16–24px
* Bottom sheets: large top radius

Do not introduce sharp rectangular UI where the reference uses rounded components.

## 7. PRIMARY BUTTON

Create a reusable Primary Button component.

Structure:

[ Button label                              → ]

Characteristics:

* Full-width
* Purple background
* White text
* Rounded corners
* Medium/bold text
* Consistent height
* Optional right arrow icon
* Pressed/disabled/loading states

Use this same component throughout the application.

Examples:

Continue
Get Started
Create New Project
Continue with Vehicle
Continue to Payment
Pay
Track Delivery
Confirm
Submit
View Details

## 8. BOTTOM NAVIGATION

Create a reusable fixed bottom navigation component.

The reference application uses a minimal bottom navigation system with:

* Home
* Projects
* Orders
* Resources/profile-related section

Use line-style icons.

Active navigation item:

* Purple icon
* Purple label where applicable

Inactive:

* Muted gray

Keep the navigation visually lightweight.

Do not create a heavy dark navigation bar.

## 9. HEADER

Create reusable application headers.

Header variants:

### Standard Header

* Back button where required
* Center/left aligned title
* Optional right-side action

### Branded Header

* EntFast logo
* Minimal navigation/action icons

### Tracking Header

* Back button
* Delivery/order title
* Status information

Maintain the exact spacing and alignment from the references.

---

# 10. ONBOARDING SCREENS

Recreate the onboarding screens from the references.

Use the SAME supplied illustrations and vehicle/construction imagery.

Do not replace the images.

Layout:

Top:

* Status bar
* Brand logo

Middle:

* Large illustration/image
* Supporting visual elements

Lower section:

* Large heading
* Supporting text
* Primary CTA

Use generous whitespace.

The onboarding screens should feel premium, clean and trustworthy.

---

# 11. LOGIN SCREEN

Recreate the login screen from the supplied reference.

Include:

* EntFast logo
* Welcome/login heading
* Email/mobile input
* Password input
* Password visibility icon
* Login CTA
* Forgot password
* Account creation link
* Supporting authentication elements exactly as shown

Use reusable input components.

Input component:

Label
Input field
Optional icon
Optional validation/error message

States:

* Default
* Focused
* Filled
* Error
* Disabled

---

# 12. OTP VERIFICATION

Recreate the OTP screen.

Include:

* Back navigation
* EntFast branding
* OTP heading
* Supporting text
* OTP input boxes
* Resend OTP
* Verification CTA
* Security/illustration element

OTP fields should be evenly spaced and visually consistent.

---

# 13. ACCOUNT TYPE

Recreate the account selection screen.

Show the account options from the reference:

* Business
* Individual

Use selectable cards.

Selected state:

* Purple border
* Light purple background
* Selected indicator

Unselected state:

* White card
* Light border

Bottom:
Primary Continue button.

---

# 14. KYC FLOW

Support both KYC states shown in the reference flow:

1. KYC under review
2. Approved KYC / normal customer

The under-review state should clearly communicate that verification is still processing.

The approved state should provide access to the normal customer experience.

Do not merge these two states.

They must be separate screens/states in Figma.

---

# 15. HOME DASHBOARD

Recreate the main dashboard.

Use the same visual hierarchy from the references.

Structure:

Top:

* Logo/header
* User/account information
* Notification/profile action if shown

Main:

* Current order/project card
* Delivery status
* Vehicle imagery
* Important status information
* Quick action

Cards should use:

* White background
* Rounded corners
* Very subtle shadow/border
* Purple accent
* Compact information hierarchy

Bottom:

* Fixed navigation

---

# 16. PROJECTS

Create Projects screens matching the references.

Projects listing:

* Header
* Search/filter where shown
* Project cards
* Project image
* Project name
* Location
* Status
* Project metadata
* Add/create project CTA

Project cards must use the same construction/site imagery supplied in the reference.

Do not replace the imagery with generic placeholder images.

---

# 17. CREATE NEW PROJECT

Recreate the create project screen.

Fields should match the supplied design.

Include:

* Project name
* Project location
* Address/location selector
* Saved location support
* Site information
* Project image/visual
* Continue/create CTA

Use the same form hierarchy and iconography.

---

# 18. LOCATION / MAP

Recreate the location screens.

Map UI should visually match the reference.

Include:

* Light map
* Location pin
* Search/location field
* Current location indicator
* Selected location card
* Address
* Confirm button

Use a clean light map style.

Do not use a dark map.

---

# 19. PROJECT DETAILS

Create the Project Details screen.

Include:

* Large project/site image
* Project title
* Location
* Project status
* Quantity/metrics
* Project information
* Location/map section
* Related orders/resources
* Primary action

Use the same image hierarchy as the supplied screen.

---

# 20. CREATE ORDER FLOW

Create the complete ordering flow.

Steps should include the screens shown in the reference:

1. Select product/service
2. Select quantity
3. Select vehicle
4. Select services
5. Site access requirements
6. Review order
7. Payment

Use a clean step-by-step experience.

Maintain visual consistency between every step.

---

# 21. SELECT VEHICLE

Recreate the vehicle selection screen.

Show vehicle options using the supplied vehicle imagery.

Each option should contain:

* Vehicle image
* Vehicle name/type
* Capacity
* Relevant specifications
* Price if applicable
* Selection state

Selected vehicle:

* Purple border
* Light purple background
* Check/selected indicator

---

# 22. QUANTITY SCREEN

Recreate the quantity selection interface.

Use the same visual treatment from the reference.

Large quantity/value display.

Include:

* Minus
* Quantity
* Plus

Supporting unit information.

Primary CTA at bottom.

---

# 23. SERVICES

Create the service selection screen.

Use reusable selectable service rows/cards.

Each service can include:

* Icon/image
* Service name
* Short description
* Price
* Selection indicator

Maintain the same compact visual hierarchy as the reference.

---

# 24. SITE ACCESS REQUIREMENTS

Recreate the Site Access Requirements screen.

Use selectable requirement cards/options.

Examples should only use the options present in the supplied reference.

Selected items should have a purple selected state.

Include Continue CTA.

---

# 25. ORDER REVIEW

Create the Order Review screen.

Show:

* Product/service
* Project
* Delivery location
* Vehicle
* Quantity
* Services
* Delivery information
* Price breakdown
* Total amount

Use clear section cards.

Total amount should be visually prominent.

Primary CTA:

Continue to Payment

---

# 26. PAYMENT

Recreate all payment-related screens from the references.

Include:

* Payment method selection
* Saved payment method
* Card/payment option
* Secure payment messaging
* Amount
* Payment CTA
* Payment processing state
* Payment confirmation

The secure-payment screen should preserve the supplied security illustration.

Do not replace the illustration.

---

# 27. PAYMENT CONFIRMATION

Create the confirmation state shown in the reference.

Use:

* Success/security illustration
* Payment status
* Amount
* Order information
* Date/time
* Transaction information
* Primary CTA

Use the same purple confirmation visual language.

---

# 28. ORDERS

Create the Orders screen.

Use segmented/filter/status categories where present.

Order cards should show:

* Order ID
* Product/service
* Project
* Vehicle
* Delivery date
* Status
* Amount
* Relevant thumbnail

Status colors should match the reference.

---

# 29. ORDER DETAILS

Create detailed order information.

Include:

* Order status
* Product/service
* Quantity
* Vehicle
* Project
* Delivery location
* Payment information
* Price
* Delivery information
* Action buttons

Use expandable/section-card patterns where appropriate.

---

# 30. DELIVERY SCHEDULE

Recreate the Delivery Scheduled screen.

Include:

* Delivery date
* Delivery time window
* Vehicle/truck
* Order information
* Delivery location
* Driver/resource information
* Track Delivery CTA

Make the time window visually prominent.

---

# 31. LIVE DELIVERY TRACKING

This is one of the most important screens.

Recreate the Live Delivery screen exactly.

Use:

* Large map area
* Delivery route
* Truck/vehicle marker
* Destination marker
* Driver/vehicle information
* ETA
* Delivery status
* Bottom information sheet/card

The map should occupy most of the screen.

The bottom card should contain delivery information.

Do not turn this into a generic Google Maps screen.

Recreate the visual composition shown in the reference.

---

# 32. LOADING COMPLETED

Create the loading/completion state shown in the reference.

Use the same construction/vehicle imagery.

Include:

* Completion heading
* Delivery/order summary
* Status
* Supporting details
* Continue/view order CTA

---

# 33. RESOURCE MANAGEMENT

Recreate the Resources screens.

Include:

* Resource list
* Vehicles
* Drivers/team
* Resource status
* Assignment information

Use cards with:

* Resource image
* Name
* Type
* Status
* Assignment information

---

# 34. ASSIGNED RESOURCES

Create the Assigned Resources screen.

Show:

* Assigned vehicle
* Driver/resource
* Order/project
* Status
* Relevant metadata

Maintain the same visual hierarchy as the reference.

---

# 35. SITE CHECKPOINTS

Recreate the Site Checkpoints flow.

Include the map/site visualization shown in the supplied references.

Show:

* Site map
* Checkpoint markers
* Vehicle/resource position
* Checkpoint status
* Supporting information
* Continue/action button

---

# 36. COMPLETED DELIVERY / REVIEW

Recreate the delivery completion screen.

Include:

* Completion state
* Delivery/order summary
* Rating
* Review/feedback
* Supporting information
* Submit/finish CTA

Use the same rating component shown in the reference.

---

# 37. COMPONENT LIBRARY

Create a dedicated Figma Components page.

Create reusable components for:

* Buttons
* Inputs
* OTP fields
* Cards
* Project cards
* Order cards
* Vehicle cards
* Service rows
* Status badges
* Navigation
* Headers
* Bottom navigation
* Map pins
* Location cards
* Payment cards
* Resource cards
* Rating stars
* Quantity selector
* Checkboxes
* Radio buttons
* Toggles
* Modals
* Bottom sheets
* Loading states
* Success states
* Error states

Use Figma Auto Layout wherever possible.

Use component variants instead of duplicated components.

---

# 38. RESPONSIVE / AUTO LAYOUT

All major components must use Auto Layout.

Components should adapt to:

* Different text lengths
* Different screen widths
* Different order information
* Different project names
* Different prices
* Different status labels

Do not create every screen as a flattened design.

The Figma file must be editable.

---

# 39. ASSET RULE

CRITICAL:

Use the exact images from the supplied reference document wherever possible.

The supplied screenshots contain:

* Construction images
* Concrete/truck images
* Project/site images
* Delivery images
* Map visuals
* Security/payment illustrations
* Onboarding illustrations
* Vehicle imagery

Do NOT substitute these with random stock images.

If an image is available in the supplied reference assets, reuse it.

If an image exists only inside a screenshot, crop/extract it from the reference rather than generating an unrelated replacement.

Maintain the same image crop, aspect ratio, placement and visual prominence.

---

# 40. ICON RULE

Use icons visually matching the reference.

Prefer simple outlined icons.

Maintain consistent:

* Stroke width
* Icon size
* Corner treatment
* Purple/gray states

Do not mix multiple icon styles.

---

# 41. SCREEN ORGANIZATION

Organize the Figma file into pages:

01 — Cover
02 — Design System
03 — Components
04 — Onboarding
05 — Authentication
06 — KYC
07 — Home
08 — Projects
09 — Create Project
10 — Create Order
11 — Payment
12 — Orders
13 — Delivery
14 — Live Tracking
15 — Resources
16 — Completion / Feedback
17 — Prototype Flow

Name every frame clearly.

Example:

AUTH-01 Login
AUTH-02 OTP Verification
AUTH-03 Account Type
KYC-01 Under Review
KYC-02 Approved
HOME-01 Dashboard
PROJECT-01 Project List
PROJECT-02 Create Project
PROJECT-03 Project Details
ORDER-01 Vehicle Selection
ORDER-02 Quantity
ORDER-03 Services
ORDER-04 Site Access
ORDER-05 Review
PAY-01 Payment Method
PAY-02 Payment Processing
PAY-03 Payment Confirmed
DELIVERY-01 Scheduled
DELIVERY-02 Live Tracking
RESOURCE-01 Resources
RESOURCE-02 Assigned Resources

---

# 42. PROTOTYPE

Connect all screens into a working prototype.

Interactions should include:

* Continue → next screen
* Back → previous screen
* Login → OTP
* OTP → account/home
* Account selection → next step
* Project → project details
* Create project → location
* Vehicle → quantity
* Quantity → services
* Services → site access
* Site access → review
* Review → payment
* Payment → confirmation
* Order → delivery
* Track Delivery → live tracking
* Delivery completion → rating/review

Use simple smart transitions.

Avoid unnecessary animation.

---

# 43. FINAL QUALITY REQUIREMENT

Before considering the design complete, compare every recreated screen against the supplied reference.

Check:

* Logo size
* Image crop
* Image position
* Typography
* Font weight
* Button dimensions
* Button radius
* Card radius
* Icon placement
* Spacing
* Map proportions
* Navigation position
* Bottom safe area
* Status colors
* Price alignment
* Heading alignment
* Vertical rhythm

The recreated screen should look like the same production application, not an AI-generated interpretation.

PRIORITY ORDER:

1. Match layout
2. Match images/assets
3. Match colors
4. Match typography
5. Match spacing
6. Match components
7. Match interactions

Do not sacrifice visual accuracy for creativity.

The final Figma file must be clean, editable, component-based, Auto Layout driven, and ready for developer handoff.
