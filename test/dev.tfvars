project_name         = "hfn-project"
vpc_id               = "vpc-01a64c15484c80c1d"
subnet_ids           = ["subnet-0c9e5f18b2997881a", "subnet-0e4f6bc1a5c809076", "subnet-04363fb37383c97c9"]
allocated_storage    = 20
storage_type         = "gp2"
engine_version       = "8.0.28"
instance_class       = "db.t3.micro"
db_username          = "hfncarerds"
db_name = "carerds"
skip_final_snapshot  = true
backup_retention_period = 7
multi_az             = false

