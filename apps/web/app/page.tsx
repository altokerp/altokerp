const sections = [
  { id: 'como-funciona', title: 'Cómo funciona', text: 'Solicita, conecta y viaja con seguimiento en tiempo real.' },
  { id: 'servicios', title: 'Servicios', text: 'AUTO para confort y MOTO para rapidez y ahorro.' },
  { id: 'seguridad', title: 'Seguridad', text: 'Conductores verificados, botón SOS y monitoreo continuo.' },
];

export default function HomePage() {
  return (
    <main>
      <header className="hero">
        <p className="badge">Lima, Perú</p>
        <h1>GO Move</h1>
        <p>Movilidad urbana inteligente con viajes en AUTO y MOTO.</p>
        <div className="cta-group">
          <button>Descargar app pasajero</button>
          <button className="ghost">Conducir con GO Move</button>
        </div>
      </header>

      {sections.map((section) => (
        <section id={section.id} key={section.id} className="section">
          <h2>{section.title}</h2>
          <p>{section.text}</p>
        </section>
      ))}

      <section id="contacto" className="section alt">
        <h2>Contacto</h2>
        <p>Hola@gomove.pe | Soporte 24/7 para viajes en Lima.</p>
      </section>
    </main>
  );
}
