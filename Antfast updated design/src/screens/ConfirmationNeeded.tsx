import AntfastLogo from "../components/AntfastLogo";
import PrimaryButton from "../components/PrimaryButton";
import { BottomNav, Icon } from "../components/ui";
import { art } from "../assets";
import { useNav } from "../nav";

export default function ConfirmationNeeded() {
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
        <h1 className="mt-3 text-[26px] font-bold tracking-[-0.01em] text-[#1f2533]">Confirmation Needed</h1>
        <div className="mt-2 inline-flex items-center gap-1.5 rounded-full bg-[#fef3c7] px-3 py-1">
          <Icon name="clock" size={13} className="text-[#b45309]" />
          <span className="text-[12px] font-semibold text-[#b45309]">Confirmation needed</span>
        </div>
        <div className="mt-2 text-[13px] text-[var(--muted-foreground)]">AF-2057 · Palm Jumeirah Villa</div>

        {/* Comparison table */}
        <div className="mt-4 overflow-hidden rounded-2xl border border-[var(--border)] bg-white shadow-[0_2px_8px_rgba(30,25,70,0.04)]">
          {/* Column headers */}
          <div className="grid grid-cols-[auto_1fr_1fr] gap-0 border-b border-[var(--border)] px-4 py-2.5">
            <div className="w-9" />
            <div className="text-center text-[11px] font-semibold text-[var(--muted-foreground)]">You Requested</div>
            <div className="text-center text-[11px] font-bold text-[var(--primary)]">ANTFAST Proposal</div>
          </div>
          {[
            { icon: "clock", label: "Shift", yours: "Morning", theirs: "Morning" },
            { icon: "truck", label: "Services", yours: "Medium Pump\n43-52 m", theirs: "Medium Pump\n43-52 m" },
          ].map((r, i, arr) => (
            <div key={r.label} className={`grid grid-cols-[auto_1fr_1fr] items-center gap-0 px-4 py-3.5 ${i < arr.length - 1 ? "border-b border-[var(--border)]" : ""}`}>
              <div className="flex w-9 items-center justify-center">
                <span className="flex h-7 w-7 items-center justify-center rounded-lg bg-[var(--muted)]">
                  <Icon name={r.icon} size={14} className="text-[var(--primary)]" />
                </span>
              </div>
              <div className="text-center text-[13px] text-[var(--muted-foreground)] whitespace-pre-line">{r.yours}</div>
              <div className="text-center text-[13px] font-semibold text-[#1f2533] whitespace-pre-line">{r.theirs}</div>
            </div>
          ))}
        </div>

        {/* Time estimates */}
        <div className="mt-3 grid grid-cols-2 gap-3">
          <div className="rounded-2xl border border-[var(--border)] bg-white px-4 py-3.5 shadow-[0_1px_4px_rgba(30,25,70,0.04)]">
            <div className="flex items-center gap-1.5">
              <Icon name="clock" size={13} className="text-[var(--muted-foreground)]" />
              <span className="text-[11px] text-[var(--muted-foreground)]">Estimated starting time</span>
            </div>
            <div className="mt-1.5 text-[20px] font-bold text-[var(--primary)]">8:30 AM</div>
          </div>
          <div className="rounded-2xl border border-[var(--border)] bg-white px-4 py-3.5 shadow-[0_1px_4px_rgba(30,25,70,0.04)]">
            <div className="flex items-center gap-1.5">
              <Icon name="clock" size={13} className="text-[var(--muted-foreground)]" />
              <span className="text-[11px] text-[var(--muted-foreground)]">Estimated completion</span>
            </div>
            <div className="mt-1.5 text-[16px] font-bold text-[var(--primary)]">About 2 hr 30 min</div>
          </div>
        </div>

        {/* Info card with illustration */}
        <div className="mt-3 flex items-center gap-3 overflow-hidden rounded-2xl border border-[var(--border)] bg-white shadow-[0_1px_4px_rgba(30,25,70,0.04)]">
          <div className="flex-1 px-4 py-3">
            <div className="flex items-start gap-2">
              <Icon name="shield" size={16} className="shrink-0 mt-0.5 text-[var(--primary)]" />
              <p className="text-[12px] text-[var(--muted-foreground)] leading-relaxed">
                This sequence provides a steadier concrete flow for your selected volume and site access.
              </p>
            </div>
          </div>
          <img src={art.heroTruck} alt="ANTFAST truck" className="h-[90px] w-[110px] shrink-0 object-contain"
            style={{ padding: "4px 8px 4px 0" }} />
        </div>

        {/* Order footer row */}
        <div className="mt-3 flex items-center gap-2.5 rounded-xl border border-[var(--border)] bg-white px-4 py-3">
          <Icon name="box" size={15} className="shrink-0 text-[var(--muted-foreground)]" />
          <span className="text-[12.5px] text-[var(--muted-foreground)]">120 m³ · C30/37 · Main Villa Entrance</span>
        </div>

        <div className="mt-5 space-y-3">
          <PrimaryButton arrow onClick={() => nav.navigate("deliveryScheduled")}>
            Accept Proposal
          </PrimaryButton>
          <button type="button" onClick={nav.back}
            className="w-full rounded-2xl border-2 border-[var(--primary)] py-3.5 text-center text-[14px] font-semibold text-[var(--primary)]">
            Request Change
          </button>
        </div>
      </div>

      <BottomNav active="Home" />
    </div>
  );
}
