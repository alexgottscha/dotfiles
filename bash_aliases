# https://github.com/Microsoft/WSL/issues/2715

alias units=gunits
alias sed=gsed
alias ls='ls -F --color'
alias less='bat --theme=Coldark-Dark -p'
alias ly='less -l yaml'
alias lj='less -l json'
alias cat='bat -P'
alias vi='nvim'
alias vim='nvim'
alias jqp='jq -C | less -R' # color pager
alias k=kubectl
complete -o default -F __start_kubectl k
alias kx=kubectx
complete -F _kube_contexts kx
alias kns=kubens
complete -F _kube_namespaces kns
alias t=terraform
alias watch='watch ' # appending space forces alias parsing
alias certbot='certbot --config-dir $HOME/certbot/etc --work-dir $HOME/certbot/run --logs-dir $HOME/certbot/log'
alias prom='k port-forward -n monitoring svc/prometheus-server 8888:80 & k port-forward -n monitoring svc/prometheus-alertmanager 8889:80 &'

function certinfo {
  echo  | openssl s_client -connect "$1:443" | openssl x509 -text -noout | less
}

function ecr-login {
  local region=$(aws configure get region)
  local account=$(aws sts get-caller-identity --query Account --output text)
  export REGISTRY=$account.dkr.ecr.$region.amazonaws.com
  echo "export REGISTRY='$REGISTRY'"
  aws ecr get-login-password --region $region \
  | docker login --password-stdin --username AWS $REGISTRY
}

function commit {
  # pattern grabs Jira ticket # in either path-style or beginning of line
  # (e.g. "foo/APP-123/bar" or "APP-456")
  local issue=$(git branch --show-current | sed -E 's#(^|.*/)([A-Z]+-[0-9]+).*#\2#')
  local message="$@"
  local changetype
  if [[ -z "$message" ]]; then echo "Usage: commit with a message as args" 1>&2; return 1; fi
  if [[ -z "$issue" ]]; then echo "ERROR: no issue found in branch name" 1>&2; return 2; fi
  select changetype in build chore ci docs feat fix perf refactor revert style; do break; done
  echo git commit -m \"$changetype: [$issue] $message\"
  git commit -m "$changetype: [$issue] $message"
}

function tdiff {
  set -euo pipefail
  local TEMP=$(mktemp -d) envfile=$1 target=$2

  echo "Generating a diff of '$target' in '$TEMP'"

  terraform plan -out=$TEMP/tfplan >/dev/null
  terraform show -json $TEMP/tfplan | \
    jq -r '.resource_changes[] | select(.address=="'"$1"'") | .change.before.values | add' > $TEMP/before.txt
  terraform show -json $TEMP/tfplan | \
    jq -r '.resource_changes[] | select(.address=="'"$1"'") | .change.after.values | add' > $TEMP/after.txt
  diff -u --color=always $TEMP/before.txt $TEMP/after.txt | sed -e '1,2d'
}
