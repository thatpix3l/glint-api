FROM ghcr.io/thatpix3l/glint-web:latest as web

FROM docker.io/oven/bun:1 AS compiler
WORKDIR /workdir
COPY . .
RUN bun install --production
RUN bun run compile

FROM scratch
COPY --from=compiler /workdir/build/glint-server /app/
COPY --from=web /var/www/ /app/public/
