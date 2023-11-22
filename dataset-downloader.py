from huggingface_hub import snapshot_download
import os, sys
import argparse


def main(output_dir, name, hf_type, revision=None):
    os.makedirs(output_dir, exist_ok=True)

    snapshot_download(
        token=os.environ["HF_HOME"],
        repo_id=name,
        repo_type=hf_type,
        local_dir=output_dir,
        revision=revision,
        local_dir_use_symlinks=False,
    )

    print(f"{hf_type} named '{name}' downloaded and saved to '{output_dir}'.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--output_dir",
        default="output",
        help="Name of output directory that stores the output",
    )
    parser.add_argument(
        "--name",
        type=str,
        help="Name of the Hugging Face dataset/model",
    )
    parser.add_argument(
        "--revision",
        type=str,
        default=None,
        help="Revision of the dataset/model (optional)",
    )
    parser.add_argument(
        "--type",
        type=str,
        default="dataset",
        help="Type of download (dataset or model)",
    )

    args = parser.parse_args()
    if "HF_HOME" not in os.environ or not os.environ:
        print(
            "Please set your Hugging Face API key in the HF_HOME environment variable."
        )
        sys.exit(1)
    main(
        output_dir=args.output_dir,
        name=args.name,
        hf_type=args.type,
        revision=args.revision
    )
