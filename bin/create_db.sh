# #!/bin/bash

# # Start the PostgreSQL container
# docker-compose up -d postgres

# # Wait for the PostgreSQL container to be up and running
# echo "Waiting for PostgreSQL container to be up..."
# until docker-compose exec postgres pg_isready; do
#   sleep 2
# done

# # Check if the database exists
# if ! docker-compose exec postgres psql -U user_dev -lqt | cut -d \| -f 1 | grep -qw webgate_pro_development; then
#   # Create the PostgreSQL database
#   # docker-compose exec postgres psql -U user_dev -d postgres -c "CREATE DATABASE webgate_pro_development;"
#   echo "Database 'webgate_pro_development' created successfully!"
# else
#   echo "Database 'webgate_pro_development' already exists."
# fi
