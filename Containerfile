FROM docker.io/oven/bun:1 AS compiler
WORKDIR /workdir
COPY . .
RUN bun install --production
RUN bun run compile

FROM scratch
COPY --from=compiler /workdir/build/glint-server /app/

CMD ["/app/glint-server"]