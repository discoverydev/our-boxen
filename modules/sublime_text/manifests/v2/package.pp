# Public: Install a Sublime Text 2 package.
#
# namevar - The name of the package.
# source  - The location of the git repository containing the package.
#
# Examples
#
#   sublime_text::v2::package { 'Emmet':
#     source => 'sergeche/emmet-sublime'
#   }
define sublime_text::v2::package($source) {
  require sublime_text::v2::config

  repository { "${sublime_text::v2::config::packagedir}/${name}":
    source => $source
  }
}
