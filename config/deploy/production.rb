# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.


set :stage, :production
set :branch, "master"


#used in case we're deplyong multiple versions of the same 
#app side by side. Also provides quick sanity checks when looking
#at filepaths

set :full_app_name, "#{fetch(:application)}_#{fetch(:stage)}"
set :server_name, "abacuskenya.cloudapp.net"

#dont try and infer something as imporatnt as environment
#from stage name
set :rails_env, :production

#whether we're using ssl or not, used for building nginx
#config file
set :enable_ssl, false

role :app, %w{deploy@example.com}
role :web, %w{deploy@example.com}
role :db,  %w{deploy@example.com}


# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

server 'abacuskenya.cloudapp.net', user: 'deploy', roles: %w{web app db}, primary: :true


# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult[net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start).
#
# Global options
# --------------
#  set :ssh_options, {
#    keys: %w(/home/#{ENV['USERPROFILE']}/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
#
# And/or per server (overrides global)
# ------------------------------------
# server 'abacuskenya.cloudapp.net',
#   user: 'abacuskenya',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'deploy', # overrides user setting above
#     keys: %w(/home/deploy/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey)
#     # password: 'please use keys'
#   }
