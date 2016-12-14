(
--3ds max uses hFov
--Unity uses vFov
height = 540
width = 960
fov = 27

vfovRad = degToRad fov
hfovrad = 2 * atan (tan (vfovRad/2) * width/height)

hfov = radToDeg hfovrad
hfov = ceil hfov

print "hfov = " + (hfov as string)

)