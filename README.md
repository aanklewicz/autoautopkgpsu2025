# IT Endpoint Autopkg

This repository contains tools and utilities for managing IT endpoint packages using AutoPkg.

## Basic Links
[Autopkg](https://github.com/autopkg/autopkg)  
[Munki](https://github.com/munki/munki)  
[Jon Crain's Automunki](https://github.com/joncrain/automunki)  
[Gusto's autopromote](https://github.com/Gusto/it-cpe-opensource/tree/main/autopromote)
[PDF from Jon's talk at Utah meetup](https://downloads.lib.utah.edu/media_streaming_presentation_documents/pdf/mac_mgrs/20211215_mm/2021.12.15_mm_github_actions.pdf)
[Betsy Keiser’s AutoPKG for Jamf Pro with GitHub Actions](https://www.youtube.com/watch?v=2_xT6Fy2Yi0)
[William Theaker’s (Quick Talk) Running Autopkg with GitHub Actions](https://www.youtube.com/watch?v=bvTO8rNDqX0)
[Rod Christiansen @ MDOYVR 2025](https://www.youtube.com/watch?v=ayQqGT9S_cM)
[Create a Personal Access Token in GitHub](https://github.com/settings/tokens)

## Contents

### `autopkg_src/`

Contains the main source code for AutoPkg tools and utilities.

- `autopkg_tools.py`: Main tools for AutoPkg.
- `cache_utils.py`: Utilities for caching.
- `git_utils.py`: Git utilities.
- `recipe_list.json`: List of recipes.
- `repo_list.txt`: List of repositories.
- `requirements.txt`: Python dependencies.
- `slack_utils.py`: Slack integration utilities.
- `autopromote/`: Directory for autopromote related scripts and configurations.
- `overrides/`: Directory for Autopkg override configurations.

### `autopromote/`

Contains scripts and configurations for autopromoting packages.

- `autopromote.json`: Configuration file for autopromote.
- `autopromote.py`: Script for autopromoting packages.
- `requirements.txt`: Python dependencies.
- `results.plist`: Results file.

## Munki Repo folders

### `icons/`

Contains icons for various applications to appear in Managed Software Centre.

### `manifests/`

Contains manifests which outline which apps are required and optional for each Rollout Phased group in Managed Software Centre.

### `pkgsinfo/`

Contains information about all the packages in the repo and where the installer files live and all settings for them.

## Github Actions

### `autopkg.yml`

This action will run daily on a schedule. Currently set to 9am eastern time. It will grab all the `autopkg_src/recipe_list.json` file and run through all the recipes in that list. It uses the `autopkg_src/autopkg_tools.py` python script to run Autopkg.

1. Spins up a macOS runner.  
A runner is a virtual machine that is spun up on demand to execute the Actions.
2. Checksout the repo.  
This step will take the contents of the Github Repo and make them accessible to the runner.
3. Install Munki.  
Downloaded and installed from source Github repo.
4. Install Autopkg.  
Downloaded and installed from source Github repo.
5. Configure AutoPkg.  
This step will go and set all the required settings for the runner to have during this instance of the run. Since runners are created ad hoc, nothing lives between runs, so it must do this every time.
6. Configure AutoPkg Repos.  
Runs a for loop to go through every line in `autopkg_src/recipe_list.json` and makes sure to add it to autopkg `autopkg repo-add "$repo"`
7. Runs makecatalogs  
This runs Munki's command `makecatalogs` and builds the catalogue files.
8. Setup Python  
This will setup Python settings in macOS
9. Python Cache  
Not sure what this does.
10. pip install  
This will install the requirements for python.
11. Run autopkg  
This will actually run autopkg, this will take the most amount of time.
12. Configure AWS credentials  
Sets up AWS so we can sync the files
13. Push icons and client_resources to Storage Bucket
14. Push packages to Storage Bucket  
These two steps will sync the pkgs and icons and client_resource folders to S3.
15. Gather Logs
16. Upload log file  
These log files appear for us if we need to troubleshoot

### `autopkg_automerge.yml`

This script will automatically merge new branches with `main`.

This runs when a new branch is created that starts with `autopkg-` or `autopromote-`

1. Spins up an Ubuntu runner
2. Checksout the repo
3. Gets the name of the branch  
This branch name is what it needs to merge with `main`
4. Merge the AutoPkg Branch  
This does the actual merging.
5. Delete Branch  
Delete the old branch, as it's now merged with `main`.


### `munki_catalog_s3_sync.yml`

Whenever a new branch is created in `/pkgsinfo/`, we need to merge the brances and sync to S3.

1. Spins up a macOS runner
2. Checksout the repo
3. Install Munki 
4. Runs `makecatalogs`
5. Configure AWS credentials
6. Push files to Storage Bucket  
catalog(ue)s  
pkgsinfo  
manifests

### `munki_repoclean.yml`

This currently doesn't work. The plan is to clean up the Munki Repo, as it is growing fast.

### `munki-promote.yml`

This Github Action will promote items automatically using Gusto's autopromote script.

This Action will run daily at 10am eastern.

1. Spins up a macOS runner
2. Checksout the repo
3. Install Munki 
4. Runs `makecatalogs`
5. Sets up Python
6. Installs Python dependencies
7. Runs the Autopromote script `autopromote/autopromote.py`
8. Run `makecatalogs`
9. Create Branch and Commit Changes