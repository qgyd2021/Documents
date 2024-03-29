#!/usr/bin/expect
# 参考链接:
# https://gitee.com/help/articles/4181#article-header0
#
# 交互时输入回车, 参考链接:
# https://www.shuzhiduo.com/A/kvJ3rYQDzg/
# https://www.shuzhiduo.com/A/8Bz8KD1Ndx/
# https://blog.51cto.com/u_15366123/4660499


# params
verbose=true;
stage=0
stop_stage=0
comment=qgyd2021@gmail.com;


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


if [ ${stage} -le 0 ] && [ ${stop_stage} -ge 0 ]; then
  $verbose && echo "ssh-keygen";
  # echo -e '\n\n\n' | ssh-keygen -t rsa -C "qgyd2021@gmail.com" -N ""
  echo | ssh-keygen -t rsa -C "${comment}" -N ""

  cat ~/.ssh/id_rsa
  cat ~/.ssh/id_rsa.pub
fi
