import { useState } from "react";
import AntfastLogo from "../components/AntfastLogo";
import PrimaryButton from "../components/PrimaryButton";
import { Icon } from "../components/ui";
import { art } from "../assets";
import { useNav } from "../nav";

const bankDetails = [
  { label: "Bank", value: "ANTFAST Bank", copy: false },
  { label: "IBAN", value: "AE•• •••• •••• 2086", copy: true },
  { label: "Reference", value: "AF-260803-014", copy: true },
];

export default function UploadPaymentProof() {
  const nav = useNav();
  const [uploaded, setUploaded] = useState(false);

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
        {/* Title + illustration side by side */}
        <div className="mt-2 flex items-start justify-between">
          <div className="flex-1 pr-4">
            <h1 className="text-[24px] font-bold tracking-[-0.01em] text-[#1f2533]">Upload Payment Proof</h1>
            <div className="mt-2 inline-flex items-center gap-2 rounded-full bg-[var(--primary-soft)] px-3 py-1.5">
              <Icon name="building" size={14} className="text-[var(--primary)]" />
              <span className="text-[12px] font-semibold text-[var(--primary)]">Bank Transfer</span>
            </div>
            <div className="mt-3">
              <div className="text-[12px] text-[var(--muted-foreground)]">Amount transferred</div>
              <div className="mt-0.5 text-[26px] font-bold text-[#1f2533]">AED 29,820.00</div>
            </div>
          </div>
          <img
            src={art.bankTransfer}
            alt="Bank transfer"
            className="w-[150px] object-contain"
            style={{ maxHeight: 150 }}
          />
        </div>

        {/* Transfer details card */}
        <div className="mt-4 overflow-hidden rounded-2xl border border-[var(--border)] bg-white shadow-[0_2px_8px_rgba(30,25,70,0.05)]">
          <div className="border-b border-[var(--border)] px-4 py-3">
            <div className="text-[14px] font-bold text-[#1f2533]">Transfer Details</div>
          </div>
          {bankDetails.map((d, i) => (
            <div key={d.label} className={`flex items-center justify-between px-4 py-3.5 ${i < bankDetails.length - 1 ? "border-b border-[var(--border)]" : ""}`}>
              <span className="text-[12.5px] text-[var(--muted-foreground)]">{d.label}</span>
              <div className="flex items-center gap-2">
                <span className="text-[13px] font-semibold text-[#1f2533]">{d.value}</span>
                {d.copy && (
                  <button type="button" className="flex h-7 w-7 items-center justify-center rounded-lg bg-[var(--muted)] text-[var(--primary)]">
                    <Icon name="doc" size={13} />
                  </button>
                )}
              </div>
            </div>
          ))}
        </div>

        {/* Upload section */}
        <div className="mt-4">
          <div className="text-[14px] font-bold text-[#1f2533]">Upload Payment Proof</div>
          <button type="button" onClick={() => setUploaded(true)}
            className={`mt-2 flex w-full flex-col items-center justify-center rounded-2xl border-2 border-dashed px-6 py-7 transition-colors ${
              uploaded ? "border-[var(--primary)] bg-[var(--primary-soft)]/10" : "border-[#d3d1e4] bg-white"
            }`}>
            <div className={`flex h-14 w-14 items-center justify-center rounded-2xl ${uploaded ? "bg-[var(--primary)]" : "bg-[var(--primary-soft)]"}`}>
              {uploaded
                ? <Icon name="check" size={26} className="text-white" />
                : (
                  <svg viewBox="0 0 24 24" width="26" height="26" fill="none" stroke="var(--primary)" strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round">
                    <rect x="3" y="3" width="18" height="18" rx="2" />
                    <circle cx="8.5" cy="8.5" r="1.5" />
                    <path d="M21 15l-5-5L5 21" />
                    <path d="M12 8v4M10 10h4" />
                  </svg>
                )}
            </div>
            <div className="mt-3 text-[13px] font-semibold text-[#1f2533]">
              {uploaded ? "Receipt uploaded" : "Attach receipt or transfer screenshot"}
            </div>
            {!uploaded && <div className="mt-1 text-[11.5px] text-[var(--muted-foreground)]">JPG, PNG or PDF · Max 10 MB</div>}
            <span className="mt-2 text-[13px] font-semibold text-[var(--primary)]">{uploaded ? "Change File" : "Choose File"}</span>
          </button>
        </div>

        {/* Warning */}
        <div className="mt-3 flex items-center gap-2.5 rounded-xl bg-[#fffbeb] px-4 py-3">
          <Icon name="clock" size={15} className="shrink-0 text-[#b45309]" />
          <p className="text-[12px] text-[#92400e]">Payment remains pending until Finance verifies the attachment.</p>
        </div>

        <div className="mt-5 space-y-3">
          <PrimaryButton arrow onClick={() => nav.navigate("paymentConfirmed")}>
            Submit Payment Proof
          </PrimaryButton>
          <button type="button" onClick={nav.back}
            className="w-full py-3 text-center text-[14px] font-semibold text-[var(--primary)]">
            Change Method
          </button>
        </div>
      </div>
    </div>
  );
}
