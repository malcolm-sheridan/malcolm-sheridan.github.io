
function getInstagramPosts {
    param (
        $url
    )
    
    $RestCall = @{            
        Uri = $url
        ContentType = "application/json"
        Method = "GET"
    }

    # Invoke the REST method call to the Slack service's webhook.
    $RestMethodResult = Invoke-RestMethod @RestCall

    $RestMethodResult | ForEach-Object {
        Write-Output $_.data
    }

    $paging = $RestMethodResult | Where-Object { $null -ne $_.paging.next }
    #Write-Output $paging.paging.next

    if($null -ne $paging.paging.next) {
        Write-Output "Fetching more..."
        getInstagramPosts($paging.paging.next)
    }
}

$access_token = ""
$fields = "id,caption,media_url,media_type,username,timestamp"
$limit = 5
$url = "https://graph.instagram.com/me/media?fields=$($fields)&access_token=$($access_token)&limit=$($limit)"

# Make the first call to the Instagram Basic API
getInstagramPosts($url)
