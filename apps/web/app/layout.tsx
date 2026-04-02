import './globals.css';
import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'GO Move | Auto y Moto en Lima',
  description: 'Movilidad urbana segura y rápida en Lima con servicio de auto y moto.',
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="es">
      <body>{children}</body>
    </html>
  );
}
