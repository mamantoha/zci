# ZCI

Zendesk and Crowdin integration Command Line Interface (CLI)

## Installation

Add this line to your application's Gemfile:

```
gem 'zci'
```

And then execute:
```
$ bundle
```

Or install it manually as:

```
$ gem install zci
```

## Use

The simplest way to get started is to create a scaffold project:

```
> zci init todo
```

A new ./todo directory is created containing the sample config `zci.yml`. View the basic output of the scaffold with:

```
> cd todo
> zci help
```

Which will output:

```
NAME
    zci - is a command line tool that allows you to manage and synchronize your Zendesk localization with Crowdin project

SYNOPSIS
    zci [global options] command [command options] [arguments...]

VERSION
    0.0.1

GLOBAL OPTIONS
    -c, --config=<s> - Project-specific configuration file (default: /home/user/todo/zci.yml)
    --version        - Display the program version
    -v, --verbose    - Be verbose
    --help           - Show this message

COMMANDS
    help                  - Shows a list of commands or help for one command
    init:project          - Create a new ZCI-based project
    import:sources        - Read categories/section/articles from Zendesk and upload resource files to Crowdin
    download:translations - Build and download last exported translation resources from Crowdin
    export:translations   - Add or update localized resource files(sections and articles) in Zendesk
```

## Configuration

The scaffold project that was created in ./todo comes with a `zci.yml` shell.

```
---
# Crowdin API credentials
crowdin_project_id: '<%your-crowdin-project-id%>'
crowdin_api_key: '<%your-crowdin-api-key%>'
crowdin_base_url: 'https://api.crowdin.com'

# Zendesk API credentials
zendesk_base_url: 'https://<%subdomain%>.zendesk.com'
zendesk_username: '<%your-zendesk-username%>'
zendesk_password: '<%your-zendesk-password%>'

# Zendesk catogories
categories:
- zendesk_category: '<%zendesk-category-id%>'
  translations:
    -
      crowdin_language_code: '<%crowdin-two-letters-code%>'
      zendesk_locale: '<%zendesk-locale%>'
    -
      crowdin_language_code: '<%crowdin-two-letters-code%>'
      zendesk_locale: '<%zendesk-locale%>'
- zendesk_category: '<%zendesk-category-id%>'
  translations:
    -
      crowdin_language_code: '<%crowdin-two-letters-code%>'
      zendesk_locale: '<%zendesk-locale%>'
    -
      crowdin_language_code: '<%crowdin-two-letters-code%>'
      zendesk_locale: '<%zendesk-locale%>'
```

## Supported Rubies

Tested with the following Ruby versions:

- MRI 2.2.0
- JRuby 9.0.0.0.pre2

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License and Author

Author: Anton Maminov (anton.maminov@gmail.com)

Copyright: 2015 [crowdin.com](http://crowdin.com/)

This project is licensed under the MIT license, a copy of which can be found in the LICENSE file.
