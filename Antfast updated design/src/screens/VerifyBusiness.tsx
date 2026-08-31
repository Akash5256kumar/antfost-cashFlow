import AntfastLogo from "../components/AntfastLogo";
import PrimaryButton from "../components/PrimaryButton";
import { Icon } from "../components/ui";
import { art } from "../assets";
import { useNav } from "../nav";

const docs = [
  { title: "Trade License", desc: "Upload a clear copy of your trade license" },
  { title: "VAT Certificate", desc: "Upload your VAT certificate", optional: true },
  { title: "Authorized Person ID", desc: "Upload ID of authorized signatory" },
];

export default function VerifyBusiness() {
  const nav = useNav();

  return (
    <div className="flex flex-1 flex-col overflow-y-auto px-6 pb-8">

      {/* Header: back button left, logo centered */}
      <div className="relative flex items-center pt-2">
        <button onClick={nav.back} aria-label="Back" className="flex h-9 w-9 items-center justify-center">
          <Icon name="back" size={24} strokeWidth={2.2} />
        </button>
        <div className="absolute inset-x-0 flex justify-center">
          <AntfastLogo style={{ width: 160, height: "auto" }} />
        </div>
      </div>

      {/* Title */}
      <div className="mt-5">
        <h1 className="text-[28px] font-bold leading-tight tracking-[-0.01em] text-[#1f2533]">Verify Your Business</h1>
        <p className="mt-1.5 text-[15px] leading-relaxed text-[var(--muted-foreground)]">Secure company verification</p>
      </div>

      {/* Illustration */}
      <div className="-mx-6 mt-4">
        <img
          src={art.kycShield}
          alt="Verified trade license with a shield and mixer truck"
          className="block w-full object-contain"
          style={{ maxHeight: 230 }}
        />
      </div>

      {/* Progress indicator */}
      <div className="mt-3 flex items-center gap-3">
        <span className="text-[12px] font-semibold text-[var(--muted-foreground)]">1 of 3</span>
        <div className="h-1.5 flex-1 overflow-hidden rounded-full bg-[#e6e4f1]">
          <div className="h-full w-1/3 rounded-full bg-[var(--primary)]" />
        </div>
      </div>

      {/* Upload Documents */}
      <h2 className="mt-7 text-[20px] font-bold text-[#1f2533]">Upload Documents</h2>
      <div className="mt-3 space-y-3">
        {docs.map((d) => (
          <button key={d.title} className="flex w-full items-center gap-3.5 rounded-2xl border border-[var(--border)] bg-white p-4 text-left shadow-[0_1px_4px_rgba(30,25,70,0.04)]">
            <div className="flex h-11 w-11 shrink-0 items-center justify-center rounded-xl bg-[var(--muted)] text-[var(--primary)]">
              <Icon name="doc" size={21} />
            </div>
            <div className="flex-1">
              <div className="text-[15px] font-semibold text-[#1f2533]">{d.title}</div>
              <div className="text-[13px] text-[var(--muted-foreground)]">{d.desc}</div>
            </div>
            {d.optional && (
              <span className="shrink-0 rounded-full bg-[var(--primary-soft)] px-2.5 py-1 text-[11px] font-semibold text-[var(--primary)]">Optional</span>
            )}
            <Icon name="chevronRight" size={20} className="shrink-0 text-[#c3c1d6]" />
          </button>
        ))}
      </div>

      {/* Company Details */}
      <div className="mt-5 rounded-2xl border border-[var(--border)] bg-white p-4 shadow-[0_1px_4px_rgba(30,25,70,0.04)]">
        <div className="text-[18px] font-semibold text-[#1f2533]">Company Details</div>
        <div className="mt-3 grid grid-cols-2 gap-4">
          {[
            { label: "Company Legal Name", icon: "building", ph: "Enter legal company name" },
            { label: "License Number", icon: "doc", ph: "Enter license number" },
          ].map((f) => (
            <div key={f.label}>
              <div className="text-[11px] font-medium text-[var(--muted-foreground)]">{f.label}</div>
              <div className="mt-1 flex items-center gap-1.5 border-b border-[var(--border)] pb-1.5">
                <Icon name={f.icon} size={16} className="text-[var(--primary)]" />
                <input placeholder={f.ph} className="w-full bg-transparent text-[12px] outline-none placeholder:text-[#a3a1b8]" />
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Security note */}
      <div className="mt-4 flex items-center gap-2 text-[12px] text-[var(--muted-foreground)]">
        <Icon name="lock" size={15} />
        Documents are encrypted and used only for account verification.
      </div>

      {/* Continue */}
      <div className="mt-5">
        <PrimaryButton arrow onClick={() => nav.navigate("home", { approved: false })}>
          Continue
        </PrimaryButton>
      </div>
      <button
        className="mt-3 text-center text-[14px] font-semibold text-[var(--primary)]"
        onClick={() => nav.navigate("home", { approved: false })}
      >
        Save and finish later
      </button>
    </div>
  );
}
