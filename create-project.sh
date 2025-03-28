#!/bin/bash

# If there less than 2 arguments, the script fails since '-p [directory]' is required
if [ "$#" -lt 2 ]; then
	echo "Option -p [directory] is required."
	exit 1
fi

# Parse the option arguments
while getopts :p: opt; do
	case ${opt} in
		# If '-p' option is found extract the directory path
		p)
			PROJECT_ROOT="${OPTARG}"
		;;

		# Unknown argument found (they are ignored)
		?)
		 	# If '-p' option is found without a value the script fails since [directory] is required
		 	if [ "${OPTARG}" == "p" ]; then
					echo "Option -${OPTARG} requires a [directory] path"
					exit 1
			fi
		;;
	esac
done

# If the found [directory] path is empty ("" or not set) the script fails
if [[ -z "$PROJECT_ROOT" ]]; then
	echo "Option -p requires a [directory] path"
	exit 1
fi

# If the found [directory] path exists the script fails
if [ -d "$PROJECT_ROOT" ]; then
	echo "Option -p requires a non existing path"
	exit 1
fi

# Create project directory
mkdir -p $PROJECT_ROOT
if [ $? -ne 0 ]; then { echo "Failed to create project root directory: $PROJECT_ROOT" ; exit 1; } fi

# Enter the newly created project root
cd $PROJECT_ROOT

# Install lua crush dependecy manager

## Cloen the crush lua repository
LUA_CRUSH_REPOSITORY="https://git.doublefourteen.io/lua/crush.git"
GIT_TERMINAL_PROMPT=0 git clone $LUA_CRUSH_REPOSITORY
if [ $? -ne 0 ]; then
	### Print error message
	echo "Failed to fetch lua crush dependecy manager: $LUA_CRUSH_REPOSITORY"
	### Perform clean up
	rm -rf ../$PROJECT_ROOT
	### Script fails
	exit 1
fi


## Copy the crush lua file into the project directory
cp crush/crush.lua .

## Remove the lua crush repository
rm -rf crush

# Create the directory structure
LIB_DIR="lib"
mkdir "$LIB_DIR"
mkdir "src"
touch "src/main.lua"
touch ".lovedeps"

# Set up love-api for EmmyLua
LOVE_API_REPOSITORY="https://github.com/love2d-community/love-api.git"
LOVE_API_DIR="love2d-api"
GIT_TERMINAL_PROMPT=0 git clone $LOVE_API_REPOSITORY $LOVE_API_DIR
if [ $? -ne 0 ]; then
	### Print error message
	echo "Failed to fetch love2d API: $LOVE_API_REPOSITORY"
	### Perform clean up
	rm -rf ../$PROJECT_ROOT
	### Script fails
	exit 1
fi

# Set up EmmyLua API generator
EMMY_LUA_API_REPOSITORY="https://github.com/kindfulkirby/Emmy-love-api.git"
EMMY_LUA_API_DIR="emmy-lua-api"
GIT_TERMINAL_PROMPT=0 git clone $EMMY_LUA_API_REPOSITORY $EMMY_LUA_API_DIR
if [ $? -ne 0 ]; then
	### Print error message
	echo "Failed to fetch Emmy Lua API: $EMMY_LUA_API_REPOSITORY"
	### Perform clean up
	rm -rf ../$PROJECT_ROOT
	### Script fails
	exit 1
fi

# The directory of the generated EmmyLua API
GENERATED_API_DIR="api"
# The lib directory for the generated EmmyLua API (this is the destination where the generated API will be stored)
LIB_API_DIR="love-api"
EMMY_LUA_GENERATOR="genEmmyAPI.lua"

# Generate EmmyLua API
## Copy lua generator script to the love-api cloned repository
cp "$EMMY_LUA_API_DIR/$EMMY_LUA_GENERATOR" $LOVE_API_DIR
## Etner the love2d API directory
cd $LOVE_API_DIR
## Create folder where the generated EmmyLua API will be stored
mkdir $GENERATED_API_DIR
## Generated EmmyLua API
lua $EMMY_LUA_GENERATOR
## Exit the directory
cd ..
## Copy the generated EmmyLua API to the lib directory
cp -r "$LOVE_API_DIR/$GENERATED_API_DIR/" "$LIB_DIR/$LIB_API_DIR"

# Perform cleanup
rm -rf $EMMY_LUA_API_DIR
rm -rf $LOVE_API_DIR
