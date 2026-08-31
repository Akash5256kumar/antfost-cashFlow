import { useState } from "react";
import { AppHeader, BottomNav, Icon, StepRail } from "../components/ui";
import PrimaryButton from "../components/PrimaryButton";
import { art } from "../assets";
import { useNav } from "../nav";

export const ORDER_STEPS = ["Project", "Mix Code", "Quantity", "Schedule", "Services", "Site Access", "Review"];

const mixes = [
  { code: "C30/37", desc: "General Structural", size: "20 mm", slump: "S3", psi: "5,365 PSI", mpa: "37 MPa", img: art.concreteCube },
  { code: "C40/50", desc: "High Strength", size: "20 mm", slump: "S3", psi: "7,252 PSI", mpa: "50 MPa", img: art.concreteCube },
  { code: "C25/30", desc: "Foundations", size: "20 mm", slump: "S3", psi: "4,351 PSI", mpa: "30 MPa", img: art.concreteCube },
];

export default function MixCode() {
  const nav = useNav();
  const [sel, setSel] = useState("C30/37");

  return (
    <div className="flex flex-1 flex-col" style={{ background: "var(--background)" }}>
      <AppHeader />
      <div className="px-5 pb-2">
        <StepRail steps={ORDER_STEPS} current={1} />
      </div>
      <div className="flex-1 overflow-y-auto px-6 pb-28">
        <h1 className="mt-2 text-[22px] font-bold tracking-[-0.01em] text-[#1f2533]">Select Mix Code</h1>
        <p className="mt-1 text-[13.5px] text-[var(--muted-foreground)]">Choose the right concrete mix for your project.</p>

        <div className="mt-4 flex items-center gap-3 rounded-2xl border border-[var(--border)] bg-white px-4 py-3.5 shadow-[0_2px_8px_rgba(30,25,70,0.05)]">
          <Icon name="search" size={19} className="text-[#9b99b3]" />
          <input placeholder="Search code or concrete grade" className="flex-1 bg-transparent text-[13px] outline-none placeholder:text-[#a3a1b8]" />
        </div>

        <div className="mt-4 space-y-3">
          {mixes.map((m) => {
            const on = m.code === sel;
            return (
              <button
                key={m.code}
                onClick={() => setSel(m.code)}
                className={`flex w-full items-center gap-3.5 rounded-2xl border p-3 text-left transition-all shadow-[0_2px_8px_rgba(30,25,70,0.05)] ${
                  on ? "border-[var(--primary)] bg-[var(--primary-soft)]/40" : "border-[var(--border)] bg-white"
                }`}
              >
                <img src={m.img} alt={m.code} className="h-16 w-16 rounded-xl object-cover" />
                <div className="flex-1">
                  <div className="text-[14px] font-bold text-[#1f2533]">{m.code}</div>
                  <div className="text-[12.5px] text-[var(--muted-foreground)]">{m.desc}</div>
                  <div className="mt-1.5 flex flex-wrap gap-1.5">
                    <span className="rounded-md bg-[var(--muted)] px-2 py-0.5 text-[11px] font-medium text-[var(--muted-foreground)]">{m.size}</span>
                    <span className="rounded-md bg-[var(--muted)] px-2 py-0.5 text-[11px] font-medium text-[var(--muted-foreground)]">{m.slump}</span>
                    <span className={`rounded-md px-2 py-0.5 text-[11px] font-semibold ${on ? "bg-[var(--primary-soft)] text-[var(--primary)]" : "bg-[var(--muted)] text-[var(--muted-foreground)]"}`}>{m.mpa}</span>
                    <span className={`rounded-md px-2 py-0.5 text-[11px] font-medium ${on ? "bg-[var(--primary-soft)] text-[var(--primary)]" : "bg-[var(--muted)] text-[var(--muted-foreground)]"}`}>{m.psi}</span>
                  </div>
                </div>
                <span className={`flex h-5 w-5 shrink-0 items-center justify-center rounded-full border-2 ${on ? "border-[var(--primary)]" : "border-[#d3d1e4]"}`}>
                  {on && <span className="h-2.5 w-2.5 rounded-full bg-[var(--primary)]" />}
                </span>
              </button>
            );
          })}
        </div>

        <div className="mt-6">
          <PrimaryButton arrow onClick={() => nav.navigate("quantity")}>
            Continue to Quantity
          </PrimaryButton>
        </div>
      </div>
      <BottomNav active="Home" />
    </div>
  );
}
