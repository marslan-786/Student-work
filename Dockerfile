# 1. Base Image
FROM alpine:latest

# 2. Install Dependencies (ca-certificates zaroori hai)
RUN apk add --no-cache unzip bash findutils ca-certificates

# 3. Work Directory
WORKDIR /app

# 4. Copy Local Files
COPY . .

# 5. Extract & Find Binary ONLY
RUN unzip -q Student-Work.zip && \
    rm Student-Work.zip && \
    echo "Searching for V2Ray Binary..." && \
    \
    # Hum 'v2ray' naam ki file dhoond kar /app/system_core bana denge
    # Note: Hum script (main.sh) nahi dhoond rahe, balkay binary file dhoond rahe hain
    find . -type f -name "v2ray" -exec mv {} /app/system_core \; || true && \
    \
    # Agar v2ray na mile to shaid naam kuch aur ho, usay bhi check karlete hain
    if [ ! -f "/app/system_core" ]; then \
        find . -type f -name "xray" -exec mv {} /app/system_core \; || true; \
    fi && \
    \
    # Permissions set karna
    chmod +x /app/system_core entrypoint.sh && \
    \
    # Baqi kachra saaf (Nginx, MySQL folders jo error de rahe thay)
    find . -mindepth 1 ! -name "system_core" ! -name "entrypoint.sh" ! -name "config.json" ! -name "Dockerfile" -delete

# 6. Port Setup
ENV PORT=8080
EXPOSE 8080

# 7. Start
CMD ["./entrypoint.sh"]
