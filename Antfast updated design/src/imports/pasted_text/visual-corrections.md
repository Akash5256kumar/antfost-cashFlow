FINAL VISUAL CORRECTION — DO NOT REDESIGN

I have compared the current Figma Make implementation against the supplied ANTFAST reference PDF again.

There are TWO remaining problems that must be fixed.

==================================================
1. REMOVE THE DESKTOP PRESENTATION WRAPPER
==================================================

The actual mobile application is already designed around 390 × 844, but the current implementation wraps it inside a desktop-style presentation layout.

Remove this behavior.

The application preview must behave as a REAL MOBILE APP VIEWPORT.

Specifically:

- Remove the visible "ANTFAST · Screens" desktop sidebar from the normal application presentation.
- Do not show the screen picker in the main UI.
- Remove the large outer lavender/gray canvas surrounding the phone.
- Do not visually render a tiny 390px phone inside a large desktop container.
- The root application should itself represent the 390 × 844 mobile viewport.
- The current screen must occupy the entire available viewport.
- The browser/Figma Make preview should visually resemble opening the actual mobile app, not viewing a phone mockup on a desktop.
- Keep the 390 × 844 design dimensions internally.
- Do not scale the entire app using transform, zoom, CSS scale, or browser-style shrinking.
- Do not change the actual reference design to compensate for the outer wrapper.

IMPORTANT:

The current PhoneFrame component should NOT be used as a decorative phone mockup.

Convert it into the actual application shell.

The application should effectively be:

390px wide
844px minimum height
full-height
overflow controlled internally
safe-area aware

NOT:

desktop canvas
→ sidebar
→ centered phone
→ tiny application

==================================================
2. FIX THE ACTUAL SCREEN PROPORTIONS
==================================================

After fixing the application shell, compare every screen against the reference PDF again.

The reference PDF is the SINGLE SOURCE OF TRUTH.

Do not redesign anything.

Do not introduce new styles.

Do not modernize.

Do not invent components.

Do not change the ANTFAST visual identity.

==================================================
3. TYPOGRAPHY
==================================================

The current typography is too large on several screens.

Match the reference proportions.

Use approximately:

Screen title:
20–22px

Section title:
13–15px

Body:
10–12px

Small helper text:
8–10px

Button text:
11–13px

Input text:
11–13px

Do NOT blindly apply these values if the reference visually differs.

The PDF comparison takes priority.

Headings must not dominate the screen.

==================================================
4. ONBOARDING
==================================================

Match the reference onboarding composition.

The illustration must occupy significantly more visual area.

The logo should remain compact.

The heading should be compact and centered.

Supporting text should be smaller.

Reduce excessive vertical spacing.

Keep CTA near the bottom.

The screen should feel dense like the reference rather than like a marketing landing page.

==================================================
5. LOGIN
==================================================

This is one of the highest priority screens.

Match the reference exactly:

ANTFAST logo
↓
construction illustration
↓
Login
↓
supporting description
↓
Business / Individual selector
↓
username/mobile field
↓
password field
↓
Forgot Password
↓
Login
↓
OR
↓
Create Account
↓
Try Our Demo

All elements must fit naturally inside 390 × 844.

Do not make the illustration or heading excessively large.

==================================================
6. ACCOUNT TYPE
==================================================

Match the reference:

Create Account
Step 1 of 3

How will you use ANTFAST?

Business card
Individual card

Selected state must have the purple border and selected indicator.

Continue button must sit near the bottom.

==================================================
7. CREATE ACCOUNT + OTP
==================================================

Match the reference screenshots exactly.

Keep the construction/business imagery.

Keep compact form fields.

Keep the OTP cells small and evenly spaced.

Keep the verification illustration.

Do not make the forms look like generic web forms.

==================================================
8. HOME / PROJECTS / SAVED LOCATIONS
==================================================

The reference screens are compact mobile dashboards.

Do not make cards oversized.

Preserve:

- project images
- project titles
- locations
- counts
- status pills
- search
- bottom navigation
- purple selected states

The bottom navigation must remain fixed to the bottom of the 390 × 844 viewport.

==================================================
9. ORDER CREATION
==================================================

The reference order flow is information dense.

Preserve the step indicator:

Project
Mix Code
Quantity
Schedule
Services
Site Access
Review

Do not turn these screens into oversized cards.

Use compact spacing matching the reference.

==================================================
10. SERVICES / SITE ACCESS
==================================================

These are particularly important.

Match the reference density.

Services must retain:

Slab
Raft
Pile
Column
Concrete Pump
Pump Size
Technician
Cube Mould Quantity
Laboratory Testing
Other Approved Services

Site Access must retain:

Narrow Access
Road Permit Required
Boom Reach Restriction
Night Delivery Access

Do not simplify these sections.

==================================================
11. PAYMENT
==================================================

Match:

Choose Payment Method
Complete Payment
Price Breakdown
Terms & Conditions
Payment Confirmed

Use the same compact card proportions and purple selection states.

==================================================
12. DELIVERY / TRACKING
==================================================

Match:

Confirmation Needed
Delivery Scheduled
Order Details
Loading Completed
Live Delivery
Site Checkpoint
Pouring
Assigned Resources
Delivery Completed

The maps, trucks, route markers and truck lists must remain compact like the reference.

==================================================
13. BOTTOM NAVIGATION
==================================================

Use the reference navigation:

Home
Orders
Projects
Wallet
Profile

Keep it fixed.

Selected item:
purple

Unselected:
muted gray

Do not make the navigation taller than the reference.

==================================================
14. ASSETS
==================================================

Continue using the existing supplied ANTFAST assets.

Do not replace reference images with random stock images.

Do not generate replacement illustrations.

==================================================
15. IMPORTANT IMPLEMENTATION RULE
==================================================

DO NOT rebuild the application from scratch.

Modify the existing React implementation.

Preserve:
- navigation
- screen registry
- existing assets
- components
- existing screen flow

Only correct:
- viewport behavior
- sizing
- spacing
- typography
- component proportions
- visual fidelity

==================================================
16. FINAL TEST
==================================================

After making the changes, inspect the following screens specifically:

1. Onboarding
2. Login
3. Account Type
4. Create Individual
5. OTP
6. Projects
7. Create Project
8. Services
9. Site Access
10. Review Order
11. Payment Method
12. Payment Confirmed
13. Delivery Scheduled
14. Live Delivery
15. Site Checkpoint
16. Assigned Resources
17. Delivery Completed

Every screen must look like a real 390 × 844 ANTFAST mobile screen.

The PDF remains the visual source of truth.

DO NOT stop after fixing the outer viewport.

Fix both:
A. application viewport/presentation
B. internal screen proportions