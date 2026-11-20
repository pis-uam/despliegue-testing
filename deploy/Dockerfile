FROM node:24-alpine3.22 AS builder

WORKDIR /app

ENV NODE_OPTIONS="--max-old-space-size=3072"

COPY app/package.json app/package-lock.json ./
RUN npm ci

COPY app/ ./

RUN npm run build

FROM node:24-alpine3.22 AS runner

WORKDIR /app

ENV NODE_ENV=production
ENV PORT=3000
ENV NEXT_TELEMETRY_DISABLED=1

COPY app/package.json app/package-lock.json ./
RUN npm ci --omit=dev

COPY --from=builder --chown=node:node /app/.next ./.next
COPY --from=builder --chown=node:node /app/public ./public
COPY --from=builder --chown=node:node /app/next.config.ts ./next.config.ts

RUN mkdir -p /app/.next/cache && chown -R node:node /app/.next/cache

COPY --chown=node:node --chmod=500 deploy/app/entrypoint.sh /app/entrypoint.sh

USER node

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 CMD node -e "fetch('http://127.0.0.1:3000/api/salud', {signal: AbortSignal.timeout(4000)}).then(r => process.exit(r.ok ? 0 : 1)).catch(() => process.exit(1))"

ENTRYPOINT ["/app/entrypoint.sh"]

CMD ["node", "node_modules/next/dist/bin/next", "start", "--hostname", "0.0.0.0"]
