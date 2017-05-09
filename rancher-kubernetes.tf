variable "my_ips" {
  type        = "list"
  default     = ["94.18.224.14/32", "83.94.47.160/32"]
  description = "List of host"
}

provider "aws" {}

resource "aws_security_group" "rancher_server" {
  name        = "Rancher server"
  description = "Allow all inbound traffic"
  vpc_id = "vpc-5b2f223f"
}

resource "aws_security_group_rule" "allow8080" {
  type            = "ingress"
  from_port       = 8080
  to_port         = 8080
  protocol        = "tcp"
  cidr_blocks = ["${var.my_ips}"]

  security_group_id = "${aws_security_group.rancher_server.id}"
}

resource "aws_security_group_rule" "allow22" {
  type            = "ingress"
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  cidr_blocks = ["${var.my_ips}"]

  security_group_id = "${aws_security_group.rancher_server.id}"
}

resource "aws_security_group_rule" "allowTCPInternally" {
  type            = "ingress"
  from_port       = 0
  to_port         = 65535
  protocol        = "tcp"
  source_security_group_id = "${aws_security_group.rancher_server.id}"
  //cidr_blocks = ["${aws_instance.rancher-master.public_ip}/32"]

  security_group_id = "${aws_security_group.rancher_server.id}"
}

resource "aws_security_group_rule" "allowUDPInternally" {
  type            = "ingress"
  from_port       = 0
  to_port         = 65535
  protocol        = "udp"
  source_security_group_id = "${aws_security_group.rancher_server.id}"
  //cidr_blocks = ["${aws_instance.rancher-master.public_ip}/32"]

  security_group_id = "${aws_security_group.rancher_server.id}"
}

resource "aws_security_group_rule" "allowAllEgress" {
  type            = "egress"
  from_port       = 0
  to_port         = 0
  protocol        = "-1"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.rancher_server.id}"
}



resource "aws_instance" "rancher-master" {
  ami           = "ami-405f7226"
  instance_type = "t2.micro"
  key_name = "terraform"
  subnet_id = "subnet-a91700cd"
  vpc_security_group_ids = ["${aws_security_group.rancher_server.id}"]
  tags {
    Type = "RancherMaster"
  }
}

resource "aws_instance" "rancher-etcd1" {
  ami           = "ami-405f7226"
  instance_type = "t2.micro"
  key_name = "terraform"
  subnet_id = "subnet-a91700cd"
  vpc_security_group_ids = ["${aws_security_group.rancher_server.id}"]
  tags {
    Type = "KubernetesEtcd"
  }
}

//resource "aws_instance" "rancher-etcd2" {
//  ami           = "ami-405f7226"
//  instance_type = "t2.micro"
//  key_name = "terraform"
//  subnet_id = "subnet-a91700cd"
//  vpc_security_group_ids = ["${aws_security_group.rancher_server.id}"]
//  tags {
//    Type = "KubernetesEtcd"
//  }
//}
//
//resource "aws_instance" "rancher-etcd3" {
//  ami           = "ami-405f7226"
//  instance_type = "t2.micro"
//  key_name = "terraform"
//  subnet_id = "subnet-a91700cd"
//  vpc_security_group_ids = ["${aws_security_group.rancher_server.id}"]
//  tags {
//    Type = "KubernetesEtcd"
//  }
//}

resource "aws_instance" "rancher-kube-master1" {
  ami           = "ami-405f7226"
  instance_type = "t2.micro"
  key_name = "terraform"
  subnet_id = "subnet-a91700cd"
  vpc_security_group_ids = ["${aws_security_group.rancher_server.id}"]
  tags {
    Type = "KubernetesMaster"
  }
}

//resource "aws_instance" "rancher-kube-master2" {
//  ami           = "ami-405f7226"
//  instance_type = "t2.micro"
//  key_name = "terraform"
//  subnet_id = "subnet-a91700cd"
//  vpc_security_group_ids = ["${aws_security_group.rancher_server.id}"]
//  tags {
//    Type = "KubernetesMaster"
//  }
//}

resource "aws_instance" "rancher-kube-compute1" {
  ami           = "ami-405f7226"
  instance_type = "t2.micro"
  key_name = "terraform"
  subnet_id = "subnet-a91700cd"
  vpc_security_group_ids = ["${aws_security_group.rancher_server.id}"]
  tags {
    Type = "KubernetesCompute"
  }
}

