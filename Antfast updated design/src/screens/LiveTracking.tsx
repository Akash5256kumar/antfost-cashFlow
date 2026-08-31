import { BottomNav, Icon } from "../components/ui";
import { art } from "../assets";
import { useNav } from "../nav";
import AntfastLogo from "../components/AntfastLogo";
import PrimaryButton from "../components/PrimaryButton";

const TRUCKS = [
  { id: "01", status: "Arrived", statusColor: "#16a34a", eta: "08:56", etaLabel: "08:56" },
  { id: "02", status: "Approaching", statusColor: "#3b6fd6", eta: "05 min", etaLabel: "05 min" },
  { id: "03", status: "Following", statusColor: "#f59e0b", eta: "12 min", etaLabel: "12 min" },
];

export default function LiveTracking() {
  const nav = useNav();

  return (
    <div className="flex flex-1 flex-col">
      {/* Header */}
      <div className="flex items-center justify-between px-5 pt-2 pb-1">
        <button type="button" onClick={nav.back}
          className="flex h-10 w-10 items-center justify-center rounded-full bg-white shadow-[0_2px_10px_rgba(30,25,70,0.06)]">
          <Icon name="back" size={22} strokeWidth={2.2} />
        </button>
        <span className="text-[17px] font-bold text-[#1f2533]">Live Delivery</span>
        <div className="w-10" />
      </div>

      <div className="flex-1 overflow-y-auto pb-28">
        {/* Order card */}
        <div className="mx-5 mt-2 flex items-center justify-between rounded-2xl border border-[var(--border)] bg-white px-4 py-3 shadow-[0_2px_8px_rgba(30,25,70,0.04)]">
          <div>
            <div className="flex items-center gap-1.5">
              <span className="text-[13px] font-bold text-[#1f2533]">AF-2048 · Palm Jumeirah Villa</span>
            </div>
            <div className="mt-1 flex items-center gap-1.5">
              <Icon name="check" size={13} strokeWidth={3} className="text-[#16a34a]" />
              <span className="text-[12px] font-semibold text-[#16a34a]">Arrived at Site</span>
            </div>
          </div>
          <div className="flex items-center gap-1.5 rounded-full border border-[var(--border)] px-2.5 py-1">
            <Icon name="truck" size={12} className="text-[var(--muted-foreground)]" />
            <span className="text-[11px] font-semibold text-[var(--muted-foreground)]">Trucks Only</span>
          </div>
        </div>

        {/* Location pill */}
        <button type="button" className="mx-5 mt-2 flex w-full items-center justify-between rounded-xl border border-[var(--border)] bg-white px-4 py-2.5">
          <div className="flex items-center gap-2">
            <Icon name="pin" size={15} className="text-[var(--primary)]" />
            <span className="text-[13px] font-medium text-[#1f2533]">Main Villa Entrance</span>
          </div>
          <Icon name="chevronRight" size={15} className="text-[var(--muted-foreground)]" />
        </button>

        {/* Map */}
        <div className="mt-2 overflow-hidden">
          <img src={art.routeMap} alt="Live delivery map" className="block w-full object-cover"
            style={{ height: 240, objectPosition: "center" }} />
        </div>

        {/* Trucks section */}
        <div className="mt-3 px-5">
          <div className="flex items-center gap-2 mb-3">
            <Icon name="truck" size={16} className="text-[var(--muted-foreground)]" />
            <span className="text-[13px] font-bold text-[#1f2533]">Trucks Only</span>
            <span className="text-[12px] text-[var(--muted-foreground)]">· 3 trucks delivering concrete</span>
          </div>

          <div className="space-y-2">
            {TRUCKS.map((t) => (
              <button key={t.id} type="button" onClick={() => nav.navigate("siteCheckpoint")}
                className="flex w-full items-center gap-3 rounded-2xl border border-[var(--border)] bg-white px-4 py-3.5 shadow-[0_1px_4px_rgba(30,25,70,0.04)]">
                <div className="flex h-10 w-14 shrink-0 items-center justify-center rounded-lg bg-[#f5f4fa]">
                  <img src={art.heroTruck} alt="Truck" className="h-full w-full rounded-lg object-contain" style={{ padding: "2px" }} />
                </div>
                <div className="flex-1 text-left">
                  <div className="text-[13px] font-semibold text-[#1f2533]">Truck {t.id}</div>
                  <div className="mt-0.5 flex items-center gap-1.5">
                    <span className="h-1.5 w-1.5 rounded-full" style={{ backgroundColor: t.statusColor }} />
                    <span className="text-[12px] font-medium" style={{ color: t.statusColor }}>{t.status}</span>
                  </div>
                </div>
                <div className="flex items-center gap-1.5">
                  <Icon name="clock" size={13} className="text-[var(--muted-foreground)]" />
                  <span className="text-[12px] font-semibold text-[#1f2533]">{t.etaLabel}</span>
                  <Icon name="chevronRight" size={14} className="text-[var(--muted-foreground)]" />
                </div>
              </button>
            ))}
          </div>

          <div className="mt-4">
            <PrimaryButton arrow onClick={() => nav.navigate("siteCheckpoint")}>
              View Site Progress
            </PrimaryButton>
          </div>
        </div>
      </div>

      <BottomNav active="Orders" />
    </div>
  );
}
