$ErrorActionPreference = "Continue"

Write-Output "DISTRIBUTED NODE FAILURE AND RECOVERY TEST"

try {
    Write-Output "TEST 1: STOPPING REMOTE BRANCH NODE"

    docker stop mit8103-branch-node

    Write-Output "TEST 2: REMOTE QUERY SHOULD FAIL"

    docker exec mit8103-coordinator `
        psql -U mit8103 -d distributed_retail `
        -c "SELECT COUNT(*) FROM remote_branch_orders;" 2>&1

    if ($LASTEXITCODE -ne 0) {
        Write-Output "TEST PASSED: Coordinator detected that the remote node was unavailable"
    }
    else {
        Write-Output "TEST FAILED: Remote query unexpectedly succeeded"
    }
}
finally {
    Write-Output "TEST 3: RESTARTING REMOTE BRANCH NODE"

    docker start mit8103-branch-node

    Write-Output "WAITING FOR REMOTE NODE TO BECOME HEALTHY"

    $healthStatus = ""

    for ($attempt = 1; $attempt -le 20; $attempt++) {
        $healthStatus = docker inspect `
            --format="{{.State.Health.Status}}" `
            mit8103-branch-node 2>$null

        if ($healthStatus -eq "healthy") {
            break
        }

        Start-Sleep -Seconds 2
    }

    Write-Output "Remote node health status: $healthStatus"

    Write-Output "TEST 4: REMOTE QUERY AFTER RECOVERY"

    docker exec mit8103-coordinator `
        psql -v ON_ERROR_STOP=1 `
        -U mit8103 `
        -d distributed_retail `
        -c "SELECT COUNT(*) AS recovered_orders, SUM(order_total) AS recovered_revenue FROM remote_branch_orders;"

    if ($LASTEXITCODE -eq 0 -and $healthStatus -eq "healthy") {
        Write-Output "TEST PASSED: Remote node recovered and distributed queries resumed"
    }
    else {
        Write-Output "TEST FAILED: Recovery verification was unsuccessful"
    }
}

Write-Output "ALL FAILURE AND RECOVERY TESTS COMPLETED"