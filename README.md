terraform-issue-aws_security_group_rule
=======================================

# What's the issue

This is a complicated case, so I explain this by using a examle.

Example Case:

- `security_group a`, `security_group b`, `security_group c` exist.
- `security_group a` has `security_group c` as egress.
- `security_group b` has `security_group c` as egress.
- `security_group a` want to have `security_group b` as egress.
- `security_group b` want to have `security_group a` as egress.

In this case, I define a refering security group cycle by using `aws_security_group_rule`.
However, `aws_security_group_rule` defined above is *redefined* again and again in subsequent executions.
This *redefine* means the security group is deleted first, then re-applied in next time, and then in the next time this is deleted again.
Since the security group is deleted once, I cannot apply the tf to production now.
Could you help with this issue?


# How to reproduce the issue

You need to prepare access_key_id & secret_access_key before, then...

```
$ ./prepare.sh
$ ./terraform apply
$ ./terraform apply
```

# Environment

terraform version: 0.9.8

# Log

```
[terraform-issue-aws_security_group_rule] for n in {0..2};do ./terraform apply;echo "*****************************************";done
aws_security_group.aws_security_group_c: Refreshing state... (ID: sg-4a778e3b)
aws_security_group.aws_security_group_a: Refreshing state... (ID: sg-7a778e0b)
aws_security_group.aws_security_group_b: Refreshing state... (ID: sg-ff758c8e)
aws_security_group_rule.aws_security_group_a2aws_security_group_b: Refreshing state... (ID: sgrule-4096370764)
aws_security_group_rule.aws_security_group_b2aws_security_group_a: Refreshing state... (ID: sgrule-1321502299)
aws_security_group_rule.aws_security_group_a2aws_security_group_b: Creating...
  from_port:                "" => "0"
  protocol:                 "" => "-1"
  security_group_id:        "" => "sg-7a778e0b"
  self:                     "" => "false"
  source_security_group_id: "" => "sg-ff758c8e"
  to_port:                  "" => "0"
  type:                     "" => "egress"
aws_security_group_rule.aws_security_group_b2aws_security_group_a: Creating...
  from_port:                "" => "0"
  protocol:                 "" => "-1"
  security_group_id:        "" => "sg-ff758c8e"
  self:                     "" => "false"
  source_security_group_id: "" => "sg-7a778e0b"
  to_port:                  "" => "0"
  type:                     "" => "egress"
aws_security_group_rule.aws_security_group_b2aws_security_group_a: Creation complete (ID: sgrule-1321502299)
aws_security_group_rule.aws_security_group_a2aws_security_group_b: Creation complete (ID: sgrule-4096370764)

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

The state of your infrastructure has been saved to the path
below. This state is required to modify and destroy your
infrastructure, so keep it safe. To inspect the complete state
use the `terraform show` command.

State path:
*****************************************
aws_security_group.aws_security_group_c: Refreshing state... (ID: sg-4a778e3b)
aws_security_group.aws_security_group_b: Refreshing state... (ID: sg-ff758c8e)
aws_security_group.aws_security_group_a: Refreshing state... (ID: sg-7a778e0b)
aws_security_group_rule.aws_security_group_b2aws_security_group_a: Refreshing state... (ID: sgrule-1321502299)
aws_security_group_rule.aws_security_group_a2aws_security_group_b: Refreshing state... (ID: sgrule-4096370764)
aws_security_group.aws_security_group_b: Modifying... (ID: sg-ff758c8e)
  egress.#:                                     "2" => "1"
  egress.1200810321.cidr_blocks.#:              "0" => "0"
  egress.1200810321.from_port:                  "0" => "0"
  egress.1200810321.ipv6_cidr_blocks.#:         "0" => "0"
  egress.1200810321.prefix_list_ids.#:          "0" => "0"
  egress.1200810321.protocol:                   "-1" => "-1"
  egress.1200810321.security_groups.#:          "1" => "1"
  egress.1200810321.security_groups.1185811063: "sg-4a778e3b" => "sg-4a778e3b"
  egress.1200810321.self:                       "false" => "false"
  egress.1200810321.to_port:                    "0" => "0"
  egress.2086235085.cidr_blocks.#:              "0" => "0"
  egress.2086235085.from_port:                  "0" => "0"
  egress.2086235085.ipv6_cidr_blocks.#:         "0" => "0"
  egress.2086235085.prefix_list_ids.#:          "0" => "0"
  egress.2086235085.protocol:                   "-1" => ""
  egress.2086235085.security_groups.#:          "1" => "0"
  egress.2086235085.security_groups.3809238615: "sg-7a778e0b" => ""
  egress.2086235085.self:                       "false" => "false"
  egress.2086235085.to_port:                    "0" => "0"
aws_security_group.aws_security_group_a: Modifying... (ID: sg-7a778e0b)
  egress.#:                                     "2" => "1"
  egress.1200810321.cidr_blocks.#:              "0" => "0"
  egress.1200810321.from_port:                  "0" => "0"
  egress.1200810321.ipv6_cidr_blocks.#:         "0" => "0"
  egress.1200810321.prefix_list_ids.#:          "0" => "0"
  egress.1200810321.protocol:                   "-1" => "-1"
  egress.1200810321.security_groups.#:          "1" => "1"
  egress.1200810321.security_groups.1185811063: "sg-4a778e3b" => "sg-4a778e3b"
  egress.1200810321.self:                       "false" => "false"
  egress.1200810321.to_port:                    "0" => "0"
  egress.977538633.cidr_blocks.#:               "0" => "0"
  egress.977538633.from_port:                   "0" => "0"
  egress.977538633.ipv6_cidr_blocks.#:          "0" => "0"
  egress.977538633.prefix_list_ids.#:           "0" => "0"
  egress.977538633.protocol:                    "-1" => ""
  egress.977538633.security_groups.#:           "1" => "0"
  egress.977538633.security_groups.2547491832:  "sg-ff758c8e" => ""
  egress.977538633.self:                        "false" => "false"
  egress.977538633.to_port:                     "0" => "0"
aws_security_group.aws_security_group_b: Modifications complete (ID: sg-ff758c8e)
aws_security_group.aws_security_group_a: Modifications complete (ID: sg-7a778e0b)

Apply complete! Resources: 0 added, 2 changed, 0 destroyed.

The state of your infrastructure has been saved to the path
below. This state is required to modify and destroy your
infrastructure, so keep it safe. To inspect the complete state
use the `terraform show` command.

State path:
*****************************************
aws_security_group.aws_security_group_c: Refreshing state... (ID: sg-4a778e3b)
aws_security_group.aws_security_group_b: Refreshing state... (ID: sg-ff758c8e)
aws_security_group.aws_security_group_a: Refreshing state... (ID: sg-7a778e0b)
aws_security_group_rule.aws_security_group_b2aws_security_group_a: Refreshing state... (ID: sgrule-1321502299)
aws_security_group_rule.aws_security_group_a2aws_security_group_b: Refreshing state... (ID: sgrule-4096370764)
aws_security_group_rule.aws_security_group_b2aws_security_group_a: Creating...
  from_port:                "" => "0"
  protocol:                 "" => "-1"
  security_group_id:        "" => "sg-ff758c8e"
  self:                     "" => "false"
  source_security_group_id: "" => "sg-7a778e0b"
  to_port:                  "" => "0"
  type:                     "" => "egress"
aws_security_group_rule.aws_security_group_a2aws_security_group_b: Creating...
  from_port:                "" => "0"
  protocol:                 "" => "-1"
  security_group_id:        "" => "sg-7a778e0b"
  self:                     "" => "false"
  source_security_group_id: "" => "sg-ff758c8e"
  to_port:                  "" => "0"
  type:                     "" => "egress"
aws_security_group_rule.aws_security_group_b2aws_security_group_a: Creation complete (ID: sgrule-1321502299)
aws_security_group_rule.aws_security_group_a2aws_security_group_b: Creation complete (ID: sgrule-4096370764)

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

The state of your infrastructure has been saved to the path
below. This state is required to modify and destroy your
infrastructure, so keep it safe. To inspect the complete state
use the `terraform show` command.

State path:
*****************************************
```
