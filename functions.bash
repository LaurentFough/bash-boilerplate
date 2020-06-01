#!/usr/bin/env bash
#   __                  _   _
#  / _|_   _ _ __   ___| |_(_) ___  _ __  ___
# | |_| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
# |  _| |_| | | | | (__| |_| | (_) | | | \__ \
# |_|  \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
#
# Shell function examples and boilerplate.
#
# The functions here are intended to be included in the interactive shell,
# which is done by defining them in a shell init file like `~/.bashrc`.
#
# Bash Boilerplate: https://github.com/xwmx/bash-boilerplate
#
# Copyright (c) 2016 William Melody • hi@williammelody.com

###############################################################################
# Simple shell function with help / usage.
#
# This function provides an example of a simple shell function with help /
# usage information that is displayed with either the `-h` or `--help` flag.
###############################################################################

hello() {
  if [ "${1}" = "-h" ] || [ "${1}" = "--help" ]
  then
    cat <<HEREDOC
Usage:
  hello
  hello -h | --help

Options:
  -h --help  Display this usage information.

Description:
  Say 'hello'.
HEREDOC
    return 0
  fi

  printf "Hello.\\n"
}

###############################################################################
# Simple shell function with help / usage and option flags.
#
# This function provides an example of a simple shell function with help /
# usage information that is displayed with either the `-h` or `--help` flag.
# This example also demonstrates how to include an option flag to provide
# optional behavior. Only one option can be used at a time and it is expected
# to be in the first position.
###############################################################################

hi() {
  if [ "${1}" = "-h" ] || [ "${1}" = "--help" ]
  then
    cat <<HEREDOC
Usage:
  hi
  hi --all
  hi -h | --help

Options:
  --all      Say 'hi' to everyone.
  -h --help  Display this usage information.

Description:
  Say 'hi'.
HEREDOC
  elif [ "${1}" = "--all" ]
  then
    printf "Hi, everyone!\\n"
  else
    printf "Hi!\\n"
  fi
}

###############################################################################
# Shell function with help / usage and option flags and option parsing.
#
# This function provides an example of a simple shell function with help /
# usage information that is displayed with either the `-h` or `--help` flag.
# This example also shows how to do basic option parsing in a function.
###############################################################################

hey() {
  local _all=0
  local _arguments=()
  local _help=0

  for __arg in "${@:-}"
  do
    case "${__arg}" in
      --all)
        _all=1
        ;;
      -h|--help)
        _help=1
        ;;
      *)
        _arguments+=("${__arg}")
        ;;
    esac
  done

  if ((_help))
  then
    cat <<HEREDOC
Usage:
  hey
  hey --all
  hey -h | --help

Options:
  --all      Say 'hey' to everyone.
  -h --help  Display this usage information.

Description:
  Say 'hey'.
HEREDOC
  elif ((_all))
  then
    printf "Hey, everyone!\\n"
  else
    printf "Hey!\\n"
  fi
}

###############################################################################
# Shell function with parsing for options with values.
#
# This function provides an example of a simple shell function with help /
# usage information that is displayed with either the `-h` or `--help` flag.
# This example also shows how to do option parsing with values in a function.
###############################################################################

sup() {
  # Usage: __get_option_value <option> <value>
  __get_option_value() {
    local __arg="${1:-}"
    local __val="${2:-}"

    if [[ -n "${__val:-}" ]] && [[ ! "${__val:-}" =~ ^- ]]
    then
      printf "%s\\n" "${__val}"
    else
      _exit_1 printf "%s requires a valid argument.\\n" "${__arg}"
    fi
  }

  local _all=0
  local _arguments=()
  local _help=0
  local _to=

  while ((${#}))
  do
    local __arg="${1:-}"
    local __val="${2:-}"

    case "${__arg}" in
      -a|--all)
        _all=1
        ;;
      -h|--help)
        _help=1
        ;;
      -t|--to)
        _to="$(__get_option_value "${__arg}" "${__val:-}")"
        shift
        ;;
      *)
        _arguments+=("${__arg}")
        ;;
    esac

    shift
  done

  if ((_help))
  then
    cat <<HEREDOC
Usage:
  sup
  sup --all
  sup -h | --help
  sup (-t | --to) <name>

Options:
  --all                   Say 'sup' to everyone.
  -h --help               Display this usage information.
  -t <name> --to <name>   Say 'sup' to <name>.

Description:
  Say 'sup'.
HEREDOC
  elif ((_all))
  then
    printf "Sup, everyone!\\n"
  elif [[ -n "${_to:-}" ]]
  then
    printf "Sup, %s!\\n" "${_to:-}"
  else
    printf "Sup!\\n"
  fi
}

###############################################################################
# Simple wrapper with help / usage and option flags.
#
# This wrapper function provides an example of a simple wrapper for an
# existing command, adding help / usage information that is displayed with
# either the `-h` or `--help` flag. This example also demonstrates how to
# include an option flag to provide optional behavior. Only one option can be
# used at a time and it is expected to be in the first position.
#
# Wrapper functions are useful for adding functionality and options to an
# existing command, or even simply adding usage information to a command that
# doesn't otherwise provide it.
###############################################################################

# Save the existing `yes` exectuable path to a variable so it can be used
# after the name `yes` is redefined.
_YES_COMMAND="$(which yes)"
yes() {
  if [ "${1}" = "-h" ] || [ "${1}" = "--help" ]
  then
    cat <<HEREDOC
Usage:
  yes [<expletive>]
  yes --quiet
  yes -h | --help

Options:
  --quiet    Suppress output.
  -h --help  Display this usage information.

Description:
  A wrapper for \`yes\`, which outputs <expletive> or, by default, 'y' forever.
  For more information, run \`man yes\`.
HEREDOC
  elif [ "${1}" = "--quiet" ]
  then
    "${_YES_COMMAND}" "${@}" 1> /dev/null
  else
    "${_YES_COMMAND}" "${@}"
  fi
}

###############################################################################
# Anonymous Function / Immediately-invoked function expression (IIFE)
#
# A simple anonymous throway function pattern that leverages common conventions
# from JavaScript and other languages. An underscore (`_`) function name
# indicates an anonymous function, which is then immediately invoked after
# the definition.
#
# Anonymous functions can be useful for shell initialization functions that are
# intended to be executed only once.
#
# Source (credit to https://stackoverflow.com/users/10559/jwfearn):
#   https://stackoverflow.com/a/24538676
#
# More Information:
#   https://en.wikipedia.org/wiki/Immediately-invoked_function_expression
###############################################################################

_() {
  printf "Hello World.\\n"
} && _ "$@"
unset -f _
