# CronJobs
This repository is to host my cronbjob scripts in the context of github actions.

# Keep Projects Awake

The **Keep Projects Awake** GitHub Actions workflow is designed to ensure that a set of specified projects remain accessible and operational. It periodically checks the availability of these projects using a set of proxy servers and updates IP authorizations as needed.

## Overview

This workflow performs the following tasks:

1. **Scheduled Execution**: Runs every 15 minutes or manually triggered via the GitHub Actions interface.
2. **IP Authorization Management**: Retrieves and deletes existing IP authorizations, then authorizes the runner's current IP address with the proxy API.
3. **Project Availability Check**: Tests the availability of specified projects through multiple proxies, retrying with different proxies if necessary.

## Workflow

The workflow is triggered by a scheduled cron job (`*/15 * * * *`) or can be manually triggered. It runs the following steps:

1. **Checkout Repository**: Checks out the repository to access workflow files and scripts.
   
2. **Get Runner IP Address**: Retrieves the IP address of the runner machine and sets it as an output variable.

3. **Fetch and Debug Existing IP Authorizations**: Fetches and logs all current IP authorizations from the proxy API.

4. **Delete All Existing IP Authorizations**: Deletes all existing IP authorizations to ensure only the current runner's IP is authorized.

5. **Authorize IP Address with Proxy API**: Authorizes the current IP address of the runner with the proxy API.

6. **Create and Run Project Check Script**: Generates and executes a script to check the availability of a list of projects using various proxies. The script:
   - Defines a list of proxy servers and projects to check.
   - Attempts to access each project using the proxies, retrying with different proxies as needed.
   - Logs results and exits with an error if none of the proxies succeed for a project.

## Configuration

### Cron Schedule

The workflow is scheduled to run every 15 minutes using the cron expression `*/15 * * * *`.

### Secrets

Ensure the following secrets are configured in your GitHub repository settings:

- `PROXY_API_TOKEN`: Your API token for authenticating with the proxy service.

## Script Details

The `check_projects.sh` script performs the following tasks:

- **Lists Proxies and Projects**: Defines arrays of proxy servers and project URLs.
- **Checks Each Project**: Tries to access each project URL through a randomly selected proxy. Retries if the request fails.
- **Logs Results**: Outputs the success or failure of each attempt and logs the overall result.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

For more information or support, please contact the project maintainers or refer to the repository issues.

---

Feel free to contribute to the project or suggest improvements via GitHub issues or pull requests.
