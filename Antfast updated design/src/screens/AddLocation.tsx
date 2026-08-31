import { AppHeader, BottomNav, Icon } from "../components/ui";
import PrimaryButton from "../components/PrimaryButton";
import { art } from "../assets";
import { useNav } from "../nav";

function Row({
  label,
  ph,
}: {
  label: string;
  ph: string;
}) {
  return (
    <div className="rounded-2xl border border-[var(--border)] bg-white px-4 py-2.5 shadow-[0_2px_8px_rgba(30,25,70,0.05)]">
      <div className="text-[11px] text-[var(--muted-foreground)]">
        {label}
      </div>

      <input
        placeholder={ph}
        className="
          w-full
          bg-transparent
          text-[13px]
          outline-none
          placeholder:text-[#a3a1b8]
        "
      />
    </div>
  );
}

export default function AddLocation() {
  const nav = useNav();

  return (
    <div
      className="flex flex-1 flex-col"
      style={{ background: "var(--background)" }}
    >
      <AppHeader back />

      {/* =========================================================
          PAGE HEADER
      ========================================================= */}
      <div className="px-6 pt-4">
        <h1
          className="
            text-[22px]
            font-bold
            tracking-[-0.02em]
            text-[#1f2533]
          "
        >
          Add Location
        </h1>

        <p
          className="
            mt-1
            text-[13.5px]
            text-[var(--muted-foreground)]
          "
        >
          For{" "}
          <span className="font-semibold text-[var(--primary)]">
            Palm Jumeirah Villa
          </span>
        </p>
      </div>

      {/* =========================================================
          MAP
      ========================================================= */}
      <div className="relative mt-4 overflow-hidden">
        <img
          src={art.locationPickerMap}
          alt="The Palm Jumeirah location picker"
          className="block w-full object-cover"
          style={{
            height: "230px",
          }}
        />

        {/* Current location */}
        <button
          type="button"
          className="
            absolute
            bottom-3
            right-3
            flex
            items-center
            gap-1.5
            rounded-full
            bg-white
            px-3
            py-2
            text-[12px]
            font-semibold
            text-[var(--primary)]
            shadow-md
          "
        >
          <Icon name="crosshair" size={14} />
          Use current location
        </button>
      </div>

      {/* =========================================================
          FORM CONTENT
      ========================================================= */}
      <div className="flex-1 overflow-y-auto px-6 pb-28">
        <div className="mt-5 space-y-3">
          {/* Location Name */}
          <Row
            label="Location Name"
            ph="e.g. Main Gate, North Entrance"
          />

          {/* Address */}
          <Row
            label="Address"
            ph="e.g. Palm Jumeirah, Frond E, Villa 123"
          />

          {/* Contact */}
          <div className="grid grid-cols-2 gap-3">
            <Row
              label="Site Contact"
              ph="e.g. Ahmed Khalid"
            />

            <Row
              label="Mobile Number"
              ph="e.g. +971 50 123 4567"
            />
          </div>
        </div>

        {/* =========================================================
            INFO
        ========================================================= */}
        <div className="mt-4 flex items-center gap-2.5">
          <span
            className="
              flex
              h-5
              w-5
              shrink-0
              items-center
              justify-center
              rounded-md
              bg-[var(--primary)]
            "
          >
            <Icon
              name="check"
              size={13}
              strokeWidth={3.2}
              className="text-white"
            />
          </span>

          <span
            className="
              text-[12.5px]
              leading-[1.35]
              text-[var(--muted-foreground)]
            "
          >
            This pin helps ANTFAST deliver to the correct entrance.
          </span>
        </div>

        {/* =========================================================
            ADD LOCATION
        ========================================================= */}
        <div className="mt-5">
          <PrimaryButton
            onClick={() =>
              nav.navigate("createProject", {
                saved: true,
              })
            }
          >
            Add Location
          </PrimaryButton>
        </div>

        {/* Cancel */}
        <button
          type="button"
          onClick={nav.back}
          className="
            mt-3
            w-full
            text-center
            text-[14px]
            font-semibold
            text-[var(--muted-foreground)]
          "
        >
          Cancel
        </button>
      </div>

      <BottomNav active="Projects" />
    </div>
  );
}