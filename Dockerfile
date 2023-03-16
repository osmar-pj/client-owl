#  docker from nginx
FROM nginx:1.23.3-alpine

# Copy the build output to replace the default nginx contents
COPY ./dist /usr/share/nginx/html

# Expose port 80 and start nginx server
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]