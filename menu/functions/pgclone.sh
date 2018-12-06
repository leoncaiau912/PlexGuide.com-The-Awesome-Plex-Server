#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
statusmount () {
  mcheck5=$(cat /opt/appdata/plexguide/rclone.conf | grep "$type")
  if [ "$mcheck5" != "" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Warning!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
NOTE: $mcheck5 already exists! To proceed, we must delete the prior
configuration for you.

EOF
  read -p '🌍 Proceed? y or n | Press [ENTER]: ' typed < /dev/tty

  if [[ "$typed" == "Y" || "$typed" == "y" ]]; then a=b
elif [[ "$typed" == "N" || "$typed" == "n" ]]; then mountsmenu
  else
    badinput
    statusmount
  fi

  rclone --config /opt/appdata/plexguide/rclone.conf config delete $mcheck5

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: $mcheck5 deleted!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
read -p '🌍 Acknowledge Info | Press [ENTER]: ' typed < /dev/tty
fi

}

inputphase () {
deploychecks

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Deployment - $type       reference: oauth.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PG is Deploying /w the Following Values:

ID:        $public
SECRET:    $secret
TEAMDRIVE: $teamdrive

EOF

read -p '🌍 Proceed? y or n | Press [ENTER]: ' typed < /dev/tty

if [[ "$typed" == "Y" || "$typed" == "y" ]]; then a=b
elif [[ "$typed" == "N" || "$typed" == "n" ]]; then question1
else
  badinput
  inputphase
fi

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Google Authentication    reference: oauth.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Quitting? Type > exit
NOTE: Copy & Paste Url into Browser | Use Correct Google Account!

https://accounts.google.com/o/oauth2/auth?client_id=$public&redirect_uri=urn:ietf:wg:oauth:2.0:oob&scope=https://www.googleapis.com/auth/drive&response_type=code

EOF
  read -p '🌍 Token | PRESS [ENTER]: ' token < /dev/tty
  if [ "$token" = "exit" ]; then mountsmenu; fi
  curl --request POST --data "code=$token&client_id=$public&client_secret=$secret&redirect_uri=urn:ietf:wg:oauth:2.0:oob&grant_type=authorization_code" https://accounts.google.com/o/oauth2/token > /opt/appdata/plexguide/pgclone.info

  accesstoken=$(cat /opt/appdata/plexguide/pgclone.info | grep access_token | awk '{print $2}')
  refreshtoken=$(cat /opt/appdata/plexguide/pgclone.info | grep refresh_token | awk '{print $2}')
  rcdate=$(date +'%Y-%m-%d')
  rctime=$(date +"%H:%M:%S" --date="$givenDate 60 minutes")
  rczone=$(date +"%:z")
  final=$(echo "${rcdate}T${rctime}${rczone}")

  testphase
}

mountsmenu () {
projectid=$(cat /var/plexguide/pgclone.project)
secret=$(cat /var/plexguide/pgclone.secret)
public=$(cat /var/plexguide/pgclone.public)
teamdrive=$(cat /var/plexguide/pgclone.teamdrive)

if [ "$secret" == "" ]; then dsecret="NOT SET"; else dsecret="SET"; fi
if [ "$public" == "" ]; then dpublic="NOT SET"; else dpublic="SET"; fi
if [ "$teamdrive" == "" ]; then dteamdrive="NOT SET"; else dteamdrive="SET"; fi

#5 - Configure - tdrive: [$tstatus]
#6 - Encryption Setup

if [ "$transport" == "PG Move /w No Encryption" ]; then
display2="5 - Deploy PG Clone   : [good/bad]"
fi

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 PG Clone - Mounts                       reference:pgclone.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1 - Set Client ID     : [$dpublic]
2 - Set Secret ID     : [$dsecret]
3 - Set TeamDrive     : [$dteamdrive]
4 - Configure - gdrive: [$gstatus]
$display2
Z - Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -p '🌍 Set Choice | Press [ENTER] ' typed < /dev/tty

if [ "$transport" == "PG Move /w No Encryption" ]; then
  if [ "$typed" == "5" ]; then
  inputphase
  mountsmenu
  fi
fi

if [ "$typed" == "1" ]; then
  publickeyinput
  mountsmenu
elif [ "$typed" == "2" ]; then
  secretkeyinput
  mountsmenu
elif [ "$typed" == "3" ]; then
  teamdriveinput
  mountsmenu
elif [ "$typed" == "4" ]; then
  type=gdrive
  statusmount
  inputphase
  mountsmenu
  ##type=tdrive
  #statusmount
  #inputphase
  #mountsmenu

#elif [ "$typed" == "7" ]; then
#  inputphase
#  mountsmenu
elif [[ "$typed" == "Z" || "$typed" == "z" ]]; then question1;
else badinput
  projectmenu; fi
}

teamdriveinput () {
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Team Drive Identifier                       reference: td.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Quitting? Type > exit
Example: 0BCGnO4COZqr2Uk9PVA ~ Visit Reference Above for More Info

EOF
  read -p '🌍 Type Identifer | Press [Enter]: ' teamdrive < /dev/tty
  if [ "$teamdrive" = "exit" ]; then mountsmenu; fi
echo "$teamdrive" > /var/plexguide/pgclone.teamdrive

}

publickeyinput () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Google OAuth Keys - Client ID             reference: oauth.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Quitting? Type > exit
NOTE: Visit reference for Google OAuth Keys!

EOF

read -p '🌍 Client ID  | Press [Enter]: ' public < /dev/tty
if [ "$public" = "exit" ]; then mountsmenu; fi
echo "$public" > /var/plexguide/pgclone.public
mountsmenu
}

secretkeyinput () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Google OAuth Keys - Secret Key           reference: oauth.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Quitting? Type > exit
NOTE: Visit reference for Google OAuth Keys!

EOF
read -p '🌍 Secret Key  | Press [Enter]: ' secret < /dev/tty
if [ "$secret" = "exit" ]; then mountsmenu; fi
echo "$secret" > /var/plexguide/pgclone.secret
mountsmenu
}

projectmenu () {
projectid=$(cat /var/plexguide/pgclone.project)

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 GCloud Project Interface               reference:pgclone.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Project ID: $projectid

1 - Establish
2 - Create
3 - Destroy (NOT READY)
4 - Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

read -p '🌍 Set Choice | Press [ENTER] ' typed < /dev/tty

if [ "$typed" == "1" ]; then projectestablish;
elif [ "$typed" == "2" ]; then projectcreate;
elif [ "$typed" == "4" ]; then question1;
else badinput
  projectmenu; fi
}

projectestablish () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 GCloud Project Interface               reference:pgclone.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Project ID: $projectid

Established Projects
EOF
  cat /var/plexguide/projects.list | cut -d' ' -f1 | tail -n +2
  cat /var/plexguide/projects.list | cut -d' ' -f1 | tail -n +2 > /var/plexguide/project.cut
  echo
  changeproject
  echo
  projectidset
  gcloud config set project $typed

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 System Message: Enabling Drive API ~ Project $typed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
gcloud services enable drive.googleapis.com --project $typed
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 System Message: Project Established ~ $typed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -p '🌍 Acknowledge Info | Press [ENTER] ' typed < /dev/tty
  $typed > /var/plexguide/pgclone.project
  question1
]
}

transportdisplay () {
temp=$(cat /var/plexguide/pgclone.transport)
  if [ "$temp" == "umove" ]; then transport="PG Move /w No Encryption"
elif [ "$temp" == "emove" ]; then transport="PG Move /w Encryption"
elif [ "$temp" == "ublitz" ]; then transport="PG Blitz /w No Encryption"
else transport="NOT-SET"; fi
}

transportmode () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Select a Data Transport Mode          reference:transport.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1 - PG Move : Unencrypt | Simple  ~ Uploads 750GB  Per Day
2 - PG Move : Encrypted | Simple  ~ Uploads 750GB  Per Day
3 - PG Blitz: Unencrypt | Complex ~ Exceeds 750GB+ Per Day
Z - Exit

EOF
read -p '🌍 Set Choice | Press [ENTER] ' typed < /dev/tty

  if [ "$typed" == "1" ]; then echo "umove" > /var/plexguide/pgclone.transport && echo;
elif [ "$typed" == "2" ]; then echo "emove" > /var/plexguide/pgclone.transport && echo;
elif [ "$typed" == "3" ]; then echo "ublitz" > /var/plexguide/pgclone.transport && echo;
elif [[ "$typed" == "Z" || "$typed" == "z" ]]; then question1;
else
  badinput
  transportmode; fi
}

changeproject () {
  read -p '🌍 Set/Change Project ID? (y/n)| Press [ENTER] ' typed < /dev/tty
  if [[ "$typed" == "n" || "$typed" == "N" ]]; then question1
elif [[ "$typed" == "y" || "$typed" == "Y" ]]; then a=b
else badinput
  echo ""
  changeproject; fi
}

projectidset () {
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Type the Project Name to Utilize
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  cat /var/plexguide/projects.list | cut -d' ' -f1 | tail -n +2
  echo ""
  read -p '🌍 Type Project Name | Press [ENTER]: ' typed < /dev/tty
  echo ""
  list=$(cat /var/plexguide/project.cut | grep $typed)

  if [ "$typed" != "$list" ]; then
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Error! Type the Exact Project Name Listed!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -p '🌍 Acknowledge Info | Press [ENTER] ' typed < /dev/tty
  projectidset
  fi
}

testphase () {
  echo "" > /opt/appdata/plexguide/test.conf
  echo "[$type]" >> /opt/appdata/plexguide/test.conf
  echo "client_id = $public" >> /opt/appdata/plexguide/test.conf
  echo "client_secret = $secret" >> /opt/appdata/plexguide/test.conf
  echo "type = drive" >> /opt/appdata/plexguide/test.conf
  echo -n "token = {\"access_token\":${accesstoken}\"token_type\":\"Bearer\",\"refresh_token\":${refreshtoken}\"expiry\":\"${final}\"}" >> /opt/appdata/plexguide/test.conf
  echo "" >> /opt/appdata/plexguide/test.conf
  if [ "$type" == "tdrive" ]; then echo "team_drive = $teamdrive" >> /opt/appdata/plexguide/test.conf; fi
  echo ""
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Conducting Validation Checks - $type
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  sleep 1
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Creating Test Directory - $type:/plexguide
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  sleep 1
  rclone mkdir --config /opt/appdata/plexguide/test.conf $type:/plexguide
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Checking Existance of $type:/plexguide
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  rcheck=$(rclone lsd --config /opt/appdata/plexguide/test.conf $type: | grep -oP plexguide | head -n1)

  if [ "$rcheck" != "plexguide" ];then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Validation Checks Failed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

TIPS:
1. Did you copy your username and password correctly?
2. When you created the credentials, did you select "Other"?
3. Did you enable your API?

EOF
    echo "Not Active" > /var/plexguide/gdrive.pgclone
    read -p '🌍 Acknowledge Info | Press [ENTER] ' typed2 < /dev/tty
    question1
else
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Validation Checks Passed - $type
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

fi

read -p '🌍 Acknowledge Info | Press [ENTER] ' typed2 < /dev/tty
echo "Active" > /var/plexguide/$type.pgclone
cat /opt/appdata/plexguide/test.conf >> /opt/appdata/plexguide/rclone.conf
question1

EOF
}

deploychecks () {
secret=$(cat /var/plexguide/pgclone.secret)
public=$(cat /var/plexguide/pgclone.public)
teamdrive=$(cat /var/plexguide/pgclone.teamdrive)

if [ "$secret" == "" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 ERROR: Secret Key Is Blank! Unable to Deploy!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
read -p '🌍 Acknowledge Info | Press [Enter] ' typed < /dev/tty
question1; fi

if [ "$public" == "" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 ERROR: Client ID Is Blank! Unable to Deploy!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
read -p '🌍 Acknowledge Info | Press [Enter] ' typed < /dev/tty
question1; fi
}
