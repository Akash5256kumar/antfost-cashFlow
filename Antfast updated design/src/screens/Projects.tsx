import { AppHeader, Badge, BottomNav, Icon } from "../components/ui";
import PrimaryButton from "../components/PrimaryButton";
import { art, photos } from "../assets";
import { useNav } from "../nav";

const projects = [
  { name: "Palm Jumeirah Villa", loc: "Palm Jumeirah, Dubai", img: art.villaHero, locs: 4, orders: 2, status: "On Track", pct: 60, tone: "active" as const },
  { name: "Marina Tower", loc: "Dubai Marina, Dubai", img: photos.marinaTower, locs: 6, orders: 1, status: "On Track", pct: 35, tone: "active" as const },
  { name: "Creek Residence", loc: "Dubai Creek Harbour, Dubai", img: photos.creekResidence, locs: 5, orders: 0, status: "Planning", pct: 15, tone: "planning" as const },
];

function MiniStat({ icon, label, value }: { icon: string; label: string; value: string }) {
  return (
    <button className="flex flex-1 items-center gap-2.5 rounded-2xl border border-[var(--border)] bg-white p-3.5 text-left">
      <div className="flex h-9 w-9 items-center justify-center rounded-xl bg-[var(--muted)] text-[var(--primary)]">
        <Icon name={icon} size={18} />
      </div>
      <div className="flex-1">
        <div className="text-[11px] text-[var(--muted-foreground)]">{label}</div>
        <div className="text-[19px] font-bold leading-tight">{value}</div>
      </div>
      <Icon name="chevronRight" size={16} className="text-[#c3c1d6]" />
    </button>
  );
}

export default function Projects() {
  const nav = useNav();
  return (
    <div className="flex flex-1 flex-col">
      <AppHeader />
      <div className="flex-1 overflow-y-auto px-6 pb-28">
        <h1 className="text-[20px] font-bold tracking-[-0.01em]">Projects</h1>

        <div className="mt-3 flex gap-3">
          <MiniStat icon="building" label="Active Projects" value="3" />
          <MiniStat icon="pin" label="Saved Locations" value="7" />
        </div>

        <div className="mt-3 flex items-center gap-3 rounded-2xl border border-[var(--border)] bg-white px-4 py-3.5">
          <Icon name="search" size={19} className="text-[#9b99b3]" />
          <input placeholder="Search projects or locations" className="flex-1 bg-transparent text-[13px] outline-none placeholder:text-[#a3a1b8]" />
        </div>

        <div className="mt-4 space-y-3.5">
          {projects.map((p) => (
            <button
              key={p.name}
              onClick={() => nav.navigate("projectDetails")}
              className="w-full overflow-hidden rounded-2xl border border-[var(--border)] bg-white text-left shadow-[0_2px_12px_rgba(30,25,70,0.03)]"
            >
              <div className="flex gap-3 p-3">
                <img src={p.img} alt={p.name} className="h-[86px] w-[86px] rounded-xl object-cover" />
                <div className="flex-1">
                  <div className="flex items-center justify-between">
                    <span className="text-[15px] font-bold">{p.name}</span>
                    <Icon name="chevronRight" size={18} className="text-[#c3c1d6]" />
                  </div>
                  <div className="mt-0.5 flex items-center gap-1 text-[12px] text-[var(--muted-foreground)]">
                    <Icon name="pin" size={13} /> {p.loc}
                  </div>
                  <div className="mt-2 flex gap-4 text-[11px] text-[var(--muted-foreground)]">
                    <span><span className="font-bold text-[var(--foreground)]">{p.locs}</span> Saved Locations</span>
                    <span><span className="font-bold text-[var(--foreground)]">{p.orders}</span> Active Orders</span>
                  </div>
                  <div className="mt-2 flex items-center gap-2">
                    <Badge variant={p.tone}>{p.status}</Badge>
                    <div className="h-1.5 flex-1 overflow-hidden rounded-full bg-[#ececf3]">
                      <div className="h-full rounded-full bg-[var(--primary)]" style={{ width: `${p.pct}%` }} />
                    </div>
                    <span className="text-[11px] font-semibold text-[var(--muted-foreground)]">{p.pct}%</span>
                  </div>
                </div>
              </div>
            </button>
          ))}
        </div>

        <div className="mt-5">
          <PrimaryButton icon={<Icon name="plus" size={20} strokeWidth={2.4} />} onClick={() => nav.navigate("createProject")}>
            Add New Project
          </PrimaryButton>
        </div>
      </div>
      <BottomNav active="Projects" />
    </div>
  );
}
