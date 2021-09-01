::------------------------------------------------------------------------------
:: NAME
::     h265_and_archive.bat
::
:: DESCRIPTION
::     Takes a video file as input, uses ffmpeg to convert it to a 10-bit x265
::     MKV file, then uses 7z to archive it in an XZ file with max compression.
::
:: MANDATORY ARGUMENTS
::     %1 - The name of the video file to process
::
:: AUTHOR
::     Sintrode
::------------------------------------------------------------------------------
@echo off

:: Constants
set "ffmpeg=REPLACE_ME_WITH_PATH_TO_FFMPEG.EXE"
set "ffmpeg_opts=-fflags +genpts -c:v libx265 -preset slow -pix_fmt yuv422p10le -x265-params pools=4 -c:a copy"
set "sevenzip=REPLACE_ME_WITH_PATH_TO_7Z.EXE"
set "sevenzip_opts=a -mx9 -mmt32 -ms256m"

for %%A in ("%ffmpeg%" "%sevenzip%") do (
	if not exist "%%A" (
		echo %%~nxA not found. Exiting.
		exit /b 1
	)
)

set "input_file=%~1"
set "output_file=%~dpn1.10bit.x265.mkv"
"%ffmpeg%" -i "%input_file%" %ffmpeg_opts% "%output_file%"
"%sevenzip%" %sevenzip_opts% "%output_file%.xz" "%output_file%"
del "%output_file%"
del "%input_file%"