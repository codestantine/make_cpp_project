
#!/bin/bash

# Function to display usage instructions
usage() {
    echo "Usage: $0 <project_name> [absolute_project_directory]"
    exit 1
}

# Check if a project name is provided
if [ -z "$1" ]; then
    usage
fi

PROJECT_NAME=$1

# If project directory is provided, use it; otherwise, use the current directory
if [ -n "$2" ]; then
    # Check if the provided project directory is an absolute path
    if [[ $2 != /* ]]; then
        echo "Error: Project directory must be an absolute path."
        usage
    fi
    PROJECT_DIR=$2/$PROJECT_NAME
else
    PROJECT_DIR=$(pwd)/$PROJECT_NAME
fi

# Create project directory
mkdir -p $PROJECT_DIR
cd $PROJECT_DIR

# Create CMakeLists.txt
cat <<EOF > CMakeLists.txt
cmake_minimum_required(VERSION 3.10)
project($PROJECT_NAME)

set(CMAKE_CXX_STANDARD 17)
add_executable(main main.cpp)
EOF

# Create main.cpp
cat <<EOF > main.cpp
#include <iostream>

int main() {
    // Print Hello, World! message
    std::cout << "Hello, World!" << std::endl;

    // For loop to print numbers from 1 to 10
    for (int i = 1; i <= 10; ++i) {
        std::cout << "Number: " << i << std::endl;
    }

    return 0;
}
EOF

# Generate build files with CMake
mkdir -p build
cd build
cmake ..

# Generate compile_commands.json with correct include paths
cat <<EOF > compile_commands.json
[
  {
    "directory": "$PROJECT_DIR",
    "command": "/usr/bin/clang++ -I/usr/include/c++/11 -I/usr/include/x86_64-linux-gnu/c++/11 -I/usr/include/c++/11/backward -I/usr/lib/gcc/x86_64-linux-gnu/11/include -I/usr/local/include -I/usr/include/x86_64-linux-gnu -I/usr/include -o main main.cpp",
    "file": "main.cpp"
  }
]
EOF

# Print success message
echo "Project $PROJECT_NAME setup completed in directory $PROJECT_DIR."
echo "You can now open main.cpp in Vim and start coding!"
