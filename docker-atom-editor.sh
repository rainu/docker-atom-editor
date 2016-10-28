#!/bin/bash

####
# Variables
####

DOCKER_IMAGE="rainu/atom-editor"

CUR_USER_ID=$(id -u)
CUR_USER_GID=$(id -g)

HOST_PROFILE="$HOME/.docker/$DOCKER_IMAGE"
HOST_SSH="$HOME/.ssh/"
HOST_MNT="/host"

INTERNAL_HOME="/home/atom"

ATOM_ARGS=""
DOCKER_ARGS=""

DOCKER_NAME="atom-editor-$CUR_USER_ID"
read -r -d '' DOCKER_RUN_PARAMS <<EOF
--rm
--env HOST_USER_UID=$(id -u) 
--env HOST_USER_GID=$(id -g)
--env LANG=$LANG 
--env LANGUAGE=$LANGUAGE 
--env DISPLAY=$DISPLAY
--env HOST_USER_UID=$CUR_USER_ID
--env HOST_USER_GID=$CUR_USER_GID
--volume /tmp/.X11-unix:/tmp/.X11-unix 
--volume $HOST_PROFILE:$INTERNAL_HOME/.atom
--volume /usr/share/icons:/usr/share/icons:ro
--volume /:$HOST_MNT
--workdir $HOST_MNT$PWD
--privileged
EOF

####
# Functions
####

execute() {
	SCRIPT=$(mktemp)

	echo $@ > $SCRIPT
	chmod +x $SCRIPT

	$SCRIPT
	RC=$?
	rm $SCRIPT

	return $RC
}

showHelp() {
echo 'Starts the Atom-Editor docker container.

docker-atom-editor.sh [OPTIONS...] [ATOM-PARAMS...]

Options:
	-h, -help
		Shows this help text
	-D, --docker
		Additional argument to docker command
'
	exit 0
}

readArguments() {
	while [[ $# > 0 ]]; do
		key="$1"

		case $key in
		    -D|--docker)
		    DOCKER_ARGS=$DOCKER_ARGS" $2"
		    shift
		    ;;
		    -h|--help)
		    showHelp
		    ;;
		    *)
			if [[ $key == "/"* ]]; then
				ATOM_ARGS=$ATOM_ARGS" $HOST_MNT$key"
			else
				ATOM_ARGS=$ATOM_ARGS" $key"
			fi
		    ;;
		esac
		shift # past argument or value
	done
}

####
# Main
####

readArguments "$@"

echo $ATOM_ARGS

mkdir -p $HOST_PROFILE
execute docker run $DOCKER_RUN_PARAMS $DOCKER_ARGS $DOCKER_IMAGE $ATOM_ARGS

exit $?