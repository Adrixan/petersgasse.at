#!/usr/bin/env bash
# ==============================================================================
# publish.sh - Automated Hugo Publishing Script for BRG Petersgasse
# ==============================================================================
# Workflow:
# 1) Execute Hugo to update public/ directory
# 2) Upload generated "public" directory to FTP subfolder "petersgasse.at"
# 3) Verify upload completeness and file size integrity
# 4) Delete any existing *.prev directories and rename "www.petersgasse.at" to "www.petersgasse.at.prev"
# 5) Rename uploaded "public" folder to "www.petersgasse.at"
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Load optional local .env configuration if present
if [[ -f .env ]]; then
  # shellcheck disable=SC1091
  source .env
fi

FTP_HOST="${FTP_HOST:-s1.weirer-it.at}"
FTP_USER="${FTP_USER:-pet001it}"
FTP_PASS="${FTP_PASS:-zbvxyuehpd}"
FTP_DIR="${FTP_DIR:-petersgasse.at}"
TARGET_DIR="${TARGET_DIR:-www.petersgasse.at}"

SKIP_BUILD=0

# Parse CLI options
for arg in "$@"; do
  case "$arg" in
    --skip-build)
      SKIP_BUILD=1
      ;;
    -h|--help)
      echo "Usage: ./publish.sh [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  --skip-build   Skip the 'hugo' step and publish existing public/ folder"
      echo "  -h, --help     Show this help message"
      echo ""
      echo "Environment variables (or .env):"
      echo "  FTP_HOST       FTP hostname (default: s1.weirer-it.at)"
      echo "  FTP_USER       FTP username (default: pet001it)"
      echo "  FTP_PASS       FTP password"
      echo "  FTP_DIR        Remote target subfolder (default: petersgasse.at)"
      echo "  TARGET_DIR     Production folder name (default: www.petersgasse.at)"
      exit 0
      ;;
    *)
      echo "Unknown option: $arg" >&2
      echo "Use --help for usage instructions." >&2
      exit 1
      ;;
  esac
done

echo "=========================================================="
echo "Publishing petersgasse.at via FTP"
echo "Target: ftp://${FTP_USER}@${FTP_HOST}/${FTP_DIR}/"
echo "=========================================================="

# ------------------------------------------------------------------------------
# 1) Run Hugo to build site
# ------------------------------------------------------------------------------
if [[ "$SKIP_BUILD" -eq 0 ]]; then
  echo "[1/5] Building site with Hugo..."
  hugo --gc
  if [[ ! -d "public" || ! -f "public/index.html" ]]; then
    echo "Error: Hugo build failed or public/index.html is missing." >&2
    exit 1
  fi
  echo "Hugo build completed successfully."
else
  echo "[1/5] Skipping Hugo build step as requested."
  if [[ ! -d "public" || ! -f "public/index.html" ]]; then
    echo "Error: public/ directory does not exist. Run Hugo first or omit --skip-build." >&2
    exit 1
  fi
fi

# ------------------------------------------------------------------------------
# 2-5) Python FTP publisher engine
# ------------------------------------------------------------------------------
export FTP_HOST FTP_USER FTP_PASS FTP_DIR TARGET_DIR

python3 - << 'PY_EOF'
import os
import sys
import time
import socket
import ftplib
import re
from pathlib import Path

host = os.environ['FTP_HOST']
user = os.environ['FTP_USER']
password = os.environ['FTP_PASS']
remote_base = os.environ['FTP_DIR']
target_dir_name = os.environ['TARGET_DIR']

local_public = Path('public')

def get_ftp_connection():
    f = ftplib.FTP(timeout=45)
    f.encoding = 'latin-1'
    f.connect(host, 21)
    f.login(user, password)
    f.sendcmd('TYPE I')
    f.cwd(remote_base)
    return f

def remove_ftp_dir_recursive(ftp, dir_path):
    orig = ftp.pwd()
    try:
        ftp.cwd(dir_path)
        for name, facts in list(ftp.mlsd()):
            if name in ('.', '..'):
                continue
            if facts.get('type') == 'dir':
                remove_ftp_dir_recursive(ftp, name)
            else:
                ftp.delete(name)
        ftp.cwd('..')
        ftp.rmd(dir_path.split('/')[-1])
    finally:
        ftp.cwd(orig)

def count_remote_files(ftp, dir_path):
    orig = ftp.pwd()
    count = 0
    try:
        ftp.cwd(dir_path)
        for name, facts in ftp.mlsd():
            if name in ('.', '..'):
                continue
            if facts.get('type') == 'dir':
                count += count_remote_files(ftp, name)
            else:
                count += 1
    finally:
        ftp.cwd(orig)
    return count

def check_quota_status(ftp):
    try:
        resp = ftp.sendcmd('SITE QUOTA')
        match = re.search(r'Uploaded Mb:\s*([\d\.]+)/([\d\.]+)', resp)
        if match:
            used = float(match.group(1))
            limit = float(match.group(2))
            free = max(limit - used, 0.0)
            return used, limit, free
    except Exception:
        pass
    return None, None, None

print("\nConnecting to FTP server...")
ftp = get_ftp_connection()
print(f"Connected to {host} as {user}. Remote base: {ftp.pwd()}")

# Pre-upload storage cleanup: Delete any existing .prev folders beforehand to free quota space
remote_items = {name: facts.get('type') for name, facts in ftp.mlsd() if name not in ('.', '..')}

prev_target = f"{target_dir_name}.prev"
for name, entry_type in list(remote_items.items()):
    if entry_type == 'dir' and (name.endswith('.prev') or name == prev_target):
        print(f"Purging old backup directory beforehand: '{name}'...")
        remove_ftp_dir_recursive(ftp, name)

# Also remove any partial 'public' directory from an interrupted previous run
remote_items = {name: facts.get('type') for name, facts in ftp.mlsd() if name not in ('.', '..')}
if 'public' in remote_items and remote_items['public'] == 'dir':
    print("Purging partial 'public' folder from previous interrupted upload...")
    remove_ftp_dir_recursive(ftp, 'public')

# Check available quota
used_mb, limit_mb, free_mb = check_quota_status(ftp)
local_files = [p for p in local_public.rglob('*') if p.is_file()]
total_files = len(local_files)
total_bytes = sum(p.stat().st_size for p in local_files)
total_mb = total_bytes / (1024 * 1024)

if free_mb is not None:
    print(f"Server Quota: {used_mb:.2f} MB used / {limit_mb:.2f} MB limit ({free_mb:.2f} MB free)")
    if free_mb < total_mb:
        sys.exit(f"Error: Insufficient quota space. Need {total_mb:.2f} MB, but only {free_mb:.2f} MB available. Aborting.")

# ------------------------------------------------------------------------------
# 2) Upload "public" directory to subfolder "petersgasse.at/public"
# ------------------------------------------------------------------------------
print(f"\n[2/5] Uploading 'public' directory ({total_files} files, {total_mb:.2f} MB)...")

ftp.mkd('public')
created_dirs = {'public'}
start_time = time.time()
uploaded_bytes = 0

for idx, file_path in enumerate(local_files, 1):
    rel_path = file_path.relative_to(local_public)
    parent_dirs = rel_path.parent.parts

    # Ensure remote directory hierarchy exists
    current_remote_dir = 'public'
    for part in parent_dirs:
        current_remote_dir = f"{current_remote_dir}/{part}"
        if current_remote_dir not in created_dirs:
            try:
                ftp.mkd(current_remote_dir)
            except ftplib.error_perm:
                pass
            created_dirs.add(current_remote_dir)

    remote_file_path = f"public/{rel_path.as_posix()}"
    file_size = file_path.stat().st_size

    # Upload with automatic retry and reconnection on transient errors
    max_retries = 3
    for attempt in range(1, max_retries + 1):
        try:
            with open(file_path, 'rb') as f:
                ftp.storbinary(f"STOR {remote_file_path}", f, blocksize=65536)
            break
        except (socket.error, ftplib.all_errors, BrokenPipeError, ConnectionResetError) as err:
            if attempt == max_retries:
                sys.exit(f"\nUpload failed for '{rel_path}' after {max_retries} attempts: {err}")
            time.sleep(1.0 * attempt)
            try:
                ftp.close()
            except Exception:
                pass
            ftp = get_ftp_connection()

    uploaded_bytes += file_size
    pct = (idx / total_files) * 100
    if idx % 10 == 0 or idx == total_files or file_size > 512 * 1024:
        elapsed = max(time.time() - start_time, 0.001)
        speed_kb = (uploaded_bytes / 1024) / elapsed
        sys.stdout.write(f"\r  Uploaded {idx}/{total_files} files ({pct:5.1f}%) - {speed_kb:.1f} KB/s")
        sys.stdout.flush()

elapsed_total = time.time() - start_time
print(f"\nUpload completed in {elapsed_total:.1f} seconds ({uploaded_bytes / (1024 * 1024 * max(elapsed_total, 0.001)):.2f} MB/s).")

def get_remote_file_size(ftp, file_path):
    ftp.voidcmd('TYPE I')
    try:
        return ftp.size(file_path)
    except ftplib.all_errors:
        return None

# ------------------------------------------------------------------------------
# 3) Verify that the upload was successful
# ------------------------------------------------------------------------------
print("\n[3/5] Verifying upload integrity...")
remote_file_count = count_remote_files(ftp, 'public')
print(f"  Remote file count: {remote_file_count} (Expected: {total_files})")

if remote_file_count != total_files:
    sys.exit(f"Verification failed: Remote file count ({remote_file_count}) does not match local ({total_files}). Aborting switch.")

# Check integrity of key entrypoints
for key_file in ['index.html', '404.html', 'sitemap.xml', 'robots.txt', 'Schulvideo_480p.mp4']:
    local_key = local_public / key_file
    if local_key.exists():
        remote_size = get_remote_file_size(ftp, f"public/{key_file}")
        local_size = local_key.stat().st_size
        if remote_size != local_size:
            sys.exit(f"Verification failed: Size mismatch on {key_file} (Remote: {remote_size}, Local: {local_size}). Aborting switch.")
print("Verification successful: File count and key file sizes verified.")

# ------------------------------------------------------------------------------
# 4) Rename "www.petersgasse.at" to "www.petersgasse.at.prev"
# ------------------------------------------------------------------------------
print("\n[4/5] Archiving current production site to backup...")
items_now = {name: facts.get('type') for name, facts in ftp.mlsd() if name not in ('.', '..')}

# Delete any existing .prev folders beforehand if any reappeared
for name, entry_type in list(items_now.items()):
    if entry_type == 'dir' and (name.endswith('.prev') or name == prev_target):
        print(f"Removing old backup '{name}'...")
        remove_ftp_dir_recursive(ftp, name)

if target_dir_name in items_now and items_now[target_dir_name] == 'dir':
    print(f"Renaming '{target_dir_name}' to '{prev_target}'...")
    ftp.rename(target_dir_name, prev_target)
else:
    print(f"Note: Current folder '{target_dir_name}' not found; skipping backup rename.")

# ------------------------------------------------------------------------------
# 5) Rename uploaded "public" directory to "www.petersgasse.at"
# ------------------------------------------------------------------------------
print(f"\n[5/5] Activating new release: Renaming 'public' to '{target_dir_name}'...")
ftp.rename('public', target_dir_name)

ftp.quit()
print(f"\n✓ Successfully published! Live at https://{target_dir_name}")
PY_EOF

# ------------------------------------------------------------------------------
# Live Production HTTP Verification
# ------------------------------------------------------------------------------
echo ""
echo "Verifying live production response:"
if curl -sI --max-time 10 "https://${TARGET_DIR}" | head -n 5; then
  echo "Site is responding normally."
else
  echo "Warning: Could not fetch headers from https://${TARGET_DIR}."
fi
