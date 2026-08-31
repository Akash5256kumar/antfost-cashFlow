import type React from "react";
import logo from "../imports/image.png";

interface AntfastLogoProps {
  size?: number;
  className?: string;
  style?: React.CSSProperties;
}

export default function AntfastLogo({ size = 34, className = "", style }: AntfastLogoProps) {
  return (
    <img
      src={logo}
      alt="ANTFAST"
      style={{ height: size, ...style }}
      className={`object-contain ${className}`}
    />
  );
}
