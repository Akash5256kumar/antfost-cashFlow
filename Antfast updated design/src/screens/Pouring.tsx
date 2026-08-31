import AntfastLogo from "../components/AntfastLogo";
import PrimaryButton from "../components/PrimaryButton";
import { BottomNav, Icon } from "../components/ui";
import { art } from "../assets";
import { useNav } from "../nav";

const STEPS = [
  { label: "Arrived", time: "09:05", done: true },
  { label: "Site Checkpoint", time: "09:18", done: true },
  { label: "Pouring", time: "09:21", done: true },
];

export default function Pouring() {
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
          <div className="text-[17px] font-bold text-[#1f2533]">Pouring</div>
          <div className="text-[11px] text-[var(--muted-foreground)]">AF-2048 · Palm Jumeirah Villa</div>
        </div>
        <div className="w-10" />
      </div>

      <div className="flex-1 overflow-y-auto pb-28">
        {/* Status badge */}
        <div className="mx-5 mt-1 flex justify-center">
          <div className="inline-flex items-center gap-1.5 rounded-full bg-[var(--primary-soft)] px-3 py-1">
            <span className="h-1.5 w-1.5 rounded-full bg-[var(--primary)]" />
            <span className="text-[11px] font-semibold text-[var(--primary)]">Delivery in progress</span>
          </div>
        </div>

        {/* Map */}
        <div className="mt-2 overflow-hidden">
          <img src={art.villaRouteMap} alt="Pouring site map" className="block w-full object-cover"
            style={{ height: 230, objectPosition: "center" }} />
        </div>

        <div className="px-5 mt-4">
          {/* Active truck card */}
          <div className="overflow-hidden rounded-2xl border border-[var(--border)] bg-white shadow-[0_2px_8px_rgba(30,25,70,0.04)]">
            <div className="flex items-center gap-3 px-4 py-3.5 border-b border-[var(--border)]">
              <img src={art.heroTruck} alt="Truck 01" className="h-10 w-14 rounded-lg object-cover"
                style={{ objectPosition: "center 30%" }} />
              <div className="flex-1">
                <div className="text-[14px] font-bold text-[#1f2533]">Truck 01 of 3</div>
                <div className="flex items-center gap-1.5 mt-0.5">
                  <span className="h-1.5 w-1.5 rounded-full bg-[var(--primary)]" />
                  <span className="text-[12px] font-semibold text-[var(--primary)]">Actively pouring</span>
                </div>
              </div>
            </div>

            {/* Step progress inline */}
            <div className="flex items-center px-4 py-3">
              {STEPS.map((s, i) => (
                <div key={s.label} className="flex flex-1 flex-col items-center">
                  <div className="flex w-full items-center">
                    <div className={`h-0.5 flex-1 ${i === 0 ? "opacity-0" : "bg-[var(--primary)]"}`} />
                    <div className="flex h-6 w-6 shrink-0 items-center justify-center rounded-full bg-[var(--primary)]">
                      <Icon name="check" size={13} strokeWidth={3} className="text-white" />
                    </div>
                    <div className={`h-0.5 flex-1 ${i === STEPS.length - 1 ? "opacity-0" : "bg-[var(--primary)]"}`} />
                  </div>
                  <div className="mt-1 text-center">
                    <div className="text-[10px] font-semibold text-[var(--primary)]">{s.label}</div>
                    <div className="text-[10px] text-[var(--muted-foreground)]">{s.time}</div>
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Expected pour window */}
          <div className="mt-3 flex items-center gap-2.5 rounded-xl border border-[var(--border)] bg-white px-4 py-3">
            <Icon name="clock" size={15} className="shrink-0 text-[var(--primary)]" />
            <p className="text-[12.5px] text-[var(--muted-foreground)]">Expected pour window: <span className="font-semibold text-[#1f2533]">20–35 min</span> · Timing may adjust to site conditions.</p>
          </div>

          <div className="mt-5">
            <PrimaryButton arrow onClick={() => nav.navigate("assignedResources")}>
              View All Trucks
            </PrimaryButton>
          </div>
        </div>
      </div>

      <BottomNav active="Orders" />
    </div>
  );
}
