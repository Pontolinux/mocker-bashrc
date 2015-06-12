mocker_usage() {
  echo "Usage: mocker COMMAND [arg...]"
  echo ""
  echo "Commands:"
  echo "    attach      Attach to a running container (Docker alias)"
  echo "    build       Build an image from a Dockerfile (Docker alias)"
  echo "    commit      Create a new image from a container's changes (Docker alias)"
  echo "    cp          Copy files/folders from a container's filesystem to the host path (Docker alias)"
  echo "    create      Create a new container (Docker alias)"
  echo "    destroy     Force remove all containers and local related files"
  echo "    diff        Inspect changes on a container's filesystem (Docker alias)"
  echo "    events      Get real time events from the server (Docker alias)"
  echo "    exec        Run a command in a running container (Docker alias)"
  echo "    export      Stream the contents of a container as a tar archive (Docker alias)"
  echo "    help        Show this help"
  echo "    --help"
  echo "    -h"
  echo "    history     Show the history of an image (Docker alias)"
  echo "    images      List images (Docker alias)"
  echo "    import      Create a new filesystem image from the contents of a tarball (Docker alias)"
  echo "    info        Display system-wide information (Docker alias)"
  echo "    inspect     Return low-level information on a container or image (Docker alias)"
  echo "    kill        Kill a running container (Docker alias)"
  echo "    load        Load an image from a tar archive (Docker alias)"
  echo "    login       Register or log in to a Docker registry server (Docker alias)"
  echo "    logout      Log out from a Docker registry server (Docker alias)"
  echo "    logs        Fetch the logs of a container (Docker alias)"
  echo "    port        Lookup the public-facing port that is NAT-ed to PRIVATE_PORT (Docker alias)"
  echo "    pause       Pause all processes within a container (Docker alias)"
  echo "    ps          List containers (Docker alias)"
  echo "    pull        Pull an image or a repository from a Docker registry server (Docker alias)"
  echo "    push        Push an image or a repository to a Docker registry server (Docker alias)"
  echo "    rename      Rename an existing container (Docker alias)"
  echo "    restart     Restart a running container (Docker alias)"
  echo "    rm          Remove one or more containers"
  echo "    rmi         Remove one or more images (Docker alias)"
  echo "    run         Run a command in a new container"
  echo "    save        Save an image to a tar archive (Docker alias)"
  echo "    search      Search for an image on the Docker Hub (Docker alias)"
  echo "    start       Start a stopped container (Docker alias)"
  echo "    stats       Display a live stream of one or more containers' resource usage statistics (Docker alias)"
  echo "    stop        Stop a running container (Docker alias)"
  echo "    tag         Tag an image into a repository (Docker alias)"
  echo "    top         Lookup the running processes of a container (Docker alias)"
  echo "    unpause     Unpause a paused container (Docker alias)"
  echo "    update      Update Mocker to the latest version"
  echo "    version     Show the Mocker version information"
  echo "    --version"
  echo "    -v"
  echo "    wait        Block until a container stops, then print its exit code (Docker alias)"
}

mocker_run_usage() {
  echo 'Usage: mocker run [--name=""] [IMAGE[:TAG]]'
  echo ''
  echo 'Run a new container'
  echo ''
  echo '  --name=""     Assign a name to the container. If omitted, it will be a random name.'
  echo '  IMAGE[:TAG]   Docker image. If omitted, it will be mocker/mocker:latest.'
}

mocker_rm_usage() {
  echo 'Usage: mocker rm [--force=false] CONTAINER [CONTAINER...]'
  echo ''
  echo 'Remove one or more containers'
  echo ''
  echo '  -f, --force=false   Force the removal of a running container (uses SIGKILL)'
}

mocker_update_usage() {
  echo 'Usage: mocker update'
  echo ''
  echo 'Update the command line and the Docker image of Mocker.'
}

mocker_version_usage() {
  echo 'Usage: mocker version | --version | -v'
  echo ''
  echo 'Show the Mocker version information'
}

mocker_destroy_usage() {
  echo 'Usage: mocker destroy'
  echo ''
  echo 'Force remove all containers and local related files'
}

mocker_mage_usage() {
  echo 'Usage: mocker mage COMMAND SUBCOMMAND arg...'
  echo ''
  echo 'Execute n98-magerun commands in the running container'
  echo 'See: http://magerun.net/'
  echo ''
  echo 'Commands:'
  echo '    cache           Manage the object cache.'
  echo '    cap             Manage user capabilities.'
  echo '    cli             Get information about WP-CLI itself.'
  echo '    comment         Manage comments.'
  echo '    core            Download, install, update and otherwise manage WordPress proper.'
  echo '    cron            Manage WP-Cron events and schedules.'
  echo '    db              Perform basic database operations.'
  echo '    eval            Execute arbitrary PHP code after loading WordPress.'
  echo '    eval-file       Load and execute a PHP file after loading WordPress.'
  echo '    export          Export content to a WXR file.'
  echo '    help            Get help on a certain command.'
  echo '    import          Import content from a WXR file.'
  echo '    media           Manage attachments.'
  echo '    menu            List, create, assign, and delete menus'
  echo '    network         -'
  echo '    option          Manage options.'
  echo '    plugin          Manage plugins.'
  echo '    post            Manage posts.'
  echo '    rewrite         Manage rewrite rules.'
  echo '    role            Manage user roles.'
  echo '    scaffold        Generate code for post types, taxonomies, etc.'
  echo '    search-replace  Search/replace strings in the database.'
  echo '    shell           Interactive PHP console.'
  echo '    sidebar         Manage sidebars.'
  echo '    site            Perform site-wide operations.'
  echo '    super-admin     List, add, and remove super admins from a network.'
  echo '    term            Manage terms.'
  echo '    theme           Manage themes.'
  echo '    transient       Manage transients.'
  echo '    user            Manage users.'
  echo '    widget          Manage sidebar widgets.'
}

mocker() {

  local version='0.0.1'
  local red=31
  local image='mocker/mocker:latest'
  local cname
  local ports
  local cid
  local cids
  local dirname
  local containers
  local force
  local running
  local confirmation

  case "$1" in

    #
    # $ mocker run
    #
    'run' )

      if [[ "$2" = '--help' ]]; then
        mocker_run_usage
      else

        if [[ "$2" = '--name' ]]; then
          cname="$3"
          image=${4:-$image}
        elif [[ "$2" =~ ^--name=(.*)$ ]]; then
          cname="${BASH_REMATCH[1]}"
          image=${3:-$image}
        else
          cname=""
          image=${2:-$image}
        fi

        if [[ $(docker ps -q) ]]; then
          ports=$(docker inspect --format='{{.NetworkSettings.Ports}}' $(docker ps -q))
        fi

        if [[ $ports =~ "HostIp:0.0.0.0 HostPort:80" ]]; then
          echo -e "\033[${red}mCannot start container $cname: Bind for 0.0.0.0:80 failed: port is already allocated\033[m"

        # Use existing Magento files to run a container
        elif [[ $cname && -d ~/data/${cname} ]]; then
          docker run -d --name $cname -p 80:80 -p 3306:3306 -v ~/data/${cname}:/var/www/magento:rw $image

        # Or copy Magento files from the image to run a container
        else

          if [[ $cname ]]; then
            docker run -d --name $cname $image
          else
            docker run -d $image
          fi

          cid=$(docker inspect --format='{{.Id}}' $(docker ps -l -q)) && \
          cid=${cid:0:12} && \
          dirname=$(docker inspect --format='{{.Name}}' $(docker ps -l -q)) && \
          dirname=${dirname#*/} && \
          cname=$dirname
          docker cp $(docker ps -l -q):/var/www/magento ~/data/${cid} && \
          mv ~/data/${cid}/magento ~/data/${dirname} && \
          rm -rf ~/data/${cid} && \
          docker rm -f $(docker ps -l -q) && \
          docker run -d --name $cname -p 80:80 -p 3306:3306 -v ~/data/${dirname}:/var/www/magento:rw $image
        fi

      fi
      ;;

    #
    # $ mocker rm
    #
    'rm' )

      if [[ "$2" = '--help' ]]; then
        mocker_rm_usage
      else

        case "$2" in
          '-f' | '--force' | '--force=true' )
            force=true
            containers=${@:3}
            ;;
          * )
            force=false
            containers=${@:2}
            ;;
        esac

        cids=$(docker inspect --format='{{.Id}}' $containers)

        for cid in $cids; do
          running=$(docker inspect --format='{{.State.Running}}' $cid)
          dirname=$(docker inspect --format='{{.Name}}' $cid)
          dirname=${dirname#*/}

          docker rm --force=${force} $cid
          if [[ $force = true || $running = false ]]; then
            rm -rf ~/data/${dirname}
          fi
        done

      fi
      ;;

    #
    # $ mocker update
    #
    'update' )

      if [[ "$2" = '--help' ]]; then
        mocker_update_usage
      else
        curl -O https://raw.githubusercontent.com/pontolinux/mocker-bashrc/master/bashrc && mv -f bashrc ~/.bashrc && source ~/.bashrc
        docker pull mocker/mocker:latest
      fi
      ;;

    #
    # $ mocker destroy
    #
    'destroy' )

      if [[ "$2" = '--help' ]]; then
        mocker_destroy_usage
      else

        if [[ $(docker ps -a -q) ]]; then

          echo 'Are you sure you want to remove all containers and related files? [y/N]'
          read confirmation

          case $confirmation in
            'y' )
              for cid in $(docker ps -a -q); do
                dirname=$(docker inspect --format='{{.Name}}' $cid)
                dirname=${dirname#*/}
                rm -rf ~/data/${dirname}
              done
              docker rm -f $(docker ps -a -q)
              ;;
            * )
              echo 'Containers and file will not be removed, since the confirmation was declined.'
              ;;
          esac

        else
          echo 'Nothing to destroy.'
        fi

      fi
      ;;

    #
    # $ mocker --help | $ mocker -h
    #
    'help' | '--help' | '-h' )
      mocker_usage
      ;;

    #
    # $ mocker version | $ mocker --version | $ mocker -v
    #
    'version' | '--version' | '-v' )
      if [[ "$2" = '--help' ]]; then
        mocker_version_usage
      else
        echo "Version: $version"
      fi
      ;;

    #
    # $ mocker wp
    #
    'wp' )

      if [[ "$2" = '--help' ]]; then
        mocker_wp_usage
      else
        if [[ $(docker ps -q) ]]; then
          cid=$(docker ps -q)
          if [[ ! $cid =~ $'\n' ]]; then
            docker exec $cid wp --allow-root ${@:2}
          fi
        fi
      fi
    ;;

    #
    # Other Docker commands
    #
    'attach' | 'build' | 'commit' | 'cp' | 'create' | 'diff' | 'events' | 'exec' | 'export' | 'history' | 'images' | 'import' | 'info' | 'inspect' | 'kill' | 'load' | 'login' | 'logout' | 'logs' | 'port' | 'pause' | 'ps' | 'pull' | 'push' | 'rename' | 'restart' | 'rmi' | 'save' | 'search' | 'start' | 'stop' | 'tag' | 'top' | 'unpause' | 'wait' )
      docker $@
      ;;

    #
    # Show Mocker usage
    #
    * )
      mocker_usage
      ;;

  esac
}
