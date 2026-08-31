import { AppHeader, Badge, BottomNav, Icon } from "../components/ui";
import PrimaryButton from "../components/PrimaryButton";
import { art, photos } from "../assets";
import { useNav } from "../nav";

const recent = [
  {
    name: "Marina Tower",
    id: "AF-2052",
    img: photos.marinaTower,
    status: "scheduled" as const,
    label: "Scheduled",
  },
  {
    name: "Palm Jumeirah Villa",
    id: "AF-2048",
    img: photos.villa,
    status: "onway" as const,
    label: "On the way",
  },
  {
    name: "Creek Residence",
    id: "AF-2043",
    img: photos.creekResidence,
    status: "confirm" as const,
    label: "Confirmation needed",
  },
];

function StatCard({
  icon,
  label,
  value,
  onClick,
}: {
  icon: string;
  label: string;
  value: string;
  onClick?: () => void;
}) {
  return (
    <button
      type="button"
      onClick={onClick}
      className="
        flex
        min-w-0
        flex-1
        items-center
        gap-3
        rounded-2xl
        border
        border-[var(--border)]
        bg-white
        px-4
        py-4
        text-left
        shadow-[0_2px_12px_rgba(30,25,70,0.03)]
      "
    >
      <div
        className="
          flex
          h-11
          w-11
          shrink-0
          items-center
          justify-center
          rounded-full
          bg-[var(--primary-soft)]
          text-[var(--primary)]
        "
      >
        <Icon name={icon} size={21} />
      </div>

      <div className="min-w-0 flex-1">
        <div className="text-[12px] leading-5 text-[var(--muted-foreground)]">
          {label}
        </div>

        <div className="mt-0.5 text-[25px] font-bold leading-none text-[#151d40]">
          {value}
        </div>
      </div>

      <Icon
        name="chevronRight"
        size={19}
        className="shrink-0 text-[#aaa9c4]"
      />
    </button>
  );
}

export default function Home() {
  const nav = useNav();
  const approved = nav.params.approved !== false;

  return (
    <div className="flex flex-1 flex-col bg-[var(--background)]">
      <AppHeader />

      <div className="flex-1 overflow-y-auto px-5 pb-28">

        {/* APPROVAL STATUS */}
        <div className="flex justify-center">
          {approved ? (
            <Badge variant="active">Approved</Badge>
          ) : (
            <span
              className="
                inline-flex
                items-center
                gap-1.5
                rounded-full
                bg-[var(--muted)]
                px-3
                py-1
                text-[12px]
                font-semibold
                text-[var(--muted-foreground)]
              "
            >
              <Icon name="clock" size={13} />
              Under Review
            </span>
          )}
        </div>

        {/* GREETING */}
        <h1
          className="
            mt-4
            text-[24px]
            font-bold
            leading-[1.1]
            tracking-[-0.025em]
            text-[#151d40]
          "
        >
          Good afternoon, Rashed
        </h1>

        {!approved && (
          <p className="mt-2 text-[12px] leading-5 text-[var(--muted-foreground)]">
            Business verification in review · Payments activate after approval
          </p>
        )}

        {/* STATS */}
        <div className="mt-5 flex gap-3">
          <StatCard
            icon="building"
            label="Projects"
            value={approved ? "5" : "0"}
            onClick={() => nav.navigate("projects")}
          />

          <StatCard
            icon="clipboard"
            label="Active Orders"
            value={approved ? "3" : "0"}
            onClick={() => nav.navigate("orders")}
          />
        </div>

        {/* =========================================================
            HERO
            Full artwork background — NO separate image section
           ========================================================= */}
        <div
          className="
            relative
            mt-5
            h-[330px]
            overflow-hidden
            rounded-[28px]
            border
            border-[var(--border)]
            bg-[#eef1f9]
            shadow-[0_3px_14px_rgba(30,25,70,0.045)]
          "
        >
          {/* FULL HERO ARTWORK */}
          <img
            src={art.homeHero}
            alt="ANTFAST mixer truck at a batching plant"
            className="
              absolute
              inset-0
              h-full
              w-full
            "
            style={{
              objectFit: "cover",
              objectPosition: "center center",
            }}
          />

          {/* SUBTLE LIGHT OVERLAY
              Keeps text readable without hiding artwork */}
          <div
            className="
              pointer-events-none
              absolute
              inset-0
              bg-gradient-to-b
              from-white/35
              via-transparent
              to-transparent
            "
          />

          {/* HERO HEADING */}
          <div
            className="
              absolute
              left-5
              top-5
              z-10
            "
          >
            <h2
              className="
                text-[22px]
                font-bold
                leading-[1.08]
                tracking-[-0.03em]
                text-[#111a3b]
              "
            >
              Ready for
              <br />
              your next pour?
            </h2>
          </div>

          {/* CTA */}
          <div
            className="
              absolute
              bottom-4
              left-4
              right-4
              z-20
            "
          >
            <PrimaryButton
              arrow
              onClick={() => nav.navigate("createProject")}
            >
              Create New Project
            </PrimaryButton>
          </div>
        </div>

        {/* RECENT ORDERS */}
        <h3
          className="
            mt-6
            text-[18px]
            font-bold
            leading-tight
            tracking-[-0.02em]
            text-[#151d40]
          "
        >
          Recent Orders
        </h3>

        {approved ? (
          <div className="mt-3 overflow-hidden rounded-2xl border border-[var(--border)] bg-white">
            {recent.map((r, index) => (
              <button
                key={r.id}
                type="button"
                onClick={() => nav.navigate("projectDetails")}
                className={`
                  flex
                  w-full
                  items-center
                  gap-3
                  px-3
                  py-3
                  text-left
                  ${
                    index !== recent.length - 1
                      ? "border-b border-[var(--border)]"
                      : ""
                  }
                `}
              >
                {/* ORDER IMAGE */}
                <img
                  src={r.img}
                  alt={r.name}
                  className="
                    h-12
                    w-12
                    shrink-0
                    rounded-xl
                    object-cover
                  "
                />

                {/* ORDER DETAILS */}
                <div className="min-w-0 flex-1">
                  <div
                    className="
                      truncate
                      text-[13px]
                      font-semibold
                      text-[#17203f]
                    "
                  >
                    {r.name}
                  </div>

                  <div
                    className="
                      mt-0.5
                      text-[12px]
                      text-[var(--muted-foreground)]
                    "
                  >
                    Order {r.id}
                  </div>
                </div>

                {/* STATUS */}
                <div className="shrink-0">
                  <Badge variant={r.status}>{r.label}</Badge>
                </div>

                {/* ARROW */}
                <Icon
                  name="chevronRight"
                  size={18}
                  className="shrink-0 text-[#aaa9c4]"
                />
              </button>
            ))}
          </div>
        ) : (
          <div
            className="
              mt-3
              flex
              flex-col
              items-center
              rounded-2xl
              border
              border-dashed
              border-[var(--border)]
              bg-white
              py-8
            "
          >
            <div
              className="
                flex
                h-12
                w-12
                items-center
                justify-center
                rounded-full
                bg-[var(--primary-soft)]
                text-[var(--primary)]
              "
            >
              <Icon name="clipboard" size={22} />
            </div>

            <div className="mt-3 text-[13px] font-semibold text-[#17203f]">
              No orders yet
            </div>

            <div className="mt-1 text-[12px] text-[var(--muted-foreground)]">
              Your first order will appear here
            </div>
          </div>
        )}
      </div>

      <BottomNav active="Home" />
    </div>
  );
}