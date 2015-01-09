# grannyvisor
Motion sensor for monitoring the elderly

apt-get dependencies:

libwww-perl (for LWP)
motion

Assumes that the git repository is cloned to the home directory of a
user called grannyvisor.

This user runs the cron job in ./crontab
This job starts (and restarts) the motion server.

There is a configuration file for motion in ./config/motion
There is a template configuration file for the grannyvisor scripts in
.config/grannyvisor

When motion detects a movement, it generates a sequence of .jpg files in
the motion subdirectory, and runs scripts/on_motion_detected.pl. This
script generates an HTML page that shows the images in motion/index.html
 
