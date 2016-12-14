try(destroyDialog ::ChunkTool) catch()
global multiplier = 100
global missingModelsTxt = ""
--For use in scaleMatrix
global x = [-1, 1, 1]
global y = [1, -1, 1]
global z = [1, 1, -1]


--Function to Convert a string of type "[a, b, c]" to a true point3 value, where a, b, c are integers
fn StringtoPoint3Converter PointString = (


    Elements = filterstring PointString "[,]" 


    XElement = (Elements[1] as float) * multiplier
    YElement = (Elements[2] as float) * multiplier
    ZElement = (Elements[3] as float) * multiplier


    -- Swap Y and Z
    NewPoint3 = [XElement, YElement, ZElement]
    return NewPoint3
)



fn StringtoQuat QuatString = (


    Elements = filterstring QuatString "[,]" 


    XElement = (Elements[1] as float)
    YElement = (Elements[2] as float)
    ZElement = (Elements[3] as float)
    WElement = (Elements[4] as float)


    NewQuat = quat XElement YElement ZElement WElement
    return NewQuat
)


rollout ChunkTool "ChunkTool Importer"( 


local importPathRoot = ""

edittext edt_A "MaxFile folder path" text:"Paste path here"
on edt_A entered text do (
importPathRoot = text
)


button btnChunkToolRun "Run" width: 200 height: 50 
    on btnChunkToolRun pressed do (
try(destroyDialog ::textBoxRollout) catch()
try(delete $SceneGroup) catch()






local oldDisplayType = units.DisplayType
local oldType = units.USType
local oldSystemType = units.SystemType



-- Set display units
units.DisplayType = #metric
units.MetricType = #meters 
-- Set system units
units.SystemType = #centimeters






local modelArray = #()
propHash = dotNetObject "System.Collections.Hashtable" 
propHash.Add "name" "Nate_Berkus_Gold_Gem_Decorative_Box"
propHash.Add "position" "-1.442276,0.4660283,-1.276902"
propHash.Add "rotation" "-0.1299875,0.645427,0.7379094,0.1483812"
append modelArray propHash 


propHash = dotNetObject "System.Collections.Hashtable" 
propHash.Add "name" "Nate_Berkus_Gold_Gem_Decorative_Box"
propHash.Add "position" "-1.196852,0.4709536,-1.209315"
propHash.Add "rotation" "0.2045881,0.62628,0.7111464,-0.2453324"
append modelArray propHash 



propHash = dotNetObject "System.Collections.Hashtable" 
propHash.Add "name" "Nate_Berkus_Gold_Gem_Decorative_Box"
propHash.Add "position" "-0.92726,0.4792817,-1.294357"
propHash.Add "rotation" "0.03641981,0.6831889,0.7287365,-0.02949299"
append modelArray propHash 


propHash = dotNetObject "System.Collections.Hashtable" 
propHash.Add "name" "Bird-Shaped_Wood_Slice"
propHash.Add "position" "-1.185296,0.5612186,-1.192117"
propHash.Add "rotation" "-0.2472874,0.4951787,0.6655298,0.5007165"
append modelArray propHash 


propHash = dotNetObject "System.Collections.Hashtable" 
propHash.Add "name" "Bird-Shaped_Wood_Slice"
propHash.Add "position" "-1.425331,0.5676512,-1.267461"
propHash.Add "rotation" "0.04245396,0.6243464,0.7203602,0.299116"
append modelArray propHash 


propHash = dotNetObject "System.Collections.Hashtable" 
propHash.Add "name" "Bird-Shaped_Wood_Slice"
propHash.Add "position" "-0.917417,0.5761924,-1.277136"
propHash.Add "rotation" "-0.6650567,0.3253594,0.1799471,0.6476573"
append modelArray propHash 


propHash = dotNetObject "System.Collections.Hashtable" 
propHash.Add "name" "RE_C1_CB_WhiteVase"
propHash.Add "position" "-1.050058,0.4682658,-1.200765"
propHash.Add "rotation" "-0.0005115686,0.6393616,0.7688115,-0.01206744"
append modelArray propHash 
        for i = 1 to modelArray.count do ( 


            modelHashEnum = modelArray[i]


            importPath = importPathRoot + "\\" + (modelHashEnum.Item["name"] as string) + "\\" + (modelHashEnum.Item["name"] as string) + ".max" 
local checkFile = doesFileExist importPath
if(checkFile == false) then (
missingModelsTxt += ("MISSING:  " + importPath + "\r\n")
)
            mergeMAXFile importPath #noRedraw #mergeDups #useMergedMtlDups #select quiet:true
            selection.name = (modelHashEnum.Item["name"] as string)




            for obj in selection where (isGroupHead obj) or (isGroupMember obj == false) do (


                newQuat = StringtoQuat(modelHashEnum.Item["rotation"])
                obj.rotation = newQuat
                obj.pos = StringtoPoint3Converter(modelHashEnum.Item["position"])
                obj.transform *= (matrix3 [-1,0,0] [0,1,0] [0,0,1] [0,0,0])


                -- Mirror scale across the X axis
                axisReflectTransform = scalematrix x
                obj.transform = axisReflectTransform * obj.transform
            )


        )



if(not (missingModelsTxt == "")) then (
rollout textBoxRollout "Text Box"(
dotnetcontrol saveText "TextBox" width:400 height:200 align:#center
on textBoxRollout open do (
saveText.MultiLine = true
saveText.WordWrap = false
saveText.ScrollBars = (dotNetClass "ScrollBars").Both
saveText.text = (missingModelsTxt as string)
)
        
)
createDialog textBoxRollout 400 200
)



        -- Rotate objects 90 degrees so they're upright
        select $*
        if (selection.count > 0) then(
        group selection name:"SceneGroup" select:true
        $SceneGroup.pivot = [0,0,0]
        rotate $SceneGroup (angleaxis 90 [1,0,0])
        --ungroup $SceneGroup
        missingModelsTxt = ""


    )



-- Revert display units
units.DisplayType = oldDisplayType
if (oldDisplayType == "#metric") then (
units.MetricType = oldType
) else if(oldDisplayType == "us") then (
units.USType = oldType
)
-- Revert system units
units.SystemType = oldSystemType



) 
) 
createDialog ChunkTool 250 100
