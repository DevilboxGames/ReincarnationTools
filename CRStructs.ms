
struct CRSettings (GamePath, TexturePath, GibbedTools, LOLDecoder, MaxResolution,MaxResolutionID)

struct AdjacentTriangle (ref, tri)
struct AdjacentEdge (refa, refb, face)
struct mbbox (vmin, vmax, center, halfdist)
struct mdlFace (matID, flags, v1, v2, v3)
struct mdlMesh (verts, faces, stripOffset, stripVertCount, StripList, patchOffset, patchVertCount, PatchList, BBox)
struct mdlVert (pos, norm, tex, tex2, colour)
struct mdlPrepFace (matID, flags, v1, v2, v3)
struct mdlPrepVert (Position, Normal, UV1, UV2, Colour)
struct mdlPrepMesh (verts, faces, stripOffset, stripVertCount, StripList, patchOffset, patchVertCount, PatchList, BBox)
struct mdlUserFace (PlaneD, PlaneX, PlaneY, PlaneZ, v1NormX, v1NormY, v1NormZ, v2NormX, v2NormY, v2NormZ, v3NormX, v3NormY, v3NormZ, MaterialIndex, SmoothingGroup, v1, v2, v3, v1Colour, v2Colour, v3Colour, v1U, v1V, v1U2, v1V2, v2U, v2V, v2U2, v2V2, v3U, v3V, v3U2, v3V2, FaceFlags, AppSpecificFlags)
struct mdlUserVert (x,y,z,TimesUsed, normX, normY, normZ)
struct MDLMatGroup (matID, triStrip, triStripVertOffset,patchList, patchListVertOffset, numTriangles)



struct LITGnode (lightType, lightBounds, objectNameLength, objectName)
struct EMT2node (bytes)
struct MODLnode (objectNameLength, objectName)
struct SKINnode (objectNameLength, objectName)
struct VFXInode (objectNameLength, objectName)
struct NewCNTNode (nameLength, nodeName, isA12CNT, unknownFloat, parentNode, transformMatrix, position, combinedMatrix, absolutePosition,  nodeType, nodeData, numChildren, children)
