#https://www.cloudskillsboost.google/focuses/22792?parent=catalog


##Migrate to Cloud SQL for PostgreSQL using Database Migration Service

Database Migration Service provides options for one-time and continuous jobs to migrate data to Cloud SQL using different connectivity options, including IP allowlists, VPC peering, and reverse SSH tunnels (see documentation on connectivity options at https://cloud.google.com/database-migration/docs/postgresql/configure-connectivity.

In this lab, you migrate a stand-alone PostgreSQL database (running on a virtual machine) to Cloud SQL for PostgreSQL 
    using a continuous Database Migration Service job 
    VPC peering for connectivity.

### Prepare the source database for migration.
In Google Shell:
gcloud auth list ## You can list the active account name with this command:
gcloud config list project  ## Project iD 
Enable "Database Migration API"  ## Google console
Enable "Service Networking API"  ##  Service Networking API is required in order to be able to configure Cloud SQL to support VPC Peering and connections over a private ip-address.

#### Upgrade the DB with pglogical xtn
 ssh to postgresql-vm
 sudo apt -y install postgresql-13-pglogical  ## pglogical is a logical replication system implemented entirely as a PostgreSQL extension. Fully integrated, it requires no triggers or external programs. This alternative to physical replication is a highly efficient method of replicating data using a publish/subscribe model for selective replication. Read more here: https://github.com/2ndQuadrant/pglogical
 sudo su - postgres -c "gsutil cp gs://cloud-training/gsp918/pg_hba_append.conf ."

sudo su - postgres -c "gsutil cp gs://cloud-training/gsp918/postgresql_append.conf ."
sudo su - postgres -c "cat pg_hba_append.conf >> /etc/postgresql/13/main/pg_hba.conf"
sudo su - postgres -c "cat postgresql_append.conf >> /etc/postgresql/13/main/postgresql.conf"
sudo systemctl restart postgresql@13-main

echo "host    all all 0.0.0.0/0   md5" >> pg_hba.conf
Edit "listen_addresses = '*'         # what IP address(es) to listen on, '*' is all"  ## pglogical to listen on all ip address



--pending --








