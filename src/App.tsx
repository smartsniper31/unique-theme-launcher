import React, { useState, useEffect, useMemo } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { Battery, Clock, Zap, Smartphone, ShieldCheck, Wifi } from 'lucide-react';

// --- Types ---
interface ThemeConfig {
  primaryColor: string;
  cornerRadius: number;
  gridColumns: number;
  iconSize: number;
  fontSize: number;
  signature: string;
}

interface UserSpecs {
  model: string;
  os: string;
  battery: number;
  timestamp: string;
  wifi: string;
}

// --- Utils ---
const generateColor = (name: string) => {
  let hash = 0;
  for (let i = 0; i < name.length; i++) {
    hash = name.charCodeAt(i) + ((hash << 5) - hash);
  }
  const color = `hsl(${Math.abs(hash) % 360}, 70%, 50%)`;
  return color;
};

const getVowelCount = (name: string) => {
  return (name.match(/[aeiouy]/gi) || []).length;
};

const getGreeting = (name: string) => {
  const hour = new Date().getHours();
  if (hour < 12) return `Éveil, ${name}. Le monde t'attend.`;
  if (hour < 18) return `Énergie, ${name}. Ta trace se dessine.`;
  return `Repos, ${name}. Ta signature demeure.`;
};

// --- Components ---
export default function App() {
  const [name, setName] = useState('Utilisateur');
  const [specs, setSpecs] = useState<UserSpecs | null>(null);
  const [isLoaded, setIsLoaded] = useState(false);

  useEffect(() => {
    // Simulate auto-detection
    const detect = async () => {
      // 1. Name detection (simulated)
      // In a real web app, we might use Google One Tap or similar
      // Here we just use a placeholder or try to guess from user agent (not really possible)
      const detectedName = "Adnene"; // Hardcoded for demo as per user email prefix

      // 2. Hardware detection
      const ua = navigator.userAgent;
      let model = "Web Browser";
      if (ua.includes("iPhone")) model = "iPhone";
      else if (ua.includes("Android")) model = "Android Device";
      
      const os = navigator.platform;
      
      // 3. Battery
      let batteryLevel = 0.85;
      try {
        // @ts-ignore
        const battery = await navigator.getBattery();
        batteryLevel = battery.level;
      } catch (e) {}

      setSpecs({
        model,
        os,
        battery: batteryLevel,
        timestamp: new Date().toISOString(),
        wifi: navigator.onLine ? "Connected" : "Offline"
      });
      setName(detectedName);
      
      // Artificial delay for "magic" feel
      setTimeout(() => setIsLoaded(true), 1500);
    };

    detect();
  }, []);

  const theme = useMemo<ThemeConfig>(() => {
    if (!specs) return { primaryColor: '#3b82f6', cornerRadius: 12, gridColumns: 4, iconSize: 56, fontSize: 18, signature: '' };
    
    const signature = `${name.substring(0, 3).toUpperCase()}-${specs.model.substring(0, 2).toUpperCase()}-${specs.battery.toString().substring(2, 4)}`;
    
    return {
      primaryColor: generateColor(name),
      cornerRadius: Math.min(Math.max(getVowelCount(name) * 8, 8), 40),
      gridColumns: name.length <= 4 ? 3 : name.length <= 7 ? 4 : 5,
      iconSize: name.length < 5 ? 64 : name.length > 8 ? 48 : 56,
      fontSize: 16 + getVowelCount(name),
      signature
    };
  }, [name, specs]);

  if (!isLoaded || !specs) {
    return (
      <div className="flex flex-col items-center justify-center min-h-screen bg-neutral-950 text-white font-sans">
        <motion.div
          animate={{ rotate: 360 }}
          transition={{ duration: 2, repeat: Infinity, ease: "linear" }}
          className="w-12 h-12 border-4 border-blue-500 border-t-transparent rounded-full mb-6"
        />
        <motion.p
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          className="text-neutral-400 font-medium tracking-widest uppercase text-xs"
        >
          Initialisation du Thème Unique...
        </motion.p>
      </div>
    );
  }

  return (
    <div 
      className="min-h-screen font-sans transition-colors duration-1000"
      style={{ backgroundColor: `${theme.primaryColor}10` }}
    >
      <div className="max-w-md mx-auto min-h-screen flex flex-col p-8">
        {/* Header */}
        <motion.header
          initial={{ y: -20, opacity: 0 }}
          animate={{ y: 0, opacity: 1 }}
          className="mb-12"
        >
          <h1 
            className="font-bold leading-tight tracking-tighter mb-2"
            style={{ color: theme.primaryColor, fontSize: `${theme.fontSize * 1.8}px` }}
          >
            {getGreeting(name)}
          </h1>
          <p className="text-neutral-500 text-sm italic flex items-center gap-2">
            <ShieldCheck size={14} />
            Détecté via Empreinte Numérique
          </p>
        </motion.header>

        {/* Stats Row */}
        <motion.div 
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.3 }}
          className="grid grid-cols-2 gap-4 mb-12"
        >
          <div className="flex flex-col">
            <span className="text-neutral-400 text-xs font-medium uppercase tracking-wider mb-1">Énergie</span>
            <div className="flex items-center gap-2">
              <Battery size={18} style={{ color: theme.primaryColor }} />
              <span className="font-bold" style={{ color: theme.primaryColor, fontSize: `${theme.fontSize}px` }}>
                {(specs.battery * 100).toFixed(1)} {name}-pwr
              </span>
            </div>
          </div>
          <div className="flex flex-col items-end">
            <span className="text-neutral-400 text-xs font-medium uppercase tracking-wider mb-1">Temps</span>
            <div className="flex items-center gap-2">
              <span className="font-bold" style={{ color: theme.primaryColor, fontSize: `${theme.fontSize}px` }}>
                {Math.floor(Math.random() * 100)}.5 {name}-h
              </span>
              <Clock size={18} style={{ color: theme.primaryColor }} />
            </div>
          </div>
        </motion.div>

        {/* Main Stage */}
        <div className="flex-1 flex flex-col items-center justify-center">
          <motion.div
            initial={{ scale: 0.8, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            transition={{ type: "spring", damping: 15 }}
            className="relative"
          >
            <div 
              className="shadow-2xl flex items-center justify-center transition-all duration-700"
              style={{ 
                width: `${theme.iconSize * 3}px`, 
                height: `${theme.iconSize * 3}px`, 
                backgroundColor: theme.primaryColor,
                borderRadius: `${theme.cornerRadius}px`,
                boxShadow: `0 20px 50px -12px ${theme.primaryColor}60`
              }}
            >
              <Zap size={theme.iconSize * 1.5} color="white" />
            </div>
            
            {/* Floating Accents */}
            <motion.div
              animate={{ y: [0, -10, 0] }}
              transition={{ duration: 4, repeat: Infinity }}
              className="absolute -top-4 -right-4 w-12 h-12 rounded-full bg-white/20 backdrop-blur-sm flex items-center justify-center"
            >
              <Wifi size={20} color="white" />
            </motion.div>
          </motion.div>
        </div>

        {/* Footer Info */}
        <motion.footer
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.6 }}
          className="mt-auto pt-8 border-t border-neutral-200 flex flex-col items-center gap-4"
        >
          <div className="flex gap-8 text-neutral-400">
            <div className="flex items-center gap-2">
              <Smartphone size={14} />
              <span className="text-[10px] font-medium">{specs.model}</span>
            </div>
            <div className="flex items-center gap-2">
              <Zap size={14} />
              <span className="text-[10px] font-medium">v{specs.os}</span>
            </div>
          </div>
          <p className="text-[10px] font-mono text-neutral-400 tracking-widest uppercase">
            Signature: {theme.signature}
          </p>
        </motion.footer>
      </div>
    </div>
  );
}
