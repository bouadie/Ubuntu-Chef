name "base"
description "this is the base config that all systems use"
run_list(
    "recipe[route53]",
    "recipe[monit]"
)
