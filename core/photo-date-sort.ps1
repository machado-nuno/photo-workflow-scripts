
# Define the source directory containing photos
$sourceDir = "C:\Path\To\Source\Photos"

# Define the destination directory where photos will be sorted
$destinationDir = "C:\Path\To\Sorted\Photos"

# Create the destination directory if it doesn't exist
if (-Not (Test-Path $destinationDir)) {
    New-Item -Path $destinationDir -ItemType Directory
}

# Get all the image files from the source directory
$photos = Get-ChildItem -Path $sourceDir -Include *.jpg, *.jpeg, *.png, *.gif, *.tiff -Recurse

foreach ($photo in $photos) {
    try {
        # Get the Date Taken property of the photo
        $dateTaken = (Get-ItemProperty -Path $photo.FullName).DateTaken

        # If Date Taken property is not found, use the Date Modified property
        if (-not $dateTaken) {
            $dateTaken = (Get-ItemProperty -Path $photo.FullName).LastWriteTime
        }

        # Extract Year and Month from the Date Taken
        $year = $dateTaken.ToString("yyyy")
        $month = $dateTaken.ToString("MM")

        # Define the target folder structure: Year\Month
        $targetFolder = Join-Path -Path $destinationDir -ChildPath "$year\$month"

        # Create the target folder if it doesn't exist
        if (-Not (Test-Path $targetFolder)) {
            New-Item -Path $targetFolder -ItemType Directory -Force
        }

        # Move the photo to the target folder
        Move-Item -Path $photo.FullName -Destination $targetFolder

        Write-Output "Moved $($photo.Name) to $targetFolder"
    } catch {
        Write-Output "Error processing $($photo.FullName): $_"
    }
}


### Key Improvements

###1. **Year and Month-Based Folder Structure**:  
###   The script now extracts the year and month from the photo's `DateTaken` property and organizes photos into a folder structure like `Year\Month` (e.g., `2024\08`).

###2. **Flexible and Robust**:
###   - If the `DateTaken` property isn't available, the script falls back to the `LastWriteTime` property.
###   - Creates folders only if they do not already exist.

###3. **Improved Logging**:
###   - Output messages indicate when a file is moved and any errors encountered during processing.

### How to Use

###1. **Update Paths**: Replace `$sourceDir` and `$destinationDir` with your actual source and destination directories.
###2. **Run in PowerShell**: Save the script to a `.ps1` file or run it directly in a PowerShell window.

###This script will now organize your photos by the year and month they were taken, making it easier to navigate and manage your photo collection.
