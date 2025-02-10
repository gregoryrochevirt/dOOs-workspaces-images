![Logo][logo]
# Workspaces Images

Each of these images is based off one of the [**Workspaces Core Images**](https://github.com/kasmtech/workspaces-core-images?utm_campaign=Github&utm_source=github) which contain the necessary wiring to work within the Kasm Workspaces platform.


For more information about building custom images please review the  [**How To Guide**](https://kasmweb.com/docs/latest/how_to/building_images.html?utm_campaign=Github&utm_source=github)



# Manual Deployment

```
sudo docker run --rm  -it --shm-size=512m -p 6901:6901 -e VNC_PW=password -e CONNECTTO=192.168.0.10 -e
USERMANE=jean -e PASSWORD=pierre dooshub/winbox4:1.16.1

```

The container is now accessible via a browser : `https://<IP>:6901`

 - **User** : `kasm_user`
 - **Password**: `password`
