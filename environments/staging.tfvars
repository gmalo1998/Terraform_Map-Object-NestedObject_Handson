environment= "staging"

# nested object
instances = {
staging-instance-1 = {
    instance_type="t3.micro"
    volume_size= 10
    volume_type= "gp3"
    monitoring = {
    enable=true
    level= "detailed"
    }
}
staging-instance-2 = {
    volume_type= "gp3"
    monitoring = {
    enable=false
    level= "basic"
    }
}
}