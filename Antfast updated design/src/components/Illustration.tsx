import type React from "react";

export default function Illustration({
  src,
  alt,
  className = "",
  fade = 6,
  style,
}: {
  src: string;
  alt: string;
  className?: string;
  fade?: number;
  style?: React.CSSProperties;
}) {
  const maskStyle = fade > 0 ? (() => {
    const mask = `linear-gradient(to right, transparent 0, #000 ${fade}%, #000 ${100 - fade}%, transparent 100%), linear-gradient(to bottom, transparent 0, #000 ${fade}%, #000 ${100 - fade}%, transparent 100%)`;
    return { WebkitMaskImage: mask, maskImage: mask, WebkitMaskComposite: "source-in" as const, maskComposite: "intersect" as const };
  })() : {};
  return (
    <img
      src={src}
      alt={alt}
      className={`w-full object-contain ${className}`}
      style={{ ...maskStyle, ...style }}
    />
  );
}
