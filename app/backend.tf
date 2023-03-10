# definisco il backend 
# utilizzo un path differente in modo da mantenere lo stato
# degli oggtti deployati.
# In questo caso, essendo un ambiente di test, il backend 
# è configurato su un path locale su disco. 
# In un ambiente di produzione, sarebbe stato un bucket S3 o simile
terraform {
  backend "local" {
    path = "../backend_local/app/terraform.tfstate"
  }
}
