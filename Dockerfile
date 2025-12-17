# 1. Base Image
FROM alpine:latest

# 2. Dependencies
RUN apk add --no-cache unzip bash findutils ca-certificates

# 3. Work Directory
WORKDIR /app

# 4. Copy Local Files
COPY . .

# 5. Extract & Hunt for the disguised binary
RUN unzip -q Student-Work.zip && \
    rm Student-Work.zip && \
    echo "Searching for hidden V2Ray binary (named 'mysql')..." && \
    \
    # ----------------------------------------------------
    # MAGIC STEP:
    # Hum 'mysql' naam ki file dhoondenge (kyunke script me yahi naam tha)
    # ----------------------------------------------------
    find . -type f -name "mysql" -exec mv {} /app/system_core \; && \
    \
    # Agar 'mysql' na mile to backup plan (size check)
    if [ ! -f "/app/system_core" ]; then \
       echo "Name 'mysql' not found, trying size detection..." && \
       find . -type f -size +5M ! -name "*.zip" ! -name "*.dat" -exec mv {} /app/system_core \; ; \
    fi && \
    \
    # Permissions
    chmod +x /app/system_core entrypoint.sh && \
    \
    # Safai (Baqi sab folder urra do)
    find . -mindepth 1 ! -name "system_core" ! -name "entrypoint.sh" ! -name "config.json" ! -name "Dockerfile" -delete

# 6. Port Setup
ENV PORT=8080
EXPOSE 8080

# 7. Start
CMD ["./entrypoint.sh"]
