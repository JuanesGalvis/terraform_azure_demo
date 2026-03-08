const { app } = require('@azure/functions');

app.http('goodbye', {
  methods: ['GET', 'POST'],
  authLevel: 'anonymous',
  route: 'goodbye',
  handler: async (request, context) => {
    const nombre = request.query.get('nombre') || 'Mundo';
    const despedidas = [
      `¡Hasta luego, ${nombre}! 👋`,
      `¡Adiós, ${nombre}! 🙌`,
      `¡Chao, ${nombre}! 😊`
    ];
    const mensaje = despedidas[Math.floor(Math.random() * despedidas.length)];
    return {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        mensaje,
        funcion: 'goodbye',
        timestamp: new Date().toISOString()
      })
    };
  }
});