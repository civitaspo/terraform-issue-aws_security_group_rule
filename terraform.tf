provider "aws" {
    access_key = "${var.aws_access_key_id}"
    secret_key = "${var.aws_secret_access_key}"
    region = "us-east-1"
}

resource "aws_security_group" "aws_security_group_a" {
    name        = "aws_security_group_a"

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        security_groups = ["${aws_security_group.aws_security_group_c.id}"]
    }
}

resource "aws_security_group" "aws_security_group_b" {
    name        = "aws_security_group_b"

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        security_groups = ["${aws_security_group.aws_security_group_c.id}"]
    }
}

resource "aws_security_group" "aws_security_group_c" {
    name        = "aws_security_group_c"
}

resource "aws_security_group_rule" "aws_security_group_a2aws_security_group_b" {
    security_group_id = "${aws_security_group.aws_security_group_a.id}"
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    source_security_group_id = "${aws_security_group.aws_security_group_b.id}"
}

resource "aws_security_group_rule" "aws_security_group_b2aws_security_group_a" {
    security_group_id = "${aws_security_group.aws_security_group_b.id}"
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    source_security_group_id = "${aws_security_group.aws_security_group_a.id}"
}
