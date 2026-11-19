variable "environment" {
  type = string
}
# MAP example
# variable "instances" {
#   type = map(string)
# }

# MAP multi objects 

# variable "instances" {
#   type = map(object({
#     instance_type = string
#     volume_size= number
#     volume_type= string 
#   }))
#   default = {
#   default-instance = {
#     instance_type = "t3.micro"
#     volume_size= 9
#     volume_type="gp3"
#   }
# }
# }

# MAP with nested object
variable "instances" {
  type = map(object({
    instance_type = optional(string,"t2.medium")
    volume_size= optional(number, 10)
    volume_type = string
    monitoring = object({
      enable = bool
      level = string 
    })
  }))
  default = {
    staging = {
     volume_type = "gp3"
     monitoring = {
       enable = false
       level = "basic"
     }    
    }
    prod = {
     instance_type = "t3.large"
     volume_size = 15
     volume_type = "gp3"
     monitoring = {
       enable = false
       level = "basic"
     }    
    }
  }
  }

variable "ec2_key" {
  type    = string
  default = "ec2-putty-key-pair"
}