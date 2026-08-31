import AntfastLogo from "../components/AntfastLogo";
import PrimaryButton from "../components/PrimaryButton";
import { Icon } from "../components/ui";
import { art } from "../assets";
import { useNav } from "../nav";

const STEPS = [
  { label: "Scheduled", sub: "Today, 8:00 AM", done: true },
  { label: "Loading completed", sub: "Today, 10:35 AM", done: true },
  { label: "On the way", sub: "Preparing departure", done: false, preparing: true },
];

export default function LoadingComplete() {
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
        {/* Check circle */}
        <div className="mt-3 flex justify-center">
          <div className="flex h-14 w-14 items-center justify-center rounded-full bg-[var(--primary)] shadow-[0_8px_24px_rgba(91,75,224,0.3)]">
            <Icon name="check" size={28} strokeWidth={2.5} className="text-white" />
          </div>
        </div>

        <h1 className="mt-3 text-center text-[26px] font-bold tracking-[-0.01em] text-[#1f2533]">Loading Completed</h1>
        <div className="mt-2 flex justify-center">
          <div className="inline-flex items-center gap-1.5 rounded-full bg-[var(--muted)] px-3 py-1">
            <Icon name="truck" size={12} className="text-[var(--muted-foreground)]" />
            <span className="text-[12px] font-semibold text-[var(--muted-foreground)]">Preparing departure</span>
          </div>
        </div>

        {/* Plant image */}
        <div className="mt-4 overflow-hidden rounded-2xl shadow-[0_4px_20px_rgba(30,25,70,0.08)]">
          <img src={art.plantDepotHero} alt="ANTFAST plant depot" className="block w-full object-cover"
            style={{ height: 180, objectPosition: "center" }} />
        </div>

        {/* Order row */}
        <button type="button" className="mt-4 flex w-full items-center justify-between rounded-xl border border-[var(--border)] bg-white px-4 py-2.5">
          <div className="flex items-center gap-2">
            <Icon name="doc" size={14} className="text-[var(--primary)]" />
            <span className="text-[13px] font-medium text-[#1f2533]">Order AF-2057 · Palm Jumeirah Villa</span>
          </div>
          <Icon name="chevronRight" size={16} className="text-[var(--muted-foreground)]" />
        </button>

        {/* Timeline */}
        <div className="mt-4 space-y-0">
          {STEPS.map((s, i) => (
            <div key={s.label} className="flex gap-3">
              <div className="flex flex-col items-center">
                <div className={`flex h-6 w-6 shrink-0 items-center justify-center rounded-full ${s.done ? "bg-[var(--primary)]" : "border-2 border-[#d3d1e4] bg-white"}`}>
                  {s.done && <Icon name="check" size={13} strokeWidth={3} className="text-white" />}
                </div>
                {i < STEPS.length - 1 && (
                  <div className={`mt-1 w-0.5 flex-1 ${s.done ? "bg-[var(--primary)]" : "bg-[#e6e4f1]"}`} style={{ minHeight: 28 }} />
                )}
              </div>
              <div className="pb-3">
                <div className={`text-[13px] font-semibold ${s.done ? "text-[#1f2533]" : "text-[var(--muted-foreground)]"}`}>{s.label}</div>
                <div className={`mt-0.5 text-[12px] ${s.preparing ? "text-[var(--primary)] font-medium" : "text-[var(--muted-foreground)]"}`}>{s.sub}</div>
              </div>
            </div>
          ))}
        </div>

        {/* Info note */}
        <div className="mt-2 flex items-start gap-2.5 rounded-xl border border-[var(--border)] bg-white px-4 py-3">
          <Icon name="truck" size={16} className="shrink-0 mt-0.5 text-[var(--primary)]" />
          <p className="text-[12px] text-[var(--muted-foreground)]">Your first delivery resource is preparing to depart. Live tracking appears after departure and initial movement toward your site.</p>
        </div>

        {/* Resources */}
        <div className="mt-3 flex items-center gap-2.5 rounded-xl border border-[var(--border)] bg-white px-4 py-3">
          <Icon name="truck" size={16} className="text-[var(--primary)]" />
          <span className="text-[12.5px] font-semibold text-[#1f2533]">Pump + 8 Trucks</span>
        </div>

        <div className="mt-5 space-y-3">
          <PrimaryButton arrow onClick={() => nav.navigate("liveTracking")}>
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
