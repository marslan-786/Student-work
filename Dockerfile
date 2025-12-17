# 1. Base Image
FROM alpine:latest

# 2. Tools Install
RUN apk add --no-cache unzip bash

# 3. Working Directory
WORKDIR /app

# 4. COPY EVERYTHING (Magic Step)
# Ye command apki Repo ki sari files (smaet Student-Work.zip) container me le ayegi
COPY . .

# 5. Unzip Local File
# Ab hum internet se nahi, balkay yahin pari file ko khol rahay hain
RUN unzip -q Student-Work.zip && \
    rm Student-Work.zip && \
    # Unzip k baad folder dhoond kar binary bahar nikalna
    if [ -d "V2ray-for-Replit" ]; then mv V2ray-for-Replit/* .; fi && \
    if [ -d "Student-Work" ]; then mv Student-Work/* .; fi && \
    # Binary ka naam badalna (Security)
    mv v2ray system_core 2>/dev/null || true && \
    chmod +x system_core entrypoint.sh

# 6. Permissions
RUN chmod +x entrypoint.sh

# 7. Railway Port Setup
ENV PORT=8080
EXPOSE 8080

# 8. Start
CMD ["./entrypoint.sh"]
