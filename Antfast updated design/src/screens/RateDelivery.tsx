import { useState } from "react";
import AntfastLogo from "../components/AntfastLogo";
import PrimaryButton from "../components/PrimaryButton";
import { Icon } from "../components/ui";
import { art } from "../assets";
import { useNav } from "../nav";

const Star = ({ filled }: { filled: boolean }) => (
  <svg viewBox="0 0 24 24" width="28" height="28" fill={filled ? "var(--primary)" : "#e2e0ef"}>
    <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z" />
  </svg>
);

const SmallStar = ({ filled }: { filled: boolean }) => (
  <svg viewBox="0 0 24 24" width="18" height="18" fill={filled ? "var(--primary)" : "#e2e0ef"}>
    <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z" />
  </svg>
);

const LABELS = ["Poor", "Fair", "Good", "Great", "Excellent"];

const CATEGORIES = [
  { icon: "clock", label: "On-time Delivery" },
  { icon: "shield", label: "Concrete Quality" },
  { icon: "user", label: "Driver Service" },
  { icon: "truck", label: "Pump Service" },
  { icon: "phone", label: "ANTFAST Support" },
];

export default function RateDelivery() {
  const nav = useNav();
  const [overall, setOverall] = useState(5);
  const [cats, setCats] = useState<Record<string, number>>(
    Object.fromEntries(CATEGORIES.map((c) => [c.label, 5]))
  );
  const [comment, setComment] = useState("");

  return (
    <div className="flex flex-1 flex-col">
      {/* Header */}
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

      <div className="flex-1 overflow-y-auto pb-8 px-5">
        <h1 className="mt-2 text-[24px] font-bold tracking-[-0.01em] text-[#1f2533]">Rate Your Delivery</h1>

        {/* Pill badge */}
        <div className="mt-2 inline-flex items-center gap-1.5 rounded-full border border-[var(--border)] bg-white px-3 py-1">
          <span className="text-[12px] font-semibold text-[var(--muted-foreground)]">AF-2057 · Palm Jumeirah Villa</span>
        </div>

        {/* Hero image */}
        <div className="mt-3 overflow-hidden rounded-2xl shadow-[0_4px_16px_rgba(30,25,70,0.08)]">
          <img src={art.villaPumpHero} alt="Villa with pump truck" className="block w-full object-cover"
            style={{ height: 160, objectPosition: "center 30%" }} />
        </div>

        {/* Overall rating */}
        <div className="mt-4 overflow-hidden rounded-2xl border border-[var(--border)] bg-white px-4 py-5 shadow-[0_2px_8px_rgba(30,25,70,0.04)]">
          <div className="text-center text-[13px] font-semibold text-[#1f2533]">Overall Experience</div>
          <div className="mt-3 flex items-center justify-center gap-1">
            {[1, 2, 3, 4, 5].map((n) => (
              <button key={n} type="button" onClick={() => setOverall(n)}>
                <Star filled={n <= overall} />
              </button>
            ))}
          </div>
          <div className="mt-1.5 text-center text-[13px] font-semibold text-[var(--primary)]">
            {LABELS[overall - 1]}
          </div>
        </div>

        {/* Category ratings */}
        <div className="mt-3 overflow-hidden rounded-2xl border border-[var(--border)] bg-white shadow-[0_2px_8px_rgba(30,25,70,0.04)]">
          {CATEGORIES.map((c, i) => (
            <div key={c.label} className={`flex items-center gap-3 px-4 py-3.5 ${i < CATEGORIES.length - 1 ? "border-b border-[var(--border)]" : ""}`}>
              <div className="flex h-8 w-8 shrink-0 items-center justify-center rounded-xl bg-[var(--muted)]">
                <Icon name={c.icon} size={16} className="text-[var(--primary)]" />
              </div>
              <span className="flex-1 text-[13px] font-medium text-[#1f2533]">{c.label}</span>
              <div className="flex items-center gap-0.5">
                {[1, 2, 3, 4, 5].map((n) => (
                  <button key={n} type="button" onClick={() => setCats((p) => ({ ...p, [c.label]: n }))}>
                    <SmallStar filled={n <= cats[c.label]} />
                  </button>
                ))}
              </div>
              <Icon name="chevronRight" size={14} className="text-[var(--muted-foreground)]" />
            </div>
          ))}
        </div>

        {/* Comment */}
        <div className="mt-3 overflow-hidden rounded-2xl border border-[var(--border)] bg-white shadow-[0_1px_4px_rgba(30,25,70,0.04)]">
          <div className="border-b border-[var(--border)] px-4 py-2.5">
            <span className="text-[12px] font-semibold text-[var(--muted-foreground)]">Tell us more <span className="font-normal">(optional)</span></span>
          </div>
          <textarea
            value={comment}
            onChange={(e) => setComment(e.target.value)}
            placeholder="Share any details or suggestions..."
            rows={3}
            className="w-full resize-none bg-transparent px-4 py-3 text-[13px] text-[#1f2533] placeholder:text-[#a3a1b8] outline-none"
          />
        </div>

        {/* Add photos row */}
        <button type="button"
          className="mt-2 flex w-full items-center justify-between rounded-xl border border-[var(--border)] bg-white px-4 py-3">
          <div className="flex items-center gap-2.5">
            <Icon name="plus" size={16} className="text-[var(--primary)]" />
            <span className="text-[13px] font-medium text-[#1f2533]">Add photos or documents</span>
          </div>
          <Icon name="chevronRight" size={15} className="text-[var(--muted-foreground)]" />
        </button>

        {/* Privacy note */}
        <div className="mt-2 flex items-center gap-1.5 px-1">
          <Icon name="lock" size={12} className="shrink-0 text-[var(--muted-foreground)]" />
          <span className="text-[11px] text-[var(--muted-foreground)]">Your feedback is linked to this delivery for service improvement.</span>
        </div>

        <div className="mt-5 space-y-3">
          <PrimaryButton onClick={() => nav.jump("home")}>
            Submit Rating
          </PrimaryButton>
          <button type="button" onClick={nav.back}
            className="w-full rounded-2xl border border-[var(--border)] py-3.5 text-center text-[14px] font-semibold text-[var(--muted-foreground)]">
            Not now
          </button>
        </div>
      </div>
    </div>
  );
}
