resource_group_name = "rg-fortiweblab-student-CHANGEME"
vnet_name           = "vnet-fortiweb-training-lab"
admin_username      = "azureuser"
admin_password      = "Fortinetlab1!"
# Images share one gallery in Internal-Training so lab users can read them.
# Source captures: External-Training rg_Wondy_Fortiweb_Training / fortiweb_lab_gallery
# (guac 0.0.3 Specialized, docker2 0.0.2 Generalized). CUS uses *-v2 definitions
# (SCSI + Accelerated Networking) because original CUS Linux-docker-2 is TrustedLaunch-only.
guac_image_id       = "/subscriptions/02b50049-c444-416f-a126-3e4c815501ac/resourceGroups/rg-fortiweb-lab-gallery-cus/providers/Microsoft.Compute/galleries/fortiweb_lab_gallery_cus/images/guacamole-client-image-v2/versions/0.0.3"
docker1_image_id    = "/subscriptions/02b50049-c444-416f-a126-3e4c815501ac/resourceGroups/rg-fortiweb-lab-gallery-cus/providers/Microsoft.Compute/galleries/fortiweb_lab_gallery_cus/images/Linux-docker-1/versions/0.0.1"
docker2_image_id    = "/subscriptions/02b50049-c444-416f-a126-3e4c815501ac/resourceGroups/rg-fortiweb-lab-gallery-cus/providers/Microsoft.Compute/galleries/fortiweb_lab_gallery_cus/images/Linux-docker-2-v2/versions/0.0.3"
guac_size           = "Standard_D2s_v3"
docker_size         = "Standard_D2s_v3"
