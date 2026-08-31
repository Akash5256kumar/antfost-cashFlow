import { useState } from "react";
import AntfastLogo from "../components/AntfastLogo";
import PrimaryButton from "../components/PrimaryButton";
import { BottomNav, Icon } from "../components/ui";
import { useNav } from "../nav";

const SECTIONS = [
  {
    icon: "clipboard",
    title: "Order Request & Pricing",
    desc: "Orders are confirmed upon acceptance of the final price proposal. Prices are subject to change based on market conditions.",
  },
  {
    icon: "wallet",
    title: "Payment",
    desc: "Payment must be completed within 48 hours of price acceptance. Late payments may result in order cancellation.",
  },
  {
    icon: "building",
    title: "Site Readiness",
    desc: "The customer is responsible for ensuring site access and readiness at the scheduled delivery time.",
  },
  {
    icon: "truck",
    title: "Delivery & Delays",
    desc: "ANTFAST will notify customers of any delays. Waiting charges apply after 30 minutes of idle time on site.",
  },
  {
    icon: "refresh",
    title: "Cancellation & Refunds",
    desc: "Cancellations made within 24 hours of delivery are subject to a 10% cancellation fee. Refunds are processed within 5-7 working days.",
  },
];

export default function TermsConditions() {
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
        <h1 className="mt-3 text-[26px] font-bold tracking-[-0.01em] text-[#1f2533]">Terms &amp; Conditions</h1>

        <div className="mt-2 inline-flex items-center gap-2 rounded-full bg-[var(--muted)] px-3.5 py-1.5">
          <span className="text-[12px] font-semibold text-[var(--muted-foreground)]">AF-2057 · AED 29,820.00</span>
        </div>

        <div className="mt-4 overflow-hidden rounded-2xl border border-[var(--border)] bg-white shadow-[0_2px_8px_rgba(30,25,70,0.04)]">
          {SECTIONS.map((s, i) => (
            <div key={s.title} className={`flex items-start gap-3 px-4 py-4 ${i < SECTIONS.length - 1 ? "border-b border-[var(--border)]" : ""}`}>
              <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-xl bg-[var(--primary-soft)]">
                <Icon name={s.icon} size={18} className="text-[var(--primary)]" />
              </div>
              <div className="flex-1 min-w-0">
                <div className="text-[13px] font-bold text-[#1f2533]">{s.title}</div>
                <div className="mt-0.5 text-[12px] text-[var(--muted-foreground)] leading-relaxed">{s.desc}</div>
              </div>
              <Icon name="chevronRight" size={16} className="shrink-0 text-[var(--muted-foreground)] mt-0.5" />
            </div>
          ))}
        </div>

        <button type="button" onClick={() => setAgreed((v) => !v)}
          className="mt-4 flex items-start gap-3">
          <span className={`mt-0.5 flex h-5 w-5 shrink-0 items-center justify-center rounded-[5px] border-2 ${agreed ? "border-[var(--primary)] bg-[var(--primary)]" : "border-[#d3d1e4]"}`}>
            {agreed && <Icon name="check" size={11} strokeWidth={3} className="text-white" />}
          </span>
          <span className="text-left text-[13px] text-[#1f2533]">I have read and agree to the ANTFAST Terms &amp; Conditions.</span>
        </button>

        <div className="mt-2 text-[11px] text-[var(--muted-foreground)]">Terms version 4.2 · 04 Aug 2026</div>

        <div className="mt-5">
          <PrimaryButton arrow disabled={!agreed} onClick={() => nav.navigate("completePayment")}>
            Continue to Payment
          </PrimaryButton>
        </div>
      </div>

      <BottomNav active="Home" />
    </div>
  );
}
