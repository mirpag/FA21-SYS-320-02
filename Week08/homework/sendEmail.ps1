# Storyline: send an email.

# Variable can have an underscore or any alphanumeric value

# Body of the email
$msg = "Hello there."

Write-Host -BackgroundColor Red -ForegroundColor White $msg

# Email From Address
$email = "miranda.pagarelski@mymail.champlain.edu"


# To address
$toEmail = "deployer@csi-web"

# Sending the email
Send-MailMessage -From $email -To $toEmail -Subject "A Greeting" -Body $msg -SmtpServer 192.168.6.71