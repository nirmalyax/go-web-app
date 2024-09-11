# First stage: Build the Go application using the official Golang image
FROM golang:1.22.5 as base

# Set the working directory inside the container
WORKDIR /app

# Copy the go.mod file and download dependencies
COPY go.mod .

# Download Go module dependencies
RUN go mod download

# Copy the entire project into the container
COPY . .

# Build the Go application and output the binary as 'main'
RUN go build -o main .

# Second stage: Create a minimal image using distroless to run the application
FROM gcr.io/distroless/base

# Copy the built binary from the first stage
COPY --from=base /app/main .

# Copy the static files from the first stage
COPY --from=base /app/static/ ./static/

# Expose port 8080 for the application
EXPOSE 8080

# Command to run the application
CMD [ "./main" ]



