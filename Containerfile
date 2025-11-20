FROM docker.io/oven/bun:1 AS installed-dependencies
WORKDIR /workdir
COPY . .
RUN bun install --production

FROM installed-dependencies AS compiled
ARG TARGETPLATFORM

RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
        echo "Building for AMD64..."; \
        bun run compile --target bun-linux-x64-modern; \
    elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
        echo "Building for ARM64..."; \
        bun run compile --target bun-linux-arm64-modern; \
    else \
        echo "Invalid platform"; \
        echo "Expected one of the following: [\"linux/amd64\", \"linux/arm64\"]"; \
        echo "Instead got: \"${TARGETPLATFORM}\""; \
        exit 1; \
    fi

FROM gcr.io/distroless/static-debian12
COPY --from=compiled /workdir/build/glint-server /app/

CMD ["/app/glint-server"]