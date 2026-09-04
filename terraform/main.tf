terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

# tentukan lokasi server 
provider "aws" {
    region = "ap-southeast-1"
}

# pesan server ke 1 untuk dijadikan master node kubernetes
resource "aws_instance" "k8s_master" {
    ami           = "ami-0df7a207adb9748c7" #kode ubuntu LTS 22.04
    instance_type = "t2.medium" # spesifikasi CPU & RAM minimal

    tags = {
        Name        = "Yokode-K8s-Master"
        Environment = "Production"
        ManagedBy   = "Terraform"
    }
}

# pesan server ke 2 untuk dijadikan worker node (tempat aplikasinya berjalan)
resource "aws_instance" "k8s_worker" {
    ami           = "ami-0df7a207adb9748c7" #kode ubuntu LTS 22.04
    instance_type = "t2.medium" # spesifikasi CPU & RAM minimal

    tags = {
        Name        = "Yokode-K8s-Worker-1"
        Environment = "Production"
        ManagedBy   = "Terraform"
    }        
}