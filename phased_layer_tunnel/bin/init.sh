#!/bin/sh
_start_() {
  export HOME=/phased_layer_tunnel
  export GEM_HOME=$HOME/gems
  export PATH=/opt/ruby193/bin:$GEM_HOME/bin:$PATH
  cd $HOME
  sudo $HOME/bin/start_purge_agent.sh &
  echo $! >$HOME/start_purge_agent.pid
  bundle exec unicorn -c config/unicorn.rb config.ru &
  echo $! >$HOME/unicorn.pid
}

_stop_() {
  kill  `cat /jail/phasunnel/start_purge_agent.pid /jail/phased_layer_tunnel/unicorn.pid | awk '{printf $1 " "}'`
  rm -f /jail/phasunnel/start_purge_agent.pid /jail/phased_layer_tunnel/unicorn.pid
}


case "$1" in
  start)
    _start_
    ;;
  stop)
    _stop_
    ;;
  *)
    echo 'usaage'
esac
