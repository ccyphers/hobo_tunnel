#!/bin/sh

export HOME=/phased_layer_tunnel
export GEM_HOME=$HOME/gems
export PATH=/opt/ruby193/bin:$GEM_HOME/bin:$PATH
cd $HOME
ruby bin/purge_authorized_keys.rb &
