####################################################################
# File Name: backup_tar_incremental_pendent_adjuntar.sh
# Author: Anqiao
# Mail: ayang@jaumebalmes.net
# Created Time: mié 01 feb 2017 17:55:36 CET
#===================================================================
#!/bin/bash


cd /tmp/test; tar --listed-incremental=snapshot.file -cf - documents | smbclient //192.168.0.11/rfp08 -A /root/.smbpass_cli -Tx - &> /dev/null; cd -

