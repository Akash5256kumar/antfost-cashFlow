import { useState } from "react";
import PrimaryButton from "../components/PrimaryButton";
import { Icon, TitleHeader } from "../components/ui";
import { useNav } from "../nav";

const TOTAL = 31920;
const WALLET = 24850;
const REMAINING = TOTAL - WALLET;
const WALLET_PCT = (WALLET / TOTAL) * 100;

const R = 40;
const CIRC = 2 * Math.PI * R;
const walletArc = (WALLET_PCT / 100) * CIRC;

const secondaryMethods = [
  { id: "card", label: "Card / Payment Link", desc: "Visa, Mastercard, or secure link", icon: "card" },
  { id: "bank", label: "Bank Transfer", desc: "Direct transfer — 1–2 business days", icon: "building" },
  { id: "cash", label: "Cash in Advance", desc: "Pay before delivery at ANTFAST office", icon: "cash" },
];

export default function SplitWalletPayment() {
  const nav = useNav();
  const [sel, setSel] = useState("card");

  return (
    <div className="flex flex-1 flex-col">
      <TitleHeader title="Split Wallet Payment" />

      <div className="flex-1 overflow-y-auto px-6 pb-8">
        {/* Total */}
        <div className="text-center">
          <div className="text-[11px] font-semibold uppercase tracking-wider text-[var(--muted-foreground)]">Total Order Amount</div>
          <div className="mt-1 text-[26px] font-bold text-[#1f2533]">AED {TOTAL.toLocaleString()}.00</div>
        </div>

        {/* Donut + breakdown */}
        <div className="mt-4 flex items-center justify-between rounded-2xl border border-[var(--border)] bg-white p-5 shadow-[0_2px_8px_rgba(30,25,70,0.05)]">
          {/* SVG Donut */}
          <div className="relative flex items-center justify-center">
            <svg width="120" height="120" viewBox="0 0 100 100">
              <circle cx="50" cy="50" r={R} fill="none" stroke="#e6e4f1" strokeWidth="12" />
              <circle
                cx="50" cy="50" r={R} fill="none"
                stroke="#5b4be0" strokeWidth="12"
                strokeDasharray={`${walletArc} ${CIRC}`}
                strokeLinecap="round"
                transform="rotate(-90 50 50)"
              />
            </svg>
            <div className="absolute text-center">
              <div className="text-[14px] font-bold text-[var(--primary)]">{WALLET_PCT.toFixed(1)}%</div>
              <div className="text-[9px] text-[var(--muted-foreground)]">Wallet</div>
            </div>
          </div>

          {/* Breakdown labels */}
          <div className="flex-1 pl-4 space-y-3">
            <div>
              <div className="flex items-center gap-1.5">
                <span className="h-2.5 w-2.5 rounded-full bg-[var(--primary)]" />
                <span className="text-[11px] font-semibold text-[var(--muted-foreground)]">From Wallet</span>
              </div>
              <div className="mt-0.5 text-[15px] font-bold text-[#1f2533]">AED {WALLET.toLocaleString()}.00</div>
            </div>
            <div>
              <div className="flex items-center gap-1.5">
                <span className="h-2.5 w-2.5 rounded-full bg-[#e6e4f1]" />
                <span className="text-[11px] font-semibold text-[var(--muted-foreground)]">Remaining Amount</span>
              </div>
              <div className="mt-0.5 text-[15px] font-bold text-[#1f2533]">AED {REMAINING.toLocaleString()}.00</div>
            </div>
          </div>
        </div>

        {/* Secondary method selection */}
        <div className="mt-5">
          <div className="text-[14px] font-bold text-[#1f2533]">Choose one method for the remaining amount</div>
          <div className="mt-1 text-[12px] text-[var(--muted-foreground)]">Wallet may combine with exactly ONE secondary method.</div>
        </div>

        <div className="mt-3 space-y-2.5">
          {secondaryMethods.map((m) => {
            const on = sel === m.id;
            return (
              <button
                key={m.id}
                type="button"
                onClick={() => setSel(m.id)}
                className={`flex w-full items-center gap-3 rounded-2xl border p-4 text-left transition-all ${
                  on ? "border-[var(--primary)] bg-[var(--primary-soft)]/20" : "border-[var(--border)] bg-white"
                }`}
              >
                <div className={`flex h-11 w-11 shrink-0 items-center justify-center rounded-xl ${on ? "bg-[var(--primary)] text-white" : "bg-[var(--muted)] text-[var(--primary)]"}`}>
                  <Icon name={m.icon} size={20} />
                </div>
                <div className="flex-1">
                  <div className="text-[13px] font-semibold text-[#1f2533]">{m.label}</div>
                  <div className="text-[12px] text-[var(--muted-foreground)]">{m.desc}</div>
                </div>
                <div className={`flex h-5 w-5 shrink-0 items-center justify-center rounded-full border-2 ${on ? "border-[var(--primary)] bg-[var(--primary)]" : "border-[#c3c1d6]"}`}>
                  {on && <span className="h-2 w-2 rounded-full bg-white" />}
                </div>
              </button>
            );
          })}
        </div>

        <div className="mt-3 flex items-center gap-2 rounded-xl bg-[var(--muted)] px-4 py-3">
          <Icon name="lock" size={14} className="shrink-0 text-[var(--primary)]" />
          <span className="text-[11.5px] text-[var(--muted-foreground)]">Wallet funds are reserved only after you continue.</span>
        </div>

        <div className="mt-5 space-y-3">
          <PrimaryButton arrow onClick={() => nav.navigate("priceBreakdown")}>
            Review Price Breakdown
          </PrimaryButton>
          <button type="button" onClick={nav.back}
            className="w-full py-2 text-center text-[14px] font-semibold text-[var(--primary)]">
            Use another payment method
          </button>
        </div>
      </div>
    </div>
  );
}
