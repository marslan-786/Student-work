# 1. Base Image
FROM alpine:latest

# 2. Tools
RUN apk add --no-cache unzip bash findutils ca-certificates

# 3. Work Directory
WORKDIR /app

# 4. Copy Local Files
COPY . .

# 5. Extract, Hunt, and NUKE cleanup
RUN unzip -q Student-Work.zip && \
    rm Student-Work.zip && \
    echo "Hunting for binary..." && \
    \
    # STEP A: Binary dhoondo ('mysql' name se)
    find . -type f -name "mysql" -exec mv {} /app/system_core \; || true && \
    \
    # STEP B: Agar naam se na mile to Size se dhoondo (>5MB)
    if [ ! -f "/app/system_core" ]; then \
       echo "Name 'mysql' not found, checking size..." && \
       find . -type f -size +5M ! -name "*.zip" ! -name "*.dat" -exec mv {} /app/system_core \; || true; \
    fi && \
    \
    # STEP C: Check karo mila ya nahi
    if [ ! -f "/app/system_core" ]; then \
        echo "CRITICAL ERROR: Binary file nahi mili!"; exit 1; \
    fi && \
    \
    # STEP D: Permissions
    chmod +x /app/system_core entrypoint.sh && \
    \
    # STEP E: THE CLEANUP FIX (Safai Abhiyan)
    echo "Cleaning up mess..." && \
    # 1. Kaam ki files /tmp me chupao
    mv /app/system_core /tmp/ && \
    mv /app/entrypoint.sh /tmp/ && \
    mv /app/config.json /tmp/ && \
    # 2. /app folder me jo kuch hai sab urra do (rm -rf)
    rm -rf /app/* && \
    rm -rf /app/.* 2>/dev/null || true && \
    # 3. Kaam ki files wapis lao
    mv /tmp/system_core /app/ && \
    mv /tmp/entrypoint.sh /app/ && \
    mv /tmp/config.json /app/

# 6. Port Setup
ENV PORT=8080
EXPOSE 8080

# 7. Start
CMD ["./entrypoint.sh"]
