#!/usr/bin/env python3
"""
Download arXiv source tar files from S3 (requester pays).
Downloads one tar file per month from 2020-2025 for testing.
Each tar file is ~500MB and contains ~500 papers.
"""

import boto3
import os
from pathlib import Path

# Target directory for downloads
OUTPUT_DIR = Path("/raid/duan/arxiv_samples")
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

# Files to download: one per year from January (first chunk)
# Format: arXiv_src_YYMM_NNN.tar
FILES_TO_DOWNLOAD = [
    f"src/arXiv_src_{year:02d}{month:02d}_001.tar"
    for year in range(20, 26)
    for month in range(1, 13)
]

BUCKET = "arxiv"

def download_file(s3_client, key, output_path):
    """Download a file from S3 with requester pays."""
    print(f"Downloading {key}...")
    file_size = s3_client.head_object(
        Bucket=BUCKET, 
        Key=key, 
        RequestPayer='requester'
    )['ContentLength']
    print(f"  Size: {file_size / (1024*1024):.1f} MB")
    
    s3_client.download_file(
        BUCKET, 
        key, 
        str(output_path),
        ExtraArgs={'RequestPayer': 'requester'}
    )
    print(f"  Saved to: {output_path}")

def main():
    s3 = boto3.client('s3', region_name='us-east-1')
    
    for key in FILES_TO_DOWNLOAD:
        filename = os.path.basename(key)
        output_path = OUTPUT_DIR / filename
        
        # Check if file already exists and is complete
        if output_path.exists():
            try:
                remote_size = s3.head_object(
                    Bucket=BUCKET, 
                    Key=key, 
                    RequestPayer='requester'
                )['ContentLength']
                local_size = output_path.stat().st_size
                if local_size == remote_size:
                    print(f"Skipping {filename} (already exists, {local_size / (1024*1024):.1f} MB)")
                    continue
                else:
                    print(f"Re-downloading {filename} (incomplete: {local_size} vs {remote_size} bytes)")
            except Exception as e:
                print(f"Could not verify {filename}, will re-download: {e}")
        
        try:
            download_file(s3, key, output_path)
        except Exception as e:
            print(f"Error downloading {key}: {e}")
    
    print("\nDone! Files saved to:", OUTPUT_DIR)
    print("Total files:", len(list(OUTPUT_DIR.glob("*.tar"))))

if __name__ == "__main__":
    main()
