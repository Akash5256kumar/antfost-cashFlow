import AntfastLogo from "../components/AntfastLogo";
import PrimaryButton from "../components/PrimaryButton";
import { BottomNav, Icon, StepRail } from "../components/ui";
import { art } from "../assets";
import { useNav } from "../nav";
import { ORDER_STEPS } from "./MixCode";

const ACCESS_FLAGS = [
  { label: "Narrow Access", yes: true },
  { label: "Road Permit Required", yes: true },
  { label: "Boom Reach Restriction", yes: false },
  { label: "Night Delivery Access", yes: false },
];

const ATTACHMENTS = [
  {
    name: "Access photo",
    type: "image",
  },
  {
    name: "Road_Permit_AF-2048.pdf",
    type: "pdf",
    size: "1.2 MB",
  },
];

export default function ReviewOrder() {
  const nav = useNav();

  return (
    <div className="flex h-full min-h-0 flex-1 flex-col overflow-hidden bg-[#f8f8fc]">

      {/* HEADER */}
      <div className="shrink-0 px-5 pt-2">

        <div className="relative flex h-[46px] items-center justify-between">

          <button
            type="button"
            onClick={nav.back}
            className="flex h-10 w-10 items-center justify-center"
          >
            <Icon
              name="back"
              size={24}
              strokeWidth={2}
            />
          </button>

          <div className="absolute left-1/2 -translate-x-1/2">
            <AntfastLogo
              style={{
                width: 140,
                height: "auto",
              }}
            />
          </div>

          <button
            type="button"
            className="relative flex h-10 w-10 items-center justify-center"
          >
            <Icon
              name="bell"
              size={22}
            />

            <span className="absolute right-1.5 top-1.5 h-2 w-2 rounded-full bg-[var(--primary)]" />
          </button>

        </div>

        <h1 className="mt-1 text-[24px] font-bold leading-tight tracking-[-0.025em] text-[#151a38]">
          Review Order
        </h1>

        <div className="mt-3">
          <StepRail
            steps={ORDER_STEPS}
            current={6}
          />
        </div>

      </div>

      {/* SCROLL AREA */}
      <div className="min-h-0 flex-1 overflow-y-auto pb-[110px]">

        {/* HERO */}
        <div className="h-[165px] w-full overflow-hidden bg-[#f8f8fc]">

          <img
            src={art.heroTruck}
            alt="ANTFAST pump truck on site"
            className="block h-full w-full object-contain"
            style={{
              objectPosition: "center center",
            }}
          />

        </div>

        {/* CONTENT */}
        <div className="px-5 pb-[120px]">

          {/* MAIN CARD */}
          <div className="overflow-hidden rounded-[17px] border border-[#e3e5ee] bg-white">

            {/* PROJECT */}
            <div className="flex min-h-[72px] items-center gap-3 border-b border-[#e7e8ef] px-4">

              <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-[#f0efff] text-[var(--primary)]">
                <Icon
                  name="doc"
                  size={18}
                  strokeWidth={1.8}
                />
              </div>

              <div className="min-w-0 flex-1">

                <div className="text-[12.5px] font-bold text-[#172044]">
                  Project & Location
                </div>

                <div className="mt-1 text-[11px] font-medium leading-[1.3] text-[#7b8094]">
                  Palm Jumeirah Villa · Main Villa Entrance
                </div>

              </div>

              <button
                type="button"
                onClick={() => nav.navigate("createProject")}
                className="flex h-9 w-9 shrink-0 items-center justify-center text-[var(--primary)]"
              >
                <Icon
                  name="edit"
                  size={19}
                  strokeWidth={1.8}
                />
              </button>

            </div>

            {/* MIX */}
            <div className="flex min-h-[72px] items-center gap-3 border-b border-[#e7e8ef] px-4">

              <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-[#f0efff] text-[var(--primary)]">
                <Icon
                  name="doc"
                  size={18}
                  strokeWidth={1.8}
                />
              </div>

              <div className="min-w-0 flex-1">

                <div className="text-[12.5px] font-bold text-[#172044]">
                  Mix & Quantity
                </div>

                <div className="mt-1 text-[11px] font-medium text-[#7b8094]">
                  C30/37 · 120 m³
                </div>

              </div>

              <button
                type="button"
                onClick={() => nav.navigate("mixCode")}
                className="flex h-9 w-9 shrink-0 items-center justify-center text-[var(--primary)]"
              >
                <Icon
                  name="edit"
                  size={19}
                  strokeWidth={1.8}
                />
              </button>

            </div>

            {/* SCHEDULE */}
            <div className="flex min-h-[76px] items-center gap-3 border-b border-[#e7e8ef] px-4">

              <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-[#f0efff] text-[var(--primary)]">
                <Icon
                  name="calendar"
                  size={18}
                  strokeWidth={1.8}
                />
              </div>

              <div className="min-w-0 flex-1">

                <div className="text-[12.5px] font-bold text-[#172044]">
                  Schedule
                </div>

                <div className="mt-1 text-[11px] font-medium leading-[1.3] text-[#7b8094]">
                  Tue 12 Aug · Morning · 08:00 · requested interval 15 min
                </div>

              </div>

              <button
                type="button"
                onClick={() => nav.navigate("schedule")}
                className="flex h-9 w-9 shrink-0 items-center justify-center text-[var(--primary)]"
              >
                <Icon
                  name="edit"
                  size={19}
                  strokeWidth={1.8}
                />
              </button>

            </div>

            {/* SERVICES */}
            <div className="flex min-h-[72px] items-center gap-3 border-b border-[#e7e8ef] px-4">

              <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-[#f0efff] text-[var(--primary)]">
                <Icon
                  name="doc"
                  size={18}
                  strokeWidth={1.8}
                />
              </div>

              <div className="min-w-0 flex-1">

                <div className="text-[12.5px] font-bold text-[#172044]">
                  Services
                </div>

                <div className="mt-1 text-[11px] font-medium text-[#7b8094]">
                  Pump + Technician · 6 cube moulds
                </div>

              </div>

              <button
                type="button"
                onClick={() => nav.navigate("services")}
                className="flex h-9 w-9 shrink-0 items-center justify-center text-[var(--primary)]"
              >
                <Icon
                  name="edit"
                  size={19}
                  strokeWidth={1.8}
                />
              </button>

            </div>

            {/* SITE ACCESS */}
            <div className="px-4 pt-4 pb-3">

              <div className="flex items-start gap-3">

                <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-[#f0efff] text-[var(--primary)]">
                  <Icon
                    name="shield"
                    size={18}
                    strokeWidth={1.8}
                  />
                </div>

                <div className="min-w-0 flex-1">

                  <div className="flex items-center justify-between">

                    <div className="text-[12.5px] font-bold text-[#172044]">
                      Site Access
                    </div>

                    <button
                      type="button"
                      onClick={() => nav.navigate("siteAccess")}
                      className="flex h-8 w-8 items-center justify-center text-[var(--primary)]"
                    >
                      <Icon
                        name="edit"
                        size={19}
                        strokeWidth={1.8}
                      />
                    </button>

                  </div>

                  <div className="mt-1">

                    {ACCESS_FLAGS.map((flag, index) => (
                      <div
                        key={flag.label}
                        className={`flex min-h-[34px] items-center justify-between gap-3 ${
                          index !== ACCESS_FLAGS.length - 1
                            ? "border-b border-[#eeeeF3]"
                            : ""
                        }`}
                      >

                        <span className="text-[11px] font-medium text-[#252a42]">
                          {flag.label}
                        </span>

                        <span
                          className={`flex h-[27px] min-w-[69px] items-center justify-center rounded-[9px] text-[10.5px] font-bold ${
                            flag.yes
                              ? "bg-[var(--primary)] text-white"
                              : "bg-[#e9eaf1] text-[#252a42]"
                          }`}
                        >

                          {flag.yes && (
                            <Icon
                              name="check"
                              size={11}
                              strokeWidth={3}
                            />
                          )}

                          <span className={flag.yes ? "ml-1" : ""}>
                            {flag.yes ? "YES" : "NO"}
                          </span>

                        </span>

                      </div>
                    ))}

                  </div>

                </div>

              </div>

              {/* ATTACHMENTS */}
              <div className="mt-3 border-t border-[#e7e8ef] pt-3">

                <div className="ml-[52px]">

                  <div className="text-[12px] font-semibold text-[#252a42]">
                    Attachments ({ATTACHMENTS.length})
                  </div>

                  <div className="mt-2 space-y-2">

                    {/* Access photo */}
                    <div className="flex items-center gap-3">

                      <div className="h-[60px] w-[100px] shrink-0 overflow-hidden rounded-[7px] bg-[#b5b0a6]">

                        <div className="flex h-full w-full items-center justify-center bg-gradient-to-br from-[#bcb7ad] via-[#817a70] to-[#d7d2c9]">

                          <div className="h-full w-[30%] bg-[#625c55] opacity-55" />

                          <div className="mx-1 h-[85%] w-[32%] bg-[#c7c2b7] opacity-75" />

                          <div className="h-full w-[23%] bg-[#716b63] opacity-60" />

                        </div>

                      </div>

                      <span className="text-[11px] font-medium text-[#252a42]">
                        Access photo
                      </span>

                    </div>

                    {/* PDF */}
                    <div className="flex min-h-[57px] items-center gap-3 rounded-[8px] border border-[#e4e5ec] bg-white px-3">

                      <div className="flex h-[40px] w-[33px] shrink-0 items-center justify-center rounded-[4px] border border-[#ef8b82] bg-[#fff7f6]">

                        <span className="text-[8px] font-bold text-[#e65c50]">
                          PDF
                        </span>

                      </div>

                      <div className="min-w-0 flex-1">

                        <div className="truncate text-[11px] font-medium text-[#252a42]">
                          Road_Permit_AF-2048.pdf
                        </div>

                        <div className="mt-0.5 text-[9.5px] text-[#7c8194]">
                          1.2 MB
                        </div>

                      </div>

                    </div>

                  </div>

                </div>

              </div>

            </div>

          </div>

          {/* PAYMENT NOTE */}
          <div className="mt-3 flex items-center gap-2 px-1">

            <Icon
              name="shield"
              size={14}
              className="shrink-0 text-[#7d8293]"
            />

            <p className="text-[10px] leading-[1.35] text-[#777d90]">
              You can review payment options after this order is saved.
            </p>

          </div>

          {/* CONTINUE */}
          <div className="mt-3 pb-4">

            <PrimaryButton
              arrow
              onClick={() => nav.navigate("paymentMethod")}
            >
              Continue
            </PrimaryButton>

          </div>

        </div>
      </div>

      {/* BOTTOM NAV */}
      <div className="relative z-50 shrink-0 border-t border-[#e7e8ef] bg-white">
        <BottomNav active="Home" />
      </div>

    </div>
  );
}