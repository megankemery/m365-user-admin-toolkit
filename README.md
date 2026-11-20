# Microsoft 365 User Administration Toolkit

A PowerShell-based IT administration project that simulates Microsoft 365 user account auditing, license reviews, group membership checks, and administrative reporting.

## Project Overview

This project demonstrates how PowerShell can automate common identity and access management (IAM) review tasks.

The toolkit analyzes fictional Microsoft 365-style user records, identifies potential administrative concerns, assigns review priorities, and generates a CSV report.

It is designed as a hands-on IT automation and professional portfolio project.

**Important:** This project uses fictional data only. It does not connect to a live Microsoft 365 tenant or make changes to user accounts.

## Features

- Reviews simulated Microsoft 365 user accounts
- Identifies disabled accounts with assigned licenses
- Flags enabled accounts without licenses
- Identifies potentially inactive enabled accounts
- Reviews group memberships for disabled accounts
- Detects disabled accounts retaining All-Staff membership
- Assigns administrative review priorities
- Supports multiple findings per account
- Generates a detailed CSV audit report
- Displays account totals and priority summaries
- Runs automatically through GitHub Actions
- Provides downloadable report artifacts

## Technologies Used

- PowerShell
- Microsoft 365 administration concepts
- Identity and Access Management (IAM)
- CSV data processing
- GitHub
- GitHub Actions
- Windows automation

## Project Structure

```text
m365-user-admin-toolkit/
|
|-- .github/
|   |-- workflows/
|       |-- m365-user-audit.yml
|
|-- Invoke-M365UserAudit.ps1
|-- sample-m365-users.csv
|-- sample-m365-audit-report.csv
|-- README.md
```

## Audit Rules

The script evaluates user accounts against the following conditions:

| Condition | Review Priority |
|-----------|-----------------|
| Disabled account with license | Medium |
| Enabled account without license | Low |
| Enabled account inactive for 90+ days | Medium |
| Disabled account retaining All-Staff membership | Medium |
| Multiple findings for one account | High |

These priorities are illustrative administrative review categories, not official Microsoft security severity ratings.

A flagged account does not automatically indicate a security incident or an incorrectly configured account.

## Sample Audit Results

The fictional test dataset contains eight user accounts.

The completed audit identifies four accounts requiring administrative review.

| Account | Review Priority | Findings |
|---------|-----------------|----------|
| Mary Jones | High | Disabled with license; retains All-Staff membership |
| Brian Williams | Low | Enabled without license |
| Sarah Johnson | Medium | Potentially inactive |
| Alex Garcia | Medium | Disabled account retaining All-Staff membership |

### Administrative Review Summary

```text
Accounts reviewed: 8
Accounts flagged: 4

High priority accounts: 1
Medium priority accounts: 2
Low priority accounts: 1
```

## Running the Script

### Requirements

- PowerShell 5.1 or later
- Windows or a compatible PowerShell environment
- Sample CSV dataset included in the repository

### Local Execution

Clone or download the repository.

Open PowerShell in the project directory and run:

```powershell
.\Invoke-M365UserAudit.ps1
```

The script reads:

`sample-m365-users.csv`

And generates:

`m365-user-audit-report.csv`

The generated report includes eight columns:

1. DisplayName
2. UserPrincipalName
3. Department
4. AccountEnabled
5. License
6. LastSignInDaysAgo
7. ReviewPriority
8. Issues

## GitHub Actions Automation

The project includes a GitHub Actions workflow that runs the audit on a Windows runner.

The workflow can be started manually and also runs when relevant project files are pushed to the main branch.

After execution, the generated CSV report is uploaded as a downloadable artifact.

Artifacts are retained for seven days.

## Testing and Validation

The script was tested using GitHub Actions with fictional Microsoft 365-style account records.

Verified results:

- Eight accounts successfully processed
- Four accounts correctly flagged
- Multiple findings detected for one account
- Group membership checks completed
- Review priorities assigned
- Priority summary generated
- CSV report exported successfully
- GitHub Actions workflow completed successfully

## Security and Privacy

This project does not use real employee information, credentials, or Microsoft 365 tenant data.

The script performs read-only analysis of a fictional CSV dataset.

No account modifications, license changes, or group membership changes are performed.

In a real environment, account reviews should follow organizational security policies, authorized access requirements, and documented approval procedures.

## Current Limitations

- Uses simulated account data rather than Microsoft Graph
- Does not connect to a Microsoft 365 tenant
- Uses a fixed 90-day inactivity threshold
- Does not distinguish between all Microsoft 365 license or group types
- Uses illustrative review priorities
- Does not automatically remediate flagged accounts

## Future Improvements

Potential enhancements include:

- Microsoft Graph integration using authorized read-only permissions
- License utilization reporting
- Expanded group membership auditing
- Configurable inactivity thresholds
- Improved input validation and error handling
- Automated PowerShell unit tests
- HTML administrative dashboards
- Additional account lifecycle checks

## Skills Demonstrated

This project demonstrates practical experience with:

- PowerShell scripting and automation
- Identity and Access Management concepts
- Microsoft 365 user administration workflows
- License and group membership auditing
- Conditional logic and PowerShell functions
- CSV processing and report generation
- Automated execution through GitHub Actions
- Troubleshooting and validation
- Technical documentation

## Career Development

This project was created to strengthen practical PowerShell automation, identity administration, and IT operations skills while building a professional technical portfolio.
