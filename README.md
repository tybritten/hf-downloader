# Huggingface Dataset Downloader

Simple Pachyderm Pipeline template to download a huggingface dataset to a repo.

### Template arguments:
`name`- Pipeline name
`secretName`- Kubernetes secret with hugggingface token
`dataset_name`- Name of the hugggingface dataset to download
`revision`- (Optional) a specific revision of the dataset you want to download


### Example Usage:

1. Create a secret in your pachyderm kubernetes namespace with your huggingface token that's read-only:
   `kubectl create secret generic hugging-face-token --from-literal HF_HOME=<token>`
2. Create the pipeline using the template in this repo using `pachctl`:
    ```
     pachctl create pipeline \
     --jsonnet https://raw.githubusercontent.com/tybritten/hf-dataset-downloader/main/dataset-downloader.jsonnet \
     --arg name="hf-downloader-CodeAlpaca_20k" --arg dataset_name="HuggingFaceH4/CodeAlpaca_20K" --arg secretName=hugging-face-token
   ```
3. This creates a cron pipeline with a spec of never. So to run it you'll run:
   `pachctl cron run hf-downloader-CodeAlpaca_20k`
