ANTFAST — FINAL VISUAL MATCH CORRECTION
CURRENT FIGMA MAKE DESIGN → PDF REFERENCE

IMPORTANT:
Do NOT redesign the entire application.

Use the CURRENT Figma Make implementation as the baseline and the attached ANTFAST PDF as the SINGLE VISUAL SOURCE OF TRUTH.

I want you to correct the following screens so that they match the PDF reference closely.

Preserve existing navigation and interactions wherever they already exist.

Do NOT randomly modernize the UI.
Do NOT invent a different design.
Do NOT simplify the PDF screens.
Do NOT replace reference artwork with generic icons.
Do NOT change the ANTFAST visual identity.

==================================================
GLOBAL RULE — ILLUSTRATION / ICON SCALE
==================================================

The visual/illustration sizing used on the current
"Create Individual Account" screen should become the
REFERENCE SCALE PHILOSOPHY for the rest of the application.

When a PDF screen contains a prominent illustration:

- use a similarly prominent visual scale
- do not make the illustration unnecessarily tiny
- maintain the same visual weight relative to the phone viewport
- preserve the illustration's aspect ratio
- maintain appropriate whitespace around it
- do not put it inside an unnecessary card unless the PDF does
- do not crop important parts of the illustration

The goal is that illustrations across the app feel like they belong to the SAME design system.

IMPORTANT:
This does NOT mean every screen must have an illustration.

Only screens where the PDF has an illustration should receive one.

For small functional icons inside cards:
keep them small and consistent with the PDF.

==================================================
GLOBAL HEADER
==================================================

Use the current ANTFAST header system as the base, but correct it
screen-by-screen according to the PDF.

Reference:

- mobile width around 390px
- centered ANTFAST logo
- back button where shown
- notification icon where shown
- light lavender/off-white background
- dark navy typography
- ANTFAST purple primary color
- subtle borders
- white cards
- approximately 16–20px corner radius

Do not use oversized logos.

The logo should have approximately the same visual scale as
the reference PDF screens.

==================================================
1. SERVICES SCREEN
==================================================

CURRENT SCREEN IS NOT MATCHING THE PDF.

The current implementation uses generic application-type cards
and generic toggles.

Replace the visual structure with the PDF structure.

PDF reference:
"Choose Services"

Subtitle:
"Select the structure type and services required for this delivery."

Top:
- ANTFAST header
- back arrow
- notification icon
- order progress step rail

Step rail must show:

Project
Mix Code
Quantity
Schedule
Services
Site Access
Review

Services should be the active step.

MAIN SERVICE TYPE:

Create the large white bordered section shown in the PDF.

Show:

"Slab"
with dropdown/expand control

Below it:
- Slab
- Raft
- Pile
- Column

Use the small concrete/application illustrations shown in the PDF.

Do NOT use the current generic 2x2 service cards.

==================================================
CONCRETE PUMP SECTION
==================================================

Match the PDF.

Show:

checkbox/selection state
Concrete Pump
Assigned and required for most pours

Use the actual concrete pump/truck visual from the supplied assets.

Do not replace the truck artwork with a generic line icon.

Inside the expanded section:

"Choose Pump Size"

Three cards:

Small Pump
Up to 42 m

Medium Pump
42–52 m

Big Pump
52 m and above

Match:
- card dimensions
- radio selection
- purple active border
- muted inactive state
- icon/visual size

==================================================
TECHNICIAN SECTION
==================================================

Match the PDF.

Selected service card:

Technician

"On-site support for sampling and quality control"

Use the technician image/artwork.

Below it:

"Cube Mould Quantity"

with:
- minus
- quantity
- plus

Do NOT replace this with a generic toggle.

==================================================
OTHER SERVICES
==================================================

Add the collapsed service rows shown in the PDF:

- Laboratory Testing
- Other Approved Services

Each should have:
- checkbox
- small icon
- title
- short description
- chevron

==================================================
SERVICES CTA
==================================================

Bottom fixed/anchored CTA:

"Continue to Site Access"

Use the existing PrimaryButton component.

Maintain its current footprint/style rather than creating another button system.

==================================================
2. SITE ACCESS
==================================================

CURRENT SCREEN IS TOO SIMPLE.

PDF title:

"Site Access Requirements"

Subtitle:

"Answer Yes or No for every site condition."

Keep the same progress step rail.

Create four expandable requirement cards:

1. Narrow Access
2. Road Permit Required
3. Boom Reach Restriction
4. Night Delivery Access

Each card must contain:

- icon
- title
- description
- Yes / No segmented controls

MATCH THE PDF selected/unselected states.

==================================================
NARROW ACCESS
==================================================

When expanded, show:

"Access photos"

with an image attachment thumbnail exactly like the PDF.

Include remove/delete icon on thumbnail.

==================================================
ROAD PERMIT
==================================================

When selected/expanded show:

"Road Permit Required"

attachment row:

Road_Permit_AF-2048.pdf

PDF/file icon
file size
remove icon

==================================================
BOOM REACH
==================================================

Match PDF styling.

Use the truck/pump related visual language.

==================================================
NIGHT DELIVERY
==================================================

Use moon/night icon.

Match Yes / No controls from PDF.

==================================================
BOTTOM
==================================================

Add:

checkbox:
"I confirm the site information and access instructions are accurate."

Primary CTA:

"Continue to Review"

Secondary text action:

"Save Draft"

Do NOT use the current generic card-only implementation.

==================================================
3. ORDER SAVED
==================================================

IMPORTANT:

The current project does not have a dedicated PDF-matching
"Order Saved" screen.

Create a dedicated screen.

PDF reference is the KYC-under-review state.

Header:
- back
- ANTFAST logo
- notification icon

Centered title:

"Order Saved"

Status:

"Verification in review"

Large prominent illustration:

Use the PDF's order-saved/KYC artwork.

The artwork must have similar visual prominence to
the Create Individual illustration scale.

Below:

"Your order has been saved."

"Payment will be available after ANTFAST approves your account."

Project/order card:

Palm Jumeirah Villa
120 m³ · C30/37

Status:

"Waiting for KYC Approval"

Primary button:

"View Saved Order"

Secondary outline:

"Back to Home"

Bottom navigation as shown in PDF.

Do NOT reuse Confirmation Needed for this screen.

They represent different states.

==================================================
4. REVIEW ORDER
==================================================

CURRENT REVIEW ORDER IS TOO TEXT-HEAVY AND DOES NOT MATCH PDF.

PDF has a large hero visual at the top.

Add:

- order/project hero image
- concrete truck / pump artwork
- progress step rail
- project/location summary

Then sections:

Project & Location
Mix & Quantity
Schedule
Services
Site Access
Attachments

Each row should have:

- small purple icon
- label
- value
- edit pencil on right

Site Access must show the actual selected Yes/No values.

Attachments section should show:

Access photo thumbnail
Road permit PDF

Bottom:

checkbox:
"I agree with the order details and confirm the information is accurate."

Primary CTA:

"Continue"

Match PDF vertical spacing and card density.

Do not use the current large generic list card as the final design.

==================================================
5. CHOOSE PAYMENT METHOD
==================================================

CURRENT PAYMENT METHOD SCREEN IS NOT MATCHING.

Remove the large generic wallet image currently placed above
the payment methods.

The PDF uses a compact payment selection screen.

Header:

Choose Payment Method

Order reference pill:

AF-2057 · AED 29,820

Then four large payment options:

1. Wallet
   AED 24,850 available

2. Card / Payment Link

3. Bank Transfer

4. Cash in Advance

Each option must have:
- appropriate visual/icon
- title
- description
- radio button
- selected purple border/background

Use the reference artwork/icons from the PDF.

Do not use the current generic 140px wallet image.

Bottom:

Continue to Pay

Secondary:

Save and exit

==================================================
6. COMPLETE PAYMENT
==================================================

IMPORTANT:
Create a dedicated "Complete Payment" screen.

The current application does not have this dedicated screen.

Match PDF exactly.

Header:

Complete Payment

Small order/reference pill:

Cash / Payment Link
or corresponding selected method.

Amount section:

Amount to pay

AED 29,820.00

Large payment illustration on the right/hero area.

Then segmented selector:

Pay by Card
Send Payment Link

Default selected state should match PDF.

CARD FORM:

Cardholder Name
Card Number
MM/YY
CVV

Add:
- card icon
- information icon where shown
- secure payment/helper text

Primary CTA:

Pay AED 29,820.00

Secondary:

Change Method

Maintain compact vertical spacing so the complete form fits
inside the mobile viewport like the PDF.

==================================================
7. UPLOAD PAYMENT PROOF
==================================================

IMPORTANT:
Create dedicated screen.

PDF title:

Upload Payment Proof

Payment method badge:

Bank Transfer

Amount transferred:

AED 29,820.00

Use the PDF's bank transfer / security illustration prominently.

The illustration should NOT be tiny.

Then:

TRANSFER DETAILS CARD

Bank:
ANTFAST Bank

IBAN:
AE•• •••• •••• 2086

Reference:
AF-260803-014

with copy icons.

Then:

UPLOAD PAYMENT PROOF

Large dashed upload area.

Icon:
image/document upload

Text:

Attach receipt or transfer screenshot

JPG, PNG or PDF · Max 10 MB

Button:

Choose File

Then warning/info banner:

"Payment remains pending until Finance verifies the attachment."

Primary:

Submit Payment Proof

Secondary:

Change Method

Match PDF proportions exactly.

==================================================
8. SPLIT WALLET PAYMENT
==================================================

IMPORTANT:
Create dedicated screen.

Title:

Split Wallet Payment

Show:

Total order amount

AED 31,920.00

Then a large donut/progress visualization.

Wallet:

77.8%
AED 24,850.00

Remaining:

22.2%
AED 7,070.00

On right/side:

From Wallet
AED 24,850.00

Remaining Amount
AED 7,070.00

Then:

"Choose one method for the remaining amount"

Subtitle:

"Wallet may combine with exactly ONE secondary method."

Options:

Card / Payment Link
Bank Transfer
Cash in Advance

Selected state must match PDF.

Footer note:

"Wallet funds are reserved only after you continue."

Primary:

Review Price Breakdown

Secondary:

Use another payment method

Use a real CSS/SVG donut chart.
Do NOT use an external chart library for this simple visual.

==================================================
9. WALLET
==================================================

CURRENT WALLET SCREEN DOES NOT MATCH THE PDF.

Replace its visual structure with the PDF Wallet design.

Top balance card:

Available Balance

AED 24,850.00

Reserved:
AED 2,100.00

Use the purple wallet artwork/card from the reference.

Below:

Top Up
Withdraw

two compact action buttons.

Then information card:

"Wallet can be combined with one payment method"

with chevron.

Then transaction filters:

All
Top-ups
Payments
Refunds

Selected filter uses purple underline.

Transactions:

Order AF-2048
- AED 8,420.00
Confirmed

Wallet Top-up
+ AED 10,000.00
Confirmed

Refund AF-2029
+ AED 760.00
Processing

Use the exact compact transaction-row style shown in PDF.

Bottom navigation:

Home
Orders
Projects
Wallet
Profile

Wallet selected.

Do not use the current generic wallet implementation.

==================================================
10. PRICE BREAKDOWN
==================================================

Match PDF.

Header:

Price Breakdown

Order/reference information.

Use the truck/concrete artwork near the top as shown.

Rows:

Concrete
AED 25,000.00

Concrete Pump
AED 2,400.00

Technician & 6 Cube Moulds
AED 600.00

Payment Method Charge
AED 200.00

Subtotal
AED 28,400.00

VAT 5%
AED 1,420.00

TOTAL
AED 29,820.00

Large highlighted total row.

Then:

checkbox:
"I have reviewed this amount"

Primary:

Accept Price

Secondary:

Change Payment Method

Do not use the current generic estimated-price card layout.

==================================================
11. TERMS & CONDITIONS
==================================================

Match PDF.

Use compact white cards for:

Order Request & Pricing
Payment
Site Readiness
Delivery & Delays
Cancellation & Refunds

Each:
- icon
- title
- description
- chevron

Bottom checkbox:

I have read and agree to ANTFAST's Terms & Conditions

Continue button disabled until selected.

==================================================
12. PAYMENT CONFIRMED
==================================================

CURRENT PAYMENT CONFIRMED SCREEN IS NOT MATCHING THE PDF.

PDF uses:

Payment Confirmed

small green "Confirmed" badge

Large successful payment/concrete delivery illustration.

Large amount:

AED 29,820.00

Then compact information rows:

Order
AF-2057

Payment
Card / Payment Link

Balance
ANT-...

Then:

View Order Status

Download Receipt

Back to Home

Use the PDF's illustration at a prominent scale.

Do not use the current generic "Order Placed!" presentation.

==================================================
13. VISUAL CONSISTENCY
==================================================

Across ALL corrected screens:

Use the same:

- page background
- logo scale
- header height
- icon stroke style
- card radius
- purple
- muted lavender
- typography
- button height
- button radius
- progress step rail
- bottom navigation

Do not create a different design language for payment screens.

==================================================
14. REFERENCE ASSET RULE
==================================================

The project already contains local reference assets.

Reuse them.

Do not generate random illustrations.

Relevant assets include:

- concrete truck
- construction site
- payment card
- bank transfer
- approved receipt
- wallet
- concrete cube
- delivery artwork
- KYC artwork

Use the asset that corresponds to the PDF screen.

==================================================
15. IMPORTANT DIFFERENCE BETWEEN STATES
==================================================

Do NOT merge these screens:

Order Saved
≠
Confirmation Needed
≠
Payment Confirmed
≠
Delivery Scheduled
≠
Loading Completed
≠
Delivery Completed

Each represents a different business state and must retain
its own visual treatment from the PDF.

==================================================
16. NAVIGATION / ROUTES
==================================================

Add the missing screens to the existing navigation architecture
without breaking current routes.

Missing dedicated screens should include:

- Order Saved
- Complete Payment
- Upload Payment Proof
- Split Wallet Payment

If the current Wallet screen is reused for the wallet tab,
update its design to match the PDF rather than creating a second
unnecessary Wallet implementation.

Maintain the existing React navigation architecture.

==================================================
17. DO NOT CHANGE FUNCTIONALITY UNNECESSARILY
==================================================

Keep existing:

- navigation
- state handling
- buttons
- selection interactions
- form controls
- progress rail
- reusable components

Only modify them where necessary to reproduce the PDF.

For missing screens, create the screen and connect it into the
existing navigation flow.

==================================================
18. FINAL QA
==================================================

After implementation, visually inspect these screens as one
continuous flow:

Services
→ Site Access
→ Order Saved
→ Review Order
→ Choose Payment Method
→ Complete Payment
→ Upload Payment Proof
→ Split Wallet Payment
→ Wallet
→ Price Breakdown
→ Terms & Conditions
→ Payment Confirmed

For every screen compare against the supplied PDF.

Specifically verify:

1. Illustration size
2. Illustration position
3. Logo size
4. Header spacing
5. Step rail
6. Card dimensions
7. Icon dimensions
8. Typography
9. Purple selected states
10. Yes/No controls
11. Attachment UI
12. Payment form
13. Wallet donut
14. Wallet balance card
15. Transaction rows
16. Bottom navigation
17. CTA position
18. Safe-area spacing

IMPORTANT FINAL RULE:

DO NOT STOP AFTER MAKING THE SCREENS "LOOK NICE".

They must visually resemble the supplied ANTFAST PDF.

The PDF is the reference.
The current Figma Make project is the implementation baseline.
The goal is HIGH-FIDELITY VISUAL MATCH, not a new interpretation.