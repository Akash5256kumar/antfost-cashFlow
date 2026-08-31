import type { ReactNode } from "react";
import { useState } from "react";
import PhoneFrame from "./components/PhoneFrame";
import { NavProvider, useNav, type ScreenId } from "./nav";
import Onboarding from "./components/Onboarding";
import Login from "./screens/Login";
import AccountType from "./screens/AccountType";
import CreateIndividual from "./screens/CreateIndividual";
import CreateBusiness from "./screens/CreateBusiness";
import Otp from "./screens/Otp";
import VerifyBusiness from "./screens/VerifyBusiness";
import Home from "./screens/Home";
import Orders from "./screens/Orders";
import Projects from "./screens/Projects";
import SavedLocations from "./screens/SavedLocations";
import CreateProject from "./screens/CreateProject";
import AddLocation from "./screens/AddLocation";
import ProjectDetails from "./screens/ProjectDetails";
import MixCode from "./screens/MixCode";
import Quantity from "./screens/Quantity";
import Schedule from "./screens/Schedule";
import Services from "./screens/Services";
import SiteAccess from "./screens/SiteAccess";
import ReviewOrder from "./screens/ReviewOrder";
import PaymentMethod from "./screens/PaymentMethod";
import PriceBreakdown from "./screens/PriceBreakdown";
import TermsConditions from "./screens/TermsConditions";
import PaymentConfirmed from "./screens/PaymentConfirmed";
import ConfirmationNeeded from "./screens/ConfirmationNeeded";
import DeliveryScheduled from "./screens/DeliveryScheduled";
import Wallet from "./screens/Wallet";
import OrderTracking from "./screens/OrderTracking";
import OrderSaved from "./screens/OrderSaved";
import CompletePayment from "./screens/CompletePayment";
import UploadPaymentProof from "./screens/UploadPaymentProof";
import SplitWalletPayment from "./screens/SplitWalletPayment";
import OrderDetails from "./screens/OrderDetails";
import LoadingComplete from "./screens/LoadingComplete";
import LiveTracking from "./screens/LiveTracking";
import SiteCheckpoint from "./screens/SiteCheckpoint";
import Pouring from "./screens/Pouring";
import AssignedResources from "./screens/AssignedResources";
import DeliveryComplete from "./screens/DeliveryComplete";
import RateDelivery from "./screens/RateDelivery";

const registry: Record<ScreenId, { label: string; Component: () => ReactNode }> = {
  onboarding: { label: "Onboarding", Component: Onboarding },
  login: { label: "Login", Component: Login },
  accountType: { label: "Account Type", Component: AccountType },
  createIndividual: { label: "Create Individual", Component: CreateIndividual },
  createBusiness: { label: "Create Business", Component: CreateBusiness },
  otp: { label: "OTP Verification", Component: Otp },
  verifyBusiness: { label: "Verify Business (KYC)", Component: VerifyBusiness },
  home: { label: "Home Dashboard", Component: Home },
  orders: { label: "Orders", Component: Orders },
  projects: { label: "Projects", Component: Projects },
  savedLocations: { label: "Saved Locations", Component: SavedLocations },
  createProject: { label: "Create Project", Component: CreateProject },
  addLocation: { label: "Add Location", Component: AddLocation },
  projectDetails: { label: "Project Details", Component: ProjectDetails },
  mixCode: { label: "Mix Code", Component: MixCode },
  quantity: { label: "Quantity", Component: Quantity },
  schedule: { label: "Schedule", Component: Schedule },
  services: { label: "Services", Component: Services },
  siteAccess: { label: "Site Access", Component: SiteAccess },
  reviewOrder: { label: "Review Order", Component: ReviewOrder },
  paymentMethod: { label: "Payment Method", Component: PaymentMethod },
  priceBreakdown: { label: "Price Breakdown", Component: PriceBreakdown },
  termsConditions: { label: "Terms & Conditions", Component: TermsConditions },
  paymentConfirmed: { label: "Payment Confirmed", Component: PaymentConfirmed },
  confirmationNeeded: { label: "Confirmation Needed", Component: ConfirmationNeeded },
  deliveryScheduled: { label: "Delivery Scheduled", Component: DeliveryScheduled },
  orderTracking: { label: "Order Tracking", Component: OrderTracking },
  wallet: { label: "Wallet", Component: Wallet },
  orderSaved: { label: "Order Saved", Component: OrderSaved },
  completePayment: { label: "Complete Payment", Component: CompletePayment },
  uploadPaymentProof: { label: "Upload Payment Proof", Component: UploadPaymentProof },
  splitWalletPayment: { label: "Split Wallet Payment", Component: SplitWalletPayment },
  orderDetails: { label: "Order Details", Component: OrderDetails },
  loadingComplete: { label: "Loading Complete", Component: LoadingComplete },
  liveTracking: { label: "Live Tracking", Component: LiveTracking },
  siteCheckpoint: { label: "Site Checkpoint", Component: SiteCheckpoint },
  pouring: { label: "Pouring", Component: Pouring },
  assignedResources: { label: "Assigned Resources", Component: AssignedResources },
  deliveryComplete: { label: "Delivery Complete", Component: DeliveryComplete },
  rateDelivery: { label: "Rate Delivery", Component: RateDelivery },
};

const order: ScreenId[] = [
  "onboarding", "login", "accountType", "createIndividual", "createBusiness", "otp",
  "verifyBusiness", "home", "orders", "projects", "savedLocations", "createProject",
  "addLocation", "projectDetails", "mixCode", "quantity", "schedule", "services",
  "siteAccess", "reviewOrder", "paymentMethod", "priceBreakdown", "termsConditions",
  "paymentConfirmed", "confirmationNeeded", "deliveryScheduled", "orderTracking", "wallet",
  "orderSaved", "completePayment", "uploadPaymentProof", "splitWalletPayment",
  "orderDetails", "loadingComplete", "liveTracking", "siteCheckpoint",
  "pouring", "assignedResources", "deliveryComplete", "rateDelivery",
];

function CurrentScreen() {
  const nav = useNav();
  const { Component } = registry[nav.screen];
  return <Component />;
}

function DevPicker() {
  const nav = useNav();
  const [open, setOpen] = useState(false);
  return (
    <div className="fixed bottom-10 right-2 z-50 flex flex-col items-end gap-1">
        {open && (
          <div className="mb-1 max-h-72 w-44 overflow-y-auto rounded-xl border border-[#ddd] bg-white shadow-xl">
            {order.map((id) => (
              <button
                key={id}
                onClick={() => { nav.jump(id); setOpen(false); }}
                className={`block w-full px-3 py-1.5 text-left text-[11px] transition-colors ${
                  nav.screen === id ? "bg-[#5b4be0] text-white" : "text-[#4a4763] hover:bg-[#f5f4fa]"
                }`}
              >
                {registry[id].label}
              </button>
            ))}
          </div>
        )}
        <button
          onClick={() => setOpen((o) => !o)}
          className="flex h-7 w-7 items-center justify-center rounded-full bg-[#5b4be0] text-white shadow-lg text-[14px] font-bold opacity-60 hover:opacity-100"
        >
          {open ? "×" : "≡"}
        </button>
    </div>
  );
}

export default function App() {
  return (
    <NavProvider>
      <PhoneFrame>
        <CurrentScreen />
      </PhoneFrame>
      <DevPicker />
    </NavProvider>
  );
}
