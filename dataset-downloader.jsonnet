////
// Template arguments:
//
// dataset_name     : HuggingFace dataset name
// name             : name of the pipeline
// secretName       : Secret name with a Read-only HuggingFace API token with a key of HF_HOME
// revision         : revision of the dataset to use (optional)
// disable_progress : (Optional) set to `true` to disable progress logging
//  allow_patterns  : (Optional) allow patterns for the download comma separated `"data/*,*.json"`
// ignore_patterns   : (Optional) ignore patterns for the download comma separated `"data/*,*.json"`

local join(a) =
    local notNull(i) = i != null;
    local maybeFlatten(acc, i) = if std.type(i) == "array" then acc + i else acc + [i];
    std.foldl(maybeFlatten, std.filter(notNull, a), []);


local args(hf_name, revision, type, allow_patterns, ignore_patterns) = 
    join([
    if revision != "" then ["--revision", revision],
    if allow_patterns != "" then ["--allow_patterns", allow_patterns],
    if ignore_patterns != "" then ["--ignore_patterns", ignore_patterns],
    ["--name", hf_name, "--type", type, "--output_dir", "/pfs/out"],
    ]);


function(name, hf_name, secretName, revision="", type="dataset", disable_progress="false", allow_patterns="", ignore_patterns="")
{
  pipeline: { name: name },
  description: "Download HF Dataset: "+name,
  transform: {
    cmd: [ "python3", "/app/dataset-downloader.py" ] + args(hf_name, revision, type, allow_patterns, ignore_patterns),
    image: "vmtyler/hfdownloader:v0.0.7",
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
    autoscaling: true,
    input: {
      cron: {
        name: 'cron',
        spec: "@never",
        overwrite: true,
      },
    },
}
