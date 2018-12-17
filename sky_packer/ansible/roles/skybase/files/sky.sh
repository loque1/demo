if [ "$TERM" == "" ]; then
    export PS1="\u@\h: "
else
    env=$(/etc/ansible/facts.d/aws.fact | jq -r  '[.datacentre.subnet, .datacentre.vpc] | "\(.[0])@\(.[1])"' | tr [:lower:] [:upper:])
    case ${env} in 
      GLOBAL*|BASTION*|PRD*) c=1;;
      UAT*) c=3;;
      *) c=2;;
    esac

    export PS1="\[$(tput bold)\]\[$(tput setaf $c)\][$env] \[$(tput setaf 7)\]\u@\h \[$(tput setaf 4)\]\W \\$ \[$(tput sgr0)\]"
fi
