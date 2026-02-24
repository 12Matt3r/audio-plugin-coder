# Verification script for PluginName validation
# To be run with PowerShell

$testCases = @(
    @{ Name = "ValidName"; Expected = $true }
    @{ Name = "valid_name-123"; Expected = $true }
    @{ Name = "Invalid Name"; Expected = $false }
    @{ Name = "Invalid;Name"; Expected = $false }
    @{ Name = "Invalid&Name"; Expected = $false }
    @{ Name = "Invalid|Name"; Expected = $false }
    @{ Name = "Invalid`Name"; Expected = $false }
    @{ Name = "$(whoami)"; Expected = $false }
    @{ Name = "../path/traversal"; Expected = $false }
    @{ Name = "Plugin'Name"; Expected = $false }
    @{ Name = 'Plugin"Name'; Expected = $false }
)

$regex = '^[a-zA-Z0-9_\-]+$'
$allPassed = $true

foreach ($test in $testCases) {
    $result = $test.Name -match $regex
    if ($result -eq $test.Expected) {
        Write-Host "PASS: '$($test.Name)' (Expected $($test.Expected), got $result)" -ForegroundColor Green
    } else {
        Write-Host "FAIL: '$($test.Name)' (Expected $($test.Expected), got $result)" -ForegroundColor Red
        $allPassed = $false
    }
}

if ($allPassed) {
    Write-Host "`nAll validation tests passed!" -ForegroundColor Green
    exit 0
} else {
    Write-Host "`nSome validation tests failed!" -ForegroundColor Red
    exit 1
}
