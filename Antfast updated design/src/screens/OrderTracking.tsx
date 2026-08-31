import { AppHeader, Badge, Icon } from "../components/ui";
import PrimaryButton from "../components/PrimaryButton";
import { art } from "../assets";
import { useNav } from "../nav";

const timeline = [
  { label: "Order confirmed", time: "07:12", done: true },
  { label: "Batching at plant", time: "07:48", done: true },
  { label: "En route to site", time: "08:05", done: true, active: true },
  { label: "Arriving at site", time: "~08:20", done: false },
  { label: "Pouring complete", time: "—", done: false },
];

export default function OrderTracking() {
  const nav = useNav();
  return (
    <div className="flex flex-1 flex-col">
      <AppHeader back />
      <div className="flex-1 overflow-y-auto pb-32">
        <div className="flex items-center justify-between px-6">
          <div>
            <h1 className="text-[20px] font-bold tracking-[-0.01em]">Order AF-2048</h1>
            <div className="text-[12px] text-[var(--muted-foreground)]">Palm Jumeirah Villa · 28 m³</div>
          </div>
          <Badge variant="onway">On the way</Badge>
        </div>

        {/* Live map — actual reference asset */}
        <div className="relative mt-3 overflow-hidden">
          <img src={art.routeMap} alt="Live delivery route from plant to site" className="h-[300px] w-full object-cover" />
          <div className="absolute left-4 top-4 flex items-center gap-2 rounded-full bg-white/95 px-3 py-1.5 shadow-[0_4px_14px_rgba(30,25,70,0.12)] backdrop-blur">
            <span className="flex h-2 w-2 rounded-full bg-[var(--primary)]" />
            <span className="text-[12px] font-semibold">3 trucks in transit</span>
          </div>
        </div>

        {/* ETA driver card */}
        <div className="mx-6 -mt-6 relative rounded-2xl border border-[var(--border)] bg-white p-4 shadow-[0_10px_30px_-12px_rgba(30,25,70,0.18)]">
          <div className="flex items-center gap-3">
            <span className="flex h-12 w-12 items-center justify-center rounded-2xl bg-[var(--primary-soft)] text-[var(--primary)]">
              <Icon name="truck" size={24} />
            </span>
            <div className="flex-1">
              <div className="text-[14px] font-bold">Lead Mixer · Truck 01</div>
              <div className="text-[12px] text-[var(--muted-foreground)]">Driver: Rahim K. · Plate D-48210</div>
            </div>
            <div className="text-right">
              <div className="text-[18px] font-bold text-[var(--primary)]">18 min</div>
              <div className="text-[11px] text-[var(--muted-foreground)]">ETA</div>
            </div>
          </div>
          <div className="mt-3 flex gap-2">
            <button className="flex flex-1 items-center justify-center gap-1.5 rounded-xl bg-[var(--primary-soft)] py-2.5 text-[13px] font-semibold text-[var(--primary)]">
              <Icon name="bell" size={16} /> Call driver
            </button>
            <button className="flex flex-1 items-center justify-center gap-1.5 rounded-xl border border-[var(--border)] py-2.5 text-[13px] font-semibold">
              <Icon name="pin" size={16} /> Share ETA
            </button>
          </div>
        </div>

        {/* Live pour scene */}
        <div className="mx-6 mt-4 overflow-hidden rounded-2xl border border-[var(--border)]">
          <img src={art.pumpPourHero} alt="ANTFAST mixer and pump delivering concrete on site" className="h-32 w-full object-cover" />
        </div>

        {/* Timeline */}
        <h2 className="mt-5 px-6 text-[15px] font-bold">Delivery Timeline</h2>
        <div className="mt-2 px-6">
          {timeline.map((t, i) => (
            <div key={t.label} className="flex gap-3">
              <div className="flex flex-col items-center">
                <span
                  className={`flex h-6 w-6 items-center justify-center rounded-full text-white ${
                    t.done ? "bg-[var(--primary)]" : "bg-[#e6e4f1] text-[#9b99b3]"
                  } ${t.active ? "ring-4 ring-[var(--primary-soft)]" : ""}`}
                >
                  {t.done ? <Icon name="check" size={13} strokeWidth={3} /> : <span className="h-2 w-2 rounded-full bg-[#c3c1d6]" />}
                </span>
                {i < timeline.length - 1 && <span className={`w-[2px] flex-1 ${t.done ? "bg-[var(--primary)]" : "bg-[#e2e0ef]"}`} />}
              </div>
              <div className={`flex flex-1 items-center justify-between pb-5 ${i === timeline.length - 1 ? "pb-0" : ""}`}>
                <span className={`text-[13.5px] ${t.active ? "font-bold text-[var(--primary)]" : t.done ? "font-semibold" : "text-[var(--muted-foreground)]"}`}>
                  {t.label}
                </span>
                <span className="text-[12px] text-[var(--muted-foreground)]">{t.time}</span>
              </div>
            </div>
          ))}
        </div>
      </div>

      <div className="absolute bottom-0 left-0 right-0 border-t border-[var(--border)] bg-white/95 px-6 pb-7 pt-3 backdrop-blur">
        <PrimaryButton arrow icon={<Icon name="doc" size={18} />} onClick={() => nav.navigate("wallet")}>
          View Order Details
        </PrimaryButton>
      </div>
    </div>
  );
}
