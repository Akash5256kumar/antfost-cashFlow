import { useState } from "react";
import PrimaryButton from "../components/PrimaryButton";
import { Icon, TitleHeader } from "../components/ui";
import { useNav } from "../nav";

const options = [
  { id: "business", icon: "building", title: "Business", desc: "For companies with industrial licences." },
  { id: "individual", icon: "user", title: "Individual", desc: "For personal use." },
];

export default function AccountType() {
  const nav = useNav();
  const [sel, setSel] = useState("business");

  return (
    <div className="flex flex-1 flex-col px-6 pb-8">
      <TitleHeader title="Create Account" right="Step 1 of 3" />

      <h2 className="mt-3 text-[22px] font-bold tracking-[-0.01em] text-[#1f2533]">How will you use ANTFAST?</h2>
      <p className="mt-1 text-[13px] text-[var(--muted-foreground)]">Choose one account type to continue.</p>

      <div className="mt-6 space-y-4">
        {options.map((o) => {
          const on = sel === o.id;
          return (
            <button
              key={o.id}
              onClick={() => setSel(o.id)}
              className={`flex w-full items-center gap-4 rounded-3xl border p-5 text-left transition-all ${
                on ? "border-[var(--primary)] bg-white shadow-[0_10px_30px_-16px_rgba(91,75,224,0.3)]" : "border-[var(--border)] bg-white"
              }`}
            >
              <div className={`flex h-11 w-11 items-center justify-center rounded-2xl ${on ? "bg-[var(--primary-soft)] text-[var(--primary)]" : "bg-[var(--muted)] text-[var(--primary)]"}`}>
                <Icon name={o.icon} size={22} />
              </div>
              <div className="flex-1">
                <div className="text-[15px] font-bold text-[#1f2533]">{o.title}</div>
                <div className="mt-0.5 text-[13px] leading-snug text-[var(--muted-foreground)]">{o.desc}</div>
              </div>
              <div className={`mt-0.5 flex h-6 w-6 items-center justify-center rounded-full border-2 ${on ? "border-[var(--primary)] bg-[var(--primary)]" : "border-[#d3d1e4]"}`}>
                {on && <Icon name="check" size={13} strokeWidth={3} className="text-white" />}
              </div>
            </button>
          );
        })}
      </div>

      <div className="mt-auto pt-8">
        <PrimaryButton arrow onClick={() => nav.navigate(sel === "business" ? "createBusiness" : "createIndividual")}>
          Continue
        </PrimaryButton>
      </div>
    </div>
  );
}
