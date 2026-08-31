import AntfastLogo from "../components/AntfastLogo";
import PrimaryButton from "../components/PrimaryButton";
import { BottomNav, Icon } from "../components/ui";
import { art } from "../assets";
import { useNav } from "../nav";

const STATS = [
  { label: "Delivered", value: "120 m³" },
  { label: "Concrete Grade", value: "C30/37" },
  { label: "Services", value: "Pump + Technician" },
  { label: "Date", value: "Tuesday\n12 August" },
];

export default function DeliveryComplete() {
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

      <div className="flex-1 overflow-y-auto pb-28 px-5">
        <h1 className="mt-2 text-[28px] font-bold tracking-[-0.01em] text-[#1f2533]">Delivery Completed</h1>
        <div className="mt-2 inline-flex items-center gap-1.5 rounded-full bg-[#dcfce7] px-3 py-1">
          <Icon name="check" size={12} strokeWidth={3} className="text-[#16a34a]" />
          <span className="text-[12px] font-semibold text-[#16a34a]">Completed</span>
        </div>

        {/* Delivery illustration */}
        <div className="mt-4 overflow-hidden rounded-2xl shadow-[0_4px_20px_rgba(30,25,70,0.1)]">
          <img src={art.deliveredVilla} alt="Delivery completed" className="block w-full object-cover"
            style={{ height: 200, objectPosition: "center 30%" }} />
        </div>

        {/* Order row */}
        <div className="mt-4 flex items-center gap-2.5 rounded-xl border border-[var(--border)] bg-white px-4 py-3">
          <Icon name="home" size={16} className="shrink-0 text-[var(--primary)]" />
          <span className="text-[13px] font-semibold text-[#1f2533]">AF-2057 · Palm Jumeirah Villa</span>
        </div>

        {/* Stats row */}
        <div className="mt-3 grid grid-cols-4 gap-2">
          {STATS.map((s) => (
            <div key={s.label} className="flex flex-col items-center rounded-xl border border-[var(--border)] bg-white py-3 px-1 text-center shadow-[0_1px_4px_rgba(30,25,70,0.04)]">
              <div className="text-[11px] font-bold text-[#1f2533] whitespace-pre-line leading-tight">{s.value}</div>
              <div className="mt-1 text-[10px] text-[var(--muted-foreground)]">{s.label}</div>
            </div>
          ))}
        </div>

        {/* Completion checks */}
        <div className="mt-3 space-y-2">
          {[
            { icon: "truck", label: "8 of 8 trucks completed", sub: "All scheduled trucks have been delivered." },
            { icon: "factory", label: "Pump service completed", sub: "Concrete pumping and site service completed." },
          ].map((item) => (
            <div key={item.label} className="flex items-start gap-3 rounded-2xl border border-[var(--border)] bg-white px-4 py-3.5 shadow-[0_1px_4px_rgba(30,25,70,0.04)]">
              <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-xl bg-[#dcfce7]">
                <Icon name={item.icon} size={16} className="text-[#16a34a]" />
              </div>
              <div className="flex-1">
                <div className="text-[13px] font-bold text-[#1f2533]">{item.label}</div>
                <div className="mt-0.5 text-[11.5px] text-[var(--muted-foreground)]">{item.sub}</div>
              </div>
              <Icon name="check" size={18} strokeWidth={2.5} className="shrink-0 text-[#16a34a]" />
            </div>
          ))}
        </div>

        {/* Documents */}
        <div className="mt-4">
          <div className="mb-2 text-[14px] font-bold text-[#1f2533]">Documents</div>
          <div className="overflow-hidden rounded-2xl border border-[var(--border)] bg-white shadow-[0_2px_8px_rgba(30,25,70,0.04)]">
            {[
              { label: "Download Invoice" },
              { label: "Download Receipt" },
            ].map((d, i) => (
              <button key={d.label} type="button"
                className={`flex w-full items-center justify-between px-4 py-3.5 ${i < 1 ? "border-b border-[var(--border)]" : ""}`}>
                <div className="flex items-center gap-2.5">
                  <Icon name="doc" size={16} className="text-[var(--primary)]" />
                  <span className="text-[13px] font-medium text-[#1f2533]">{d.label}</span>
                </div>
                <Icon name="download" size={16} className="text-[var(--muted-foreground)]" />
              </button>
            ))}
          </div>
        </div>

        <div className="mt-5 space-y-3">
          <PrimaryButton arrow onClick={() => nav.navigate("rateDelivery")}
            icon={
              <svg viewBox="0 0 24 24" width="18" height="18" fill="currentColor">
                <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z" />
              </svg>
            }>
            Rate Delivery
          </PrimaryButton>
          <button type="button"
            className="flex w-full items-center justify-center gap-2 rounded-2xl border-2 border-[var(--primary)] py-3.5 text-[14px] font-semibold text-[var(--primary)]">
            View Order Summary
          </button>
          <button type="button" onClick={() => nav.jump("home")}
            className="flex w-full items-center justify-center gap-2 rounded-2xl border border-[var(--border)] py-3 text-[14px] font-semibold text-[var(--muted-foreground)]">
            <Icon name="home" size={16} />
            Back to Home
          </button>
        </div>
      </div>

      <BottomNav active="Home" />
    </div>
  );
}
