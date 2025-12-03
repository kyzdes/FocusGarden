// SVG components for garden elements

interface ElementProps {
  className?: string;
}

export function Tree({ className = '' }: ElementProps) {
  return (
    <svg className={className} viewBox="0 0 64 80" fill="none" xmlns="http://www.w3.org/2000/svg">
      {/* Trunk */}
      <rect x="26" y="50" width="12" height="30" rx="2" fill="#8B6F47" />
      {/* Foliage layers */}
      <ellipse cx="32" cy="48" rx="20" ry="16" fill="#7BC5AE" />
      <ellipse cx="32" cy="38" rx="18" ry="14" fill="#9ED9C5" />
      <ellipse cx="32" cy="30" rx="14" ry="12" fill="#B8E6D5" />
      {/* Highlights */}
      <ellipse cx="28" cy="32" rx="4" ry="3" fill="#D4F1E8" opacity="0.6" />
      <ellipse cx="36" cy="40" rx="3" ry="2" fill="#D4F1E8" opacity="0.5" />
    </svg>
  );
}

export function Cloud({ className = '' }: ElementProps) {
  return (
    <svg className={className} viewBox="0 0 80 40" fill="none" xmlns="http://www.w3.org/2000/svg">
      <ellipse cx="20" cy="25" rx="15" ry="12" fill="#FFFFFF" opacity="0.9" />
      <ellipse cx="40" cy="20" rx="20" ry="16" fill="#FFFFFF" opacity="0.9" />
      <ellipse cx="60" cy="25" rx="15" ry="12" fill="#FFFFFF" opacity="0.9" />
      <ellipse cx="35" cy="28" rx="18" ry="10" fill="#F8F9FA" opacity="0.8" />
    </svg>
  );
}

export function Butterfly({ className = '' }: ElementProps) {
  return (
    <svg className={className} viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg">
      {/* Body */}
      <ellipse cx="24" cy="24" rx="2" ry="8" fill="#4A5568" />
      <circle cx="24" cy="18" r="2" fill="#2D3748" />
      {/* Left wings */}
      <ellipse cx="16" cy="22" rx="8" ry="10" fill="#F6AD55" opacity="0.9" />
      <ellipse cx="14" cy="20" rx="5" ry="6" fill="#ED8936" opacity="0.8" />
      <ellipse cx="16" cy="32" rx="6" ry="8" fill="#FBD38D" opacity="0.9" />
      {/* Right wings */}
      <ellipse cx="32" cy="22" rx="8" ry="10" fill="#F6AD55" opacity="0.9" />
      <ellipse cx="34" cy="20" rx="5" ry="6" fill="#ED8936" opacity="0.8" />
      <ellipse cx="32" cy="32" rx="6" ry="8" fill="#FBD38D" opacity="0.9" />
      {/* Spots */}
      <circle cx="16" cy="22" r="2" fill="#FFFFFF" opacity="0.6" />
      <circle cx="32" cy="22" r="2" fill="#FFFFFF" opacity="0.6" />
    </svg>
  );
}

export function Bird({ className = '' }: ElementProps) {
  return (
    <svg className={className} viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg">
      {/* Body */}
      <ellipse cx="24" cy="26" rx="8" ry="10" fill="#A8C5E0" />
      {/* Head */}
      <circle cx="24" cy="18" r="6" fill="#A8C5E0" />
      {/* Eye */}
      <circle cx="26" cy="17" r="1.5" fill="#2D3748" />
      {/* Beak */}
      <path d="M30 18 L34 17 L30 16 Z" fill="#F6AD55" />
      {/* Left wing */}
      <ellipse cx="18" cy="26" rx="6" ry="10" fill="#8BAED4" transform="rotate(-20 18 26)" />
      {/* Right wing */}
      <ellipse cx="30" cy="26" rx="6" ry="10" fill="#8BAED4" transform="rotate(20 30 26)" />
      {/* Tail */}
      <ellipse cx="24" cy="36" rx="4" ry="6" fill="#A8C5E0" />
      {/* Belly highlight */}
      <ellipse cx="24" cy="28" rx="4" ry="5" fill="#C5DBEF" opacity="0.6" />
    </svg>
  );
}

export function Rabbit({ className = '' }: ElementProps) {
  return (
    <svg className={className} viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg">
      {/* Body */}
      <ellipse cx="28" cy="32" rx="10" ry="12" fill="#E5E5E5" />
      {/* Head */}
      <circle cx="24" cy="22" r="8" fill="#E5E5E5" />
      {/* Left ear */}
      <ellipse cx="20" cy="12" rx="3" ry="10" fill="#E5E5E5" transform="rotate(-15 20 12)" />
      <ellipse cx="20" cy="12" rx="1.5" ry="7" fill="#FFC1CC" transform="rotate(-15 20 12)" />
      {/* Right ear */}
      <ellipse cx="28" cy="12" rx="3" ry="10" fill="#E5E5E5" transform="rotate(15 28 12)" />
      <ellipse cx="28" cy="12" rx="1.5" ry="7" fill="#FFC1CC" transform="rotate(15 28 12)" />
      {/* Face */}
      <circle cx="21" cy="22" r="1.5" fill="#2D3748" />
      <circle cx="27" cy="22" r="1.5" fill="#2D3748" />
      <ellipse cx="24" cy="25" rx="1" ry="1.5" fill="#FFC1CC" />
      {/* Tail */}
      <circle cx="34" cy="34" r="4" fill="#F5F5F5" />
    </svg>
  );
}

export function Deer({ className = '' }: ElementProps) {
  return (
    <svg className={className} viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg">
      {/* Body */}
      <ellipse cx="28" cy="32" rx="12" ry="10" fill="#D4A574" />
      {/* Neck */}
      <rect x="18" y="22" width="6" height="12" rx="3" fill="#D4A574" />
      {/* Head */}
      <ellipse cx="20" cy="18" rx="6" ry="7" fill="#D4A574" />
      {/* Snout */}
      <ellipse cx="20" cy="22" rx="3" ry="2" fill="#C8956A" />
      {/* Ears */}
      <ellipse cx="18" cy="14" rx="2" ry="4" fill="#D4A574" transform="rotate(-20 18 14)" />
      <ellipse cx="22" cy="14" rx="2" ry="4" fill="#D4A574" transform="rotate(20 22 14)" />
      {/* Antlers - left */}
      <path d="M18 12 L16 8 M16 8 L14 9 M16 8 L17 6" stroke="#8B6F47" strokeWidth="1.5" strokeLinecap="round" />
      {/* Antlers - right */}
      <path d="M22 12 L24 8 M24 8 L26 9 M24 8 L23 6" stroke="#8B6F47" strokeWidth="1.5" strokeLinecap="round" />
      {/* Eye */}
      <circle cx="21" cy="18" r="1" fill="#2D3748" />
      {/* Legs */}
      <rect x="24" y="38" width="3" height="8" rx="1.5" fill="#C8956A" />
      <rect x="30" y="38" width="3" height="8" rx="1.5" fill="#C8956A" />
      {/* Spots */}
      <circle cx="26" cy="30" r="2" fill="#FFFFFF" opacity="0.5" />
      <circle cx="32" cy="32" r="1.5" fill="#FFFFFF" opacity="0.5" />
      <circle cx="28" cy="35" r="1.5" fill="#FFFFFF" opacity="0.5" />
    </svg>
  );
}

export function Fox({ className = '' }: ElementProps) {
  return (
    <svg className={className} viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg">
      {/* Body */}
      <ellipse cx="28" cy="32" rx="10" ry="9" fill="#E67E22" />
      {/* Belly */}
      <ellipse cx="28" cy="34" rx="6" ry="6" fill="#F8F4E8" />
      {/* Neck */}
      <ellipse cx="22" cy="26" rx="5" ry="6" fill="#E67E22" />
      {/* Head */}
      <circle cx="20" cy="20" r="7" fill="#E67E22" />
      {/* Snout */}
      <ellipse cx="20" cy="23" rx="4" ry="3" fill="#F8F4E8" />
      <ellipse cx="20" cy="24" rx="1.5" ry="1" fill="#2D3748" />
      {/* Ears */}
      <path d="M16 14 L14 8 L18 16 Z" fill="#E67E22" />
      <path d="M24 14 L26 8 L22 16 Z" fill="#E67E22" />
      <path d="M16 14 L15 10 L17 15 Z" fill="#2D3748" />
      <path d="M24 14 L25 10 L23 15 Z" fill="#2D3748" />
      {/* Eyes */}
      <circle cx="18" cy="20" r="1.5" fill="#2D3748" />
      <circle cx="22" cy="20" r="1.5" fill="#2D3748" />
      {/* Tail */}
      <ellipse cx="36" cy="30" rx="8" ry="6" fill="#E67E22" transform="rotate(30 36 30)" />
      <ellipse cx="38" cy="28" rx="4" ry="3" fill="#F8F4E8" transform="rotate(30 38 28)" />
    </svg>
  );
}
