worker_processes 4
working_directory "/home/cliff/l_bkup/svn/co/hobo_tunnel/phased_layer_tunnel"
listen 8080, :tcp_nopush => true
timeout 30
#stderr_path "/path/to/app/shared/log/unicorn.stderr.log"
#stdout_path "/path/to/app/shared/log/unicorn.stdout.log"
# combine Ruby 2.0.0dev or REE with "preload_app true" for memory savings
# http://rubyenterpriseedition.com/faq.html#adapt_apps_for_cow
preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true

