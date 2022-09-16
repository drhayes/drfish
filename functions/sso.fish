function sso --description "Enumerate profiles and log in to one of them via AWS SSO."
  set -gx AWS_PROFILE (sed -n "s/^\[\(profile \)\{0,1\}\(.*\)\]/\2/gp" ~/.aws/config | fzf)
  if test "$AWS_PROFILE" = "default"
    # If I selected default, set nothing.
    set -e AWS_PROFILE
    return 0
  end

  # Am I logged into SSO?
  set _whoami (aws sts get-caller-identity 2>/dev/null)
  if test $status -ne 0
    aws sso login
    set _whoami (aws sts get-caller-identity 2>/dev/null)
  end

  # Give some feedback to know it worked.
  echo "$_whoami" | jq --raw-output '.Arn'
end

