import { useState } from "react";
import AntfastLogo from "../components/AntfastLogo";
import PrimaryButton from "../components/PrimaryButton";
import Illustration from "../components/Illustration";
import { Icon, StepRail } from "../components/ui";
import { art } from "../assets";
import { useNav } from "../nav";
import { ORDER_STEPS } from "./MixCode";

const days = [
  { d: "Sun", n: "10 Aug" },
  { d: "Mon", n: "11 Aug" },
  { d: "Tue", n: "12 Aug" },
  { d: "Wed", n: "13 Aug" },
  { d: "Thu", n: "14 Aug" },
];

const windows = [
  { label: "Morning", time: "06:00–12:00", icon: "sun" },
  { label: "Midday", time: "12:00–16:00", icon: "sun" },
  { label: "Afternoon", time: "16:00–00:00", icon: "sun" },
  { label: "Early Night", time: "00:00–06:00", icon: "moon" },
];

export default function Schedule() {
  const nav = useNav();
  const [day, setDay] = useState(2);
  const [win, setWin] = useState(0);
  const [interval, setInterval] = useState(15);

  return (
    <div className="flex flex-1 flex-col">
      <div className="flex items-center justify-between px-5 pt-2 pb-1">
        <button
          onClick={nav.back}
          className="flex h-10 w-10 items-center justify-center rounded-full bg-white shadow-[0_2px_10px_rgba(30,25,70,0.06)]"
          aria-label="Back"
        >
          <Icon name="back" size={22} strokeWidth={2.2} />
        </button>
        <AntfastLogo style={{ width: 140, height: "auto" }} />
        <button className="relative flex h-10 w-10 items-center justify-center rounded-full bg-white shadow-[0_2px_10px_rgba(30,25,70,0.06)] text-[var(--foreground)]" aria-label="Notifications">
          <Icon name="bell" size={20} />
          <span className="absolute right-1.5 top-1.5 h-2 w-2 rounded-full bg-[var(--primary)]" />
        </button>
      </div>
      <div className="px-5 pt-2 pb-1">
        <StepRail steps={ORDER_STEPS} current={3} />
      </div>

      <div className="flex-1 overflow-y-auto px-6 pb-8">
        <h1 className="mt-2 text-[20px] font-bold tracking-[-0.01em]">Choose Schedule</h1>
        <p className="mt-1 text-[13.5px] text-[var(--muted-foreground)]">Select your preferred date and time window.</p>

        {/* Date selector */}
        <div className="mt-4 flex items-center gap-2">
          <button className="flex h-9 w-9 shrink-0 items-center justify-center rounded-xl border border-[var(--border)] bg-white text-[var(--muted-foreground)]">
            <Icon name="back" size={16} strokeWidth={2.4} />
          </button>
          <div className="flex flex-1 gap-2 overflow-x-auto">
            {days.map((d, i) => {
              const on = i === day;
              return (
                <button
                  key={d.n}
                  onClick={() => setDay(i)}
                  className={`flex min-w-[58px] flex-col items-center gap-1 rounded-2xl border px-2 py-2.5 ${
                    on ? "border-[var(--primary)] bg-white" : "border-[var(--border)] bg-white"
                  }`}
                >
                  <span className={`text-[12px] ${on ? "font-semibold text-[var(--primary)]" : "text-[var(--muted-foreground)]"}`}>{d.d}</span>
                  <span className="text-[12px] font-semibold">{d.n}</span>
                  {on && (
                    <span className="flex h-4 w-4 items-center justify-center rounded-full bg-[var(--primary)]">
                      <Icon name="check" size={10} strokeWidth={3.4} className="text-white" />
                    </span>
                  )}
                </button>
              );
            })}
          </div>
          <button className="flex h-9 w-9 shrink-0 items-center justify-center rounded-xl border border-[var(--border)] bg-white text-[var(--muted-foreground)]">
            <Icon name="chevronRight" size={16} strokeWidth={2.4} />
          </button>
        </div>

        {/* Time windows */}
        <h2 className="mt-5 text-[13px] font-bold">Select Time Window</h2>
        <div className="mt-2 grid grid-cols-4 gap-2">
          {windows.map((w, i) => {
            const on = i === win;
            return (
              <button
                key={w.label}
                onClick={() => setWin(i)}
                className={`flex flex-col items-center gap-1 rounded-2xl border px-1 py-3 ${
                  on ? "border-[var(--primary)] bg-[var(--primary-soft)]/40" : "border-[var(--border)] bg-white"
                }`}
              >
                <Icon name={w.icon} size={20} className={on ? "text-[var(--primary)]" : "text-[#9b99b3]"} />
                <span className="text-[11px] font-semibold">{w.label}</span>
                <span className="text-[9px] text-[var(--muted-foreground)]">{w.time}</span>
                {on && (
                  <span className="flex h-4 w-4 items-center justify-center rounded-full bg-[var(--primary)]">
                    <Icon name="check" size={10} strokeWidth={3.4} className="text-white" />
                  </span>
                )}
              </button>
            );
          })}
        </div>

        {/* Supply interval */}
        <h2 className="mt-5 text-[13px] font-bold">Requested Supply Interval</h2>
        <div className="mt-2 flex items-center justify-between rounded-2xl border border-[var(--border)] bg-white px-3 py-2.5">
          <button onClick={() => setInterval((v) => Math.max(5, v - 5))} className="flex h-9 w-9 items-center justify-center rounded-xl bg-[var(--primary-soft)] text-[var(--primary)]">
            <Icon name="minus" size={18} strokeWidth={2.6} />
          </button>
          <span className="text-[15px] font-bold">{interval} min</span>
          <button onClick={() => setInterval((v) => v + 5)} className="flex h-9 w-9 items-center justify-center rounded-xl bg-[var(--primary-soft)] text-[var(--primary)]">
            <Icon name="plus" size={18} strokeWidth={2.6} />
          </button>
        </div>
        <p className="mt-2 text-[11.5px] text-[var(--muted-foreground)]">Requested interval helps ANTFAST prepare your proposal.</p>

        {/* Notes */}
        <h2 className="mt-4 text-[13px] font-bold">
          Schedule Notes <span className="font-normal text-[var(--muted-foreground)]">(Optional)</span>
        </h2>
        <div className="mt-2 rounded-2xl border border-[var(--border)] bg-white p-3">
          <textarea
            rows={2}
            maxLength={200}
            placeholder="Add any notes or instructions for your delivery..."
            className="w-full resize-none bg-transparent text-[13px] outline-none placeholder:text-[#a3a1b8]"
          />
          <div className="text-right text-[11px] text-[var(--muted-foreground)]">0/200</div>
        </div>

        <div className="mt-4">
          <PrimaryButton arrow onClick={() => nav.navigate("services")}>
            Continue to Services
          </PrimaryButton>
        </div>

        <div className="-mx-6 mt-3 overflow-hidden">
          <Illustration src={art.plantSceneSoft} alt="ANTFAST mixer truck at a plant" className="max-h-[120px] opacity-80" fade={10} />
        </div>
      </div>
    </div>
  );
}
