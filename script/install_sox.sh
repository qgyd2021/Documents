#!/usr/bin/env bash
#
# https://sourceforge.net/projects/sox/files/sox/

# 参数:
system_version="windows";

# parse options
while true; do
  [ -z "${1:-}" ] && break;  # break if there are no arguments
  case "$1" in
    --*) name=$(echo "$1" | sed s/^--// | sed s/-/_/g);
      eval '[ -z "${'"$name"'+xxx}" ]' && echo "$0: invalid option $1" 1>&2 && exit 1;
      old_value="(eval echo \\$$name)";
      if [ "${old_value}" == "true" ] || [ "${old_value}" == "false" ]; then
        was_bool=true;
      else
        was_bool=false;
      fi

      # Set the variable to the right value-- the escaped quotes make it work if
      # the option had spaces, like --cmd "queue.pl -sync y"
      eval "${name}=\"$2\"";

      # Check that Boolean-valued arguments are really Boolean.
      if $was_bool && [[ "$2" != "true" && "$2" != "false" ]]; then
        echo "$0: expected \"true\" or \"false\": $1 $2" 1>&2
        exit 1;
      fi
      shift 2;
      ;;

    *) break;
  esac
done

echo "system_version: ${system_version}";

if [ ${system_version} = "windows" ]; then
  echo "system_version: ${system_version}";
  wget -P C:/Program20%Files https://altushost-swe.dl.sourceforge.net/project/sox/sox/14.4.1/sox-14.4.1a-win32.zip
  cd C:/Program20%Files || exit 1;
  unzip -d sox-14.4.1a-win32 sox-14.4.1a-win32.zip
  rm sox-14.4.1a-win32.zip

fi

