import AntfastLogo from "../components/AntfastLogo";
import PrimaryButton from "../components/PrimaryButton";
import { BottomNav, Icon } from "../components/ui";
import { art } from "../assets";
import { useNav } from "../nav";

const INFO_ROWS = [
  { icon: "clipboard", label: "Order", value: "AF-2057" },
  { icon: "card", label: "Payment Method", value: "Card / Payment Link" },
  { icon: "doc", label: "Reference", value: "ANT-849271" },
];

export default function PaymentConfirmed() {
  const nav = useNav();

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
        {/* Check circle */}
        <div className="mt-4 flex justify-center">
          <div className="flex h-20 w-20 items-center justify-center rounded-full bg-[var(--primary)] shadow-[0_8px_32px_rgba(91,75,224,0.35)]">
            <Icon name="check" size={40} strokeWidth={2.5} className="text-white" />
          </div>
        </div>

        {/* Title + badge */}
        <div className="mt-4 flex flex-col items-center gap-2">
          <h1 className="text-[24px] font-bold tracking-[-0.01em] text-[#1f2533]">Payment Confirmed</h1>
          <span className="inline-flex items-center gap-1.5 rounded-full bg-[#dcfce7] px-3 py-1">
            <span className="h-2 w-2 rounded-full bg-[#16a34a]" />
            <span className="text-[12px] font-semibold text-[#16a34a]">Confirmed</span>
          </span>
        </div>

        {/* Illustration */}
        <div className="mt-4 flex justify-center">
          <img src={art.approvedReceipt} alt="Payment receipt" className="w-full max-w-[280px] object-contain"
            style={{ maxHeight: 200 }} />
        </div>

        {/* Amount */}
        <div className="mt-3 text-center">
          <div className="text-[12px] text-[var(--muted-foreground)]">Total Amount</div>
          <div className="mt-0.5 text-[32px] font-bold tracking-tight text-[#1f2533]">AED 29,820.00</div>
        </div>

        {/* Info rows */}
        <div className="mt-4 overflow-hidden rounded-2xl border border-[var(--border)] bg-white shadow-[0_2px_8px_rgba(30,25,70,0.04)]">
          {INFO_ROWS.map((r, i) => (
            <div key={r.label} className={`flex items-center gap-3 px-4 py-3.5 ${i < INFO_ROWS.length - 1 ? "border-b border-[var(--border)]" : ""}`}>
              <div className="flex h-8 w-8 shrink-0 items-center justify-center rounded-xl bg-[var(--primary-soft)]">
                <Icon name={r.icon} size={16} className="text-[var(--primary)]" />
              </div>
              <span className="flex-1 text-[12.5px] text-[var(--muted-foreground)]">{r.label}</span>
              <span className="text-[13px] font-semibold text-[#1f2533]">{r.value}</span>
            </div>
          ))}
        </div>

        {/* Info note */}
        <div className="mt-3 flex items-center gap-2.5 rounded-xl border border-[var(--border)] bg-white px-4 py-3">
          <Icon name="clock" size={15} className="shrink-0 text-[var(--primary)]" />
          <p className="text-[12px] text-[var(--muted-foreground)]">ANTFAST is preparing your order proposal.</p>
        </div>

        <div className="mt-5 space-y-3">
          <PrimaryButton arrow onClick={() => nav.navigate("orders")}>
            View Order Status
          </PrimaryButton>
          <button type="button"
            className="flex w-full items-center justify-center gap-2 rounded-2xl border-2 border-[var(--primary)] py-3.5 text-[14px] font-semibold text-[var(--primary)]">
            <Icon name="download" size={18} />
            Download Receipt
          </button>
          <button type="button" onClick={() => nav.navigate("home")}
            className="w-full py-2 text-center text-[14px] font-semibold text-[var(--muted-foreground)]">
            Back to Home
          </button>
        </div>
      </div>

      <BottomNav active="Home" />
    </div>
  );
}
