import { AppHeader, Badge, BottomNav, Icon } from "../components/ui";
import PrimaryButton from "../components/PrimaryButton";
import { art, photos } from "../assets";
import { useNav } from "../nav";

const stats = [
  {
    icon: "clipboard",
    value: "3",
    label: "Orders",
  },
  {
    icon: "pin",
    value: "2",
    label: "Locations",
  },
  {
    icon: "box",
    value: "46 m³",
    label: "Delivered",
  },
];

const locations = [
  {
    name: "Main Villa Entrance",
    area: "Palm Jumeirah, Frond F",
  },
  {
    name: "Service Gate",
    area: "Palm Jumeirah, Frond F",
  },
];

const recentOrders = [
  {
    id: "AF-2048",
    loc: "Main Villa Entrance",
    spec: "28 m³ · PUMP · 30 MPa",
    status: "onway" as const,
    label: "On the way",
  },
  {
    id: "AF-1987",
    loc: "Service Gate",
    spec: "18 m³ · PUMP · 30 MPa",
    status: "completed" as const,
    label: "Completed",
  },
];

export default function ProjectDetails() {
  const nav = useNav();

  return (
    <div
      className="relative flex flex-1 flex-col"
      style={{
        background: "var(--background)",
      }}
    >
      {/* =========================================================
          HEADER
      ========================================================= */}
      <AppHeader back />

      {/* =========================================================
          SCROLLABLE CONTENT
      ========================================================= */}
      <div
        className="
          flex-1
          overflow-y-auto
          px-5
          pb-40
        "
      >
        {/* PAGE TITLE */}
        <h1
          className="
            mt-2
            text-[22px]
            font-bold
            tracking-[-0.02em]
            text-[#14204a]
          "
        >
          Project Details
        </h1>

        {/* =======================================================
            PROJECT HERO IMAGE
        ======================================================= */}
        <div className="mt-3 overflow-hidden rounded-[20px]">
          <img
            src={art.villaHero}
            alt="Palm Jumeirah Villa"
            className="
              block
              h-[150px]
              w-full
              object-cover
            "
          />
        </div>

        {/* =======================================================
            PROJECT NAME + STATUS
        ======================================================= */}
        <div className="mt-3 flex items-center justify-between px-1">
          <div className="min-w-0">
            <div
              className="
                truncate
                text-[20px]
                font-bold
                tracking-[-0.02em]
                text-[#14204a]
              "
            >
              Palm Jumeirah Villa
            </div>

            <div
              className="
                mt-0.5
                text-[12px]
                text-[var(--muted-foreground)]
              "
            >
              PRJ-0318
            </div>
          </div>

          <Badge variant="active">
            Active
          </Badge>
        </div>

        {/* =======================================================
            STATS
        ======================================================= */}
        <div
          className="
            mt-4
            flex
            overflow-hidden
            rounded-[18px]
            border
            border-[var(--border)]
            bg-white
          "
        >
          {stats.map((stat, index) => (
            <div
              key={stat.label}
              className={`
                flex
                min-w-0
                flex-1
                items-center
                justify-center
                gap-2
                px-2
                py-3
                ${
                  index !== stats.length - 1
                    ? "border-r border-[var(--border)]"
                    : ""
                }
              `}
            >
              {/* ICON */}
              <div
                className="
                  flex
                  h-9
                  w-9
                  shrink-0
                  items-center
                  justify-center
                  rounded-full
                  bg-[var(--muted)]
                  text-[var(--primary)]
                "
              >
                <Icon
                  name={stat.icon}
                  size={18}
                />
              </div>

              {/* VALUE + LABEL */}
              <div className="min-w-0">
                <div
                  className="
                    whitespace-nowrap
                    text-[17px]
                    font-bold
                    leading-none
                    text-[#14204a]
                  "
                >
                  {stat.value}
                </div>

                <div
                  className="
                    mt-1
                    whitespace-nowrap
                    text-[10.5px]
                    leading-none
                    text-[var(--muted-foreground)]
                  "
                >
                  {stat.label}
                </div>
              </div>
            </div>
          ))}
        </div>

        {/* =======================================================
            PROJECT MAP
        ======================================================= */}
        <div
          className="
            relative
            mt-4
            h-[154px]
            overflow-hidden
            rounded-[18px]
          "
        >
          <img
            src={art.villaRouteMap}
            alt="Project delivery locations map"
            className="
              block
              h-full
              w-full
              object-cover
            "
          />
        </div>

        {/* =======================================================
            PROJECT LOCATIONS
        ======================================================= */}
        <h2
          className="
            mt-4
            px-1
            text-[15px]
            font-bold
            text-[#14204a]
          "
        >
          Project Locations
        </h2>

        <div
          className="
            mt-2
            overflow-hidden
            rounded-[18px]
            border
            border-[var(--border)]
            bg-white
          "
        >
          {locations.map((location, index) => (
            <button
              key={location.name}
              type="button"
              className={`
                flex
                w-full
                items-center
                gap-3
                px-3
                py-3
                text-left
                ${
                  index !== locations.length - 1
                    ? "border-b border-[var(--border)]"
                    : ""
                }
              `}
            >
              {/* PIN */}
              <div
                className="
                  flex
                  h-9
                  w-9
                  shrink-0
                  items-center
                  justify-center
                  rounded-full
                  bg-[var(--muted)]
                  text-[var(--primary)]
                "
              >
                <Icon
                  name="pin"
                  size={17}
                />
              </div>

              {/* LOCATION */}
              <div className="min-w-0 flex-1">
                <div
                  className="
                    truncate
                    text-[13.5px]
                    font-semibold
                    text-[#14204a]
                  "
                >
                  {location.name}
                </div>

                <div
                  className="
                    mt-0.5
                    truncate
                    text-[11.5px]
                    text-[var(--muted-foreground)]
                  "
                >
                  {location.area}
                </div>
              </div>

              {/* ARROW */}
              <div
                className="
                  flex
                  h-8
                  w-8
                  shrink-0
                  items-center
                  justify-center
                  rounded-lg
                  border
                  border-[var(--border)]
                "
              >
                <Icon
                  name="chevronRight"
                  size={16}
                  className="text-[#8f8ca8]"
                />
              </div>
            </button>
          ))}
        </div>

        {/* =======================================================
            RECENT ORDERS
        ======================================================= */}
        <h2
          className="
            mt-4
            px-1
            text-[15px]
            font-bold
            text-[#14204a]
          "
        >
          Recent Orders
        </h2>

        <div
          className="
            mt-2
            overflow-hidden
            rounded-[18px]
            border
            border-[var(--border)]
            bg-white
          "
        >
          {recentOrders.map((order, index) => (
            <button
              key={order.id}
              type="button"
              className={`
                flex
                w-full
                items-center
                gap-3
                px-3
                py-2.5
                text-left
                ${
                  index !== recentOrders.length - 1
                    ? "border-b border-[var(--border)]"
                    : ""
                }
              `}
            >
              {/* ORDER IMAGE */}
              <img
                src={photos.marinaTower}
                alt=""
                className="
                  h-11
                  w-11
                  shrink-0
                  rounded-lg
                  object-cover
                "
              />

              {/* ORDER DETAILS */}
              <div className="min-w-0 flex-1">
                <div
                  className="
                    text-[13px]
                    font-semibold
                    text-[#14204a]
                  "
                >
                  Order {order.id}
                </div>

                <div
                  className="
                    mt-0.5
                    truncate
                    text-[11px]
                    text-[var(--muted-foreground)]
                  "
                >
                  {order.loc}
                </div>

                <div
                  className="
                    mt-0.5
                    truncate
                    text-[10.5px]
                    text-[var(--muted-foreground)]
                  "
                >
                  {order.spec}
                </div>
              </div>

              {/* STATUS */}
              <div className="flex shrink-0 items-center gap-1">
                <Badge variant={order.status}>
                  {order.label}
                </Badge>

                <Icon
                  name="chevronRight"
                  size={17}
                  className="text-[#8f8ca8]"
                />
              </div>
            </button>
          ))}
        </div>

        {/* Extra space so content doesn't hide behind buttons */}
        <div className="h-3" />
      </div>

      {/* =========================================================
          FIXED ACTION BUTTONS
      ========================================================= */}
      <div
        className="
          absolute
          bottom-0
          left-0
          right-0
          z-20
          space-y-2
          border-t
          border-[var(--border)]
          bg-[var(--background)]/95
          px-5
          pb-5
          pt-3
          backdrop-blur-md
        "
      >
        <PrimaryButton
          arrow
          icon={<Icon name="box" size={18} />}
          onClick={() => nav.navigate("mixCode")}
        >
          Create Order for This Project
        </PrimaryButton>

        <PrimaryButton
          variant="outline"
          icon={<Icon name="pin" size={18} />}
          onClick={() => nav.navigate("addLocation")}
        >
          Add Project Location
        </PrimaryButton>
      </div>
    </div>
  );
}