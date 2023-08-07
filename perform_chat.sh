#!/bin/bash
MODEL_ID="chat-bison"
# replace project id here
PROJECT_ID="notebook-project-keyh"


curl \
-X POST \
-H "Authorization: Bearer $(gcloud auth print-access-token)" \
-H "Content-Type: application/json" \
https://us-central1-aiplatform.googleapis.com/v1/projects/${PROJECT_ID}/locations/us-central1/publishers/google/models/${MODEL_ID}:predict -d \
'{
  "instances": [{
      "context":  "My name is Ned. You are my personal assistant. My favorite movies are Lord of the Rings and Hobbit.",
      "examples": [ {
          "input": {"content": "Who do you work for?"},
          "output": {"content": "I work for Ned."}
      },
      {
          "input": {"content": "What do I like?"},
          "output": {"content": "Ned likes watching movies."}
      }],
      "messages": [
      {
          "author": "user",
          "content": "Are my favorite movies based on a book series?",
      }],
  }],
  "parameters": {
    "temperature": 0.3,
    "maxOutputTokens": 200,
    "topP": 0.8,
    "topK": 40
  }
}'
