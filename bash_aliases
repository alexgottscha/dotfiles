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
