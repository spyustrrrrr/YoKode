terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# 1. Tentukan lokasi server (Misal: AWS Region Singapura)
provider "aws" {
  region = "ap-southeast-1" 
}

# 2. Pesan Server ke-1 untuk dijadikan "Master Node" Kubernetes
resource "aws_instance" "k8s_master" {
  ami           = "ami-0df7a207adb9748c7" # Kode OS Ubuntu 22.04 LTS
  instance_type = "t2.medium"             # Spesifikasi CPU & RAM minimal

  tags = {
    Name        = "Yokode-K8s-Master"
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}

# 3. Pesan Server ke-2 untuk dijadikan "Worker Node" (Tempat aplikasi Yokode berjalan)
resource "aws_instance" "k8s_worker" {
  ami           = "ami-0df7a207adb9748c7"
  instance_type = "t2.medium"

  tags = {
    Name        = "Yokode-K8s-Worker-1"
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}
