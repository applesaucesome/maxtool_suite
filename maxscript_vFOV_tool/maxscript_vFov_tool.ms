try(destroyDialog ::CameraInfoExporter) catch()
--3ds max uses vFov
--Unity uses hFov
global vfov
global cameraInfo = ""
fn CamExporter = (
    cameraInfo = ""

        try(destroyDialog ::textBoxRollout) catch()

        hfovRad = degToRad $.fov
        vfovRad = 2 * atan (tan (hfovRad/2) * renderHeight/renderWidth)


        vfov = radToDeg vfovRad
        vfov = ceil vfov

        eulerRotation = $.rotation as eulerAngles
        
        cameraInfo += "{" + "\r\n"
        cameraInfo += "position: {" + "\r\n"
        cameraInfo += "    x: " + (($.pos.x * 0.01) as string) + "," + "\r\n"
        cameraInfo += "    y: " + (($.pos.z * 0.01) as string) + "," + "\r\n"
        cameraInfo += "    z: " + (($.pos.y * 0.01 * -1) as string) + "," + "\r\n"
        cameraInfo += "}," + "\r\n"
        cameraInfo += "rotation: {" + "\r\n"
        cameraInfo += "    x: " + ((eulerRotation.x) as string) + "," + "\r\n"
        cameraInfo += "    y: " + ((eulerRotation.z + 180) as string) + "," + "\r\n"
        cameraInfo += "    z: " + ((eulerRotation.y) as string) + "," + "\r\n"
        cameraInfo += "}," + "\r\n"
        cameraInfo += "rect: {" + "\r\n"
        cameraInfo += "    width: " + (renderWidth as string) + "," + "\r\n"
        cameraInfo += "    height: " + (renderHeight as string) + "," + "\r\n"
        cameraInfo += "}," + "\r\n"
        cameraInfo += "fieldOfView: " + (vfov as string) + "," + "\r\n"
        cameraInfo += "}" + "\r\n"

        rollout textBoxRollout "Text Box"(
            label fovLabel "FOV" align:#left
            dotnetcontrol saveText "TextBox" width:400 height:250 align:#center
            on textBoxRollout open do (
                saveText.MultiLine = true
                saveText.WordWrap = false
                saveText.ScrollBars = (dotNetClass "ScrollBars").Both
                saveText.text = (cameraInfo as string)
            )
            
        )
        createDialog textBoxRollout 400 250
)
rollout CameraInfoExporter "Camera Info Exporter" ( 

    button btnChunkToolImport "Convert Camera Info" width:200 height:50 
    on btnChunkToolImport pressed do ( 
        

        If ($.targeted == true) then (
            $.targeted = false
            CamExporter()
            $.targeted = true
        ) else (
            CamExporter()
        )
        

    )
)
createDialog CameraInfoExporter 210 70
