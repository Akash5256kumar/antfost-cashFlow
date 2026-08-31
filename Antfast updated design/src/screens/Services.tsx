import { useState } from "react";
import AntfastLogo from "../components/AntfastLogo";
import PrimaryButton from "../components/PrimaryButton";
import { BottomNav, Icon, StepRail } from "../components/ui";
import { art } from "../assets";
import { useNav } from "../nav";
import { ORDER_STEPS } from "./MixCode";

const APP_TYPES: { id: string; svg: JSX.Element }[] = [
  {
    id: "Slab",
    svg: (
      <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round">
        <rect x="2" y="9" width="20" height="4" rx="1" />
        <path d="M5 9V6M12 9V6M19 9V6M5 13v3M12 13v3M19 13v3" />
      </svg>
    ),
  },
  {
    id: "Raft",
    svg: (
      <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round">
        <rect x="2" y="14" width="20" height="3" rx="1" />
        <path d="M6 14V8M10 14V10M14 14V10M18 14V8" />
        <path d="M4 8h16" />
      </svg>
    ),
  },
  {
    id: "Pile",
    svg: (
      <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round">
        <rect x="2" y="4" width="20" height="3" rx="1" />
        <path d="M7 7v13M12 7v13M17 7v13" />
      </svg>
    ),
  },
  {
    id: "Column",
    svg: (
      <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round">
        <rect x="5" y="3" width="4" height="18" rx="1" />
        <rect x="15" y="3" width="4" height="18" rx="1" />
        <path d="M3 5h18M3 19h18" />
      </svg>
    ),
  },
];

const PUMP_SIZES = [
  { id: "small", label: "Small Pump", desc: "Up to 42 m" },
  { id: "medium", label: "Medium Pump", desc: "43–52 m" },
  { id: "big", label: "Big Pump", desc: "53 m and above" },
];

const EXTRAS = [
  { id: "temp", icon: "sun", label: "Temperature Control", desc: "Special temperature requirement" },
  { id: "lab", icon: "shield", label: "Laboratory Testing", desc: "Testing to meet project specifications" },
  { id: "other", icon: "box", label: "Other Approved Service", desc: "Add a service request" },
];

export default function Services() {
  const nav = useNav();
  const [typeOpen, setTypeOpen] = useState(false);
  const [appType, setAppType] = useState("Slab");
  const [pump, setPump] = useState(true);
  const [pumpOpen, setPumpOpen] = useState(true);
  const [pumpSize, setPumpSize] = useState("medium");
  const [technician, setTechnician] = useState(true);
  const [techOpen, setTechOpen] = useState(true);
  const [cubeMould, setCubeMould] = useState(6);
  const [extras, setExtras] = useState<Record<string, boolean>>({});
  const [extrasOpen, setExtrasOpen] = useState<Record<string, boolean>>({});

  return (
    <div className="flex flex-1 flex-col">
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

      <div className="px-5 pt-1 pb-1">
        <StepRail steps={ORDER_STEPS} current={4} />
      </div>

      <div className="flex-1 overflow-y-auto px-6 pb-28">
        <h1 className="mt-2 text-[20px] font-bold tracking-[-0.01em] text-[#1f2533]">Choose Services</h1>
        <p className="mt-0.5 text-[13px] text-[var(--muted-foreground)]">Select the structure type and services required for this delivery.</p>

        {/* Structure Type */}
        <div className="mt-4">
          <div className="mb-1.5 text-[12px] font-semibold text-[#1f2533]">Structure Type</div>
          <div className="overflow-hidden rounded-2xl border border-[var(--border)] bg-white shadow-[0_2px_8px_rgba(30,25,70,0.04)]">
            <button type="button"
              onClick={() => setTypeOpen((v) => !v)}
              className="flex w-full items-center gap-3 px-4 py-3.5 text-left">
              <div className="flex h-9 w-9 items-center justify-center rounded-xl bg-[var(--muted)] text-[var(--primary)]">
                {APP_TYPES.find((t) => t.id === appType)?.svg}
              </div>
              <span className="flex-1 text-[14px] font-semibold text-[#1f2533]">{appType}</span>
              <Icon name={typeOpen ? "chevronUp" : "chevronDown"} size={18} className="text-[var(--muted-foreground)]" />
            </button>
            {typeOpen && (
              <div className="border-t border-[var(--border)]">
                {APP_TYPES.map((t) => (
                  <button key={t.id} type="button"
                    onClick={() => { setAppType(t.id); setTypeOpen(false); }}
                    className="flex w-full items-center gap-3 px-4 py-3">
                    <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-[var(--muted)] text-[var(--primary)]">
                      {t.svg}
                    </div>
                    <span className="flex-1 text-left text-[13px] text-[#1f2533]">{t.id}</span>
                    <span className={`flex h-5 w-5 items-center justify-center rounded-full border-2 ${appType === t.id ? "border-[var(--primary)] bg-[var(--primary)]" : "border-[#d3d1e4]"}`}>
                      {appType === t.id && <span className="h-2 w-2 rounded-full bg-white" />}
                    </span>
                  </button>
                ))}
              </div>
            )}
          </div>
        </div>

        {/* Concrete Pump */}
        <div className="mt-3 overflow-hidden rounded-2xl border border-[var(--border)] bg-white shadow-[0_2px_8px_rgba(30,25,70,0.04)]">
          <div className="flex items-center gap-3 px-4 py-3">
            <button type="button"
              onClick={() => setPump((v) => !v)}
              className={`flex h-5 w-5 shrink-0 items-center justify-center rounded-[5px] border-2 ${pump ? "border-[var(--primary)] bg-[var(--primary)]" : "border-[#d3d1e4]"}`}>
              {pump && <Icon name="check" size={11} strokeWidth={3} className="text-white" />}
            </button>
            <img src={art.pumpPourHero} alt="Concrete pump truck" className="h-10 w-16 rounded-lg object-cover" style={{ objectPosition: "center 30%" }} />
            <div className="flex-1">
              <div className="text-[13px] font-semibold text-[#1f2533]">Concrete Pump</div>
              <div className="text-[11px] text-[var(--muted-foreground)]">Assigned and tracked as a separate resource</div>
            </div>
            {pump && (
              <button type="button" onClick={() => setPumpOpen((v) => !v)}>
                <Icon name={pumpOpen ? "chevronUp" : "chevronDown"} size={18} className="text-[var(--muted-foreground)]" />
              </button>
            )}
          </div>

          {pump && pumpOpen && (
            <div className="border-t border-[var(--border)] px-4 pb-4 pt-3">
              <div className="mb-2 text-[12px] font-semibold text-[#1f2533]">Choose Pump Size</div>
              <div className="grid grid-cols-3 gap-2">
                {PUMP_SIZES.map((p) => {
                  const on = pumpSize === p.id;
                  return (
                    <button key={p.id} type="button"
                      onClick={() => setPumpSize(p.id)}
                      className={`flex flex-col items-center rounded-xl border py-3 px-1 text-center transition-all ${on ? "border-[var(--primary)] bg-[var(--primary-soft)]/30" : "border-[var(--border)] bg-[var(--muted)]"}`}>
                      <span className={`flex h-4 w-4 items-center justify-center rounded-full border-2 ${on ? "border-[var(--primary)] bg-[var(--primary)]" : "border-[#d3d1e4]"}`}>
                        {on && <span className="h-2 w-2 rounded-full bg-white" />}
                      </span>
                      <span className={`mt-1.5 text-[11px] font-semibold ${on ? "text-[var(--primary)]" : "text-[#1f2533]"}`}>{p.label}</span>
                      <span className="mt-0.5 text-[10px] text-[var(--muted-foreground)]">{p.desc}</span>
                    </button>
                  );
                })}
              </div>
            </div>
          )}
        </div>

        {/* Technician */}
        <div className="mt-3 overflow-hidden rounded-2xl border border-[var(--border)] bg-white shadow-[0_2px_8px_rgba(30,25,70,0.04)]">
          <div className="flex items-center gap-3 px-4 py-3">
            <button type="button"
              onClick={() => setTechnician((v) => !v)}
              className={`flex h-5 w-5 shrink-0 items-center justify-center rounded-[5px] border-2 ${technician ? "border-[var(--primary)] bg-[var(--primary)]" : "border-[#d3d1e4]"}`}>
              {technician && <Icon name="check" size={11} strokeWidth={3} className="text-white" />}
            </button>
            <img src={art.villaPumpHero} alt="Technician on site" className="h-10 w-16 rounded-lg object-cover" style={{ objectPosition: "center top" }} />
            <div className="flex-1">
              <div className="text-[13px] font-semibold text-[#1f2533]">Technician</div>
              <div className="text-[11px] text-[var(--muted-foreground)]">On-site support for sampling and quality control</div>
            </div>
            {technician && (
              <button type="button" onClick={() => setTechOpen((v) => !v)}>
                <Icon name={techOpen ? "chevronUp" : "chevronDown"} size={18} className="text-[var(--muted-foreground)]" />
              </button>
            )}
          </div>

          {technician && techOpen && (
            <div className="border-t border-[var(--border)] px-4 pb-4 pt-3">
              <div className="mb-2 text-[12px] font-semibold text-[#1f2533]">Cube Mould Quantity</div>
              <div className="flex items-center gap-5">
                <button type="button"
                  onClick={() => setCubeMould((v) => Math.max(6, v - 1))}
                  className="flex h-10 w-10 items-center justify-center rounded-xl border border-[var(--border)] bg-[var(--muted)] text-[#1f2533] text-[20px] font-bold">
                  −
                </button>
                <span className="w-8 text-center text-[24px] font-bold text-[#1f2533]">{cubeMould}</span>
                <button type="button"
                  onClick={() => setCubeMould((v) => v + 1)}
                  className="flex h-10 w-10 items-center justify-center rounded-xl bg-[var(--primary)] text-white text-[20px] font-bold">
                  +
                </button>
                <span className="text-[11px] text-[var(--muted-foreground)]">Minimum 6</span>
              </div>
            </div>
          )}
        </div>

        {/* Extra services */}
        <div className="mt-3 space-y-2">
          {EXTRAS.map((e) => {
            const on = extras[e.id];
            const open = extrasOpen[e.id];
            return (
              <div key={e.id} className="overflow-hidden rounded-2xl border border-[var(--border)] bg-white shadow-[0_2px_8px_rgba(30,25,70,0.04)]">
                <div className="flex items-center gap-3 px-4 py-3.5">
                  <button type="button"
                    onClick={() => setExtras((v) => ({ ...v, [e.id]: !v[e.id] }))}
                    className={`flex h-5 w-5 shrink-0 items-center justify-center rounded-[5px] border-2 ${on ? "border-[var(--primary)] bg-[var(--primary)]" : "border-[#d3d1e4]"}`}>
                    {on && <Icon name="check" size={11} strokeWidth={3} className="text-white" />}
                  </button>
                  <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-[var(--muted)] text-[var(--primary)]">
                    <Icon name={e.icon} size={16} />
                  </div>
                  <div className="flex-1">
                    <div className="text-[13px] font-semibold text-[#1f2533]">{e.label}</div>
                    <div className="text-[11px] text-[var(--muted-foreground)]">{e.desc}</div>
                  </div>
                  <button type="button" onClick={() => setExtrasOpen((v) => ({ ...v, [e.id]: !v[e.id] }))}>
                    <Icon name={open ? "chevronUp" : "chevronDown"} size={18} className="text-[var(--muted-foreground)]" />
                  </button>
                </div>
              </div>
            );
          })}
        </div>

        <div className="mt-5">
          <PrimaryButton arrow onClick={() => nav.navigate("siteAccess")}>
            Continue to Site Access
          </PrimaryButton>
        </div>
      </div>
      <BottomNav active="Home" />
    </div>
  );
}
