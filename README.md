Sunzi-Rails
===========

```
"The supreme art of war is to subdue the enemy without fighting." - Sunzi
```

Sunzi is the easiest [server provisioning](http://en.wikipedia.org/wiki/Provisioning#Server_provisioning) utility designed for mere mortals. If Chef or Puppet is driving you nuts, try Sunzi!

Sunzi assumes that modern Linux distributions have (mostly) sane defaults and great package managers.

Its design goals are:

* **It's just shell script.** No clunky Ruby DSL involved. Most of the information about server configuration on the web is written in shell commands. Just copy-paste them, rather than translate it into an arbitrary DSL. Also, Bash is the greatest common denominator on minimum Linux installs.
* **Focus on diff from default.** No big-bang overwriting. Append or replace the smallest possible piece of data in a config file. Loads of custom configurations make it difficult to understand what you are really doing.
* **Always use the root user.** Think twice before blindly assuming you need a regular user - it doesn't add any security benefit for server provisioning, it just adds extra verbosity for nothing. However, it doesn't mean that you shouldn't create regular users with Sunzi - feel free to write your own recipes.
* **Minimum dependencies.** No configuration server required. You don't even need a Ruby runtime on the remote server.

Quickstart
----------

Install:

```bash
$ [sudo] gem install sunzi-rails
```

Go into your Rails project directory, then:

```bash
$ sunzi-cap create
```

It generates a `config/sunzi` folder along with subdirectories and templates. Inside `sunzi`, there are `sunzi.yml` and `install.sh`. Those two are the most important files that you mainly work on.

Go into your `config/deploy.rb` and make sure to have these set: 

```ruby
set :ruby_version, IO.read("#{File.dirname(__FILE__)}/../.ruby-version").strip
set :admin_name, 'admin'
set :deployer_name, 'deployer'
```

Go into your `config/deploy/[stage].rb` and make sure to have these set:

```ruby
set :server, 'example.com'
server fetch(:server), user: fetch(:deployer_name), roles: %w[app web db]
```

Go into your `config/secrets.yml` and make sure to have these set:

```
[stage]:
  deployer_password: password
  deployer_public_key: "ssh-rsa ...== deployer@example.com"
```

Finally, add `/compiled` to your `.gitignore` file.

All those settings can be overriden in your `sunzi.yml` file within `attributes`.

Also, contextual attributes are available through `@attributes`:

```ruby
@attributes.env_stage
@attributes.env_role
@attributes.env_sudo
@attributes.env_user
@attributes.env_host
@attributes.env_port
```

Go into the project directory, then run `sunzi-cap deploy`:

```bash
$ sunzi-cap deploy staging admin --sudo
$ sunzi-cap deploy staging deployer
```

Now, what it actually does is:

1. Compile `sunzi.yml` to generate attributes and retrieve remote recipes, then copy files scoped to `admin` role into the `compiled` directory
1. SSH to `user@example.com` defined within your Cpistrano `config/deploy/staging.rb` file
1. Transfer the content of the `compiled` directory to the remote server and extract in `$HOME/sunzi`
1. Run `install.sh` on the remote server with sudo mode turned on
1. Idem for the `deployer` role, but with sudo mode turned off

As you can see, all you need to do is edit `install.sh` and add some shell commands. That's it.

A Sunzi project without any recipes or roles is totally fine, so that you can start small, go big as you get along.

Commands
--------

```bash
$ sunzi-cap                                  # Show command help
$ sunzi-cap create                           # Create a new Sunzi project
$ sunzi-cap compile [stage] [role] [--sudo]  # Compile Sunzi project
$ sunzi-cap deploy [stage] [role] [--sudo]   # Deploy Sunzi project
```

Directory structure
-------------------

Here's the directory structure that `sunzi-cap create` automatically generates:

```bash
compiled/         # everything under this folder will be transferred to the
                  # remote server (do not edit directly)
config/sunzi/
  install.sh      # main script
  sunzi.yml       # add custom attributes and remote recipes here

  recipes/        # put commonly used scripts here, referred from install.sh
    sunzi.sh
  roles/          # when role is specified, scripts here will be concatenated
    db.sh         # to install.sh in the compile phase
    web.sh
  files/          # put any files to be transferred
```

How do you pass dynamic values?
-------------------------------

There are two ways to pass dynamic values to the script - ruby and bash.

**For ruby**: In the compile phase, attributes defined in `sunzi.yml` are accessible from any files in the form of `<%= @attributes.ruby_version %>`.

**For bash**: In the compile phase, attributes defined in `sunzi.yml` are split into multiple files in `compiled/attributes`, one per attribute. Now you can refer to it by `$(cat attributes/ruby_version)` in the script.

For instance, given the following `install.sh`:

```bash
echo "Goodbye <%= @attributes.goodbye %>, Hello <%= @attributes.hello %>!"
```

With `sunzi.yml`:

```yaml
attributes:
  goodbye: Chef
  hello: Sunzi
```

Now, you get the following result.

```
Goodbye Chef, Hello Sunzi!
```

Remote Recipes
--------------

Recipes can be retrieved remotely via HTTP. Put a URL in the recipes section of `sunzi.yml`, and Sunzi will automatically load the content and put it into the `compiled/recipes` folder in the compile phase.

For instance, if you have the following line in `sunzi.yml`,

```yaml
recipes:
  rvm: https://raw.github.com/kenn/sunzi-recipes/master/ruby/rvm.sh
```

`rvm.sh` will be available and you can refer to that recipe by `source recipes/rvm.sh`.

You may find sample recipes in this repository useful: https://github.com/kenn/sunzi-recipes

Role-based configuration
------------------------

You probably have different configurations between **web servers** and **database servers**.

No problem - how Sunzi handles role-based configuration is refreshingly simple.

Shell scripts under the `roles` directory, such as `web.sh` or `db.sh`, are automatically recognized as a role. The role script will be appended to `install.sh` at deploy, so you should put common configurations in `install.sh` and role specific procedures in the role script.

For instance, when you set up a new web server, deploy with a role name:

```bash
sunzi-cap deploy production web
```

It is equivalent to running `install.sh`, followed by `web.sh`.

Vagrant
-------

If you're using Sunzi with [Vagrant](http://vagrantup.com/), make sure that you have a root access via SSH.

An easy way is to edit `Vagrantfile`:

```ruby
Vagrant.configure("2") do |config|
  config.vm.provision "shell",
    inline: "sudo echo 'root:vagrant' | /usr/sbin/chpasswd"
  end
end
```

and now run `vagrant up`, it will change the root password to `vagrant`.

Also keep in mind that you need to specify the port number 2222 within `config/deploy/vagrant.rb`.

```bash
$ sunzi-cap deploy vagrant deployer
```

Demonstration Videos
-------

You can watch video on how to deploy a Rails 4.1 app with Sunzi and Capistrano 3 at http://youtu.be/3mwupXqtkmg
