import type { ReactNode } from "react";

function StatusBar() {
  return (
    <div className="flex shrink-0 items-center justify-between px-6 pb-1 pt-3 text-[#16151f]">
      <span className="text-[15px] font-semibold tracking-tight">9:41</span>
      <div className="flex items-center gap-1.5">
        <svg width="17" height="11" viewBox="0 0 18 12" fill="currentColor">
          <rect x="0" y="8" width="3" height="4" rx="1" />
          <rect x="5" y="5" width="3" height="7" rx="1" />
          <rect x="10" y="2.5" width="3" height="9.5" rx="1" />
          <rect x="15" y="0" width="3" height="12" rx="1" />
        </svg>
        <svg width="16" height="11" viewBox="0 0 17 12" fill="currentColor">
          <path d="M8.5 2.4c2.5 0 4.8 1 6.5 2.6l1.4-1.5A11 11 0 0 0 8.5.3 11 11 0 0 0 .6 3.5L2 5A9 9 0 0 1 8.5 2.4Zm0 3.7c1.5 0 2.9.6 3.9 1.6l1.4-1.5a8 8 0 0 0-10.6 0l1.4 1.5a5.5 5.5 0 0 1 3.9-1.6Zm0 3.6 2.3 2.3-2.3-.1-2.3.1 2.3-2.3Z" />
        </svg>
        <svg width="25" height="12" viewBox="0 0 26 13" fill="none">
          <rect x="0.5" y="0.5" width="21" height="12" rx="3.5" stroke="currentColor" opacity="0.4" />
          <rect x="2" y="2" width="18" height="9" rx="2" fill="currentColor" />
          <rect x="23" y="4" width="2" height="5" rx="1" fill="currentColor" opacity="0.4" />
        </svg>
      </div>
    </div>
  );
}

export default function PhoneFrame({ children }: { children: ReactNode }) {
  return (
    <div
      className="relative flex flex-col overflow-hidden bg-[var(--background)]"
      style={{ width: "100%", minHeight: "100dvh" }}
    >
      <StatusBar />
      <div className="flex min-h-0 flex-1 flex-col">{children}</div>
      <div className="flex h-5 shrink-0 items-center justify-center pb-1">
        <div className="h-1 w-32 rounded-full bg-[#16151f] opacity-20" />
      </div>
    </div>
  );
}
