(
--3ds max uses hFov
--Unity uses vFov
height = 540
width = 960
fov = 48

hfovRad = degToRad fov
vfovRad = 2 * atan (tan (hfovRad/2) * height/width)

vfov = radToDeg vfovRad
vfov = ceil vfov

print "vfov = " + (vfov as string)
)