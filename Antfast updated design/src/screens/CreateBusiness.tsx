import AntfastLogo from "../components/AntfastLogo";
import PrimaryButton from "../components/PrimaryButton";
import { Field, Icon } from "../components/ui";
import { art } from "../assets";
import { useNav } from "../nav";

export default function CreateBusiness() {
  const nav = useNav();

  return (
    <div className="flex flex-1 flex-col overflow-y-auto px-6 pb-8">
      {/* Header: back + centered logo */}
      <div className="relative flex items-center pt-2">
        <button onClick={nav.back} aria-label="Back" className="flex h-9 w-9 items-center justify-center">
          <Icon name="back" size={24} strokeWidth={2.2} />
        </button>
        <div className="absolute inset-x-0 flex justify-center">
          <AntfastLogo style={{ width: 160, height: "auto" }} />
        </div>
      </div>

      {/* Illustration */}
      <div className="-mx-6 mt-3">
        <img
          src={art.businessReceipt}
          alt="ANTFAST business plant and mixer trucks"
          className="block w-full object-contain"
          style={{ maxHeight: 220 }}
        />
      </div>

      {/* Title */}
      <h1 className="mt-2 text-[24px] font-bold tracking-[-0.01em] text-[#1f2533]">Create Business Account</h1>
      <p className="mt-1 text-[13.5px] text-[var(--muted-foreground)]">Set up your company access</p>

      {/* Fields */}
      <div className="mt-4 space-y-3">
        <Field icon="building" placeholder="Company Name" />
        <Field icon="user" placeholder="Business Username" />
        <Field icon="phone" placeholder="Registered Mobile" />
        <Field icon="lock" placeholder="Password" type="password" trailing={<Icon name="eyeOff" size={20} className="text-[#9b99b3]" />} />
        <Field icon="lock" placeholder="Confirm Password" type="password" trailing={<Icon name="eyeOff" size={20} className="text-[#9b99b3]" />} />
      </div>

      <p className="mt-4 text-center text-[12px] leading-relaxed text-[var(--muted-foreground)]">
        You can plan an order while verification is in progress.
        <br />
        Payment activates after approval.
      </p>

      <div className="mt-4">
        <PrimaryButton arrow onClick={() => nav.navigate("otp")}>
          Create Account
        </PrimaryButton>
      </div>
    </div>
  );
}
