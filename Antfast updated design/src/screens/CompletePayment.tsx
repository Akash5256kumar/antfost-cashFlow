import { useState } from "react";
import AntfastLogo from "../components/AntfastLogo";
import PrimaryButton from "../components/PrimaryButton";
import { Icon } from "../components/ui";
import { art } from "../assets";
import { useNav } from "../nav";

export default function CompletePayment() {
  const nav = useNav();
  const [tab, setTab] = useState<"card" | "link">("card");
  const [name, setName] = useState("");
  const [cardNum, setCardNum] = useState("");
  const [expiry, setExpiry] = useState("");
  const [cvv, setCvv] = useState("");

  return (
    <div className="flex flex-1 flex-col overflow-y-auto pb-8">
      {/* Header */}
      <div className="flex items-center justify-between px-5 pt-2 pb-1">
        <button type="button" onClick={nav.back}
          className="flex h-10 w-10 items-center justify-center rounded-full bg-white shadow-[0_2px_10px_rgba(30,25,70,0.06)]">
          <Icon name="back" size={22} strokeWidth={2.2} />
        </button>
        <AntfastLogo style={{ width: 140, height: "auto" }} />
        <div className="w-10" />
      </div>

      <div className="px-6">
        {/* Title + image side by side */}
        <div className="mt-2 flex items-start justify-between">
          <div className="flex-1 pr-4">
            <h1 className="text-[26px] font-bold tracking-[-0.01em] text-[#1f2533]">Complete Payment</h1>
            <div className="mt-2 inline-flex items-center gap-2 rounded-full bg-[var(--primary-soft)] px-3 py-1.5">
              <Icon name="card" size={14} className="text-[var(--primary)]" />
              <span className="text-[12px] font-semibold text-[var(--primary)]">Card / Payment Link</span>
            </div>
            <div className="mt-3">
              <div className="text-[12px] text-[var(--muted-foreground)]">Amount to be paid</div>
              <div className="mt-0.5 text-[28px] font-bold text-[#1f2533]">AED 29,820.00</div>
            </div>
          </div>
          <img
            src={art.paymentCard}
            alt="ANTFAST payment card"
            className="w-[160px] object-contain"
            style={{ maxHeight: 150 }}
          />
        </div>

        {/* Tab selector */}
        <div className="mt-4 flex rounded-2xl border border-[var(--border)] bg-[var(--muted)] p-1">
          {(["card", "link"] as const).map((t) => (
            <button key={t} type="button" onClick={() => setTab(t)}
              className={`flex-1 rounded-xl py-2.5 text-[13px] font-semibold transition-all ${
                tab === t ? "bg-white text-[var(--primary)] shadow-sm" : "text-[var(--muted-foreground)]"
              }`}>
              {t === "card" ? "Pay by Card" : "Send Payment Link"}
            </button>
          ))}
        </div>

        {tab === "card" ? (
          <div className="mt-4 space-y-3">
            <div className="overflow-hidden rounded-2xl border border-[var(--border)] bg-white shadow-[0_2px_8px_rgba(30,25,70,0.05)]">
              <div className="border-b border-[var(--border)] px-4 py-3.5">
                <input value={name} onChange={(e) => setName(e.target.value)} placeholder="Cardholder Name"
                  className="w-full bg-transparent text-[14px] outline-none placeholder:text-[#a3a1b8]" />
              </div>
              <div className="flex items-center gap-3 border-b border-[var(--border)] px-4 py-3.5">
                <input value={cardNum} onChange={(e) => setCardNum(e.target.value)} placeholder="Card Number"
                  className="flex-1 bg-transparent text-[14px] outline-none placeholder:text-[#a3a1b8]" />
                <Icon name="card" size={20} className="text-[#c3c1d6]" />
              </div>
              <div className="flex">
                <div className="flex-1 border-r border-[var(--border)] px-4 py-3.5">
                  <input value={expiry} onChange={(e) => setExpiry(e.target.value)} placeholder="MM/YY"
                    className="w-full bg-transparent text-[14px] outline-none placeholder:text-[#a3a1b8]" />
                </div>
                <div className="flex flex-1 items-center gap-2 px-4 py-3.5">
                  <input value={cvv} onChange={(e) => setCvv(e.target.value)} placeholder="CVV" type="password"
                    className="flex-1 bg-transparent text-[14px] outline-none placeholder:text-[#a3a1b8]" />
                  <span className="flex h-5 w-5 items-center justify-center rounded-full border border-[#c3c1d6] text-[10px] font-bold text-[#c3c1d6]">i</span>
                </div>
              </div>
            </div>

            <div className="flex items-center justify-center gap-1.5 py-1">
              <Icon name="shield" size={14} className="text-[var(--muted-foreground)]" />
              <span className="text-[12px] text-[var(--muted-foreground)]">Encrypted payment · 3D Secure supported</span>
            </div>
          </div>
        ) : (
          <div className="mt-4 rounded-2xl border border-[var(--border)] bg-white p-5 shadow-[0_2px_8px_rgba(30,25,70,0.05)]">
            <p className="text-center text-[13px] text-[var(--muted-foreground)]">
              A secure payment link will be sent to your registered mobile number and email.
            </p>
            <div className="mt-4 rounded-xl bg-[var(--muted)] px-4 py-3 text-center">
              <div className="text-[13px] font-semibold text-[var(--primary)]">+971 50 123 4567</div>
              <div className="text-[11px] text-[var(--muted-foreground)]">rashed@company.ae</div>
            </div>
          </div>
        )}

        <div className="mt-5 space-y-3">
          <PrimaryButton onClick={() => nav.navigate("paymentConfirmed")}>
            <Icon name="lock" size={18} className="mr-2" />
            Pay AED 29,820.00
          </PrimaryButton>
          <button type="button" onClick={nav.back}
            className="w-full py-3.5 text-center text-[14px] font-semibold text-[var(--primary)]">
            Change Method
          </button>
        </div>
      </div>
    </div>
  );
}
