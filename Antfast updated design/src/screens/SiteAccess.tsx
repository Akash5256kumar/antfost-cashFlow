import { useState } from "react";
import AntfastLogo from "../components/AntfastLogo";
import PrimaryButton from "../components/PrimaryButton";
import { BottomNav, Icon, StepRail } from "../components/ui";
import { useNav } from "../nav";
import { ORDER_STEPS } from "./MixCode";

const CONDITIONS = [
  { id: "narrow", icon: "bridge", label: "Narrow Access", desc: "Limited access for large vehicles." },
  { id: "permit", icon: "doc", label: "Road Permit Required", desc: "A road permit is required for delivery." },
  { id: "boom", icon: "truck", label: "Boom Reach Restriction", desc: "Limited pump boom reach on site." },
  { id: "night", icon: "moon", label: "Night Delivery Access", desc: "Access available during night hours." },
];

export default function SiteAccess() {
  const nav = useNav();
  const [vals, setVals] = useState<Record<string, boolean | null>>({ narrow: true, permit: true, boom: false, night: false });
  const [confirmed, setConfirmed] = useState(true);

  const allAnswered = CONDITIONS.every((c) => vals[c.id] !== null && vals[c.id] !== undefined);

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
        <StepRail steps={ORDER_STEPS} current={5} />
      </div>

      <div className="flex-1 overflow-y-auto px-6 pb-6">
        <h1 className="mt-2 text-[20px] font-bold tracking-[-0.01em] text-[#1f2533]">Site Access Requirements</h1>
        <p className="mt-0.5 text-[13px] text-[var(--muted-foreground)]">Answer Yes or No for every site condition.</p>

        <div className="mt-4 space-y-3">
          {CONDITIONS.map((c) => {
            const yes = vals[c.id] === true;
            const no = vals[c.id] === false;

            return (
              <div key={c.id}
                className={`overflow-hidden rounded-2xl border ${yes ? "border-[var(--primary)]" : "border-[var(--border)]"} bg-white shadow-[0_2px_8px_rgba(30,25,70,0.04)]`}>
                <div className="flex items-center gap-3 px-4 py-3.5">
                  <div className={`flex h-9 w-9 shrink-0 items-center justify-center rounded-xl ${yes ? "bg-[var(--primary)] text-white" : "bg-[var(--muted)] text-[var(--primary)]"}`}>
                    <Icon name={c.icon} size={18} />
                  </div>
                  <div className="flex-1">
                    <div className="text-[13px] font-semibold text-[#1f2533]">{c.label}</div>
                    <div className="text-[11px] text-[var(--muted-foreground)]">{c.desc}</div>
                  </div>
                </div>

                <div className="border-t border-[var(--border)] flex gap-2 px-4 pb-3 pt-2.5">
                  <button type="button"
                    onClick={() => setVals((v) => ({ ...v, [c.id]: true }))}
                    className={`flex-1 rounded-xl py-2.5 text-[13px] font-bold transition-all ${yes ? "bg-[var(--primary)] text-white" : "border border-[var(--border)] bg-[var(--muted)] text-[#1f2533]"}`}>
                    Yes
                  </button>
                  <button type="button"
                    onClick={() => setVals((v) => ({ ...v, [c.id]: false }))}
                    className={`flex-1 rounded-xl py-2.5 text-[13px] font-bold transition-all ${no ? "bg-[var(--primary)] text-white" : "border border-[var(--border)] bg-[var(--muted)] text-[#1f2533]"}`}>
                    No
                  </button>
                </div>

                {/* Conditional attachment: narrow access photo */}
                {c.id === "narrow" && yes && (
                  <div className="border-t border-[var(--border)] px-4 pb-3 pt-2.5">
                    <div className="text-[11px] font-semibold text-[var(--muted-foreground)] mb-2">Access photo</div>
                    <div className="relative inline-block">
                      <div className="h-16 w-16 rounded-xl bg-[#d9dce8] flex items-center justify-center overflow-hidden">
                        <Icon name="pin" size={22} className="text-[var(--primary)]" />
                      </div>
                      <button type="button"
                        className="absolute -right-1.5 -top-1.5 flex h-5 w-5 items-center justify-center rounded-full bg-[#444] text-white text-[10px]">
                        ×
                      </button>
                    </div>
                  </div>
                )}

                {/* Conditional attachment: road permit */}
                {c.id === "permit" && yes && (
                  <div className="border-t border-[var(--border)] px-4 pb-3 pt-2.5">
                    <div className="text-[11px] font-semibold text-[var(--muted-foreground)] mb-2">Road permit</div>
                    <div className="flex items-center gap-2 rounded-xl border border-[var(--border)] bg-[var(--muted)] px-3 py-2">
                      <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-[#fee2e2] text-[#dc2626]">
                        <span className="text-[9px] font-bold">PDF</span>
                      </div>
                      <div className="flex-1">
                        <div className="text-[12px] font-semibold text-[#1f2533]">Road_Permit_AF-2048.pdf</div>
                        <div className="text-[10px] text-[var(--muted-foreground)]">1.2 MB</div>
                      </div>
                      <button type="button" className="text-[var(--muted-foreground)]">×</button>
                    </div>
                  </div>
                )}
              </div>
            );
          })}
        </div>

        {/* Confirm checkbox */}
        <button type="button" onClick={() => setConfirmed((v) => !v)}
          className="mt-4 flex items-center gap-3">
          <div className={`flex h-5 w-5 shrink-0 items-center justify-center rounded-[5px] border-2 ${confirmed ? "border-[var(--primary)] bg-[var(--primary)]" : "border-[#d3d1e4]"}`}>
            {confirmed && <Icon name="check" size={11} strokeWidth={3} className="text-white" />}
          </div>
          <span className="text-[12.5px] text-[var(--muted-foreground)]">I confirm the site information and access instructions are accurate.</span>
        </button>

        <div className="mt-4 space-y-3">
          <PrimaryButton arrow onClick={() => nav.navigate("reviewOrder")}>
            Continue to Review
          </PrimaryButton>
          <PrimaryButton variant="outline" onClick={nav.back}>
            Save Draft
          </PrimaryButton>
        </div>
      </div>
      <BottomNav active="Home" />
    </div>
  );
}
