
https://cloud.google.com/sql/docs/postgres/authentication

export REGION=us-central1
export DB_INSTANCE=myinstance
export DB_DB=mydb
##
gcloud services enable sqladmin.googleapis.com
gcloud sql instances create ${DB_INSTANCE} --database-version=POSTGRES_14 --cpu=2 --memory=7680MB --region=${REGION}  #--database-flags=cloudsql.iam_authentication=on
gcloud sql instances patch ${DB_INSTANCE} --database-flags=cloudsql.iam_authentication=on
	## gcloud sql instances patch INSTANCE_NAME --clear-database-flags ##CLEAR all flags https://cloud.google.com/sql/docs/postgres/flags#gcloud
	##  SELECT name, setting FROM pg_settings;  ## to check settings
	## 
gcloud sql instances list
##
gcloud sql databases create ${DB_DB} --instance=${DB_INSTANCE}
gcloud sql databases list
##Users
USER1=user1
PWD1=password1
#gcloud sql users set-password postgres --instance=${DB_INSTANCE} --prompt-for-password
gcloud sql users create ${USER1} --instance=${DB_INSTANCE} --password=${PWD1}

##Connect  https://www.cloudskillsboost.google/focuses/937?parent=catalog
gcloud sql connect myinstance --user=${USER1} 
### Create table
CREATE TABLE guestbook (guestName VARCHAR(255), content VARCHAR(255), entryID SERIAL PRIMARY KEY);
INSERT INTO guestbook (guestName, content) values ('first guest', 'I got here!');
INSERT INTO guestbook (guestName, content) values ('second guest', 'Me too!');
### 
SELECT * FROM guestbook;
###

##Connect using IAM  https://xebia.com/blog/how-to-connect-to-a-cloudsql-with-iam-authentication/
export CONNECTION=$(gcloud sql instances describe ${DB_INSTANCE} --format 'value(connectionName)')
cloud_sql_proxy --instances $CONNECTION=tcp:5432 --enable_iam_login  &

## ? How to create SQL IAM users
psql "sslmode=disable dbname=${DB_DB} host=127.0.0.1 user=markvanholsteijn@binx.io"
