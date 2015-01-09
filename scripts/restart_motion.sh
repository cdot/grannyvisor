#!/bin/sh
case "$(pidof motion | wc -w)" in

0)  echo "Restarting motion:     $(date)" >> $HOME/logs/motion.log
    motion -c $HOME/.config/motion &
    ;;
1)  # all ok
    ;;
*)  echo "Removed double motion: $(date)" >> $HOME/logs/motion.log
    kill $(pidof motion | awk '{print $1}')
    ;;
esac


