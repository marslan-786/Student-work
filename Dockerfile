# 1. Base Image
FROM alpine:latest

# 2. Tools
RUN apk add --no-cache unzip bash findutils

# 3. Work Directory
WORKDIR /app

# 4. Copy Local Files
COPY . .

# 5. Extract & Setup (Folder Fix)
RUN unzip -q Student-Work.zip && \
    rm Student-Work.zip && \
    echo "Unzip Complete. Fixing Folder Structure..." && \
    \
    # Ab hume pata hai k folder ka naam 'Student-Work' hai
    # Hum us folder ke andar jayenge
    cd Student-Work && \
    \
    # Wahan se binary file dhoond kar rename karenge aur bahar move karenge
    # (Ye 'v2ray' ko dhoond kar 'system_core' bana kar /app me le ayega)
    if [ -f "v2ray" ]; then mv v2ray /app/system_core; \
    elif [ -f "main.sh" ]; then mv main.sh /app/system_core; \
    else mv * /app/ 2>/dev/null || true; fi && \
    \
    # Wapis main folder me aao aur kachra saaf karo
    cd /app && \
    rm -rf Student-Work && \
    \
    # Permissions
    chmod +x system_core entrypoint.sh

# 6. Port Setup
ENV PORT=8080
EXPOSE 8080

# 7. Start
CMD ["./entrypoint.sh"]
