import { defineConfig } from 'vite';

const staticRouteRewriter = () => ({
  name: 'rewrite-static-routes',
  configureServer(server) {
    return () => {
      server.middlewares.use((req, _res, next) => {
        if (req.url === '/create') req.url = '/create/index.html';
        next();
      });
    };
  },
  configurePreviewServer(server) {
    return () => {
      server.middlewares.use((req, _res, next) => {
        if (req.url === '/create') req.url = '/create/index.html';
        next();
      });
    };
  },
});

export default defineConfig({
  server: { port: 5173 },
  plugins: [staticRouteRewriter()],
});


