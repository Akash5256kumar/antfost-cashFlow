Update ONLY the 3 ANTFAST ONBOARDING SCREENS.

Compare the CURRENT Figma Make onboarding implementation against the supplied ANTFAST reference design/PDF and correct the entire onboarding flow as one consistent system.

IMPORTANT:
Do NOT redesign the onboarding.
Do NOT invent a new layout.
Do NOT replace the existing ANTFAST logo or supplied illustrations.
Do NOT modify Login or any other screen.
Do NOT change navigation behavior.

The target is a real 390 × 844 px mobile screen.

==================================================
GLOBAL ONBOARDING LAYOUT
==================================================

All 3 onboarding screens must use the SAME structural layout and spacing system.

Screen structure:

iOS Status Bar
↓
Skip
↓
ANTFAST Logo
↓
Controlled spacing
↓
Large illustration
↓
Controlled spacing
↓
Heading
↓
Supporting description
↓
Pagination
↓
Controlled spacing
↓
Continue button
↓
Bottom safe area / home indicator

The screen must feel like a polished real mobile application, not a desktop webpage.

Do NOT use large flexible empty areas.

Do NOT allow mt-auto/flex expansion to create a huge gap between pagination and Continue.

Use controlled vertical spacing.

==================================================
1. ANTFAST LOGO
==================================================

The current logo is too small in the latest version.

Increase the logo from the current 48px size.

Target approximately:

Width: 140px
Height: approximately 48px

Maintain the original logo aspect ratio.

Do NOT stretch or distort it.

The logo should visually match the proportion shown in the ANTFAST reference.

Keep it centered horizontally.

Keep the logo position near the top, below the Skip/status area.

Use exactly the same logo size and position on all 3 onboarding screens.

Do NOT use 352 × 124.

==================================================
2. SKIP
==================================================

Keep Skip at the top-left.

Use compact typography matching the reference.

Skip should have consistent horizontal padding with the main screen content.

Do not move Skip into the illustration area.

On the final onboarding slide, keep the existing behavior where Skip is not shown if that is already the intended flow.

==================================================
3. ILLUSTRATION AREA
==================================================

The illustration is the dominant visual element of each onboarding screen.

Do NOT make the illustration tiny.

Do NOT crop the artwork.

Do NOT replace the supplied assets.

Use the existing onboarding assets:

Slide 1:
ANTFAST ready-mix concrete truck / city illustration

Slide 2:
Location-based delivery / location pin illustration

Slide 3:
Secure payment / payment security illustration

Keep the visual scale consistent across all 3 slides.

Target illustration container:
approximately 300–320px visual height within the 390 × 844 viewport.

The actual artwork must remain fully visible.

Use object-contain / equivalent behavior.

Do NOT use object-cover.

Do NOT distort the artwork.

The illustration should sit relatively close below the logo, with approximately 20–28px visual spacing.

Do not create a large blank region between logo and illustration.

==================================================
4. HEADINGS
==================================================

Keep the exact existing onboarding copy.

Slide 1:

Busy like ants.
Fast like ANTFAST.

Slide 2:

Location-Based Delivery

Slide 3:

Secure Payments

Use approximately:

22px
bold
center aligned
tight line height

Do not make headings oversized.

The heading should sit approximately 12–18px below the illustration's visual bottom.

==================================================
5. SUPPORTING TEXT
==================================================

Keep the exact existing copy.

Slide 1:

Reliable ready-mix concrete, delivered exactly when you need it.

Slide 2:

Set the exact project location for accurate planning and on-time delivery.

Slide 3:

Pay securely with multiple options and full transparency.

Use approximately:

12–13px
regular
muted gray-purple
center aligned
max width around 280–300px

Keep approximately 8–10px between heading and description.

Do not make the description too large.

==================================================
6. PAGINATION
==================================================

Keep exactly 3 pagination indicators.

Active indicator:
purple
wider pill

Inactive indicators:
light lavender/gray

Keep them centered.

Place approximately 16–20px below the supporting description.

Keep the same pagination position across all three slides.

The active indicator must correctly correspond to:

Slide 1 → indicator 1 active
Slide 2 → indicator 2 active
Slide 3 → indicator 3 active

==================================================
7. CONTINUE BUTTON
==================================================

Keep the existing purple ANTFAST primary button.

Text:

Continue

Do NOT redesign the button.

Do NOT make it excessively tall.

Use the same horizontal margins as the reference.

The button should sit approximately:

24–32px below the pagination.

IMPORTANT:

Do NOT use mt-auto or another flex rule that creates a large empty area between pagination and button.

The button should be positioned using controlled spacing.

Maintain approximately 20–24px bottom safe-area spacing.

==================================================
8. VERTICAL RHYTHM
==================================================

Target visual rhythm for all 3 screens:

Status bar
↓
Skip
↓
~12–16px
Logo
↓
~20–28px
Illustration
↓
~12–18px
Heading
↓
~8–10px
Description
↓
~16–20px
Pagination
↓
~24–32px
Continue
↓
~20–24px
Bottom safe area

Do not allow flexbox to redistribute these spaces unpredictably.

The three screens should feel visually identical in structure.

==================================================
9. SCREEN 1 — TRUCK
==================================================

Use the existing truck illustration.

Visual hierarchy:

ANTFAST logo
↓
large ready-mix truck/city illustration
↓
Busy like ants.
Fast like ANTFAST.
↓
Reliable ready-mix concrete, delivered exactly when you need it.
↓
● ○ ○
↓
Continue

The truck should be visually prominent and approximately centered.

Do not let the truck become too small.

==================================================
10. SCREEN 2 — LOCATION
==================================================

Use the existing location illustration.

Visual hierarchy:

ANTFAST logo
↓
large location/delivery illustration
↓
Location-Based Delivery
↓
Set the exact project location for accurate planning and on-time delivery.
↓
○ ● ○
↓
Continue

Maintain exactly the same logo, illustration area, text spacing and CTA positioning as Screen 1.

Only the illustration, heading, description and active pagination state should change.

==================================================
11. SCREEN 3 — PAYMENT
==================================================

Use the existing payment/security illustration.

Visual hierarchy:

ANTFAST logo
↓
large payment/security illustration
↓
Secure Payments
↓
Pay securely with multiple options and full transparency.
↓
○ ○ ●
↓
Continue

Maintain exactly the same layout system as Screens 1 and 2.

==================================================
12. RESPONSIVE SAFETY
==================================================

Primary target:

390 × 844

Also ensure the onboarding does not break at:

375 × 812
393 × 852
430 × 932

Do not scale the entire onboarding using transform/zoom.

Do not shrink the complete screen to fit.

If the viewport is shorter, reduce controlled spacing slightly rather than shrinking the logo/illustration disproportionately.

==================================================
13. DO NOT TOUCH
==================================================

Do NOT modify:

- Login
- Account Type
- Create Account
- OTP
- Home
- Projects
- Orders
- Payment
- Delivery
- navigation
- routing
- supplied assets
- colors outside onboarding
- global typography
- global components unless absolutely required for onboarding

Only modify the onboarding implementation and onboarding-specific styles.

==================================================
14. FINAL VISUAL CHECK
==================================================

Before finishing, inspect all 3 onboarding slides individually.

Verify:

1. Logo is approximately 140 × 48 visual size
2. Logo is centered
3. Logo is not too close to Skip
4. Illustration is large and prominent
5. Illustration is fully visible
6. No excessive logo → illustration gap
7. No excessive illustration → heading gap
8. Heading is compact
9. Description is compact
10. Pagination is correctly positioned
11. Continue is approximately 24–32px below pagination
12. No giant empty area between pagination and button
13. Continue remains near the bottom
14. Bottom safe-area spacing is correct
15. All 3 screens have identical structural alignment
16. Only slide-specific content changes between screens

MOST IMPORTANT:

Match the supplied ANTFAST reference visually.

Do not creatively reinterpret the design.

Do not make the onboarding look like a generic modern SaaS onboarding.

The result should look like the same ANTFAST product shown throughout the supplied reference screens.