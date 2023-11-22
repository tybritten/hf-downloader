////
// Template arguments:
//
// dataset_name : HuggingFace dataset name
// name         : name of the pipeline
// secretName   : Secret name with a Read-only HuggingFace API token with a key of HF_HOME
// revision     : revision of the dataset to use (optional)
// 
local args(hf_name, revision, type) = 
    local localargs = ["--name", hf_name, "--type", type, "--output_dir", "/pfs/out"];
    if revision != "" then localargs +["--revision", revision] else localargs;

function(name, hf_name, secretName, revision="", type="dataset", disable_progress="false")
{
  pipeline: { name: name },
  description: "Download HF Dataset: "+name,
  transform: {
    cmd: [ "python3", "/app/dataset-downloader.py" ] + args(hf_name, revision, type),
    image: "vmtyler/hfdownloader:v0.0.5",
    secrets: [
        {
          name: secretName,
          env_var: 'HF_HOME',
          key: 'HF_HOME',
        },
      ],
    "env": {
        "PYTHONUNBUFFERED": "1",
        "HF_HUB_DISABLE_PROGRESS_BARS": disable_progress,
    },
    },
    autoscaling: "true",
    input: {
      cron: {
        name: 'cron',
        spec: "@never",
        overwrite: true,
      },
    },
}
