FROM nginx

# Create a non-root user
RUN useradd -ms /bin/bash nginx

# Copy your application files
COPY . /usr/share/nginx/html

# Set ownership and permissions
RUN chown -R nginx:nginx /usr/share/nginx/html

# Switch to the nginx user
USER nginx

# Expose port 80
EXPOSE 80
