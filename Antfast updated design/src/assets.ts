// Local illustration assets shipped with the reference PDF
import onbTruck from "./imports/3.jpg";
import onbPin from "./imports/4.jpg";
import onbPay from "./imports/1.jpg";
import loginPlant from "./imports/8.jpg";
import homeTruck from "./imports/3.jpg";
import otpEnvelope from "./imports/5.jpg";
import individualHouse from "./imports/9.jpg";
import businessReceipt from "./imports/15.jpg";
import kycShield from "./imports/6-1.jpg";
import projectBuild from "./imports/7.jpg";
import concreteCube from "./imports/10.jpg";
import loadingGauge from "./imports/11.jpg";
import deliveredVilla from "./imports/16.jpg";
import paymentCard from "./imports/13.jpg";
import bankTransfer from "./imports/14.jpg";
import approvedReceipt from "./imports/15.jpg";
import trackingMap from "./imports/17.jpg";
import checkpointMap from "./imports/18.jpg";
import scheduleTruck from "./imports/3.jpg";
import routeMap from "./imports/19-1.jpg";
import deliveryMap from "./imports/20-1.jpg";
import villaRouteMap from "./imports/21-1.jpg";
import locationPickerMap from "./imports/22-1.jpg";
import pumpSiteMap from "./imports/23-1.jpg";
import routeMapAlt from "./imports/24-1.jpg";
import radiusMap from "./imports/25-1.jpg";
import siteRadiusMap from "./imports/26-1.jpg";
import heroTruck from "./imports/27-1.jpg";
import walletCard from "./imports/28-1.jpg";
import villaHero from "./imports/29.jpg";
import plantSceneSoft from "./imports/30-2.jpg";
import villaPumpHero from "./imports/31.jpg";
import plantDepotHero from "./imports/32.jpg";
import pumpPourHero from "./imports/33.jpg";
import plantHeroSoft from "./imports/34.jpg";
import homeHero from "./imports/32-1.jpg";

export const art = {
  onbTruck,
  onbPin,
  onbPay,
  loginPlant,
  homeTruck,
  otpEnvelope,
  individualHouse,
  businessReceipt,
  kycShield,
  projectBuild,
  concreteCube,
  loadingGauge,
  deliveredVilla,
  paymentCard,
  bankTransfer,
  approvedReceipt,
  trackingMap,
  checkpointMap,
  scheduleTruck,
  routeMap,
  deliveryMap,
  villaRouteMap,
  locationPickerMap,
  pumpSiteMap,
  routeMapAlt,
  radiusMap,
  siteRadiusMap,
  heroTruck,
  walletCard,
  villaHero,
  plantSceneSoft,
  villaPumpHero,
  plantDepotHero,
  pumpPourHero,
  plantHeroSoft,
  homeHero,
};

const u = (id: string, w = 400, h = 300) =>
  `https://images.unsplash.com/photo-${id}?w=${w}&h=${h}&fit=crop&auto=format`;

// Real-estate photos for project / order / location thumbnails
export const photos = {
  villa: u("1743819455744-05417bf55cea"),
  marinaTower: u("1780326412117-1b1ed27b9654"),
  creekResidence: u("1768913109654-6e6498409d89"),
  jvcTownhouse: u("1775135999808-d479060d60ec"),
  neighborhood: u("1640877268187-2fa6b2ed7a5f"),
  apartment: u("1766791783611-b1c6a7ad86bc"),
};
