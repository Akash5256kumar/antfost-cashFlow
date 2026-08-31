import { useState } from "react";
import PrimaryButton from "../components/PrimaryButton";
import { Icon, TitleHeader } from "../components/ui";
import { useNav } from "../nav";

const methods = [
  {
    id: "wallet",
    label: "Wallet",
    desc: "AED 24,850 available",
    icon: "wallet",
  },
  {
    id: "card",
    label: "Card / Payment Link",
    desc: "Visa, Mastercard, or secure link",
    icon: "card",
  },
  {
    id: "bank",
    label: "Bank Transfer",
    desc: "Direct transfer — 1–2 business days",
    icon: "building",
  },
  {
    id: "cash",
    label: "Cash in Advance",
    desc: "Pay before delivery at ANTFAST office",
    icon: "cash",
  },
];

export default function PaymentMethod() {
  const nav = useNav();
  const [sel, setSel] = useState("wallet");

  const handleContinue = () => {
    if (sel === "card") nav.navigate("completePayment");
    else if (sel === "bank") nav.navigate("uploadPaymentProof");
    else if (sel === "wallet") nav.navigate("splitWalletPayment");
    else nav.navigate("priceBreakdown");
  };

  return (
    <div className="flex flex-1 flex-col">
      <TitleHeader title="Choose Payment Method" />

      <div className="flex-1 overflow-y-auto px-6 pb-8">
        {/* Order reference pill */}
        <div className="flex justify-center">
          <div className="flex items-center gap-2 rounded-full border border-[var(--border)] bg-white px-4 py-1.5">
            <Icon name="doc" size={13} className="text-[var(--primary)]" />
            <span className="text-[12px] font-semibold text-[#1f2533]">AF-2057 · AED 29,820</span>
          </div>
        </div>

        <div className="mt-4 space-y-2.5">
          {methods.map((m) => {
            const on = sel === m.id;
            return (
              <button
                key={m.id}
                type="button"
                onClick={() => setSel(m.id)}
                className={`flex w-full items-center gap-3.5 rounded-2xl border p-4 text-left transition-all ${
                  on ? "border-[var(--primary)] bg-[var(--primary-soft)]/20 shadow-[0_4px_16px_rgba(91,75,224,0.12)]" : "border-[var(--border)] bg-white"
                }`}
              >
                <div className={`flex h-12 w-12 shrink-0 items-center justify-center rounded-2xl ${on ? "bg-[var(--primary)] text-white" : "bg-[var(--muted)] text-[var(--primary)]"}`}>
                  <Icon name={m.icon} size={22} />
                </div>
                <div className="flex-1">
                  <div className="text-[14px] font-semibold text-[#1f2533]">{m.label}</div>
                  <div className="text-[12px] text-[var(--muted-foreground)]">{m.desc}</div>
                </div>
                <div className={`flex h-5 w-5 shrink-0 items-center justify-center rounded-full border-2 transition-all ${on ? "border-[var(--primary)] bg-[var(--primary)]" : "border-[#c3c1d6]"}`}>
                  {on && <span className="h-2 w-2 rounded-full bg-white" />}
                </div>
              </button>
            );
          })}
        </div>

        <div className="mt-5 space-y-3">
          <PrimaryButton arrow onClick={handleContinue}>
            Continue to Pay
          </PrimaryButton>
          <PrimaryButton variant="outline" onClick={nav.back}>
            Save and exit
          </PrimaryButton>
        </div>
      </div>
    </div>
  );
}
