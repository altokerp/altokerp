const resourceName = typeof GetParentResourceName === 'function' ? GetParentResourceName() : 'LY_welcome_system';

const app = document.getElementById('app');
const statusEl = document.getElementById('status');
const titleEl = document.getElementById('title');
const descriptionEl = document.getElementById('description');
const codeInput = document.getElementById('codeInput');
const redeemBtn = document.getElementById('redeemBtn');
const closeBtn = document.getElementById('closeBtn');
const streamerBtn = document.getElementById('streamerBtn');
const confirmSound = document.getElementById('confirmSound');

const postNui = async (event, data = {}) => {
  try {
    await fetch(`https://${resourceName}/${event}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data)
    });
  } catch (error) {
    setStatus('No se pudo comunicar con el recurso.', true);
  }
};

const setStatus = (text, isError = false, isSuccess = false) => {
  statusEl.textContent = text;
  statusEl.classList.remove('error', 'success');
  if (isError) statusEl.classList.add('error');
  if (isSuccess) statusEl.classList.add('success');
};

const openPanel = () => {
  app.classList.remove('hidden');
  setStatus('Selecciona tu premio de bienvenida.');
};

const closePanel = () => {
  app.classList.add('hidden');
  codeInput.value = '';
  setStatus('Esperando acción...');
};

redeemBtn.addEventListener('click', () => {
  const code = codeInput.value.trim().toUpperCase();
  if (!code) {
    setStatus('Debes ingresar un código.', true);
    return;
  }

  postNui('redeemCode', { code });
});

closeBtn.addEventListener('click', () => postNui('close'));

streamerBtn.addEventListener('click', () => {
  setStatus('Contacta al staff por ticket para validación streamer.', false, true);
});

document.querySelectorAll('[data-vehicle]').forEach((btn) => {
  btn.addEventListener('click', () => {
    const vehicleType = btn.dataset.vehicle;
    setStatus('Procesando solicitud de bienvenida...');
    postNui('claimWelcome', { vehicleType });
  });
});

window.addEventListener('keydown', (event) => {
  if (event.key === 'Escape') {
    postNui('close');
  }
});

window.addEventListener('message', (event) => {
  const { action, data } = event.data || {};

  if (action === 'open') {
    openPanel();
    return;
  }

  if (action === 'close') {
    closePanel();
    return;
  }

  if (action === 'hydrate' && data) {
    titleEl.textContent = data.title || 'Bienvenido a Lima York RP';
    descriptionEl.textContent = data.description || '';
    return;
  }

  if (action === 'codeResult' && data) {
    if (data.success) {
      setStatus(data.message || 'Código válido aplicado.', false, true);
      confirmSound?.play().catch(() => {});
    } else {
      setStatus(data.message || 'Código inválido.', true);
    }
    return;
  }

  if (action === 'claimResult' && data) {
    if (data.success) {
      setStatus(data.message || 'Recompensa reclamada.', false, true);
      confirmSound?.play().catch(() => {});
    } else {
      setStatus(data.message || 'No se pudo reclamar.', true);
    }
  }
});
