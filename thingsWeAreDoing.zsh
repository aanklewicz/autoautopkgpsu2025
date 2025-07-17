#!/bin/zsh

# Install XCode Developer tools (done ahead of time)

# Show hidden files ⌘⇧.

# Create AWS Bucket and store data

BUCKET_SECRET_REGION="us-east-2"
BUCKET_SECRET_NAME="autoautopkgpsu2025"
AWS_ACCESS_KEY_ID=""
AWS_SECRET_ACCESS_KEY=""

# Create IAM user
# Permissions -> Add Permissions -> Create Inline policy
# Select A Service S3
# List
#     ListBucket
# Read 
#     GetObject
#     GetObjectTagging
# Write
#     PutObject
#     DeleteObject

# Resources - Specific - Add ARN
#     Resource Bucket Name from above
#     Resource Object Name - Click any box

json_output_file="/Users/aanklewicz/Desktop/Demo files/AWS_JSON_file.json"

json_content=$(cat <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:PutObject",
                "s3:PutObjectAcl",
                "s3:GetObject",
                "s3:GetObjectAcl",
                "s3:GetObjectTagging",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::${BUCKET_SECRET_NAME}",
                "arn:aws:s3:::${BUCKET_SECRET_NAME}/*"
            ]
        }
    ]
}
EOF
)

# Use jq to format and save the JSON content to the file
# echo "$json_content" | jq '.' > "$json_output_file"

# UNCOMMENT AND RUN THIS

cd ~/Desktop/Demo\ files
AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
aws --region ${BUCKET_SECRET_REGION} \
s3 cp thingsWeAreDoing.zsh s3://${BUCKET_SECRET_NAME}/thingsWeAreDoingAlpha.zsh

# Create GitHub repo
# Download it to local computer

# Create folder structure by running setup.zsh

# Create personal access token
#     https://github.com/settings/tokens
#     Generate New Token
#     Generate New Token (Classic)
#     Give it a name in the note field
#     Give it an expiration date (7 days for demo purposes)
#     Give it full repo access
#     Generate token

RW_REPO_TOKEN=""

# Add repo secrets
# Your repo -> Settings -> Secrets and Variables -> Actions
# New repository secret
# Call it RW_REPO_TOKEN
# Paste in your Personal Access Token
#     Repeat above for AWS items

# AutoMunki
#     Download
#     Create Munki folder structure
#     Add a single item to munki # PUT IT IN APPS FOLDER!
#     Put contents of autopkg_src into the github repo
#     Walk through .github/workflows/autopkg_automerge.yml and .github/workflows/autopkg.yml
#         Make many changes
#         Configure Autopkg has a token that needs to be updated and you will miss otherwise

# Run autopkg for Firefox
# In MunkiAdmin add to catalogue and manifest

# Install autopkg
# Add repos
#     autopkg repo-add https://github.com/autopkg/aanklewicz-recipes
#     autopkg repo-add https://github.com/autopkg/recipes.git
# Create override for SF Icons & Renew
#     autopkg make-override SFIcons.munki
#     autopkg make-override Renew.munki

# Gusto's autopromote
#     copy autompromote to /
#     copy munki-promote.yml to .github/workflows





# Time to tidy up after doing this
# 1) remove github repo
# 2) Remove repo from local computer
# 3) Delete PAT
# 4) empty Bucket
# 5) Delete bucket
# 6) Delete IAM user key
# 7) Delete IAM user
# 8) Hide hidden files
# 9) Remove autopkg from computer
    # sudo launchctl unload /Library/LaunchDaemons/com.github.autopkg.autopkginstalld.plist
    # sudo launchctl unload /Library/LaunchDaemons/com.github.autopkg.autopkgserver.plist
    # sudo rm /Library/LaunchDaemons/com.github.autopkg.autopkg*
    # sudo rm -r /usr/local/autopkg
    # sudo rm /usr/local/bin/autopkg
    # sudo rm -r /Library/AutoPkg
    # sudo pkgutil --forget com.github.autopkg.autopkg
    # rm -r ~/Library/AutoPkg
# 10) Clear out variables above
# 11)