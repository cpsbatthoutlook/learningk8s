
[Handling Encryption Keys with Cloud KMS https://learn.acloud.guru/handson/26caab9d-e2d4-428d-941e-74d184671a37]


## Enable KMS service
gcloud projects list
gcloud config set project ${GCP_PROJECT}
gcloud services list --available
gcloud services list --enabled
gcloud services enable cloudkms.googleapis.com


KMSRING=my-ring
KEY=key1
##In the Cloud Shell, create the initial keyring.
  gcloud kms keyrings create ${KMSRING} --location us
  gcloud kms keyrings list 
	#NAME: projects/playground-s-11-f565df09/locations/us/keyRings/my-ring
##Create a key for the new keyring.
  gcloud kms keys create ${KEY} --location us --keyring ${KMSRING} --purpose encryption
##List the existing keys within the CLI.
   gcloud kms keys list --location us --keyring ${KMSRING}
	#NAME: projects/playground-s-11-f565df09/locations/us/keyRings/my-ring/cryptoKeys/key1
## Verify Security > Key Management  .. and find ${KEY}


Retrieve the Example File
Clone the GitHub repository: git clone https://github.com/linuxacademy/content-gcpro-security-engineer
Change directory to the content-gcpro-security-engineer/kms-encrypt-lab folder: cd content-gcpro-security-engineer/kms-encrypt-lab
Open the Cloud Shell Editor by clicking the pencil icon.
Review the file top-secret-ufo-1950.txt.
##Encrypt and Decrypt the File
In the Cloud Shell, encrypt the top-secret-ufo-1950.txt file and set the name to top-secret-ufo-1950.txt.encrypted.
   gcloud kms encrypt --location us --keyring ${KMSRING} --key ${KEY} --plaintext-file top-secret-ufo-1950.txt --ciphertext-file top-secret-ufo-1950.txt.encrypted
Review the top-secret-ufo-1950.txt.encrypted file.
In the Cloud Shell, decrypt the encrypted file and set the name to top-secret-ufo-1950.txt.decrypted.
  gcloud kms decrypt --location us --keyring ${KMSRING} --key ${KEY} --ciphertext-file top-secret-ufo-1950.txt.encrypted --plaintext-file top-secret-ufo-1950.txt.decrypted
Review the top-secret-ufo-1950.txt.decrypted file.\




content-gcpro-security-engineer/kms-encrypt-lab/top-secret-ufo-1950.txt.decrypted
content-gcpro-security-engineer/kms-encrypt-lab/top-secret-ufo-1950.txt.encrypted
content-gcpro-security-engineer/kms-encrypt-lab/top-secret-ufo-1950.txt
