import type { ReactNode } from "react";
import AntfastLogo from "./AntfastLogo";
import { useNav, type ScreenId } from "../nav";

/* ---------------------------------------------------------------- Icons */

const paths: Record<string, ReactNode> = {
  back: <path d="M15 5l-7 7 7 7" />,
  chevronRight: <path d="M9 6l6 6-6 6" />,
  chevronDown: <path d="M6 9l6 6 6-6" />,
  chevronUp: <path d="M6 15l6-6 6 6" />,
  arrowRight: <path d="M5 12h14M13 6l6 6-6 6" />,
  bell: <path d="M18 8a6 6 0 1 0-12 0c0 7-3 9-3 9h18s-3-2-3-9M13.7 21a2 2 0 0 1-3.4 0" />,
  search: <><circle cx="11" cy="11" r="7" /><path d="M21 21l-4.3-4.3" /></>,
  lock: <><rect x="4" y="10" width="16" height="11" rx="2.5" /><path d="M8 10V7a4 4 0 0 1 8 0v3" /></>,
  eye: <><path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7-10-7-10-7Z" /><circle cx="12" cy="12" r="3" /></>,
  eyeOff: <><path d="M3 3l18 18M10.6 10.6a3 3 0 0 0 4.2 4.2M9.4 5.2A9.8 9.8 0 0 1 12 5c6.5 0 10 7 10 7a17 17 0 0 1-3.2 4M6.2 6.2A17 17 0 0 0 2 12s3.5 7 10 7a9.8 9.8 0 0 0 3-.5" /></>,
  user: <><circle cx="12" cy="8" r="4" /><path d="M4 21c0-4 3.6-7 8-7s8 3 8 7" /></>,
  building: <><rect x="5" y="3" width="14" height="18" rx="2" /><path d="M9 7h.01M15 7h.01M9 11h.01M15 11h.01M9 15h.01M15 15h.01M10 21v-3h4v3" /></>,
  home: <path d="M4 11l8-7 8 7M6 10v10h12V10" />,
  clipboard: <><rect x="6" y="4" width="12" height="17" rx="2.5" /><path d="M9 4a3 3 0 0 1 6 0" /></>,
  wallet: <><rect x="3" y="6" width="18" height="14" rx="3" /><path d="M3 10h18M17 15h.01" /></>,
  phone: <><rect x="6" y="2.5" width="12" height="19" rx="2.6" /><path d="M11 18.5h2" /></>,
  pin: <><path d="M12 21s7-6 7-11a7 7 0 0 0-14 0c0 5 7 11 7 11Z" /><circle cx="12" cy="10" r="2.5" /></>,
  clock: <><circle cx="12" cy="12" r="9" /><path d="M12 7v5l3 2" /></>,
  truck: <><path d="M3 6h11v9H3zM14 9h4l3 3v3h-7" /><circle cx="7" cy="18" r="2" /><circle cx="17.5" cy="18" r="2" /></>,
  check: <path d="M5 12l5 5 9-11" />,
  doc: <><path d="M7 3h7l5 5v13H7z" /><path d="M14 3v5h5M10 13h6M10 17h6" /></>,
  shield: <path d="M12 3l8 3v6c0 5-3.5 8-8 9-4.5-1-8-4-8-9V6z" />,
  layers: <path d="M12 3l9 5-9 5-9-5 9-5ZM3 13l9 5 9-5" />,
  factory: <><path d="M3 21V9l6 4V9l6 4V5h6v16z" /><path d="M8 17h.01M13 17h.01M18 17h.01" /></>,
  calendar: <><rect x="3" y="5" width="18" height="16" rx="2.5" /><path d="M3 10h18M8 3v4M16 3v4" /></>,
  plus: <path d="M12 5v14M5 12h14" />,
  minus: <path d="M5 12h14" />,
  sun: <><circle cx="12" cy="12" r="4" /><path d="M12 2v2M12 20v2M4 12H2M22 12h-2M5 5l1.5 1.5M17.5 17.5L19 19M19 5l-1.5 1.5M6.5 17.5L5 19" /></>,
  moon: <path d="M20 14a8 8 0 1 1-9-9 6 6 0 0 0 9 9Z" />,
  crosshair: <><circle cx="12" cy="12" r="7" /><path d="M12 2v3M12 19v3M2 12h3M19 12h3" /></>,
  box: <><path d="M12 3l8 4v10l-8 4-8-4V7z" /><path d="M4 7l8 4 8-4M12 11v10" /></>,
  edit: <path d="M4 20h4l10-10-4-4L4 16zM13 5l4 4" />,
  bridge: <path d="M3 8s3-2 9-2 9 2 9 2M4 8v11M20 8v11M4 12h16M9 12v7M15 12v7" />,
  card: <><rect x="2" y="5" width="20" height="14" rx="2.5" /><path d="M2 10h20M7 15h.01M11 15h4" /></>,
  cash: <><rect x="2" y="7" width="20" height="10" rx="2" /><circle cx="12" cy="12" r="2.5" /><path d="M6 12h.01M18 12h.01" /></>,
  download: <path d="M12 3v12M8 11l4 4 4-4M3 18v1a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-1" />,
  refresh: <path d="M4 12a8 8 0 0 1 14.9-3M20 12a8 8 0 0 1-14.9 3M20 4v4h-4M4 20v-4h4" />,
};

interface IconProps {
  name: keyof typeof paths | string;
  size?: number;
  className?: string;
  strokeWidth?: number;
  fill?: boolean;
}

export function Icon({ name, size = 22, className = "", strokeWidth = 1.9, fill = false }: IconProps) {
  return (
    <svg
      width={size}
      height={size}
      viewBox="0 0 24 24"
      fill={fill ? "currentColor" : "none"}
      stroke={fill ? "none" : "currentColor"}
      strokeWidth={strokeWidth}
      strokeLinecap="round"
      strokeLinejoin="round"
      className={className}
    >
      {paths[name] ?? null}
    </svg>
  );
}

/* --------------------------------------------------------------- Headers */

/** Branded header: centered logo + notification bell. */
export function AppHeader({ back, onBell }: { back?: boolean; onBell?: () => void }) {
  const nav = useNav();
  return (
    <div className="flex items-center justify-between px-6 pt-2 pb-3">
      <div className="w-8">
        {back && (
          <button onClick={nav.back} className="text-[var(--foreground)]" aria-label="Back">
            <Icon name="back" size={24} strokeWidth={2.2} />
          </button>
        )}
      </div>
      <AntfastLogo size={34} />
      <button onClick={onBell} className="relative w-8 text-[var(--foreground)]" aria-label="Notifications">
        <Icon name="bell" size={22} />
        <span className="absolute right-1 top-0 h-2 w-2 rounded-full bg-[var(--primary)]" />
      </button>
    </div>
  );
}

/** Plain header: back button + centered title + optional right slot. */
export function TitleHeader({ title, right }: { title: string; right?: ReactNode }) {
  const nav = useNav();
  return (
    <div className="flex items-center justify-between px-5 pt-2 pb-3">
      <button
        onClick={nav.back}
        className="flex h-10 w-10 items-center justify-center rounded-full bg-white text-[var(--foreground)] shadow-[0_2px_10px_rgba(30,25,70,0.06)]"
        aria-label="Back"
      >
        <Icon name="back" size={22} strokeWidth={2.2} />
      </button>
      <h1 className="text-[17px] font-semibold">{title}</h1>
      <div className="min-w-10 text-right text-[13px] font-medium text-[var(--muted-foreground)]">{right}</div>
    </div>
  );
}

/* ------------------------------------------------------------ Bottom nav */

const tabs: { id: ScreenId; label: string; icon: string }[] = [
  { id: "home", label: "Home", icon: "home" },
  { id: "orders", label: "Orders", icon: "clipboard" },
  { id: "projects", label: "Projects", icon: "building" },
  { id: "wallet", label: "Wallet", icon: "wallet" },
  { id: "home", label: "Profile", icon: "user" },
];

export function BottomNav({ active }: { active: string }) {
  const nav = useNav();
  return (
    <div className="absolute bottom-0 left-0 right-0 border-t border-[var(--border)] bg-white/95 px-3 pb-7 pt-2.5 backdrop-blur">
      <div className="flex items-stretch justify-between">
        {tabs.map((t, i) => {
          const on = t.label.toLowerCase() === active.toLowerCase();
          return (
            <button
              key={i}
              onClick={() => nav.navigate(t.id)}
              className={`flex flex-1 flex-col items-center gap-1 ${on ? "text-[var(--primary)]" : "text-[#9b99b3]"}`}
            >
              <Icon name={t.icon} size={23} strokeWidth={on ? 2.2 : 1.9} />
              <span className={`text-[11px] ${on ? "font-semibold" : "font-medium"}`}>{t.label}</span>
              {on && <span className="mt-0.5 h-1 w-1 rounded-full bg-[var(--primary)]" />}
            </button>
          );
        })}
      </div>
    </div>
  );
}

/* --------------------------------------------------------------- Inputs */

export function Field({
  label,
  placeholder,
  icon,
  trailing,
  value,
  type = "text",
}: {
  label?: string;
  placeholder?: string;
  icon?: string;
  trailing?: ReactNode;
  value?: string;
  type?: string;
}) {
  return (
    <div>
      {label && <label className="mb-2 block text-[12px] font-semibold tracking-wide text-[var(--muted-foreground)]">{label}</label>}
      <div className="flex items-center gap-3 rounded-2xl border border-[var(--border)] bg-white px-4 shadow-[0_1px_2px_rgba(30,25,70,0.03)] focus-within:border-[var(--primary)]">
        {icon && <Icon name={icon} size={20} className="text-[#9b99b3]" />}
        <input
          type={type}
          defaultValue={value}
          placeholder={placeholder}
          className="h-[54px] flex-1 bg-transparent text-[13px] text-[var(--foreground)] placeholder:text-[#a3a1b8] outline-none"
        />
        {trailing}
      </div>
    </div>
  );
}

/* ------------------------------------------------------- Segmented / tabs */

export function Segmented({
  options,
  value,
  onChange,
}: {
  options: string[];
  value: string;
  onChange: (v: string) => void;
}) {
  return (
    <div className="flex rounded-full bg-[var(--muted)] p-1.5">
      {options.map((o) => {
        const on = o === value;
        return (
          <button
            key={o}
            onClick={() => onChange(o)}
            className={`flex-1 rounded-full py-2.5 text-[14px] font-semibold transition-colors ${
              on ? "bg-[var(--primary)] text-white shadow-[0_6px_14px_-6px_rgba(91,75,224,0.7)]" : "text-[var(--muted-foreground)]"
            }`}
          >
            {o}
          </button>
        );
      })}
    </div>
  );
}

export function Chips({ options, value, onChange }: { options: string[]; value: string; onChange: (v: string) => void }) {
  return (
    <div className="flex gap-2 overflow-x-auto">
      {options.map((o) => {
        const on = o === value;
        return (
          <button
            key={o}
            onClick={() => onChange(o)}
            className={`whitespace-nowrap rounded-full px-4 py-2 text-[13px] font-medium transition-colors ${
              on ? "bg-[var(--primary)] text-white" : "bg-white text-[var(--muted-foreground)] border border-[var(--border)]"
            }`}
          >
            {o}
          </button>
        );
      })}
    </div>
  );
}

/* -------------------------------------------------------------- Badges */

type Tone = "scheduled" | "onway" | "confirm" | "completed" | "active" | "planning" | "review";

const tone: Record<Tone, { bg: string; fg: string; icon?: string }> = {
  scheduled: { bg: "var(--info-soft)", fg: "#3b6fd6", icon: "calendar" },
  onway: { bg: "var(--primary-soft)", fg: "var(--primary)", icon: "truck" },
  confirm: { bg: "var(--warning-soft)", fg: "var(--warning)", icon: "clock" },
  completed: { bg: "var(--success-soft)", fg: "var(--success)", icon: "check" },
  active: { bg: "var(--success-soft)", fg: "var(--success)" },
  planning: { bg: "var(--success-soft)", fg: "var(--success)" },
  review: { bg: "var(--muted)", fg: "var(--muted-foreground)" },
};

export function Badge({ children, variant = "scheduled" }: { children: ReactNode; variant?: Tone }) {
  const t = tone[variant];
  return (
    <span
      className="inline-flex items-center gap-1 rounded-full px-2.5 py-1 text-[11px] font-semibold"
      style={{ backgroundColor: t.bg, color: t.fg }}
    >
      {t.icon && <Icon name={t.icon} size={13} strokeWidth={2.2} />}
      {children}
    </span>
  );
}

/* --------------------------------------------------------- Step indicator */

export function StepRail({ steps, current }: { steps: string[]; current: number }) {
  return (
    <div className="flex items-start px-1">
      {steps.map((s, i) => {
        const done = i < current;
        const on = i === current;
        return (
          <div key={s} className="flex flex-1 flex-col items-center">
            <div className="flex w-full items-center">
              <div className={`h-[3px] flex-1 rounded-full ${i === 0 ? "opacity-0" : done || on ? "bg-[var(--primary)]" : "bg-[#e2e0ef]"}`} />
              <div
                className={`flex h-6 w-6 shrink-0 items-center justify-center rounded-full text-[11px] font-bold ${
                  done ? "bg-[var(--primary)] text-white" : on ? "bg-[var(--primary)] text-white ring-4 ring-[var(--primary-soft)]" : "bg-[#e6e4f1] text-[#9b99b3]"
                }`}
              >
                {done ? <Icon name="check" size={13} strokeWidth={3} /> : i + 1}
              </div>
              <div className={`h-[3px] flex-1 rounded-full ${i === steps.length - 1 ? "opacity-0" : done ? "bg-[var(--primary)]" : "bg-[#e2e0ef]"}`} />
            </div>
            <span className={`mt-1.5 text-[10px] ${on ? "font-semibold text-[var(--primary)]" : "text-[#9b99b3]"}`}>{s}</span>
          </div>
        );
      })}
    </div>
  );
}
