import { useMemo, useState } from "react";
import { AppHeader, BottomNav, Icon } from "../components/ui";
import { art } from "../assets";
import { useNav } from "../nav";

type OrderFilter =
  | "All"
  | "Active"
  | "Confirmation needed"
  | "Completed";

type Order = {
  id: string;
  project: string;
  date: string;
  quantity: string;
  status: "Scheduled" | "On the way" | "Confirmation needed" | "Completed";
  statusType: "active" | "warning" | "completed";
  image: string;
};

const ORDERS: Order[] = [
  {
    id: "AF-2052",
    project: "Marina Tower",
    date: "May 16, 2025",
    quantity: "42 m³",
    status: "Scheduled",
    statusType: "active",
    image: art.heroTruck,
  },
  {
    id: "AF-2048",
    project: "Palm Jumeirah Villa",
    date: "May 15, 2025",
    quantity: "28 m³",
    status: "On the way",
    statusType: "active",
    image: art.heroTruck,
  },
  {
    id: "AF-2043",
    project: "Creek Residence",
    date: "May 14, 2025",
    quantity: "120 m³",
    status: "Confirmation needed",
    statusType: "warning",
    image: art.heroTruck,
  },
  {
    id: "AF-2031",
    project: "JVC Townhouse",
    date: "May 12, 2025",
    quantity: "18 m³",
    status: "Completed",
    statusType: "completed",
    image: art.heroTruck,
  },
];

const FILTERS: OrderFilter[] = [
  "All",
  "Active",
  "Confirmation needed",
  "Completed",
];

export default function Orders() {
  const nav = useNav();

  const [filter, setFilter] = useState<OrderFilter>("All");
  const [search, setSearch] = useState("");

  const filteredOrders = useMemo(() => {
    const query = search.trim().toLowerCase();

    return ORDERS.filter((order) => {
      // Filter
      let matchesFilter = true;

      if (filter === "Active") {
        matchesFilter =
          order.status === "Scheduled" ||
          order.status === "On the way";
      }

      if (filter === "Confirmation needed") {
        matchesFilter = order.status === "Confirmation needed";
      }

      if (filter === "Completed") {
        matchesFilter = order.status === "Completed";
      }

      if (!matchesFilter) return false;

      // Search
      if (!query) return true;

      return (
        order.id.toLowerCase().includes(query) ||
        order.project.toLowerCase().includes(query)
      );
    });
  }, [filter, search]);

  const getStatusClasses = (order: Order) => {
    if (order.statusType === "warning") {
      return {
        container: "bg-[#fff4e8]",
        text: "text-[#d97706]",
      };
    }

    if (order.statusType === "completed") {
      return {
        container: "bg-[#e8f8f2]",
        text: "text-[#16805a]",
      };
    }

    return {
      container: "bg-[#efedff]",
      text: "text-[var(--primary)]",
    };
  };

  const getStatusIcon = (order: Order) => {
    if (order.status === "Scheduled") {
      return "calendar";
    }

    if (order.status === "On the way") {
      return "truck";
    }

    if (order.status === "Confirmation needed") {
      return "clock";
    }

    return "check";
  };

  return (
    <div className="flex flex-1 flex-col overflow-hidden bg-[#f8f8fc]">
      {/* =========================================================
          HEADER
      ========================================================= */}
      <AppHeader />

      {/* =========================================================
          SCROLLABLE CONTENT
      ========================================================= */}
      <div className="min-h-0 flex-1 overflow-y-auto px-5 pb-32">

        {/* =======================================================
            TITLE
        ======================================================= */}
        <h1 className="mt-1 text-[25px] font-bold tracking-[-0.025em] text-[#172044]">
          My Orders
        </h1>

        {/* =======================================================
            SEARCH
        ======================================================= */}
        <div className="mt-4 flex h-[54px] items-center rounded-[18px] border border-[#e2e2ee] bg-white px-4">
          <Icon
            name="search"
            size={24}
            strokeWidth={1.8}
            className="shrink-0 text-[#697092]"
          />

          <input
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            type="text"
            placeholder="Search order or project"
            className="ml-3 min-w-0 flex-1 bg-transparent text-[14px] text-[#1f2533] outline-none placeholder:text-[#8d93b0]"
          />
        </div>

        {/* =======================================================
            FILTERS
        ======================================================= */}
        <div className="mt-4 flex gap-2 overflow-x-auto pb-1 scrollbar-none">
          {FILTERS.map((item) => {
            const active = filter === item;

            return (
              <button
                key={item}
                type="button"
                onClick={() => setFilter(item)}
                className={[
                  "h-[40px] shrink-0 rounded-[12px] px-4 text-[13px] font-medium transition-all",
                  active
                    ? "bg-[var(--primary)] text-white shadow-[0_4px_10px_rgba(81,73,237,0.18)]"
                    : "border border-[#e1e2ee] bg-white text-[#697092]",
                ].join(" ")}
              >
                {item}
              </button>
            );
          })}
        </div>

        {/* =======================================================
            ORDERS
        ======================================================= */}
        <div className="mt-4 space-y-3">

          {filteredOrders.map((order) => {
            const status = getStatusClasses(order);

            return (
              <button
                key={order.id}
                type="button"
                onClick={() => {
                  // Keep this navigation safe for now.
                  // Change to your order-details route when available.
                }}
                className="block w-full rounded-[20px] border border-[#e5e5ee] bg-white p-3 text-left shadow-[0_2px_8px_rgba(30,25,70,0.035)]"
              >
                <div className="flex items-center gap-3">

                  {/* =================================================
                      PROJECT IMAGE
                  ================================================= */}
                  <div className="h-[94px] w-[94px] shrink-0 overflow-hidden rounded-[11px] bg-[#eef1fb]">
                    <img
                      src={order.image}
                      alt={order.project}
                      className="h-full w-full object-cover"
                    />
                  </div>

                  {/* =================================================
                      ORDER INFORMATION
                  ================================================= */}
                  <div className="min-w-0 flex-1">

                    {/* Order ID + Arrow */}
                    <div className="flex items-center justify-between gap-2">
                      <span className="text-[17px] font-bold tracking-[-0.02em] text-[#172044]">
                        {order.id}
                      </span>

                      <Icon
                        name="chevronRight"
                        size={20}
                        strokeWidth={1.8}
                        className="shrink-0 text-[#172044]"
                      />
                    </div>

                    {/* Project */}
                    <div className="mt-1.5 truncate text-[14px] font-medium text-[#202744]">
                      {order.project}
                    </div>

                    {/* Bottom information */}
                    <div className="mt-2 flex items-end justify-between gap-2">

                      {/* Date */}
                      <span className="text-[12px] text-[#8187a4]">
                        {order.date}
                      </span>

                      {/* Quantity + Status */}
                      <div className="flex min-w-0 flex-col items-end gap-1">
                        <span className="whitespace-nowrap text-[16px] font-bold text-[#172044]">
                          {order.quantity}
                        </span>

                        <span
                          className={`flex h-[30px] max-w-[170px] items-center gap-1.5 rounded-full px-3 text-[11px] font-medium ${status.container} ${status.text}`}
                        >
                          <Icon
                            name={getStatusIcon(order)}
                            size={14}
                            strokeWidth={1.8}
                          />

                          <span className="truncate">
                            {order.status}
                          </span>
                        </span>
                      </div>

                    </div>
                  </div>
                </div>
              </button>
            );
          })}

          {/* Empty state */}
          {filteredOrders.length === 0 && (
            <div className="rounded-[20px] border border-[#e5e5ee] bg-white px-5 py-12 text-center">
              <div className="mx-auto flex h-12 w-12 items-center justify-center rounded-full bg-[var(--primary-soft)]">
                <Icon
                  name="search"
                  size={22}
                  className="text-[var(--primary)]"
                />
              </div>

              <div className="mt-3 text-[15px] font-semibold text-[#1f2533]">
                No orders found
              </div>

              <div className="mt-1 text-[12px] text-[#8187a4]">
                Try another order number or project name.
              </div>
            </div>
          )}
        </div>

        {/* =======================================================
            CREATE NEW ORDER
        ======================================================= */}
        <button
          type="button"
          onClick={() => nav.navigate("createProject")}
          className="mt-4 flex h-[58px] w-full items-center justify-center gap-3 rounded-[18px] bg-[var(--primary)] text-white shadow-[0_6px_16px_rgba(81,73,237,0.22)]"
        >
          <span className="flex h-8 w-8 items-center justify-center rounded-full border-2 border-white">
            <Icon
              name="plus"
              size={19}
              strokeWidth={2}
              className="text-white"
            />
          </span>

          <span className="text-[15px] font-semibold">
            Create New Order
          </span>
        </button>

      </div>

      {/* =========================================================
          BOTTOM NAV
      ========================================================= */}
      <BottomNav active="Orders" />
    </div>
  );
}