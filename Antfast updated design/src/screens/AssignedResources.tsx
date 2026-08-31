import { useState } from "react";
import AntfastLogo from "../components/AntfastLogo";
import PrimaryButton from "../components/PrimaryButton";
import { Icon } from "../components/ui";
import { art } from "../assets";
import { useNav } from "../nav";

const TRUCKS_ACTIVE = [
  { name: "Truck 01 of 4", status: "Pouring", statusColor: "var(--primary)", eta: "18:24" },
  { name: "Truck 02 of 4", status: "Site Checkpoint", statusColor: "#3b6fd6", eta: "02:10" },
  { name: "Truck 03 of 4", status: "Approaching", statusColor: "#f59e0b", eta: "08 min" },
  { name: "Truck 04 of 4", status: "Completed", statusColor: "#16a34a", eta: "10:12" },
];

export default function AssignedResources() {
  const nav = useNav();
  const [tab, setTab] = useState<"Active" | "History">("Active");

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

      <div className="flex-1 overflow-y-auto pb-8 px-5">
        <h1 className="mt-2 text-[24px] font-bold tracking-[-0.01em] text-[#1f2533]">Assigned Resources</h1>
        <div className="text-[12px] text-[var(--muted-foreground)]">AF-2048 · Palm Jumeirah Villa</div>

        {/* Summary */}
        <div className="mt-3 flex items-center gap-2">
          <div className="flex items-center gap-1.5 rounded-full bg-[var(--primary-soft)] px-3 py-1">
            <span className="h-1.5 w-1.5 rounded-full bg-[var(--primary)]" />
            <span className="text-[12px] font-semibold text-[var(--primary)]">3 Active</span>
          </div>
          <div className="flex items-center gap-1.5 rounded-full bg-[#dcfce7] px-3 py-1">
            <Icon name="check" size={11} strokeWidth={3} className="text-[#16a34a]" />
            <span className="text-[12px] font-semibold text-[#16a34a]">1 Completed</span>
          </div>
        </div>

        {/* Map */}
        <div className="mt-3 overflow-hidden rounded-2xl shadow-[0_4px_16px_rgba(30,25,70,0.08)]">
          <img src={art.pumpSiteMap} alt="Resource locations map" className="block w-full object-cover"
            style={{ height: 190, objectPosition: "center" }} />
        </div>

        {/* Tabs */}
        <div className="mt-4 flex border-b border-[var(--border)]">
          {(["Active", "History"] as const).map((t) => (
            <button key={t} type="button" onClick={() => setTab(t)}
              className={`px-4 pb-2.5 text-[13px] font-semibold transition-all ${tab === t ? "border-b-2 border-[var(--primary)] text-[var(--primary)]" : "text-[var(--muted-foreground)]"}`}>
              {t}
            </button>
          ))}
        </div>

        <div className="mt-1 mb-2 text-[11.5px] text-[var(--muted-foreground)]">Each truck progresses independently.</div>

        {/* Truck list */}
        <div className="space-y-2">
          {TRUCKS_ACTIVE.map((t) => {
            const isHistory = t.status === "Completed";
            return (
              <button key={t.name} type="button"
                className={`flex w-full items-center gap-3 rounded-2xl border border-[var(--border)] bg-white px-4 py-3.5 shadow-[0_1px_4px_rgba(30,25,70,0.04)] ${isHistory ? "opacity-50" : ""}`}>
                <div className="flex h-10 w-14 shrink-0 items-center justify-center rounded-lg bg-[#f5f4fa]">
                  <img src={art.heroTruck} alt={t.name} className="h-full w-full rounded-lg object-contain" style={{ padding: "2px" }} />
                </div>
                <div className="flex-1 text-left">
                  <div className="text-[13px] font-semibold text-[#1f2533]">{t.name}</div>
                  <div className="mt-0.5 flex items-center gap-1.5">
                    <span className="h-1.5 w-1.5 rounded-full" style={{ backgroundColor: t.statusColor }} />
                    <span className="text-[12px] font-medium" style={{ color: t.statusColor }}>{t.status}</span>
                  </div>
                </div>
                <div className="flex items-center gap-1.5">
                  {!isHistory && <Icon name="clock" size={13} className="text-[var(--muted-foreground)]" />}
                  <span className="text-[13px] font-bold text-[#1f2533]">{t.eta}</span>
                  <Icon name="chevronRight" size={14} className="text-[var(--muted-foreground)]" />
                </div>
              </button>
            );
          })}
        </div>

        <div className="mt-5">
          <button type="button" onClick={() => nav.navigate("liveTracking")}
            className="flex w-full items-center justify-center gap-2 rounded-2xl bg-[var(--primary)] py-4 text-[15px] font-semibold text-white shadow-[0_8px_24px_rgba(91,75,224,0.3)]">
            <Icon name="pin" size={18} />
            Open Live Map
          </button>
        </div>
      </div>
    </div>
  );
}
