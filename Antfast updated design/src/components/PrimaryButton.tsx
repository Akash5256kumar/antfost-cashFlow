import type { ReactNode } from "react";

interface PrimaryButtonProps {
  children: ReactNode;
  onClick?: () => void;
  arrow?: boolean;
  variant?: "solid" | "outline" | "ghost";
  icon?: ReactNode;
  disabled?: boolean;
}

/**
 * Reusable full-width CTA. Solid purple by default; outline and ghost
 * variants reuse the same footprint for secondary actions.
 */
export default function PrimaryButton({
  children,
  onClick,
  arrow = false,
  variant = "solid",
  icon,
  disabled = false,
}: PrimaryButtonProps) {
  const base =
    "group relative flex h-[58px] w-full items-center justify-center gap-2 rounded-[20px] text-[15.5px] font-semibold transition-all duration-200 active:scale-[0.985]";
  const styles =
    variant === "solid"
      ? "bg-[var(--primary)] text-white shadow-[0_14px_30px_-10px_rgba(91,75,224,0.6)] hover:bg-[var(--primary-hover)]"
      : variant === "outline"
        ? "border border-[var(--primary)]/40 bg-white text-[var(--primary)] hover:bg-[var(--primary-soft)]"
        : "bg-[var(--primary-soft)] text-[var(--primary)] hover:brightness-95";

  return (
    <button type="button" onClick={onClick} disabled={disabled} className={`${base} ${styles} ${disabled ? "opacity-40 cursor-not-allowed" : ""}`}>
      {icon}
      <span>{children}</span>
      {arrow && (
        <svg
          className="absolute right-6 transition-transform duration-200 group-hover:translate-x-0.5"
          width="20"
          height="20"
          viewBox="0 0 24 24"
          fill="none"
        >
          <path d="M9 6l6 6-6 6" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round" />
        </svg>
      )}
    </button>
  );
}
