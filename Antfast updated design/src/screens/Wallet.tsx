import { useState } from "react";
import { AppHeader, BottomNav, Icon } from "../components/ui";
import { art } from "../assets";

type FilterTab = "All" | "Top-ups" | "Payments" | "Refunds";

const TRANSACTIONS = [
  {
    id: 1,
    icon: "arrowRight",
    iconBg: "#eef2ff",
    title: "Wallet Top-up",
    date: "12 Aug 2026 · 09:14",
    status: "Completed",
    statusColor: "#16a34a",
    amount: "+AED 5,000",
    amountColor: "#16a34a",
    category: "Top-ups",
  },
  {
    id: 2,
    icon: "truck",
    iconBg: "var(--primary-soft)",
    title: "Order AF-2048",
    date: "08 Aug 2026 · 14:30",
    status: "Paid",
    statusColor: "#16a34a",
    amount: "-AED 21,400",
    amountColor: "#1f2533",
    category: "Payments",
  },
  {
    id: 3,
    icon: "refresh",
    iconBg: "#fef9ef",
    title: "Refund - AF-2031",
    date: "01 Aug 2026 · 10:02",
    status: "Refunded",
    statusColor: "#b45309",
    amount: "+AED 3,200",
    amountColor: "#16a34a",
    category: "Refunds",
  },
  {
    id: 4,
    icon: "truck",
    iconBg: "var(--primary-soft)",
    title: "Order AF-2039",
    date: "25 Jul 2026 · 08:45",
    status: "Paid",
    statusColor: "#16a34a",
    amount: "-AED 8,750",
    amountColor: "#1f2533",
    category: "Payments",
  },
  {
    id: 5,
    icon: "arrowRight",
    iconBg: "#eef2ff",
    title: "Wallet Top-up",
    date: "20 Jul 2026 · 16:20",
    status: "Completed",
    statusColor: "#16a34a",
    amount: "+AED 10,000",
    amountColor: "#16a34a",
    category: "Top-ups",
  },
];

export default function Wallet() {
  const [filter, setFilter] = useState<FilterTab>("All");

  const tabs: FilterTab[] = [
    "All",
    "Top-ups",
    "Payments",
    "Refunds",
  ];

  const filtered =
    filter === "All"
      ? TRANSACTIONS
      : TRANSACTIONS.filter((tx) => tx.category === filter);

  return (
    <div className="flex flex-1 flex-col bg-[var(--background)]">

      <AppHeader />

      <div className="flex-1 overflow-y-auto px-5 pb-28">

        {/* Wallet title */}
        <h1 className="mb-4 text-[24px] font-bold text-[#1f2533]">
          Wallet
        </h1>

        {/* Balance card */}
        <div className="relative w-full overflow-hidden rounded-[30px]">
          <img
            src={art.walletCard}
            alt="Wallet balance"
            className="block h-auto w-full"
          />
        </div>

        {/* Top Up / Withdraw */}
        <div className="mt-3 grid grid-cols-2 gap-3">

          <button
            type="button"
            className="flex items-center justify-center gap-2 rounded-2xl border border-[var(--border)] bg-white py-3.5 shadow-[0_2px_8px_rgba(30,25,70,0.04)]"
          >
            <span className="flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-[var(--primary-soft)]">
              <Icon
                name="plus"
                size={17}
                className="text-[var(--primary)]"
              />
            </span>

            <span className="text-[14px] font-semibold text-[#1f2533]">
              Top Up
            </span>
          </button>

          <button
            type="button"
            className="flex items-center justify-center gap-2 rounded-2xl border border-[var(--border)] bg-white py-3.5 shadow-[0_2px_8px_rgba(30,25,70,0.04)]"
          >
            <span className="flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-[#f2f1f9]">
              <Icon
                name="arrowRight"
                size={17}
                className="text-[#1f2533]"
              />
            </span>

            <span className="text-[14px] font-semibold text-[#1f2533]">
              Withdraw
            </span>
          </button>

        </div>

        {/* Payment info */}
        <div className="mt-3 flex items-center gap-3 rounded-2xl border border-[var(--border)] bg-white px-4 py-3.5 shadow-[0_2px_8px_rgba(30,25,70,0.04)]">

          <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-[var(--primary-soft)]">
            <Icon
              name="card"
              size={18}
              className="text-[var(--primary)]"
            />
          </div>

          <p className="min-w-0 text-[12px] leading-[1.35] text-[var(--muted-foreground)]">
            Wallet can be combined with Card or Bank
            <br />
            Transfer for partial payments.
          </p>

        </div>

        {/* Transactions */}
        <div className="mt-6">

          <h2 className="text-[20px] font-bold text-[#1f2533]">
            Transactions
          </h2>

          {/* Tabs */}
          <div className="mt-3 flex border-b border-[var(--border)]">

            {tabs.map((tab) => (
              <button
                key={tab}
                type="button"
                onClick={() => setFilter(tab)}
                className={
                  filter === tab
                    ? "relative flex-1 whitespace-nowrap px-1 pb-3 text-[13px] font-semibold text-[var(--primary)]"
                    : "relative flex-1 whitespace-nowrap px-1 pb-3 text-[13px] font-semibold text-[var(--muted-foreground)]"
                }
              >
                {tab}

                {filter === tab && (
                  <span className="absolute bottom-[-1px] left-1/2 h-[2px] w-14 -translate-x-1/2 rounded-full bg-[var(--primary)]" />
                )}
              </button>
            ))}

          </div>

          {/* Transaction list */}
          <div className="mt-3 space-y-2">

            {filtered.map((tx) => (
              <div
                key={tx.id}
                className="flex min-h-[100px] items-center gap-3 rounded-2xl bg-white px-4 py-4 shadow-[0_1px_5px_rgba(30,25,70,0.04)]"
              >

                {/* Transaction icon */}
                <div
                  className="flex h-11 w-11 shrink-0 items-center justify-center rounded-full"
                  style={{
                    backgroundColor: tx.iconBg,
                  }}
                >
                  <Icon
                    name={tx.icon}
                    size={19}
                    className="text-[var(--primary)]"
                  />
                </div>

                {/* Transaction details */}
                <div className="min-w-0 flex-1">

                  <div className="truncate text-[14px] font-semibold text-[#1f2533]">
                    {tx.title}
                  </div>

                  <div className="mt-1 flex flex-wrap items-center gap-x-1.5 gap-y-1">

                    <span className="whitespace-nowrap text-[11px] text-[var(--muted-foreground)]">
                      {tx.date}
                    </span>

                    <span
                      className="h-1.5 w-1.5 shrink-0 rounded-full"
                      style={{
                        backgroundColor: tx.statusColor,
                      }}
                    />

                    <span
                      className="text-[11px] font-medium"
                      style={{
                        color: tx.statusColor,
                      }}
                    >
                      {tx.status}
                    </span>

                  </div>

                </div>

                {/* Amount */}
                <div className="flex shrink-0 items-center gap-1.5">

                  <span
                    className="whitespace-nowrap text-[14px] font-bold"
                    style={{
                      color: tx.amountColor,
                    }}
                  >
                    {tx.amount}
                  </span>

                  <Icon
                    name="chevronRight"
                    size={16}
                    className="text-[var(--muted-foreground)]"
                  />

                </div>

              </div>
            ))}

          </div>

        </div>

      </div>

      <BottomNav active="Wallet" />

    </div>
  );
}