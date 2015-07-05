class reposado::apache_vhost (
  $user          = $::reposado::params::user,
  $group         = $::reposado::params::group,
  $document_root = "${::reposado::params::base_dir}/html",
  $server_name   = $::reposado::params::server_name) inherits ::reposado::params 
{
  include ::apache
  include ::apache::mod::rewrite

  $apple_catalogs = ['10.10', '10.11']

  notice("apple_catalogs: ${apple_catalogs}")

  $rewrite_rules = rewrite_rules($apple_catalogs)

  notice("rewrite_rules: ${rewrite_rules}")

  notify {
    'apple_catalogs':
      message => $apple_catalogs;

    'rewrite_rules':
      message => $rewrite_rules
  }

  ::apache::vhost { $server_name:
    port          => '80',
    docroot       => $document_root,
    docroot_owner => $user,
    docroot_group => $group,
    directories   => [{
        path           => $document_root,
        options        => ['Indexes', 'FollowSymLinks'],
        allow_override => ['None'],
        require        => 'all granted'
      }
      ],
    #    rewrites      => $rewrite_rules,
    servername    => $server_name;
  }
}