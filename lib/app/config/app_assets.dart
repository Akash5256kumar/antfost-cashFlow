abstract final class AppAssets {
  /// The ANTFAST wordmark as a true vector (hand-outlined path data, not an
  /// embedded photo) — renders pixel-perfect at any zoom/size, unlike a
  /// raster crop. Render with `SvgPicture.asset`, not `Image.asset`.
  static const String antfostLogo = 'assets/images/antfost_logo.svg';

  // ── Real assets ported from the Figma "Antfast-updated-design" file ──────
  // These are the genuine `src/imports/*.jpg` source files pulled directly
  // from the Figma Make project (not screen-capture crops), so they're at
  // full original resolution (1200x800) with no re-crop artifacts.
  /// The new design's onboarding/home/schedule mixer-truck illustration
  /// (same source image reused across all three per the Figma source).
  static const String figmaTruck = 'assets/images/figma_truck.jpg';

  /// The new design's Login-screen batching-plant illustration
  /// (`art.loginPlant` = Figma `imports/8.jpg`).
  static const String figmaPlant = 'assets/images/figma_plant.jpg';

  /// Onboarding slide 2 — location pin over a city skyline.
  static const String onboardingLocation =
      'assets/images/onboarding_location.jpg';

  /// Onboarding slide 3 — phone + secure payment card.
  static const String onboardingPayment =
      'assets/images/onboarding_payment.jpg';

  /// Trade license + shield in front of an ANTFAST plant — KYC/verification.
  static const String artKycShield = 'assets/images/art_kyc_shield.jpg';

  /// Villa under construction with palm trees — individual account signup.
  static const String artIndividualHouse =
      'assets/images/art_individual_house.jpg';

  /// Building under construction with a crane — business/project setup.
  static const String artProjectBuild = 'assets/images/art_project_build.jpg';

  /// Home hero artwork showing the full Antfost batching plant and mixer truck
  /// exactly as rendered in the Figma reference design (Downloads/35.jpg).
  static const String artHomeHero = 'assets/images/35.jpg';

  /// Seamlessly blended batching plant and mixer truck illustration for Price Breakdown header.
  static const String artBreakdownHero = 'assets/images/art_breakdown_hero.png';

  /// Soft/faded plant scene (`art.plantSceneSoft`) — decorative footer
  /// illustration on the Schedule step.
  static const String artPlantSceneSoft =
      'assets/images/art_plant_scene_soft.jpg';

  /// Villa + pool + pump truck (`art.heroTruck`) — Price Breakdown's side
  /// illustration next to the title.
  static const String artHeroTruck = 'assets/images/art_hero_truck.jpg';

  /// Batching plant with silos + mixer truck leaving the depot
  /// (`art.plantDepotHero`) — Loading Completed's hero image.
  static const String artPlantDepotHero =
      'assets/images/art_plant_depot_hero.jpg';

  /// Villa site map with route line (`art.villaRouteMap`) — Pouring
  /// screen's map header.
  static const String artVillaRouteMap =
      'assets/images/art_villa_route_map.jpg';

  /// Verified envelope — OTP verification.
  static const String artOtpEnvelope = 'assets/images/art_otp_envelope.jpg';

  /// Bank building + "Bank Transfer" document — bank-transfer payment step.
  static const String artBankTransfer = 'assets/images/art_bank_transfer.jpg';

  static const String artWalletMini = 'assets/images/art_wallet_mini.jpg';
  static const String artCardMini = 'assets/images/art_card_mini.jpg';
  static const String artBankMini = 'assets/images/art_bank_mini.jpg';
  static const String artCashMini = 'assets/images/art_cash_mini.jpg';

  /// ANTFAST branded card + security shield/lock (`art.paymentCard`) —
  /// Complete Payment's card-entry illustration.
  static const String artPaymentCard = 'assets/images/art_payment_card.jpg';

  /// Concrete cube sample — price breakdown / mix composition.
  static const String artConcreteCube = 'assets/images/art_concrete_cube.jpg';

  /// Signed "Delivery Completed" certificate — payment/order confirmed.
  static const String artApprovedReceipt =
      'assets/images/art_approved_receipt.jpg';

  /// Aerial map — pump in use, trucks assigned to a site.
  static const String artPumpSiteMap = 'assets/images/art_pump_site_map.jpg';

  /// Map pin picker over Palm Jumeirah — add/pick a location.
  static const String artLocationPickerMap =
      'assets/images/art_location_picker_map.jpg';

  /// Villa + concrete pump mid-pour, wide hero.
  static const String artVillaPumpHero =
      'assets/images/art_villa_pump_hero.jpg';

  /// Villa + pump actively pouring concrete, wide hero.
  static const String artPumpPourHero = 'assets/images/art_pump_pour_hero.jpg';

  /// Site-radius map with trucks converging and an ETA countdown.
  static const String artRadiusMap = 'assets/images/art_radius_map.jpg';

  /// Pouring specific map image (imports/23.jpg)
  static const String artPouringMap = 'assets/images/23.jpg';

  /// Live tracking map — multiple trucks across Dubai with ETAs.
  static const String artTrackingMap = 'assets/images/art_tracking_map.jpg';

  /// Villa + truck mid-pour + "Delivery Completed" certificate with confetti.
  static const String artDeliveredVilla =
      'assets/images/art_delivered_villa.jpg';

  /// Real daylight photo of a modern villa with a pool — new project hero.
  static const String artVillaHero = 'assets/images/art_villa_hero.jpg';

  /// Delivery map with "Arrived" timestamps at a villa site.
  static const String artDeliveryMap = 'assets/images/art_delivery_map.jpg';

  /// Batching plant + truck with a "120 m³ / Loading in progress" gauge.
  static const String artLoadingGauge = 'assets/images/art_loading_gauge.jpg';

  /// Site checkpoint map — plant + trucks with arrival times.
  static const String artCheckpointMap = 'assets/images/art_checkpoint_map.jpg';

  /// Route map — truck en route between named Dubai neighborhoods.
  static const String artRouteMap = 'assets/images/art_route_map.jpg';

  /// Real project/site thumbnail photos referenced by the new design
  /// (`src/assets.ts`'s `photos` map — genuine Unsplash photos, fetched
  /// directly since those are public URLs rather than Figma-internal ones).
  static const String figmaVilla = 'assets/images/figma_villa.jpg';
  static const String figmaMarinaTower = 'assets/images/figma_marina_tower.jpg';
  static const String figmaCreekResidence =
      'assets/images/figma_creek_residence.jpg';
  static const String figmaJvcTownhouse =
      'assets/images/figma_jvc_townhouse.jpg';
  static const String figmaNeighborhood =
      'assets/images/figma_neighborhood.jpg';
  static const String figmaApartment = 'assets/images/figma_apartment.jpg';

  static const String orderThumbMarina = 'assets/images/order_thumb_marina.jpg';
  static const String orderThumbPalm = 'assets/images/order_thumb_palm.jpg';
  static const String orderThumbCreek = 'assets/images/order_thumb_creek.jpg';
  static const String orderThumbJvc = 'assets/images/order_thumb_jvc.jpg';

  static const String mapTwoPins = 'assets/images/map_two_pins.png';

  // Mix code thumbnails (from Mini Image folder)
  static const String mixThumb1 = 'assets/images/mix_thumb_1.jpg';
  static const String mixThumb2 = 'assets/images/mix_thumb_2.jpg';
  static const String mixThumb3 = 'assets/images/mix_thumb_3.jpg';
  static const String mixThumb4 = 'assets/images/mix_thumb_4.jpg';
  static const String mixThumb5 = 'assets/images/mix_thumb_5.jpg';
  static const String mixThumb6 = 'assets/images/mix_thumb_6.jpg';
  static const String mixThumb7 = 'assets/images/mix_thumb_7.jpg';
  static const String mixThumb8 = 'assets/images/mix_thumb_8.jpg';
  static const String mixThumb9 = 'assets/images/mix_thumb_9.jpg';
  static const String mixThumb10 = 'assets/images/mix_thumb_10.jpg';
  static const String mixThumb11 = 'assets/images/mix_thumb_11.jpg';
  static const String mixThumb12 = 'assets/images/mix_thumb_12.jpg';
  static const String mixThumb13 = 'assets/images/mix_thumb_13.jpg';
  static const String mixThumb14 = 'assets/images/mix_thumb_14.jpg';
  static const String mixThumb15 = 'assets/images/mix_thumb_15.jpg';


  static String orderThumbnailFor(String orderId, String location) {
    final key = '$orderId $location'.toLowerCase();
    if (key.contains('2052') || key.contains('marina')) {
      return orderThumbMarina;
    }
    if (key.contains('2048') || key.contains('palm') || key.contains('villa')) {
      return orderThumbPalm;
    }
    if (key.contains('2043') || key.contains('creek')) {
      return orderThumbCreek;
    }
    if (key.contains('2031') ||
        key.contains('jvc') ||
        key.contains('townhouse')) {
      return orderThumbJvc;
    }
    return artHeroTruck;
  }

  /// Best-effort match of a project/order location string to one of the
  /// real Figma-referenced site photos above, so cards showing "Palm
  /// Jumeirah Villa", "Marina Tower", etc. show real matching photography
  /// instead of a generic icon. Returns null when nothing matches, so
  /// callers can fall back to an icon placeholder.
  static String? photoForLocation(String location) {
    final l = location.toLowerCase();
    if (l.contains('marina') || l.contains('2052')) {
      return figmaMarinaTower;
    }
    if (l.contains('palm') ||
        l.contains('jumeirah') ||
        l.contains('villa') ||
        l.contains('2048')) {
      return figmaVilla;
    }
    if (l.contains('creek') || l.contains('residence') || l.contains('2043')) {
      return figmaCreekResidence;
    }
    if (l.contains('jvc') || l.contains('townhouse') || l.contains('2031')) {
      return figmaJvcTownhouse;
    }
    if (l.contains('neighborhood') || l.contains('community')) {
      return figmaNeighborhood;
    }
    if (l.contains('apartment') || l.contains('tower')) {
      return figmaApartment;
    }
    return figmaVilla;
  }

  static const String onboardingRectangle = 'assets/images/rectangle.svg';
  static const String notificationIcon = 'assets/svgs/notification.svg';
  static const String process = 'assets/svgs/process.svg';
  static const String truck = 'assets/svgs/truck.png';
  static const String box = 'assets/svgs/box.svg';
  static const String order = 'assets/svgs/order.svg';
  static const String guideBg = 'assets/images/guide_bg.png';
}
