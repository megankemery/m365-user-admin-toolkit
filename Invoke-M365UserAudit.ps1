# Microsoft 365 User Administration Toolkit
# Simulated user account audit
# Uses fictional CSV data only
# Read-only: Does not connect to Microsoft 365

$ErrorActionPreference = "Stop"

$inputFile = Join-Path $PSScriptRoot "sample-m365-users.csv"
$outputFile = Join-Path $PSScriptRoot "m365-user-audit-report.csv"

function Get-M365AuditFindings {
    param(
        [Parameter(Mandatory)]
        [object[]]$Users
    )

    $findings = @()

    foreach ($user in $Users) {
        $issues = @()

        $enabled = $user.AccountEnabled -eq "True"
        $hasLicense = -not (
            [string]::IsNullOrWhiteSpace($user.License) -or
            $user.License -eq "None"
        )

        $lastSignIn = [int]$user.LastSignInDaysAgo

        # Check disabled accounts with licenses
        if (-not $enabled -and $hasLicense) {
            $issues += "Disabled account with license"
        }

        # Check enabled accounts without licenses
        if ($enabled -and -not $hasLicense) {
            $issues += "Enabled account without license"
        }

        # Check potentially inactive enabled accounts
        if ($enabled -and $lastSignIn -ge 90) {
            $issues += "Potentially inactive account"
        }

# Check disabled accounts with All-Staff membership
$groups = @(
    $user.Groups -split ";" |
    ForEach-Object { $_.Trim() }
)

if (-not $enabled -and "All-Staff" -in $groups) {
    $issues += "Disabled account retains All-Staff membership"
}

# Assign administrative review priority
$reviewPriority = "Low"

if ($issues.Count -gt 1) {
    $reviewPriority = "High"
}
elseif (
    "Disabled account with license" -in $issues -or
    "Potentially inactive account" -in $issues -or
    "Disabled account retains All-Staff membership" -in $issues
) {
    $reviewPriority = "Medium"
}

        # Add flagged accounts to the report
        if ($issues.Count -gt 0) {
            $findings += [PSCustomObject]@{
                DisplayName = $user.DisplayName
                UserPrincipalName = $user.UserPrincipalName
                Department = $user.Department
                AccountEnabled = $user.AccountEnabled
                License = $user.License
                LastSignInDaysAgo = $lastSignIn
                ReviewPriority = $reviewPriority
                Issues = $issues -join "; "
            }
        }
    }

    return $findings
}

Write-Host "==================================="
Write-Host " MICROSOFT 365 USER ACCOUNT AUDIT"
Write-Host "==================================="
Write-Host ""

# Verify the input file exists
if (-not (Test-Path $inputFile)) {
    throw "Input file not found: $inputFile"
}

# Import fictional user accounts
$users = @(Import-Csv -Path $inputFile)

# Validate required columns
$requiredColumns = @(
    "DisplayName",
    "UserPrincipalName",
    "AccountEnabled",
    "License",
    "Department",
    "Groups",
    "LastSignInDaysAgo"
)

$actualColumns = @()
if ($users.Count -gt 0) {
    $actualColumns = @($users[0].PSObject.Properties.Name)
}

$missingColumns = @(
    $requiredColumns | Where-Object {
        $_ -notin $actualColumns
    }
)

if ($missingColumns.Count -gt 0) {
    throw "Missing required CSV columns: $($missingColumns -join ', ')"
}

# Run account audit
$findings = @(Get-M365AuditFindings -Users $users)

# Export report
$findings | Export-Csv `
    -Path $outputFile `
    -NoTypeInformation `
    -Encoding UTF8

# Display summary
Write-Host "Accounts reviewed: $($users.Count)"
Write-Host "Accounts flagged: $($findings.Count)"
Write-Host ""

foreach ($finding in $findings) {
    Write-Host "Account: $($finding.UserPrincipalName)"
    Write-Host "Issues: $($finding.Issues)"
    Write-Host ""
}

Write-Host "Audit completed successfully!" -ForegroundColor Green
Write-Host "Report saved to: $outputFile"
