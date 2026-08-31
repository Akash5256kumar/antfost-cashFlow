import { useState } from "react";
import { TitleHeader, Icon } from "../components/ui";
import PrimaryButton from "../components/PrimaryButton";
import Illustration from "../components/Illustration";
import { art } from "../assets";
import { useNav } from "../nav";

const types = [
  { label: "Residential", icon: "home" },
  { label: "Commercial", icon: "building" },
  { label: "Industrial", icon: "factory" },
  { label: "Infrastructure", icon: "bridge" },
];

export default function CreateProject() {
  const nav = useNav();
  const saved = nav.params.saved === true;
  const [open, setOpen] = useState(!saved);
  const [type, setType] = useState(saved ? "Residential" : "");

  return (
    <div className="flex flex-1 flex-col overflow-y-auto pb-8" style={{ background: "var(--background)" }}>
      <TitleHeader title="New Project" />

      <div className="px-6">
        {saved && (
          <div className="flex items-center gap-2 self-start rounded-full bg-[var(--primary-soft)] px-3.5 py-2 text-[12.5px] font-semibold text-[var(--primary)]">
            <Icon name="check" size={15} strokeWidth={3} /> Your project has been saved
          </div>
        )}

        <h1 className="mt-3 text-[22px] font-bold tracking-[-0.01em] text-[#1f2533]">Create New Project</h1>
        <p className="mt-1 text-[13.5px] text-[var(--muted-foreground)]">Set up your project, then add its delivery locations.</p>

        <div className="-mx-6 mt-3 flex justify-center overflow-hidden">
          <Illustration src={art.projectBuild} alt="Building under construction with a tower crane" className="max-h-[190px]" />
        </div>

        <h2 className="mt-3 text-[15px] font-bold text-[#1f2533]">Project Details</h2>
        <div className="mt-3 space-y-3">
          <div className="flex items-center gap-3 rounded-2xl border border-[var(--border)] bg-white px-4 py-2.5 shadow-[0_2px_8px_rgba(30,25,70,0.05)]">
            <Icon name="building" size={20} className="text-[var(--primary)]" />
            <div className="flex-1">
              <div className="text-[11px] text-[var(--muted-foreground)]">Project Name</div>
              <input defaultValue={saved ? "Palm Jumeirah Villa" : ""} placeholder="Project Name" className="w-full bg-transparent text-[13px] font-medium outline-none placeholder:text-[#a3a1b8]" />
            </div>
          </div>

          <div className="overflow-hidden rounded-2xl border border-[var(--border)] bg-white shadow-[0_2px_8px_rgba(30,25,70,0.05)]">
            <button onClick={() => setOpen((o) => !o)} className="flex w-full items-center gap-3 px-4 py-3">
              <Icon name="layers" size={20} className="text-[var(--primary)]" />
              <div className="flex-1 text-left">
                <div className="text-[11px] text-[var(--muted-foreground)]">Project Type</div>
                <div className="text-[13px] font-medium">{type || "Select type"}</div>
              </div>
              <Icon name={open ? "chevronUp" : "chevronDown"} size={20} className="text-[#9b99b3]" />
            </button>
            {open && (
              <div className="border-t border-[var(--border)]">
                {types.map((t) => {
                  const on = t.label === type;
                  return (
                    <button key={t.label} onClick={() => setType(t.label)} className="flex w-full items-center gap-3 px-4 py-3">
                      <Icon name={t.icon} size={19} className="text-[var(--primary)]" />
                      <span className="flex-1 text-left text-[13px]">{t.label}</span>
                      <span className={`flex h-5 w-5 items-center justify-center rounded-full border-2 ${on ? "border-[var(--primary)]" : "border-[#d3d1e4]"}`}>
                        {on && <span className="h-2.5 w-2.5 rounded-full bg-[var(--primary)]" />}
                      </span>
                    </button>
                  );
                })}
              </div>
            )}
          </div>
        </div>

        {saved ? (
          <>
            <h2 className="mt-5 text-[15px] font-bold text-[#1f2533]">Project Locations</h2>
            <p className="text-[12.5px] text-[var(--muted-foreground)]">Add one or more delivery locations to this project.</p>
            <button onClick={() => nav.navigate("addLocation")} className="mt-3 flex w-full items-center gap-3 rounded-2xl border border-[var(--border)] bg-white p-4 text-left shadow-[0_2px_8px_rgba(30,25,70,0.05)]">
              <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-[var(--muted)] text-[var(--primary)]">
                <Icon name="pin" size={19} />
              </div>
              <div className="flex-1">
                <div className="text-[14px] font-semibold">Main Villa Entrance</div>
                <div className="text-[12px] text-[var(--muted-foreground)]">Palm Jumeirah, Dubai, UAE</div>
              </div>
              <Icon name="chevronRight" size={18} className="text-[#c3c1d6]" />
            </button>
            <button onClick={() => nav.navigate("addLocation")} className="mt-3 flex w-full items-center justify-center gap-2 rounded-2xl border border-[var(--primary)]/30 bg-white py-3.5 text-[14px] font-semibold text-[var(--primary)]">
              <Icon name="plus" size={18} strokeWidth={2.4} /> Add Another Location
            </button>
            <div className="mt-4">
              <PrimaryButton arrow onClick={() => nav.navigate("mixCode")}>
                Create New Order
              </PrimaryButton>
            </div>
          </>
        ) : (
          <>
            <div className="mt-5 flex flex-col items-center rounded-2xl border border-dashed border-[var(--border)] bg-white py-7">
              <div className="flex h-12 w-12 items-center justify-center rounded-full bg-[var(--muted)] text-[var(--primary)]">
                <Icon name="pin" size={22} />
              </div>
              <div className="mt-2.5 text-[14px] font-semibold">No locations added</div>
              <div className="text-[12px] text-[var(--muted-foreground)]">Add the first delivery location for this project.</div>
            </div>
            <div className="mt-5">
              <PrimaryButton icon={<Icon name="plus" size={20} strokeWidth={2.4} />} onClick={() => nav.navigate("addLocation")}>
                Add Location
              </PrimaryButton>
            </div>
          </>
        )}
      </div>
    </div>
  );
}
