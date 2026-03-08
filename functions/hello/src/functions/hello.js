const { app } = require('@azure/functions');

app.http('hello', {
  methods: ['GET', 'POST'],
  authLevel: 'anonymous',
  route: 'hello',
  handler: async (request, context) => {
    const nombre = request.query.get('nombre') || 'Mundo';
    return {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        mensaje: `¡Hola, ${nombre}! 👋`,
        funcion: 'hello',
        timestamp: new Date().toISOString()
      })
    };
  }
});