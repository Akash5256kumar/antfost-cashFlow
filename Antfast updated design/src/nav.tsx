import { createContext, useCallback, useContext, useMemo, useState, type ReactNode } from "react";

export type ScreenId =
  | "onboarding"
  | "login"
  | "accountType"
  | "createIndividual"
  | "createBusiness"
  | "otp"
  | "verifyBusiness"
  | "home"
  | "orders"
  | "projects"
  | "savedLocations"
  | "createProject"
  | "addLocation"
  | "projectDetails"
  | "mixCode"
  | "quantity"
  | "schedule"
  | "wallet"
  | "orderTracking"
  | "services"
  | "siteAccess"
  | "reviewOrder"
  | "paymentMethod"
  | "priceBreakdown"
  | "termsConditions"
  | "paymentConfirmed"
  | "confirmationNeeded"
  | "deliveryScheduled"
  | "orderSaved"
  | "completePayment"
  | "uploadPaymentProof"
  | "splitWalletPayment"
  | "orderDetails"
  | "loadingComplete"
  | "liveTracking"
  | "siteCheckpoint"
  | "pouring"
  | "assignedResources"
  | "deliveryComplete"
  | "rateDelivery";

interface NavState {
  screen: ScreenId;
  params: Record<string, unknown>;
  navigate: (screen: ScreenId, params?: Record<string, unknown>) => void;
  back: () => void;
  jump: (screen: ScreenId, params?: Record<string, unknown>) => void;
}

const NavContext = createContext<NavState | null>(null);

export function NavProvider({ children }: { children: ReactNode }) {
  const [stack, setStack] = useState<{ screen: ScreenId; params: Record<string, unknown> }[]>([
    { screen: "onboarding", params: {} },
  ]);

  const navigate = useCallback((screen: ScreenId, params: Record<string, unknown> = {}) => {
    setStack((s) => [...s, { screen, params }]);
  }, []);

  const back = useCallback(() => {
    setStack((s) => (s.length > 1 ? s.slice(0, -1) : s));
  }, []);

  const jump = useCallback((screen: ScreenId, params: Record<string, unknown> = {}) => {
    setStack([{ screen, params }]);
  }, []);

  const top = stack[stack.length - 1];

  const value = useMemo<NavState>(
    () => ({ screen: top.screen, params: top.params, navigate, back, jump }),
    [top, navigate, back, jump],
  );

  return <NavContext.Provider value={value}>{children}</NavContext.Provider>;
}

export function useNav() {
  const ctx = useContext(NavContext);
  if (!ctx) throw new Error("useNav must be used within NavProvider");
  return ctx;
}
