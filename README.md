## What is this?

This project contains simple terraform for setting up a project
that grants access to a user to call the vertex AI service
API.

The user has limited roles that exclude most google services
with the idea that this could be used by a group to create a 
singular project for the user to experiment with or use the 
Vertex AI platform from a command line (using `curl` for example)
of from a programming language like python. 

## Applying Terraform

Check out this repository and ensure that terraform is installed. 

Inside this repo, run:

```
terraform init
```

Then, run the following to see what terraform plans to do.

*Replace the email with the user email you like.*

```
terraform plan --var vertexai_user_email='sean.2.davis@cuanschutz.edu'
```

If you are satisfied, apply the terraform:

```
terraform plan --var vertexai_user_email='sean.2.davis@cuanschutz.edu'
```

## What does the end user do?

The person owning the email address needs to then go to the 
command line and perform the following:

```
gcloud auth login
```

This will open a web browser and the user will then need to authenticate
using the google auth workflow.

Once completed, the user should be able to go back to that same 
shell and edit the file `perform_chat.sh` to use the correct 
google project name (supplied by the person running the terraform).

After making that change to the script, this should work:

```
bash perform_chat.sh
```


