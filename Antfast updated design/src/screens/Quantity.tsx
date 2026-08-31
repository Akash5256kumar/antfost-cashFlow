import { useState } from "react";
import { AppHeader, BottomNav, Icon, StepRail } from "../components/ui";
import PrimaryButton from "../components/PrimaryButton";
import Illustration from "../components/Illustration";
import { art } from "../assets";
import { useNav } from "../nav";
import { ORDER_STEPS } from "./MixCode";

export default function Quantity() {
  const nav = useNav();
  const [qty, setQty] = useState(120);

  return (
    <div className="flex flex-1 flex-col">
      <AppHeader />
      <div className="px-5 pb-2">
        <StepRail steps={ORDER_STEPS} current={2} />
      </div>
      <div className="flex-1 overflow-y-auto px-6 pb-28">
        <h1 className="mt-2 text-center text-[20px] font-bold tracking-[-0.01em]">Enter Quantity</h1>

        <div className="-mx-6 mt-2 flex justify-center overflow-hidden">
          <Illustration src={art.concreteCube} alt="Concrete test cube with aggregate" className="max-h-[220px]" />
        </div>

        <div className="mt-2 rounded-3xl border border-[var(--border)] bg-white p-5 shadow-[0_4px_20px_rgba(30,25,70,0.04)]">
          <div className="flex items-center justify-between">
            <button
              onClick={() => setQty((q) => Math.max(1, q - 1))}
              className="flex h-12 w-12 items-center justify-center rounded-2xl bg-[var(--primary-soft)] text-[var(--primary)]"
            >
              <Icon name="minus" size={22} strokeWidth={2.6} />
            </button>
            <div className="text-center">
              <div className="text-[46px] font-bold leading-none tracking-tight">{qty}</div>
              <div className="text-[15px] font-semibold text-[var(--muted-foreground)]">m³</div>
            </div>
            <button
              onClick={() => setQty((q) => q + 1)}
              className="flex h-12 w-12 items-center justify-center rounded-2xl bg-[var(--primary-soft)] text-[var(--primary)]"
            >
              <Icon name="plus" size={22} strokeWidth={2.6} />
            </button>
          </div>
          <div className="mt-4 flex items-center justify-center gap-1.5 text-[12.5px] text-[var(--muted-foreground)]">
            <Icon name="edit" size={15} /> Enter exact required volume
          </div>
        </div>

        <div className="mt-6">
          <PrimaryButton arrow onClick={() => nav.navigate("schedule")}>
            Continue to Schedule
          </PrimaryButton>
        </div>
      </div>
      <BottomNav active="Home" />
    </div>
  );
}
