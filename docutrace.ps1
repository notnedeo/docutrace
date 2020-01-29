Add-Type -assembly System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$GForm = New-Object System.Windows.Forms.Form

$ShFileName = New-Object System.Windows.Forms.Label
$RetUniQ = New-Object System.Windows.Forms.Label
$ExpText = New-Object System.Windows.Forms.Label

$FileDia = New-Object System.Windows.Forms.OpenFileDialog
$FolderDia = New-Object System.Windows.Forms.FolderBrowserDialog

$AssignButton = New-Object System.Windows.Forms.Button
$IndexButton = New-Object System.Windows.Forms.Button

$GForm.FormBorderStyle = 3
$GForm.Text ='DocuTrace - Document Tracing System'
$GForm.Width = 600
$GForm.Height = 400

$ShFileName.Location = '100,100'
$ShFileName.Size = '400,40'
$ShFileName.Text = 'The selected file will show here'

$RetUniQ.Location = '200,150'
$RetUniQ.Size = '400,23'
$RetUniQ.Text = 'Unique Identifier is '

$AssignButton.Text = 'Select'
$AssignButton.Location = '200,200'

$IndexButton.Text = 'Index'
$IndexButton.Location = '300,200'

$ExpText.Text = 'The File You have selected: '
$ExpText.Location = '200,50'
$ExpText.Size = '200,23' 

$GForm.Controls.Add($ShFileName)
$GForm.Controls.Add($RetUniQ)
$GForm.Controls.Add($ExpText)
$GForm.Controls.Add($AssignButton)
$GForm.Controls.Add($IndexButton)

$AssignButton.Add_Click({
    $FileDia.ShowDialog()
    $file = $FileDia.FileName
    $value =  -join ((48..57) + (65..90) + (97..122) `
    | Get-Random -Count 20 `
    | ForEach-Object {[char]$_})
    if (-NOT (Get-Item $file -Stream * | where stream -ne ':$DATA')) {
        $ShFileName.Text = $FileDia.FileName
        Set-Content $file -Stream $value -value $value
        $RetUniQ.Text = 'Unique Identifier is ' + $value
        }
    else {
        $ShFileName.Text = 'Already has Unique Identifier'
        $RetUniQ.Text = ''

    }
    })

$IndexButton.Add_Click({
    $FolderDia.ShowDialog()
    $folder = $FolderDia.SelectedPath
    $folder = $folder + "\*"
    get-childitem -Path $folder -recurse `
    | ForEach-Object { get-item $_.FullName -stream * } `
    | where-object stream -ne ':$DATA' `
    | where stream -ne 'Zone.Identifier' `
    | ConvertTo-Html -Property FileName, Stream, PSChildName `
    | Out-File -FilePath C:\Users\index.html #this will need to be changed
})

$GForm.ShowDialog()


