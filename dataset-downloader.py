from huggingface_hub import snapshot_download
import os, sys
import argparse


def download_and_save_dataset(dataset_name, api_key, save_path):
    # Set Hugging Face API key
    os.environ["HF_HOME"] = api_key

    # Load the dataset


def main(output_dir, dataset_name, dataset_revision=None):
    os.makedirs(output_dir, exist_ok=True)

    snapshot_download(
        repo_id=dataset_name,
        repo_type="dataset",
        local_dir=output_dir,
        revision=dataset_revision,
    )

    print(f"Dataset '{dataset_name}' downloaded and saved to '{output_dir}'.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--output_dir",
        default="output",
        help="Name of output directory that stores the dataset",
    )
    parser.add_argument(
        "--dataset_name",
        type=str,
        help="Name of the Hugging Face dataset",
    )
    parser.add_argument(
        "--dataset_revision",
        type=str,
        default=None,
        help="Revision of the dataset (optional)",
    )

    args = parser.parse_args()
    if "HF_HOME" not in os.environ or not os.environ:
        print(
            "Please set your Hugging Face API key in the HF_HOME environment variable."
        )
        sys.exit(1)
    main(
        output_dir=args.output_dir,
        dataset_name=args.dataset_name,
        dataset_revision=args.dataset_revision,
    )
