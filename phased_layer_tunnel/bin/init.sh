#!/bin/sh

export HOME=/phased_layer_tunnel
export GEM_HOME=$HOME/gems
export PATH=/opt/ruby193/bin:$GEM_HOME/bin:$PATH
cd $HOME
sudo $HOME/bin/start_purge_agent.sh &
bundle exec unicorn -c config/unicorn.rb config.ru &

