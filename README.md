# Huggingface Downloader

Simple Pachyderm Pipeline template to download a huggingface dataset or model to a repo.

### Template arguments:
* `name`- Pipeline name
* `secretName`- Kubernetes secret with hugggingface token
* `type`- The type of download `model` or `dataset`
* `hf_name`- Name of the hugggingface dataset or model to download
* `revision`- (Optional) a specific revision of the dataset you want to download
* `disable_progress`- (Optional) set to `true` to disable progress logging


### Example Usage:

1. Create a secret in your pachyderm kubernetes namespace with your huggingface token that's read-only:
   `kubectl create secret generic hugging-face-token --from-literal HF_HOME=<token>`
2. Create the pipeline using the template in this repo using `pachctl`:
    ```
     pachctl create pipeline \
     --jsonnet https://raw.githubusercontent.com/tybritten/hf-dataset-downloader/main/dataset-downloader.jsonnet \
     --arg name="hf-downloader-CodeAlpaca_20k" --arg hf_name="HuggingFaceH4/CodeAlpaca_20K" --arg secretName=hugging-face-token
   ```
3. This creates a cron pipeline with a spec of never. So to run it you'll run:
   ```
   pachctl cron run hf-downloader-CodeAlpaca_20k
   ```
