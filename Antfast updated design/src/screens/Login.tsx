import { useState } from "react";
import AntfastLogo from "../components/AntfastLogo";
import PrimaryButton from "../components/PrimaryButton";
import { Field, Icon, Segmented } from "../components/ui";
import { art } from "../assets";
import { useNav } from "../nav";

export default function Login() {
  const nav = useNav();
  const [mode, setMode] = useState("Business");
  const [show, setShow] = useState(false);
  const business = mode === "Business";

  return (
    <div className="flex flex-1 flex-col overflow-y-auto px-6 pb-6 pt-2">
      <div className="mt-1 flex justify-center">
        <AntfastLogo size={54} />
      </div>

      <div className="-mx-7 mt-2">
        <img
          src={art.loginPlant}
          alt="ANTFAST batching plant with silos and mixer truck"
          className="block w-full object-contain"
          style={{
            WebkitMaskImage: "linear-gradient(to bottom, #000 70%, transparent 100%)",
            maskImage: "linear-gradient(to bottom, #000 70%, transparent 100%)",
          }}
        />
      </div>

      <h1 className="mt-2 text-center text-[20px] font-bold tracking-[-0.01em]">Login</h1>
      <p className="mx-auto mt-1.5 max-w-[270px] text-center text-[12px] leading-relaxed text-[var(--muted-foreground)]">
        {business
          ? "Plan concrete orders, manage project sites and track live deliveries."
          : "Log in to manage your projects, orders and deliveries."}
      </p>

      <div className="mt-3">
        <Segmented options={["Business", "Individual"]} value={mode} onChange={setMode} />
      </div>

      <div className="mt-4 space-y-3">
        <Field
          label={business ? "BUSINESS USERNAME" : "MOBILE NUMBER OR USERNAME"}
          icon={business ? "lock" : "user"}
          trailing={<Icon name="chevronRight" size={20} className="text-[#c3c1d6]" />}
        />
        <Field
          label="PASSWORD"
          icon="lock"
          type={show ? "text" : "password"}
          value="············"
          trailing={
            <button onClick={() => setShow((s) => !s)} className="text-[#9b99b3]">
              <Icon name={show ? "eye" : "eyeOff"} size={20} />
            </button>
          }
        />
      </div>

      <button className="mt-2 self-end text-[12px] font-semibold text-[var(--primary)]">Forgot Password?</button>

      <div className="mt-4">
        <PrimaryButton arrow onClick={() => nav.navigate("otp")}>
          Log In
        </PrimaryButton>
      </div>

      <div className="my-3 flex items-center gap-3 text-[12px] text-[var(--muted-foreground)]">
        <span className="h-px flex-1 bg-[var(--border)]" />
        or
        <span className="h-px flex-1 bg-[var(--border)]" />
      </div>

      <div className="space-y-3">
        <PrimaryButton variant="outline" onClick={() => nav.navigate("accountType")}>
          Create Account
        </PrimaryButton>
        <PrimaryButton variant="outline" onClick={() => nav.navigate("home", { approved: true })}>
          Try Our Demo
        </PrimaryButton>
      </div>
    </div>
  );
}
