import { useState } from "react";
import AntfastLogo from "../components/AntfastLogo";
import PrimaryButton from "../components/PrimaryButton";
import { BottomNav, Icon } from "../components/ui";
import { art } from "../assets";
import { useNav } from "../nav";

const ITEMS = [
  { label: "Concrete", amount: "AED 25,200" },
  { label: "Concrete Pump", amount: "AED 2,400" },
  { label: "Technician & 6 Cube Moulds", amount: "AED 600" },
  { label: "Payment Method Charge", amount: "AED 200" },
];

export default function PriceBreakdown() {
  const nav = useNav();
  const [agreed, setAgreed] = useState(false);

  return (
    <div className="flex flex-1 flex-col">
      {/* Header */}
      <div className="flex items-center justify-between px-5 pt-2 pb-1">
        <button type="button" onClick={nav.back}
          className="flex h-10 w-10 items-center justify-center rounded-full bg-white shadow-[0_2px_10px_rgba(30,25,70,0.06)]">
          <Icon name="back" size={22} strokeWidth={2.2} />
        </button>
        <AntfastLogo style={{ width: 140, height: "auto" }} />
        <button type="button"
          className="relative flex h-10 w-10 items-center justify-center rounded-full bg-white shadow-[0_2px_10px_rgba(30,25,70,0.06)]">
          <Icon name="bell" size={20} />
          <span className="absolute right-1.5 top-1.5 h-2 w-2 rounded-full bg-[var(--primary)]" />
        </button>
      </div>

      <div className="flex-1 overflow-y-auto px-5 pb-28">
        {/* Title + truck side by side */}
        <div className="mt-2 flex items-start justify-between">
          <div className="flex-1 pr-2">
            <h1 className="text-[26px] font-bold tracking-[-0.01em] text-[#1f2533]">Price Breakdown</h1>
            <div className="mt-2 inline-flex items-center gap-2 rounded-full bg-[var(--primary-soft)] px-3 py-1.5">
              <Icon name="card" size={13} className="text-[var(--primary)]" />
              <span className="text-[12px] font-semibold text-[var(--primary)]">Card / Payment Link</span>
            </div>
            <div className="mt-2 flex items-center gap-1.5">
              <Icon name="building" size={13} className="text-[var(--muted-foreground)]" />
              <span className="text-[12px] text-[var(--muted-foreground)]">Palm Jumeirah Villa · 120 m³ · C30/37</span>
            </div>
          </div>
          <img src={art.heroTruck} alt="ANTFAST mixer truck" className="w-[120px] object-contain"
            style={{ maxHeight: 100 }} />
        </div>

        {/* Items card */}
        <div className="mt-4 overflow-hidden rounded-2xl border border-[var(--border)] bg-white shadow-[0_2px_8px_rgba(30,25,70,0.05)]">
          {ITEMS.map((item, i) => (
            <div key={item.label}
              className={`flex items-center justify-between px-4 py-3.5 ${i < ITEMS.length - 1 ? "border-b border-[var(--border)]" : ""}`}>
              <span className="text-[13px] text-[#1f2533]">{item.label}</span>
              <span className="text-[13px] font-semibold text-[#1f2533]">{item.amount}</span>
            </div>
          ))}
          <div className="mx-4 h-px bg-[#d3d1e4]" />
          <div className="flex items-center justify-between border-t border-[var(--border)] px-4 py-3.5">
            <span className="text-[13px] text-[var(--muted-foreground)]">Subtotal</span>
            <span className="text-[13px] font-semibold text-[#1f2533]">AED 28,400</span>
          </div>
          <div className="flex items-center justify-between border-t border-[var(--border)] px-4 py-3.5">
            <span className="text-[13px] text-[var(--muted-foreground)]">VAT 5%</span>
            <span className="text-[13px] font-semibold text-[#1f2533]">AED 1,420</span>
          </div>
          <div className="flex items-center justify-between bg-[var(--primary)] px-4 py-4">
            <span className="text-[15px] font-bold text-white">Total</span>
            <span className="text-[18px] font-bold text-white">AED 29,820.00</span>
          </div>
        </div>

        {/* Info note */}
        <div className="mt-3 flex items-center gap-2.5 rounded-xl border border-[var(--border)] bg-white px-4 py-3">
          <Icon name="shield" size={15} className="shrink-0 text-[var(--primary)]" />
          <p className="text-[12px] text-[var(--muted-foreground)]">Price reflects the selected payment method.</p>
        </div>

        {/* Checkbox */}
        <button type="button" onClick={() => setAgreed((v) => !v)}
          className="mt-4 flex items-center gap-3">
          <span className={`flex h-5 w-5 shrink-0 items-center justify-center rounded-[5px] border-2 ${agreed ? "border-[var(--primary)] bg-[var(--primary)]" : "border-[#d3d1e4]"}`}>
            {agreed && <Icon name="check" size={11} strokeWidth={3} className="text-white" />}
          </span>
          <span className="text-[13px] text-[#1f2533]">I have reviewed this amount</span>
        </button>

        <div className="mt-5 space-y-3">
          <PrimaryButton arrow disabled={!agreed} onClick={() => nav.navigate("termsConditions")}>
            Accept Price
          </PrimaryButton>
          <button type="button" onClick={nav.back}
            className="w-full rounded-2xl border-2 border-[var(--primary)] py-3.5 text-center text-[14px] font-semibold text-[var(--primary)]">
            Change Payment Method
          </button>
        </div>
      </div>

      <BottomNav active="Home" />
    </div>
  );
}
