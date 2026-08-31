import AntfastLogo from "../components/AntfastLogo";
import PrimaryButton from "../components/PrimaryButton";
import { BottomNav, Icon } from "../components/ui";
import { art } from "../assets";
import { useNav } from "../nav";

const RESOURCES = [
  { name: "Pump", status: "At Site", statusColor: "#16a34a", eta: "Ready" },
  { name: "Truck 01", status: "At Checkpoint", statusColor: "#3b6fd6", eta: "03:42" },
  { name: "Truck 02", status: "Approaching", statusColor: "#f59e0b", eta: "05 min" },
  { name: "Truck 03", status: "Following", statusColor: "#f59e0b", eta: "12 min" },
];

const STEPS = ["Arrived", "Site Checkpoint", "Pouring"];

export default function SiteCheckpoint() {
  const nav = useNav();

  return (
    <div className="flex flex-1 flex-col">
      {/* Header */}
      <div className="flex items-center justify-between px-5 pt-2 pb-1">
        <button type="button" onClick={nav.back}
          className="flex h-10 w-10 items-center justify-center rounded-full bg-white shadow-[0_2px_10px_rgba(30,25,70,0.06)]">
          <Icon name="back" size={22} strokeWidth={2.2} />
        </button>
        <div className="text-center">
          <div className="text-[17px] font-bold text-[#1f2533]">Site Checkpoint</div>
          <div className="text-[11px] text-[var(--muted-foreground)]">AF-2057 · Palm Jumeirah Villa</div>
        </div>
        <div className="w-10" />
      </div>

      <div className="flex-1 overflow-y-auto pb-28">
        {/* Status chip */}
        <div className="mx-5 mt-1 flex justify-center">
          <div className="inline-flex items-center gap-1.5 rounded-full bg-[#fef3c7] px-3 py-1">
            <span className="h-1.5 w-1.5 rounded-full bg-[#b45309]" />
            <span className="text-[11px] font-semibold text-[#b45309]">Site access confirmation in progress</span>
          </div>
        </div>

        {/* Map */}
        <div className="mt-2 overflow-hidden">
          <img src={art.checkpointMap} alt="Site checkpoint map" className="block w-full object-cover"
            style={{ height: 220, objectPosition: "center" }} />
        </div>

        {/* Step progress */}
        <div className="mx-5 mt-4 flex items-center">
          {STEPS.map((s, i) => {
            const done = i < 1;
            const current = i === 1;
            return (
              <div key={s} className="flex flex-1 flex-col items-center">
                <div className="flex w-full items-center">
                  <div className={`h-0.5 flex-1 ${i === 0 ? "opacity-0" : done || current ? "bg-[var(--primary)]" : "bg-[#e2e0ef]"}`} />
                  <div className={`flex h-7 w-7 shrink-0 items-center justify-center rounded-full text-[11px] font-bold border-2 ${done ? "border-[var(--primary)] bg-[var(--primary)] text-white" : current ? "border-[var(--primary)] bg-white text-[var(--primary)]" : "border-[#d3d1e4] bg-white text-[var(--muted-foreground)]"}`}>
                    {done ? <Icon name="check" size={14} strokeWidth={3} /> : i + 1}
                  </div>
                  <div className={`h-0.5 flex-1 ${i === STEPS.length - 1 ? "opacity-0" : done ? "bg-[var(--primary)]" : "bg-[#e2e0ef]"}`} />
                </div>
                <span className={`mt-1 text-[10px] text-center leading-tight ${current ? "font-bold text-[var(--primary)]" : "text-[var(--muted-foreground)]"}`}>{s}</span>
              </div>
            );
          })}
        </div>

        {/* Resources */}
        <div className="mx-5 mt-4">
          <div className="text-[14px] font-bold text-[#1f2533]">Pump + Trucks</div>
          <div className="mt-2 overflow-hidden rounded-2xl border border-[var(--border)] bg-white shadow-[0_2px_8px_rgba(30,25,70,0.04)]">
            {RESOURCES.map((r, i) => (
              <div key={r.name} className={`flex items-center gap-3 px-4 py-3.5 ${i < RESOURCES.length - 1 ? "border-b border-[var(--border)]" : ""}`}>
                <div className="flex h-9 w-14 shrink-0 items-center justify-center rounded-lg bg-[#f5f4fa]">
                  <img src={art.heroTruck} alt={r.name} className="h-full w-full rounded-lg object-contain" style={{ padding: "2px" }} />
                </div>
                <div className="flex-1">
                  <div className="text-[13px] font-semibold text-[#1f2533]">{r.name}</div>
                  <div className="mt-0.5 flex items-center gap-1">
                    <span className="h-1.5 w-1.5 rounded-full" style={{ backgroundColor: r.statusColor }} />
                    <span className="text-[11px] font-medium" style={{ color: r.statusColor }}>{r.status}</span>
                  </div>
                </div>
                <span className="text-[13px] font-bold text-[#1f2533]">{r.eta}</span>
              </div>
            ))}
          </div>
        </div>

        <div className="mt-4 px-5">
          <div className="mb-2 text-center text-[11px] text-[var(--muted-foreground)]">Site access confirmation in progress</div>
          <PrimaryButton arrow onClick={() => nav.navigate("pouring")}>
            View Resource Sequence
          </PrimaryButton>
        </div>
      </div>

      <BottomNav active="Orders" />
    </div>
  );
}
