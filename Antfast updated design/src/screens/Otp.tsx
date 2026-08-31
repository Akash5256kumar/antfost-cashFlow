import { useState } from "react";
import PrimaryButton from "../components/PrimaryButton";
import Illustration from "../components/Illustration";
import { Icon } from "../components/ui";
import { art } from "../assets";
import { useNav } from "../nav";

export default function Otp() {
  const nav = useNav();
  const [code, setCode] = useState("124");

  const digits = Array.from({ length: 6 }, (_, i) => code[i] ?? "");
  const activeIndex = Math.min(code.length, 5);

  const press = (n: string) => setCode((c) => (c.length < 6 ? c + n : c));
  const del = () => setCode((c) => c.slice(0, -1));

  return (
    <div className="flex flex-1 flex-col px-6 pb-6">
      <div className="pt-2">
        <button
          onClick={nav.back}
          className="flex h-10 w-10 items-center justify-center rounded-full bg-white shadow-[0_2px_10px_rgba(30,25,70,0.06)]"
          aria-label="Back"
        >
          <Icon name="back" size={22} strokeWidth={2.2} />
        </button>
      </div>

      <h1 className="mt-5 text-center text-[22px] font-bold tracking-[-0.01em] text-[#1f2533]">OTP Verification</h1>
      <p className="mt-1.5 text-center text-[12.5px] text-[var(--muted-foreground)]">Enter the 6-digit code sent to</p>

      <div className="mx-auto mt-4 flex items-center gap-2.5 rounded-2xl border border-[var(--border)] bg-white px-5 py-3 shadow-[0_2px_10px_rgba(30,25,70,0.04)]">
        <Icon name="phone" size={18} className="text-[var(--primary)]" />
        <span className="text-[13px] font-semibold text-[#1f2533]">+971 50 123 4567</span>
      </div>

      <div className="mt-7 flex justify-center gap-2">
        {digits.map((d, i) => (
          <div
            key={i}
            className={`flex h-12 w-11 items-center justify-center rounded-2xl border text-[20px] font-bold transition-all ${
              i === activeIndex
                ? "border-[var(--primary)] bg-white ring-4 ring-[var(--primary-soft)]"
                : d
                ? "border-[var(--primary)]/30 bg-white"
                : "border-[var(--border)] bg-white"
            }`}
          >
            {d || <span className="text-[#c9c7db]">-</span>}
          </div>
        ))}
      </div>

      <div className="mt-5 flex items-center justify-center gap-1.5 text-[13px] text-[var(--muted-foreground)]">
        <Icon name="clock" size={16} />
        Resend code in 00:45
      </div>

      <div className="-mx-6 mt-2 flex flex-1 items-center justify-center overflow-hidden">
        <Illustration src={art.otpEnvelope} alt="Verification envelope" className="max-h-[210px]" fade={8} />
      </div>

      <div className="mb-4 grid grid-cols-3 gap-2">
        {["1", "2", "3", "4", "5", "6", "7", "8", "9", "", "0", "⌫"].map((k, i) => (
          <button
            key={i}
            onClick={() => (k === "⌫" ? del() : k ? press(k) : null)}
            disabled={!k}
            className={`h-12 rounded-2xl text-[16px] font-semibold ${k ? "bg-white text-[var(--foreground)] shadow-[0_1px_4px_rgba(30,25,70,0.07)] active:bg-[var(--muted)]" : "opacity-0"}`}
          >
            {k}
          </button>
        ))}
      </div>

      <PrimaryButton onClick={() => nav.navigate("verifyBusiness")}>Verify OTP</PrimaryButton>
    </div>
  );
}
