# Use the official Ruby image as the base image
FROM ruby:3.2.2

# Set the working directory in the container
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  default-jre-headless

# Copy the Gemfile and Gemfile.lock to the container
COPY Gemfile* /app/

# Install gems
RUN gem install bundler && bundle install

# Copy the application code to the container
COPY . /app

# Expose the port on which the Rails server will run
EXPOSE 3000

# Set the default command to start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]
