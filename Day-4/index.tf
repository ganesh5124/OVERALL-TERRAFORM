provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "dev-server" {
  # (resource arguments)
  instance_type = "t3.micro"
  ami           = "ami-0e1d06225679bc1c5"

  key_name = "dev"
  tags = {
    Name = "import1"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("/Users/pepakayalaveeraganeshkumar/AWS/JenkinsKeys111.pem")
    host        = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "sudo yum update –y",
      "sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo",

      "sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key",

      "sudo yum upgrade",
      "sudo dnf install java-17-amazon-corretto -y",
      "sudo yum install jenkins -y",
      "sudo systemctl enable jenkins",
      "sudo systemctl start jenkins"

    ]
  }
  provisioner "file" {
    source = "app.py"
    destination = "/tmp/app.py"
  }

  provisioner "local-exec" {
    command = "echo 'hey hi' > dummy.txt"
  }
}
