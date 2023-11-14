////
// Template arguments:
//
// dataset_name : HuggingFace dataset name
// name         : name of the pipeline
// secretName   : Secret name with a Read-only HuggingFace API token with a key of HF_HOME
// revision     : revision of the dataset to use (optional)
// 
local args(dataset_name, revision) = 
    local localargs = ["--dataset_name", dataset_name,"--output_dir", "/pfs/out"];
    if revision != "" then localargs +["--dataset_revision", revision] else localargs;

function(name, dataset_name, secretName, revision="")
{
  pipeline: { name: name },
  description: "Download HF Dataset: "+dataset_name,
  transform: {
    cmd: [ "python3", "/app/dataset-downloader.py" ] + args(dataset_name, revision),
    image: "vmtyler/hfdownloader:v0.0.1",
    secrets: [
        {
          name: secretName,
          env_var: 'HF_HOME',
          key: 'HF_HOME',
        },
      ],
    },
    input: {
      cron: {
        name: 'cron',
        spec: "@never",
        overwrite: true,
      },
    },
}
