import PrimaryButton from "../components/PrimaryButton";
import AntfastLogo from "../components/AntfastLogo";
import { BottomNav, Icon } from "../components/ui";
import { art, photos } from "../assets";
import { useNav } from "../nav";

export default function OrderSaved() {
  const nav = useNav();

  return (
    <div className="flex flex-1 flex-col">
      <div className="flex items-center justify-between px-5 pt-2 pb-1">
        <button type="button" onClick={nav.back}
          className="flex h-10 w-10 items-center justify-center rounded-full bg-white shadow-[0_2px_10px_rgba(30,25,70,0.06)]">
          <Icon name="back" size={22} strokeWidth={2.2} />
        </button>
        <AntfastLogo style={{ width: 140, height: "auto" }} />
        <div className="w-10" />
      </div>

      <div className="flex-1 overflow-y-auto pb-6">
        <div className="flex flex-col items-center px-6">
          <h1 className="mt-5 text-center text-[28px] font-bold tracking-[-0.01em] text-[#1f2533]">Order Saved</h1>

          <div className="mt-2 flex items-center gap-1.5 rounded-full border border-[var(--border)] bg-white px-3.5 py-1.5">
            <Icon name="clock" size={14} className="text-[var(--muted-foreground)]" />
            <span className="text-[12px] font-semibold text-[var(--muted-foreground)]">Verification in review</span>
          </div>

          {/* KYC illustration */}
          <div className="-mx-6 mt-4 w-[calc(100%+48px)]">
            <img
              src={art.kycShield}
              alt="KYC verification in review"
              className="block w-full object-contain"
              style={{ maxHeight: 250 }}
            />
          </div>

          <h2 className="mt-4 text-center text-[22px] font-bold text-[#1f2533]">Your order has been saved.</h2>
          <p className="mt-1.5 text-center text-[13.5px] leading-relaxed text-[var(--muted-foreground)]">
            Payment will be available after ANTFAST<br />approves your account.
          </p>

          {/* Order card */}
          <div className="mt-5 flex w-full items-center gap-3 rounded-2xl border border-[var(--border)] bg-white p-3.5 shadow-[0_2px_8px_rgba(30,25,70,0.05)]">
            <img src={photos.villa} alt="Palm Jumeirah Villa" className="h-14 w-14 rounded-xl object-cover" />
            <div className="flex-1">
              <div className="text-[13.5px] font-bold text-[#1f2533]">Palm Jumeirah Villa · 120 m³ · C30/37</div>
              <div className="mt-1.5 flex items-center gap-1.5">
                <Icon name="clock" size={13} className="text-[var(--muted-foreground)]" />
                <span className="text-[11.5px] font-semibold text-[var(--muted-foreground)]">Waiting for KYC Approval</span>
              </div>
            </div>
          </div>

          <div className="mt-5 w-full space-y-3">
            <PrimaryButton arrow onClick={() => nav.navigate("orders")}>
              View Saved Order
            </PrimaryButton>
            <PrimaryButton variant="outline" onClick={() => nav.jump("home", { approved: false })}>
              Back to Home
            </PrimaryButton>
          </div>
        </div>
      </div>
      <BottomNav active="Home" />
    </div>
  );
}
