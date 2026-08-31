import AntfastLogo from "../components/AntfastLogo";
import PrimaryButton from "../components/PrimaryButton";
import { Icon } from "../components/ui";
import { art } from "../assets";
import { useNav } from "../nav";

const STEPS = [
  { label: "Loading started", sub: "In progress", done: true, active: true },
  { label: "Loading completed", sub: "We'll notify you when loading is complete", done: false, active: false },
  { label: "On the way", sub: "Tracking begins after departure", done: false, active: false },
];

export default function OrderDetails() {
  const nav = useNav();

  return (
    <div className="flex flex-1 flex-col">
      {/* Header */}
      <div className="flex items-center justify-between px-5 pt-2 pb-1">
        <div className="w-10" />
        <AntfastLogo style={{ width: 140, height: "auto" }} />
        <button type="button"
          className="relative flex h-10 w-10 items-center justify-center rounded-full bg-white shadow-[0_2px_10px_rgba(30,25,70,0.06)]">
          <Icon name="bell" size={20} />
          <span className="absolute right-1.5 top-1.5 h-2 w-2 rounded-full bg-[var(--primary)]" />
        </button>
      </div>

      <div className="flex-1 overflow-y-auto pb-8 px-5">
        {/* Status chip */}
        <div className="mt-2 inline-flex items-center gap-1.5 rounded-full bg-[var(--primary-soft)] px-3 py-1">
          <Icon name="truck" size={12} className="text-[var(--primary)]" />
          <span className="text-[12px] font-semibold text-[var(--primary)]">Loading started</span>
        </div>

        <h1 className="mt-2 text-[24px] font-bold tracking-[-0.01em] text-[#1f2533]">Order Details</h1>

        {/* Order ref row */}
        <button type="button" className="mt-2 flex w-full items-center justify-between rounded-xl border border-[var(--border)] bg-white px-4 py-2.5">
          <div className="flex items-center gap-2">
            <Icon name="doc" size={14} className="text-[var(--primary)]" />
            <span className="text-[13px] font-medium text-[#1f2533]">Order AF-2057 · Palm Jumeirah Villa</span>
          </div>
          <Icon name="chevronRight" size={16} className="text-[var(--muted-foreground)]" />
        </button>

        {/* Circular gauge + plant */}
        <div className="mt-4 flex items-center gap-3 overflow-hidden rounded-2xl border border-[var(--border)] bg-white shadow-[0_2px_8px_rgba(30,25,70,0.05)]">
          <div className="relative flex flex-1 flex-col items-center justify-center py-5">
            <svg width="120" height="120" viewBox="0 0 120 120">
              <circle cx="60" cy="60" r="48" fill="none" stroke="#e6e4f1" strokeWidth="10" />
              <circle cx="60" cy="60" r="48" fill="none" stroke="var(--primary)" strokeWidth="10"
                strokeLinecap="round" strokeDasharray="220 302"
                transform="rotate(-90 60 60)" />
            </svg>
            <div className="absolute flex flex-col items-center">
              <span className="text-[22px] font-bold text-[#1f2533]">120 m³</span>
              <span className="text-[10px] text-[var(--muted-foreground)]">Total order</span>
            </div>
            <div className="mt-2 inline-flex items-center gap-1 rounded-full bg-[var(--primary-soft)] px-3 py-1">
              <span className="h-1.5 w-1.5 rounded-full bg-[var(--primary)]" />
              <span className="text-[11px] font-semibold text-[var(--primary)]">Loading in progress</span>
            </div>
          </div>
          <img src={art.plantDepotHero} alt="ANTFAST plant" className="h-[180px] w-[130px] object-cover"
            style={{ objectPosition: "center" }} />
        </div>

        {/* Step list */}
        <div className="mt-4 space-y-0">
          {STEPS.map((s, i) => (
            <div key={s.label} className="flex gap-3">
              <div className="flex flex-col items-center">
                <div className={`flex h-6 w-6 shrink-0 items-center justify-center rounded-full ${s.done ? "bg-[var(--primary)]" : "border-2 border-[#d3d1e4] bg-white"}`}>
                  {s.done && <Icon name="check" size={13} strokeWidth={3} className="text-white" />}
                </div>
                {i < STEPS.length - 1 && (
                  <div className={`mt-1 w-0.5 flex-1 ${s.done ? "bg-[var(--primary)]" : "bg-[#e6e4f1]"}`} style={{ minHeight: 32 }} />
                )}
              </div>
              <div className="pb-4">
                <div className={`text-[13px] font-semibold ${s.active ? "text-[var(--primary)]" : s.done ? "text-[#1f2533]" : "text-[var(--muted-foreground)]"}`}>{s.label}</div>
                <div className="mt-0.5 text-[12px] text-[var(--muted-foreground)]">{s.sub}</div>
              </div>
            </div>
          ))}
        </div>

        {/* Info note */}
        <div className="mt-2 flex items-start gap-2.5 rounded-xl border border-[var(--border)] bg-white px-4 py-3">
          <Icon name="truck" size={16} className="shrink-0 mt-0.5 text-[var(--primary)]" />
          <p className="text-[12px] text-[var(--muted-foreground)]">Your first delivery resource is being loaded. Live tracking appears after departure and initial movement toward your site.</p>
        </div>

        {/* Resources */}
        <div className="mt-3 flex items-center gap-2.5 rounded-xl border border-[var(--border)] bg-white px-4 py-3">
          <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="var(--primary)" strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round">
            <path d="M3 6h11v9H3zM14 9h4l3 3v3h-7" /><circle cx="7" cy="18" r="2" /><circle cx="17.5" cy="18" r="2" />
          </svg>
          <span className="text-[12.5px] font-semibold text-[#1f2533]">Pump + 8 Trucks</span>
        </div>

        <div className="mt-5 space-y-3">
          <PrimaryButton arrow onClick={() => nav.navigate("loadingComplete")}>
            View Order Status
          </PrimaryButton>
          <button type="button" onClick={() => nav.jump("home")}
            className="w-full py-2 text-center text-[14px] font-semibold text-[var(--muted-foreground)]">
            Back to Home
          </button>
        </div>
      </div>
    </div>
  );
}
