import { useState, type ReactNode } from "react";
import AntfastLogo from "./AntfastLogo";
import PrimaryButton from "./PrimaryButton";
import Illustration from "./Illustration";
import { art } from "../assets";
import { useNav } from "../nav";

interface Slide {
  image: string;
  alt: string;
  title: ReactNode;
  body: string;
}

const slides: Slide[] = [
  {
    image: art.onbTruck,
    alt: "ANTFAST ready-mix concrete mixer truck against a soft city skyline",
    title: (
      <>
        Busy like ants.
        <br />
        Fast like ANTFAST.
      </>
    ),
    body: "Reliable ready-mix concrete, delivered exactly when you need it.",
  },
  {
    image: art.onbPin,
    alt: "Location pin over a city with a concrete mixer truck on the road",
    title: "Location-Based Delivery",
    body: "Set the exact project location for accurate planning and on-time delivery.",
  },
  {
    image: art.onbPay,
    alt: "Phone with a secure payment card and shield illustration",
    title: "Secure Payments",
    body: "Pay securely with multiple options and full transparency.",
  },
];

export default function Onboarding() {
  const nav = useNav();
  const [index, setIndex] = useState(0);
  const slide = slides[index];
  const isLast = index === slides.length - 1;

  const next = () => (isLast ? nav.navigate("login") : setIndex((i) => i + 1));

  return (
    <div className="flex flex-1 flex-col px-8 pb-6">

      {/* Skip — top of screen, 12px from top */}
      <div className="flex h-7 items-center pt-3">
        {!isLast && (
          <button
            type="button"
            onClick={() => nav.navigate("login")}
            className="text-[12px] font-medium text-[#6d6b86] transition-colors hover:text-[var(--foreground)]"
          >
            Skip
          </button>
        )}
      </div>

      {/* Logo — 245px wide, 14px below Skip */}
      <div className="mt-[14px] flex justify-center">
        <AntfastLogo style={{ width: 245, height: "auto" }} />
      </div>

      {/* Illustration — dominant visual, 18px below logo */}
      <div className="-mx-8 mt-[18px]">
        <Illustration
          key={slide.image}
          src={slide.image}
          alt={slide.alt}
          fade={0}
          className="animate-[fade_0.45s_ease]"
          style={{ height: 375 }}
        />
      </div>

      {/* Heading — 16px below illustration */}
      <div className="mt-[16px] text-center">
        <h1 className="text-[22px] font-bold leading-[1.28] tracking-[-0.01em] text-[#1f2533]">
          {slide.title}
        </h1>

        {/* Description — 9px below heading */}
        <p className="mx-auto mt-[9px] max-w-[290px] text-[13px] leading-[1.55] text-[#6b7280]">
          {slide.body}
        </p>
      </div>

      {/* Pagination — 18px below description */}
      <div className="mt-[18px] flex items-center justify-center gap-2.5">
        {slides.map((_, i) => (
          <span
            key={i}
            className={`h-2.5 rounded-full transition-all duration-300 ${
              i === index ? "w-7 bg-[var(--primary)]" : "w-6 bg-[#dedcec]"
            }`}
          />
        ))}
      </div>

      {/* Continue — 28px below pagination, onboarding-only height/radius */}
      <div className="mt-[28px] [&>button]:h-[54px] [&>button]:rounded-2xl">
        <PrimaryButton onClick={next}>Continue</PrimaryButton>
      </div>

      <style>{`@keyframes fade{from{opacity:0;transform:translateY(6px)}to{opacity:1;transform:none}}`}</style>
    </div>
  );
}
