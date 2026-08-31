import { useState } from "react";
import AntfastLogo from "../components/AntfastLogo";
import PrimaryButton from "../components/PrimaryButton";
import { Field, Icon } from "../components/ui";
import { art } from "../assets";
import { useNav } from "../nav";

export default function CreateIndividual() {
  const nav = useNav();
  const [show, setShow] = useState(false);
  const [agree, setAgree] = useState(true);

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
          src={art.individualHouse}
          alt="Construction site with a villa and concrete truck"
          className="block w-full object-contain"
          style={{ maxHeight: 220 }}
        />
      </div>

      {/* Title */}
      <h1 className="mt-2 text-[24px] font-bold tracking-[-0.01em] text-[#1f2533]">Create Individual Account</h1>
      <p className="mt-1 text-[13.5px] text-[var(--muted-foreground)]">Set up your personal access</p>

      {/* Fields */}
      <div className="mt-4 space-y-3">
        <Field icon="user" placeholder="Full Name" />
        <Field icon="phone" placeholder="Mobile Number" />
        <Field icon="user" placeholder="Nickname / Username" />
        <Field
          icon="lock"
          placeholder="Password"
          type={show ? "text" : "password"}
          trailing={
            <button onClick={() => setShow((s) => !s)} className="text-[#9b99b3]">
              <Icon name={show ? "eye" : "eyeOff"} size={20} />
            </button>
          }
        />
        <Field icon="lock" placeholder="Confirm Password" type="password" trailing={<Icon name="eye" size={20} className="text-[#9b99b3]" />} />
      </div>

      <p className="mt-4 text-center text-[12px] text-[var(--muted-foreground)]">Your mobile number will be verified by OTP.</p>

      <button onClick={() => setAgree((a) => !a)} className="mt-3 flex items-center gap-2.5">
        <span className={`flex h-5 w-5 shrink-0 items-center justify-center rounded-md border-2 ${agree ? "border-[var(--primary)] bg-[var(--primary)]" : "border-[#d3d1e4]"}`}>
          {agree && <Icon name="check" size={11} strokeWidth={3.2} className="text-white" />}
        </span>
        <span className="text-[13px] text-[var(--foreground)]">I accept the account terms</span>
      </button>

      <div className="mt-4">
        <PrimaryButton arrow onClick={() => nav.navigate("otp")}>
          Create Account
        </PrimaryButton>
      </div>
    </div>
  );
}
