FROM alpine:latest

# Install aws-cli and curl
RUN apk add --no-cache aws-cli curl

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Run the entrypoint
ENTRYPOINT ["/entrypoint.sh"]
