# Creating Google Cloud Functions

This manual will guide you through the process of creating a Google Cloud Function using Python. The Cloud Function will make use of a webhook to trigger an action on a GitHub repository.

1. Make sure you have a GitHub personal access token with the necessary permissions. The required permissions for the repository "flux-gitops" are:
   - Read access to metadata
   - Read and write access to code
   
2. Set up a Cloud Pub/Sub topic that will trigger the Cloud Function. You can get a topic named from `output.tf` "webhook-topic-6495" using the following command:
   ```bash
   $ terraform output
   google_pubsub_topic_name = "webhook-topic-6495"
   ```

3. Configure the runtime environment variables for the Cloud Function. You need to set the following variables with their respective values:
   - `github_token`: Your GitHub personal access token.
   - `github_user`: Your GitHub username.
   - `github_repo`: The name of the repository ("gke-flux-gitops" in this case).
   
4. Write the code for the Cloud Function. Use the provided code as a starting point, but make sure to update the event handling logic according to your requirements. The code demonstrates how to trigger a GitHub webhook when the event type is "SECRET_VERSION_ADD". You can modify this logic as needed.

5. Deploy the Cloud Function on Google Cloud. You can use the following command to deploy the function:
   ```bash
   gcloud functions deploy webhook-function \
   --runtime python3.9 \
   --trigger-topic projects/<your-project>/topics/webhook-topic-6495 \
   --set-env-vars github_token=<your-github-token>,github_user=<your-github-username>,github_repo=gke-flux-gitops
   ```

6. [Test a repository dispatch event](https://docs.github.com/en/rest/repos/repos?apiVersion=2022-11-28#create-a-repository-dispatch-event). Works with GitHub Apps
```bash
 curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $github_token"\
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/$github_user/$github_repo/dispatches \
  -d '{"event_type":"update-secret"}'
```

Ensure that you replace `<your-project>`, `<your-github-token>`, and `<your-github-username>` with the appropriate values.

After deployment, the Cloud Function will be triggered whenever a message is published to the specified Cloud Pub/Sub topic. Make sure to test and validate the function's behavior according to your requirements.
