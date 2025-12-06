environment       = "production"
vpc_cidrblock     = "192.168.0.0/16"
countsub          = 2
create_subnet     = true
create_elastic_ip = true
desired_size      = 2
max_size          = 6
min_size          = 2
instance_types    = ["t3.medium"]
capacity_type     = "ON_DEMAND"
ami_type          = "AL2_x86_64"
label_one         = "system-nodepool"
eks_version       = "1.32"
cluster_name      = "eks-cluster"
repository_name   = "eks-repository"
email             = "uche2net@gmail.com"

# 🔥 Add this
db_username = "mybankuser"
db_password = "MyStrongPassword2025!"
db_name     = "online_banking_system"
