import { useState } from "react";
import { AppHeader, BottomNav, Icon } from "../components/ui";
import PrimaryButton from "../components/PrimaryButton";
import { photos } from "../assets";
import { useNav } from "../nav";

const locations = [
  { name: "Main Villa Entrance", project: "Palm Jumeirah Villa", area: "Palm Jumeirah, Dubai", img: photos.villa },
  { name: "Service Gate", project: "Palm Jumeirah Villa", area: "Palm Jumeirah, Dubai", img: photos.neighborhood },
  { name: "Tower Loading Bay", project: "Marina Tower", area: "Dubai Marina, Dubai", img: photos.marinaTower },
  { name: "Main Site Entrance", project: "Creek Residence", area: "Dubai Creek Harbour, Dubai", img: photos.creekResidence },
];

export default function SavedLocations() {
  const nav = useNav();
  const [sel, setSel] = useState(0);

  return (
    <div className="flex flex-1 flex-col" style={{ background: "var(--background)" }}>
      <AppHeader back />
      <div className="flex-1 overflow-y-auto px-6 pb-28">
        <h1 className="text-[22px] font-bold tracking-[-0.01em] text-[#1f2533]">Saved Locations</h1>
        <p className="mt-1 text-[12.5px] text-[var(--muted-foreground)]">Choose a location to create an order for.</p>

        <div className="mt-4 flex items-center gap-3 rounded-2xl border border-[var(--border)] bg-white px-4 py-3.5 shadow-[0_2px_8px_rgba(30,25,70,0.05)]">
          <Icon name="search" size={19} className="text-[#9b99b3]" />
          <input placeholder="Search saved locations" className="flex-1 bg-transparent text-[13px] outline-none placeholder:text-[#a3a1b8]" />
        </div>

        <div className="mt-4 space-y-3">
          {locations.map((l, i) => {
            const on = i === sel;
            return (
              <button
                key={l.name}
                onClick={() => setSel(i)}
                className={`flex w-full items-center gap-3 rounded-2xl border p-3 text-left transition-all shadow-[0_2px_8px_rgba(30,25,70,0.03)] ${
                  on ? "border-[var(--primary)] bg-[var(--primary-soft)]/20" : "border-[var(--border)] bg-white"
                }`}
              >
                <img src={l.img} alt={l.name} className="h-16 w-16 shrink-0 rounded-xl object-cover" />
                <div className="flex-1">
                  <div className={`text-[13.5px] font-bold ${on ? "text-[var(--primary)]" : "text-[#1f2533]"}`}>{l.name}</div>
                  <div className="text-[12.5px] font-semibold text-[var(--muted-foreground)]">{l.project}</div>
                  <div className="mt-0.5 flex items-center gap-1 text-[11.5px] text-[var(--muted-foreground)]">
                    <Icon name="pin" size={12} /> {l.area}
                  </div>
                </div>
                <span className={`flex h-5 w-5 shrink-0 items-center justify-center rounded-full border-2 ${on ? "border-[var(--primary)] bg-[var(--primary)]" : "border-[#d3d1e4]"}`}>
                  {on && <span className="h-2 w-2 rounded-full bg-white" />}
                </span>
              </button>
            );
          })}
        </div>

        <div className="mt-5">
          <PrimaryButton arrow onClick={() => nav.navigate("mixCode")}>
            Create New Order
          </PrimaryButton>
        </div>
      </div>
      <BottomNav active="Projects" />
    </div>
  );
}
