export HTTP_PROXY="http://proxy.sky.local:3128"
export http_proxy="http://proxy.sky.local:3128"
export HTTPS_PROXY="http://proxy.sky.local:3128"
export https_proxy="http://proxy.sky.local:3128"
printf -v dev '%s,' 172.24.32.{2..20}
printf -v uat '%s,' 172.24.48.{2..20}
printf -v tst '%s,' 172.24.64.{2..20}
printf -v sit '%s,' 172.24.80.{2..20}
printf -v awsmeta '%s,' 169.254.169.254
caciaws_no_proxy="$dev$uat$tst$sit$awsmeta"
export no_proxy="::1,localhost,127.0.0.1,.sky.local,${caciaws_no_proxy%,},*.eu-west-2.amazonaws.com"
export NO_PROXY=${no_proxy}

