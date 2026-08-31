import AntfastLogo from "../components/AntfastLogo";
import PrimaryButton from "../components/PrimaryButton";
import { Icon } from "../components/ui";
import { art } from "../assets";
import { useNav } from "../nav";

export default function DeliveryScheduled() {
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
        <h1 className="mt-3 text-[26px] font-bold tracking-[-0.01em] text-[#1f2533]">Delivery Scheduled</h1>
        <div className="mt-2 inline-flex items-center gap-1.5 rounded-full bg-[var(--primary-soft)] px-3 py-1">
          <Icon name="calendar" size={13} className="text-[var(--primary)]" />
          <span className="text-[12px] font-semibold text-[var(--primary)]">Scheduled</span>
        </div>

        {/* Hero image */}
        <div className="mt-4 overflow-hidden rounded-2xl shadow-[0_4px_20px_rgba(30,25,70,0.1)]">
          <img src={art.villaPumpHero} alt="Concrete pump at villa" className="block w-full object-cover"
            style={{ height: 180, objectPosition: "center 30%" }} />
        </div>

        {/* Date + time */}
        <div className="mt-4 flex items-center gap-3 rounded-2xl border border-[var(--border)] bg-white px-4 py-4 shadow-[0_2px_8px_rgba(30,25,70,0.04)]">
          <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-[var(--primary-soft)]">
            <Icon name="calendar" size={20} className="text-[var(--primary)]" />
          </div>
          <div>
            <div className="text-[12px] text-[var(--muted-foreground)]">Tuesday · 12 August</div>
            <div className="text-[28px] font-bold leading-tight text-[#1f2533]">08:30</div>
          </div>
        </div>

        {/* Details */}
        <div className="mt-3 overflow-hidden rounded-2xl border border-[var(--border)] bg-white shadow-[0_2px_8px_rgba(30,25,70,0.04)]">
          {[
            { icon: "layers", value: "120 m³ · C30/37" },
            { icon: "clock", value: "12 min interval" },
            { icon: "user", value: "Pump + Technician" },
            { icon: "pin", value: "Main Villa Entrance" },
          ].map((r, i, arr) => (
            <div key={r.value} className={`flex items-center gap-3 px-4 py-3.5 ${i < arr.length - 1 ? "border-b border-[var(--border)]" : ""}`}>
              <Icon name={r.icon} size={18} className="shrink-0 text-[var(--muted-foreground)]" />
              <span className="text-[13.5px] font-medium text-[#1f2533]">{r.value}</span>
            </div>
          ))}
        </div>

        {/* Estimated supply window */}
        <div className="mt-3 flex items-center gap-3 rounded-2xl border border-[var(--border)] bg-white px-4 py-4 shadow-[0_2px_8px_rgba(30,25,70,0.04)]">
          <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-[var(--primary-soft)]">
            <Icon name="clock" size={20} className="text-[var(--primary)]" />
          </div>
          <div>
            <div className="text-[12px] text-[var(--muted-foreground)]">Estimated Supply Window</div>
            <div className="text-[22px] font-bold text-[#1f2533]">08:30–11:00</div>
            <div className="text-[11px] text-[var(--muted-foreground)]">Updates automatically if the delivery plan changes</div>
          </div>
        </div>

        {/* Notification note */}
        <div className="mt-3 flex items-center gap-2.5 rounded-xl border border-[var(--border)] bg-white px-4 py-3">
          <Icon name="bell" size={15} className="shrink-0 text-[var(--primary)]" />
          <p className="text-[12px] text-[var(--muted-foreground)]">{"We'll notify you when loading is completed."}</p>
        </div>

        <div className="mt-5 space-y-3">
          <PrimaryButton arrow onClick={() => nav.navigate("orderDetails")}>
            View Order Details
          </PrimaryButton>
          <button type="button"
            className="flex w-full items-center justify-center gap-2 rounded-2xl border-2 border-[var(--primary)] py-3.5 text-[14px] font-semibold text-[var(--primary)]">
            <Icon name="calendar" size={18} />
            Add to Calendar
          </button>
        </div>
      </div>
    </div>
  );
}
