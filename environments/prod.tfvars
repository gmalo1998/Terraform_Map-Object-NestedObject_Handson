environment="prod"


#Map 
#each iteration will create a independent ec2 instance
# if you want it will add instance type, region then you have to create an object inside a map 
# inside each object you have to pass instance type, region 
instances = {
    web   = "t3.micro"
    db    = "t3.medium"
    cache = "t3.small"
    }
